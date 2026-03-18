package com.eventMapAl_Andalus.persistence.repositories;

import java.util.Optional;
import org.springframework.data.repository.ListCrudRepository;
import com.eventMapAl_Andalus.persistence.entities.Municipio;

public interface MunicipioRepository extends ListCrudRepository<Municipio, Integer> {
    
    Optional<Municipio> findByNombre(String nombre);
    
    boolean existsByNombre(String nombre);
}