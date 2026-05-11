package com.eventMapAl_Andalus.web.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.eventMapAl_Andalus.persistence.entities.Municipio;
import com.eventMapAl_Andalus.services.MunicipioService;

@RestController
@RequestMapping("/api/municipios")
@CrossOrigin(origins = "*")
public class MunicipioController {

    @Autowired
    private MunicipioService municipioService;

    @GetMapping
    public ResponseEntity<List<Municipio>> getAllMunicipios() {
        return ResponseEntity.ok(municipioService.getAllMunicipios());
    }
}
