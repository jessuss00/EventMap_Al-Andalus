package com.eventMapAl_Andalus.services.exceptions;

// Fíjate que ponga 'extends RuntimeException'
public class VisitaException extends RuntimeException {
    
    private static final long serialVersionUID = 1L;

    public VisitaException(String message) {
        super(message);
    }
}