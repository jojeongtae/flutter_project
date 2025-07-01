package com.example.smokers_back.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "beverage_world_cup")
public class BeverageEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "beverage", nullable = false, length = 100)
    private String beverage;

    @Lob
    @Column(name = "imageurl", nullable = false)
    private String imageurl;

}