import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  authService = inject(AuthService);
  router = inject(Router);

  isDropdownOpen = false;
  isLoggedIn$ = this.authService.isLoggedIn$;

  getHomeRoute(): string {
    return this.authService.isLoggedIn() ? '/home' : '/login';
  }

  toggleDropdown(): void {
    this.isDropdownOpen = !this.isDropdownOpen;
  }

  logout(): void {
    this.authService.logout();
    this.isDropdownOpen = false;
    this.router.navigate(['/login']);
  }

  editProfile(): void {
    this.isDropdownOpen = false;
    this.router.navigate(['/profile']);
  }
}
