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
    
    public Evento saveEvento(Evento evento) {
        if (evento.getDetalle() != null) {
            evento.getDetalle().setEvento(evento);
        }
        return eventoRepository.save(evento);
    }

    public Evento updateEvento(int id, Evento eventoDetalles) {
        Evento evento = getEventoById(id);
        if (evento != null) {
            evento.setNombre(eventoDetalles.getNombre());
            evento.setTipo(eventoDetalles.getTipo());
            evento.setDescripcionSimple(eventoDetalles.getDescripcionSimple());
            evento.setConfirmada(eventoDetalles.isConfirmada());
            evento.setMunicipio(eventoDetalles.getMunicipio());
            evento.setImagen(eventoDetalles.getImagen());
            
            if (evento.getDetalle() != null && eventoDetalles.getDetalle() != null) {
                evento.getDetalle().setFechaInicio(eventoDetalles.getDetalle().getFechaInicio());
                evento.getDetalle().setFechaFin(eventoDetalles.getDetalle().getFechaFin());
                evento.getDetalle().setSubtipo(eventoDetalles.getDetalle().getSubtipo());
                evento.getDetalle().setDescripcionDetallada(eventoDetalles.getDetalle().getDescripcionDetallada());
                evento.getDetalle().setLocalizacionExacta(eventoDetalles.getDetalle().getLocalizacionExacta());
                evento.getDetalle().setEntradas(eventoDetalles.getDetalle().getEntradas());
            } else if (eventoDetalles.getDetalle() != null) {
                eventoDetalles.getDetalle().setEvento(evento);
                evento.setDetalle(eventoDetalles.getDetalle());
            }
            
            return eventoRepository.save(evento);
        }
        return null;
    }

    public void deleteEvento(int id) {
        eventoRepository.deleteById(id);
    }
}
