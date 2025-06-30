package com.example.smokers_back.data.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "restaurant")
public class RestaurantEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "resid", nullable = false)
    private Integer id;

    @Column(name = "resname", nullable = false, length = 100)
    private String resname;

    @Column(name = "rescategory", nullable = false, length = 100)
    private String rescategory;

    @Column(name = "resaddr", nullable = false, length = 100)
    private String resaddr;

    @Column(name = "resaddrpoint", nullable = false, length = 100)
    private String resaddrpoint;

    @OneToMany(mappedBy = "resid")
    private Set<FavoriteEntity> favorites = new LinkedHashSet<>();

}