package com.example.smokers_back.service;

import com.example.smokers_back.data.dao.ItemDAO;
import com.example.smokers_back.data.dto.ItemDTO;
import com.example.smokers_back.data.dto.ItemPairDTO;
import com.example.smokers_back.data.entity.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ItemService {
    private final ItemDAO itemDAO;
    public List<ItemPairDTO> getShuffledPairs(String type){
        List<Object> entities=itemDAO.getItemsByType(type);

        List<ItemDTO> dtos=entities.stream()
                .map(this::convertToDTO)
                .toList();

        if(dtos.size()<2 || dtos.size()%2!=0){
            throw new IllegalStateException("Invalid type");
        }

        List<ItemPairDTO> pairs=new ArrayList<>();

        for(int i=0;i<dtos.size();i+=2){
            pairs.add(ItemPairDTO.builder()
                            .item1(dtos.get(i))
                            .item2(dtos.get(i+1))
                    .build());
        }
        Collections.shuffle(pairs);
        return pairs;
    }

    private ItemDTO convertToDTO(Object entity){
        if(entity instanceof FoodEntity f){
            return ItemDTO.builder()
                    .id(f.getId())
                    .name(f.getFood())
                    .imageurl(f.getImageurl())
                    .build();
        }else if(entity instanceof SnackEntity s){
            return ItemDTO.builder()
                    .id(s.getId())
                    .name(s.getSnack())
                    .imageurl(s.getImageurl())
                    .build();
        } else if(entity instanceof BeverageEntity be){
            return ItemDTO.builder()
                    .id(be.getId())
                    .name(be.getBeverage())
                    .imageurl(be.getImageurl())
                    .build();
        }else if(entity instanceof FruitEntity fr){
            return ItemDTO.builder()
                    .id(fr.getId())
                    .name(fr.getFruit())
                    .imageurl(fr.getImageurl())
                    .build();
        }else if(entity instanceof BanchanEntity ba){
            return ItemDTO.builder()
                    .id(ba.getId())
                    .name(ba.getBanchan())
                    .imageurl(ba.getImageurl())
                    .build();
        }else {
            throw new IllegalArgumentException("Invalid type");
        }
    }
}
