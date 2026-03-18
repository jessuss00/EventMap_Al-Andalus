package com.eventMapAl_Andalus.persistence.repositories;

import java.util.List;
import org.springframework.data.repository.ListCrudRepository;

import com.eventMapAl_Andalus.persistence.entities.Visita;
import com.eventMapAl_Andalus.persistence.entities.VisitaId;

public interface VisitaRepository extends ListCrudRepository<Visita, VisitaId> {
    
    List<Visita> findByUsuarioId(int idUsuario);
    
    List<Visita> findByEventoId(int idEvento);
}