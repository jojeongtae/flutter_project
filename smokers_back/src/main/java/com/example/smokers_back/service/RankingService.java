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
    private final AlcoholRepository alcoholRepository;
    private final GwaesikRepository gwaesikRepository;

    public List<RankingDTO> getRanking(String winnertype) {
        List<Object[]> rawData = resultRepository.findWinnerRanking(winnertype);

        List<RankingDTO> result = new ArrayList<>();
        Double total = 0.0;
        for (Object[] row : rawData) {
            total = total + (Long) row[1];
        }

        for (Object[] row : rawData) {
            Integer winnerid = (Integer) row[0];
            Long count = (Long) row[1];

            RankingDTO dto = getItemInfo(winnertype, winnerid, count.intValue(), total);
            result.add(dto);
        }
        return result;
    }

    private RankingDTO getItemInfo(String winnertype, Integer id, int count, Double total) {

        switch (winnertype) {
            case "food_world_cup":
                return foodRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getFood(), f.getImageurl(), count, count/total))
                        .orElseThrow(() -> new IllegalArgumentException("음식 없음"));
            case "snack_world_cup":
                return snackRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getSnack(), f.getImageurl(), count, count/total))
                        .orElseThrow(() -> new IllegalArgumentException("과자 없음"));
            case "fruit_world_cup":
                return fruitRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getFruit(), f.getImageurl(), count, count/total))
                        .orElseThrow(() -> new IllegalArgumentException("과일 없음"));
            case "banchan_world_cup":
                return banchanRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getBanchan(), f.getImageurl(), count, count/total))
                        .orElseThrow(() -> new IllegalArgumentException("반찬 없음"));
            case "beverage_world_cup":
                return beverageRepository.findById(id)
                        .map(f -> new RankingDTO(f.getId(), f.getBeverage(), f.getImageurl(), count, count/total))
                        .orElseThrow(() -> new IllegalArgumentException("음료 없음"));
            case "alcohol_world_cup":
                return alcoholRepository.findById(id)
                        .map(f->new RankingDTO(f.getId(), f.getAlcohol(), f.getImageurl(), count, count/total))
                        .orElseThrow(() -> new IllegalArgumentException("알코올 없음"));
            case "gwaesik_world_cup":
                return gwaesikRepository.findById(id)
                        .map(f->new RankingDTO(f.getId(), f.getGwaesik(), f.getImageurl(), count, count/total))
                        .orElseThrow(() -> new IllegalArgumentException("괴식 없음"));
            default:
                throw new IllegalArgumentException("지원하지 않는 타입: " + winnertype);
        }
    }
}
