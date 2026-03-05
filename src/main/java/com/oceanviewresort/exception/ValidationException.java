package com.oceanviewresort.exception;

import java.util.Collections;
import java.util.Map;

public class ValidationException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    private final Map<String, String> errors;

    public ValidationException(Map<String, String> errors) {
        super("Validation failed");
        this.errors = errors == null ? Collections.emptyMap() : errors;
    }

    public Map<String, String> getErrors() {
        return errors;
    }
}
