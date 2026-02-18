package com.eventMapAl_Andalus.services.exceptions;

public class VisitaNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public VisitaNotFoundException(String message) {
        super(message);
    }
}