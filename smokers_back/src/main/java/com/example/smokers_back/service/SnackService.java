package com.example.smokers_back.service;

import com.example.smokers_back.data.dao.SnackDAO;
import com.example.smokers_back.data.dto.SnackDTO;
import com.example.smokers_back.data.dto.SnackPairDTO;
import com.example.smokers_back.data.entity.SnackEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SnackService {
    private final SnackDAO snackDAO;

    public List<SnackPairDTO> getShuffledPairs() {
        List<SnackEntity> snacks=snackDAO.getAllSnacks();

        if(snacks.size()<2 || snacks.size()%2!=0){
            throw new RuntimeException("음식 개수가 짝수가 아니거나 부족합니다.");
        }

        Collections.shuffle(snacks);
        List<SnackPairDTO> snackPairs=new ArrayList<>();
        for(int i=0;i<snacks.size();i+=2){
            SnackDTO snack1=convertToDTO(snacks.get(i));
            SnackDTO snack2=convertToDTO(snacks.get(i+1));
            snackPairs.add(new SnackPairDTO(snack1,snack2));
        }
        return snackPairs;
    }

    private SnackDTO convertToDTO(SnackEntity snack){
        return SnackDTO.builder()
                .id(snack.getId())
                .name(snack.getSnack())
                .imageurl(snack.getImageurl())
                .build();
    }
}
