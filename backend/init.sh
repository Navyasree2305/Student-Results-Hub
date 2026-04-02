#!/bin/bash
set -e

echo "Running database migrations..."
python manage.py migrate --noinput

echo "Creating admin user if not exists..."
python manage.py shell << EOF
from results.models import User
import os

username = os.environ.get('ADMIN_USERNAME', 'admin')
password = os.environ.get('ADMIN_DEFAULT_PASSWORD', 'SpmvvExamResults')

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(
        username=username,
        password=password,
        email='admin@spmvv.edu',
        role='admin'
    )
    print(f'Admin user {username} created successfully')
else:
    print(f'Admin user {username} already exists')
EOF

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting Gunicorn..."
exec gunicorn --bind 0.0.0.0:8000 --workers 3 --timeout 120 exam_results.wsgi:application
