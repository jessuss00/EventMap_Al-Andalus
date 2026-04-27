import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  credentials = { email: '', password: '' };
  errorMessage = '';
  authService = inject(AuthService);
  router = inject(Router);

  login() {
    this.errorMessage = '';
    this.authService.login(this.credentials).subscribe({
      next: (res) => {
        console.log('Login success:', res);
        if (res && res.token) {
          localStorage.setItem('token', res.token);
        } else if (typeof res === 'string') {
          // Si el token viene como un texto plano
          localStorage.setItem('token', res);
        }
        // Marcar manualmente la sesión (opcional si es simulado)
        localStorage.setItem('isLoggedIn', 'true');
        this.router.navigate(['/home']);
      },
      error: (err) => {
        console.error('Login failed:', err);
        this.errorMessage = 'Credenciales incorrectas. Por favor, inténtalo de nuevo.';
      }
    });
  }
}
