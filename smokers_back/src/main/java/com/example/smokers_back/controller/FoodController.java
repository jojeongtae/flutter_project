package com.example.smokers_back.controller;

import com.example.smokers_back.data.dto.FoodPairDTO;
import com.example.smokers_back.data.dto.SnackPairDTO;
import com.example.smokers_back.service.FoodService;
import com.example.smokers_back.service.SnackService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor

public class FoodController {
    private final FoodService foodService;
    private final SnackService snackService;

    @GetMapping("/food")
    public ResponseEntity<List<FoodPairDTO>> getFoodPairs(){
        return ResponseEntity.ok(foodService.getShuffledPairs());
    }

    @GetMapping("/snack")
    public ResponseEntity<List<SnackPairDTO>> getSnackPairs(){
        return ResponseEntity.ok(snackService.getShuffledPairs());
    }
}
