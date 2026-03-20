import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../services/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './register.component.html',
  styleUrl: './register.component.css'
})
export class RegisterComponent {
  userData = {
    nombre: '',
    apellidos: '',
    email: '',
    dni: '',
    edad: null,
    password1: '',
    password2: ''
  };
  errorMessage = '';
  authService = inject(AuthService);
  router = inject(Router);

  register() {
    this.errorMessage = '';

    if (this.userData.password1 !== this.userData.password2) {
      this.errorMessage = 'Las contraseñas no coinciden.';
      return;
    }

    this.authService.register(this.userData).subscribe({
      next: (res) => {
        console.log('Registration success:', res);
        this.router.navigate(['/login']);
      },
      error: (err) => {
        console.error('Registration failed:', err);
        if (err.error && typeof err.error === 'string') {
          this.errorMessage = err.error;
        } else if (err.error && err.error.message) {
          this.errorMessage = err.error.message;
        } else if (err.status === 500) {
          this.errorMessage = 'El servidor rechazó el registro. Es probable que el email ya esté en uso.';
        } else {
          this.errorMessage = 'No se ha podido registrar el usuario. Comprueba si el email ya existe en el sistema o si los datos son inválidos.';
        }
      }
    });
  }
}
