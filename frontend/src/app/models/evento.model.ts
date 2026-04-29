export interface DetalleEvento {
    id: number;
    fechaInicio?: string;
    fechaFin?: string;
    subtipo: string;
    descripcionDetallada: string;
    localizacionExacta: string;
    entradas: string;
}

export interface Evento {
    id: number;
    nombre: string;
    tipo: 'Cultural' | 'Nocturno' | 'Deportivo';
    descripcionSimple: string;
    confirmada: boolean;
    imagen: string;
    municipio?: {
        id: number;
        nombre: string;
        provincia: string;
    };
    detalle?: DetalleEvento;
}
