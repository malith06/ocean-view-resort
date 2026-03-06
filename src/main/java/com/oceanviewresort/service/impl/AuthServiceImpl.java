package com.oceanviewresort.service.impl;

import java.util.Optional;

import com.oceanviewresort.dao.UserDao;
import com.oceanviewresort.dto.LoginRequest;
import com.oceanviewresort.dto.LoginResponse;
import com.oceanviewresort.model.User;
import com.oceanviewresort.service.AuthService;
import com.oceanviewresort.util.PasswordUtil;


public class AuthServiceImpl implements AuthService {

    private final UserDao userDao;

    public AuthServiceImpl(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public LoginResponse login(LoginRequest request) {

        if (request == null || isBlank(request.getUsername()) || isBlank(request.getPassword())) {
            return new LoginResponse(false, "Username and password are required.", null, null);
        }

        Optional<User> opt = userDao.findByUsername(request.getUsername().trim());
        if (opt.isEmpty()) {
            return new LoginResponse(false, "Invalid username or password.", null, null);
        }

        User user = opt.get();

        if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            return new LoginResponse(false, "Your account is disabled. Contact admin.", null, null);
        }

        
        if (!PasswordUtil.verify(request.getPassword(), user.getPasswordHash())) {
            return new LoginResponse(false, "Invalid username or password.", null, null);
        }

        return new LoginResponse(true, "Login successful.", user.getUsername(), user.getRole());
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
