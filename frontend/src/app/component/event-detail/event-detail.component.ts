import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { EventoService } from '../../services/evento.service';
import { Evento } from '../../models/evento.model';

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

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private eventoService: EventoService,
    private sanitizer: DomSanitizer
  ) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loadEvento(+id);
    } else {
      this.error = 'No se ha proporcionado un ID de evento válido.';
      this.loading = false;
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
          
          if (address.length < 20 && this.evento.municipio) {
            address += `, ${this.evento.municipio.nombre}`;
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
