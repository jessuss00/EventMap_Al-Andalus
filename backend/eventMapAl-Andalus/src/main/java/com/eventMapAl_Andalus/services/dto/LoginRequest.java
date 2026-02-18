package com.eventMapAl_Andalus.services.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor
public class LoginRequest {
    private String email; // Cambiado username por email
    private String password;
}