package com.example.smokers_back.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "fruit_world_cup")
public class FruitEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "fruit", nullable = false, length = 100)
    private String fruit;

    @Lob
    @Column(name = "imageurl", nullable = false)
    private String imageurl;

}