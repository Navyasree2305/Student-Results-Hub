"""
Student Results Management API Views
"""

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.db import models
from .models import Result, Subject, AuditLog
from .views import get_client_ip
import logging

logger = logging.getLogger(__name__)

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def search_student(request):
    if not (request.user.role == "admin" or request.user.can_search_students):
        return Response({"error": "Admin only"}, status=403)
    try:
        query = request.GET.get("q", "").strip()
        if not query:
            return Response({"error": "Search query is required"}, status=400)
        results = Result.objects.filter(roll_number__icontains=query).values("roll_number", "student_name", "course", "branch").distinct()
        students = []
        seen = set()
        for result in results:
            roll = result["roll_number"]
            if roll not in seen:
                seen.add(roll)
                students.append({"roll_number": roll, "student_name": result["student_name"], "course": dict(Result.COURSE_CHOICES).get(result["course"], result["course"]), "branch": dict(Result.BRANCH_CHOICES).get(result["branch"], result["branch"])})
        return Response({"students": students})
    except Exception as e:
        logger.error(f"Error searching students: {str(e)}")
        return Response({"error": str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_student_history(request, roll_number):
    """Get complete history of results for a student. Each exam is shown separately."""
    if not (request.user.role == 'admin' or request.user.can_search_students):
        return Response({'error': 'Admin only'}, status=403)
    
    try:
        results = Result.objects.filter(
            roll_number=roll_number
        ).select_related('student').prefetch_related('subjects').order_by(
            'year', 'semester', 'uploaded_at'
        )
        
        if not results.exists():
            return Response({'error': 'No results found for this roll number'}, status=404)
        
        first_result = results.first()
        student_info = {
            'roll_number': roll_number,
            'student_name': first_result.student_name,
            'course': first_result.get_course_display(),
            'branch': first_result.get_branch_display()
        }
        
        # Count exams per year/semester for attempt count
        exam_counts = {}
        for result in results:
            key = (result.year, result.semester)
            exam_counts[key] = exam_counts.get(key, 0) + 1
        
        # ----------------------------------------------------------------
        # Build per-attempt entries AND compute consolidated_sgpa per
        # year/semester group (latest grade per subject across all attempts)
        # ----------------------------------------------------------------
        PASS_GRADES = {'O', 'A', 'B', 'C', 'D'}
        GRADE_POINTS = {'O': 10, 'A': 9, 'B': 8, 'C': 7, 'D': 6, 'F': 0}

        # Step 1: collect all results keyed by (year, semester) in upload order
        group_results = {}
        for result in results:
            key = (result.year, result.semester)
            if key not in group_results:
                group_results[key] = []
            group_results[key].append(result)

        # Step 2: for each group compute consolidated view
        consolidated_info = {}  # key -> {consolidated_sgpa, consolidated_result, consolidated_pending, consolidated_pending_names, consolidated_earned_credits}
        for key, group in group_results.items():
            # Walk attempts in upload order; keep latest grade per subject_code
            latest_grade = {}   # subject_code -> (grade, credits, subject_name)
            for r in sorted(group, key=lambda x: x.uploaded_at):
                for subj in r.subjects.all():
                    code = subj.subject_code or subj.subject_name
                    latest_grade[code] = (
                        (subj.grade or '').strip().upper(),
                        subj.credits or 0,
                        subj.subject_name
                    )
            # Compute consolidated SGPA
            total_credits_c = 0
            weighted_sum_c = 0
            pending_c = 0
            pending_names_c = []
            earned_credits_c = 0
            for code, (grade, credits, name) in latest_grade.items():
                if credits and grade in GRADE_POINTS:
                    total_credits_c += credits
                    weighted_sum_c += GRADE_POINTS[grade] * credits
                if grade in PASS_GRADES:
                    earned_credits_c += credits
                if grade == 'F':
                    pending_c += 1
                    pending_names_c.append(name)
            cons_sgpa = round(weighted_sum_c / total_credits_c, 2) if total_credits_c > 0 else None
            cons_result = 'Pass' if pending_c == 0 and cons_sgpa is not None and cons_sgpa >= 6.0 else 'Fail'
            consolidated_info[key] = {
                'consolidated_sgpa': cons_sgpa,
                'consolidated_result': cons_result,
                'consolidated_pending': pending_c,
                'consolidated_pending_names': pending_names_c,
                'consolidated_earned_credits': earned_credits_c,
            }

        # Step 3: build per-attempt entries as before, injecting consolidated fields
        semester_summary = []
        for result in results:
            subjects = result.subjects.all()
            total_subjects = subjects.count()
            pending_subjects = 0
            pending_subject_names = []
            total_credits = 0
            earned_credits = 0

            for subject in subjects:
                cr = subject.credits or 0
                total_credits += cr
                if subject.grade and subject.grade.upper() in PASS_GRADES:
                    earned_credits += cr
                if subject.grade and subject.grade.upper() == 'F':
                    pending_subjects += 1
                    pending_subject_names.append(subject.subject_name)

            overall_result = result.overall_result if result.overall_result else ('Pass' if pending_subjects == 0 else 'Fail')
            key = (result.year, result.semester)
            num_attempts = exam_counts[key]
            completion_date_str = result.completion_date.strftime('%Y-%m-%d') if result.completion_date else None
            cons = consolidated_info[key]

            semester_summary.append({
                'year': result.year,
                'semester': result.semester,
                'result_id': result.id,
                'exam_name': result.exam_name,
                'result_type': result.get_result_type_display(),
                'total_marks': result.total_marks,
                'sgpa': float(result.sgpa) if result.sgpa else None,
                'overall_result': overall_result,
                'overall_grade': result.overall_grade or '',
                'total_subjects': total_subjects,
                'total_credits': total_credits,
                'earned_credits': earned_credits,
                'pending_subjects': pending_subjects,
                'pending_subject_names': pending_subject_names,
                'num_attempts': num_attempts,
                'completion_date': completion_date_str,
                'uploaded_at': result.uploaded_at.strftime('%Y-%m-%d %H:%M:%S'),
                # Consolidated fields (same value for all attempts in the same group)
                'consolidated_sgpa': cons['consolidated_sgpa'],
                'consolidated_result': cons['consolidated_result'],
                'consolidated_pending': cons['consolidated_pending'],
                'consolidated_pending_names': cons['consolidated_pending_names'],
                'consolidated_earned_credits': cons['consolidated_earned_credits'],
            })
        
        return Response({'student_info': student_info, 'semester_summary': semester_summary})
    except Exception as e:
        logger.error(f'Error getting student history for {roll_number}: {str(e)}')
        return Response({'error': str(e)}, status=500)



@api_view(["GET"])
@permission_classes([IsAuthenticated])
def get_semester_subjects(request, result_id):
    """Get subjects for a SPECIFIC exam (result_id). Each exam is independent."""  
    if not (request.user.role == "admin" or request.user.can_search_students or request.user.can_edit_results):
        return Response({"error": "Admin only"}, status=403)
    try:
        result = Result.objects.get(id=result_id)
        
        # Get subjects for THIS specific exam only (no consolidation)
        subjects = result.subjects.all().order_by("subject_code")
        
        subject_details = []
        for subject in subjects:
            subject_details.append({
                "id": subject.id,
                "subject_code": subject.subject_code,
                "subject_name": subject.subject_name,
                "credits": subject.credits,
                "total_marks": subject.total_marks,
                "grade": subject.grade
            })
        
        semester_info = {
            "roll_number": result.roll_number,
            "student_name": result.student_name,
            "year": result.year,
            "semester": result.semester,
            "exam_name": result.exam_name,
            "result_type": result.get_result_type_display(),
            "overall_result": result.overall_result,
            "total_marks": result.total_marks,
            "sgpa": float(result.sgpa) if result.sgpa else None
        }
        return Response({"semester_info": semester_info, "subjects": subject_details})
    except Result.DoesNotExist:
        return Response({"error": "Result not found"}, status=404)
    except Exception as e:
        logger.error(f"Error getting semester subjects for result {result_id}: {str(e)}")
        return Response({"error": str(e)}, status=500)

@api_view(["PUT"])
@permission_classes([IsAuthenticated])
def update_subject_marks(request, subject_id):
    if not (request.user.role == "admin" or request.user.can_edit_results):
        return Response({"error": "Admin only"}, status=403)
    try:
        subject = Subject.objects.select_related("result").get(id=subject_id)
        internal_marks = request.data.get("internal_marks")
        external_marks = request.data.get("external_marks")
        total_marks = request.data.get("total_marks")
        grade = request.data.get("grade", "").strip().upper()

        valid_grades = ["O", "A", "B", "C", "D", "F", "AB"]  # AB = absent
        if grade and grade not in valid_grades:
            return Response({"error": f"Invalid grade. Must be one of: {', '.join(valid_grades)}"}, status=400)

        if internal_marks is not None:
            subject.internal_marks = internal_marks
        if external_marks is not None:
            subject.external_marks = external_marks
        if total_marks is not None:
            subject.total_marks = total_marks

        # Track attempts: if subject was previously failed (grade F) and is now passing
        prev_grade = (subject.grade or "").strip().upper()
        if prev_grade == "F" and grade and grade != "F":
            subject.attempts += 1

        subject.grade = grade
        subject.save()

        result = subject.result
        all_subjects = result.subjects.all()
        # Determine pass/fail: any subject with grade F means overall fail
        failed_count = all_subjects.filter(grade__iexact="F").count()
        if failed_count == 0:
            result.overall_result = "Pass"
            result.save()

        AuditLog.objects.create(
            user=request.user,
            action="result_edit",
            details=f"Updated marks for {subject.subject_code} - {result.roll_number} Year {result.year} Sem {result.semester}",
            ip_address=get_client_ip(request)
        )
        subject_result_display = "Fail" if grade == "F" else ("Absent" if grade == "AB" else "Pass")
        return Response({
            "message": "Subject marks updated successfully",
            "subject": {
                "id": subject.id,
                "subject_code": subject.subject_code,
                "subject_name": subject.subject_name,
                "internal_marks": subject.internal_marks,
                "external_marks": subject.external_marks,
                "total_marks": subject.total_marks,
                "subject_result": subject_result_display,
                "grade": subject.grade,
                "attempts": subject.attempts
            },
            "overall_result_updated": failed_count == 0
        })
    except Subject.DoesNotExist:
        return Response({"error": "Subject not found"}, status=404)
    except Exception as e:
        logger.error(f"Error updating subject marks for subject {subject_id}: {str(e)}")
        return Response({"error": str(e)}, status=500)

