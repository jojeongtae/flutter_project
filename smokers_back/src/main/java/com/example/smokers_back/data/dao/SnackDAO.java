package com.example.smokers_back.data.dao;

import com.example.smokers_back.data.entity.SnackEntity;
import com.example.smokers_back.data.repository.SnackRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SnackDAO {
    private final SnackRepository snackRepository;

    public List<SnackEntity> getAllSnacks() {
        return snackRepository.findAll();
    }

}
