import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { RouterLink, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../services/auth.service';
import { EventoService } from '../../services/evento.service';
import { Evento } from '../../models/evento.model';

@Component({
  selector: 'app-landing',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './landing.component.html',
  styleUrl: './landing.component.css'
})
export class LandingComponent implements OnInit, OnDestroy {
  private authService = inject(AuthService);
  private router = inject(Router);
  private eventoService = inject(EventoService);

  targetDate: Date = new Date(); 
  nextEventName: string = 'Próximo Evento';
  months: string = '00';
  days: string = '00';
  hours: string = '00';
  minutes: string = '00';
  private timer: any;

  ngOnInit(): void {
    if (this.authService.isLoggedIn()) {
      this.router.navigate(['/home']);
    }
    this.loadNextEvent();
  }

  private loadNextEvent(): void {
    this.eventoService.getEventos().subscribe({
      next: (eventos) => {
        const now = new Date();
        const futureEvents = eventos
          .filter(ev => ev.detalle && ev.detalle.fechaInicio)
          .map(ev => ({
            nombre: ev.nombre,
            fecha: new Date(ev.detalle!.fechaInicio!)
          }))
          .filter(ev => ev.fecha > now)
          .sort((a, b) => a.fecha.getTime() - b.fecha.getTime());

        if (futureEvents.length > 0) {
          this.targetDate = futureEvents[0].fecha;
          this.nextEventName = futureEvents[0].nombre;
          this.startCountdown();
        } else {
          // Fallback si no hay eventos futuros con fecha válida
          this.targetDate = new Date(now.getFullYear(), now.getMonth() + 2, now.getDate());
          this.startCountdown();
        }
      },
      error: (err) => {
        console.error('Error loading events for landing:', err);
        const now = new Date();
        this.targetDate = new Date(now.getFullYear(), now.getMonth() + 1, now.getDate());
        this.startCountdown();
      }
    });
  }

  ngOnDestroy(): void {
    if (this.timer) {
      clearInterval(this.timer);
    }
  }

  private startCountdown(): void {
    this.updateCountdown();
    this.timer = setInterval(() => {
      this.updateCountdown();
    }, 60000);
  }

  private updateCountdown(): void {
    const now = new Date().getTime();
    const distance = this.targetDate.getTime() - now;

    if (distance < 0) {
      this.months = '00';
      this.days = '00';
      this.hours = '00';
      this.minutes = '00';
      return;
    }

    const m = Math.floor(distance / (1000 * 60 * 60 * 24 * 30));
    const d = Math.floor((distance % (1000 * 60 * 60 * 24 * 30)) / (1000 * 60 * 60 * 24));
    const h = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const min = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));

    this.months = m.toString().padStart(2, '0');
    this.days = d.toString().padStart(2, '0');
    this.hours = h.toString().padStart(2, '0');
    this.minutes = min.toString().padStart(2, '0');
  }
}
