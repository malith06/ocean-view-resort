package com.oceanviewresort.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Use when saving user passwords
    public static String hash(String plainPassword) {
        if (plainPassword == null) return null;
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    // Use when logging in
    public static boolean verify(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) return false;

        // ✅ If DB has plaintext (student projects), allow fallback
        // (You should later convert all stored passwords to bcrypt)
        if (!(storedHash.startsWith("$2a$") || storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$"))) {
            return plainPassword.equals(storedHash);
        }

        return BCrypt.checkpw(plainPassword, storedHash);
    }
}
