package com.eventMapAl_Andalus.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.eventMapAl_Andalus.persistence.entities.Usuario;
import com.eventMapAl_Andalus.persistence.repositories.UsuarioRepository;
import com.eventMapAl_Andalus.services.dto.RegisterRequest;

@Service
public class UsuarioService implements UserDetailsService {
    
    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        // Buscamos por email en lugar de username
        Usuario usuario = this.usuarioRepository.findByEmail(email).orElseThrow(
                () -> new UsernameNotFoundException("El usuario con email " + email + " no existe."));
        
        // Como tu BBDD no tiene roles, asignamos "USER" por defecto a todos
        return User.builder()
                .username(usuario.getEmail())
                .password(usuario.getPassword())
                .roles("USER") 
                .build();
    }
    
    // Método adaptado para recibir todos los datos del registro nuevo
    public Usuario create(RegisterRequest request) {
        Usuario usuario = new Usuario();
        usuario.setNombre(request.getNombre());
        usuario.setApellidos(request.getApellidos());
        usuario.setEmail(request.getEmail());
        usuario.setDni(request.getDni());
        usuario.setEdad(request.getEdad());
        
        // Encriptamos la contraseña igual que en el proyecto anterior
        usuario.setPassword(new BCryptPasswordEncoder().encode(request.getPassword1()));
        
        return usuarioRepository.save(usuario);
    }
}