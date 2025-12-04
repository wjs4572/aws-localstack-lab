# Database Lab - MySQL with Python & Java

Learn database connectivity and CRUD operations using MySQL in Docker with both Python and Java.

> **Technology Selection Disclaimer:** The technologies used in this project were selected based on project-specific requirements, testing results, and practical development constraints observed at the time of implementation. These selections reflect the scope and goals of this work and should not be interpreted as endorsements or guarantees of performance, cost, or future availability.

## What You'll Learn

- **Database Setup**: Run MySQL 8.0 in Docker with persistent storage
- **Schema Management**: Create tables with migrations
- **Connection Pooling**: Configure connection pools (Python: MySQLConnectionPool, Java: HikariCP)
- **CRUD Operations**: Implement Create, Read, Update, Delete in both languages
- **SQL Best Practices**: Use prepared statements to prevent SQL injection
- **Polyglot Development**: Same database accessed by Python and Java

## Prerequisites

- Docker Desktop running
- WSL with Java 21 and Maven (see `../WSL_SETUP.md`)
- Python 3 with pip

## Quick Start

```bash
# 1. Setup database
./setup-database.sh

# 2. Run Python demo
./test-database.sh python

# 3. Run Java demo
./test-database.sh java

# 4. View in phpMyAdmin
open http://localhost:8080  # Username: labuser, Password: labpassword

# 5. Cleanup
./clean-database.sh

**Python function:**
```bash
```

## What Gets Created

### Database Resources
- **MySQL Container**: Database server on port 3306
- **phpMyAdmin Container**: Web GUI on port 8080
- **Database**: `userdb` with `users` table
- **Sample Data**: 3 pre-loaded users

### Application Code
- **Python App**: `python-app/db_operations.py` - CRUD with connection pooling
- **Java App**: `java-app/` - Maven project with HikariCP connection pool

## Architecture

```
┌─────────────────┐     ┌─────────────────┐
│  Python App     │     │    Java App     │
│  (pooled conn)  │     │   (HikariCP)    │
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     │
              ┌──────▼──────┐
              │   MySQL     │
              │   (Docker)  │
              └─────────────┘
                     │
              ┌──────▼──────┐
              │ phpMyAdmin  │
              │  (Web GUI)  │
              └─────────────┘
```

## Database Schema

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## Connection Details

- **Host**: `localhost:3306`
- **Database**: `userdb`
- **Username**: `labuser`
- **Password**: `labpassword`

## Python Implementation

### Key Features
- `MySQLConnectionPool` with pool size 5
- Prepared statements for all queries
- Context managers for connection handling
- JSON serialization with datetime support

### Example Usage

```python
from db_operations import DatabaseService

db = DatabaseService()

# Create user
user_id = db.create_user('alice', 'alice@example.com', 'Alice Smith')

# Read user
user = db.get_user(user_id)
print(user)

# Update user
db.update_user(user_id, email='alice.smith@example.com', full_name='Alice M. Smith')

# Delete user
db.delete_user(user_id)
```

## Java Implementation

### Key Features
- HikariCP connection pool (max 10, min idle 2)
- PreparedStatement for all queries
- Try-with-resources for cleanup
- Gson for JSON output

### Example Usage

```java
DatabaseService db = new DatabaseService();

// Create user
int userId = db.createUser("bob", "bob@example.com", "Bob Jones");

// Read user
Map<String, Object> user = db.getUser(userId);
System.out.println(user);

// Update user
db.updateUser(userId, "bob.jones@example.com", "Robert Jones");

// Delete user
db.deleteUser(userId);

// Don't forget to close!
db.close();
```

## Testing the Lab

### Run Both Demos

```bash
./test-database.sh all
```

### Run Individual Demos

```bash
./test-database.sh python  # Python only
./test-database.sh java    # Java only
```

### Manual Testing

```bash
# Connect with MySQL client
docker exec -it lab-mysql mysql -u labuser -plabpassword userdb

# List users
SELECT * FROM users;

# Exit
exit
```

## Migration to AWS RDS

When you're ready to use AWS RDS:

1. **Create RDS Instance** (MySQL 8.0)

   ```bash
   aws rds create-db-instance \
       --db-instance-identifier my-database \
       --db-instance-class db.t3.micro \
       --engine mysql \
       --master-username admin \
       --master-user-password YourPassword \
       --allocated-storage 20
   ```

2. **Update Connection Strings**
   - Python: Update `host` in `db_operations.py`
   - Java: Update `jdbcUrl` in `DatabaseService.java`

3. **Run Migrations**

   ```bash
   mysql -h your-rds-endpoint.amazonaws.com -u admin -p < migrations/001_create_users.sql
   ```

4. **Security Groups**: Allow inbound on port 3306

## Key Concepts

### Connection Pooling

- **Why**: Creating connections is expensive (100ms+)
- **How**: Pool reuses connections across requests
- **Python**: MySQLConnectionPool manages pool automatically
- **Java**: HikariCP provides enterprise-grade pooling

### Prepared Statements

- **Why**: Prevent SQL injection attacks
- **How**: SQL and data sent separately
- **Example**: `SELECT * FROM users WHERE id = ?` with parameter binding

### Transactions

- **CRUD Operations**: Auto-commit mode (default)
- **Multi-step**: Use explicit transactions with rollback
- **Error Handling**: Always rollback on errors

## Troubleshooting

### Port 3306 Already in Use

**Symptom**: `Error response from daemon: ports are not available: exposing port TCP 0.0.0.0:3306`

**Cause**: MySQL is already running on Windows (or another container is using port 3306)

**Solution**:

```powershell
# In Administrator PowerShell (Windows)
Get-Service | Where-Object {$_.Name -like "*mysql*"}
Stop-Service MySQL80  # Or whatever MySQL service is running
```

Alternatively, modify `docker-compose.yml` to use a different port:

```yaml
mysql:
  ports:
    - "3307:3306"  # Use 3307 on host instead
```

### MySQL Won't Start

```bash
# Check Docker
docker ps

# View MySQL logs
docker logs lab-mysql

# Restart containers
docker-compose restart mysql
```

### Connection Refused

```bash
# Verify MySQL is running
docker exec lab-mysql mysqladmin ping -h localhost -u root -prootpassword

# Check port (WSL)
sudo ss -tlnp | grep 3306

# Check port (Windows PowerShell)
netstat -ano | findstr :3306
```

### Python Module Not Found

```bash
# Install dependencies
pip3 install -r python-app/requirements.txt
```

### Java Build Fails

```bash
# Clean rebuild
cd java-app
mvn clean package
```

## Cost Analysis

### Docker (This Lab)

- **Cost**: $0
- **Performance**: Local, very fast
- **Limitations**: Not accessible from other machines

### AWS RDS db.t3.micro

- **Cost**: Involves ongoing AWS charges (verify current pricing)
- **Performance**: Network latency (~5-50ms)
- **Benefits**: Managed backups, multi-AZ, automatic updates

## Learning Path

1. ✅ **Start Here**: MySQL in Docker (this lab)
2. 🔄 **Next**: Add more tables and relationships
3. 🔄 **Advanced**: Connection pooling tuning
4. 🔄 **Production**: Migrate to AWS RDS

## Real-World Applications

- **Microservices**: Each service maintains its own database connection pool
- **Web APIs**: REST endpoints backed by database CRUD operations
- **Data Pipelines**: ETL processes reading/writing to databases
- **AWS Lambda**: Connection pooling critical for serverless (use RDS Proxy)

## Files Created

```
database-lab/
├── docker-compose.yml           # MySQL + phpMyAdmin config
├── migrations/
│   └── 001_create_users.sql     # Schema and sample data
├── python-app/
│   ├── db_operations.py         # Python CRUD with pooling
│   └── requirements.txt         # Python dependencies
├── java-app/
│   ├── pom.xml                  # Maven configuration
│   └── src/main/java/com/example/database/
│       ├── DatabaseService.java # Java CRUD with HikariCP
│       └── DatabaseDemo.java    # Demo main class
├── setup-database.sh            # Start MySQL and verify
├── test-database.sh             # Run Python or Java demos
└── clean-database.sh            # Stop and cleanup
```

---

## Appendix: Script Details

### setup-database.sh

```bash
# Start containers
docker-compose up -d mysql phpmyadmin

# Wait for MySQL health check (up to 60 seconds)
docker exec lab-mysql mysqladmin ping -h localhost -u root -prootpassword

# Migrations run automatically via docker-entrypoint-initdb.d
# Check: docker exec lab-mysql mysql -u labuser -plabpassword -e "SHOW TABLES FROM userdb"
```

**What it does**:
- Starts MySQL 8.0 and phpMyAdmin containers
- Waits for MySQL to be ready (health check)
- Migrations in `./migrations/` run automatically on first startup
- Prints connection details and next steps

### test-database.sh

```bash
# Python demo
pip3 install -r python-app/requirements.txt
python3 python-app/db_operations.py

# Java demo
cd java-app && mvn clean package -q
java -jar java-app/target/database-lab-1.0.0.jar
```

**What it does**:
- Installs Python dependencies (if needed)
- Runs Python CRUD demo
- Builds Java app with Maven (if needed)
- Runs Java CRUD demo
- Both demos create → read → update → delete → verify

**Usage**:

```bash
./test-database.sh all     # Run both Python and Java
./test-database.sh python  # Python only
./test-database.sh java    # Java only
```

### clean-database.sh

```bash
# Stop containers
docker-compose down

# Remove data volume (optional, asks first)
docker volume rm project_aws_localstack_lab_mysql_data

# Clean Java build
rm -rf java-app/target
```

**What it does**:
- Asks for confirmation
- Stops MySQL and phpMyAdmin containers
- Optionally removes data volume (asks first)
- Removes Java build artifacts

---

## Why MySQL in Docker?

This lab demonstrates database connectivity and CRUD operations with the following goals:

- Learn real database skills (connection pooling, prepared statements, transactions)
- Show polyglot development (Python and Java accessing the same database)
- Keep costs at $0 for learning and portfolio demonstration
- Build transferable skills that work with AWS RDS

**Why not LocalStack RDS?**

Based on our testing at the time of implementation, the LocalStack Community Edition did not provide functional emulation for the database services required for this project. While expanded database emulation is available in paid LocalStack tiers, those options were outside the scope of this work.

**Why not AWS RDS?**

While AWS RDS is production-ready with managed backups and automatic updates, running instances involves ongoing costs. For learning and portfolio purposes, we chose a zero-cost alternative.

**MySQL in Docker provides:**

- ✅ Real MySQL 8.0 database with full functionality
- ✅ Actual database skills (not API mocks)
- ✅ Code that works unchanged with AWS RDS
- ✅ Zero cost for development and testing
- ✅ Fast local performance

The skills learned in this lab transfer directly to AWS RDS when production deployment is needed.

---

---

## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".

