from rest_framework import status, generics
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from django.db import transaction
from django.utils import timezone
from django.db.models import Count, Q, Avg, F
from collections import defaultdict
from django.http import HttpResponse
from .models import User, Result, Subject, Notification, AuditLog, Circular
from .serializers import (
    UserRegistrationSerializer, PasswordChangeSerializer,
    ResultSerializer, SubjectSerializer, NotificationSerializer, AuditLogSerializer, CircularSerializer
)
from .middleware import LoginAttemptMiddleware
from .excel_handler import ExcelValidator
import logging

logger = logging.getLogger('django')
security_logger = logging.getLogger('security')


def calculate_sgpa(subjects):
    """
    Calculate SGPA based on subjects with credits and grades
    Grade mapping: O=10, A=9, B=8, C=7, D=6, F=0
    Formula: (subject1_grade * subject1_credits + ...) / total_credits
    """
    grade_points = {
        'O': 10,
        'A': 9,
        'B': 8,
        'C': 7,
        'D': 6,
        'F': 0
    }
    
    total_credits = 0
    weighted_sum = 0
    
    for subject in subjects:
        credits = subject.get('Credits', 0)
        grade = subject.get('Grade', '').strip().upper()
        
        if credits and grade in grade_points:
            total_credits += credits
            weighted_sum += grade_points[grade] * credits
    
    if total_credits == 0:
        return None
    
    sgpa = weighted_sum / total_credits
    return round(sgpa, 2)


def calculate_total_marks(subjects):
    """Calculate total marks from all subjects"""
    total = 0
    for subject in subjects:
        marks = subject.get('Total', 0)
        if marks:
            total += marks
    return total


def get_client_ip(request):
    """Get client IP address"""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


def create_audit_log(user, action, details, request):
    """Create audit log entry"""
    AuditLog.objects.create(
        user=user,
        action=action,
        details=details,
        ip_address=get_client_ip(request)
    )


@api_view(['POST'])
@permission_classes([AllowAny])
def register_student(request):
    """Student registration"""
    serializer = UserRegistrationSerializer(data=request.data)
    
    if serializer.is_valid():
        user = serializer.save()
        
        # Create audit log
        create_audit_log(user, 'user_registration', 
                        f"Student registered: {user.roll_number}", request)
        
        security_logger.info(f"New student registered: {user.roll_number} from {get_client_ip(request)}")
        
        return Response({
            'message': 'Registration successful',
            'roll_number': user.roll_number
        }, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    """Login for both admin and students"""
    username = request.data.get('username')
    password = request.data.get('password')
    ip_address = get_client_ip(request)
    
    if not username or not password:
        return Response({
            'error': 'Username and password are required'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    # Check login attempts
    if not LoginAttemptMiddleware.check_login_attempts(username, ip_address):
        security_logger.warning(f"Account locked: {username} from {ip_address}")
        return Response({
            'error': 'Account temporarily locked due to multiple failed login attempts. Please try again later.'
        }, status=status.HTTP_403_FORBIDDEN)
    
    # Authenticate user
    user = authenticate(username=username, password=password)
    
    if user is not None:
        # Clear failed attempts
        LoginAttemptMiddleware.clear_login_attempts(username)
        
        # Record successful attempt
        LoginAttemptMiddleware.record_login_attempt(username, ip_address, True)
        
        # Generate tokens
        refresh = RefreshToken.for_user(user)
        
        # Create audit log
        create_audit_log(user, 'login', f"Successful login from {ip_address}", request)
        
        security_logger.info(f"Successful login: {username} from {ip_address}")
        
        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': {
                'username': user.username,
                'roll_number': user.roll_number,
                'role': user.role,
                'first_name': user.first_name,
                'last_name': user.last_name,
                'branch': user.branch,
                'department': user.department,
                'can_view_all_branches': user.can_view_all_branches,
                'can_manage_users': user.can_manage_users,
                'can_view_statistics': user.can_view_statistics,
                'can_upload_results': user.can_upload_results,
                'can_delete_results': user.can_delete_results,
                'permissions': {
                    'can_view_statistics': user.can_view_statistics,
                    'can_upload_results': user.can_upload_results,
                    'can_delete_results': user.can_delete_results,
                    'can_manage_users': user.can_manage_users,
                    'can_view_all_branches': user.can_view_all_branches,
                }
            }
        })
    else:
        # Record failed attempt
        LoginAttemptMiddleware.record_login_attempt(username, ip_address, False)
        
        # Get remaining attempts
        remaining = LoginAttemptMiddleware.get_remaining_attempts(username)
        
        security_logger.warning(f"Failed login attempt: {username} from {ip_address}. {remaining} attempts remaining")
        
        error_message = 'Invalid credentials'
        if remaining > 0:
            error_message += f'. {remaining} attempt(s) remaining before account lockout'
        else:
            error_message = 'Account locked due to multiple failed attempts. Please try again in 30 minutes'
        
        return Response({
            'error': error_message,
            'remaining_attempts': remaining
        }, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    """Logout and blacklist token"""
    try:
        from .models import BlacklistedToken
        
        refresh_token = request.data.get('refresh')
        access_token = request.data.get('access')
        
        # Blacklist both tokens
        if refresh_token:
            BlacklistedToken.objects.get_or_create(
                token=refresh_token,
                defaults={'user': request.user}
            )
        
        if access_token:
            BlacklistedToken.objects.get_or_create(
                token=access_token,
                defaults={'user': request.user}
            )
        
        create_audit_log(request.user, 'logout', 
                        f"Logout from {get_client_ip(request)}", request)
        
        security_logger.info(f"User logged out: {request.user.username} from {get_client_ip(request)}")
        
        return Response({'message': 'Logout successful'})
    except Exception as e:
        security_logger.error(f"Logout error: {str(e)}")
        return Response({'error': 'Logout failed'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def change_password(request):
    """Change password"""
    serializer = PasswordChangeSerializer(data=request.data)
    
    if serializer.is_valid():
        user = request.user
        
        # Check old password
        if not user.check_password(serializer.validated_data['old_password']):
            return Response({
                'error': 'Old password is incorrect'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        # Set new password
        user.set_password(serializer.validated_data['new_password'])
        user.save()
        
        # Create audit log
        create_audit_log(user, 'password_change', 
                        f"Password changed from {get_client_ip(request)}", request)
        
        security_logger.info(f"Password changed: {user.username} from {get_client_ip(request)}")
        
        return Response({'message': 'Password changed successfully'})
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def upload_results(request):
    """Upload results via Excel (Admin only)"""
    if request.user.role != 'admin':
        security_logger.warning(f"Unauthorized result upload attempt by {request.user.username}")
        return Response({
            'error': 'Permission denied'
        }, status=status.HTTP_403_FORBIDDEN)
    
    file = request.FILES.get('file')
    if not file:
        return Response({
            'error': 'No file provided'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    # Get form data
    year = request.POST.get('year')
    semester = request.POST.get('semester')
    result_type = request.POST.get('result_type')
    course = request.POST.get('course', 'btech')  # Default to btech
    exam_held_date = request.POST.get('exam_held_date')
    
    # Validate form data
    if not year or not semester or not result_type or not course:
        return Response({
            'error': 'Year, Semester, Result Type, and Course are required'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    try:
        year = int(year)
        semester = int(semester)
    except ValueError:
        return Response({
            'error': 'Year and Semester must be numbers'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    if year not in [1, 2, 3, 4]:
        return Response({
            'error': 'Year must be 1, 2, 3, or 4'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    if semester not in [1, 2]:
        return Response({
            'error': 'Semester must be 1 or 2'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    # Normalize course
    course_lower = course.lower()
    if course_lower not in ['btech', 'mtech']:
        return Response({
            'error': 'Course must be B.Tech or M.Tech'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    course_display = 'B.Tech' if course_lower == 'btech' else 'M.Tech'
    

    
    # Normalize result type
    result_type_lower = result_type.lower()
    if result_type_lower not in ['regular', 'supplementary', 'both']:
        return Response({
            'error': 'Result Type must be Regular, Supplementary, or Both'
        }, status=status.HTTP_400_BAD_REQUEST)
    
    # Generate exam name
    year_text = ['I', 'II', 'III', 'IV'][year - 1]
    semester_text = ['I', 'II'][semester - 1]
    result_type_display = dict([('regular', 'Regular'), ('supplementary', 'Supplementary'), ('both', 'Regular and Supplementary')])[result_type_lower]
    
    from datetime import datetime
    exam_date_obj = None
    if exam_held_date:
        try:
            # Parse YYYY-MM format
            exam_date = datetime.strptime(exam_held_date, "%Y-%m")
            month_year = exam_date.strftime("%B %Y")
            exam_date_obj = exam_date.date()  # Convert to date object
        except:
            month_year = datetime.now().strftime("%B %Y")
    else:
        month_year = datetime.now().strftime("%B %Y")
    
    exam_name = f"{course_display} {year_text} year {semester_text} Semester {result_type_display} Exam Results {month_year}"
    # Validate file
    file_errors = ExcelValidator.validate_file(file)
    if file_errors:
        return Response({'errors': file_errors}, status=status.HTTP_400_BAD_REQUEST)
    
    # Parse Excel
    try:
        import openpyxl
        workbook = openpyxl.load_workbook(file, data_only=True)
        
        # Validate structure
        structure_errors = ExcelValidator.validate_structure(workbook)
        if structure_errors:
            return Response({'errors': structure_errors}, status=status.HTTP_400_BAD_REQUEST)
        
        # Parse data
        file.seek(0)
        data, parse_errors = ExcelValidator.parse_excel(file)
        
        if parse_errors:
            return Response({'errors': parse_errors}, status=status.HTTP_400_BAD_REQUEST)
        
        # Validate data
        validation_errors = ExcelValidator.validate_data(data)
        if validation_errors:
            return Response({'errors': validation_errors}, status=status.HTTP_400_BAD_REQUEST)
        
        # Import data
        with transaction.atomic():
            created_count = 0
            updated_count = 0
            students_notified = set()
            branches_found = set()
            
            for row in data:
                roll_number = str(row['Roll Number']).strip()
                student_branch = row.get("Branch", "cse")
                student_result_type = row.get("Result Type", "regular")
                branches_found.add(student_branch)
                # Year, semester, exam_name, result_type come from form data now
                
                # Try to find existing student user (do NOT auto-create)
                try:
                    student_user = User.objects.get(roll_number=roll_number)
                except User.DoesNotExist:
                    student_user = None  # Exam results can exist without user accounts
                
                # Check if result exists (lookup by unique_together fields only)
                # DEBUG: Log what we are about to create
                logger.error(f"DEBUG Upload Row - Roll: {roll_number}, Name: {row['Student Name']}")
                logger.error(f"DEBUG Upload Row - Year: {year}, Semester: {semester}, Result Type: {student_result_type}")
                logger.error(f"DEBUG Upload Row - Student User: {student_user} (ID: {student_user.id if student_user else None})")
                logger.error(f"DEBUG Upload Row - Branch: {student_branch}, Course: {course_lower}")

                # Calculate SGPA and total marks
                subjects_data = row.get('subjects', [])
                sgpa = calculate_sgpa(subjects_data)
                total_marks = calculate_total_marks(subjects_data)

                # Check if any subject has F grade
                has_fail_grade = any(
                    subject.get("Grade", "").strip().upper() == "F"
                    for subject in subjects_data
                )

                # Determine overall result: Fail if any F grade OR SGPA < 6.0
                if has_fail_grade:
                    overall_result = "Fail"
                elif sgpa and sgpa >= 6.0:
                    overall_result = "Pass"
                else:
                    overall_result = "Fail"
                
                result, created = Result.objects.update_or_create(
                    roll_number=roll_number,
                    exam_name=exam_name,
                    defaults={
                        'student': student_user,  # Update student FK (can be None)
                        'student_name': str(row['Student Name']).strip(),
                        'year': year,
                        'semester': semester,
                        'result_type': student_result_type,
                        'exam_held_date': exam_date_obj,
                        'course': course_lower,
                        'branch': student_branch,  # Branch from Excel
                        'overall_result': overall_result,
                        'overall_grade': '',  # Not used in new format
                        'total_marks': total_marks,
                        'sgpa': sgpa,
                        'uploaded_by': request.user
                    }
                )
                
                logger.error(f"DEBUG Upload Result - Created: {created}, Result ID: {result.id}")
                if created:
                    created_count += 1
                else:
                    updated_count += 1
                
                # Handle subject creation - Simple and isolated per exam
                # Each exam is completely independent, no merging or copying
                
                # Delete existing subjects for this result if updating
                if not created:
                    result.subjects.all().delete()
                
                # Create subjects from Excel
                for subject_data in row.get('subjects', []):
                    Subject.objects.create(
                        result=result,
                        subject_code=str(subject_data.get('Code', '')).strip(),
                        subject_name=str(subject_data.get('Name', '')).strip(),
                        credits=subject_data.get('Credits', None),
                        internal_marks=subject_data.get('Internal', None),
                        external_marks=subject_data.get('External', None),
                        total_marks=subject_data.get('Total', None),
                        grade=subject_data.get('Grade', ''),
                        attempts=1  # Each exam is independent, attempts=1
                    )
                
                # Re-validate overall_result based on saved subject grades
                # Check if any subject has F grade (failing grade)
                all_subjects = result.subjects.all()
                if all_subjects.count() > 0:
                    has_f_grade = all_subjects.filter(
                        grade__iexact="F"
                    ).exists()
                    
                    # Update overall_result: Fail if any F grade OR SGPA < 6.0
                    if has_f_grade:
                        result.overall_result = "Fail"
                    elif result.sgpa and result.sgpa >= 6.0:
                        result.overall_result = "Pass"
                    else:
                        result.overall_result = "Fail"
                    result.save()

                # Update completion date if all subjects passed
                all_subjects = result.subjects.all()
                pending_count = all_subjects.filter(grade__iexact='F').count()
                if pending_count == 0 and all_subjects.count() > 0:
                    from datetime import date
                    result.completion_date = date.today()
                    result.save()
                

                # Create notification for student
                if student_user and roll_number not in students_notified:
                    from datetime import date
                    Notification.objects.create(
                        student=student_user,
                        result=result,
                        exam_name=exam_name,
                        message=f"{exam_name}",
                        results_published_date=date.today()
                    )
                    students_notified.add(roll_number)
            
            # Create audit log
            create_audit_log(
                request.user, 
                'result_upload',
                f"Uploaded results: {created_count} created, {updated_count} updated, Branches: {list(branches_found)}",
                request
            )
            
            security_logger.info(
                f"Results uploaded by {request.user.username}: {created_count} created, {updated_count} updated, Branches: {list(branches_found)}"
            )
            
            return Response({
                'message': 'Results uploaded successfully',
                'created': created_count,
                'updated': updated_count,
                'students_notified': len(students_notified),
                'branches': list(branches_found)
            }, status=status.HTTP_201_CREATED)
    
    except Exception as e:
        logger.error(f"Error uploading results: {str(e)}")
        import traceback
        logger.error(f"Full traceback: {traceback.format_exc()}")
        return Response({
            'error': f"Error processing file: {str(e)}"
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_results(request):
    """Get results for logged-in student or all results for admin"""
    user = request.user
    
    if user.role == 'admin':
        # Admin can see all results
        results = Result.objects.all().order_by('-uploaded_at')
        
        # Optional filters
        roll_number = request.GET.get('roll_number')
        semester = request.GET.get('semester')
        result_type = request.GET.get('result_type')
        
        if roll_number:
            results = results.filter(roll_number__icontains=roll_number)
        if semester:
            results = results.filter(semester=semester)
        if result_type:
            results = results.filter(result_type=result_type)
    else:
        # Students can only see their own results (by roll_number)
        if user.roll_number:
            results = Result.objects.filter(roll_number=user.roll_number).order_by('-uploaded_at')
        else:
            results = Result.objects.none()  # No results if roll number not set
    
    serializer = ResultSerializer(results, many=True)
    
    # Create audit log
    create_audit_log(user, 'result_view', 
                    f"Viewed results: {results.count()} records", request)
    
    return Response({
        'count': results.count(),
        'results': serializer.data
    })


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_consolidated_results(request):
    """
    Get consolidated results grouped by year/semester with current SGPA calculation.
    For each year/semester:
    - Show all exam attempts (regular, supplementary)
    - Calculate current SGPA using best grades across all attempts
    - Show pending subjects count
    """
    user = request.user
    
    if user.role != 'student' or not user.roll_number:
        return Response({
            'error': 'Only students with roll numbers can access consolidated results'
        }, status=status.HTTP_403_FORBIDDEN)
    
    # Get all results for the student
    results = Result.objects.filter(roll_number=user.roll_number).order_by('year', 'semester', 'uploaded_at')
    
    if not results.exists():
        return Response({
            'count': 0,
            'consolidated_results': []
        })
    
    # Group results by year and semester
    year_semester_groups = {}
    for result in results:
        key = f"{result.year}_{result.semester}"
        if key not in year_semester_groups:
            year_semester_groups[key] = {
                'year': result.year,
                'semester': result.semester,
                'attempts': []
            }
        
        # Get subjects for this attempt
        subjects = Subject.objects.filter(result=result).order_by('id')
        subjects_data = SubjectSerializer(subjects, many=True).data
        
        year_semester_groups[key]['attempts'].append({
            'result_id': result.id,
            'exam_name': result.exam_name,
            'result_type': result.result_type,
            'result_type_display': result.get_result_type_display(),
            'uploaded_at': result.uploaded_at.strftime('%Y-%m-%d'),
            'original_sgpa': result.sgpa,
            'original_result': result.overall_result,
            'total_marks': result.total_marks,
            'subjects': subjects_data
        })
    
    # Calculate current SGPA and pending subjects for each year/semester
    consolidated_results = []
    for key, group_data in year_semester_groups.items():
        # Collect all subjects across all attempts
        all_subjects = {}  # key: subject_code, value: best subject data
        
        for attempt in group_data['attempts']:
            for subject in attempt['subjects']:
                subject_code = subject['subject_code']
                
                # If subject not seen before, or if this is a more recent attempt, update it
                if subject_code not in all_subjects:
                    all_subjects[subject_code] = subject
                else:
                    # Compare grades - use the latest attempt (most recent upload)
                    # The attempts are already ordered by uploaded_at
                    all_subjects[subject_code] = subject
        
        # Calculate current SGPA using best grades
        grade_points = {'O': 10, 'A': 9, 'B': 8, 'C': 7, 'D': 6, 'F': 0}
        total_credits = 0
        weighted_sum = 0
        pending_subjects = []
        
        for subject_code, subject in all_subjects.items():
            credits = subject.get('credits', 0)
            grade = subject.get('grade', '').strip().upper()
            
            if credits and grade in grade_points:
                total_credits += credits
                weighted_sum += grade_points[grade] * credits
                
                # Track pending (failed) subjects
                if grade == 'F':
                    pending_subjects.append({
                        'subject_code': subject_code,
                        'subject_name': subject.get('subject_name', '')
                    })
        
        current_sgpa = round(weighted_sum / total_credits, 2) if total_credits > 0 else None
        
        # Determine current result status
        if len(pending_subjects) > 0:
            current_result = 'Fail'
        elif current_sgpa and current_sgpa >= 6.0:
            current_result = 'Pass'
        else:
            current_result = 'Fail'
        
        # Get year name
        year_names = {1: 'I', 2: 'II', 3: 'III', 4: 'IV'}
        year_display = f"{year_names.get(group_data['year'], group_data['year'])} Year"
        semester_display = f"{year_names.get(group_data['semester'], group_data['semester'])} Semester"
        
        consolidated_results.append({
            'year': group_data['year'],
            'semester': group_data['semester'],
            'year_display': year_display,
            'semester_display': semester_display,
            'attempts': group_data['attempts'],
            'current_sgpa': current_sgpa,
            'current_result': current_result,
            'pending_subjects_count': len(pending_subjects),
            'pending_subjects': pending_subjects,
            'best_subjects': list(all_subjects.values())
        })
    
    # Sort by year and semester
    consolidated_results.sort(key=lambda x: (x['year'], x['semester']))
    
    # Create audit log
    create_audit_log(user, 'consolidated_result_view', 
                    f"Viewed consolidated results: {len(consolidated_results)} year/semester groups", request)
    
    return Response({
        'count': len(consolidated_results),
        'consolidated_results': consolidated_results
    })




@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_notifications(request):
    """Get notifications for logged-in student"""
    user = request.user
    
    if user.role != 'student':
        return Response({
            'error': 'Notifications are only available for students'
        }, status=status.HTTP_403_FORBIDDEN)
    
    # Get query parameters
    unread_only = request.GET.get('unread_only', 'false').lower() == 'true'
    
    notifications = Notification.objects.filter(student=user)
    
    if unread_only:
        notifications = notifications.filter(is_read=False)
    
    serializer = NotificationSerializer(notifications, many=True)
    
    return Response({
        'count': notifications.count(),
        'unread_count': Notification.objects.filter(student=user, is_read=False).count(),
        'notifications': serializer.data
    })


@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def mark_notification_read(request, notification_id):
    """Mark notification as read"""
    user = request.user
    
    try:
        notification = Notification.objects.get(id=notification_id, student=user)
        notification.is_read = True
        notification.save()
        
        return Response({
            'message': 'Notification marked as read'
        })
    except Notification.DoesNotExist:
        return Response({
            'error': 'Notification not found'
        }, status=status.HTTP_404_NOT_FOUND)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def health_check(request):
    pass


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_combined_notifications(request):
    """
    Get combined notifications and circulars for student dashboard.
    Returns latest 3 items combining exam notifications and circulars.
    """
    user = request.user
    
    if user.role != 'student':
        return Response({
            'error': 'This endpoint is only for students'
        }, status=status.HTTP_403_FORBIDDEN)
    
    combined_items = []
    
    # Get exam notifications
    notifications = Notification.objects.filter(student=user, is_read=False).order_by('-created_at')
    for notif in notifications:
        combined_items.append({
            'id': f'notif_{notif.id}',
            'type': 'exam_notification',
            'title': 'New Exam Result',
            'message': notif.message,
            'created_at': notif.created_at,
            'is_read': notif.is_read,
            'result_id': notif.result_id,
            'notification_id': notif.id
        })
    
    # Get circulars (same filtering as manage_circulars)
    circulars = Circular.objects.filter(is_active=True)
    
    # Get year from latest result
    result = Result.objects.filter(roll_number=user.roll_number).order_by('-year', '-semester').first()
    if result:
        circulars = circulars.filter(
            Q(target_year=result.year) | Q(target_year__isnull=True)
        )
    
    # Filter by branch from user profile
    if user.branch:
        circulars = circulars.filter(
            Q(target_branch__iexact=user.branch) | Q(target_branch__isnull=True)
        )
    
    circulars = circulars.order_by('-created_at')
    
    for circ in circulars:
        combined_items.append({
            'id': f'circ_{circ.id}',
            'type': 'circular',
            'title': circ.title,
            'message': circ.description,
            'created_at': circ.created_at,
            'category': circ.category,
            'file_url': request.build_absolute_uri(circ.attachment.url) if circ.attachment else None,
            'circular_id': circ.id
        })
    
    # Sort by created_at descending
    combined_items.sort(key=lambda x: x['created_at'], reverse=True)
    
    # Get latest 3 for dashboard
    latest_3 = combined_items[:3]
    
    return Response({
        'count': len(latest_3),
        'total_unread_notifications': Notification.objects.filter(student=user, is_read=False).count(),
        'total_active_circulars': circulars.count(),
        'items': latest_3
    })

    """Health check endpoint"""
    try:
        # Check database connectivity
        user_count = User.objects.count()
        result_count = Result.objects.count()
        
        return Response({
            'status': 'healthy',
            'database': 'connected',
            'user': {
                'username': request.user.username,
                'role': request.user.role,
                'authenticated': True
            },
            'stats': {
                'total_users': user_count,
                'total_results': result_count
            },
            'timestamp': timezone.now().isoformat()
        })
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        return Response({
            'status': 'unhealthy',
            'error': str(e),
            'timestamp': timezone.now().isoformat()
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def get_uploaded_exams(request):
    """Get list of uploaded exams (grouped by exam_name) with isolated statistics - Admin only"""
    if request.user.role != "admin":
        return Response({"error": "Permission denied"}, status=status.HTTP_403_FORBIDDEN)
    
    from django.db.models import Count, Max, Min, F, Q
    
    # Get unique exam names first
    exam_names = Result.objects.values_list('exam_name', flat=True).distinct()
    
    exams_list = []
    for exam_name in exam_names:
        # Get stats for this exam - ISOLATED by exam_name
        exam_results = Result.objects.filter(exam_name=exam_name)
        
        # Count unique students (by roll_number)
        student_count = exam_results.values('roll_number').distinct().count()
        
        # Calculate pass/fail statistics - ISOLATED per exam
        pass_count = exam_results.filter(overall_result__iexact='pass').count()
        fail_count = exam_results.filter(overall_result__iexact='fail').count()
        pass_percentage = round((pass_count / student_count * 100), 2) if student_count > 0 else 0
        
        # Get other info from first result
        first_result = exam_results.first()
        
        if first_result:
            exams_list.append({
                'exam_name': exam_name,
                'year': first_result.year,
                'semester': first_result.semester,
                'result_type': first_result.result_type,
                'course': first_result.course,
                'uploaded_at': first_result.uploaded_at,
                'uploaded_by__username': first_result.uploaded_by.username if first_result.uploaded_by else 'Unknown',
                'student_count': student_count,
                'pass_count': pass_count,
                'fail_count': fail_count,
                'pass_percentage': pass_percentage,
                'latest_upload': exam_results.aggregate(Max('uploaded_at'))['uploaded_at__max']
            })
    
    # Sort by latest upload date
    exams_list.sort(key=lambda x: x['latest_upload'], reverse=True)
    
    return Response({
        "count": len(exams_list),
        "exams": exams_list
    })



@api_view(["GET"])
@permission_classes([IsAuthenticated])
def download_exam_results(request, exam_name):
    """Download results as Excel file for a specific exam - Admin only"""
    if request.user.role != "admin":
        return Response({"error": "Permission denied"}, status=status.HTTP_403_FORBIDDEN)
    
    from django.http import HttpResponse
    import openpyxl
    from openpyxl.styles import Font, PatternFill, Alignment
    
    # Get all results for this exam
    results = Result.objects.filter(exam_name=exam_name).prefetch_related("subjects").order_by("roll_number")
    
    if not results.exists():
        return Response({"error": "No results found for this exam"}, status=status.HTTP_404_NOT_FOUND)
    
    # Create workbook
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "Results"
    
    # Headers
    headers = ["Roll Number", "Student Name"]
    
    # Find maximum number of subjects
    max_subjects = max(r.subjects.count() for r in results)
    
    # Add subject columns
    for i in range(1, max_subjects + 1):
        headers.extend([
            f"Subject {i} Code", f"Subject {i} Name",
            f"Subject {i} Internal", f"Subject {i} External",
            f"Subject {i} Total", f"Subject {i} Result", f"Subject {i} Grade"
        ])
    
    headers.extend(["Overall Result", "Overall Grade"])
    
    # Write headers
    for col_idx, header in enumerate(headers, 1):
        cell = ws.cell(1, col_idx, header)
        cell.font = Font(bold=True, color="FFFFFF")
        cell.fill = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
        cell.alignment = Alignment(horizontal="center", vertical="center")
    
    # Write data
    row_idx = 2
    current_roll = None
    row_data = []
    
    for result in results:
        if current_roll != result.roll_number:
            # Write previous row if exists
            if row_data:
                for col_idx, value in enumerate(row_data, 1):
                    ws.cell(row_idx, col_idx, value)
                row_idx += 1
            
            # Start new row
            row_data = [result.roll_number, result.student_name]
            current_roll = result.roll_number
        
        # Add subject data
        for subject in result.subjects.all():
            row_data.extend([
                subject.subject_code, subject.subject_name,
                subject.internal_marks, subject.external_marks,
                subject.total_marks, subject.grade
            ])
        
        # Add overall result (only once per student)
        if not any(x in row_data[2:] for x in [result.overall_result, result.overall_grade]):
            row_data.extend([result.overall_result, result.overall_grade])
    
    # Write last row
    if row_data:
        for col_idx, value in enumerate(row_data, 1):
            ws.cell(row_idx, col_idx, value)
    
    # Adjust column widths
    for col in ws.columns:
        max_length = 0
        column = col[0].column_letter
        for cell in col:
            try:
                if len(str(cell.value)) > max_length:
                    max_length = len(str(cell.value))
            except:
                pass
        adjusted_width = min(max_length + 2, 50)
        ws.column_dimensions[column].width = adjusted_width
    
    # Create response
    response = HttpResponse(
        content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
    filename = exam_name.replace(" ", "_")
    response["Content-Disposition"] = f"attachment; filename={filename}.xlsx"
    
    wb.save(response)
    return response


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_exam_results(request, exam_name):
    """Delete all results for a specific exam - Admin only"""
    if request.user.role != 'admin':
        return Response({'error': 'Permission denied'}, status=status.HTTP_403_FORBIDDEN)
    
    # Get all results for this exam
    results = Result.objects.filter(exam_name=exam_name)
    
    if not results.exists():
        return Response({'error': 'No results found for this exam'}, status=status.HTTP_404_NOT_FOUND)
    
    # Count before deletion
    count = results.count()
    student_count = results.values('roll_number').distinct().count()
    
    # Delete all results (subjects will be cascade deleted)
    results.delete()
    
    # Delete associated notifications
    Notification.objects.filter(exam_name=exam_name).delete()
    
    # Create audit log
    create_audit_log(
        request.user,
        'result_delete_exam',
        f'Deleted exam: {exam_name} ({student_count} students, {count} total records)',
        request
    )
    
    logger.info(f'Admin {request.user.username} deleted exam: {exam_name}')
    
    return Response({
        'message': f'Successfully deleted {exam_name}',
        'students_deleted': student_count,
        'records_deleted': count
    }, status=status.HTTP_200_OK)


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def get_statistics(request):
    """Get comprehensive statistics - permission-based filtering"""
    # Check if user has permission to view statistics
    if not request.user.can_view_statistics:
        return Response({"error": "Permission denied. You do not have access to view statistics."}, status=403)
    
    try:
        user = request.user
        
        # Get filter parameters
        result_type_filter = request.GET.get('result_type', 'all')  # all, regular, supplementary
        branch_filter = request.GET.get('branch', 'all')  # all or specific branch
        exam_name_filter = request.GET.get('exam_name', None)  # filter by specific exam
        
        # Base queryset
        base_query = Result.objects.all()
        
        # Apply exam name filter if provided
        if exam_name_filter:
            base_query = base_query.filter(exam_name=exam_name_filter)
        
        # Apply user-specific branch restrictions
        if user.branch and not user.can_view_all_branches:
            # User is restricted to their branch only
            base_query = base_query.filter(branch__iexact=user.branch)
            # Override branch_filter to their assigned branch
            branch_filter = user.branch
        
        # Apply result type filter
        if result_type_filter == 'regular':
            base_query = base_query.filter(result_type='regular')
        elif result_type_filter == 'supplementary':
            base_query = base_query.filter(result_type='supplementary')
        
        # Apply branch filter
        if branch_filter != 'all':
            base_query = base_query.filter(branch=branch_filter)
        
        # ===== COLLEGE LEVEL STATISTICS =====
        
        # Overall Summary
        total_results = base_query.count()
        total_students = base_query.values('roll_number').distinct().count()
        pass_count = base_query.filter(overall_result__iexact='pass').count()
        fail_count = base_query.filter(overall_result__iexact='fail').count()
        pass_percentage = round((pass_count / total_results * 100), 2) if total_results > 0 else 0
        
        # Regular vs Supplementary breakdown (count distinct students, not results)
        regular_query = base_query.filter(result_type='regular')
        regular_stats = {
            'total': regular_query.values('roll_number').distinct().count(),
            'pass': regular_query.filter(overall_result__iexact='pass').values('roll_number').distinct().count(),
            'fail': regular_query.filter(overall_result__iexact='fail').values('roll_number').distinct().count(),
        }
        regular_stats['pass_percentage'] = round((regular_stats['pass'] / regular_stats['total'] * 100), 2) if regular_stats['total'] > 0 else 0
        
        supplementary_query = base_query.filter(result_type='supplementary')
        supplementary_stats = {
            'total': supplementary_query.values('roll_number').distinct().count(),
            'pass': supplementary_query.filter(overall_result__iexact='pass').values('roll_number').distinct().count(),
            'fail': supplementary_query.filter(overall_result__iexact='fail').values('roll_number').distinct().count(),
        }
        supplementary_stats['pass_percentage'] = round((supplementary_stats['pass'] / supplementary_stats['total'] * 100), 2) if supplementary_stats['total'] > 0 else 0
        
        # Branch-wise Statistics (for college level)
        branch_stats = []
        branches = base_query.values('branch').distinct()
        
        for branch_data in branches:
            branch = branch_data['branch']
            branch_query = base_query.filter(branch=branch)
            
            # Overall for this branch
            branch_total = branch_query.count()
            branch_pass = branch_query.filter(overall_result__iexact='pass').count()
            branch_fail = branch_query.filter(overall_result__iexact='fail').count()
            branch_pass_pct = round((branch_pass / branch_total * 100), 2) if branch_total > 0 else 0
            
            # Regular for this branch
            branch_regular_total = branch_query.filter(result_type='regular').count()
            branch_regular_pass = branch_query.filter(result_type='regular', overall_result__iexact='pass').count()
            branch_regular_pass_pct = round((branch_regular_pass / branch_regular_total * 100), 2) if branch_regular_total > 0 else 0
            
            # Supplementary for this branch
            branch_supp_total = branch_query.filter(result_type='supplementary').count()
            branch_supp_pass = branch_query.filter(result_type='supplementary', overall_result__iexact='pass').count()
            branch_supp_pass_pct = round((branch_supp_pass / branch_supp_total * 100), 2) if branch_supp_total > 0 else 0
            
            branch_stats.append({
                'branch': branch.upper(),
                'total': branch_total,
                'pass': branch_pass,
                'fail': branch_fail,
                'pass_percentage': branch_pass_pct,
                'regular': {
                    'total': branch_regular_total,
                    'pass': branch_regular_pass,
                    'pass_percentage': branch_regular_pass_pct
                },
                'supplementary': {
                    'total': branch_supp_total,
                    'pass': branch_supp_pass,
                    'pass_percentage': branch_supp_pass_pct
                }
            })
        
        # Sort by branch name
        branch_stats.sort(key=lambda x: x['branch'])
        
        # ===== BRANCH LEVEL STATISTICS (Subject-wise) =====
        
        # Get all branches for subject-wise analysis
        subject_stats_by_branch = {}
        
        for branch_data in branches:
            branch = branch_data['branch']
            branch_results = base_query.filter(branch=branch)
            
            # Get all subjects for this branch
            subjects = Subject.objects.filter(result__in=branch_results)
            
            # Group by subject code
            subject_analysis = defaultdict(lambda: {
                'code': '', 'name': '', 
                'total': 0, 'pass': 0, 'fail': 0, 'absent': 0,
                'regular_total': 0, 'regular_pass': 0, 'regular_fail': 0,
                'supplementary_total': 0, 'supplementary_pass': 0, 'supplementary_fail': 0
            })
            
            for subject in subjects:
                code = subject.subject_code
                result_type = subject.result.result_type
                # Determine pass/fail based on grade (F = fail, others = pass)
                subject_grade = subject.grade.upper() if subject.grade else ""
                subject_result = "fail" if subject_grade == "F" else "pass"
                
                subject_analysis[code]['code'] = code
                subject_analysis[code]['name'] = subject.subject_name
                subject_analysis[code]['total'] += 1
                
                if subject_result == 'pass':
                    subject_analysis[code]['pass'] += 1
                elif subject_result == 'fail':
                    subject_analysis[code]['fail'] += 1
                elif subject_result == 'absent':
                    subject_analysis[code]['absent'] += 1
                
                # Track by result type
                if result_type == 'regular':
                    subject_analysis[code]['regular_total'] += 1
                    if subject_result == 'pass':
                        subject_analysis[code]['regular_pass'] += 1
                    elif subject_result == 'fail':
                        subject_analysis[code]['regular_fail'] += 1
                elif result_type == 'supplementary':
                    subject_analysis[code]['supplementary_total'] += 1
                    if subject_result == 'pass':
                        subject_analysis[code]['supplementary_pass'] += 1
                    elif subject_result == 'fail':
                        subject_analysis[code]['supplementary_fail'] += 1
            
            # Calculate percentages and convert to list
            subject_list = []
            for code, data in subject_analysis.items():
                data['pass_percentage'] = round((data['pass'] / data['total'] * 100), 2) if data['total'] > 0 else 0
                data['regular_pass_percentage'] = round((data['regular_pass'] / data['regular_total'] * 100), 2) if data['regular_total'] > 0 else 0
                data['supplementary_pass_percentage'] = round((data['supplementary_pass'] / data['supplementary_total'] * 100), 2) if data['supplementary_total'] > 0 else 0
                subject_list.append(data)
            
            # Sort by subject code
            subject_list.sort(key=lambda x: x['code'])
            subject_stats_by_branch[branch.upper()] = subject_list
        
        # Grade Distribution
        grade_distribution = {}
        grades = base_query.exclude(overall_grade='').values('overall_grade').annotate(count=Count('overall_grade'))
        for grade in grades:
            grade_distribution[grade['overall_grade']] = grade['count']
        
        return Response({
            'college_level': {
                'summary': {
                    'total_students': total_students,
                    'total_results': total_results,
                    'pass_count': pass_count,
                    'fail_count': fail_count,
                    'pass_percentage': pass_percentage
                },
                'regular_stats': regular_stats,
                'supplementary_stats': supplementary_stats,
                'branch_wise': branch_stats,
                'grade_distribution': grade_distribution
            },
            'branch_level': {
                'subject_wise': subject_stats_by_branch
            },
            'filters': {
                'result_type': result_type_filter,
                'branch': branch_filter
            }
        })
        
    except Exception as e:
        logger.error(f"Error getting statistics: {str(e)}")
        return Response({"error": str(e)}, status=500)


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def download_sample_template(request):
    if request.user.role != "admin":
        return Response({"error": "Admin only"}, status=403)
    try:
        import openpyxl
        from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
        
        wb = openpyxl.Workbook()
        ws = wb.active
        ws.title = "Results Template"
        
        # Headers with Credits and SGPA format (5 subjects)
        headers = [
            "Branch", "Result Type", "Roll Number", "Student Name",
            "Subject 1 Code", "Subject 1 Name", "Subject 1 Credits", "Subject 1 Internal", "Subject 1 External", 
            "Subject 1 Total", "Subject 1 Grade",
            "Subject 2 Code", "Subject 2 Name", "Subject 2 Credits", "Subject 2 Internal", "Subject 2 External",
            "Subject 2 Total", "Subject 2 Grade",
            "Subject 3 Code", "Subject 3 Name", "Subject 3 Credits", "Subject 3 Internal", "Subject 3 External",
            "Subject 3 Total", "Subject 3 Grade",
            "Subject 4 Code", "Subject 4 Name", "Subject 4 Credits", "Subject 4 Internal", "Subject 4 External",
            "Subject 4 Total", "Subject 4 Grade",
            "Subject 5 Code", "Subject 5 Name", "Subject 5 Credits", "Subject 5 Internal", "Subject 5 External",
            "Subject 5 Total", "Subject 5 Grade",
            "Total Marks", "SGPA"
        ]
        
        # Style header row
        header_fill = PatternFill(start_color="366092", end_color="366092", fill_type="solid")
        header_font = Font(bold=True, color="FFFFFF", size=11)
        border = Border(left=Side(style="thin"), right=Side(style="thin"), top=Side(style="thin"), bottom=Side(style="thin"))
        
        for col_num, header in enumerate(headers, start=1):
            cell = ws.cell(row=1, column=col_num, value=header)
            cell.font = header_font
            cell.fill = header_fill
            cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
            cell.border = border
            ws.column_dimensions[cell.column_letter].width = 15
        
        # Sample data
        sample = [
            "CSE", "Regular", "2021001", "Sample Student", 
            "CS101", "Data Structures", 4, 18, 65, 83, "A",
            "CS102", "Algorithms", 4, 20, 70, 90, "O",
            "CS103", "Databases", 3, 15, 50, 65, "B",
            "CS104", "Operating Systems", 4, 19, 68, 87, "A",
            "CS105", "Computer Networks", 3, 17, 62, 79, "A",
            404, 8.17
        ]
        
        for col_num, value in enumerate(sample, start=1):
            cell = ws.cell(row=2, column=col_num, value=value)
            cell.alignment = Alignment(horizontal="center", vertical="center")
            cell.border = border
        
        # Instructions sheet
        instructions_ws = wb.create_sheet("Instructions")
        instructions = [
            ["SPMVV Exam Results Upload Template - Instructions"],
            [""],
            ["IMPORTANT: This template uses Credits-based SGPA system"],
            [""],
            ["Column Descriptions:"],
            [""],
            ["1. Branch", "Student branch/department (e.g., CSE, ECE, IT)"],
            ["2. Result Type", "Type of exam: Regular / Supplementary"],
            ["3. Roll Number", "Student roll number (must be unique)"],
            ["4. Student Name", "Full name of the student"],
            [""],
            ["For each subject (up to 5 subjects):"],
            ["  - Subject Code", "Subject code (e.g., CS101)"],
            ["  - Subject Name", "Full subject name"],
            ["  - Subject Credits", "Number of credits (e.g., 3, 4)"],
            ["  - Subject Internal", "Internal marks obtained"],
            ["  - Subject External", "External marks obtained"],
            ["  - Subject Total", "Total marks (Internal + External)"],
            ["  - Subject Grade", "Grade: O, A, B, C, D, or F"],
            [""],
            ["Last two columns:"],
            ["  - Total Marks", "Sum of all subject total marks"],
            ["  - SGPA", "Semester Grade Point Average (auto-calculated)"],
            [""],
            ["Grade Point System:"],
            ["  O = 10 points"],
            ["  A = 9 points"],
            ["  B = 8 points"],
            ["  C = 7 points"],
            ["  D = 6 points"],
            ["  F = 0 points (Fail)"],
            [""],
            ["SGPA Calculation:"],
            ["  SGPA = (Grade1 x Credits1 + Grade2 x Credits2 + ...) / Total Credits"],
            ["  Example: Subject1(A grade, 4 credits) + Subject2(B grade, 3 credits)"],
            ["           SGPA = (9x4 + 8x3) / (4+3) = (36+24)/7 = 8.57"],
            [""],
            ["Pass Criteria:"],
            ["  Student PASSES if:"],
            ["    1. No F grade in any subject, AND"],
            ["    2. SGPA >= 6.0"],
            [""],
            ["  Student FAILS if:"],
            ["    1. F grade in one or more subjects, OR"],
            ["    2. SGPA < 6.0"],
            [""],
            ["Notes:"],
            ["  - You can add more subjects by repeating the subject columns pattern"],
            ["  - All fields are required except Total Marks and SGPA (auto-calculated)"],
            ["  - Credits should be positive integers (typically 3 or 4)"],
            ["  - Grades must be valid: O, A, B, C, D, F (case-insensitive)"],
            ["  - Internal and External marks should match your marking scheme"],
        ]
        
        # Style instructions
        title_font = Font(bold=True, size=14, color="FFFFFF")
        title_fill = PatternFill(start_color="366092", end_color="366092", fill_type="solid")
        header_font_inst = Font(bold=True, size=11)
        
        for row_num, instruction in enumerate(instructions, start=1):
            if row_num == 1:
                cell = instructions_ws.cell(row=row_num, column=1, value=instruction[0])
                cell.font = title_font
                cell.fill = title_fill
                cell.alignment = Alignment(horizontal="center", vertical="center")
                instructions_ws.merge_cells(f"A{row_num}:B{row_num}")
            elif len(instruction) == 2:
                cell1 = instructions_ws.cell(row=row_num, column=1, value=instruction[0])
                cell2 = instructions_ws.cell(row=row_num, column=2, value=instruction[1])
                if ":" not in instruction[0] and instruction[0] and not instruction[0].startswith(" "):
                    cell1.font = header_font_inst
            else:
                cell = instructions_ws.cell(row=row_num, column=1, value=instruction[0])
                if any(kw in instruction[0] for kw in ["Column", "Grade Point", "SGPA Calc", "Pass Crit", "Notes"]):
                    cell.font = header_font_inst
        
        instructions_ws.column_dimensions["A"].width = 30
        instructions_ws.column_dimensions["B"].width = 60
        
        response = HttpResponse(content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        response["Content-Disposition"] = "attachment; filename=SPMVV_Results_Template_Credits_SGPA.xlsx"
        wb.save(response)
        return response
    except Exception as e:
        return Response({"error": str(e)}, status=500)


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def get_audit_logs(request):
    if request.user.role != "admin":
        return Response({"error": "Admin only"}, status=403)
    try:
        logs = AuditLog.objects.select_related("user").order_by("-timestamp")[:50]
        log_data = [{"action_time": log.timestamp, "user": log.user.username if log.user else "Unknown", "action": log.get_action_display(), "object": log.details} for log in logs]
        return Response({"logs": log_data})
    except Exception as e:
        return Response({"error": str(e)}, status=500)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_users(request):
    """List all users (admin only)"""
    if not request.user.can_manage_users:
        return Response({'error': 'Permission denied'}, status=403)
    
    try:
        users = User.objects.all().order_by('role', 'username')
        users_data = [{
            'id': user.id,
            'username': user.username,
            'email': user.email,
            'first_name': user.first_name,
            'last_name': user.last_name,
            'role': user.role,
            'branch': user.branch,
            'department': user.department,
            'can_view_all_branches': user.can_view_all_branches,
            'can_manage_users': user.can_manage_users,
            'can_view_statistics': user.can_view_statistics,
            'can_upload_results': user.can_upload_results,
            'can_delete_results': user.can_delete_results,
            'is_active_user': user.is_active_user,
            'is_active': user.is_active,
            'date_joined': user.date_joined,
            'last_login': user.last_login,
        } for user in users]
        
        return Response({'users': users_data})
    except Exception as e:
        return Response({'error': str(e)}, status=500)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_user(request):
    """Create new user (admin only)"""
    if not request.user.can_manage_users:
        return Response({'error': 'Permission denied'}, status=403)
    
    try:
        data = request.data
        
        # Validate required fields
        required_fields = ['username', 'password', 'role']
        for field in required_fields:
            if not data.get(field):
                return Response({'error': f'{field} is required'}, status=400)
        
        # Check if username already exists
        if User.objects.filter(username=data['username']).exists():
            return Response({'error': 'Username already exists'}, status=400)
        
        # Create user
        user = User.objects.create_user(
            username=data['username'],
            password=data['password'],
            email=data.get('email', ''),
            first_name=data.get('first_name', ''),
            last_name=data.get('last_name', ''),
            role=data['role'],
            branch=data.get('branch'),
            department=data.get('department'),
            can_view_all_branches=data.get('can_view_all_branches', False),
            can_manage_users=data.get('can_manage_users', False),
            can_view_statistics=data.get('can_view_statistics', False),
            can_upload_results=data.get('can_upload_results', False),
            can_delete_results=data.get('can_delete_results', False),
            is_active_user=data.get('is_active_user', True),
        )
        
        return Response({
            'message': 'User created successfully',
            'user': {
                'id': user.id,
                'username': user.username,
                'role': user.role,
                'branch': user.branch,
            }
        }, status=201)
    except Exception as e:
        return Response({'error': str(e)}, status=500)


@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_user(request, user_id):
    """Update user details (admin only)"""
    if not request.user.can_manage_users:
        return Response({'error': 'Permission denied'}, status=403)
    
    try:
        user = User.objects.get(id=user_id)
        data = request.data
        
        # Update fields
        if 'email' in data:
            user.email = data['email']
        if 'first_name' in data:
            user.first_name = data['first_name']
        if 'last_name' in data:
            user.last_name = data['last_name']
        if 'role' in data:
            user.role = data['role']
        if 'branch' in data:
            user.branch = data['branch']
        if 'department' in data:
            user.department = data['department']
        if 'can_view_all_branches' in data:
            user.can_view_all_branches = data['can_view_all_branches']
        if 'can_manage_users' in data:
            user.can_manage_users = data['can_manage_users']
        if 'can_view_statistics' in data:
            user.can_view_statistics = data['can_view_statistics']
        if 'can_upload_results' in data:
            user.can_upload_results = data['can_upload_results']
        if 'can_delete_results' in data:
            user.can_delete_results = data['can_delete_results']
        if 'is_active_user' in data:
            user.is_active_user = data['is_active_user']
        if 'is_active' in data:
            user.is_active = data['is_active']
        
        user.save()
        
        return Response({
            'message': 'User updated successfully',
            'user': {
                'id': user.id,
                'username': user.username,
                'role': user.role,
                'branch': user.branch,
            }
        })
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)
    except Exception as e:
        return Response({'error': str(e)}, status=500)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def reset_user_password(request, user_id):
    """Reset user password (admin only)"""
    if not request.user.can_manage_users:
        return Response({'error': 'Permission denied'}, status=403)
    
    try:
        user = User.objects.get(id=user_id)
        new_password = request.data.get('new_password')
        
        if not new_password:
            return Response({'error': 'New password is required'}, status=400)
        
        user.set_password(new_password)
        user.failed_login_attempts = 0
        user.locked_until = None
        user.save()
        
        return Response({'message': f'Password reset successfully for user {user.username}'})
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)
    except Exception as e:
        return Response({'error': str(e)}, status=500)


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_user(request, user_id):
    """Delete user (admin only)"""
    if not request.user.can_manage_users:
        return Response({'error': 'Permission denied'}, status=403)
    
    try:
        user = User.objects.get(id=user_id)
        
        # Prevent deleting yourself
        if user.id == request.user.id:
            return Response({'error': 'Cannot delete your own account'}, status=400)
        
        # Prevent deleting the default admin account
        if user.username == 'admin' and user.role == 'admin':
            return Response({'error': 'Cannot delete the default admin account'}, status=400)
        
        username = user.username
        user.delete()
        
        return Response({'message': f'User {username} deleted successfully'})
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)
    except Exception as e:
        return Response({'error': str(e)}, status=500)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_permissions(request):
    """Get current user permissions and role"""
    user = request.user
    return Response({
        'username': user.username,
        'role': user.role,
        'branch': user.branch,
        'department': user.department,
        'can_view_all_branches': user.can_view_all_branches,
        'can_manage_users': user.can_manage_users,
        'is_active_user': user.is_active_user,
        'permissions': {
            'can_upload_results': user.role in ['admin'],
            'can_view_statistics': user.role in ['admin', 'principal', 'hod'],
            'can_delete_results': user.role in ['admin'],
            'can_manage_users': user.can_manage_users,
        }
    })


# ==================== CIRCULAR MANAGEMENT ====================

@api_view(["GET", "POST"])
@permission_classes([IsAuthenticated])
def manage_circulars(request):
    """Get all circulars or create new circular (Admin only can create)"""
    
    if request.method == "GET":
        # Students and admins can view
        circulars = Circular.objects.filter(is_active=True)
        
        # Filter by student year/branch if student
        if request.user.role == "student":
            # Get year from latest result (if available)
            result = Result.objects.filter(roll_number=request.user.roll_number).order_by('-year', '-semester').first()
            
            if result:
                # Filter by year: show circulars for their year or all years (NULL)
                circulars = circulars.filter(
                    Q(target_year=result.year) | Q(target_year__isnull=True)
                )
            
            # Filter by branch: use branch from user profile
            if request.user.branch:
                circulars = circulars.filter(
                    Q(target_branch__iexact=request.user.branch) | Q(target_branch__isnull=True)
                )
        
        circulars = circulars.order_by("-created_at")
        serializer = CircularSerializer(circulars, many=True, context={"request": request})
        
        return Response({
            "count": circulars.count(),
            "circulars": serializer.data
        })
    
    elif request.method == "POST":
        # Only admin can create
        if request.user.role != "admin":
            return Response({
                "error": "Only admins can create circulars"
            }, status=status.HTTP_403_FORBIDDEN)
        
        # Normalize target_branch to uppercase
        data = request.data.copy()
        if data.get("target_branch"):
            data["target_branch"] = data["target_branch"].strip().upper()
        
        serializer = CircularSerializer(data=data, context={"request": request})
        if serializer.is_valid():
            # Save with created_by
            circular = serializer.save(created_by=request.user)
            
            # Store original filename if attachment exists
            if "attachment" in request.FILES:
                file = request.FILES["attachment"]
                circular.attachment_name = file.name
                circular.save()
            
            # Create audit log
            create_audit_log(
                request.user,
                "circular_created",
                f"Created circular: {circular.title}",
                request
            )
            
            security_logger.info(f"Circular created by {request.user.username}: {circular.title}")
            
            return Response(
                CircularSerializer(circular, context={"request": request}).data,
                status=status.HTTP_201_CREATED
            )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["GET", "PUT", "DELETE"])
@permission_classes([IsAuthenticated])
def circular_detail(request, circular_id):
    """Get, update, or delete a specific circular"""
    
    try:
        circular = Circular.objects.get(id=circular_id)
    except Circular.DoesNotExist:
        return Response({
            "error": "Circular not found"
        }, status=status.HTTP_404_NOT_FOUND)
    
    if request.method == "GET":
        serializer = CircularSerializer(circular, context={"request": request})
        return Response(serializer.data)
    
    elif request.method == "PUT":
        # Only admin can update
        if request.user.role != "admin":
            return Response({
                "error": "Only admins can update circulars"
            }, status=status.HTTP_403_FORBIDDEN)
        
        # Normalize target_branch to uppercase
        data = request.data.copy()
        if data.get("target_branch"):
            data["target_branch"] = data["target_branch"].strip().upper()
        
        serializer = CircularSerializer(circular, data=data, partial=True, context={"request": request})
        if serializer.is_valid():
            updated_circular = serializer.save()
            
            # Update filename if new attachment
            if "attachment" in request.FILES:
                file = request.FILES["attachment"]
                updated_circular.attachment_name = file.name
                updated_circular.save()
            
            create_audit_log(
                request.user,
                "circular_updated",
                f"Updated circular: {updated_circular.title}",
                request
            )
            
            return Response(
                CircularSerializer(updated_circular, context={"request": request}).data
            )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == "DELETE":
        # Only admin can delete
        if request.user.role != "admin":
            return Response({
                "error": "Only admins can delete circulars"
            }, status=status.HTTP_403_FORBIDDEN)
        
        title = circular.title
        circular.delete()
        
        create_audit_log(
            request.user,
            "circular_deleted",
            f"Deleted circular: {title}",
            request
        )
        
        security_logger.info(f"Circular deleted by {request.user.username}: {title}")
        
        return Response({
            "message": "Circular deleted successfully"
        }, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_dashboard_stats(request):
    """Get dashboard statistics for admin overview"""
    try:
        from .models import Exam, HallTicket, Circular
        
        # Total exams count
        total_exams = Result.objects.values('exam_name').distinct().count()
        
        # Total hall tickets count
        total_hall_tickets = HallTicket.objects.count()
        
        # Active circulars count
        active_circulars = Circular.objects.filter(is_active=True).count()
        
        # Total users count (excluding superadmin)
        total_users = User.objects.filter(is_superuser=False).count()
        
        return Response({
            'total_exams': total_exams,
            'total_hall_tickets': total_hall_tickets,
            'active_circulars': active_circulars,
            'total_users': total_users
        })
    except Exception as e:
        logger.error(f"Error fetching dashboard stats: {str(e)}")
        return Response({
            'error': 'Failed to fetch dashboard statistics'
        }, status=500)


# ==================== STUDENT PROFILE ====================

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def student_profile(request):
    """Get or update student profile"""
    user = request.user

    if request.method == 'GET':
        from .models import StudentPhoto
        photo_url = None
        try:
            student_photo = StudentPhoto.objects.get(student=user)
            if student_photo.photo:
                photo_url = student_photo.photo.url  # relative URL; frontend builds absolute
        except StudentPhoto.DoesNotExist:
            pass

        return Response({
            'first_name': user.first_name or '',
            'last_name': user.last_name or '',
            'email': user.email or '',
            'roll_number': user.roll_number or '',
            'username': user.username,
            'profile_photo_url': photo_url,
        })

    elif request.method == 'PUT':
        first_name = request.data.get('first_name', '').strip()
        last_name = request.data.get('last_name', '').strip()
        email = request.data.get('email', '').strip()

        if not first_name:
            return Response({'error': 'First name is required'}, status=status.HTTP_400_BAD_REQUEST)

        if email and '@' not in email:
            return Response({'error': 'Please enter a valid email address'}, status=status.HTTP_400_BAD_REQUEST)

        user.first_name = first_name
        user.last_name = last_name
        user.email = email
        user.save(update_fields=['first_name', 'last_name', 'email'])

        create_audit_log(user, 'profile_updated', f"Student updated profile: {user.roll_number}", request)

        return Response({
            'message': 'Profile updated successfully',
            'first_name': user.first_name,
            'last_name': user.last_name,
            'email': user.email,
        })
