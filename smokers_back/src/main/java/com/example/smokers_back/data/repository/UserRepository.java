package com.example.smokers_back.data.repository;

import com.example.smokers_back.data.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {
    UserEntity findByUsername(String username);

    boolean existsByUsername(String username);
}
