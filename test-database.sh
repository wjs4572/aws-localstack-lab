#!/usr/bin/env bash
# Test database operations with Python or Java
set -euo pipefail

DEMO_TYPE="${1:-all}"

echo "[DATABASE] Running database demo: $DEMO_TYPE"
echo ""

# Check if MySQL is running
if ! docker exec lab-mysql mysqladmin ping -h localhost -u root -prootpassword --silent 2>/dev/null; then
    echo "❌ MySQL is not running. Run ./setup-database.sh first."
    exit 1
fi

run_python_demo() {
    echo "=================================="
    echo "  Python CRUD Demo"
    echo "=================================="
    
    # Install dependencies if needed
    if ! python3 -c "import mysql.connector" 2>/dev/null; then
        echo "[PYTHON] Installing dependencies..."
        pip3 install -r python-app/requirements.txt
    fi
    
    # Run Python demo
    echo "[PYTHON] Running CRUD operations..."
    python3 python-app/db_operations.py
    echo ""
}

run_java_demo() {
    echo "=================================="
    echo "  Java CRUD Demo"
    echo "=================================="
    
    # Build Java app if needed
    if [ ! -f java-app/target/database-lab-1.0.0.jar ]; then
        echo "[JAVA] Building application..."
        cd java-app
        mvn clean package -q
        cd ..
    fi
    
    # Run Java demo
    echo "[JAVA] Running CRUD operations..."
    java -jar java-app/target/database-lab-1.0.0.jar
    echo ""
}

# Run requested demo(s)
case "$DEMO_TYPE" in
    python)
        run_python_demo
        ;;
    java)
        run_java_demo
        ;;
    all)
        run_python_demo
        run_java_demo
        ;;
    *)
        echo "❌ Invalid demo type: $DEMO_TYPE"
        echo "Usage: $0 [python|java|all]"
        exit 1
        ;;
esac

echo "=================================="
echo "  Demo Complete!"
echo "=================================="
echo ""
echo "View data in phpMyAdmin: http://localhost:8080"
echo ""
