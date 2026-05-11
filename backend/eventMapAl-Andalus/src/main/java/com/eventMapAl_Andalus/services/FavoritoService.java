package com.eventMapAl_Andalus.services;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eventMapAl_Andalus.persistence.entities.Evento;
import com.eventMapAl_Andalus.persistence.entities.Usuario;
import com.eventMapAl_Andalus.persistence.repositories.EventoRepository;
import com.eventMapAl_Andalus.persistence.repositories.UsuarioRepository;

@Service
public class FavoritoService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private EventoRepository eventoRepository;

    public void toggleFavorito(String email, Integer eventoId) {
        Usuario usuario = usuarioRepository.findByEmail(email).orElse(null);
        if (usuario == null)
            return;

        String favoritos = usuario.getFavoritosIds();
        if (favoritos == null)
            favoritos = "";

        List<String> ids = new ArrayList<>(Arrays.asList(favoritos.split(",")));
        ids.removeIf(String::isEmpty);

        String idStr = String.valueOf(eventoId);
        if (ids.contains(idStr)) {
            ids.remove(idStr);
        } else {
            ids.add(idStr);
        }

        usuario.setFavoritosIds(String.join(",", ids));
        usuarioRepository.save(usuario);
    }

    public List<Evento> getFavoritos(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email).orElse(null);
        if (usuario == null || usuario.getFavoritosIds() == null || usuario.getFavoritosIds().isEmpty()) {
            return new ArrayList<>();
        }

        List<Integer> ids = Arrays.stream(usuario.getFavoritosIds().split(","))
                .filter(s -> !s.isEmpty())
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        if (ids.isEmpty())
            return new ArrayList<>();

        return ids.stream()
                .map(id -> eventoRepository.findById(id).orElse(null))
                .filter(e -> e != null)
                .collect(Collectors.toList());
    }

    public boolean isFavorito(String email, Integer eventoId) {
        Usuario usuario = usuarioRepository.findByEmail(email).orElse(null);
        if (usuario == null || usuario.getFavoritosIds() == null)
            return false;

        List<String> ids = Arrays.asList(usuario.getFavoritosIds().split(","));
        return ids.contains(String.valueOf(eventoId));
    }
}
