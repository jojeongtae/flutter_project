package com.example.smokers_back.data.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SnackDTO {
    private Integer id;
    private String name;
    private String imageurl;
}
