from io import BytesIO
from datetime import datetime
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm
from reportlab.platypus import (
    SimpleDocTemplate,
    Table,
    TableStyle,
    Paragraph,
    Spacer,
    HRFlowable,
    PageBreak,
    KeepInFrame,
)
from reportlab.lib.enums import TA_CENTER, TA_LEFT

# All color fills removed — black text on white background throughout.
HEADER_BG = colors.HexColor("#1e3a5f")  # kept only for HR line and text accents
BORDER_CLR = colors.HexColor("#888888")
SIG_LINE = colors.HexColor("#555555")


def _build_column_slots(config):
    """Build ordered list of column descriptors (period|break|lunch)."""
    start_time = config["start_time"]
    period_minutes = config["period_minutes"]
    periods_per_day = config["periods_per_day"]
    lunch_after = config["lunch_after_period"]
    lunch_minutes = config.get("lunch_minutes", 40)
    short_break_after = config.get("short_break_after_period")
    short_break_minutes = config.get("short_break_minutes", 10) or 10

    h, m = map(int, start_time.split(":"))
    cur = h * 60 + m

    def fmt(t):
        return "{:02d}:{:02d}".format((t // 60) % 24, t % 60)

    cols = []
    tidx = 0
    # short_breaks new-style: list of {after_period: N (0-based), duration: M}
    short_breaks_list = config.get("short_breaks", [])
    break_map = {}
    for b in short_breaks_list:
        ap = b.get("after_period")
        dur = b.get("duration", 10)
        if ap is not None:
            break_map[int(ap)] = int(dur)
    # Legacy single break fallback
    if not break_map and short_break_after is not None:
        break_map[short_break_after] = short_break_minutes

    for p in range(periods_per_day):
        s, e = cur, cur + period_minutes
        cols.append(
            {
                "kind": "period",
                "period_idx": tidx,
                "title": "{}\n{}".format(fmt(s), fmt(e)),
            }
        )
        cur += period_minutes
        tidx += 1

        if p in break_map:
            bDur = break_map[p]
            bs, be = cur, cur + bDur
            cols.append(
                {
                    "kind": "break",
                    "title": "SHORT\nBREAK\n{}-{}".format(fmt(bs), fmt(be)),
                }
            )
            cur += bDur

        if lunch_after is not None and p == lunch_after:
            ls, le = cur, cur + lunch_minutes
            cols.append(
                {
                    "kind": "lunch",
                    "title": "LUNCH\nBREAK\n{}-{}".format(fmt(ls), fmt(le)),
                }
            )
            cur += lunch_minutes

    return cols


def _ps(name, **kw):
    base = getSampleStyleSheet()["Normal"]
    return ParagraphStyle(name, parent=base, **kw)


DAYS_SHORT = ["MON", "TUE", "WED", "THU", "FRI", "SAT"]


def _section_story(config, solution, section, metadata, col_slots=None):
    """Return list of Flowables for one section timetable page."""
    story = []
    working_days = config["working_days"]
    periods_per_day = config["periods_per_day"]

    if col_slots is None:
        col_slots = _build_column_slots(config)

    title_st = _ps(
        "ts",
        fontSize=16,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        spaceAfter=2,
    )
    sub_st = _ps(
        "ss",
        fontSize=11,
        fontName="Helvetica",
        textColor=colors.black,
        alignment=TA_CENTER,
        spaceAfter=4,
    )
    hdr_day = _ps(
        "hd",
        fontSize=11,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        leading=13,
    )
    hdr_time = _ps(
        "ht",
        fontSize=9,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        leading=11,
    )
    cell_norm = _ps(
        "cn", fontSize=10, alignment=TA_CENTER, leading=12, textColor=colors.black
    )
    cell_it = _ps(
        "ci",
        fontSize=10,
        fontName="Helvetica-Oblique",
        alignment=TA_CENTER,
        leading=12,
        textColor=colors.black,
    )
    cell_bold = _ps(
        "cb",
        fontSize=10,
        fontName="Helvetica-Bold",
        alignment=TA_CENTER,
        leading=12,
        textColor=colors.black,
    )
    cell_brk = _ps(
        "cbr",
        fontSize=9,
        fontName="Helvetica-Bold",
        alignment=TA_CENTER,
        leading=10,
        textColor=colors.black,
    )
    leg_hdr_st = _ps(
        "lhdr",
        fontSize=12,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_LEFT,
        spaceBefore=4,
        spaceAfter=4,
    )
    sig_bold = _ps(
        "sgb",
        fontSize=11,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
    )
    footer_st = _ps(
        "ft", fontSize=8, textColor=colors.grey, alignment=TA_CENTER, spaceBefore=6
    )

    # ---- Header ----
    story.append(Paragraph(metadata["college_name"], title_st))
    yr = metadata.get("year", "")
    br = metadata.get("branch", "")
    sem = metadata.get("semester", "")
    rm = metadata.get("room", "__________")
    story.append(
        Paragraph(
            "Class: {} {} {} Sem \u2013 {} Section"
            "&nbsp;&nbsp;&nbsp;&nbsp;Room Number: {}".format(yr, br, sem, section, rm),
            sub_st,
        )
    )
    story.append(
        HRFlowable(width="100%", thickness=1.5, color=colors.black, spaceAfter=6)
    )

    # ---- Build grid ----
    header_row = [Paragraph("DAY/TIME", hdr_day)]
    for cs in col_slots:
        if cs["kind"] == "period":
            header_row.append(Paragraph(cs["title"], hdr_time))
        else:
            header_row.append(Paragraph(cs["title"], cell_brk))

    table_data = [header_row]
    for d in range(working_days):
        row = [Paragraph(DAYS_SHORT[d], hdr_day)]
        for cs in col_slots:
            if cs["kind"] in ("break", "lunch"):
                row.append(Paragraph("", cell_norm))
                continue
            p = cs["period_idx"]
            si = solution.get((d, p))
            if si is None:
                row.append(Paragraph("", cell_norm))
            elif si.get("is_lab_cont"):
                row.append(Paragraph("(cont.)", cell_it))
            else:
                stype = si.get("type", "theory")
                sname = si.get("subject_name", "")
                txt = "LAB\n({})".format(sname) if stype == "lab" else sname
                row.append(Paragraph(txt, cell_bold))
        table_data.append(row)

    # ---- Column widths ----
    page_w = landscape(A4)[0] - 3 * cm
    day_col_w = 1.5 * cm
    break_col_w = 1.4 * cm
    lunch_col_w = 1.8 * cm
    n_break = sum(1 for cs in col_slots if cs["kind"] == "break")
    n_lunch = sum(1 for cs in col_slots if cs["kind"] == "lunch")
    n_period = sum(1 for cs in col_slots if cs["kind"] == "period")
    remain = page_w - day_col_w - n_break * break_col_w - n_lunch * lunch_col_w
    per_w = remain / max(n_period, 1)

    col_widths = [day_col_w]
    for cs in col_slots:
        if cs["kind"] == "period":
            col_widths.append(per_w)
        elif cs["kind"] == "break":
            col_widths.append(break_col_w)
        else:
            col_widths.append(lunch_col_w)

    tbl = Table(table_data, colWidths=col_widths, repeatRows=1)

    cmds = [
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTNAME", (0, 1), (0, -1), "Helvetica-Bold"),
        ("ALIGN", (0, 0), (-1, -1), "CENTER"),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("GRID", (0, 0), (-1, -1), 0.5, BORDER_CLR),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
        ("LEFTPADDING", (0, 0), (-1, -1), 3),
        ("RIGHTPADDING", (0, 0), (-1, -1), 3),
        ("FONTSIZE", (0, 0), (-1, -1), 10),
        ("TEXTCOLOR", (0, 0), (-1, -1), colors.black),
        # Slightly thicker outer border
        ("BOX", (0, 0), (-1, -1), 1.0, colors.black),
    ]

    tbl.setStyle(TableStyle(cmds))
    story.append(tbl)
    story.append(Spacer(1, 0.4 * cm))

    # ---- Legend ----
    story.append(Paragraph("Subject Details", leg_hdr_st))

    def lps(nm, **kw):
        return _ps(nm, fontSize=10, **kw)

    leg_hrow = [
        Paragraph(
            "S.No",
            lps(
                "lh1",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Subject Code",
            lps(
                "lh2",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Name of Subject",
            lps(
                "lh3",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Name of Faculty",
            lps(
                "lh4",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
    ]
    legend_rows = [leg_hrow]
    seen = {}
    sno = 1
    for p in range(periods_per_day):
        for d in range(working_days):
            si = solution.get((d, p))
            if si and not si.get("is_lab_cont"):
                code = si["subject_code"]
                if code not in seen:
                    seen[code] = True
                    fac = si["faculty_1"]
                    f2 = si.get("faculty_2", "")
                    if f2 and str(f2).lower() not in ("nan", "none", ""):
                        fac += ", {}".format(f2)
                    legend_rows.append(
                        [
                            Paragraph(str(sno), lps("lc1", alignment=TA_CENTER)),
                            Paragraph(code, lps("lc2", alignment=TA_CENTER)),
                            Paragraph(
                                si["subject_name"], lps("lc3", alignment=TA_LEFT)
                            ),
                            Paragraph(fac, lps("lc4", alignment=TA_LEFT)),
                        ]
                    )
                    sno += 1

    leg_total = landscape(A4)[0] - 3 * cm
    lcw = [0.9 * cm, 3.2 * cm, 9.0 * cm, leg_total - 0.9 * cm - 3.2 * cm - 9.0 * cm]
    ltbl = Table(legend_rows, colWidths=lcw, repeatRows=1)
    ltbl.setStyle(
        TableStyle(
            [
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 10),
                ("TEXTCOLOR", (0, 0), (-1, -1), colors.black),
                ("ALIGN", (0, 0), (-1, -1), "LEFT"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("GRID", (0, 0), (-1, -1), 0.5, BORDER_CLR),
                ("BOX", (0, 0), (-1, -1), 1.0, colors.black),
                ("TOPPADDING", (0, 0), (-1, -1), 3),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
                ("LEFTPADDING", (0, 0), (-1, -1), 3),
            ]
        )
    )
    story.append(ltbl)
    story.append(Spacer(1, 0.5 * cm))

    # ---- Signatures ----
    sig_data = [
        [
            Paragraph("Class Teacher", sig_bold),
            Paragraph("Head of the Department", sig_bold),
            Paragraph("Principal", sig_bold),
        ]
    ]
    stbl = Table(sig_data, colWidths=[leg_total / 3] * 3)
    stbl.setStyle(
        TableStyle(
            [
                ("ALIGN", (0, 0), (-1, -1), "CENTER"),
                ("VALIGN", (0, 0), (-1, -1), "BOTTOM"),
                ("TOPPADDING", (0, 0), (-1, -1), 20),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
                ("LINEABOVE", (0, 0), (0, 0), 0.8, SIG_LINE),
                ("LINEABOVE", (1, 0), (1, 0), 0.8, SIG_LINE),
                ("LINEABOVE", (2, 0), (2, 0), 0.8, SIG_LINE),
            ]
        )
    )
    story.append(stbl)
    story.append(Spacer(1, 0.2 * cm))
    story.append(
        Paragraph(
            "Generated on {}".format(datetime.now().strftime("%d %b %Y, %I:%M %p")),
            footer_st,
        )
    )
    return story


def generate_timetable_pdf(config, solution, section, metadata):
    """Generate PDF for one section. Returns BytesIO."""
    buf = BytesIO()
    doc = SimpleDocTemplate(
        buf,
        pagesize=landscape(A4),
        rightMargin=1.5 * cm,
        leftMargin=1.5 * cm,
        topMargin=1.5 * cm,
        bottomMargin=1.5 * cm,
    )
    col_slots = _build_column_slots(config)
    inner = _section_story(config, solution, section, metadata, col_slots)
    pw, ph = landscape(A4)
    usable_w = pw - 3 * cm
    usable_h = ph - 3 * cm
    story = [KeepInFrame(usable_w, usable_h, inner, mode="shrink")]
    doc.build(story)
    buf.seek(0)
    return buf


def generate_all_timetables_pdf(config, full_solution, groups, college_name):
    """Generate combined PDF, one page per section. Returns BytesIO."""
    buf = BytesIO()
    doc = SimpleDocTemplate(
        buf,
        pagesize=landscape(A4),
        rightMargin=1.5 * cm,
        leftMargin=1.5 * cm,
        topMargin=1.5 * cm,
        bottomMargin=1.5 * cm,
    )
    col_slots = _build_column_slots(config)
    sec_to_group = {}
    for g in groups:
        for sec in g.get("sections", []):
            sec_to_group[sec] = g

    story = []
    sections = sorted(full_solution.keys())
    for idx, section in enumerate(sections):
        solution = full_solution[section]
        g = sec_to_group.get(section, {})
        metadata = {
            "college_name": college_name,
            "branch": g.get("branch", ""),
            "year": g.get("year", ""),
            "semester": g.get("semester", ""),
        }
        if idx > 0:
            story.append(PageBreak())
        # Extract the section letter from the scoped key (e.g. "CSE_2_1_A" -> "A")
        sec_parts = section.rsplit("_", 1)
        sec_letter = sec_parts[-1] if len(sec_parts) == 2 else section
        inner = _section_story(config, solution, sec_letter, metadata, col_slots)
        pw, ph = landscape(A4)
        usable_w = pw - 3 * cm
        usable_h = ph - 3 * cm
        story.append(KeepInFrame(usable_w, usable_h, inner, mode="shrink"))

    doc.build(story)
    buf.seek(0)
    return buf


def generate_faculty_timetable_pdf(
    config, faculty_solution, faculty_name, college_name
):
    """
    Generate a personal timetable PDF for a single faculty member.
    Returns BytesIO.
    """
    buf = BytesIO()
    doc = SimpleDocTemplate(
        buf,
        pagesize=landscape(A4),
        rightMargin=1.5 * cm,
        leftMargin=1.5 * cm,
        topMargin=1.5 * cm,
        bottomMargin=1.5 * cm,
    )
    col_slots = _build_column_slots(config)
    working_days = config["working_days"]
    story = []

    title_st = _ps(
        "fts",
        fontSize=16,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        spaceAfter=2,
    )
    sub_st = _ps(
        "fss",
        fontSize=11,
        fontName="Helvetica",
        textColor=colors.black,
        alignment=TA_CENTER,
        spaceAfter=4,
    )
    hdr_day = _ps(
        "fhd",
        fontSize=11,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        leading=13,
    )
    hdr_time = _ps(
        "fht",
        fontSize=9,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        leading=11,
    )
    cell_n = _ps(
        "fcn", fontSize=10, alignment=TA_CENTER, leading=12, textColor=colors.black
    )
    cell_it = _ps(
        "fci",
        fontSize=10,
        fontName="Helvetica-Oblique",
        alignment=TA_CENTER,
        leading=12,
        textColor=colors.black,
    )
    cell_b = _ps(
        "fcb",
        fontSize=10,
        fontName="Helvetica-Bold",
        alignment=TA_CENTER,
        leading=12,
        textColor=colors.black,
    )
    cell_brk = _ps(
        "fcbr",
        fontSize=9,
        fontName="Helvetica-Bold",
        alignment=TA_CENTER,
        leading=10,
        textColor=colors.black,
    )
    footer_st = _ps(
        "fft", fontSize=8, textColor=colors.grey, alignment=TA_CENTER, spaceBefore=6
    )

    story.append(Paragraph(college_name, title_st))
    story.append(
        Paragraph("Faculty Timetable — <b>{}</b>".format(faculty_name), sub_st)
    )
    story.append(
        HRFlowable(width="100%", thickness=1.5, color=colors.black, spaceAfter=6)
    )

    header_row = [Paragraph("DAY/TIME", hdr_day)]
    for cs in col_slots:
        if cs["kind"] == "period":
            header_row.append(Paragraph(cs["title"], hdr_time))
        else:
            header_row.append(Paragraph(cs["title"], cell_brk))

    table_data = [header_row]
    for d in range(working_days):
        row = [Paragraph(DAYS_SHORT[d], hdr_day)]
        for cs in col_slots:
            if cs["kind"] in ("break", "lunch"):
                row.append(Paragraph("", cell_n))
                continue
            p = cs["period_idx"]
            si = faculty_solution.get((d, p))
            if si is None:
                row.append(Paragraph("", cell_n))
            elif si.get("is_lab_cont"):
                row.append(Paragraph("(cont.)", cell_it))
            else:
                stype = si.get("type", "theory")
                sec = si.get("section", "")
                sname = si.get("subject_name", "")
                scode = si.get("subject_code", "")
                txt = (
                    "LAB\n{}\n(Sec {})".format(scode, sec)
                    if stype == "lab"
                    else "{}\n(Sec {})".format(sname, sec)
                )
                row.append(Paragraph(txt, cell_b))
        table_data.append(row)

    page_w = landscape(A4)[0] - 3 * cm
    day_col_w = 1.5 * cm
    break_col_w = 1.4 * cm
    lunch_col_w = 1.8 * cm
    n_break = sum(1 for cs in col_slots if cs["kind"] == "break")
    n_lunch = sum(1 for cs in col_slots if cs["kind"] == "lunch")
    n_period = sum(1 for cs in col_slots if cs["kind"] == "period")
    remain = page_w - day_col_w - n_break * break_col_w - n_lunch * lunch_col_w
    per_w = remain / max(n_period, 1)

    col_widths = [day_col_w]
    for cs in col_slots:
        if cs["kind"] == "period":
            col_widths.append(per_w)
        elif cs["kind"] == "break":
            col_widths.append(break_col_w)
        else:
            col_widths.append(lunch_col_w)

    tbl = Table(table_data, colWidths=col_widths, repeatRows=1)
    cmds = [
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTNAME", (0, 1), (0, -1), "Helvetica-Bold"),
        ("ALIGN", (0, 0), (-1, -1), "CENTER"),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("GRID", (0, 0), (-1, -1), 0.5, BORDER_CLR),
        ("BOX", (0, 0), (-1, -1), 1.0, colors.black),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
        ("LEFTPADDING", (0, 0), (-1, -1), 3),
        ("RIGHTPADDING", (0, 0), (-1, -1), 3),
        ("FONTSIZE", (0, 0), (-1, -1), 10),
        ("TEXTCOLOR", (0, 0), (-1, -1), colors.black),
    ]
    tbl.setStyle(TableStyle(cmds))
    story.append(tbl)
    story.append(Spacer(1, 0.4 * cm))

    # Summary table
    leg_hdr_st = _ps(
        "flhdr",
        fontSize=12,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_LEFT,
        spaceBefore=4,
        spaceAfter=4,
    )
    sig_bold = _ps(
        "fsgb",
        fontSize=11,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
    )
    story.append(Paragraph("Teaching Load Summary", leg_hdr_st))

    def lps(nm, **kw):
        return _ps(nm, fontSize=10, **kw)

    leg_hrow = [
        Paragraph(
            "S.No",
            lps(
                "flh1",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Section",
            lps(
                "flh2",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Subject Code",
            lps(
                "flh3",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Subject Name",
            lps(
                "flh4",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Type",
            lps(
                "flh5",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Periods/Week",
            lps(
                "flh6",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
    ]
    legend_rows = [leg_hrow]
    seen = {}
    sno = 1
    for (d, p), si in sorted(faculty_solution.items()):
        if si.get("is_lab_cont"):
            continue
        key = (si.get("section", ""), si.get("subject_code", ""))
        if key not in seen:
            seen[key] = 0
        seen[key] += 1

    for (sec, code), count in sorted(seen.items()):
        info = next(
            (
                v
                for v in faculty_solution.values()
                if v.get("section") == sec
                and v.get("subject_code") == code
                and not v.get("is_lab_cont")
            ),
            {},
        )
        legend_rows.append(
            [
                Paragraph(str(sno), lps("flc1", alignment=TA_CENTER)),
                Paragraph(sec, lps("flc2", alignment=TA_CENTER)),
                Paragraph(code, lps("flc3", alignment=TA_CENTER)),
                Paragraph(info.get("subject_name", ""), lps("flc4", alignment=TA_LEFT)),
                Paragraph(info.get("type", ""), lps("flc5", alignment=TA_CENTER)),
                Paragraph(str(count), lps("flc6", alignment=TA_CENTER)),
            ]
        )
        sno += 1

    leg_total = landscape(A4)[0] - 3 * cm
    lcw = [
        0.9 * cm,
        2.0 * cm,
        3.2 * cm,
        leg_total - 0.9 * cm - 2.0 * cm - 3.2 * cm - 2.0 * cm - 2.5 * cm,
        2.0 * cm,
        2.5 * cm,
    ]
    ltbl = Table(legend_rows, colWidths=lcw, repeatRows=1)
    ltbl.setStyle(
        TableStyle(
            [
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 10),
                ("TEXTCOLOR", (0, 0), (-1, -1), colors.black),
                ("ALIGN", (0, 0), (-1, -1), "LEFT"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("GRID", (0, 0), (-1, -1), 0.5, BORDER_CLR),
                ("BOX", (0, 0), (-1, -1), 1.0, colors.black),
                ("TOPPADDING", (0, 0), (-1, -1), 3),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
                ("LEFTPADDING", (0, 0), (-1, -1), 3),
            ]
        )
    )
    story.append(ltbl)
    story.append(Spacer(1, 0.5 * cm))

    sig_data = [
        [
            Paragraph("Faculty", sig_bold),
            Paragraph("Head of the Department", sig_bold),
            Paragraph("Principal", sig_bold),
        ]
    ]
    stbl = Table(sig_data, colWidths=[leg_total / 3] * 3)
    stbl.setStyle(
        TableStyle(
            [
                ("ALIGN", (0, 0), (-1, -1), "CENTER"),
                ("VALIGN", (0, 0), (-1, -1), "BOTTOM"),
                ("TOPPADDING", (0, 0), (-1, -1), 20),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
                ("LINEABOVE", (0, 0), (0, 0), 0.8, SIG_LINE),
                ("LINEABOVE", (1, 0), (1, 0), 0.8, SIG_LINE),
                ("LINEABOVE", (2, 0), (2, 0), 0.8, SIG_LINE),
            ]
        )
    )
    story.append(stbl)
    story.append(Spacer(1, 0.2 * cm))
    story.append(
        Paragraph(
            "Generated on {}".format(datetime.now().strftime("%d %b %Y, %I:%M %p")),
            footer_st,
        )
    )

    doc.build(story)
    buf.seek(0)
    return buf


def generate_all_faculty_timetables_pdf(config, full_faculty_solution, college_name):
    """
    Generate a combined PDF with one page per faculty member.
    Returns BytesIO.
    """
    buf = BytesIO()
    doc = SimpleDocTemplate(
        buf,
        pagesize=landscape(A4),
        rightMargin=1.5 * cm,
        leftMargin=1.5 * cm,
        topMargin=1.5 * cm,
        bottomMargin=1.5 * cm,
    )
    col_slots = _build_column_slots(config)
    story = []
    for idx, (faculty_name, fac_sol) in enumerate(
        sorted(full_faculty_solution.items())
    ):
        if idx > 0:
            story.append(PageBreak())
        story.extend(
            _faculty_page_story(config, fac_sol, faculty_name, college_name, col_slots)
        )
    doc.build(story)
    buf.seek(0)
    return buf


def _faculty_page_story(
    config, faculty_solution, faculty_name, college_name, col_slots=None
):
    """Return list of Flowables for one faculty timetable page (no PageBreak prepended)."""
    if col_slots is None:
        col_slots = _build_column_slots(config)

    working_days = config["working_days"]

    title_st = _ps(
        "fps_t",
        fontSize=16,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        spaceAfter=2,
    )
    sub_st = _ps(
        "fps_s",
        fontSize=11,
        fontName="Helvetica",
        textColor=colors.black,
        alignment=TA_CENTER,
        spaceAfter=4,
    )
    hdr_day = _ps(
        "fps_hd",
        fontSize=11,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        leading=13,
    )
    hdr_time = _ps(
        "fps_ht",
        fontSize=9,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
        leading=11,
    )
    cell_n = _ps(
        "fps_cn", fontSize=10, alignment=TA_CENTER, leading=12, textColor=colors.black
    )
    cell_it = _ps(
        "fps_ci",
        fontSize=10,
        fontName="Helvetica-Oblique",
        alignment=TA_CENTER,
        leading=12,
        textColor=colors.black,
    )
    cell_b = _ps(
        "fps_cb",
        fontSize=10,
        fontName="Helvetica-Bold",
        alignment=TA_CENTER,
        leading=12,
        textColor=colors.black,
    )
    cell_brk = _ps(
        "fps_cbr",
        fontSize=9,
        fontName="Helvetica-Bold",
        alignment=TA_CENTER,
        leading=10,
        textColor=colors.black,
    )
    footer_st = _ps(
        "fps_ft", fontSize=8, textColor=colors.grey, alignment=TA_CENTER, spaceBefore=6
    )
    leg_hdr_st = _ps(
        "fps_lhdr",
        fontSize=12,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_LEFT,
        spaceBefore=4,
        spaceAfter=4,
    )
    sig_bold = _ps(
        "fps_sgb",
        fontSize=11,
        fontName="Helvetica-Bold",
        textColor=colors.black,
        alignment=TA_CENTER,
    )

    story = []
    story.append(Paragraph(college_name, title_st))
    story.append(
        Paragraph("Faculty Timetable \u2014 <b>{}</b>".format(faculty_name), sub_st)
    )
    story.append(
        HRFlowable(width="100%", thickness=1.5, color=colors.black, spaceAfter=6)
    )

    header_row = [Paragraph("DAY/TIME", hdr_day)]
    for cs in col_slots:
        header_row.append(
            Paragraph(cs["title"], hdr_time if cs["kind"] == "period" else cell_brk)
        )

    table_data = [header_row]
    for d in range(working_days):
        row = [Paragraph(DAYS_SHORT[d], hdr_day)]
        for cs in col_slots:
            if cs["kind"] in ("break", "lunch"):
                row.append(Paragraph("", cell_n))
                continue
            p = cs["period_idx"]
            si = faculty_solution.get((d, p))
            if si is None:
                row.append(Paragraph("", cell_n))
            elif si.get("is_lab_cont"):
                row.append(Paragraph("(cont.)", cell_it))
            else:
                stype = si.get("type", "theory")
                sec = si.get("section", "")
                sname = si.get("subject_name", "")
                scode = si.get("subject_code", "")
                txt = (
                    "LAB\n{}\n(Sec {})".format(scode, sec)
                    if stype == "lab"
                    else "{}\n(Sec {})".format(sname, sec)
                )
                row.append(Paragraph(txt, cell_b))
        table_data.append(row)

    page_w = landscape(A4)[0] - 3 * cm
    day_col_w = 1.5 * cm
    break_col_w = 1.4 * cm
    lunch_col_w = 1.8 * cm
    n_break = sum(1 for cs in col_slots if cs["kind"] == "break")
    n_lunch = sum(1 for cs in col_slots if cs["kind"] == "lunch")
    n_period = sum(1 for cs in col_slots if cs["kind"] == "period")
    remain = page_w - day_col_w - n_break * break_col_w - n_lunch * lunch_col_w
    per_w = remain / max(n_period, 1)
    col_widths = [day_col_w] + [
        per_w
        if cs["kind"] == "period"
        else (break_col_w if cs["kind"] == "break" else lunch_col_w)
        for cs in col_slots
    ]

    tbl = Table(table_data, colWidths=col_widths, repeatRows=1)
    cmds = [
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTNAME", (0, 1), (0, -1), "Helvetica-Bold"),
        ("ALIGN", (0, 0), (-1, -1), "CENTER"),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("GRID", (0, 0), (-1, -1), 0.5, BORDER_CLR),
        ("BOX", (0, 0), (-1, -1), 1.0, colors.black),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
        ("LEFTPADDING", (0, 0), (-1, -1), 3),
        ("RIGHTPADDING", (0, 0), (-1, -1), 3),
        ("FONTSIZE", (0, 0), (-1, -1), 10),
        ("TEXTCOLOR", (0, 0), (-1, -1), colors.black),
    ]
    tbl.setStyle(TableStyle(cmds))
    story.append(tbl)
    story.append(Spacer(1, 0.4 * cm))

    story.append(Paragraph("Teaching Load Summary", leg_hdr_st))

    def lps(nm, **kw):
        return _ps(nm, fontSize=10, **kw)

    leg_hrow = [
        Paragraph(
            "S.No",
            lps(
                "fps_lh1",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Section",
            lps(
                "fps_lh2",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Code",
            lps(
                "fps_lh3",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Subject Name",
            lps(
                "fps_lh4",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Type",
            lps(
                "fps_lh5",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
        Paragraph(
            "Periods",
            lps(
                "fps_lh6",
                fontName="Helvetica-Bold",
                textColor=colors.black,
                alignment=TA_CENTER,
            ),
        ),
    ]
    legend_rows = [leg_hrow]
    seen = {}
    for (d, p), si in sorted(faculty_solution.items()):
        if si.get("is_lab_cont"):
            continue
        key = (si.get("section", ""), si.get("subject_code", ""))
        seen[key] = seen.get(key, {"count": 0, "info": si})
        seen[key]["count"] += 1

    for sno, ((sec, code), val) in enumerate(sorted(seen.items()), start=1):
        info = val["info"]
        legend_rows.append(
            [
                Paragraph(str(sno), lps("fps_lc1", alignment=TA_CENTER)),
                Paragraph(sec, lps("fps_lc2", alignment=TA_CENTER)),
                Paragraph(code, lps("fps_lc3", alignment=TA_CENTER)),
                Paragraph(
                    info.get("subject_name", ""), lps("fps_lc4", alignment=TA_LEFT)
                ),
                Paragraph(info.get("type", ""), lps("fps_lc5", alignment=TA_CENTER)),
                Paragraph(str(val["count"]), lps("fps_lc6", alignment=TA_CENTER)),
            ]
        )

    leg_total = landscape(A4)[0] - 3 * cm
    lcw = [
        0.9 * cm,
        2.0 * cm,
        3.2 * cm,
        leg_total - 0.9 * cm - 2.0 * cm - 3.2 * cm - 2.0 * cm - 2.5 * cm,
        2.0 * cm,
        2.5 * cm,
    ]
    ltbl = Table(legend_rows, colWidths=lcw, repeatRows=1)
    ltbl.setStyle(
        TableStyle(
            [
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 10),
                ("TEXTCOLOR", (0, 0), (-1, -1), colors.black),
                ("ALIGN", (0, 0), (-1, -1), "LEFT"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("GRID", (0, 0), (-1, -1), 0.5, BORDER_CLR),
                ("BOX", (0, 0), (-1, -1), 1.0, colors.black),
                ("TOPPADDING", (0, 0), (-1, -1), 3),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
                ("LEFTPADDING", (0, 0), (-1, -1), 3),
            ]
        )
    )
    story.append(ltbl)
    story.append(Spacer(1, 0.5 * cm))

    sig_data = [
        [
            Paragraph("Faculty", sig_bold),
            Paragraph("Head of the Department", sig_bold),
            Paragraph("Principal", sig_bold),
        ]
    ]
    stbl = Table(sig_data, colWidths=[leg_total / 3] * 3)
    stbl.setStyle(
        TableStyle(
            [
                ("ALIGN", (0, 0), (-1, -1), "CENTER"),
                ("VALIGN", (0, 0), (-1, -1), "BOTTOM"),
                ("TOPPADDING", (0, 0), (-1, -1), 20),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
                ("LINEABOVE", (0, 0), (0, 0), 0.8, SIG_LINE),
                ("LINEABOVE", (1, 0), (1, 0), 0.8, SIG_LINE),
                ("LINEABOVE", (2, 0), (2, 0), 0.8, SIG_LINE),
            ]
        )
    )
    story.append(stbl)
    story.append(Spacer(1, 0.2 * cm))
    story.append(
        Paragraph(
            "Generated on {}".format(datetime.now().strftime("%d %b %Y, %I:%M %p")),
            footer_st,
        )
    )
    return story
