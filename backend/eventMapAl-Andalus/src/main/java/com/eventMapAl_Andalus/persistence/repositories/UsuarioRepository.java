package com.eventMapAl_Andalus.persistence.repositories;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.eventMapAl_Andalus.persistence.entities.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    
    // Usaremos el email para el login, ya que es lo más parecido a un username único
    Optional<Usuario> findByEmail(String email);
    
    // Opcional: por si quieres buscar por nombre
    // Optional<Usuario> findByNombre(String nombre);
}