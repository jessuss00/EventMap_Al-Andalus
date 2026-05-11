package com.eventMapAl_Andalus.persistence.repositories;

import com.eventMapAl_Andalus.persistence.entities.Comentario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ComentarioRepository extends JpaRepository<Comentario, Integer> {
    List<Comentario> findByEventoId(int eventoId);
    List<Comentario> findByUsuarioId(int usuarioId);
}

