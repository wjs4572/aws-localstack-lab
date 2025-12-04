"""
Database operations using Python and MySQL
Demonstrates CRUD operations with proper connection handling
"""
import mysql.connector
from mysql.connector import Error, pooling
import os
import json
from datetime import datetime


class DatabaseService:
    def __init__(self, host='localhost', database='userdb', user='labuser', password='labpassword'):
        """Initialize database connection pool"""
        try:
            self.connection_pool = pooling.MySQLConnectionPool(
                pool_name="lab_pool",
                pool_size=5,
                pool_reset_session=True,
                host=host,
                database=database,
                user=user,
                password=password
            )
            print(f"✅ Connection pool created successfully")
        except Error as e:
            print(f"❌ Error creating connection pool: {e}")
            raise

    def get_connection(self):
        """Get a connection from the pool"""
        return self.connection_pool.get_connection()

    def create_user(self, username, email, full_name):
        """Create a new user"""
        connection = None
        try:
            connection = self.get_connection()
            cursor = connection.cursor()
            
            query = """
                INSERT INTO users (username, email, full_name)
                VALUES (%s, %s, %s)
            """
            cursor.execute(query, (username, email, full_name))
            connection.commit()
            
            user_id = cursor.lastrowid
            print(f"✅ Created user: {username} (ID: {user_id})")
            return user_id
            
        except Error as e:
            print(f"❌ Error creating user: {e}")
            if connection:
                connection.rollback()
            return None
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()

    def get_user(self, user_id):
        """Get a user by ID"""
        connection = None
        try:
            connection = self.get_connection()
            cursor = connection.cursor(dictionary=True)
            
            query = "SELECT * FROM users WHERE id = %s"
            cursor.execute(query, (user_id,))
            user = cursor.fetchone()
            
            if user:
                # Convert datetime to string for JSON serialization
                user['created_at'] = user['created_at'].isoformat() if user['created_at'] else None
                user['updated_at'] = user['updated_at'].isoformat() if user['updated_at'] else None
                print(f"✅ Retrieved user: {user['username']}")
            else:
                print(f"⚠️  User with ID {user_id} not found")
            
            return user
            
        except Error as e:
            print(f"❌ Error retrieving user: {e}")
            return None
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()

    def get_all_users(self):
        """Get all users"""
        connection = None
        try:
            connection = self.get_connection()
            cursor = connection.cursor(dictionary=True)
            
            query = "SELECT * FROM users ORDER BY created_at DESC"
            cursor.execute(query)
            users = cursor.fetchall()
            
            # Convert datetime to string
            for user in users:
                user['created_at'] = user['created_at'].isoformat() if user['created_at'] else None
                user['updated_at'] = user['updated_at'].isoformat() if user['updated_at'] else None
            
            print(f"✅ Retrieved {len(users)} users")
            return users
            
        except Error as e:
            print(f"❌ Error retrieving users: {e}")
            return []
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()

    def update_user(self, user_id, email=None, full_name=None):
        """Update a user's information"""
        connection = None
        try:
            connection = self.get_connection()
            cursor = connection.cursor()
            
            updates = []
            params = []
            
            if email:
                updates.append("email = %s")
                params.append(email)
            if full_name:
                updates.append("full_name = %s")
                params.append(full_name)
            
            if not updates:
                print("⚠️  No fields to update")
                return False
            
            params.append(user_id)
            query = f"UPDATE users SET {', '.join(updates)} WHERE id = %s"
            
            cursor.execute(query, params)
            connection.commit()
            
            if cursor.rowcount > 0:
                print(f"✅ Updated user ID {user_id}")
                return True
            else:
                print(f"⚠️  User with ID {user_id} not found")
                return False
            
        except Error as e:
            print(f"❌ Error updating user: {e}")
            if connection:
                connection.rollback()
            return False
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()

    def delete_user(self, user_id):
        """Delete a user"""
        connection = None
        try:
            connection = self.get_connection()
            cursor = connection.cursor()
            
            query = "DELETE FROM users WHERE id = %s"
            cursor.execute(query, (user_id,))
            connection.commit()
            
            if cursor.rowcount > 0:
                print(f"✅ Deleted user ID {user_id}")
                return True
            else:
                print(f"⚠️  User with ID {user_id} not found")
                return False
            
        except Error as e:
            print(f"❌ Error deleting user: {e}")
            if connection:
                connection.rollback()
            return False
        finally:
            if connection and connection.is_connected():
                cursor.close()
                connection.close()


def demo():
    """Demonstrate all CRUD operations"""
    print("\n" + "="*60)
    print("  Python Database Operations Demo")
    print("="*60 + "\n")
    
    # Initialize service
    db = DatabaseService()
    
    # CREATE
    print("\n--- CREATE Operation ---")
    new_user_id = db.create_user('pyuser', 'python.user@example.com', 'Python User')
    
    # READ
    print("\n--- READ Operations ---")
    if new_user_id:
        user = db.get_user(new_user_id)
        if user:
            print(f"User details: {json.dumps(user, indent=2)}")
    
    print("\n--- LIST All Users ---")
    all_users = db.get_all_users()
    for user in all_users:
        print(f"  - {user['username']}: {user['email']}")
    
    # UPDATE
    print("\n--- UPDATE Operation ---")
    if new_user_id:
        db.update_user(new_user_id, email='updated.python@example.com', full_name='Updated Python User')
        updated_user = db.get_user(new_user_id)
        if updated_user:
            print(f"Updated user: {json.dumps(updated_user, indent=2)}")
    
    # DELETE
    print("\n--- DELETE Operation ---")
    if new_user_id:
        db.delete_user(new_user_id)
        print(f"Verifying deletion...")
        deleted_user = db.get_user(new_user_id)
        if not deleted_user:
            print("✅ User successfully deleted")
    
    print("\n" + "="*60)
    print("  Demo Complete!")
    print("="*60 + "\n")


if __name__ == "__main__":
    demo()
