package com.eventMapAl_Andalus.services;

import com.eventMapAl_Andalus.persistence.entities.Comentario;
import com.eventMapAl_Andalus.persistence.entities.ComentarioId;
import com.eventMapAl_Andalus.persistence.entities.Evento;
import com.eventMapAl_Andalus.persistence.entities.Usuario;
import com.eventMapAl_Andalus.persistence.repositories.ComentarioRepository;
import com.eventMapAl_Andalus.persistence.repositories.EventoRepository;
import com.eventMapAl_Andalus.persistence.repositories.UsuarioRepository;
import com.eventMapAl_Andalus.services.exceptions.ComentarioException;
import com.eventMapAl_Andalus.services.exceptions.ComentarioNotFoundException;
import com.eventMapAl_Andalus.services.exceptions.EventoNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ComentarioService {

    @Autowired
    private ComentarioRepository comentarioRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private EventoRepository eventoRepository;

    public List<Comentario> findAll() {
        return comentarioRepository.findAll();
    }

    public List<Comentario> findByEvento(int eventoId) {
        return comentarioRepository.findByEventoId(eventoId);
    }

    @Transactional
    public Comentario save(int usuarioId, int eventoId, String texto, int calificacion) {
        if (calificacion < 0 || calificacion > 5) {
            throw new ComentarioException("La calificación debe estar entre 0 y 5");
        }

        ComentarioId id = new ComentarioId(usuarioId, eventoId);
        if (comentarioRepository.existsById(id)) {
            throw new ComentarioException("Ya has publicado un comentario en este evento.");
        }

        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ComentarioException("Usuario no encontrado"));
        Evento evento = eventoRepository.findById(eventoId)
                .orElseThrow(() -> new EventoNotFoundException("Evento no encontrado"));

        Comentario comentario = new Comentario();
        comentario.setUsuario(usuario);
        comentario.setEvento(evento);
        comentario.setTexto(texto);
        comentario.setCalificacion(calificacion);

        return comentarioRepository.save(comentario);
    }

    /**
     * Deletes a comment.
     * @param requestingUserId  The ID of the user making the request.
     * @param isAdmin           Whether the requesting user is an admin.
     * @param comentarioUsuarioId The ID of the user who owns the comment.
     * @param eventoId          The event ID.
     */
    @Transactional
    public void delete(int requestingUserId, boolean isAdmin, int comentarioUsuarioId, int eventoId) {
        ComentarioId id = new ComentarioId(comentarioUsuarioId, eventoId);
        if (!comentarioRepository.existsById(id)) {
            throw new ComentarioNotFoundException("Comentario no encontrado");
        }
        // Only owner or admin can delete
        if (!isAdmin && requestingUserId != comentarioUsuarioId) {
            throw new ComentarioException("No tienes permiso para eliminar este comentario");
        }
        comentarioRepository.deleteById(id);
    }
}
