package com.eventMapAl_Andalus.persistence.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "visita")
@Getter
@Setter
@NoArgsConstructor
public class Visita {

    @EmbeddedId
    private VisitaId id = new VisitaId();

    @ManyToOne
    @MapsId("usuario")
    @JoinColumn(name = "usuario")
    private Usuario usuario;

    @ManyToOne
    @MapsId("evento")
    @JoinColumn(name = "evento")
    private Evento evento;

    @Column(columnDefinition = "TEXT")
    private String comentarios;
}