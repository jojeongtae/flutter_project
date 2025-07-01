package com.example.smokers_back.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "snack_world_cup")
public class SnackEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "snack", nullable = false, length = 100)
    private String snack;

    @Lob
    @Column(name = "imageurl", nullable = false)
    private String imageurl;

}