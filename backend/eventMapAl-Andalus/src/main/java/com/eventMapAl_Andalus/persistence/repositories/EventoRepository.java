package com.eventMapAl_Andalus.persistence.repositories;

import java.util.List;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.repository.ListCrudRepository;
import com.eventMapAl_Andalus.persistence.entities.Evento;
import java.util.Optional;

public interface EventoRepository extends ListCrudRepository<Evento, Integer> {
    
    @EntityGraph(attributePaths = {"detalle", "municipio"})
    Optional<Evento> findById(Integer id);

    @EntityGraph(attributePaths = {"detalle", "municipio"})
    List<Evento> findAll();

    List<Evento> findByConfirmada(boolean confirmada);
    
    List<Evento> findByTipo(String tipo);
    
    List<Evento> findByMunicipioId(int idMunicipio);
    
    List<Evento> findByMunicipioNombre(String nombreMunicipio);
}