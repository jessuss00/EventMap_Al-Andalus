import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Municipio } from '../models/municipio.model';

@Injectable({
  providedIn: 'root'
})
export class MunicipioService {
  private apiUrl = environment.apiUrl + '/api/municipios';

  constructor(private http: HttpClient) { }

  getMunicipios(): Observable<Municipio[]> {
    return this.http.get<Municipio[]>(this.apiUrl);
  }
}
