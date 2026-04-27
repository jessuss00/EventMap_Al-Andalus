import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EventoService } from '../../services/evento.service';
import { Evento } from '../../models/evento.model';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  eventos: Evento[] = [];
  loading: boolean = true;

  constructor(private eventoService: EventoService) {}

  ngOnInit(): void {
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
}

