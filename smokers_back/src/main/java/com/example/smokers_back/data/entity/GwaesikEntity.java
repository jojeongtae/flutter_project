package com.example.smokers_back.data.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "gwaesik_world_cup")
public class GwaesikEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "gwaesik", nullable = false, length = 100)
    private String gwaesik;

    @Lob
    @Column(name = "imageurl", nullable = false)
    private String imageurl;

}