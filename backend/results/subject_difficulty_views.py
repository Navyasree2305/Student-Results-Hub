"""
Subject Difficulty Analyzer - Django API Views
Provides REST endpoints for the ML-powered subject difficulty analysis.
"""

from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .subject_difficulty_ml import get_subject_difficulty_analysis
import logging

logger = logging.getLogger("django")


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def subject_difficulty_analysis(request):
    """
    GET /api/subject-difficulty/

    Returns ML-powered subject difficulty analysis with rankings,
    predicted pass rates, and grade distributions.

    Query params:
        branch  - filter by branch (e.g. 'cse', 'ece') or 'all'
        year    - filter by year (1-4) or 'all'
        semester - filter by semester (1 or 2) or 'all'
        course  - filter by course ('btech', 'mtech') or 'all'
        exam_name - filter by specific exam name
    """
    # Permission check: admin or statistics_view permission
    if not (request.user.role == "admin" or request.user.statistics_view):
        return Response(
            {"error": "Permission denied. You need statistics_view permission."},
            status=status.HTTP_403_FORBIDDEN,
        )

    try:
        # Apply user branch restrictions
        user = request.user
        branch_filter = request.GET.get("branch", "all")

        if user.branch and not user.access_all_branches:
            branch_filter = user.branch

        filters = {
            "branch_filter": branch_filter,
            "year_filter": request.GET.get("year", "all"),
            "semester_filter": request.GET.get("semester", "all"),
            "course_filter": request.GET.get("course", "all"),
            "exam_name_filter": request.GET.get("exam_name", None),
        }

        result = get_subject_difficulty_analysis(**filters)
        return Response(result, status=status.HTTP_200_OK)

    except Exception as e:
        logger.error(f"Subject difficulty analysis error: {e}")
        return Response(
            {"error": f"Analysis failed: {str(e)}"},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR,
        )
