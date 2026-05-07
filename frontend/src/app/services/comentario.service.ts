import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Comentario, ComentarioRequest } from '../models/comentario.model';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ComentarioService {

  private apiUrl = `${environment.apiUrl}/comentarios`;

  constructor(private http: HttpClient) { }

  getByEvento(eventoId: number): Observable<Comentario[]> {
    return this.http.get<Comentario[]>(`${this.apiUrl}/evento/${eventoId}`);
  }

  create(payload: ComentarioRequest): Observable<Comentario> {
    return this.http.post<Comentario>(this.apiUrl, payload);
  }

  delete(comentarioUsuarioId: number, eventoId: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${comentarioUsuarioId}/${eventoId}`);
  }
}
