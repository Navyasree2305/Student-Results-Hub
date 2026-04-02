# Generated migration for session_id on AuditLog

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('results', '0018_alter_auditlog_action_alter_exam_exam_center'),
    ]

    operations = [
        migrations.AddField(
            model_name='auditlog',
            name='session_id',
            field=models.CharField(
                blank=True,
                db_index=True,
                help_text='Login session identifier to group audit events per session',
                max_length=64,
                null=True,
            ),
        ),
    ]
