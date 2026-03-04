package com.oceanviewresort.dao;

import java.util.Optional;
import com.oceanviewresort.model.User;

public interface UserDao {
    Optional<User> findByUsername(String username);
}
