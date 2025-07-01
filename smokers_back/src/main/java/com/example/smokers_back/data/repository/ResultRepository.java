package com.example.smokers_back.data.repository;

import com.example.smokers_back.data.entity.ResultEntity;
import com.example.smokers_back.data.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface ResultRepository extends JpaRepository<ResultEntity,Integer> {
    @Query("SELECT r FROM ResultEntity r WHERE r.username.username = :username")
    List<ResultEntity> findAllByUsername(@Param("username") String username);

    List<ResultEntity> findAllByWinnertype(String winnertype);

}
