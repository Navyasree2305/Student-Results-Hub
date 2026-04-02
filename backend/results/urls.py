from django.urls import path
from . import views
from . import student_management
from . import hall_ticket_views
from . import timetable_views
from . import subject_difficulty_views

urlpatterns = [
    # Authentication endpoints
    path('register/', views.register_student, name='register_student'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('change-password/', views.change_password, name='change_password'),
    
    # Result management endpoints
    path('results/upload/', views.upload_results, name='upload_results'),
    path('results/all/', views.get_results, name='get_all_results'),
    path("results/consolidated/", views.get_consolidated_results, name="get_consolidated_results"),
    path('results/', views.get_results, name='get_results'),
    
    # Exam management endpoints
    path('exams/', views.get_uploaded_exams, name='get_uploaded_exams'),
    path('exams/<str:exam_name>/download/', views.download_exam_results, name='download_exam_results'),
    path('exams/<str:exam_name>/delete/', views.delete_exam_results, name='delete_exam_results'),
    
    # Admin dashboard endpoints
    path('statistics/', views.get_statistics, name='statistics'),
    path('dashboard-stats/', views.get_dashboard_stats, name='dashboard_stats'),
    path('sample-template/', views.download_sample_template, name='sample_template'),
    path('audit-logs/', views.get_audit_logs, name='audit_logs'),
    
    # Notification endpoints
    path('notifications/', views.get_notifications, name='get_notifications'),
    path('notifications/<int:notification_id>/read/', views.mark_notification_read, name='mark_notification_read'),
    path("notifications/combined/", views.get_combined_notifications, name="get_combined_notifications"),
    
    # Student management endpoints
    path('students/search/', student_management.search_student, name='search_student'),
    path('students/<str:roll_number>/history/', student_management.get_student_history, name='get_student_history'),
    path('semesters/<int:result_id>/subjects/', student_management.get_semester_subjects, name='get_semester_subjects'),
    path('subjects/<int:subject_id>/update/', student_management.update_subject_marks, name='update_subject_marks'),

    # User management endpoints (admin only)
    path('users/', views.list_users, name='list_users'),
    path('users/create/', views.create_user, name='create_user'),
    path('users/<int:user_id>/update/', views.update_user, name='update_user'),
    path('users/<int:user_id>/reset-password/', views.reset_user_password, name='reset_user_password'),
    path('users/<int:user_id>/delete/', views.delete_user, name='delete_user'),
    path('users/permissions/', views.get_user_permissions, name='get_user_permissions'),

    # Circular management endpoints
    path('circulars/', views.manage_circulars, name='manage_circulars'),
    path('circulars/<int:circular_id>/', views.circular_detail, name='circular_detail'),

    # Health check endpoint
    path('health/', views.health_check, name='health_check'),
    # ML-powered Subject Difficulty Analyzer
    path("subject-difficulty/", subject_difficulty_views.subject_difficulty_analysis, name="subject_difficulty"),
    path('timetable/generate/', timetable_views.generate_timetable, name='timetable_generate'),
    path('timetable/download/', timetable_views.download_timetable, name='timetable_download'),
    path('timetable/template/', timetable_views.timetable_sample_template, name='timetable_template'),
    path('timetable/download-all/', timetable_views.download_all_timetable, name='timetable_download_all'),
    path('timetable/download-faculty/', timetable_views.download_faculty_timetable, name='timetable_download_faculty'),
    path('timetable/download-faculty-all/', timetable_views.download_all_faculty_timetables, name='timetable_download_faculty_all'),
    path('detained-students/', views.get_detained_students, name='detained_students'),
    path('exam-month-years/', views.get_exam_month_years, name='exam_month_years'),
    path('profile/', views.student_profile, name='student_profile'),
    
    # ==================== HALL TICKET MANAGEMENT ====================
    
    # Exam management
    path("hall-tickets/exams/", hall_ticket_views.manage_exams, name="manage_hall_ticket_exams"),
    path("hall-tickets/exams/<int:exam_id>/", hall_ticket_views.exam_detail, name="hall_ticket_exam_detail"),
    
    # Subject management
    path("hall-tickets/exams/<int:exam_id>/subjects/", hall_ticket_views.add_exam_subject, name="add_exam_subject"),
    path("hall-tickets/subjects/<int:subject_id>/", hall_ticket_views.update_exam_subject, name="update_exam_subject"),
    path("hall-tickets/subjects/<int:subject_id>/delete/", hall_ticket_views.delete_exam_subject, name="delete_exam_subject"),
    
    # Student enrollment
    path("hall-tickets/exams/<int:exam_id>/upload-students/", hall_ticket_views.upload_student_list, name="upload_student_list"),
    path("hall-tickets/exams/<int:exam_id>/enrollments/", hall_ticket_views.list_enrollments, name="list_enrollments"),
    
    # Student photo upload
    path("hall-tickets/photo/upload/", hall_ticket_views.upload_student_photo, name="upload_student_photo"),
    path("hall-tickets/photo/", hall_ticket_views.get_student_photo, name="get_student_photo"),
    
    # Hall ticket generation and management
    path("hall-tickets/exams/<int:exam_id>/generate/", hall_ticket_views.generate_hall_tickets, name="generate_hall_tickets"),
    path("hall-tickets/exams/<int:exam_id>/tickets/", hall_ticket_views.list_hall_tickets, name="list_hall_tickets"),
    path("hall-tickets/<int:ticket_id>/download/", hall_ticket_views.download_hall_ticket, name="download_hall_ticket"),
    path("hall-tickets/exams/<int:exam_id>/download-all/", hall_ticket_views.download_all_hall_tickets, name="download_all_hall_tickets"),
    path("hall-tickets/my-tickets/", hall_ticket_views.view_hall_ticket, name="view_hall_ticket"),
    
    # Sample template
    path("hall-tickets/sample-template/", hall_ticket_views.download_sample_template, name="download_hall_ticket_sample_template"),
    path("hall-tickets/supplementary/generate/", hall_ticket_views.generate_supplementary_hall_tickets, name="generate_supplementary_hall_tickets"),
]
