import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { EventoService } from '../../services/evento.service';
import { AuthService } from '../../services/auth.service';
import { Evento } from '../../models/evento.model';
import { AndaluciaMapComponent } from '../andalucia-map/andalucia-map.component';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule, AndaluciaMapComponent],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  eventos: Evento[] = [];
  loading: boolean = true;
  isAdmin: boolean = false;
  isLoggedIn: boolean = false;
  favoritosIds: Set<number> = new Set();

  // Filtros
  filtroTipo: string = 'Todos';
  fechaInicioFiltro: string = '';
  fechaFinFiltro: string = '';
  filtroProvincia: string = 'Todas';
  searchText: string = '';

  constructor(
    private eventoService: EventoService,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    this.isAdmin = this.authService.isAdmin();
    this.isLoggedIn = this.authService.isLoggedIn();

    this.eventoService.searchQuery$.subscribe(query => {
      this.searchText = query;
    });

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

    if (this.isLoggedIn) {
      this.loadFavoritos();
    }
  }

  loadFavoritos(): void {
    this.eventoService.getFavoritos().subscribe({
      next: (favs) => {
        this.favoritosIds = new Set(favs.map(f => f.id));
      },
      error: (err) => console.error('Error loading favorites:', err)
    });
  }

  toggleFavorito(eventoId: number): void {
    if (!this.isLoggedIn) {
      return;
    }

    this.eventoService.toggleFavorito(eventoId).subscribe({
      next: () => {
        if (this.favoritosIds.has(eventoId)) {
          this.favoritosIds.delete(eventoId);
        } else {
          this.favoritosIds.add(eventoId);
        }
      },
      error: (err) => console.error('Error toggling favorite:', err)
    });
  }

  esFavorito(eventoId: number): boolean {
    return this.favoritosIds.has(eventoId);
  }

  filtrarPorProvincia(provincia: string) {
    if (this.filtroProvincia === provincia) {
      this.filtroProvincia = 'Todas'; // Toggle off
    } else {
      this.filtroProvincia = provincia;
    }
  }

  get eventosFiltrados(): Evento[] {
    return this.eventos.filter(ev => {
      // Filtro por Tipo
      const matchTipo = this.filtroTipo === 'Todos' || ev.tipo === this.filtroTipo;

      // Filtro por Provincia
      const matchProvincia = this.filtroProvincia === 'Todas' ||
        (ev.municipio && ev.municipio.provincia.toLowerCase() === this.filtroProvincia.toLowerCase());

      // Filtro por Rango de Fechas
      let matchFecha = true;
      if (ev.detalle) {
        const evInicio = ev.detalle.fechaInicio ? new Date(ev.detalle.fechaInicio).setHours(0, 0, 0, 0) : null;
        const evFin = ev.detalle.fechaFin ? new Date(ev.detalle.fechaFin).setHours(23, 59, 59, 999) :
          (evInicio !== null && ev.detalle.fechaInicio ? new Date(ev.detalle.fechaInicio).setHours(23, 59, 59, 999) : null);

        if (this.fechaInicioFiltro || this.fechaFinFiltro) {
          if (evInicio === null || evFin === null) {
            matchFecha = false;
          } else {
            const filtroInicio = this.fechaInicioFiltro ? new Date(this.fechaInicioFiltro).setHours(0, 0, 0, 0) : -Infinity;
            const filtroFin = this.fechaFinFiltro ? new Date(this.fechaFinFiltro).setHours(23, 59, 59, 999) : Infinity;
            matchFecha = (evInicio <= filtroFin && evFin >= filtroInicio);
          }
        }
      } else if (this.fechaInicioFiltro || this.fechaFinFiltro) {
        matchFecha = false;
      }

      // Filtro por Nombre, Provincia o Municipio (Buscador Global)
      const query = this.searchText.toLowerCase();
      const matchSearch = !this.searchText ||
        ev.nombre.toLowerCase().includes(query) ||
        (ev.municipio?.provincia?.toLowerCase().includes(query) ?? false) ||
        (ev.municipio?.nombre?.toLowerCase().includes(query) ?? false);

      return matchTipo && matchFecha && matchProvincia && matchSearch;
    });
  }
}
