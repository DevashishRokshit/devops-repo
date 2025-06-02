#!/bin/bash

set -e  # Exit on any error

echo "🚀 Starting Flask deployment"

# Update and install necessary packages
sudo yum update -y
sudo yum install -y python3 git unzip

# Upgrade pip
python3 -m pip install --upgrade pip

# Set app directory
APP_DIR="/home/ec2-user/app"
cd "$APP_DIR"

# Optional: create a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
if [ -f requirements.txt ]; then
  pip install -r requirements.txt
else
  echo "⚠️ requirements.txt not found, skipping pip install"
fi

# Run the Flask app with gunicorn (recommended for production)
export FLASK_APP=app.py
export FLASK_ENV=production

# Kill existing gunicorn (if any)
pkill gunicorn || true

# Start gunicorn
nohup gunicorn --bind 0.0.0.0:5000 app:app > gunicorn.log 2>&1 &

echo "✅ Flask app deployed and running on port 5000"
