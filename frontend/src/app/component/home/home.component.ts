import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { EventoService } from '../../services/evento.service';
import { AuthService } from '../../services/auth.service';
import { Evento } from '../../models/evento.model';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  eventos: Evento[] = [];
  loading: boolean = true;
  isAdmin: boolean = false;
  
  // Filtros
  filtroTipo: string = 'Todos';
  fechaInicioFiltro: string = '';
  fechaFinFiltro: string = '';

  constructor(
    private eventoService: EventoService,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    this.isAdmin = this.authService.isAdmin();
    this.eventoService.getEventos().subscribe({
      next: (data) => {
        this.eventos = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error fetching events:', err);
        this.loading = false;
      }
    });
  }

  get eventosFiltrados(): Evento[] {
    return this.eventos.filter(ev => {
      // Filtro por Tipo
      const matchTipo = this.filtroTipo === 'Todos' || ev.tipo === this.filtroTipo;
      
      // Filtro por Rango de Fechas
      let matchFecha = true;
      if (ev.detalle) {
        const evInicio = ev.detalle.fechaInicio ? new Date(ev.detalle.fechaInicio).setHours(0,0,0,0) : null;
        // Si no tiene fechaFin, asumimos que termina el mismo día que empieza
        const evFin = ev.detalle.fechaFin ? new Date(ev.detalle.fechaFin).setHours(23,59,59,999) : 
                      (evInicio !== null && ev.detalle.fechaInicio ? new Date(ev.detalle.fechaInicio).setHours(23,59,59,999) : null);

        if (this.fechaInicioFiltro || this.fechaFinFiltro) {
          if (evInicio === null || evFin === null) {
            matchFecha = false; // Si estamos filtrando por fecha y el evento no tiene fechas, lo ocultamos
          } else {
            const filtroInicio = this.fechaInicioFiltro ? new Date(this.fechaInicioFiltro).setHours(0,0,0,0) : -Infinity;
            const filtroFin = this.fechaFinFiltro ? new Date(this.fechaFinFiltro).setHours(23,59,59,999) : Infinity;

            // Condición de solapamiento: (El evento empieza antes de que acabe el filtro) Y (El evento acaba después de que empiece el filtro)
            matchFecha = (evInicio <= filtroFin && evFin >= filtroInicio);
          }
        }
      } else if (this.fechaInicioFiltro || this.fechaFinFiltro) {
         // Si se filtra por fecha pero el evento no tiene detalles
         matchFecha = false;
      }
      
      return matchTipo && matchFecha;
    });
  }
}

