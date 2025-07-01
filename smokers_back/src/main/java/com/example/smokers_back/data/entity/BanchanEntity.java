package com.example.smokers_back.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "banchan_world_cup")
public class BanchanEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "banchan", nullable = false, length = 100)
    private String banchan;

    @Lob
    @Column(name = "imageurl", nullable = false)
    private String imageurl;

}