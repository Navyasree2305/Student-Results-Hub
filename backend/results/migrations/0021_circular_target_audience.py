from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("results", "0020_user_granular_permissions"),
    ]

    operations = [
        migrations.AddField(
            model_name="circular",
            name="target_audience",
            field=models.CharField(
                choices=[
                    ("all", "All (Students + Staff)"),
                    ("students", "Students Only"),
                    ("staff", "Staff Only"),
                ],
                default="all",
                help_text="Who should receive this circular",
                max_length=20,
            ),
        ),
    ]
