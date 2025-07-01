package com.example.smokers_back.controller;

import com.example.smokers_back.data.dto.FoodPairDTO;
import com.example.smokers_back.service.FoodService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/food")
public class FoodController {
    private final FoodService foodService;

    @GetMapping("/round")
    public ResponseEntity<List<FoodPairDTO>> getFoodPairs(){
        return ResponseEntity.ok(foodService.getShuffledPairs());
    }
}
