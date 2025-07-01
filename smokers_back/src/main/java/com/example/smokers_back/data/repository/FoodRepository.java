package com.example.smokers_back.data.repository;

import com.example.smokers_back.data.entity.FoodEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FoodRepository extends JpaRepository<FoodEntity, Integer> {
}
