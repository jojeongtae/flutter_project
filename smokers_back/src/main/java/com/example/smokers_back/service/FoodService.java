package com.example.smokers_back.service;

import com.example.smokers_back.data.dao.FoodDAO;
import com.example.smokers_back.data.dto.FoodDTO;
import com.example.smokers_back.data.dto.FoodPairDTO;
import com.example.smokers_back.data.entity.FoodEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FoodService {
    private final FoodDAO foodDAO;

    public List<FoodPairDTO> getShuffledPairs() {
        List<FoodEntity> foods=foodDAO.getAllFoods();

        if(foods.size()<2 || foods.size()%2!=0){
            throw new RuntimeException("음식 개수가 짝수가 아니거나 부족합니다.");
        }

        Collections.shuffle(foods);
        List<FoodPairDTO> foodPairs=new ArrayList<>();
        for(int i=0;i<foods.size();i+=2){
            FoodDTO food1=convertToDTO(foods.get(i));
            FoodDTO food2=convertToDTO(foods.get(i+1));
            foodPairs.add(new FoodPairDTO(food1,food2));
        }
        return foodPairs;
    }

    private FoodDTO convertToDTO(FoodEntity food){
        return FoodDTO.builder()
                .id(food.getId())
                .name(food.getFood())
                .imageurl(food.getImageurl())
                .build();
    }
}
