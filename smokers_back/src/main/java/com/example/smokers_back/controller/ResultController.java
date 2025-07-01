package com.example.smokers_back.controller;

import com.example.smokers_back.data.dto.ResultDTO;
import com.example.smokers_back.data.entity.ResultEntity;
import com.example.smokers_back.data.entity.UserEntity;
import com.example.smokers_back.data.repository.ResultRepository;
import com.example.smokers_back.service.ResultService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/result")
public class ResultController {
    private final ResultService resultService;

    @PostMapping(value="/save")
    public ResponseEntity<ResultDTO> saveResult(@RequestBody ResultDTO resultDTO){
        try{
            ResultDTO saved=resultService.save(resultDTO);
            return ResponseEntity.ok(saved);
        }catch(IllegalArgumentException e){
            return ResponseEntity.badRequest().body(null);
        }catch(Exception e){
            return ResponseEntity.status(500).body(null);
        }
    }

    @GetMapping(value="/myfavorite")
    public ResponseEntity<List<ResultDTO>> findAllMyResults(@RequestParam String username){
        List<ResultDTO> results=resultService.findAllByUserName(username);
        return ResponseEntity.ok(results);
    }

    @GetMapping(value="/{winnertype}")
    public ResponseEntity<List<ResultDTO>> findAllByWinnerType(@PathVariable String winnertype){
        List<ResultDTO> results=resultService.findAllByWinnerType(winnertype);
        return ResponseEntity.ok(results);
    }

    @PutMapping(value = "/comment")
    public ResponseEntity<ResultDTO> updateComment(@RequestParam Integer id, @RequestParam String comment){
        return ResponseEntity.ok(this.resultService.addComment(id, comment));
    }
}
