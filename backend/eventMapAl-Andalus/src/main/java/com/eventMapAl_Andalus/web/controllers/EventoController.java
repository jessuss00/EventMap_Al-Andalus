package com.eventMapAl_Andalus.web.controllers;

import com.eventMapAl_Andalus.persistence.entities.Evento;
import com.eventMapAl_Andalus.services.EventoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/eventos")
public class EventoController {

    @Autowired
    private EventoService eventoService;

    @GetMapping
    public ResponseEntity<List<Evento>> getAllEventos() {
        List<Evento> eventos = eventoService.getAllEventos();
        return ResponseEntity.ok(eventos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Evento> getEventoById(@PathVariable("id") int id) {
        Evento evento = eventoService.getEventoById(id);
        if (evento != null) {
            return ResponseEntity.ok(evento);
        }
        return ResponseEntity.notFound().build();
    }

    @org.springframework.web.bind.annotation.PostMapping
    public ResponseEntity<Evento> createEvento(@org.springframework.web.bind.annotation.RequestBody Evento evento) {
        Evento savedEvento = eventoService.saveEvento(evento);
        return ResponseEntity.ok(savedEvento);
    }

    @org.springframework.web.bind.annotation.PutMapping("/{id}")
    public ResponseEntity<Evento> updateEvento(@PathVariable("id") int id, @org.springframework.web.bind.annotation.RequestBody Evento evento) {
        Evento updatedEvento = eventoService.updateEvento(id, evento);
        if (updatedEvento != null) {
            return ResponseEntity.ok(updatedEvento);
        }
        return ResponseEntity.notFound().build();
    }

    @org.springframework.web.bind.annotation.DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEvento(@PathVariable("id") int id) {
        eventoService.deleteEvento(id);
        return ResponseEntity.noContent().build();
    }
}
