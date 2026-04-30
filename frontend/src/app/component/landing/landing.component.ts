import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { RouterLink, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../services/auth.service';

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

  targetDate: Date = new Date('2026-06-15T00:00:00'); // Fecha de ejemplo para la próxima feria
  months: string = '00';
  days: string = '00';
  hours: string = '00';
  minutes: string = '00';
  private timer: any;

  ngOnInit(): void {
    if (this.authService.isLoggedIn()) {
      this.router.navigate(['/home']);
    }
    this.startCountdown();
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
    }, 60000); // Actualizar cada minuto para ahorrar recursos, o cada segundo si prefieres ver el segundero
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

    // Cálculos para meses, días, horas y minutos
    // Nota: El cálculo de meses es aproximado (30 días)
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
