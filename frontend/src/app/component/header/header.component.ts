import { Component, inject, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { EventoService } from '../../services/evento.service';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  authService = inject(AuthService);
  eventoService = inject(EventoService);
  router = inject(Router);

  isDropdownOpen = false;
  isMobileMenuOpen = false;
  isLoggedIn$ = this.authService.isLoggedIn$;
  searchText = '';
  isSearchExpanded = false;

  toggleSearch(): void {
    this.isSearchExpanded = !this.isSearchExpanded;
    if (this.isSearchExpanded) {
      // Pequeño delay para asegurar que el input sea visible antes de darle foco
      setTimeout(() => {
        const input = document.querySelector('.search-input') as HTMLInputElement;
        if (input) input.focus();
      }, 100);
    }
  }

  clearSearch(): void {
    this.searchText = '';
    this.onSearchChange();
    this.isSearchExpanded = false;
  }

  onSearchChange(): void {
    this.eventoService.setSearchQuery(this.searchText);
    
    // Si no estamos en el home, redirigir allí para ver resultados
    if (this.router.url !== '/home') {
      this.router.navigate(['/home']);
    }
  }

  isLandingPage(): boolean {
    return this.router.url === '/' || this.router.url === '';
  }

  getHomeRoute(): string {
    return this.authService.isLoggedIn() ? '/home' : '/';
  }

  toggleDropdown(): void {
    this.isDropdownOpen = !this.isDropdownOpen;
  }

  toggleMobileMenu(): void {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
    if (this.isMobileMenuOpen) this.isDropdownOpen = false;
  }

  logout(): void {
    this.authService.logout();
    this.isDropdownOpen = false;
    this.isMobileMenuOpen = false;
    this.router.navigate(['/']);
  }

  editProfile(): void {
    this.isDropdownOpen = false;
    this.isMobileMenuOpen = false;
    this.router.navigate(['/profile']);
  }

  @HostListener('document:click', ['$event'])
  onDocumentClick(event: MouseEvent): void {
    const target = event.target as HTMLElement;
    if (!target.closest('.user-menu-container')) {
      this.isDropdownOpen = false;
    }
    if (!target.closest('.header-right')) {
      this.isMobileMenuOpen = false;
    }
  }
}
