package com.eventMapAl_Andalus.persistence.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "detalle_evento")
@Getter
@Setter
@NoArgsConstructor
public class DetalleEvento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "fecha_inicio")
    private LocalDateTime fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDateTime fechaFin;

    private String subtipo;

    @Column(name = "descripcion_detallada", columnDefinition = "TEXT")
    private String descripcionDetallada;

    @Column(name = "localizacion_exacta")
    private String localizacionExacta;

    private String entradas;

    @OneToOne
    @JoinColumn(name = "evento", nullable = false)
    @JsonIgnore 
    private Evento evento;
}