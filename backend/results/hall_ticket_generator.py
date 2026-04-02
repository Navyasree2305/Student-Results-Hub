from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, Image
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.lib.enums import TA_CENTER
import qrcode
import io
import os
from datetime import datetime


class HallTicketPDFGenerator:
    def __init__(self):
        self.width, self.height = A4
        self.styles = getSampleStyleSheet()
        self._setup_custom_styles()
    
    def _setup_custom_styles(self):
        self.styles.add(ParagraphStyle(
            name='CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=18,
            textColor=colors.HexColor('#1a237e'),
            spaceAfter=10,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold'
        ))
        self.styles.add(ParagraphStyle(
            name='SubTitle',
            parent=self.styles['Normal'],
            fontSize=14,
            textColor=colors.HexColor('#283593'),
            spaceAfter=8,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold'
        ))
        self.styles.add(ParagraphStyle(
            name='FieldLabel',
            parent=self.styles['Normal'],
            fontSize=10,
            fontName='Helvetica-Bold'
        ))
        self.styles.add(ParagraphStyle(
            name='FieldValue',
            parent=self.styles['Normal'],
            fontSize=10,
            fontName='Helvetica'
        ))
    
    def generate_qr_code(self, data):
        qr = qrcode.QRCode(version=1, error_correction=qrcode.constants.ERROR_CORRECT_L, box_size=10, border=2)
        qr.add_data(data)
        qr.make(fit=True)
        img = qr.make_image(fill_color="black", back_color="white")
        buffer = io.BytesIO()
        img.save(buffer, format='PNG')
        buffer.seek(0)
        return Image(buffer, width=1.5*inch, height=1.5*inch)
    
    def generate_hall_ticket(self, hall_ticket_data, output_path):
        doc = SimpleDocTemplate(output_path, pagesize=A4, rightMargin=0.5*inch, leftMargin=0.5*inch, topMargin=0.5*inch, bottomMargin=0.5*inch)
        elements = []
        elements.append(Paragraph('SRI PADMAVATI MAHILA VISVAVIDYALAYAM', self.styles['CustomTitle']))
        elements.append(Paragraph('Womens University', self.styles['Normal']))
        elements.append(Paragraph('TIRUPATI - 517502', self.styles['Normal']))
        elements.append(Spacer(1, 0.2*inch))
        elements.append(Paragraph('EXAMINATION HALL TICKET', self.styles['SubTitle']))
        elements.append(Spacer(1, 0.1*inch))
        exam_name = hall_ticket_data.get('exam_name', '')
        elements.append(Paragraph(f'<b>{exam_name}</b>', self.styles['SubTitle']))
        elements.append(Spacer(1, 0.2*inch))
        
        student_info_data = []
        student_info_data.append([Paragraph('<b>Hall Ticket No:</b>', self.styles['FieldLabel']), Paragraph(hall_ticket_data.get('hall_ticket_number', ''), self.styles['FieldValue']), ''])
        student_info_data.append([Paragraph('<b>Student Name:</b>', self.styles['FieldLabel']), Paragraph(hall_ticket_data.get('student_name', ''), self.styles['FieldValue']), ''])
        student_info_data.append([Paragraph('<b>Roll Number:</b>', self.styles['FieldLabel']), Paragraph(hall_ticket_data.get('roll_number', ''), self.styles['FieldValue']), ''])
        course_branch = f"{hall_ticket_data.get('course', '').upper()} - {hall_ticket_data.get('branch', '').upper()}"
        student_info_data.append([Paragraph('<b>Course / Branch:</b>', self.styles['FieldLabel']), Paragraph(course_branch, self.styles['FieldValue']), ''])
        year_sem = f"Year: {hall_ticket_data.get('year', '')} | Semester: {hall_ticket_data.get('semester', '')}"
        student_info_data.append([Paragraph('<b>Year / Semester:</b>', self.styles['FieldLabel']), Paragraph(year_sem, self.styles['FieldValue']), ''])
        student_info_data.append([Paragraph('<b>Exam Center:</b>', self.styles['FieldLabel']), Paragraph(hall_ticket_data.get('exam_center', 'SPMVV SOET, Tirupati'), self.styles['FieldValue']), ''])
        
        student_info_table = Table(student_info_data, colWidths=[1.5*inch, 3.5*inch, 1.5*inch])
        photo_path = hall_ticket_data.get('student_photo_path')
        if photo_path and os.path.exists(photo_path):
            try:
                photo_img = Image(photo_path, width=1.3*inch, height=1.6*inch)
                student_info_data[0][2] = photo_img
                student_info_table = Table(student_info_data, colWidths=[1.5*inch, 3.5*inch, 1.5*inch])
            except:
                pass
        
        student_info_table.setStyle(TableStyle([('BACKGROUND', (0, 0), (-1, -1), colors.white), ('TEXTCOLOR', (0, 0), (-1, -1), colors.black), ('ALIGN', (0, 0), (-1, -1), 'LEFT'), ('VALIGN', (0, 0), (-1, -1), 'TOP'), ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'), ('FONTSIZE', (0, 0), (-1, -1), 10), ('GRID', (0, 0), (-1, -1), 1, colors.black), ('BOX', (0, 0), (-1, -1), 2, colors.black), ('SPAN', (2, 0), (2, 5))]))
        elements.append(student_info_table)
        elements.append(Spacer(1, 0.2*inch))
        elements.append(Paragraph('<b>EXAMINATION SCHEDULE</b>', self.styles['SubTitle']))
        elements.append(Spacer(1, 0.1*inch))
        
        schedule_data = [[Paragraph('<b>Date</b>', self.styles['FieldLabel']), Paragraph('<b>Time</b>', self.styles['FieldLabel']), Paragraph('<b>Subject Code</b>', self.styles['FieldLabel']), Paragraph('<b>Subject Name</b>', self.styles['FieldLabel'])]]
        schedules = hall_ticket_data.get('exam_schedules', [])
        for schedule in schedules:
            schedule_data.append([Paragraph(schedule.get('exam_date', ''), self.styles['FieldValue']), Paragraph(schedule.get('exam_time', ''), self.styles['FieldValue']), Paragraph(schedule.get('subject_code', ''), self.styles['FieldValue']), Paragraph(schedule.get('subject_name', ''), self.styles['FieldValue'])])
        
        schedule_table = Table(schedule_data, colWidths=[1.2*inch, 1.2*inch, 1.5*inch, 2.6*inch])
        schedule_table.setStyle(TableStyle([('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#e3f2fd')), ('TEXTCOLOR', (0, 0), (-1, -1), colors.black), ('ALIGN', (0, 0), (-1, -1), 'CENTER'), ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'), ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'), ('FONTSIZE', (0, 0), (-1, -1), 9), ('GRID', (0, 0), (-1, -1), 1, colors.black), ('BOX', (0, 0), (-1, -1), 2, colors.black)]))
        elements.append(schedule_table)
        elements.append(Spacer(1, 0.2*inch))
        elements.append(Paragraph('<b>INSTRUCTIONS TO CANDIDATES</b>', self.styles['SubTitle']))
        elements.append(Spacer(1, 0.1*inch))
        
        instructions = hall_ticket_data.get('instructions', '')
        if not instructions:
            instructions = "1. Candidates must bring this Hall Ticket to the examination hall.<br/>2. Candidates must be present at the examination center 30 minutes before the commencement of examination.<br/>3. Mobile phones and electronic devices are strictly prohibited inside the examination hall.<br/>4. Candidates must write their Roll Number on the answer booklet.<br/>5. Candidates are not allowed to leave the examination hall before the completion of the examination.<br/>6. Any form of malpractice will lead to cancellation of examination."
        
        elements.append(Paragraph(instructions, self.styles['Normal']))
        elements.append(Spacer(1, 0.2*inch))
        
        footer_data = []
        qr_data = hall_ticket_data.get('qr_code_data', '')
        qr_code_img = self.generate_qr_code(qr_data)
        footer_data.append([qr_code_img, '', Paragraph('<b>Controller of Examinations</b>', self.styles['FieldValue'])])
        footer_table = Table(footer_data, colWidths=[2*inch, 3*inch, 2*inch])
        footer_table.setStyle(TableStyle([('ALIGN', (0, 0), (0, 0), 'LEFT'), ('ALIGN', (2, 0), (2, 0), 'RIGHT'), ('VALIGN', (0, 0), (-1,
