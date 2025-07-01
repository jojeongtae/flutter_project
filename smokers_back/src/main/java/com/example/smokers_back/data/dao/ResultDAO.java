package com.example.smokers_back.data.dao;

import com.example.smokers_back.data.entity.ResultEntity;
import com.example.smokers_back.data.entity.UserEntity;
import com.example.smokers_back.data.repository.ResultRepository;
import com.example.smokers_back.data.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ResultDAO {
    private final ResultRepository resultRepository;
    private final UserRepository userRepository;

    public boolean existsUserByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    public UserEntity findUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public ResultEntity save(ResultEntity resultEntity) {
        return resultRepository.save(resultEntity);
    }

    public List<ResultEntity> findAllByUserName(String username) {
        return resultRepository.findAllByUsername(username);
    }

    public List<ResultEntity> findAllByWinnerType(String winnertype) {
        return resultRepository.findAllByWinnertype(winnertype);
    }
}
