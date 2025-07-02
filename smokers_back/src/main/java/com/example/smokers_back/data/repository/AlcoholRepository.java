package com.example.smokers_back.data.repository;

import com.example.smokers_back.data.entity.AlcoholEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AlcoholRepository extends JpaRepository<AlcoholEntity,Integer> {
}
