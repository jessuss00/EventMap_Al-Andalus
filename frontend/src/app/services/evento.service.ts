import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { Evento } from '../models/evento.model';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class EventoService {

  private apiUrl = `${environment.apiUrl}/api/eventos`;

  private searchSubject = new BehaviorSubject<string>('');
  searchQuery$ = this.searchSubject.asObservable();

  setSearchQuery(query: string): void {
    this.searchSubject.next(query);
  }

  constructor(private http: HttpClient) { }

  getEventos(): Observable<Evento[]> {
    return this.http.get<Evento[]>(this.apiUrl);
  }

  getEventoById(id: number): Observable<Evento> {
    return this.http.get<Evento>(`${this.apiUrl}/${id}`);
  }

  createEvento(evento: Evento): Observable<Evento> {
    return this.http.post<Evento>(this.apiUrl, evento);
  }

  updateEvento(id: number, evento: Evento): Observable<Evento> {
    return this.http.put<Evento>(`${this.apiUrl}/${id}`, evento);
  }

  deleteEvento(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }

  private favoritosUrl = `${environment.apiUrl}/api/favoritos`;

  toggleFavorito(eventoId: number): Observable<void> {
    return this.http.post<void>(`${this.favoritosUrl}/${eventoId}`, {});
  }

  getFavoritos(): Observable<Evento[]> {
    return this.http.get<Evento[]>(this.favoritosUrl);
  }

  isFavorito(eventoId: number): Observable<boolean> {
    return this.http.get<boolean>(`${this.favoritosUrl}/check/${eventoId}`);
  }
}

