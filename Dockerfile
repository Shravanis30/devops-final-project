FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application package
COPY service/ ./service/

# Create non-root user and set permissions
RUN useradd --uid 1000 theia && chown -R theia /app
USER theia

# Expose microservice port
EXPOSE 8080

# Run service using Gunicorn
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]
