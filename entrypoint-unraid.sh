#!/bin/bash
set -e

# Upgrade the local Superset database
superset db upgrade

# Create default admin from Unraid GUI variables
if [ -n "$ADMIN_USERNAME" ] && [ -n "$ADMIN_PASSWORD" ]; then
    superset fab create-admin \
        --username "$ADMIN_USERNAME" \
        --firstname Superset \
        --lastname Admin \
        --email "$ADMIN_EMAIL" \
        --password "$ADMIN_PASSWORD" || true
fi

# Initialize roles and permissions
superset init

# Start the web server
exec gunicorn \
    --bind "0.0.0.0:8088" \
    --access-logfile '-' \
    --error-logfile '-' \
    --workers 1 \
    --worker-class gthread \
    --threads 20 \
    --timeout 60 \
    --limit-request-line 0 \
    --limit-request-field_size 0 \
    "superset.app:create_app()"