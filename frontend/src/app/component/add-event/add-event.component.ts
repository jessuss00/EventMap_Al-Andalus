import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink, ActivatedRoute } from '@angular/router';
import { EventoService } from '../../services/evento.service';
import { MunicipioService } from '../../services/municipio.service';
import { Municipio } from '../../models/municipio.model';
import { Evento } from '../../models/evento.model';

@Component({
  selector: 'app-add-event',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: './add-event.component.html',
  styleUrl: './add-event.component.css'
})
export class AddEventComponent implements OnInit {
  eventForm!: FormGroup;
  municipios: Municipio[] = [];
  loading: boolean = false;
  error: string | null = null;

  isEditMode: boolean = false;
  eventId: number | null = null;

  tipos = ['Cultural', 'Nocturno', 'Deportivo'];

  constructor(
    private fb: FormBuilder,
    private eventoService: EventoService,
    private municipioService: MunicipioService,
    private router: Router,
    private route: ActivatedRoute
  ) { }

  ngOnInit(): void {
    this.initForm();
    this.loadMunicipios();

    this.route.paramMap.subscribe(params => {
      const id = params.get('id');
      if (id) {
        this.isEditMode = true;
        this.eventId = +id;
        this.loadEventData(this.eventId);
      }
    });
  }

  initForm(): void {
    this.eventForm = this.fb.group({
      // Info Básica
      nombre: ['', Validators.required],
      tipo: ['Cultural', Validators.required],
      descripcionSimple: ['', Validators.required],
      imagen: ['', Validators.required],
      confirmada: [true],
      municipioId: ['', Validators.required],

      // Info Detallada
      fechaInicio: [''],
      fechaFin: [''],
      subtipo: [''],
      descripcionDetallada: [''],
      localizacionExacta: [''],
      entradas: ['']
    });
  }

  loadMunicipios(): void {
    this.municipioService.getMunicipios().subscribe({
      next: (data) => this.municipios = data,
      error: (err) => console.error('Error cargando municipios:', err)
    });
  }

  loadEventData(id: number): void {
    this.loading = true;
    this.eventoService.getEventoById(id).subscribe({
      next: (evento) => {
        let fechaInicioStr = '';
        let fechaFinStr = '';
        if (evento.detalle?.fechaInicio) {
          fechaInicioStr = new Date(evento.detalle.fechaInicio).toISOString().slice(0, 16);
        }
        if (evento.detalle?.fechaFin) {
          fechaFinStr = new Date(evento.detalle.fechaFin).toISOString().slice(0, 16);
        }

        this.eventForm.patchValue({
          nombre: evento.nombre,
          tipo: evento.tipo,
          descripcionSimple: evento.descripcionSimple,
          imagen: evento.imagen,
          confirmada: evento.confirmada,
          municipioId: evento.municipio?.id,
          fechaInicio: fechaInicioStr,
          fechaFin: fechaFinStr,
          subtipo: evento.detalle?.subtipo,
          descripcionDetallada: evento.detalle?.descripcionDetallada,
          localizacionExacta: evento.detalle?.localizacionExacta,
          entradas: evento.detalle?.entradas
        });
        this.loading = false;
      },
      error: (err) => {
        this.error = 'No se pudo cargar el evento para editar.';
        this.loading = false;
      }
    });
  }

  onSubmit(): void {
    if (this.eventForm.invalid) {
      this.eventForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.error = null;

    const formValue = this.eventForm.value;

    const mId = Number(formValue.municipioId);

    const newEvento: Evento = {
      id: this.eventId || 0,
      nombre: formValue.nombre,
      tipo: formValue.tipo,
      descripcionSimple: formValue.descripcionSimple,
      imagen: formValue.imagen,
      confirmada: formValue.confirmada,
      municipio: { id: mId, nombre: '', provincia: '' },
      detalle: {
        id: 0,
        fechaInicio: formValue.fechaInicio || undefined,
        fechaFin: formValue.fechaFin || undefined,
        subtipo: formValue.subtipo,
        descripcionDetallada: formValue.descripcionDetallada,
        localizacionExacta: formValue.localizacionExacta,
        entradas: formValue.entradas
      }
    };

    if (this.isEditMode && this.eventId) {
      this.eventoService.updateEvento(this.eventId, newEvento).subscribe({
        next: () => {
          this.loading = false;
          this.router.navigate(['/event', this.eventId]);
        },
        error: (err) => {
          this.loading = false;
          this.error = 'Hubo un error al actualizar el evento. Inténtalo de nuevo.';
          console.error(err);
        }
      });
    } else {
      this.eventoService.createEvento(newEvento).subscribe({
        next: () => {
          this.loading = false;
          this.router.navigate(['/home']);
        },
        error: (err) => {
          this.loading = false;
          this.error = 'Hubo un error al crear el evento. Inténtalo de nuevo.';
          console.error(err);
        }
      });
    }
  }
}
