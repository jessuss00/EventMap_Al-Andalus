import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { EventoService } from '../../services/evento.service';
import { Evento } from '../../models/evento.model';

import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-event-detail',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './event-detail.component.html',
  styleUrl: './event-detail.component.css'
})
export class EventDetailComponent implements OnInit {
  evento: Evento | null = null;
  loading: boolean = true;
  error: string | null = null;
  mapUrl: SafeResourceUrl | null = null;
  isAdmin: boolean = false;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private eventoService: EventoService,
    private sanitizer: DomSanitizer,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    this.isAdmin = this.authService.isAdmin();
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loadEvento(+id);
    } else {
      this.error = 'No se ha proporcionado un ID de evento válido.';
      this.loading = false;
    }
  }

  deleteEvento(): void {
    if (this.evento && confirm('¿Estás seguro de que quieres eliminar este evento?')) {
      this.eventoService.deleteEvento(this.evento.id).subscribe({
        next: () => {
          this.router.navigate(['/home']);
        },
        error: (err) => {
          console.error('Error al eliminar el evento:', err);
          alert('Hubo un error al eliminar el evento.');
        }
      });
    }
  }

  loadEvento(id: number): void {
    this.eventoService.getEventoById(id).subscribe({
      next: (data) => {
        this.evento = data;
        if (this.evento && this.evento.detalle && this.evento.detalle.localizacionExacta) {
          // Si la dirección ya es bastante larga, la usamos directamente para evitar redundancias
          // que confunden a Google Maps.
          let address = this.evento.detalle.localizacionExacta;
          
          if (this.evento.municipio) {
            const municipio = this.evento.municipio.nombre;
            const provincia = this.evento.municipio.provincia;
            
            if (!address.toLowerCase().includes(municipio.toLowerCase())) {
              address += `, ${municipio}`;
            }
            if (!address.toLowerCase().includes(provincia.toLowerCase())) {
              address += `, ${provincia}`;
            }
          }
          
          // Añadir siempre el país para evitar que Google Maps se confunda con lugares de otros países
          if (!address.toLowerCase().includes('españa') && !address.toLowerCase().includes('spain')) {
            address += ', España';
          }

          const encodedAddress = encodeURIComponent(address);
          
          // Formato más directo y con idioma español forzado
          this.mapUrl = this.sanitizer.bypassSecurityTrustResourceUrl(
            `https://maps.google.com/maps?hl=es&q=${encodedAddress}&t=&z=15&ie=UTF8&iwloc=B&output=embed`
          );
        }
        this.loading = false;
      },
      error: (err) => {
        console.error('Error al cargar el evento:', err);
        this.error = 'Hubo un problema al cargar los detalles del evento.';
        this.loading = false;
      }
    });
  }

  goBack(): void {
    this.router.navigate(['/home']);
  }

  getExternalLink(url: string | undefined): string {
    if (!url) return '#';
    // Si la URL no empieza por http:// o https://, le añadimos https:// por defecto
    if (!/^https?:\/\//i.test(url)) {
      return 'https://' + url;
    }
    return url;
  }
}
