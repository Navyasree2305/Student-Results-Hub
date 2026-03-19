from rest_framework.decorators import api_view, permission_classes, parser_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser
from django.http import FileResponse, HttpResponse
from django.db import transaction
from django.shortcuts import get_object_or_404
from django.utils import timezone
from datetime import datetime
import pandas as pd
import os
from io import BytesIO
import zipfile
import json

from .models import (
    Exam, ExamSubject, ExamEnrollment, StudentPhoto, 
    HallTicket, User, AuditLog
)
from .serializers import (
    ExamSerializer, ExamSubjectSerializer, ExamEnrollmentSerializer,
    StudentPhotoSerializer, HallTicketSerializer
)
from .hall_ticket_pdf import HallTicketPDFGenerator


def log_audit(user, action, details):
    """Helper function to log audit events"""
    try:
        ip = details.get('ip') if isinstance(details, dict) else None
        details_str = json.dumps(details) if isinstance(details, dict) else str(details)
        AuditLog.objects.create(
            user=user,
            action=action,
            details=details_str,
            ip_address=ip
        )
    except Exception as e:
        print(f"Audit log error: {str(e)}")


# ==================== EXAM MANAGEMENT ====================

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def manage_exams(request):
    """
    GET: List all exams (with filters)
    POST: Create a new exam (admin only)
    """
    if request.method == 'GET':
        exams = Exam.objects.all().prefetch_related('subjects', 'enrollments')
        
        # Apply filters
        is_active = request.query_params.get('is_active')
        year = request.query_params.get('year')
        semester = request.query_params.get('semester')
        course = request.query_params.get('course')
        branch = request.query_params.get('branch')
        
        if is_active is not None:
            exams = exams.filter(is_active=is_active.lower() == 'true')
        if year:
            exams = exams.filter(year=year)
        if semester:
            exams = exams.filter(semester=semester)
        if course:
            exams = exams.filter(course=course)
        if branch:
            exams = exams.filter(branch=branch)
        
        serializer = ExamSerializer(exams, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    elif request.method == 'POST':
        # Only admin can create exams
        if request.user.role != "admin":
            return Response({'error': 'Only admin users can create exams'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        try:
            data = request.data.copy()
            data['created_by'] = request.user.id
            
            serializer = ExamSerializer(data=data, context={'request': request})
            if serializer.is_valid():
                exam = serializer.save()
                
                log_audit(request.user, 'exam_created', {
                    'exam_id': exam.id,
                    'exam_name': exam.exam_name,
                    'ip': request.META.get('REMOTE_ADDR', 'unknown')
                })
                
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            import traceback
            return Response(
                {"error": str(e), "detail": traceback.format_exc()},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated])
def exam_detail(request, exam_id):
    """
    GET: Get exam details
    PUT: Update exam (admin only)
    DELETE: Delete exam (admin only)
    """
    exam = get_object_or_404(Exam, id=exam_id)
    
    if request.method == 'GET':
        serializer = ExamSerializer(exam, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    elif request.method == 'PUT':
        if request.user.role != "admin":
            return Response({'error': 'Only admin users can update exams'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        serializer = ExamSerializer(exam, data=request.data, partial=True, 
                                   context={'request': request})
        if serializer.is_valid():
            serializer.save()
            
            log_audit(request.user, 'exam_updated', {
                'exam_id': exam.id,
                'exam_name': exam.exam_name,
                'ip': request.META.get('REMOTE_ADDR', 'unknown')
            })
            
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        if request.user.role != "admin":
            return Response({'error': 'Only admin users can delete exams'}, 
                          status=status.HTTP_403_FORBIDDEN)
        
        exam_name = exam.exam_name
        exam.delete()
        
        log_audit(request.user, 'exam_deleted', {
            'exam_id': exam_id,
            'exam_name': exam_name,
            'ip': request.META.get('REMOTE_ADDR', 'unknown')
        })
        
        return Response({'message': 'Exam deleted successfully'}, 
                       status=status.HTTP_204_NO_CONTENT)


# ==================== SUBJECT MANAGEMENT ====================

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_exam_subject(request, exam_id):
    """Add a subject to an exam (admin only)"""
    if request.user.role != "admin":
        return Response({'error': 'Only admin users can add subjects'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    exam = get_object_or_404(Exam, id=exam_id)
    
    serializer = ExamSubjectSerializer(data=request.data)
    if serializer.is_valid():
        subject = serializer.save(exam=exam)
        
        log_audit(request.user, 'subject_added', {
            'exam_id': exam.id,
            'subject_id': subject.id,
            'subject_code': subject.subject_code,
            'ip': request.META.get('REMOTE_ADDR', 'unknown')
        })
        
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_exam_subject(request, subject_id):
    """Update a subject (admin only)"""
    if request.user.role != "admin":
        return Response({'error': 'Only admin users can update subjects'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    subject = get_object_or_404(ExamSubject, id=subject_id)
    serializer = ExamSubjectSerializer(subject, data=request.data, partial=True)
    
    if serializer.is_valid():
        serializer.save()
        
        log_audit(request.user, 'subject_updated', {
            'subject_id': subject.id,
            'subject_code': subject.subject_code,
            'ip': request.META.get('REMOTE_ADDR', 'unknown')
        })
        
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_exam_subject(request, subject_id):
    """Delete a subject (admin only)"""
    if request.user.role != "admin":
        return Response({'error': 'Only admin users can delete subjects'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    subject = get_object_or_404(ExamSubject, id=subject_id)
    subject_code = subject.subject_code
    subject.delete()
    
    log_audit(request.user, 'subject_deleted', {
        'subject_id': subject_id,
        'subject_code': subject_code,
        'ip': request.META.get('REMOTE_ADDR', 'unknown')
    })
    
    return Response({'message': 'Subject deleted successfully'}, 
                   status=status.HTTP_204_NO_CONTENT)


# ==================== STUDENT ENROLLMENT ====================

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def upload_student_list(request, exam_id):
    """Upload Excel file with student list (admin only)"""
    import logging
    logger = logging.getLogger(__name__)
    
    logger.info(f'Upload student list called for exam_id: {exam_id}')
    logger.info(f'request.FILES keys: {list(request.FILES.keys())}')
    logger.info(f'request.user: {request.user}')
    logger.info(f'request.user.role == "admin": {request.user.role == "admin"}')
    
    if request.user.role != "admin":
        logger.warning(f'Non-staff user {request.user} attempted to upload student list')
        return Response({'error': 'Only admin users can upload student lists'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    exam = get_object_or_404(Exam, id=exam_id)
    logger.info(f'Exam found: {exam.exam_name}')
    
    if 'file' not in request.FILES:
        logger.error(f'No file in request.FILES. Available keys: {list(request.FILES.keys())}')
        return Response({'error': 'No file uploaded'}, 
                      status=status.HTTP_400_BAD_REQUEST)
    
    excel_file = request.FILES['file']
    logger.info(f'File received: {excel_file.name}, size: {excel_file.size}')
    
    try:
        # Read Excel file
        df = pd.read_excel(excel_file)
        
        # Validate required columns
        required_columns = ['Roll Number', 'Student Name']
        missing_columns = [col for col in required_columns if col not in df.columns]
        
        if missing_columns:
            return Response({
                'error': f'Missing required columns: {", ".join(missing_columns)}'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Process enrollments
        created_count = 0
        skipped_count = 0
        errors = []
        
        with transaction.atomic():
            for index, row in df.iterrows():
                roll_number = str(row['Roll Number']).strip()
                student_name = str(row['Student Name']).strip()
                
                if not roll_number or not student_name:
                    errors.append(f'Row {index + 2}: Missing roll number or student name')
                    continue
                
                # Check if already enrolled
                if ExamEnrollment.objects.filter(exam=exam, roll_number=roll_number).exists():
                    skipped_count += 1
                    continue
                
                # Try to find existing student
                student = User.objects.filter(roll_number=roll_number).first()
                
                # Create enrollment
                ExamEnrollment.objects.create(
                    exam=exam,
                    roll_number=roll_number,
                    student_name=student_name,
                    student=student
                )
                created_count += 1
        
        log_audit(request.user, 'student_list_uploaded', {
            'exam_id': exam.id,
            'created_count': created_count,
            'skipped_count': skipped_count,
            'ip': request.META.get('REMOTE_ADDR', 'unknown')
        })
        
        return Response({
            'message': 'Student list uploaded successfully',
            'created_count': created_count,
            'skipped_count': skipped_count,
            'errors': errors
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        return Response({'error': f'Failed to process Excel file: {str(e)}'}, 
                      status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_enrollments(request, exam_id):
    """List all enrollments for an exam"""
    exam = get_object_or_404(Exam, id=exam_id)
    
    enrollments = ExamEnrollment.objects.filter(exam=exam).select_related('student')
    serializer = ExamEnrollmentSerializer(enrollments, many=True, context={'request': request})
    
    return Response(serializer.data, status=status.HTTP_200_OK)


# ==================== STUDENT PHOTO UPLOAD ====================

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def upload_student_photo(request):
    """Upload student photo with consent"""
    user = request.user
    
    if 'photo' not in request.FILES:
        return Response({'error': 'No photo uploaded'}, 
                      status=status.HTTP_400_BAD_REQUEST)
    
    consent_given = request.data.get('consent_given', 'false').lower() == 'true'
    
    if not consent_given:
        return Response({'error': 'Consent is required to upload photo'}, 
                      status=status.HTTP_400_BAD_REQUEST)
    
    photo = request.FILES['photo']
    consent_text = request.data.get('consent_text', 
                                    'I hereby give consent to use my photograph for hall ticket generation.')
    
    # Check if photo already exists (allow re-upload)
    student_photo, created = StudentPhoto.objects.update_or_create(
        student=user,
        defaults={
            'roll_number': user.roll_number,
            'photo': photo,
            'consent_given': True,
            'consent_text': consent_text,
            'consent_date': timezone.now()
        }
    )
    
    log_audit(request.user, 'photo_uploaded' if created else 'photo_updated', {
        'roll_number': user.roll_number,
        'ip': request.META.get('REMOTE_ADDR', 'unknown')
    })
    
    serializer = StudentPhotoSerializer(student_photo, context={'request': request})
    return Response({
        'message': 'Photo uploaded successfully',
        'photo': serializer.data
    }, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_student_photo(request):
    """Get current user's photo"""
    try:
        student_photo = StudentPhoto.objects.get(student=request.user)
        serializer = StudentPhotoSerializer(student_photo, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)
    except StudentPhoto.DoesNotExist:
        return Response({'error': 'No photo uploaded yet'}, 
                      status=status.HTTP_404_NOT_FOUND)


# ==================== HALL TICKET GENERATION ====================

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def generate_hall_tickets(request, exam_id):
    """Generate hall tickets for all enrolled students (admin only)"""
    if request.user.role != "admin":
        return Response({'error': 'Only admin users can generate hall tickets'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    exam = get_object_or_404(Exam, id=exam_id)
    enrollments = ExamEnrollment.objects.filter(exam=exam)
    
    if not enrollments.exists():
        return Response({'error': 'No students enrolled for this exam'}, 
                      status=status.HTTP_400_BAD_REQUEST)
    
    generated_count = 0
    skipped_count = 0
    errors = []
    
    with transaction.atomic():
        for enrollment in enrollments:
            # Check if hall ticket already exists
            if HallTicket.objects.filter(enrollment=enrollment).exists():
                skipped_count += 1
                continue
            
            # Use roll_number as hall ticket number
            ht_number = f"{exam.id}-{enrollment.roll_number}"
            
            # QR code data
            qr_data = f'SPVMM:HT:{ht_number}:{enrollment.roll_number}:{exam.exam_name}'
            
            # Create hall ticket record
            hall_ticket = HallTicket.objects.create(
                hall_ticket_number=ht_number,
                exam=exam,
                enrollment=enrollment,
                student=enrollment.student if hasattr(enrollment, 'student') and enrollment.student else None,
                qr_code_data=qr_data,
                status='generated',
                download_count=0,
                generated_by=request.user
            )
            
            generated_count += 1
    
    log_audit(request.user, 'hall_tickets_generated', {
        'exam_id': exam.id,
        'generated_count': generated_count,
        'skipped_count': skipped_count,
        'ip': request.META.get('REMOTE_ADDR', 'unknown')
    })
    
    return Response({
        'message': 'Hall tickets generated successfully',
        'generated_count': generated_count,
        'skipped_count': skipped_count,
        'errors': errors
    }, status=status.HTTP_201_CREATED)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_hall_tickets(request, exam_id):
    """List all hall tickets for an exam"""
    exam = get_object_or_404(Exam, id=exam_id)
    
    hall_tickets = HallTicket.objects.filter(enrollment__exam=exam).select_related(
        'enrollment', 'enrollment__student', 'student'
    )
    
    serializer = HallTicketSerializer(hall_tickets, many=True, context={'request': request})
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def download_hall_ticket(request, ticket_id):
    """Download hall ticket PDF (admin only) - generates PDF in-memory without storing"""
    if request.user.role != "admin":
        return Response({'error': 'Only admin users can download hall tickets'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    hall_ticket = get_object_or_404(HallTicket, id=ticket_id)
    
    # Prepare ticket data
    exam = hall_ticket.exam
    enrollment = hall_ticket.enrollment
    subjects = exam.subjects.all().order_by('order', 'exam_date')
    
    # Get student photo path (try via linked student, fallback by roll_number)
    photo_path = None
    try:
        student_obj = enrollment.student
        if student_obj is None:
            student_obj = User.objects.filter(roll_number=enrollment.roll_number).first()
        if student_obj:
            photo = StudentPhoto.objects.filter(student=student_obj).first()
            if photo and photo.consent_given and photo.photo:
                photo_path = photo.photo.path
    except Exception:
        photo_path = None
    
    ticket_data = [{
        'hall_ticket_number': hall_ticket.hall_ticket_number,
        'exam_name': exam.exam_name,
        'student_name': enrollment.student_name,
        'roll_number': enrollment.roll_number,
        'course': exam.course,
        'branch': exam.branch or 'N/A',
        'year': exam.year,
        'semester': exam.semester,
        'exam_center': exam.exam_center,
        'exam_start_time': exam.exam_start_time.strftime('%I:%M %p') if exam.exam_start_time else '09:00 AM',
        'exam_end_time': exam.exam_end_time.strftime('%I:%M %p') if exam.exam_end_time else '12:00 PM',
        'instructions': exam.instructions if exam.instructions else '',
        'student_photo_path': photo_path,
        'qr_code_data': hall_ticket.qr_code_data,
        'subjects': [{
            'exam_date': subject.exam_date.strftime('%Y-%m-%d') if subject.exam_date else None,
            'exam_time': subject.exam_time.strftime('%I:%M %p') if subject.exam_time else '10:00 AM',
            'subject_code': subject.subject_code,
            'subject_name': subject.subject_name,
            'subject_type': subject.subject_type,
        } for subject in subjects]
    }]
    

    # Generate PDF in-memory using buffer
    import re
    pdf_generator = HallTicketPDFGenerator()

    try:
        pdf_buffer = pdf_generator.generate(ticket_data)
        pdf_content = pdf_buffer.read()
    except Exception as e:
        import traceback
        traceback.print_exc()
        return Response({'error': 'Failed to generate PDF: ' + str(e)},
                      status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    hall_ticket.download_count += 1
    hall_ticket.downloaded_at = timezone.now()
    hall_ticket.save()

    log_audit(request.user, 'hall_ticket_downloaded', {
        'ticket_id': hall_ticket.id,
        'hall_ticket_number': hall_ticket.hall_ticket_number,
        'ip': request.META.get('REMOTE_ADDR', 'unknown')
    })

    exam_name_sanitized = re.sub(r'[^a-zA-Z0-9_.-]', '_', exam.exam_name).strip('_')
    ht_number_sanitized = re.sub(r'[^a-zA-Z0-9_-]', '_', hall_ticket.hall_ticket_number)
    pdf_filename = exam_name_sanitized + '_' + ht_number_sanitized + '.pdf'
    response = HttpResponse(pdf_content, content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="' + pdf_filename + '"'
    return response




@api_view(['GET'])
@permission_classes([IsAuthenticated])
def view_hall_ticket(request):
    """View hall ticket details (students can view, not download)"""
    user = request.user
    
    # Get hall tickets for current user
    hall_tickets = HallTicket.objects.filter(
        enrollment__roll_number=user.roll_number
    ).select_related('exam', 'enrollment')
    
    if not hall_tickets.exists():
        return Response({'error': 'No hall tickets found'}, 
                      status=status.HTTP_404_NOT_FOUND)
    
    serializer = HallTicketSerializer(hall_tickets, many=True, context={'request': request})
    return Response(serializer.data, status=status.HTTP_200_OK)


# ==================== SAMPLE EXCEL TEMPLATE ====================

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def download_sample_template(request):
    """Download sample Excel template for student list upload"""
    # Create sample Excel file
    data = {
        'Roll Number': ['20211A0101', '20211A0102', '20211A0103'],
        'Student Name': ['Student Name 1', 'Student Name 2', 'Student Name 3']
    }
    
    df = pd.DataFrame(data)
    
    # Create Excel file in memory
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='Student List')
    
    output.seek(0)
    
    response = HttpResponse(
        output.getvalue(),
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
    response['Content-Disposition'] = 'attachment; filename="student_list_template.xlsx"'
    
    return response



@api_view(['GET'])
@permission_classes([IsAuthenticated])
def download_all_hall_tickets(request, exam_id):
    """Download all hall tickets for an exam as a single PDF file (admin only)"""
    import tempfile
    import os
    
    if request.user.role != "admin":
        return Response({'error': 'Only admin users can download hall tickets'}, 
                      status=status.HTTP_403_FORBIDDEN)
    
    exam = get_object_or_404(Exam, id=exam_id)
    
    # Get all hall tickets for this exam
    hall_tickets = HallTicket.objects.filter(enrollment__exam=exam).select_related('enrollment')
    
    if not hall_tickets.exists():
        return Response({'error': 'No hall tickets found for this exam'}, 
                      status=status.HTTP_404_NOT_FOUND)
    
    # Collect all ticket data
    all_tickets_data = []
    
    for ticket in hall_tickets:
        try:
            # Get enrollment data
            enrollment = ticket.enrollment
            student = ticket.student
            
            # Get student photo path (try via linked student, fallback by roll_number)
            photo_path = None
            try:
                student_obj = student
                if student_obj is None:
                    student_obj = User.objects.filter(roll_number=enrollment.roll_number).first()
                if student_obj:
                    from .models import StudentPhoto as SP
                    photo = SP.objects.filter(student=student_obj).first()
                    if photo and photo.consent_given and photo.photo:
                        photo_path = photo.photo.path
            except Exception:
                photo_path = None
            
            # Get exam subjects
            subjects = exam.subjects.all().order_by('order', 'exam_date')
            subjects_list = [{
                'subject_code': subj.subject_code,
                'subject_name': subj.subject_name,
                'exam_date': subj.exam_date.strftime('%Y-%m-%d') if subj.exam_date else None,
                'subject_type': subj.subject_type
            } for subj in subjects]
            
            # Prepare ticket data for PDF generation
            ticket_data = {
                'hall_ticket_number': ticket.hall_ticket_number,  # Use actual hall ticket number from DB
                'exam_name': exam.exam_name,
                'course': exam.course,
                'branch': exam.branch,
                'year': exam.year,
                'semester': exam.semester,
                'roll_number': enrollment.roll_number,
                'student_name': enrollment.student_name,
                'student_photo_path': photo_path,
                'exam_center': exam.exam_center,
                'exam_start_time': exam.exam_start_time.strftime('%I:%M %p') if exam.exam_start_time else '',
                'exam_end_time': exam.exam_end_time.strftime('%I:%M %p') if exam.exam_end_time else '',
                'instructions': exam.instructions if exam.instructions else '',
                'subjects': subjects_list,
            }
            
            all_tickets_data.append(ticket_data)
            
        except Exception as e:
            # Log error but continue with other tickets
            import traceback
            print(f"Error preparing ticket data for ticket {ticket.id}: {str(e)}")
            traceback.print_exc()
            continue
    
    # Generate single PDF with all tickets (2 per page)
    try:
        pdf_generator = HallTicketPDFGenerator()
        pdf_buffer = pdf_generator.generate(all_tickets_data)
        pdf_content = pdf_buffer.read()
    except Exception as e:
        import traceback
        print(f"Error generating PDF: {str(e)}")
        traceback.print_exc()
        return Response({'error': f'Failed to generate PDF: {str(e)}'}, 
                      status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    # Create response with single PDF
    response = HttpResponse(pdf_content, content_type='application/pdf')
    # Create filename from exam name (sanitize for filesystem)
    import re
    exam_name_sanitized = re.sub(r'[^a-zA-Z0-9_.-]', '_', exam.exam_name).strip('_')
    pdf_filename = f"{exam_name_sanitized}_Halltickets.pdf"
    response['Content-Disposition'] = f'attachment; filename="{pdf_filename}"'
    
    # Log audit
    log_audit(request.user, 'bulk_hall_tickets_downloaded', {
        'exam_id': exam_id,
        'exam_name': exam.exam_name,
        'ticket_count': hall_tickets.count(),
        'ip': request.META.get('REMOTE_ADDR', 'unknown')
    })
    
    return response
