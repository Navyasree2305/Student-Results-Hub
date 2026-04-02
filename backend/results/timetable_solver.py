"""
timetable_solver.py -- OR-Tools CP-SAT based timetable constraint solver.

Input:
  config   -- dict with schedule/lab/section configuration
  subjects -- list of subject dicts parsed from Excel

Output:
  solution -- dict mapping section -> (day, period) -> assigned slot info
              or raises ValueError with a human-readable explanation if
              the problem is over-constrained.
"""

from ortools.sat.python import cp_model
from collections import defaultdict


def build_slot_list(config):
    """
    Returns a list of (day_idx, period_idx) valid teaching slots.
    All periods_per_day slots are teaching slots.
    lunch_after_period and short_break_after_period are boundary markers
    only (used by get_lab_blocks), NOT period indices to exclude.
    """
    days = config["working_days"]
    periods = config["periods_per_day"]
    slots = []
    for d in range(days):
        for p in range(periods):
            slots.append((d, p))
    return slots


def get_lab_blocks(config, lab_len=None):
    """
    Return list of valid contiguous lab blocks: [(day, [p, p+1, ...]), ...]
    Uses lab_len if provided, otherwise config["lab_consecutive_periods"].
    lunch_after_period and short_break_after_period act as boundaries that
    prevent lab blocks from spanning across them, but do NOT remove those
    periods from the teaching pool.
    """
    days = config["working_days"]
    periods = config["periods_per_day"]
    if lab_len is None:
        lab_len = config["lab_consecutive_periods"]

    boundaries = set()
    lunch = config.get("lunch_after_period")
    brk = config.get("short_break_after_period")
    if lunch is not None:
        boundaries.add(lunch)
    if brk is not None:
        boundaries.add(brk)

    blocks = []
    for d in range(days):
        run = []
        for p in range(periods):
            run.append(p)
            if p in boundaries:
                # flush run: find valid lab-length sub-runs
                for i in range(len(run) - lab_len + 1):
                    cand = run[i : i + lab_len]
                    if cand == list(range(cand[0], cand[0] + lab_len)):
                        blocks.append((d, list(cand)))
                run = []
        # flush remaining
        for i in range(len(run) - lab_len + 1):
            cand = run[i : i + lab_len]
            if cand == list(range(cand[0], cand[0] + lab_len)):
                blocks.append((d, list(cand)))
    return blocks


def solve_timetable(config, subjects):
    """
    Main solver entry point.

    config keys (global defaults):
      working_days              int
      periods_per_day           int
      lunch_after_period        int  (boundary marker only, NOT excluded from teaching)
      short_break_after_period  int | None  (boundary marker only)
      lab_consecutive_periods   int  (global default)
      min_faculty_gap           int  (global default, 0 = no gap)
      sections                  list[str]  -- derived from Excel by views.py

    subjects list item keys (from Excel):
      subject_code   str
      subject_name   str
      type           'theory' | 'lab'
      hours_per_week int
      faculty_1      str
      faculty_2      str | ''
      section        str | 'ALL'
      -- per-lab overrides (None = use global default):
      lab_consecutive_periods  int | None
      lab_split_mode           'split' | 'whole' | None
      min_faculty_gap          int | None

    config may also contain:
      custom_constraints  dict | None  (see below)

    custom_constraints keys (all optional):
      no_first_period  list[str]              -- faculty who cannot teach period 0
      no_last_period   list[str]              -- faculty who cannot teach the last period
      avoid_days       dict[str, list[int]]   -- faculty -> days to avoid (0-indexed)
      preferred_days   dict[str, list[int]]   -- faculty -> only these days allowed
      locked_slots     list[{section, day, period, subject_code}]

    Returns:
      { section: { (day, period): { subject_code, subject_name, type,
                                    faculty_1, faculty_2, is_lab_cont,
                                    lab_block_start } } }
    """
    model = cp_model.CpModel()
    sections = config["sections"]
    days = config["working_days"]
    periods = config["periods_per_day"]
    global_min_gap = config.get("min_faculty_gap", 1)
    global_lab_len = config["lab_consecutive_periods"]

    valid_slots = build_slot_list(config)

    # Expand 'ALL' subjects to each section
    expanded = []
    for subj in subjects:
        secs = sections if subj["section"].upper() == "ALL" else [subj["section"]]
        for sec in secs:
            expanded.append({**subj, "section": sec})

    theory_subjects = [(i, s) for i, s in enumerate(expanded) if s["type"] == "theory"]
    lab_subjects = [(i, s) for i, s in enumerate(expanded) if s["type"] == "lab"]

    # Pre-compute per-subject effective values
    def eff_lab_len(subj):
        v = subj.get("lab_consecutive_periods")
        return v if v is not None else global_lab_len

    def eff_min_gap(subj):
        v = subj.get("min_faculty_gap")
        return v if v is not None else global_min_gap

    # Build lab blocks per unique lab_len value needed
    lab_blocks_cache = {}
    for _, subj in lab_subjects:
        ll = eff_lab_len(subj)
        if ll not in lab_blocks_cache:
            lab_blocks_cache[ll] = get_lab_blocks(config, lab_len=ll)

    # ------------------------------------------------------------------
    # Variables
    # ------------------------------------------------------------------
    theory_vars = {}  # (subj_idx, slot_idx) -> BoolVar
    lab_vars = {}  # (subj_idx, block_idx) -> BoolVar

    for i, subj in theory_subjects:
        for j in range(len(valid_slots)):
            theory_vars[(i, j)] = model.NewBoolVar("t_{}_{}".format(i, j))

    for i, subj in lab_subjects:
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        for k in range(len(blocks)):
            lab_vars[(i, k)] = model.NewBoolVar("l_{}_{}".format(i, k))

    # ------------------------------------------------------------------
    # Constraint 1: theory hours per week
    # ------------------------------------------------------------------
    for i, subj in theory_subjects:
        model.Add(
            sum(theory_vars[(i, j)] for j in range(len(valid_slots)))
            == subj["hours_per_week"]
        )

    # ------------------------------------------------------------------
    # Constraint 2: lab sessions per week
    # ------------------------------------------------------------------
    for i, subj in lab_subjects:
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        sessions_per_week = max(1, subj["hours_per_week"] // ll)
        model.Add(
            sum(lab_vars[(i, k)] for k in range(len(blocks))) == sessions_per_week
        )

    # ------------------------------------------------------------------
    # Constraint 3: no two subjects in same section at same slot
    # ------------------------------------------------------------------
    sec_slot_vars = defaultdict(lambda: defaultdict(list))

    for i, subj in theory_subjects:
        for j, slot in enumerate(valid_slots):
            sec_slot_vars[subj["section"]][slot].append(theory_vars[(i, j)])

    for i, subj in lab_subjects:
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        for k, (day, block_periods) in enumerate(blocks):
            for p in block_periods:
                slot = (day, p)
                sec_slot_vars[subj["section"]][slot].append(lab_vars[(i, k)])

    for sec, slot_map in sec_slot_vars.items():
        for slot, var_list in slot_map.items():
            if len(var_list) > 1:
                model.Add(sum(var_list) <= 1)

    # ------------------------------------------------------------------
    # Constraint 3b: at most one lab block per section per day
    # ------------------------------------------------------------------
    # Group lab_vars by (section, day) and enforce sum <= 1
    sec_day_lab_vars = defaultdict(list)
    for i, subj in lab_subjects:
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        for k, (day, block_periods) in enumerate(blocks):
            sec_day_lab_vars[(subj["section"], day)].append(lab_vars[(i, k)])

    for (sec, day), var_list in sec_day_lab_vars.items():
        if len(var_list) > 1:
            model.Add(sum(var_list) <= 1)

    # ------------------------------------------------------------------
    # Constraint 3c: no two lab subjects with the same name (physical lab room)
    # can run at the same (day, period) across different sections/branches/years.
    # Two labs share the same physical room when their subject_name matches
    # (case-insensitive). This prevents e.g. "Machine Lab" being scheduled
    # Monday period 1 for CSE-A and also Monday period 1 for ECE-B.
    # ------------------------------------------------------------------
    lab_room_slot_vars = defaultdict(lambda: defaultdict(list))
    for i, subj in lab_subjects:
        room_key = (subj.get("subject_name") or subj.get("subject_code") or "").strip().lower()
        if not room_key:
            continue
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        for k, (day, block_periods) in enumerate(blocks):
            for p in block_periods:
                lab_room_slot_vars[room_key][(day, p)].append(lab_vars[(i, k)])

    for room_key, slot_map in lab_room_slot_vars.items():
        for slot, var_list in slot_map.items():
            if len(var_list) > 1:
                model.Add(sum(var_list) <= 1)

    # ------------------------------------------------------------------
    # Constraint 4: no faculty clash across sections at same slot.
    # For split labs, BOTH faculty_1 and faculty_2 are fully blocked
    # for the entire block duration (both batches run simultaneously).
    # For whole labs, faculty_1 is blocked (faculty_2 also blocked if set).
    # ------------------------------------------------------------------
    fac_slot_vars = defaultdict(lambda: defaultdict(list))

    def valid_fac(f):
        return bool(f and str(f).strip())

    for i, subj in theory_subjects:
        fac = subj["faculty_1"]
        if valid_fac(fac):
            for j, slot in enumerate(valid_slots):
                fac_slot_vars[fac][slot].append(theory_vars[(i, j)])

    for i, subj in lab_subjects:
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        for k, (day, block_periods) in enumerate(blocks):
            for p in block_periods:
                slot = (day, p)
                f1 = subj.get("faculty_1", "")
                if valid_fac(f1):
                    fac_slot_vars[f1][slot].append(lab_vars[(i, k)])
                f2 = subj.get("faculty_2", "")
                if valid_fac(f2):
                    fac_slot_vars[f2][slot].append(lab_vars[(i, k)])

    for fac, slot_map in fac_slot_vars.items():
        for slot, var_list in slot_map.items():
            if len(var_list) > 1:
                model.Add(sum(var_list) <= 1)

    # ------------------------------------------------------------------
    # Constraint 5: removed.
    # Scheduling the same theory subject more than once on the same day
    # is valid (e.g. two DS lectures on Friday) and necessary when the
    # timetable is close to full capacity.
    # ------------------------------------------------------------------

    # ------------------------------------------------------------------
    # Constraint 6: per-faculty min gap between DIFFERENT subject assignments
    # on the same day.
    # ------------------------------------------------------------------
    if global_min_gap > 0:
        # fac -> day -> list of (period, var, subj_idx, gap)
        fac_day_entries = defaultdict(lambda: defaultdict(list))

        for i, subj in theory_subjects:
            gap = eff_min_gap(subj)
            if gap <= 0:
                continue
            fac = subj["faculty_1"]
            if valid_fac(fac):
                for j, (d, p) in enumerate(valid_slots):
                    fac_day_entries[fac][d].append((p, theory_vars[(i, j)], i, gap))

        for i, subj in lab_subjects:
            gap = eff_min_gap(subj)
            if gap <= 0:
                continue
            ll = eff_lab_len(subj)
            blocks = lab_blocks_cache[ll]
            for k, (day, block_periods) in enumerate(blocks):
                p_start = block_periods[0]
                f1 = subj.get("faculty_1", "")
                if valid_fac(f1):
                    fac_day_entries[f1][day].append((p_start, lab_vars[(i, k)], i, gap))
                f2 = subj.get("faculty_2", "")
                if valid_fac(f2):
                    fac_day_entries[f2][day].append((p_start, lab_vars[(i, k)], i, gap))

        for fac, day_map in fac_day_entries.items():
            for d, entries in day_map.items():
                entries.sort(key=lambda x: x[0])
                for a_idx in range(len(entries)):
                    pa, va, ia, gap_a = entries[a_idx]
                    for b_idx in range(a_idx + 1, len(entries)):
                        pb, vb, ib, gap_b = entries[b_idx]
                        required_gap = max(gap_a, gap_b)
                        if pb - pa <= required_gap:
                            model.Add(va + vb <= 1)
                        else:
                            break

    # ------------------------------------------------------------------
    # Constraint 7: custom constraints
    # ------------------------------------------------------------------
    custom = config.get("custom_constraints") or {}

    no_first = set(custom.get("no_first_period") or [])
    no_last  = set(custom.get("no_last_period")  or [])
    avoid_days_map     = custom.get("avoid_days")     or {}
    preferred_days_map = custom.get("preferred_days") or {}
    locked_slots_list  = custom.get("locked_slots")   or []

    last_period = periods - 1

    # No first / no last period for named faculty
    for i, subj in theory_subjects:
        fac = subj["faculty_1"]
        for j, (d, p) in enumerate(valid_slots):
            if fac in no_first and p == 0:
                model.Add(theory_vars[(i, j)] == 0)
            if fac in no_last and p == last_period:
                model.Add(theory_vars[(i, j)] == 0)

    for i, subj in lab_subjects:
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        f1 = subj.get("faculty_1", "")
        f2 = subj.get("faculty_2", "")
        for k, (day, block_periods) in enumerate(blocks):
            p_start = block_periods[0]
            p_end   = block_periods[-1]
            for fac in [f1, f2]:
                if not valid_fac(fac):
                    continue
                if fac in no_first and p_start == 0:
                    model.Add(lab_vars[(i, k)] == 0)
                if fac in no_last and p_end == last_period:
                    model.Add(lab_vars[(i, k)] == 0)

    # Avoid days / preferred days for named faculty
    for i, subj in theory_subjects:
        fac = subj["faculty_1"]
        avoid = set(avoid_days_map.get(fac, []))
        pref  = set(preferred_days_map.get(fac, []))
        for j, (d, p) in enumerate(valid_slots):
            if d in avoid:
                model.Add(theory_vars[(i, j)] == 0)
            if pref and d not in pref:
                model.Add(theory_vars[(i, j)] == 0)

    for i, subj in lab_subjects:
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        f1 = subj.get("faculty_1", "")
        f2 = subj.get("faculty_2", "")
        for k, (day, block_periods) in enumerate(blocks):
            for fac in [f1, f2]:
                if not valid_fac(fac):
                    continue
                avoid = set(avoid_days_map.get(fac, []))
                pref  = set(preferred_days_map.get(fac, []))
                if day in avoid:
                    model.Add(lab_vars[(i, k)] == 0)
                if pref and day not in pref:
                    model.Add(lab_vars[(i, k)] == 0)

    # Locked slots: force a specific subject_code into a specific (section, day, period)
    for lock in locked_slots_list:
        sec      = lock.get("section")
        ld       = int(lock.get("day",    0))
        lp       = int(lock.get("period", 0))
        lcode    = lock.get("subject_code", "")
        # Force matching theory var ON, all others at that slot OFF
        for i, subj in theory_subjects:
            if subj["section"] != sec:
                continue
            slot_idx = None
            for j, (d, p) in enumerate(valid_slots):
                if d == ld and p == lp:
                    slot_idx = j
                    break
            if slot_idx is None:
                continue
            if subj["subject_code"] == lcode:
                model.Add(theory_vars[(i, slot_idx)] == 1)
            else:
                model.Add(theory_vars[(i, slot_idx)] == 0)

    # ------------------------------------------------------------------
    # Solve
    # ------------------------------------------------------------------
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = 30.0
    solver.parameters.num_search_workers = 4

    solve_status = solver.Solve(model)

    if solve_status not in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        raise ValueError(
            _diagnose_infeasibility(
                config, expanded, valid_slots, lab_blocks_cache, global_lab_len
            )
        )

    # ------------------------------------------------------------------
    # Extract solution
    # ------------------------------------------------------------------
    result = {sec: {} for sec in sections}

    for i, subj in theory_subjects:
        for j, slot in enumerate(valid_slots):
            if solver.Value(theory_vars[(i, j)]):
                result[subj["section"]][slot] = {
                    "subject_code": subj["subject_code"],
                    "subject_name": subj["subject_name"],
                    "type": "theory",
                    "faculty_1": subj["faculty_1"],
                    "faculty_2": "",
                    "is_lab_cont": False,
                    "lab_block_start": False,
                }

    for i, subj in lab_subjects:
        ll = eff_lab_len(subj)
        blocks = lab_blocks_cache[ll]
        for k, (day, block_periods) in enumerate(blocks):
            if solver.Value(lab_vars[(i, k)]):
                for idx, p in enumerate(block_periods):
                    result[subj["section"]][(day, p)] = {
                        "subject_code": subj["subject_code"],
                        "subject_name": subj["subject_name"],
                        "type": "lab",
                        "faculty_1": subj["faculty_1"],
                        "faculty_2": subj.get("faculty_2", ""),
                        "is_lab_cont": idx > 0,
                        "lab_block_start": idx == 0,
                        "lab_split_mode": subj.get("lab_split_mode") or "whole",
                    }

    return result


def _diagnose_infeasibility(
    config, subjects, valid_slots, lab_blocks_cache, global_lab_len
):
    sections = config["sections"]
    total_slots = len(valid_slots)
    days = config["working_days"]
    periods_per_day = config["periods_per_day"]
    min_gap = config.get("min_faculty_gap", 1)
    lines = ["No valid timetable could be found. Possible reasons:"]
    found_reason = False

    def eff_lab_len_s(subj):
        v = subj.get("lab_consecutive_periods")
        return v if v is not None else global_lab_len

    for sec in sections:
        sec_subjects = [s for s in subjects if s["section"] == sec]
        total_theory_hrs = sum(
            s["hours_per_week"] for s in sec_subjects if s["type"] == "theory"
        )
        total_lab_slots = sum(
            max(1, s["hours_per_week"] // eff_lab_len_s(s)) * eff_lab_len_s(s)
            for s in sec_subjects
            if s["type"] == "lab"
        )
        total_needed = total_theory_hrs + total_lab_slots
        if total_needed > total_slots:
            lines.append(
                "  - Section {sec}: needs {need} slots/week but only {avail} are "
                "available ({days} days x {ppd} periods). "
                "Theory: {th} periods, Lab: {lb} periods. "
                "Try increasing periods_per_day or reducing hours_per_week.".format(
                    sec=sec,
                    need=total_needed,
                    avail=total_slots,
                    days=days,
                    ppd=periods_per_day,
                    th=total_theory_hrs,
                    lb=total_lab_slots,
                )
            )
            found_reason = True

        # Check lab blocks
        for s in sec_subjects:
            if s["type"] == "lab":
                ll = eff_lab_len_s(s)
                blocks = lab_blocks_cache.get(ll, [])
                sessions_needed = max(1, s["hours_per_week"] // ll)
                if sessions_needed > len(blocks):
                    lines.append(
                        "  - Section {sec}, '{name}': needs {need} lab block(s) of "
                        "{ll} consecutive periods but only {avail} valid blocks exist "
                        "in the schedule. Try reducing lab_consecutive_periods "
                        "or adding more periods per day.".format(
                            sec=sec,
                            name=s["subject_name"],
                            need=sessions_needed,
                            ll=ll,
                            avail=len(blocks),
                        )
                    )
                    found_reason = True

    # Check for faculty overload
    from collections import defaultdict

    fac_hrs = defaultdict(int)
    for s in subjects:
        if s.get("faculty_1"):
            fac_hrs[s["faculty_1"]] += s["hours_per_week"]
        if s.get("faculty_2"):
            fac_hrs[s["faculty_2"]] += s["hours_per_week"]
    for fac, hrs in fac_hrs.items():
        if hrs > total_slots:
            lines.append(
                "  - Faculty '{fac}' is assigned {hrs} hours/week but only "
                "{avail} teaching slots exist. Reduce their load.".format(
                    fac=fac,
                    hrs=hrs,
                    avail=total_slots,
                )
            )
            found_reason = True

    if min_gap > 0:
        lines.append(
            "  - Min faculty gap is set to {gap} period(s). "
            "If a faculty teaches many subjects, this may leave too little room. "
            "Try reducing min_faculty_gap to 0.".format(gap=min_gap)
        )
        found_reason = True

    if not found_reason:
        lines.append(
            "  - The combination of subjects, faculty assignments, and constraints "
            "could not be satisfied within {days} days x {ppd} periods. "
            "Try: reducing hours_per_week for some subjects, setting "
            "min_faculty_gap to 0, or ensuring no single faculty is "
            "assigned more hours than available slots.".format(
                days=days,
                ppd=periods_per_day,
            )
        )

    return "\n".join(lines)
