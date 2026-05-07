import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EventoService } from '../../services/evento.service';
import { Evento } from '../../models/evento.model';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-favorites',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './favorites.component.html',
  styleUrl: './favorites.component.css'
})
export class FavoritesComponent implements OnInit {
  private eventoService = inject(EventoService);

  loading = true;
  favoritos: Evento[] = [];

  ngOnInit(): void {
    this.loadFavoritos();
  }

  loadFavoritos(): void {
    this.eventoService.getFavoritos().subscribe({
      next: (data) => {
        this.favoritos = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error loading favorites:', err);
        this.loading = false;
      }
    });
  }

  quitarFavorito(eventoId: number): void {
    this.eventoService.toggleFavorito(eventoId).subscribe({
      next: () => {
        this.favoritos = this.favoritos.filter(f => f.id !== eventoId);
      },
      error: (err) => console.error('Error removing favorite:', err)
    });
  }
}
