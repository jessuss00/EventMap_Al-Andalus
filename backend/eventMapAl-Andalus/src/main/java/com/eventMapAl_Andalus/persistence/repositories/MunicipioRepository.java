package com.eventMapAl_Andalus.persistence.repositories;

import java.util.Optional;
import org.springframework.data.repository.ListCrudRepository;
import com.eventMapAl_Andalus.persistence.entities.Municipio;

public interface MunicipioRepository extends ListCrudRepository<Municipio, Integer> {
    
    // Para buscar un municipio por su nombre exacto
    Optional<Municipio> findByNombre(String nombre);
    
    // Para ver si existe un municipio por nombre (útil antes de crear uno)
    boolean existsByNombre(String nombre);
}