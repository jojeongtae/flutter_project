package com.example.smokers_back.data.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Fetch;
import org.springframework.data.repository.cdi.Eager;

import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "users")
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "userid", nullable = false)
    private Integer id;

    @Column(name = "username", nullable = false, length = 100)
    private String username;

    @Column(name = "email", nullable = false, length = 100)
    private String email;

    @Column(name = "password", nullable = false, length = 100)
    private String password;

    @Column(name = "nickname", nullable = false, length = 100)
    private String nickname;

    @Column(name = "phone", length = 100)
    private String phone;

    @ColumnDefault("'ROLE_USER'")
    @Column(name = "role", nullable = false, length = 100)
    private String role;

    @OneToMany(mappedBy = "userid", fetch = FetchType.EAGER)
    private Set<FavoriteEntity> favorites = new LinkedHashSet<>();

}