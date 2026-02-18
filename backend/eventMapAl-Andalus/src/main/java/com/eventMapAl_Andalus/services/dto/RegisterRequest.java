package com.eventMapAl_Andalus.services.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor
public class RegisterRequest {
    private String nombre;
    private String apellidos;
    private String email;
    private String dni;
    private Integer edad;
    private String password1;
    private String password2;
}