package com.eventMapAl_Andalus.persistence.repositories;

import java.util.List;
import org.springframework.data.repository.ListCrudRepository;
import com.eventMapAl_Andalus.persistence.entities.Evento;

public interface EventoRepository extends ListCrudRepository<Evento, Integer> {
    
    List<Evento> findByConfirmada(boolean confirmada);
    
    List<Evento> findByTipo(String tipo);
    
    List<Evento> findByMunicipioId(int idMunicipio);
    
    List<Evento> findByMunicipioNombre(String nombreMunicipio);
}