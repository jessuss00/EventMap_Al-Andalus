export interface Comentario {
  id: number;

  usuario: {
    id: number;
    nombre: string;
    apellidos: string;
    email: string;
  };
  evento: {
    id: number;
    nombre: string;
  };
  texto: string;
  calificacion: number;
}

export interface ComentarioRequest {
  eventoId: number;
  texto: string;
  calificacion: number;
}
