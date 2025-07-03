package com.example.smokers_back.service;

import com.example.smokers_back.data.dao.ResultDAO;
import com.example.smokers_back.data.dto.UserDTO;
import com.example.smokers_back.data.entity.UserEntity;
import com.example.smokers_back.data.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final ResultDAO resultDAO;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserDTO findUserByUsername(String username) {
        UserEntity userEntity = resultDAO.findUserByUsername(username);
        if(userEntity == null){
            return null;
        }
        return UserDTO.builder()
                .username(userEntity.getUsername())
                .password(userEntity.getPassword())
                .email(userEntity.getEmail())
                .nickname(userEntity.getNickname())
                .phone(userEntity.getPhone())
                .build();
    }

    public UserDTO modifyUser(UserDTO userDTO) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        UserEntity userEntity = resultDAO.findUserByUsername(username);

        if(userEntity==null){
            return null;
        }

        userEntity.setEmail(userDTO.getEmail());
        userEntity.setNickname(userDTO.getNickname());
        userEntity.setPhone(userDTO.getPhone());
        UserEntity saved=userRepository.save(userEntity);

        return UserDTO.builder()
                .username(saved.getUsername())
                .password(saved.getPassword())
                .email(saved.getEmail())
                .nickname(saved.getNickname())
                .phone(saved.getPhone())
                .build();
    }
}
