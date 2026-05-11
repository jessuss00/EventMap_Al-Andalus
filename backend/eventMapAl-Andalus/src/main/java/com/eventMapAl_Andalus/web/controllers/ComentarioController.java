package com.eventMapAl_Andalus.web.controllers;

import com.eventMapAl_Andalus.persistence.entities.Comentario;
import com.eventMapAl_Andalus.persistence.entities.Usuario;
import com.eventMapAl_Andalus.persistence.repositories.UsuarioRepository;
import com.eventMapAl_Andalus.services.ComentarioService;
import com.eventMapAl_Andalus.services.exceptions.ComentarioException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/comentarios")
@CrossOrigin(origins = "*")
public class ComentarioController {

    @Autowired
    private ComentarioService comentarioService;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @GetMapping
    public List<Comentario> getAll() {
        return comentarioService.findAll();
    }

    @GetMapping("/evento/{eventoId}")
    public List<Comentario> getByEvento(@PathVariable int eventoId) {
        return comentarioService.findByEvento(eventoId);
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Map<String, Object> payload,
                                    Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body("Debes iniciar sesión para comentar.");
        }

        String email = authentication.getName();
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new ComentarioException("Usuario no encontrado"));

        int eventoId = (int) payload.get("eventoId");
        String texto = (String) payload.get("texto");
        int calificacion = ((Number) payload.get("calificacion")).intValue();

        Comentario comentario = comentarioService.save(usuario.getId(), eventoId, texto, calificacion);
        return ResponseEntity.ok(comentario);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable int id,
                                       Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).build();
        }

        String email = authentication.getName();
        Usuario requestingUser = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new ComentarioException("Usuario no encontrado"));

        boolean isAdmin = authentication.getAuthorities()
                .contains(new SimpleGrantedAuthority("ROLE_ADMIN"));

        comentarioService.delete(requestingUser.getId(), isAdmin, id);
        return ResponseEntity.noContent().build();
    }

}
