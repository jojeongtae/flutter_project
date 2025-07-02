package com.example.smokers_back.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "alcohol_world_cup")
public class AlcoholEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "alcohol", nullable = false, length = 100)
    private String alcohol;

    @Lob
    @Column(name = "imageurl", nullable = false)
    private String imageurl;

}