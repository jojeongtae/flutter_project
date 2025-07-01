package com.example.smokers_back.data.repository;

import com.example.smokers_back.data.dto.SnackDTO;
import com.example.smokers_back.data.entity.SnackEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SnackRepository extends JpaRepository<SnackEntity,Integer> {
}
