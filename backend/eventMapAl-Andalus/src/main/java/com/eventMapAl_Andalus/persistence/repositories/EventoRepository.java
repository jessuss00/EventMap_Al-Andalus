package com.eventMapAl_Andalus.persistence.repositories;

import java.util.List;
import org.springframework.data.repository.ListCrudRepository;
import com.eventMapAl_Andalus.persistence.entities.Evento;

public interface EventoRepository extends ListCrudRepository<Evento, Integer> {
    
    // Filtrar eventos por si están confirmados o no
    List<Evento> findByConfirmada(boolean confirmada);
    
    // Buscar eventos por tipo (ej: "Concierto", "Teatro")
    List<Evento> findByTipo(String tipo);
    
    // Buscar eventos de un municipio concreto (usando el objeto Municipio o su ID)
    List<Evento> findByMunicipioId(int idMunicipio);
    
    // Buscar eventos por nombre del municipio (navegando por la relación)
    List<Evento> findByMunicipioNombre(String nombreMunicipio);
}