package com.eventMapAl_Andalus.persistence.entities;

import java.io.Serializable;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VisitaId implements Serializable {
    private int usuario;
    private int evento;
}