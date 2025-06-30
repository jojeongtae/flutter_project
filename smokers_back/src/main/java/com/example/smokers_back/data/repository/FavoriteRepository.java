package com.example.smokers_back.data.repository;

import com.example.smokers_back.data.entity.FavoriteEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FavoriteRepository extends JpaRepository<FavoriteEntity, Integer> {
}
