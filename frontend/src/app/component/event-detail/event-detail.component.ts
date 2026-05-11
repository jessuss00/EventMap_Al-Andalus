import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { EventoService } from '../../services/evento.service';
import { ComentarioService } from '../../services/comentario.service';
import { Evento } from '../../models/evento.model';
import { Comentario } from '../../models/comentario.model';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-event-detail',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './event-detail.component.html',
  styleUrl: './event-detail.component.css'
})
export class EventDetailComponent implements OnInit {
  evento: Evento | null = null;
  loading: boolean = true;
  error: string | null = null;
  mapUrl: SafeResourceUrl | null = null;
  isAdmin: boolean = false;
  isLoggedIn: boolean = false;
  currentUserId: number | null = null;
  isFavorito: boolean = false;

  comentarios: Comentario[] = [];
  loadingComentarios: boolean = false;
  nuevoTexto: string = '';
  nuevaCalificacion: number = 0;
  hoverCalificacion: number = 0;
  errorComentario: string | null = null;
  enviandoComentario: boolean = false;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private eventoService: EventoService,
    private comentarioService: ComentarioService,
    private sanitizer: DomSanitizer,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    this.isAdmin = this.authService.isAdmin();
    this.isLoggedIn = this.authService.isLoggedIn();
    this.currentUserId = this.authService.getCurrentUserId();
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loadEvento(+id);
      this.loadComentarios(+id);
      if (this.isLoggedIn) {
        this.checkFavorito(+id);
      }
    } else {
      this.error = 'No se ha proporcionado un ID de evento válido.';
      this.loading = false;
    }
  }

  checkFavorito(id: number): void {
    this.eventoService.isFavorito(id).subscribe({
      next: (val) => this.isFavorito = val,
      error: (err) => console.error('Error checking favorite:', err)
    });
  }

  toggleFavorito(): void {
    if (!this.evento || !this.isLoggedIn) return;
    this.eventoService.toggleFavorito(this.evento.id).subscribe({
      next: () => this.isFavorito = !this.isFavorito,
      error: (err) => console.error('Error toggling favorite:', err)
    });
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

          if (!address.toLowerCase().includes('españa') && !address.toLowerCase().includes('spain')) {
            address += ', España';
          }

          const encodedAddress = encodeURIComponent(address);
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

  loadComentarios(eventoId: number): void {
    this.loadingComentarios = true;
    this.comentarioService.getByEvento(eventoId).subscribe({
      next: (data) => {
        this.comentarios = data;
        this.loadingComentarios = false;
      },
      error: () => {
        this.loadingComentarios = false;
      }
    });
  }

  submitComentario(): void {
    if (!this.evento) return;
    if (this.nuevoTexto.trim().length === 0) {
      this.errorComentario = 'El comentario no puede estar vacío.';
      return;
    }
    if (this.nuevaCalificacion === 0) {
      this.errorComentario = 'Por favor, selecciona una calificación.';
      return;
    }
    this.errorComentario = null;
    this.enviandoComentario = true;

    this.comentarioService.create({
      eventoId: this.evento.id,
      texto: this.nuevoTexto.trim(),
      calificacion: this.nuevaCalificacion
    }).subscribe({
      next: (c: Comentario) => {
        this.comentarios = [...this.comentarios, c];
        this.nuevoTexto = '';
        this.nuevaCalificacion = 0;
        this.hoverCalificacion = 0;
        this.enviandoComentario = false;
      },
      error: (err: any) => {
        this.errorComentario = err.error || 'Error al publicar el comentario.';
        this.enviandoComentario = false;
      }
    });
  }

  deleteComentario(comentario: Comentario): void {
    if (!confirm('¿Eliminar este comentario?')) return;
    this.comentarioService.delete(comentario.id).subscribe({
      next: () => {
        this.comentarios = this.comentarios.filter(c => c.id !== comentario.id);
      },
      error: (err: any) => {
        alert(err.error || 'Error al eliminar el comentario.');
      }
    });
  }

  canDeleteComentario(comentario: Comentario): boolean {
    if (this.isAdmin) return true;
    return this.isLoggedIn && this.currentUserId === comentario.usuario.id;
  }

  get hasUserCommented(): boolean {
    return false;
  }

  getAverageRating(): number {
    if (this.comentarios.length === 0) return 0;
    const sum = this.comentarios.reduce((acc, c) => acc + c.calificacion, 0);
    return Math.round((sum / this.comentarios.length) * 10) / 10;
  }

  getStars(rating: number): boolean[] {
    return [1, 2, 3, 4, 5].map(i => i <= Math.round(rating));
  }

  setCalificacion(value: number): void {
    this.nuevaCalificacion = value;
  }

  setHover(value: number): void {
    this.hoverCalificacion = value;
  }

  getActiveStars(index: number): boolean {
    const active = this.hoverCalificacion || this.nuevaCalificacion;
    return index <= active;
  }

  goBack(): void {
    this.router.navigate(['/home']);
  }

  getExternalLink(url: string | undefined): string {
    if (!url) return '#';
    if (!/^https?:\/\//i.test(url)) {
      return 'https://' + url;
    }
    return url;
  }
}
