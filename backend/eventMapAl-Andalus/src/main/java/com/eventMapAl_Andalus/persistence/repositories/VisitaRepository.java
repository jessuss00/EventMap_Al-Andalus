package com.eventMapAl_Andalus.persistence.repositories;

import java.util.List;
import org.springframework.data.repository.ListCrudRepository;

import com.eventMapAl_Andalus.persistence.entities.Visita;
import com.eventMapAl_Andalus.persistence.entities.VisitaId;

public interface VisitaRepository extends ListCrudRepository<Visita, VisitaId> {
    
    // Obtener todas las visitas (asistencias) de un usuario concreto
    List<Visita> findByUsuarioId(int idUsuario);
    
    // Ver quién va a asistir a un evento concreto
    List<Visita> findByEventoId(int idEvento);
}