package com.eventMapAl_Andalus.web.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.eventMapAl_Andalus.persistence.entities.Evento;
import com.eventMapAl_Andalus.services.FavoritoService;

@RestController
@RequestMapping("/api/favoritos")
@CrossOrigin(origins = "*")
public class FavoritoController {

    @Autowired
    private FavoritoService favoritoService;

    @PostMapping("/{eventoId}")
    public ResponseEntity<Void> toggleFavorito(@PathVariable Integer eventoId, Authentication authentication) {
        favoritoService.toggleFavorito(authentication.getName(), eventoId);
        return ResponseEntity.ok().build();
    }

    @GetMapping
    public ResponseEntity<List<Evento>> getFavoritos(Authentication authentication) {
        return ResponseEntity.ok(favoritoService.getFavoritos(authentication.getName()));
    }

    @GetMapping("/check/{eventoId}")
    public ResponseEntity<Boolean> isFavorito(@PathVariable Integer eventoId, Authentication authentication) {
        return ResponseEntity.ok(favoritoService.isFavorito(authentication.getName(), eventoId));
    }
}
