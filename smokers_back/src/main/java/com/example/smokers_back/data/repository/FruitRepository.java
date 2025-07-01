package com.example.smokers_back.data.repository;

import com.example.smokers_back.data.entity.FruitEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FruitRepository extends JpaRepository<FruitEntity, Integer> {
}
