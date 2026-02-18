package com.eventMapAl_Andalus.services.exceptions;

public class EventoSecurityException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public EventoSecurityException(String message) {
        super(message);
    }
}