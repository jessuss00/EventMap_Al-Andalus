package com.eventMapAl_Andalus.persistence.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name="usuario") 
@Getter
@Setter
@NoArgsConstructor
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private String nombre;
    private String apellidos;
    private String email;
    private Integer edad; 
    private String dni;
    
    @Column(name = "contraseña")
    private String password; 
    
    private boolean admin;
    
    @OneToMany(mappedBy = "usuario", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<Comentario> comentarios;
}