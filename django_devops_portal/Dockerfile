#######################################
# Stage 1: Builder Stage
#######################################
FROM python:3.11-slim-bullseye AS builder

WORKDIR /app
COPY requirements.txt .

# Install system build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies to user directory
RUN pip install --upgrade pip setuptools && \
    pip install --user -r requirements.txt

#######################################
# Stage 2: Runtime Stage
#######################################
FROM python:3.11-slim-bullseye

# 禁用python的輸出緩存
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # Add user-level bin directory to PATH
    PATH="/app/.local/bin:${PATH}"  

WORKDIR /app

# Copy installed dependencies from builder stage
COPY --from=builder /root/.local /root/.local

# Copy application code
COPY . .
COPY gunicorn.conf.py .

# Create non-root user
RUN groupadd -r django && useradd -r -g django django && \
    chown -R django:django /app

USER django

# Collect static files (required for Django)
RUN python manage.py collectstatic --noinput

EXPOSE 8058
#啟動gunicorn WSGI
CMD ["gunicorn", "--config", "gunicorn.conf.py", "your_project.wsgi:application"]