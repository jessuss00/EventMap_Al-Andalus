package com.eventMapAl_Andalus.persistence.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name="municipio")
@Getter
@Setter
@NoArgsConstructor
public class Municipio {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private String nombre;
    private String provincia;

    @OneToMany(mappedBy = "municipio", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<Evento> eventos;
}