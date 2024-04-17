# Python 2 Base images - amd64
#   - 2.7.18-alpine          3C 19H 6M 2L
#   - 2.7.18-slim            12C 29H 20M 34L
#   - 2.7.18-slim-stretch    0C 2H 1M 1L
ARG BASE_IMAGE=python:2.7.18-alpine
FROM --platform=amd64 ${BASE_IMAGE}

# Set environment variables for Python
# ENV PYTHONUNBUFFERED 1
# ENV PYTHONDONTWRITEBYTECODE 1

# Set up non-root user
RUN groupadd -r demouser && useradd -r -g demouser demouser
USER demouser

# Set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . /app/

# Set the entry point for the container
CMD ["python", "app.py"]