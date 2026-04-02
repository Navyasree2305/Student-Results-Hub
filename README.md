# SPMVV Exam Results Portal

A web application for Sri Padmavati Mahila Visvavidyalayam (SPMVV) to manage and publish student exam results, hall tickets, notifications, and circulars.

---

## Features

**Students**
- View exam results by semester with grades and credits
- SGPA and CGPA calculation with statistics charts
- Download hall ticket as PDF
- Upload passport photo for hall ticket
- View notifications and official circulars

**Admins**
- Upload results in bulk via Excel (.xlsx)
- Manage student and admin accounts with granular permissions
- Create hall ticket exams, enroll students, and generate PDFs
- Post notifications and circulars
- View audit logs and statistics dashboard

---

## Tech Stack

- **Backend:** Python 3.11, Django 5.0.9, Django REST Framework
- **Database:** MariaDB 10.11
- **Frontend:** React 18, Vite, Tailwind CSS
- **Auth:** JWT (SimpleJWT) + Argon2 password hashing
- **Server:** Gunicorn + Nginx
- **Containers:** Docker (3 containers)

---

## Deployment

### Prerequisites
- Docker installed and running
- Ports **2026** and **8000** open on the server

### Linux

```bash
git clone <your-repo-url>
cd spmvv-exam-results
chmod +x deploy_docker.sh
./deploy_docker.sh
```

### Windows

```powershell
./deploy_windows.ps1
```

The script handles everything: starts MariaDB, runs migrations, creates the default admin, and starts the frontend and backend containers.

### Access

| Service  | URL                         |
|----------|-----------------------------|
| Frontend | `http://<server-ip>:2026`   |
| API      | `http://<server-ip>:8000/api/` |

### Default Admin Login

| Username | Password           |
|----------|--------------------|
| `admin`  | `SpmvvExamResults` |

> Change the admin password after first login.
