package com.example.smokers_back.service;

import com.example.smokers_back.data.dao.ResultDAO;
import com.example.smokers_back.data.dto.ResultDTO;
import com.example.smokers_back.data.entity.ResultEntity;
import com.example.smokers_back.data.entity.UserEntity;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ResultService {
    private final ResultDAO resultDAO;

    public ResultDTO save(ResultDTO dto) {

        if(!resultDAO.existsUserByUsername(dto.getUsername())) {
            throw new IllegalArgumentException("User not found : "+dto.getUsername());
        }

        UserEntity user = resultDAO.findUserByUsername(dto.getUsername());
        ResultEntity entity=ResultEntity.builder()
                .username(user)
                .winnertype(dto.getWinnertype())
                .winnerid(dto.getWinnerid())
                .playedAt(LocalDateTime.now())
                .build();

        ResultEntity saved=resultDAO.save(entity);

        ResultDTO resultDTO = new ResultDTO();
        resultDTO.setUsername(user.getUsername());
        resultDTO.setWinnertype(saved.getWinnertype());
        resultDTO.setWinnerid(saved.getWinnerid());
        resultDTO.setPlayedAt(saved.getPlayedAt());
        return resultDTO;
    }

    public List<ResultDTO> findAllByUserName(String username) {
        List<ResultEntity> entityList=resultDAO.findAllByUserName(username);

        return entityList.stream()
                .map(entity->{
                    ResultDTO dto=new ResultDTO();
                    dto.setId(entity.getId());
                    dto.setUsername(entity.getUsername().getUsername());
                    dto.setWinnertype(entity.getWinnertype());
                    dto.setWinnerid(entity.getWinnerid());
                    dto.setPlayedAt(entity.getPlayedAt());
                    dto.setComment(entity.getComment());
                    return dto;
                })
                .collect(Collectors.toList());
    }

    public List<ResultDTO> findAllByWinnerType(String winnerType) {
        List<ResultEntity> entityList=resultDAO.findAllByWinnerType(winnerType);
        return entityList.stream()
                .map(entity->{
                    ResultDTO dto=new ResultDTO();
                    dto.setId(entity.getId());
                    dto.setUsername(entity.getUsername().getUsername());
                    dto.setWinnertype(entity.getWinnertype());
                    dto.setWinnerid(entity.getWinnerid());
                    dto.setPlayedAt(entity.getPlayedAt());
                    dto.setComment(entity.getComment());
                    return dto;
                })
                .collect(Collectors.toList());
    }

    public ResultDTO addComment(Integer id, String comment) {
        ResultEntity result = this.resultDAO.addComment(id, comment);
        if (result==null){
            throw new EntityNotFoundException("entity not found : "+id);
        }
        ResultDTO resultDTO = new ResultDTO();
        resultDTO.setId(result.getId());
        resultDTO.setUsername(result.getUsername().getUsername());
        resultDTO.setWinnertype(result.getWinnertype());
        resultDTO.setWinnerid(result.getWinnerid());
        resultDTO.setPlayedAt(result.getPlayedAt());
        resultDTO.setComment(result.getComment());
        return resultDTO;
    }

}
