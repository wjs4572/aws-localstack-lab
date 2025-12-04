package com.example.database;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.List;
import java.util.Map;

public class DatabaseDemo {
    public static void main(String[] args) {
        System.out.println("\n" + "=".repeat(60));
        System.out.println("  Java Database Operations Demo");
        System.out.println("=".repeat(60) + "\n");

        DatabaseService db = new DatabaseService(
            "localhost",
            "userdb",
            "labuser",
            "labpassword"
        );

        Gson gson = new GsonBuilder().setPrettyPrinting().create();

        try {
            // CREATE
            System.out.println("\n--- CREATE Operation ---");
            Integer newUserId = db.createUser("javauser", "java.user@example.com", "Java User");

            // READ
            System.out.println("\n--- READ Operations ---");
            if (newUserId != null) {
                Map<String, Object> user = db.getUser(newUserId);
                if (user != null) {
                    System.out.println("User details: " + gson.toJson(user));
                }
            }

            System.out.println("\n--- LIST All Users ---");
            List<Map<String, Object>> allUsers = db.getAllUsers();
            for (Map<String, Object> user : allUsers) {
                System.out.println("  - " + user.get("username") + ": " + user.get("email"));
            }

            // UPDATE
            System.out.println("\n--- UPDATE Operation ---");
            if (newUserId != null) {
                db.updateUser(newUserId, "updated.java@example.com", "Updated Java User");
                Map<String, Object> updatedUser = db.getUser(newUserId);
                if (updatedUser != null) {
                    System.out.println("Updated user: " + gson.toJson(updatedUser));
                }
            }

            // DELETE
            System.out.println("\n--- DELETE Operation ---");
            if (newUserId != null) {
                db.deleteUser(newUserId);
                System.out.println("Verifying deletion...");
                Map<String, Object> deletedUser = db.getUser(newUserId);
                if (deletedUser == null) {
                    System.out.println("✅ User successfully deleted");
                }
            }

            System.out.println("\n" + "=".repeat(60));
            System.out.println("  Demo Complete!");
            System.out.println("=".repeat(60) + "\n");

        } finally {
            db.close();
        }
    }
}
