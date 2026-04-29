package com.eventMapAl_Andalus.web.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.eventMapAl_Andalus.persistence.entities.Usuario;
import com.eventMapAl_Andalus.services.UsuarioService;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping("/me")
    public ResponseEntity<Usuario> getMyProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        Usuario usuario = usuarioService.findByEmail(email);
        
        if (usuario != null) {
            // Limpiamos el password por seguridad antes de enviarlo
            usuario.setPassword(null);
            return ResponseEntity.ok(usuario);
        }
        return ResponseEntity.notFound().build();
    }

    @PutMapping("/me")
    public ResponseEntity<Usuario> updateMyProfile(@RequestBody Usuario usuarioData) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        Usuario updated = usuarioService.update(email, usuarioData);
        
        if (updated != null) {
            updated.setPassword(null);
            return ResponseEntity.ok(updated);
        }
        return ResponseEntity.notFound().build();
    }
}
