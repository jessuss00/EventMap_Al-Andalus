package com.eventMapAl_Andalus.persistence.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "comentario")
@Getter
@Setter
@NoArgsConstructor
public class Comentario {

    @EmbeddedId
    private ComentarioId id = new ComentarioId();

    @ManyToOne
    @MapsId("usuario")
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;

    @ManyToOne
    @MapsId("evento")
    @JoinColumn(name = "evento_id")
    private Evento evento;

    @Column(name = "texto", columnDefinition = "TEXT")
    private String texto;

    @Column(name = "calificacion")
    private int calificacion;
}
