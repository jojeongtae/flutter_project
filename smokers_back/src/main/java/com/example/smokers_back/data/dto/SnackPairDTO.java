package com.example.smokers_back.data.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SnackPairDTO {
    private SnackDTO item1;
    private SnackDTO item2;
}
