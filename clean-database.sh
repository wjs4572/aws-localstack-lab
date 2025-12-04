#!/usr/bin/env bash
# Clean up database lab resources
set -euo pipefail

echo "[DATABASE] Cleaning up database lab..."
echo ""

# Ask for confirmation
read -p "This will stop MySQL containers and remove data. Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Stop containers
echo "[DATABASE] Stopping containers..."
docker-compose down

# Remove volume (optional - ask first)
if docker volume ls | grep -q "mysql_data"; then
    read -p "Remove MySQL data volume? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "[DATABASE] Removing data volume..."
        docker volume rm project_aws_localstack_lab_mysql_data || true
    fi
fi

# Clean Java build artifacts
if [ -d "java-app/target" ]; then
    echo "[DATABASE] Cleaning Java build artifacts..."
    rm -rf java-app/target
fi

echo ""
echo "✅ Database lab cleaned up!"
echo ""
