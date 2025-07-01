package com.example.smokers_back.data.dto;

import com.example.smokers_back.data.entity.UserEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ResultDTO {
    private Integer id;
//    private String topic;
    private String username;
    private String winnertype;
    private Integer winnerid;
    private LocalDateTime playedAt;
}
