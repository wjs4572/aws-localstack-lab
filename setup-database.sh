#!/usr/bin/env bash
# Setup MySQL database with Docker
set -euo pipefail

echo "[DATABASE] Setting up MySQL database lab..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Start MySQL and phpMyAdmin
echo "[DATABASE] Starting MySQL and phpMyAdmin containers..."
docker-compose up -d mysql phpmyadmin

# Wait for MySQL to be ready
echo "[DATABASE] Waiting for MySQL to be ready..."
for i in {1..30}; do
    if docker exec lab-mysql mysqladmin ping -h localhost -u root -prootpassword --silent 2>/dev/null; then
        echo "✅ MySQL is ready!"
        break
    fi
    echo "  Waiting... ($i/30)"
    sleep 2
done

if ! docker exec lab-mysql mysqladmin ping -h localhost -u root -prootpassword --silent 2>/dev/null; then
    echo "❌ MySQL failed to start"
    exit 1
fi

echo ""
echo "=================================="
echo "  Database Lab Ready!"
echo "=================================="
echo ""
echo "MySQL Connection Info:"
echo "  Host: localhost"
echo "  Port: 3306"
echo "  Database: userdb"
echo "  Username: labuser"
echo "  Password: labpassword"
echo ""
echo "phpMyAdmin:"
echo "  URL: http://localhost:8080"
echo "  Username: labuser"
echo "  Password: labpassword"
echo ""
echo "Next steps:"
echo "  1. Run Python demo: ./test-database.sh python"
echo "  2. Run Java demo: ./test-database.sh java"
echo "  3. View in phpMyAdmin: open http://localhost:8080"
echo ""
