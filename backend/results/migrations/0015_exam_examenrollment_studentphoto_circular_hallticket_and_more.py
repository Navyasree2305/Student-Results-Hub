# Rewritten to match current models.py exactly (fixes Windows fresh-install schema mismatch)
from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):
    dependencies = [
        ("results", "0014_update_for_credits_and_sgpa"),
    ]

    operations = [
        migrations.CreateModel(
            name="Exam",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "exam_name",
                    models.CharField(help_text="Full exam name", max_length=300),
                ),
                (
                    "year",
                    models.CharField(help_text="Year (I, II, III, IV)", max_length=10),
                ),
                (
                    "semester",
                    models.CharField(help_text="Semester (I, II)", max_length=10),
                ),
                (
                    "course",
                    models.CharField(
                        default="B.Tech",
                        help_text="Course (B.Tech, M.Tech)",
                        max_length=50,
                    ),
                ),
                (
                    "branch",
                    models.CharField(
                        blank=True,
                        help_text="Branch/Department (optional)",
                        max_length=100,
                    ),
                ),
                (
                    "exam_center",
                    models.CharField(
                        default="Main Campus",
                        help_text="Examination center",
                        max_length=200,
                    ),
                ),
                (
                    "exam_start_time",
                    models.TimeField(default="09:00", help_text="Exam start time"),
                ),
                (
                    "exam_end_time",
                    models.TimeField(default="12:00", help_text="Exam end time"),
                ),
                (
                    "instructions",
                    models.TextField(blank=True, help_text="General instructions"),
                ),
                (
                    "is_active",
                    models.BooleanField(default=True, help_text="Is exam active"),
                ),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                ("updated_at", models.DateTimeField(auto_now=True)),
                (
                    "created_by",
                    models.ForeignKey(
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        related_name="created_exams",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
            options={
                "db_table": "hall_ticket_exams",
                "ordering": ["-created_at"],
            },
        ),
        migrations.CreateModel(
            name="ExamEnrollment",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "roll_number",
                    models.CharField(
                        db_index=True, help_text="Student roll number", max_length=50
                    ),
                ),
                (
                    "student_name",
                    models.CharField(help_text="Student name", max_length=200),
                ),
                ("branch", models.CharField(blank=True, max_length=100)),
                ("enrolled_at", models.DateTimeField(auto_now_add=True)),
                (
                    "exam",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="enrollments",
                        to="results.exam",
                    ),
                ),
                (
                    "student",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="exam_enrollments",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
            options={
                "db_table": "hall_ticket_enrollments",
            },
        ),
        migrations.CreateModel(
            name="StudentPhoto",
            fields=[
                (
                    "student",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        primary_key=True,
                        related_name="hall_ticket_photo",
                        serialize=False,
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
                (
                    "roll_number",
                    models.CharField(db_index=True, max_length=50, unique=True),
                ),
                (
                    "photo",
                    models.ImageField(
                        help_text="Student photograph", upload_to="hall_ticket_photos/"
                    ),
                ),
                (
                    "consent_given",
                    models.BooleanField(
                        default=False, help_text="Consent to use photo"
                    ),
                ),
                (
                    "consent_text",
                    models.TextField(
                        default="I hereby give consent to use my photograph for hall ticket generation"
                    ),
                ),
                ("consent_date", models.DateTimeField(blank=True, null=True)),
                ("uploaded_at", models.DateTimeField(auto_now_add=True)),
                ("updated_at", models.DateTimeField(auto_now=True)),
            ],
            options={
                "db_table": "hall_ticket_student_photos",
            },
        ),
        migrations.CreateModel(
            name="Circular",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("title", models.CharField(help_text="Circular title", max_length=300)),
                (
                    "category",
                    models.CharField(
                        choices=[
                            ("general", "General Notification"),
                            ("exam", "Exam Related"),
                            ("academic", "Academic"),
                            ("admission", "Admission"),
                            ("event", "Event/Activity"),
                            ("urgent", "Urgent"),
                        ],
                        default="general",
                        max_length=50,
                    ),
                ),
                (
                    "description",
                    models.TextField(help_text="Detailed description/message"),
                ),
                (
                    "attachment",
                    models.FileField(
                        blank=True,
                        help_text="Attach PDF, JPG, JPEG, PNG files",
                        null=True,
                        upload_to="circulars/%Y/%m/",
                    ),
                ),
                (
                    "attachment_name",
                    models.CharField(
                        blank=True, help_text="Original filename", max_length=255
                    ),
                ),
                (
                    "is_active",
                    models.BooleanField(default=True, help_text="Show to students"),
                ),
                (
                    "target_year",
                    models.IntegerField(
                        blank=True,
                        help_text="Target specific year (1,2,3,4) or NULL for all",
                        null=True,
                    ),
                ),
                (
                    "target_branch",
                    models.CharField(
                        blank=True,
                        help_text="Target specific branch or NULL for all",
                        max_length=50,
                        null=True,
                    ),
                ),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                ("updated_at", models.DateTimeField(auto_now=True)),
                (
                    "created_by",
                    models.ForeignKey(
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        related_name="circulars",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
            options={
                "db_table": "circulars",
                "ordering": ["-created_at"],
            },
        ),
        migrations.CreateModel(
            name="HallTicket",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "hall_ticket_number",
                    models.CharField(
                        db_index=True,
                        help_text="Unique hall ticket number",
                        max_length=50,
                        unique=True,
                    ),
                ),
                (
                    "pdf_file",
                    models.FileField(
                        blank=True, null=True, upload_to="hall_tickets/%Y/%m/"
                    ),
                ),
                (
                    "qr_code_data",
                    models.CharField(
                        blank=True,
                        default="",
                        help_text="QR code verification data",
                        max_length=500,
                    ),
                ),
                ("status", models.CharField(default="generated", max_length=20)),
                ("download_count", models.IntegerField(default=0)),
                ("generated_at", models.DateTimeField(auto_now_add=True)),
                ("downloaded_at", models.DateTimeField(blank=True, null=True)),
                (
                    "enrollment",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="hall_ticket",
                        to="results.examenrollment",
                    ),
                ),
                (
                    "exam",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="hall_tickets",
                        to="results.exam",
                    ),
                ),
                (
                    "generated_by",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        related_name="generated_hall_tickets",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
                (
                    "student",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="hall_tickets",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
            options={
                "db_table": "hall_tickets",
                "ordering": ["-generated_at"],
            },
        ),
        migrations.CreateModel(
            name="ExamSubject",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "subject_code",
                    models.CharField(help_text="Subject code", max_length=50),
                ),
                (
                    "subject_name",
                    models.CharField(help_text="Subject name", max_length=200),
                ),
                (
                    "subject_type",
                    models.CharField(
                        choices=[("Theory", "Theory"), ("Lab", "Lab")],
                        default="Theory",
                        help_text="Subject type",
                        max_length=20,
                    ),
                ),
                (
                    "exam_date",
                    models.DateField(
                        blank=True,
                        help_text="Date of examination (required for Theory, optional for Lab)",
                        null=True,
                    ),
                ),
                (
                    "exam_time",
                    models.TimeField(default="10:00", help_text="Exam start time"),
                ),
                (
                    "duration",
                    models.CharField(
                        default="3 hours", help_text="Exam duration", max_length=50
                    ),
                ),
                (
                    "order",
                    models.IntegerField(
                        default=1, help_text="Display order in hall ticket"
                    ),
                ),
                (
                    "exam",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="subjects",
                        to="results.exam",
                    ),
                ),
            ],
            options={
                "db_table": "hall_ticket_exam_subjects",
                "ordering": ["exam", "order", "exam_date"],
                "unique_together": {("exam", "subject_code")},
            },
        ),
        migrations.AddIndex(
            model_name="examenrollment",
            index=models.Index(
                fields=["roll_number"], name="hall_ticket_roll_nu_33ddc2_idx"
            ),
        ),
        migrations.AddIndex(
            model_name="examenrollment",
            index=models.Index(
                fields=["exam", "roll_number"], name="hall_ticket_exam_id_286ec6_idx"
            ),
        ),
        migrations.AlterUniqueTogether(
            name="examenrollment",
            unique_together={("exam", "roll_number")},
        ),
        migrations.AddIndex(
            model_name="exam",
            index=models.Index(
                fields=["is_active"], name="hall_ticket_is_acti_3684f9_idx"
            ),
        ),
        migrations.AddIndex(
            model_name="circular",
            index=models.Index(
                fields=["-created_at", "is_active"], name="circulars_created_3f7483_idx"
            ),
        ),
        migrations.AddIndex(
            model_name="circular",
            index=models.Index(
                fields=["category", "is_active"], name="circulars_categor_25fad8_idx"
            ),
        ),
    ]
