package com.oceanviewresort.service;

import com.oceanviewresort.dto.LoginRequest;
import com.oceanviewresort.dto.LoginResponse;

public interface AuthService {
    LoginResponse login(LoginRequest request);
}
