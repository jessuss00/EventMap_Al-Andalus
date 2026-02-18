package com.eventMapAl_Andalus.services.exceptions;

public class MunicipioNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public MunicipioNotFoundException(String message) {
        super(message);
    }
}