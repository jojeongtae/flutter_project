package com.example.smokers_back.data.dao;

import com.example.smokers_back.data.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
@RequiredArgsConstructor
public class ItemDAO {
    private final FoodRepository foodRepository;
    private final SnackRepository snackRepository;
    private final FruitRepository fruitRepository;
    private final BeverageRepository beverageRepository;
    private final BanchanRepository banchanRepository;

    public List<Object> getItemsByType(String type){
        return switch(type.toLowerCase()){
            case "food" -> new ArrayList<>(foodRepository.findAll());
            case "snack" -> new ArrayList<>(snackRepository.findAll());
            case "fruit" -> new ArrayList<>(fruitRepository.findAll());
            case "beverage" -> new ArrayList<>(beverageRepository.findAll());
            case "banchan" -> new ArrayList<>(banchanRepository.findAll());
            default -> throw new IllegalArgumentException("Invalid type");
        };
    }
}
