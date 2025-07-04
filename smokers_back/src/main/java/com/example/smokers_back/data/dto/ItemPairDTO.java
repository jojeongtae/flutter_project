package com.example.smokers_back.data.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ItemPairDTO {
    private ItemDTO item1;
    private ItemDTO item2;
}
