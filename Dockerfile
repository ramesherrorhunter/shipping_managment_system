# Use a lightweight Python image
FROM python:3.10-slim-buster

# Set environment variables for consistent behavior
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# Set the working directory
WORKDIR /application

# Install dependencies first to leverage Docker caching
COPY requirements.txt /application
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Run migrations in a single step to reduce image layers
RUN python manage.py makemigrations && python manage.py migrate

# Expose the application port
EXPOSE 8000

# Use a non-root user for better security
RUN useradd --create-home appuser
USER appuser

# Define the default command
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]