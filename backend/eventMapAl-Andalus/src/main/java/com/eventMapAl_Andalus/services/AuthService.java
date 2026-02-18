package com.eventMapAl_Andalus.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.eventMapAl_Andalus.services.dto.LoginRequest;
import com.eventMapAl_Andalus.services.dto.LoginResponse;
import com.eventMapAl_Andalus.services.dto.RefreshDTO;
import com.eventMapAl_Andalus.services.dto.RegisterRequest;
import com.eventMapAl_Andalus.web.config.JwtUtils;

@Service
public class AuthService {
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private JwtUtils jwtUtil;
    
    @Autowired
    private UsuarioService usuarioService;
    
    public LoginResponse login(LoginRequest request) {
        // Autenticamos usando el EMAIL (request.getEmail)
        Authentication authentication = authenticationManager
                .authenticate(new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));
        
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        String accessToken = jwtUtil.generateAccessToken(userDetails);
        String refreshToken = jwtUtil.generateRefreshToken(userDetails);
        
        LoginResponse response = new LoginResponse();
        response.setAccess(accessToken);
        response.setRefresh(refreshToken);

        return response;
    }
    
    public LoginResponse registrar(RegisterRequest request) {
        if(!request.getPassword1().equals(request.getPassword2())) {
            throw new RuntimeException("Las contraseñas no coinciden"); // Excepción simple por ahora
        }
        
        // Creamos el usuario
        this.usuarioService.create(request);
        
        // Lo autenticamos automáticamente tras el registro
        Authentication authentication = authenticationManager
                .authenticate(new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword1()));
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        
        String accessToken = jwtUtil.generateAccessToken(userDetails);
        String refreshToken = jwtUtil.generateRefreshToken(userDetails);
        
        LoginResponse response = new LoginResponse();
        response.setAccess(accessToken);
        response.setRefresh(refreshToken);

        return response;
    }
    
    public LoginResponse refresh(RefreshDTO dto) {
        String accessToken = jwtUtil.generateAccessToken(dto.getRefresh());
        String refreshToken = jwtUtil.generateRefreshToken(dto.getRefresh());

        LoginResponse response = new LoginResponse();
        response.setAccess(accessToken);
        response.setRefresh(refreshToken);

        return response;
    }
}