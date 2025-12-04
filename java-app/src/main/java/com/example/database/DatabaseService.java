package com.example.database;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DatabaseService {
    private final HikariDataSource dataSource;

    public DatabaseService(String host, String database, String user, String password) {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://" + host + ":3306/" + database);
        config.setUsername(user);
        config.setPassword(password);
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);
        
        this.dataSource = new HikariDataSource(config);
        System.out.println("✅ HikariCP connection pool created successfully");
    }

    public Integer createUser(String username, String email, String fullName) {
        String sql = "INSERT INTO users (username, email, full_name) VALUES (?, ?, ?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, fullName);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int userId = rs.getInt(1);
                        System.out.println("✅ Created user: " + username + " (ID: " + userId + ")");
                        return userId;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error creating user: " + e.getMessage());
        }
        return null;
    }

    public Map<String, Object> getUser(int userId) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("id", rs.getInt("id"));
                    user.put("username", rs.getString("username"));
                    user.put("email", rs.getString("email"));
                    user.put("full_name", rs.getString("full_name"));
                    user.put("created_at", rs.getTimestamp("created_at").toString());
                    user.put("updated_at", rs.getTimestamp("updated_at").toString());
                    
                    System.out.println("✅ Retrieved user: " + user.get("username"));
                    return user;
                } else {
                    System.out.println("⚠️  User with ID " + userId + " not found");
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error retrieving user: " + e.getMessage());
        }
        return null;
    }

    public List<Map<String, Object>> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<Map<String, Object>> users = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getInt("id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("full_name", rs.getString("full_name"));
                user.put("created_at", rs.getTimestamp("created_at").toString());
                user.put("updated_at", rs.getTimestamp("updated_at").toString());
                users.add(user);
            }
            
            System.out.println("✅ Retrieved " + users.size() + " users");
        } catch (SQLException e) {
            System.err.println("❌ Error retrieving users: " + e.getMessage());
        }
        return users;
    }

    public boolean updateUser(int userId, String email, String fullName) {
        List<String> updates = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        
        if (email != null) {
            updates.add("email = ?");
            params.add(email);
        }
        if (fullName != null) {
            updates.add("full_name = ?");
            params.add(fullName);
        }
        
        if (updates.isEmpty()) {
            System.out.println("⚠️  No fields to update");
            return false;
        }
        
        params.add(userId);
        String sql = "UPDATE users SET " + String.join(", ", updates) + " WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                System.out.println("✅ Updated user ID " + userId);
                return true;
            } else {
                System.out.println("⚠️  User with ID " + userId + " not found");
                return false;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error updating user: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                System.out.println("✅ Deleted user ID " + userId);
                return true;
            } else {
                System.out.println("⚠️  User with ID " + userId + " not found");
                return false;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error deleting user: " + e.getMessage());
        }
        return false;
    }

    public void close() {
        if (dataSource != null) {
            dataSource.close();
            System.out.println("✅ Connection pool closed");
        }
    }
}
