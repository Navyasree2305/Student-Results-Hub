from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('results', '0019_auditlog_session_id'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='results_upload',
            field=models.BooleanField(default=False, help_text='Upload exam result Excel files'),
        ),
        migrations.AddField(
            model_name='user',
            name='results_edit',
            field=models.BooleanField(default=False, help_text='Edit individual subject marks'),
        ),
        migrations.AddField(
            model_name='user',
            name='results_delete',
            field=models.BooleanField(default=False, help_text='Delete uploaded exam results'),
        ),
        migrations.AddField(
            model_name='user',
            name='results_download',
            field=models.BooleanField(default=False, help_text='Download result Excel files'),
        ),
        migrations.AddField(
            model_name='user',
            name='students_view',
            field=models.BooleanField(default=False, help_text='Search students and view academic history'),
        ),
        migrations.AddField(
            model_name='user',
            name='students_detained_report',
            field=models.BooleanField(default=False, help_text='View detained students report'),
        ),
        migrations.AddField(
            model_name='user',
            name='circulars_view',
            field=models.BooleanField(default=False, help_text='View circulars'),
        ),
        migrations.AddField(
            model_name='user',
            name='circulars_create',
            field=models.BooleanField(default=False, help_text='Create new circulars'),
        ),
        migrations.AddField(
            model_name='user',
            name='circulars_edit',
            field=models.BooleanField(default=False, help_text='Edit existing circulars'),
        ),
        migrations.AddField(
            model_name='user',
            name='circulars_delete',
            field=models.BooleanField(default=False, help_text='Delete circulars'),
        ),
        migrations.AddField(
            model_name='user',
            name='timetable_view',
            field=models.BooleanField(default=False, help_text='View and download timetables'),
        ),
        migrations.AddField(
            model_name='user',
            name='timetable_create',
            field=models.BooleanField(default=False, help_text='Generate and manage timetables'),
        ),
        migrations.AddField(
            model_name='user',
            name='halltickets_view',
            field=models.BooleanField(default=False, help_text='View hall ticket exams and enrollments'),
        ),
        migrations.AddField(
            model_name='user',
            name='halltickets_create',
            field=models.BooleanField(default=False, help_text='Create/manage hall ticket exams and upload student lists'),
        ),
        migrations.AddField(
            model_name='user',
            name='halltickets_generate',
            field=models.BooleanField(default=False, help_text='Generate hall tickets'),
        ),
        migrations.AddField(
            model_name='user',
            name='halltickets_download',
            field=models.BooleanField(default=False, help_text='Download hall ticket PDFs'),
        ),
        migrations.AddField(
            model_name='user',
            name='statistics_view',
            field=models.BooleanField(default=False, help_text='View statistics and reports dashboard'),
        ),
        migrations.AddField(
            model_name='user',
            name='auditlogs_view',
            field=models.BooleanField(default=False, help_text='View security and activity audit logs'),
        ),
        migrations.AddField(
            model_name='user',
            name='users_view',
            field=models.BooleanField(default=False, help_text='View the user list'),
        ),
        migrations.AddField(
            model_name='user',
            name='users_create',
            field=models.BooleanField(default=False, help_text='Create new users'),
        ),
        migrations.AddField(
            model_name='user',
            name='users_edit',
            field=models.BooleanField(default=False, help_text='Edit users and assign permissions'),
        ),
        migrations.AddField(
            model_name='user',
            name='users_delete',
            field=models.BooleanField(default=False, help_text='Delete users'),
        ),
        migrations.AddField(
            model_name='user',
            name='access_all_branches',
            field=models.BooleanField(default=False, help_text='View data for all branches (overrides branch restriction)'),
        ),
    ]
