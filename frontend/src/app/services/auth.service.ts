import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject, tap } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = environment.apiUrl + '/auth';
  private loggedIn = new BehaviorSubject<boolean>(this.checkToken());

  constructor(private http: HttpClient) { }

  private checkToken(): boolean {
    if (typeof window !== 'undefined' && window.localStorage) {
      return !!localStorage.getItem('token');
    }
    return false;
  }

  get isLoggedIn$() {
    return this.loggedIn.asObservable();
  }

  isLoggedIn(): boolean {
    return this.loggedIn.value;
  }

  login(credentials: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/login`, credentials).pipe(
      tap(() => this.loggedIn.next(true))
    );
  }

  register(userData: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/register`, userData);
  }

  logout(): void {
    if (typeof window !== 'undefined' && window.localStorage) {
      localStorage.removeItem('token');
      localStorage.removeItem('isLoggedIn');
      this.loggedIn.next(false);
    }
  }

  isAdmin(): boolean {
    if (typeof window !== 'undefined' && window.localStorage) {
      const token = localStorage.getItem('token');
      if (token) {
        try {
          const payloadBase64 = token.split('.')[1];
          const decodedJson = atob(payloadBase64);
          const payload = JSON.parse(decodedJson);
          return payload.roles && payload.roles.includes('ROLE_ADMIN');
        } catch (e) {
          return false;
        }
      }
    }
    return false;
  }

  getCurrentUserId(): number | null {
    if (typeof window !== 'undefined' && window.localStorage) {
      const token = localStorage.getItem('token');
      if (token) {
        try {
          const payloadBase64 = token.split('.')[1];
          const decodedJson = atob(payloadBase64);
          const payload = JSON.parse(decodedJson);
          return payload.id ?? null;
        } catch (e) {
          return null;
        }
      }
    }
    return null;
  }
}
