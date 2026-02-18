package com.eventMapAl_Andalus.web.config;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.eventMapAl_Andalus.services.exceptions.*; // Importamos todas de golpe

@RestControllerAdvice
public class GlobalExceptionHandler {
    
    // --- ERRORES 404 (NOT FOUND) ---
    
    @ExceptionHandler({
        EventoNotFoundException.class, 
        MunicipioNotFoundException.class, 
        VisitaNotFoundException.class
    })
    public ResponseEntity<String> handleNotFound(RuntimeException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
    }
    
    // --- ERRORES 400 (BAD REQUEST) ---
    
    @ExceptionHandler({
        EventoException.class, 
        MunicipioException.class, 
        VisitaException.class,
        PasswordException.class
    })
    public ResponseEntity<String> handleBadRequest(RuntimeException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
    }
    
    // --- ERRORES GENÉRICOS (Para cazar lo que se nos escape) ---
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleGeneralError(Exception ex) {
        // En producción no es bueno mostrar ex.getMessage() de todo, pero para desarrollo ayuda
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body("Ocurrió un error inesperado: " + ex.getMessage());
    }
}