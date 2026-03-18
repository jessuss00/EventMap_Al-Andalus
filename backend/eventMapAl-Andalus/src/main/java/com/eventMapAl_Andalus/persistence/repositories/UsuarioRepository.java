package com.eventMapAl_Andalus.persistence.repositories;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.eventMapAl_Andalus.persistence.entities.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    
    Optional<Usuario> findByEmail(String email);
    
   
}