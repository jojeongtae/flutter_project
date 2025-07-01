package com.example.smokers_back.data.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "result")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ResultEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "matchid", nullable = false)
    private Integer id;

//    @Column(name = "topic", nullable = false, length = 100)
//    private String topic;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "username", nullable = false, referencedColumnName = "username")
    private UserEntity username;

    @Column(name = "winnertype", nullable = false, length = 100)
    private String winnertype;

    @Column(name = "winnerid", nullable = false)
    private Integer winnerid;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "played_at")
    private LocalDateTime playedAt;

    @Column(name = "comment", length = 100)
    private String comment;

}