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
    detalle?: any;
}
