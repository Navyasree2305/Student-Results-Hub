from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinLengthValidator
import logging

security_logger = logging.getLogger('security')

class User(AbstractUser):
    ROLE_CHOICES = [
        ('admin', 'Admin'),
        ('dean', 'Dean'),
        ('vice_principal', 'Vice Principal'),
        ('principal', 'Principal'),
        ('hod', 'Head of Department'),
        ('faculty', 'Faculty'),
        ('staff', 'Staff'),
        ('student', 'Student'),
    ]
    
    # Basic Info
    role = models.CharField(max_length=30, choices=ROLE_CHOICES, default='student', help_text='User role (label only)')
    roll_number = models.CharField(max_length=50, unique=True, null=True, blank=True)
    branch = models.CharField(max_length=50, null=True, blank=True, help_text='Assigned branch (CSE, ECE, etc.) or NULL for all')
    department = models.CharField(max_length=100, null=True, blank=True, help_text='Department name')
    
    # ── Granular Permission Flags (feature × action) ────────────────────────────
    # Results
    results_upload           = models.BooleanField(default=False, help_text='Upload exam result Excel files')
    results_edit             = models.BooleanField(default=False, help_text='Edit individual subject marks')
    results_delete           = models.BooleanField(default=False, help_text='Delete uploaded exam results')
    results_download         = models.BooleanField(default=False, help_text='Download result Excel files')
    # Students
    students_view            = models.BooleanField(default=False, help_text='Search students and view academic history')
    students_detained_report = models.BooleanField(default=False, help_text='View detained students report')
    # Circulars
    circulars_view           = models.BooleanField(default=False, help_text='View circulars')
    circulars_create         = models.BooleanField(default=False, help_text='Create new circulars')
    circulars_edit           = models.BooleanField(default=False, help_text='Edit existing circulars')
    circulars_delete         = models.BooleanField(default=False, help_text='Delete circulars')
    # Timetable
    timetable_view           = models.BooleanField(default=False, help_text='View and download timetables')
    timetable_create         = models.BooleanField(default=False, help_text='Generate and manage timetables')
    # Hall Tickets
    halltickets_view         = models.BooleanField(default=False, help_text='View hall ticket exams and enrollments')
    halltickets_create       = models.BooleanField(default=False, help_text='Create/manage hall ticket exams and upload student lists')
    halltickets_generate     = models.BooleanField(default=False, help_text='Generate hall tickets')
    halltickets_download     = models.BooleanField(default=False, help_text='Download hall ticket PDFs')
    # Statistics
    statistics_view          = models.BooleanField(default=False, help_text='View statistics and reports dashboard')
    # Audit Logs
    auditlogs_view           = models.BooleanField(default=False, help_text='View security and activity audit logs')
    # User Management
    users_view               = models.BooleanField(default=False, help_text='View the user list')
    users_create             = models.BooleanField(default=False, help_text='Create new users')
    users_edit               = models.BooleanField(default=False, help_text='Edit users and assign permissions')
    users_delete             = models.BooleanField(default=False, help_text='Delete users')
    # Access Scope
    access_all_branches      = models.BooleanField(default=False, help_text='View data for all branches (overrides branch restriction)')
    
    # Account Status
    is_active_user = models.BooleanField(default=True, help_text='User account is active')
    failed_login_attempts = models.IntegerField(default=0)
    locked_until = models.DateTimeField(null=True, blank=True)
    
    groups = models.ManyToManyField(
        "auth.Group",
        verbose_name="groups",
        blank=True,
        related_name="custom_user_set",
        related_query_name="custom_user",
    )
    user_permissions = models.ManyToManyField(
        "auth.Permission",
        verbose_name="user permissions",
        blank=True,
        related_name="custom_user_set",
        related_query_name="custom_user",
    )
    
    class Meta:
        db_table = 'users'
    
    def __str__(self):
        return f"{self.username} ({self.role})"


class LoginAttempt(models.Model):
    username = models.CharField(max_length=150)
    ip_address = models.GenericIPAddressField()
    timestamp = models.DateTimeField(auto_now_add=True)
    success = models.BooleanField(default=False)
    
    class Meta:
        db_table = 'login_attempts'
        indexes = [
            models.Index(fields=['username', 'timestamp']),
            models.Index(fields=['ip_address', 'timestamp']),
        ]
    
    def __str__(self):
        return f"{self.username} - {self.timestamp} - {'Success' if self.success else 'Failed'}"


class Result(models.Model):
    RESULT_TYPE_CHOICES = [
        ('regular', 'Regular'),
        ('supplementary', 'Supplementary'),
        ('both', 'Regular and Supplementary'),
    ]
    
    COURSE_CHOICES = [
        ('btech', 'B.Tech'),
        ('mtech', 'M.Tech'),
    ]
    
    BRANCH_CHOICES = [
        ("cse", "Computer Science & Engineering"),
        ("ece", "Electronics & Communication Engineering"),
        ("eee", "Electrical & Electronics Engineering"),
        ("mech", "Mechanical Engineering"),
        ("civil", "Civil Engineering"),
        ("it", "Information Technology"),
        ("chemical", "Chemical Engineering"),
        ("biotechnology", "Biotechnology"),
        ("mba", "MBA"),
        ("mca", "MCA"),
    ]
    
    student = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='results', help_text='Student user (optional, for portal login)')
    roll_number = models.CharField(max_length=50, db_index=True)
    
    student_name = models.CharField(max_length=200)
    year = models.IntegerField(default=1, help_text='Academic year: 1, 2, 3, or 4')
    semester = models.IntegerField(help_text='Semester: 1 or 2')
    exam_name = models.CharField(max_length=300, default='Exam Results', help_text='Auto-generated exam name')
    exam_held_date = models.DateField(null=True, blank=True, help_text='Date when exam was held')
    result_type = models.CharField(max_length=20, choices=RESULT_TYPE_CHOICES)
    course = models.CharField(max_length=10, choices=COURSE_CHOICES, default='btech', help_text='Course: B.Tech or M.Tech')
    branch = models.CharField(max_length=50, choices=BRANCH_CHOICES, default="cse", help_text="Branch/Department")
    overall_result = models.CharField(max_length=50, blank=True)
    overall_grade = models.CharField(max_length=10, blank=True)
    total_marks = models.IntegerField(null=True, blank=True, help_text='Total marks obtained')
    sgpa = models.DecimalField(max_digits=4, decimal_places=2, null=True, blank=True, help_text='Semester Grade Point Average')
    completion_date = models.DateField(null=True, blank=True, help_text='Date when student passed all subjects (no pending subjects)')
    uploaded_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='uploaded_results')
    uploaded_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'results'
        unique_together = ['roll_number', 'exam_name']
        indexes = [
            models.Index(fields=['roll_number', 'year', 'semester']),
            models.Index(fields=['uploaded_at']),
            models.Index(fields=['exam_name']),
        ]
    
    def __str__(self):
        return f"{self.roll_number} - Year {self.year} Semester {self.semester}"


class Subject(models.Model):
    result = models.ForeignKey(Result, on_delete=models.CASCADE, related_name='subjects')
    subject_code = models.CharField(max_length=50)
    subject_name = models.CharField(max_length=200)
    subject_type = models.CharField(max_length=20, default='Theory', choices=[('Theory', 'Theory'), ('Lab', 'Lab')], help_text='Subject type')
    credits = models.IntegerField(null=True, blank=True, help_text='Subject credits')
    internal_marks = models.IntegerField(null=True, blank=True)
    external_marks = models.IntegerField(null=True, blank=True)
    total_marks = models.IntegerField(null=True, blank=True)
    grade = models.CharField(max_length=10, blank=True)
    attempts = models.IntegerField(default=1, help_text="Number of attempts for this subject")
    
    class Meta:
        db_table = 'subjects'
        indexes = [
            models.Index(fields=['subject_code']),
        ]
    
    def __str__(self):
        return f"{self.subject_code} - {self.subject_name}"


class AuditLog(models.Model):
    ACTION_CHOICES = [
        ('login', 'Login'),
        ('logout', 'Logout'),
        ('password_change', 'Password Change'),
        ('result_upload', 'Result Upload'),
        ('result_view', 'Result View'),
        ('result_edit', 'Result Edit'),
        ('result_delete', 'Result Delete'),
        ('result_delete_exam', 'Result Delete Exam'),
        ('user_registration', 'User Registration'),
        ('consolidated_result_view', 'Consolidated Result View'),
        ('circular_created', 'Circular Created'),
        ('circular_updated', 'Circular Updated'),
        ('circular_deleted', 'Circular Deleted'),
        ('profile_updated', 'Profile Updated'),
        # Hall ticket audit actions
        ('exam_created', 'Exam Created'),
        ('exam_updated', 'Exam Updated'),
        ('exam_deleted', 'Exam Deleted'),
        ('subject_added', 'Subject Added'),
        ('subject_updated', 'Subject Updated'),
        ('subject_deleted', 'Subject Deleted'),
        ('student_list_uploaded', 'Student List Uploaded'),
        ('hall_tickets_generated', 'Hall Tickets Generated'),
        ('hall_ticket_downloaded', 'Hall Ticket Downloaded'),
        ('bulk_hall_tickets_downloaded', 'Bulk Hall Tickets Downloaded'),
        ('photo_uploaded', 'Photo Uploaded'),
        ('photo_updated', 'Photo Updated'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    action = models.CharField(max_length=50, choices=ACTION_CHOICES)
    details = models.TextField(blank=True)
    ip_address = models.GenericIPAddressField(null=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    session_id = models.CharField(max_length=64, null=True, blank=True, db_index=True, help_text='Login session identifier to group audit events per session')
    
    class Meta:
        db_table = 'audit_logs'
        indexes = [
            models.Index(fields=['user', 'timestamp']),
            models.Index(fields=['action', 'timestamp']),
            models.Index(fields=['session_id']),
        ]
    
    def __str__(self):
        return f"{self.user} - {self.action} - {self.timestamp}"



class BlacklistedToken(models.Model):
    token = models.TextField(unique=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='blacklisted_tokens')
    blacklisted_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'blacklisted_tokens'
        indexes = [
            models.Index(fields=['token']),
            models.Index(fields=['blacklisted_at']),
        ]
    
    def __str__(self):
        return f"{self.user.username} - {self.blacklisted_at}"


class Notification(models.Model):
    student = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    result = models.ForeignKey(Result, on_delete=models.CASCADE, related_name='notifications', null=True, blank=True)
    message = models.TextField()
    exam_name = models.CharField(max_length=300, blank=True)
    results_published_date = models.DateField(null=True, blank=True)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'notifications'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['student', 'is_read', 'created_at']),
        ]
    
    def __str__(self):
        return f"{self.student.username} - {self.message[:50]}"


class Circular(models.Model):
    """Model for admin circulars/notifications with file attachments"""
    CATEGORY_CHOICES = [
        ("general", "General Notification"),
        ("exam", "Exam Related"),
        ("academic", "Academic"),
        ("admission", "Admission"),
        ("event", "Event/Activity"),
        ("urgent", "Urgent"),
    ]
    
    title = models.CharField(max_length=300, help_text="Circular title")
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES, default="general")
    description = models.TextField(help_text="Detailed description/message")
    
    # File attachment (PDF/Images)
    attachment = models.FileField(
        upload_to="circulars/%Y/%m/",
        null=True,
        blank=True,
        help_text="Attach PDF, JPG, JPEG, PNG files"
    )
    attachment_name = models.CharField(max_length=255, blank=True, help_text="Original filename")
    
    # Visibility
    is_active = models.BooleanField(default=True, help_text="Show to students")
    target_year = models.IntegerField(null=True, blank=True, help_text="Target specific year (1,2,3,4) or NULL for all")
    target_branch = models.CharField(max_length=50, null=True, blank=True, help_text="Target specific branch or NULL for all")
    target_audience = models.CharField(
        max_length=20,
        choices=[("all", "All (Students + Staff)"), ("students", "Students Only"), ("staff", "Staff Only")],
        default="all",
        help_text="Who should receive this circular"
    )
    
    # Metadata
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name="circulars")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = "circulars"
        ordering = ["-created_at"]
        indexes = [
            models.Index(fields=["-created_at", "is_active"]),
            models.Index(fields=["category", "is_active"]),
        ]
    
    def __str__(self):
        return f"{self.title} ({self.category})"
    
    def get_file_extension(self):
        """Get file extension"""
        if self.attachment:
            return self.attachment.name.split(".")[-1].lower()
        return None
    
    def is_pdf(self):
        """Check if attachment is PDF"""
        return self.get_file_extension() == "pdf"
    
    def is_image(self):
        """Check if attachment is image"""
        ext = self.get_file_extension()
        return ext in ["jpg", "jpeg", "png", "gif"]


# ==================== HALL TICKET MODELS ====================

class Exam(models.Model):
    """Model for exam definitions"""
    exam_name = models.CharField(max_length=300, help_text='Full exam name')
    year = models.CharField(max_length=10, help_text='Year (I, II, III, IV)')
    semester = models.CharField(max_length=10, help_text='Semester (I, II)')
    course = models.CharField(max_length=50, default='B.Tech', help_text='Course (B.Tech, M.Tech)')
    branch = models.CharField(max_length=100, blank=True, help_text='Branch/Department (optional)')
    exam_center = models.CharField(max_length=200, default='SPMVV, Tirupati', help_text='Examination center')
    exam_start_time = models.TimeField(default='09:00', help_text='Exam start time')
    exam_end_time = models.TimeField(default='12:00', help_text='Exam end time')
    instructions = models.TextField(blank=True, help_text='General instructions')
    is_active = models.BooleanField(default=True, help_text='Is exam active')
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='created_exams')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'hall_ticket_exams'
        ordering = ['-created_at']
    
    def __str__(self):
        return self.exam_name


class ExamSubject(models.Model):
    """Model for exam subjects"""
    exam = models.ForeignKey(Exam, on_delete=models.CASCADE, related_name='subjects')
    subject_code = models.CharField(max_length=50, help_text='Subject code')
    subject_name = models.CharField(max_length=200, help_text='Subject name')
    subject_type = models.CharField(max_length=20, default='Theory', choices=[('Theory', 'Theory'), ('Lab', 'Lab')], help_text='Subject type')
    exam_date = models.DateField(null=True, blank=True, help_text='Date of examination (required for Theory, optional for Lab)')
    exam_time = models.TimeField(default='10:00', help_text='Exam start time')
    duration = models.CharField(max_length=50, default='3 hours', help_text='Exam duration')
    order = models.IntegerField(default=1, help_text='Display order in hall ticket')
    
    class Meta:
        db_table = 'hall_ticket_exam_subjects'
        ordering = ['exam', 'order', 'exam_date']
        unique_together = ['exam', 'subject_code']
    
    def __str__(self):
        return f"{self.subject_code} - {self.subject_name}"


class StudentPhoto(models.Model):
    """Model for student photos for hall tickets"""
    student = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True, related_name='hall_ticket_photo')
    roll_number = models.CharField(max_length=50, unique=True, db_index=True)
    photo = models.ImageField(upload_to='hall_ticket_photos/', help_text='Student photograph')
    consent_given = models.BooleanField(default=False, help_text='Consent to use photo')
    consent_text = models.TextField(default='I hereby give consent to use my photograph for hall ticket generation')
    consent_date = models.DateTimeField(null=True, blank=True)
    uploaded_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'hall_ticket_student_photos'
    
    def __str__(self):
        return f"Photo - {self.roll_number}"


class ExamEnrollment(models.Model):
    """Model for student exam enrollments"""
    exam = models.ForeignKey(Exam, on_delete=models.CASCADE, related_name='enrollments')
    student = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='exam_enrollments')
    roll_number = models.CharField(max_length=50, db_index=True)
    student_name = models.CharField(max_length=200)
    branch = models.CharField(max_length=100, blank=True)
    enrolled_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'hall_ticket_enrollments'
        unique_together = ['exam', 'roll_number']
    
    def __str__(self):
        return f"{self.roll_number} - {self.exam.exam_name}"


class HallTicket(models.Model):
    """Model for generated hall tickets"""
    enrollment = models.OneToOneField(ExamEnrollment, on_delete=models.CASCADE, related_name='hall_ticket')
    exam = models.ForeignKey(Exam, on_delete=models.CASCADE, related_name='hall_tickets')
    student = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='hall_tickets')
    hall_ticket_number = models.CharField(max_length=50, unique=True, db_index=True)
    qr_code_data = models.CharField(max_length=500, default='')
    status = models.CharField(max_length=20, default='generated')
    download_count = models.IntegerField(default=0)
    generated_at = models.DateTimeField(auto_now_add=True)
    downloaded_at = models.DateTimeField(null=True, blank=True)
    generated_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='generated_hall_tickets')
    pdf_file = models.FileField(upload_to='hall_tickets/%Y/%m/', null=True, blank=True)
    
    class Meta:
        db_table = 'hall_tickets'
    
    def __str__(self):
        return f"Hall Ticket - {self.hall_ticket_number}"