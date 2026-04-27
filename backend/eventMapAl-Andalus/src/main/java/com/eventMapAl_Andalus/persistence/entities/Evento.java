package com.eventMapAl_Andalus.persistence.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "evento")
@Getter
@Setter
@NoArgsConstructor
public class Evento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String nombre;
    
    public enum TipoEvento {
        Cultural, Nocturno, Deportivo
    }

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoEvento tipo;

    @Column(name = "descripcion_simple", columnDefinition = "TEXT")
    private String descripcionSimple;

    private boolean confirmada;
    
    // Añadimos el campo imagen
    private String imagen;

    @ManyToOne
    @JoinColumn(name = "municipio") 
    private Municipio municipio;

    // Relación 1 a 1 con el detalle
    @OneToOne(mappedBy = "evento", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private DetalleEvento detalle;
    
    @OneToMany(mappedBy = "evento")
    @JsonIgnore
    private List<Visita> visitas;
}