# Multi-stage build for faster deployments
FROM python:3.11-slim as builder

# APT_PROXY: pass as IP:port (e.g. http://173.36.240.172:80) to avoid DNS issues in containers
ARG APT_PROXY

# Configure apt proxy (apt ignores HTTP_PROXY env; needs its own config file)
RUN if [ -n "${APT_PROXY}" ]; then \
      echo "Acquire::http::Proxy \"${APT_PROXY}\";" > /etc/apt/apt.conf.d/99proxy && \
      echo "Acquire::https::Proxy \"${APT_PROXY}\";" >> /etc/apt/apt.conf.d/99proxy; \
    fi

# Set pip proxy via env (pip respects http_proxy/https_proxy)
ENV http_proxy=${APT_PROXY}
ENV https_proxy=${APT_PROXY}
ENV HTTP_PROXY=${APT_PROXY}
ENV HTTPS_PROXY=${APT_PROXY}

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies needed for building
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip tools first (cached layer)
RUN pip install --upgrade pip setuptools wheel

# Copy requirements and install Python dependencies
WORKDIR /app
COPY requirements.txt .

# Install Python packages (this layer will be cached if requirements.txt doesn't change)
RUN pip install --no-cache-dir -r requirements.txt

# Final stage - minimal runtime image
FROM python:3.11-slim

ARG APT_PROXY

# Configure apt proxy for this stage
RUN if [ -n "${APT_PROXY}" ]; then \
      echo "Acquire::http::Proxy \"${APT_PROXY}\";" > /etc/apt/apt.conf.d/99proxy && \
      echo "Acquire::https::Proxy \"${APT_PROXY}\";" >> /etc/apt/apt.conf.d/99proxy; \
    fi

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install only runtime dependencies (not build tools)
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Remove apt proxy config so it doesn't affect runtime
RUN rm -f /etc/apt/apt.conf.d/99proxy

# Set work directory
WORKDIR /app

# Copy Python packages from builder stage
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy project files (this layer changes most often, so it's last)
COPY . .

# Create logs and media directories
RUN mkdir -p logs media

# Collect static files (use || true to not fail build if it errors)
RUN python manage.py collectstatic --noinput || true

# Expose port
EXPOSE 8000

# Run migrations and start server
CMD python manage.py migrate && \
    python manage.py init_admin --force && \
    gunicorn exam_results.wsgi:application --bind 0.0.0.0:8000 --workers 4
