package com.example.smokers_back.data.dao;

import com.example.smokers_back.data.dto.FoodDTO;
import com.example.smokers_back.data.entity.FoodEntity;
import com.example.smokers_back.data.repository.FoodRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FoodDAO {
    private final FoodRepository foodRepository;

    public List<FoodEntity> getAllFoods() {
        return foodRepository.findAll();
    }
}
