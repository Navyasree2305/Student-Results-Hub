from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, Image, PageBreak, HRFlowable
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch, mm
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_JUSTIFY
from reportlab.pdfgen import canvas
import io
import os
from datetime import datetime


class WatermarkCanvas(canvas.Canvas):
    """Custom canvas that adds watermark and border to each page"""
    
    def __init__(self, *args, **kwargs):
        canvas.Canvas.__init__(self, *args, **kwargs)
        self.pages = []
    
    def showPage(self):
        self.pages.append(dict(self.__dict__))
        self._startPage()
    
    def save(self):
        page_count = len(self.pages)
        for page_dict in self.pages:
            self.__dict__.update(page_dict)
            self._add_watermark()
            self._add_border()
            canvas.Canvas.showPage(self)
        canvas.Canvas.save(self)
    
    def _add_watermark(self):
        """Add diagonal watermark across page"""
        self.saveState()
        self.setFont('Times-Roman', 60)
        self.setFillColor(colors.Color(0, 0, 0, alpha=0.05))
        
        page_width, page_height = A4
        self.translate(page_width / 2, page_height / 2)
        self.rotate(45)
        
        text = "SPMVV OFFICIAL"
        self.drawCentredString(0, 0, text)
        
        self.restoreState()
    
    def _add_border(self):
        """Add decorative border around page"""
        self.saveState()
        page_width, page_height = A4
        margin = 0.15 * inch
        
        # Outer border
        self.setLineWidth(2)
        self.setStrokeColor(colors.black)
        self.rect(margin, margin, page_width - 2*margin, page_height - 2*margin)
        
        # Inner border
        inner_margin = margin + 0.08*inch
        self.setLineWidth(0.5)
        self.rect(inner_margin, inner_margin, 
                  page_width - 2*inner_margin, page_height - 2*inner_margin)
        
        self.restoreState()


class HallTicketPDFGenerator:
    def __init__(self):
        self.page_width, self.page_height = A4
        self.styles = getSampleStyleSheet()
        self._setup_styles()
    
    def _setup_styles(self):
        # COMPACT styles to fit 2 tickets per page
        self.styles.add(ParagraphStyle(
            name="OriginalHeader",
            parent=self.styles["Normal"],
            fontSize=10,
            textColor=colors.black,
            alignment=TA_CENTER,
            fontName="Times-Bold",
            spaceAfter=1,
            spaceBefore=0,
            leading=10,
        ))
        
        self.styles.add(ParagraphStyle(
            name="CollegeTitle",
            parent=self.styles["Heading1"],
            fontSize=14,  # Reduced from 18
            textColor=colors.black,
            spaceAfter=1,  # Reduced from 2
            spaceBefore=0,
            alignment=TA_CENTER,
            fontName="Times-Bold",
            leading=14
        ))
        
        self.styles.add(ParagraphStyle(
            name="Subtitle",
            parent=self.styles["Normal"],
            fontSize=10,  # Reduced from 12
            textColor=colors.black,
            spaceAfter=1,
            spaceBefore=0,
            alignment=TA_CENTER,
            fontName="Times-Italic",
            leading=10
        ))
        
        self.styles.add(ParagraphStyle(
            name="ExamTitle",
            parent=self.styles["Normal"],
            fontSize=11,  # Reduced from 13
            textColor=colors.black,
            spaceAfter=2,  # Reduced from 3
            spaceBefore=1,  # Reduced from 2
            alignment=TA_CENTER,
            fontName="Times-Bold",
            leading=11
        ))
        
        self.styles.add(ParagraphStyle(
            name="FieldLabel",
            parent=self.styles["Normal"],
            fontSize=9,  # Reduced from 10
            fontName="Times-Bold",
            leading=10  # Reduced from 12
        ))
        
        self.styles.add(ParagraphStyle(
            name="FieldValue",
            parent=self.styles["Normal"],
            fontSize=9,  # Reduced from 10
            fontName="Times-Roman",
            leading=10  # Reduced from 12
        ))
        
        self.styles.add(ParagraphStyle(
            name="TableHeader",
            parent=self.styles["Normal"],
            fontSize=9,  # Increased for better readability
            fontName="Times-Bold",
            alignment=TA_CENTER,
            leading=10
        ))
        
        self.styles.add(ParagraphStyle(
            name="TableCell",
            parent=self.styles["Normal"],
            fontSize=9,  # Increased for better readability
            fontName="Times-Roman",
            leading=10,
            alignment=TA_LEFT
        ))
        
        self.styles.add(ParagraphStyle(
            name="SignatureLabel",
            parent=self.styles["Normal"],
            fontSize=9,  # Reduced from 10
            fontName="Times-Bold",
            alignment=TA_CENTER,
            leading=10  # Reduced from 12
        ))
        
        self.styles.add(ParagraphStyle(
            name="Instructions",
            parent=self.styles["Normal"],
            fontSize=8,  # Reduced from 9
            fontName="Times-Roman",
            leading=9,  # Reduced from 11
            alignment=TA_JUSTIFY,
            leftIndent=15,
            firstLineIndent=-15
        ))
    
    def _resize_photo(self, photo_path, width=1.2*inch, height=1.5*inch):
        """Resize and return student photo"""
        try:
            if photo_path and os.path.exists(photo_path):
                return Image(photo_path, width=width, height=height)
        except Exception as e:
            print(f"Error loading photo: {e}")
        return None
    
    def _build_single_ticket(self, ticket_data):
        """Build a single hall ticket"""
        elements = []
        
        # Header
        header_table = Table(
            [[Paragraph("<b>ORIGINAL - HALL TICKET</b>", self.styles["OriginalHeader"])]],
            colWidths=[7.05*inch]
        )
        header_table.setStyle(TableStyle([
            ("BOX", (0,0), (-1,-1), 1.5, colors.black),
            ("ALIGN", (0,0), (-1,-1), "CENTER"),
            ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
            ("TOPPADDING", (0,0), (-1,-1), 3),
            ("BOTTOMPADDING", (0,0), (-1,-1), 3),
        ]))
        elements.append(header_table)
        elements.append(Spacer(1, 0.05*inch))
        
        # College Name
        elements.append(Paragraph("Sri Padmavati Mahila Visvavidyalayam", self.styles["CollegeTitle"]))
        elements.append(Paragraph("(Women's University) - Tirupati", self.styles["Subtitle"]))
        elements.append(Spacer(1, 0.02*inch))
        
        # Decorative lines
        elements.append(HRFlowable(width="100%", thickness=1, color=colors.black, spaceAfter=2, spaceBefore=0))
        elements.append(HRFlowable(width="100%", thickness=0.5, color=colors.black, spaceAfter=4, spaceBefore=0))
        
        # Exam Title
        exam_title = ticket_data.get('exam_name', '')
        elements.append(Paragraph(f"<b>{exam_title}</b>", self.styles["ExamTitle"]))
        elements.append(Spacer(1, 0.06*inch))
        
        # Student Details with Photo
        photo_img = self._resize_photo(ticket_data.get("student_photo_path"))
        roll_number = ticket_data.get("roll_number", "")
        
        student_details_data = [
            [
                Paragraph("<b>Name of the Student:</b>", self.styles["FieldLabel"]),
                Paragraph(ticket_data.get("student_name", ""), self.styles["FieldValue"]),
                photo_img if photo_img else ""
            ],
            [
                Paragraph("<b>Hall Ticket Number:</b>", self.styles["FieldLabel"]),
                Paragraph(f"<b>{roll_number}</b>", self.styles["FieldValue"]),
                ""
            ],
            [
                Paragraph("<b>Branch:</b>", self.styles["FieldLabel"]),
                Paragraph(ticket_data.get("branch", ""), self.styles["FieldValue"]),
                ""
            ],
            [
                Paragraph("<b>Examination Centre:</b>", self.styles["FieldLabel"]),
                Paragraph(ticket_data.get("exam_center", "SPMVV, Tirupati"), self.styles["FieldValue"]),
                ""
            ],
            [
                Paragraph("<b>Examination Time:</b>", self.styles["FieldLabel"]),
                Paragraph(f"{ticket_data.get('exam_start_time', '09:00 AM')} to {ticket_data.get('exam_end_time', '12:00 PM')}", self.styles["FieldValue"]),
                ""
            ],
        ]
        
        student_details_table = Table(student_details_data, colWidths=[1.8*inch, 3.9*inch, 1.35*inch])
        student_details_table.setStyle(TableStyle([
            ("BOX", (0,0), (-1,-1), 1, colors.black),
            ("INNERGRID", (0,0), (1,-1), 0.25, colors.gray),
            ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
            ("ALIGN", (0,0), (0,-1), "LEFT"),
            ("ALIGN", (1,0), (1,-1), "LEFT"),
            ("ALIGN", (2,0), (2,-1), "CENTER"),
            ("SPAN", (2,0), (2,4)),
            ("BOX", (2,0), (2,4), 1, colors.black),
            ("LEFTPADDING", (0,0), (-1,-1), 4),
            ("RIGHTPADDING", (0,0), (-1,-1), 4),
            ("TOPPADDING", (0,0), (-1,-1), 3),
            ("BOTTOMPADDING", (0,0), (-1,-1), 3),
        ]))
        
        elements.append(student_details_table)
        elements.append(Spacer(1, 0.08*inch))
        
        # Subjects Table
        subjects = ticket_data.get("subjects", [])
        num_subjects = len(subjects)
        
        if num_subjects <= 4:
            subjects_table = self._build_single_column_subjects_table(subjects)
        else:
            subjects_table = self._build_two_column_subjects_table(subjects)
        
        elements.append(subjects_table)
        elements.append(Spacer(1, 0.08*inch))
        
        # Instructions
        instructions_text = ticket_data.get("instructions", "")
        if instructions_text:
            inst_header = Table(
                [[Paragraph("<b>INSTRUCTIONS TO THE CANDIDATE</b>", self.styles["FieldLabel"])]],
                colWidths=[7.05*inch]
            )
            inst_header.setStyle(TableStyle([
                ("BOX", (0,0), (-1,-1), 1, colors.black),
                ("ALIGN", (0,0), (-1,-1), "LEFT"),
                ("LEFTPADDING", (0,0), (-1,-1), 4),
                ("TOPPADDING", (0,0), (-1,-1), 2),
                ("BOTTOMPADDING", (0,0), (-1,-1), 2),
            ]))
            elements.append(inst_header)
            elements.append(Spacer(1, 0.04*inch))
            
            instructions_lines = instructions_text.split("\n")
            for idx, line in enumerate(instructions_lines[:3], 1):
                if line.strip():
                    elements.append(Paragraph(f"{idx}. {line.strip()}", self.styles["Instructions"]))
        
        # Signatures
        elements.append(Spacer(1, 0.12*inch))
        
        signature_data = [
            ["_____________________", "_____________________", "_____________________", "_____________________"],
            [
                Paragraph("<b>Signature of Student</b>", self.styles["SignatureLabel"]),
                Paragraph("<b>Signature of HOD</b>", self.styles["SignatureLabel"]),
                Paragraph("<b>Signature of CoE</b>", self.styles["SignatureLabel"]),
                Paragraph("<b>Signature of Director</b>", self.styles["SignatureLabel"])
            ]
        ]
        
        signature_table = Table(signature_data, colWidths=[1.76*inch, 1.76*inch, 1.76*inch, 1.76*inch])
        signature_table.setStyle(TableStyle([
            ("VALIGN", (0,0), (-1,-1), "BOTTOM"),
            ("ALIGN", (0,0), (-1,-1), "CENTER"),
            ("TOPPADDING", (0,0), (-1,-1), 0),
            ("BOTTOMPADDING", (0,0), (0,0), 2),
            ("TOPPADDING", (0,1), (-1,-1), 4),
        ]))
        
        elements.append(signature_table)
        
        return elements
    
    def _format_subject_date(self, subject):
        """Format subject date"""
        subject_type = subject.get("subject_type", "Theory")
        exam_date = subject.get("exam_date", "-")
        
        if subject_type == "Lab":
            return "---"
        elif exam_date and exam_date != "-":
            try:
                if isinstance(exam_date, str):
                    date_obj = datetime.strptime(exam_date, "%Y-%m-%d")
                else:
                    date_obj = exam_date
                return date_obj.strftime("%d-%m-%Y")
            except:
                return str(exam_date)
        return "---"
    
    def _build_single_column_subjects_table(self, subjects):
        """Build subjects table in single column"""
        subjects_header = [[
            Paragraph("<b>S.No</b>", self.styles["TableHeader"]),
            Paragraph("<b>Exam Date</b>", self.styles["TableHeader"]),
            Paragraph("<b>Subject Code</b>", self.styles["TableHeader"]),
            Paragraph("<b>Subject Name</b>", self.styles["TableHeader"])
        ]]
        
        subjects_rows = []
        for idx, subject in enumerate(subjects, start=1):
            exam_date = self._format_subject_date(subject)
            subjects_rows.append([
                Paragraph(str(idx), self.styles["TableCell"]),
                Paragraph(str(exam_date), self.styles["TableCell"]),
                Paragraph(subject.get("subject_code", ""), self.styles["TableCell"]),
                Paragraph(subject.get("subject_name", ""), self.styles["TableCell"])
            ])
        
        subjects_table = Table(
            subjects_header + subjects_rows,
            colWidths=[0.4*inch, 1.0*inch, 0.9*inch, 4.75*inch]
        )
        
        subjects_table.setStyle(TableStyle([
            ("BOX", (0,0), (-1,-1), 1.5, colors.black),
            ("INNERGRID", (0,0), (-1,-1), 0.5, colors.black),
            ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
            ("ALIGN", (0,0), (-1,0), "CENTER"),
            ("ALIGN", (0,1), (0,-1), "CENTER"),
            ("ALIGN", (1,1), (1,-1), "CENTER"),
            ("ALIGN", (2,1), (2,-1), "CENTER"),
            ("ALIGN", (3,1), (3,-1), "LEFT"),
            ("LEFTPADDING", (0,0), (-1,-1), 3),
            ("RIGHTPADDING", (0,0), (-1,-1), 3),
            ("TOPPADDING", (0,0), (-1,-1), 3),
            ("BOTTOMPADDING", (0,0), (-1,-1), 3),
            ("LINEABOVE", (0,1), (-1,1), 1, colors.black),
        ]))
        
        return subjects_table
    
    def _build_two_column_subjects_table(self, subjects):
        """Build subjects table in 2 columns"""
        mid_point = (len(subjects) + 1) // 2
        left_subjects = subjects[:mid_point]
        right_subjects = subjects[mid_point:]
        
        table_data = []
        
        header_row = [
            Paragraph("<b>No.</b>", self.styles["TableHeader"]),
            Paragraph("<b>Date</b>", self.styles["TableHeader"]),
            Paragraph("<b>Code</b>", self.styles["TableHeader"]),
            Paragraph("<b>Subject Name</b>", self.styles["TableHeader"]),
            Paragraph("<b>No.</b>", self.styles["TableHeader"]),
            Paragraph("<b>Date</b>", self.styles["TableHeader"]),
            Paragraph("<b>Code</b>", self.styles["TableHeader"]),
            Paragraph("<b>Subject Name</b>", self.styles["TableHeader"]),
        ]
        table_data.append(header_row)
        
        for i in range(mid_point):
            row = []
            
            left_subject = left_subjects[i]
            left_date = self._format_subject_date(left_subject)
            row.extend([
                Paragraph(str(i + 1), self.styles["TableCell"]),
                Paragraph(str(left_date), self.styles["TableCell"]),
                Paragraph(left_subject.get("subject_code", ""), self.styles["TableCell"]),
                Paragraph(left_subject.get("subject_name", ""), self.styles["TableCell"])
            ])
            
            if i < len(right_subjects):
                right_subject = right_subjects[i]
                right_date = self._format_subject_date(right_subject)
                row.extend([
                    Paragraph(str(mid_point + i + 1), self.styles["TableCell"]),
                    Paragraph(str(right_date), self.styles["TableCell"]),
                    Paragraph(right_subject.get("subject_code", ""), self.styles["TableCell"]),
                    Paragraph(right_subject.get("subject_name", ""), self.styles["TableCell"])
                ])
            else:
                row.extend([Paragraph("", self.styles["TableCell"]) for _ in range(4)])
            
            table_data.append(row)
        
        subjects_table = Table(table_data, colWidths=[
            0.35*inch, 0.75*inch, 0.55*inch, 2.1*inch,
            0.35*inch, 0.75*inch, 0.55*inch, 2.1*inch
        ])
        
        subjects_table.setStyle(TableStyle([
            ("BOX", (0,0), (-1,-1), 1.5, colors.black),
            ("INNERGRID", (0,0), (-1,-1), 0.5, colors.black),
            ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
            ("ALIGN", (0,0), (-1,0), "CENTER"),
            ("ALIGN", (0,1), (0,-1), "CENTER"),
            ("ALIGN", (4,1), (4,-1), "CENTER"),
            ("ALIGN", (1,1), (1,-1), "CENTER"),
            ("ALIGN", (5,1), (5,-1), "CENTER"),
            ("ALIGN", (2,1), (2,-1), "CENTER"),
            ("ALIGN", (6,1), (6,-1), "CENTER"),
            ("ALIGN", (3,1), (3,-1), "LEFT"),
            ("ALIGN", (7,1), (7,-1), "LEFT"),
            ("LEFTPADDING", (0,0), (-1,-1), 2),
            ("RIGHTPADDING", (0,0), (-1,-1), 2),
            ("TOPPADDING", (0,0), (-1,-1), 3),
            ("BOTTOMPADDING", (0,0), (-1,-1), 3),
            ("LINEABOVE", (0,1), (-1,1), 1, colors.black),
        ]))
        
        return subjects_table
    
    def generate(self, tickets_data):
        """Generate PDF with EXACTLY 2 hall tickets per page"""
        buffer = io.BytesIO()
        
        page_width, page_height = A4
        margin_left = 0.4*inch
        margin_right = 0.4*inch
        margin_top = 0.45*inch
        margin_bottom = 0.45*inch
        
        doc = SimpleDocTemplate(
            buffer,
            pagesize=A4,
            rightMargin=margin_right,
            leftMargin=margin_left,
            topMargin=margin_top,
            bottomMargin=margin_bottom
        )
        
        doc.canvasmaker = WatermarkCanvas
        
        story = []
        
        # Process tickets in pairs - 2 per page
        for i in range(0, len(tickets_data), 2):
            # First ticket
            ticket1_elements = self._build_single_ticket(tickets_data[i])
            story.extend(ticket1_elements)
            
            # If there's a second ticket for this page
            if i + 1 < len(tickets_data):
                # Add spacer and separator
                story.append(Spacer(1, 0.3*inch))
                story.append(HRFlowable(width="100%", thickness=0.5, dash=[3,3], color=colors.black))
                story.append(Spacer(1, 0.15*inch))
                
                # Second ticket
                ticket2_elements = self._build_single_ticket(tickets_data[i + 1])
                story.extend(ticket2_elements)
            
            # Page break after every 2 tickets
            if i + 2 < len(tickets_data):
                story.append(PageBreak())
        
        doc.build(story)
        buffer.seek(0)
        return buffer
