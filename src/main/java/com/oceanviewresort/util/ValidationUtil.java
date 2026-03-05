package com.oceanviewresort.util;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

public class ValidationUtil {

    // Allowed room types
    public static final Set<String> ALLOWED_ROOM_TYPES =
            Set.of("STANDARD", "DELUXE", "SUITE");

    public static Map<String, String> validateReservation(
            String guestName,
            String address,
            String contactNo,
            String roomType,
            String checkInStr,
            String checkOutStr
    ) {
        Map<String, String> errors = new LinkedHashMap<>();

        // guestName
        if (isBlank(guestName)) {
            errors.put("guestName", "Guest name is required.");
        } else if (!guestName.trim().matches("[A-Za-z ]{2,50}")) {
            errors.put("guestName", "Only letters and spaces allowed (2–50 chars).");
        }

        // address
        if (isBlank(address)) {
            errors.put("address", "Address is required.");
        } else if (address.trim().length() < 5) {
            errors.put("address", "Address is too short.");
        }

        // contact
        if (isBlank(contactNo)) {
            errors.put("contactNo", "Contact number is required.");
        } else if (!contactNo.trim().matches("\\d{9,12}")) {
            errors.put("contactNo", "Contact must be 9–12 digits.");
        }

        // room type
        if (isBlank(roomType)) {
            errors.put("roomType", "Room type is required.");
        } else {
            String rt = roomType.trim().toUpperCase();
            if (!ALLOWED_ROOM_TYPES.contains(rt)) {
                errors.put("roomType", "Room type must be Standard / Deluxe / Suite.");
            }
        }

        // dates
        LocalDate checkIn = null;
        LocalDate checkOut = null;

        if (isBlank(checkInStr)) errors.put("checkIn", "Check-in date is required.");
        if (isBlank(checkOutStr)) errors.put("checkOut", "Check-out date is required.");

        if (!errors.containsKey("checkIn")) {
            try {
                checkIn = LocalDate.parse(checkInStr.trim());
            } catch (Exception e) {
                errors.put("checkIn", "Invalid date. Use YYYY-MM-DD.");
            }
        }

        if (!errors.containsKey("checkOut")) {
            try {
                checkOut = LocalDate.parse(checkOutStr.trim());
            } catch (Exception e) {
                errors.put("checkOut", "Invalid date. Use YYYY-MM-DD.");
            }
        }

        if (checkIn != null && checkOut != null) {
            if (!checkOut.isAfter(checkIn)) {
                errors.put("checkOut", "Check-out must be after check-in.");
            }

            // Optional rule: check-in today or later
            if (checkIn.isBefore(LocalDate.now())) {
                errors.put("checkIn", "Check-in must be today or a future date.");
            }
        }

        return errors;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
