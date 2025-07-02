package com.example.smokers_back.controller;

import com.example.smokers_back.data.dto.RankingDTO;
import com.example.smokers_back.data.dto.ResultDTO;
import com.example.smokers_back.data.entity.ResultEntity;
import com.example.smokers_back.data.entity.UserEntity;
import com.example.smokers_back.data.repository.ResultRepository;
import com.example.smokers_back.service.RankingService;
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
    private final RankingService rankingService;


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

//    @GetMapping(value="/{winnertype}")
//    public ResponseEntity<List<ResultDTO>> findAllByWinnerType(@PathVariable String winnertype){
//        List<ResultDTO> results=resultService.findAllByWinnerType(winnertype);
//        return ResponseEntity.ok(results);
//    }

    @GetMapping("/{winnertype}")
    public ResponseEntity<List<RankingDTO>> getRanking(@PathVariable String winnertype) {
        return ResponseEntity.ok(rankingService.getRanking(winnertype));
    }

    @GetMapping(value = "/comment")
    public ResponseEntity<List<ResultDTO>> getComments(@RequestParam Integer winnerid, @RequestParam String winnertype) {
        return ResponseEntity.ok(this.resultService.allComment(winnertype, winnerid));
    }


    @PutMapping(value = "/comment")
    public ResponseEntity<ResultDTO> updateComment(@RequestParam Integer id, @RequestParam String comment){
        return ResponseEntity.ok(this.resultService.addComment(id, comment));
    }

    @GetMapping(value = "/rating")
    public ResponseEntity<List<ResultDTO>> getRating(@RequestParam Integer winnerid, @RequestParam String winnertype) {
        return null;
    }
}
