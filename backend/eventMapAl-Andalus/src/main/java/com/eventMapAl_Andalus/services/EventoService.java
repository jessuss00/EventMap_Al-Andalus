package com.eventMapAl_Andalus.services;

import com.eventMapAl_Andalus.persistence.entities.Evento;
import com.eventMapAl_Andalus.persistence.repositories.EventoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EventoService {

    @Autowired
    private EventoRepository eventoRepository;

    public List<Evento> getAllEventos() {
        return eventoRepository.findAll();
    }

    public Evento getEventoById(int id) {
        return eventoRepository.findById(id).orElse(null);
    }
}
