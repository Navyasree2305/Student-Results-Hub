# No-op: exam_date is already null=True, blank=True in migration 0015 (rewritten)
from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        (
            "results",
            "0015_exam_examenrollment_studentphoto_circular_hallticket_and_more",
        ),
    ]

    operations = [
        # Previously altered ExamSubject.exam_date to null=True, blank=True.
        # The rewritten 0015 already creates it that way, so this is a no-op.
    ]
