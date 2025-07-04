package com.example.smokers_back.data.dto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RankingDTO {
    private Integer id;
    private String name;
    private String imageurl;
    private Integer count;
    private Double rating;
}
