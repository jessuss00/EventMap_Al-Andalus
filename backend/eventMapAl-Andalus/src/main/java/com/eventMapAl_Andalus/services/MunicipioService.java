package com.eventMapAl_Andalus.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eventMapAl_Andalus.persistence.entities.Municipio;
import com.eventMapAl_Andalus.persistence.repositories.MunicipioRepository;

@Service
public class MunicipioService {
    
    @Autowired
    private MunicipioRepository municipioRepository;
    
    public List<Municipio> getAllMunicipios() {
        return municipioRepository.findAll();
    }
}
