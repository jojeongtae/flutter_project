package com.example.smokers_back.data.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FoodPairDTO {
    private FoodDTO item1;
    private FoodDTO item2;
}
