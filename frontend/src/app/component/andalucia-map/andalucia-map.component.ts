import { Component, Input, Output, EventEmitter, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-andalucia-map',
  standalone: true,
  imports: [CommonModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './andalucia-map.component.html',
  styleUrl: './andalucia-map.component.css'
})
export class AndaluciaMapComponent {
  @Input() selectedProvincia: string = 'Todas';
  @Output() provinciaSelected = new EventEmitter<string>();

  onProvinceClick(provincia: string) {
    this.provinciaSelected.emit(provincia);
  }
}
