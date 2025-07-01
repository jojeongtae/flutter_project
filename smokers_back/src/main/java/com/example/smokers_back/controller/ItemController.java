package com.example.smokers_back.controller;

import com.example.smokers_back.data.dto.ItemPairDTO;
import com.example.smokers_back.service.ItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor

public class ItemController {
    private final ItemService itemService;

    @GetMapping("/{type}")
    public ResponseEntity<List<ItemPairDTO>> getItemPairs(@PathVariable String type){
        try{
            List<ItemPairDTO> pairs=itemService.getShuffledPairs(type);
            return ResponseEntity.ok(pairs);
        }catch(IllegalArgumentException e){
            return ResponseEntity.badRequest().body(null);
        }catch(IllegalStateException e){
            return ResponseEntity.status(500).body(null);
        }
    }
}
