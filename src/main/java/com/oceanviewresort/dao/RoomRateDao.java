package com.oceanviewresort.dao;

import java.math.BigDecimal;

public interface RoomRateDao {
    BigDecimal findRateByRoomType(String roomType);

    
    Integer findCapacityByRoomType(String roomType);
}