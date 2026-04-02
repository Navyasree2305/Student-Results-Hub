from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.db import transaction
import os

User = get_user_model()


class Command(BaseCommand):
    help = 'Initialize admin user with default credentials from environment'

    def add_arguments(self, parser):
        parser.add_argument(
            '--username',
            type=str,
            help='Admin username (default: from ADMIN_USERNAME env or "admin")',
        )
        parser.add_argument(
            '--password',
            type=str,
            help='Admin password (default: from ADMIN_DEFAULT_PASSWORD env)',
        )
        parser.add_argument(
            '--email',
            type=str,
            default='admin@spmvv.edu',
            help='Admin email (default: admin@spmvv.edu)',
        )
        parser.add_argument(
            '--force',
            action='store_true',
            help='Force reset password if user exists',
        )

    def handle(self, *args, **options):
        username = options.get('username') or os.environ.get('ADMIN_USERNAME', 'admin')
        password = options.get('password') or os.environ.get('ADMIN_DEFAULT_PASSWORD')
        email = options.get('email')
        force = options.get('force', False)

        if not password:
            self.stdout.write(
                self.style.ERROR(
                    'Password is required. Set ADMIN_DEFAULT_PASSWORD environment variable '
                    'or use --password option.'
                )
            )
            return

        try:
            with transaction.atomic():
                user, created = User.objects.get_or_create(
                    username=username,
                    defaults={
                        'email': email,
                        'is_staff': True,
                        'is_superuser': True,
                        'role': 'admin',
                        'can_view_statistics': True,
                        'can_upload_results': True,
                        'can_delete_results': True,
                        'can_manage_users': True,
                        'can_view_all_branches': True,
                    }
                )

                if created:
                    user.set_password(password)
                    user.save()
                    self.stdout.write(
                        self.style.SUCCESS(
                            f'Successfully created admin user: {username}'
                        )
                    )
                    self.stdout.write(
                        self.style.WARNING(
                            f'Default password set. Please change it after first login!'
                        )
                    )
                elif force:
                    user.set_password(password)
                    user.is_staff = True
                    user.is_superuser = True
                    user.role = 'admin'
                    user.can_view_statistics = True
                    user.can_upload_results = True
                    user.can_delete_results = True
                    user.can_manage_users = True
                    user.can_view_all_branches = True
                    user.save()
                    self.stdout.write(
                        self.style.SUCCESS(
                            f'Successfully updated admin user: {username}'
                        )
                    )
                    self.stdout.write(
                        self.style.WARNING(
                            f'Password has been reset. Please change it after login!'
                        )
                    )
                else:
                    self.stdout.write(
                        self.style.WARNING(
                            f'Admin user {username} already exists. Use --force to reset password.'
                        )
                    )

        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f'Error creating admin user: {str(e)}')
            )
            raise
