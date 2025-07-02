package com.example.smokers_back.service;

import com.example.smokers_back.data.dao.ResultDAO;
import com.example.smokers_back.data.dto.RankingDTO;
import com.example.smokers_back.data.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RankingService {

    private final ResultDAO resultDAO;
    private final FoodRepository foodRepository;
    private final SnackRepository snackRepository;
    private final FruitRepository fruitRepository;
    private final BanchanRepository banchanRepository;
    private final ResultRepository  resultRepository;
    private  final BeverageRepository beverageRepository;

    public List<RankingDTO> getRanking(String winnertype) {
        List<Object[]> rawData = resultRepository.findWinnerRanking(winnertype);

        List<RankingDTO> result = new ArrayList<>();
        for (Object[] row : rawData) {
            Integer winnerid = (Integer) row[0];
            Long count = (Long) row[1];

            RankingDTO dto = getItemInfo(winnertype, winnerid, count.intValue());
            result.add(dto);
        }
        return result;
    }

    private RankingDTO getItemInfo(String winnertype, Integer id, int count) {
        switch (winnertype) {
            case "food_world_cup":
                return foodRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getFood(), f.getImageurl(), count))
                        .orElseThrow(() -> new IllegalArgumentException("음식 없음"));
            case "snack_world_cup":
                return snackRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getSnack(), f.getImageurl(), count))
                        .orElseThrow(() -> new IllegalArgumentException("과자 없음"));
            case "fruit_world_cup":
                return fruitRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getFruit(), f.getImageurl(), count))
                        .orElseThrow(() -> new IllegalArgumentException("과일 없음"));
            case "banchan_world_cup":
                return banchanRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getBanchan(), f.getImageurl(), count))
                        .orElseThrow(() -> new IllegalArgumentException("반찬 없음"));
            case "beverage_world_cup":
                return beverageRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getBeverage(), f.getImageurl(), count))
                        .orElseThrow(() -> new IllegalArgumentException("반찬 없음"));
            default:
                throw new IllegalArgumentException("지원하지 않는 타입: " + winnertype);
        }
    }
}
