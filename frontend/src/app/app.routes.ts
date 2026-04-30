import { Routes } from '@angular/router';
import { LoginComponent } from './component/auth/login/login.component';
import { RegisterComponent } from './component/auth/register/register.component';
import { HomeComponent } from './component/home/home.component';
import { ProfileComponent } from './component/profile/profile.component';
import { EventDetailComponent } from './component/event-detail/event-detail.component';
import { AddEventComponent } from './component/add-event/add-event.component';
import { authGuard, guestGuard } from './guards/auth.guard';

import { LandingComponent } from './component/landing/landing.component';

export const routes: Routes = [
  { path: '', component: LandingComponent },
  { path: 'login', component: LoginComponent, canActivate: [guestGuard] },
  { path: 'register', component: RegisterComponent, canActivate: [guestGuard] },
  { path: 'home', component: HomeComponent, canActivate: [authGuard] },
  { path: 'event/new', component: AddEventComponent, canActivate: [authGuard] },
  { path: 'event/edit/:id', component: AddEventComponent, canActivate: [authGuard] },
  { path: 'event/:id', component: EventDetailComponent, canActivate: [authGuard] },
  { path: 'profile', component: ProfileComponent, canActivate: [authGuard] },
  { path: '**', redirectTo: '' }
];
