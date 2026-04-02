# Generated migration for credits and SGPA update

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('results', '0013_alter_result_unique_together_and_more'),
    ]

    operations = [
        # Add credits field to Subject model
        migrations.AddField(
            model_name='subject',
            name='credits',
            field=models.IntegerField(blank=True, help_text='Subject credits', null=True),
        ),
        # Remove subject_result field from Subject model
        migrations.RemoveField(
            model_name='subject',
            name='subject_result',
        ),
        # Add total_marks field to Result model
        migrations.AddField(
            model_name='result',
            name='total_marks',
            field=models.IntegerField(blank=True, help_text='Total marks obtained', null=True),
        ),
        # Add sgpa field to Result model
        migrations.AddField(
            model_name='result',
            name='sgpa',
            field=models.DecimalField(blank=True, decimal_places=2, help_text='Semester Grade Point Average', max_digits=4, null=True),
        ),
        # Remove percentage field from Result model
        migrations.RemoveField(
            model_name='result',
            name='percentage',
        ),
    ]
