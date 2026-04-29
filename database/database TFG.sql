drop database if exists TFG;
create database TFG;
use TFG;

-- ==========================================
-- ESTRUCTURA DE TABLAS
-- ==========================================

create table municipio(
    id int auto_increment primary key,
    nombre varchar(100),
    provincia varchar(100) not null
);

create table usuario(
    id int auto_increment primary key,
    nombre varchar(100),
    apellidos varchar(100),
    email varchar(100),
    contraseña varchar(255) not null,
    dni char(9),
    edad int,
    admin boolean default false,
    constraint chk_edad check (edad BETWEEN 17 AND 60)
);

create table evento(
    id int auto_increment primary key,
    nombre varchar(100),
    tipo varchar(20) not null,
    descripcion_simple text,
    confirmada boolean,
    municipio_id int, 
    imagen text,
    constraint chk_tipo_evento check (tipo IN ('Cultural', 'Nocturno', 'Deportivo')),
    constraint fk_evento_municipio foreign key(municipio_id) references municipio(id)
);

create table detalle_evento(
    id int auto_increment primary key,
    evento_id int not null,
    fecha_inicio datetime,
    fecha_fin datetime,
    subtipo varchar(100),
    descripcion_detallada text,
    localizacion_exacta varchar(200),
    entradas varchar(255),
    constraint fk_detalle_evento foreign key(evento_id) references evento(id)
);

-- ==========================================
-- INSERCIONES DE DATOS
-- ==========================================

-- Solo las 8 capitales de Andalucía (IDs del 1 al 8)
INSERT INTO municipio (nombre, provincia) VALUES 
('Almería', 'Almería'),   
('Cádiz', 'Cádiz'),       
('Córdoba', 'Córdoba'),   
('Granada', 'Granada'),   
('Huelva', 'Huelva'),     
('Jaén', 'Jaén'),         
('Málaga', 'Málaga'),     
('Sevilla', 'Sevilla');   

INSERT INTO usuario (nombre, apellidos, email, contraseña, dni, edad, admin) 
VALUES ('jesus', 'madro','jesusmadro17@gmail.com','$2a$10$ZbHUeGgB2hgd3bOD.f8DXuH2uVq7iTfhrvpFFPXL8VFx70lyz.1ta','48122271s',20, true),
		('Javier', 'canijo','frujim@gmail.com','$2a$10$Xy2d8ioIDVy/tXnfwW1X8eteUY8t5jJNTxFZnSieKdZGlBYpWkeOS','1234567A',19,false);

-- Eventos reasignados a los IDs 1-8
INSERT INTO evento (nombre, tipo, descripcion_simple, confirmada, municipio_id, imagen) VALUES 
('Concierto Flamenco Mágico', 'Nocturno', 'Disfruta de una noche inolvidable.', true, 4, 'https://picsum.photos/400/300?random=1'), -- Granada
('Festival Flamenco Almería', 'Cultural', 'Cante hondo frente al mar.', true, 1, 'https://picsum.photos/400/300?random=2'), -- Almería
('Carnaval de Cádiz', 'Cultural', 'Coplas y chirigotas en la calle.', true, 2, 'https://picsum.photos/400/300?random=3'), -- Cádiz
('Antique The Teatro', 'Nocturno', 'La fiesta más exclusiva.', true, 8, 'https://picsum.photos/400/300?random=4'), -- Sevilla
('Sierra Nevada Ski Trail', 'Deportivo', 'Carrera de montaña sobre nieve.', true, 4, 'https://picsum.photos/400/300?random=5'), -- Granada
('Noche Blanca del Flamenco', 'Nocturno', 'Toda la ciudad cantando.', true, 3, 'https://picsum.photos/400/300?random=6'), -- Córdoba
('Visita Guiada Alhambra', 'Cultural', 'Recorrido por palacios nazaríes.', true, 4, 'https://picsum.photos/400/300?random=7'), -- Granada
('Voley Playa Almería', 'Deportivo', 'Torneo amateur de verano.', true, 1, 'https://picsum.photos/400/300?random=8'), -- Almería
('Feria de Abril', 'Nocturno', 'Vive la magia de la feria.', true, 8, 'https://picsum.photos/400/300?random=9'), -- Sevilla
('Carreras de Caballos', 'Deportivo', 'Carreras en la arena.', true, 2, 'https://picsum.photos/400/300?random=10'), -- Cádiz (Sanlúcar remapeado a Cádiz cap)
('Ruta de Tapas y Vino', 'Cultural', 'Ruta por las tabernas.', true, 3, 'https://picsum.photos/400/300?random=11'), -- Córdoba
('Maratón Ciudad de Sevilla', 'Deportivo', 'Participa en la carrera legendaria.', true, 8, 'https://picsum.photos/400/300?random=12'), -- Sevilla
('Teatre - Show & Club', 'Nocturno', 'Espectáculo en vivo.', true, 4, 'https://picsum.photos/400/300?random=13'), -- Granada
('Feria del Caballo', 'Cultural', 'Doma, vino y tradición.', true, 2, 'https://picsum.photos/400/300?random=14'), -- Cádiz (Jerez remapeado a Cádiz cap)
('Saca de las Yeguas', 'Cultural', 'Tradición ganadera.', true, 5, 'https://picsum.photos/400/300?random=15'), -- Huelva
('Starlite Occident', 'Nocturno', 'El festival de las estrellas.', true, 7, 'https://picsum.photos/400/300?random=16'), -- Málaga
('Clásica Ciclista Almería', 'Deportivo', 'Carrera profesional UCI.', true, 1, 'https://picsum.photos/400/300?random=17'), -- Almería
('Bienal de Flamenco', 'Cultural', 'El evento más importante.', true, 8, 'https://picsum.photos/400/300?random=18'), -- Sevilla
('Beach Club Party Málaga', 'Nocturno', 'Sesión de DJ en club de lujo.', true, 7, 'https://picsum.photos/400/300?random=19'), -- Málaga
('Maratón de Málaga', 'Deportivo', '42km con vistas al Mediterráneo.', true, 7, 'https://picsum.photos/400/300?random=20'); -- Málaga

-- Detalles de eventos (IDs del 1 al 20 automáticos)
INSERT INTO detalle_evento (evento_id, fecha_inicio, fecha_fin, subtipo, descripcion_detallada, localizacion_exacta, entradas) VALUES 
(1, '2026-06-15 21:00:00', '2026-06-15 23:30:00', 'Flamenco', 'Espectáculo íntimo.', 'Sacromonte, Granada', 'flamencogranada.com'),
(2, '2026-07-05 20:00:00', '2026-07-05 23:59:00', 'Flamenco', 'Cante hondo frente al mar.', 'Puerto de Almería', 'Taquilla puerto'),
(3, '2026-08-15 19:00:00', '2026-08-16 02:00:00', 'Carnaval', 'Coplas y chirigotas.', 'Plaza de las Flores, Cádiz', 'Gratis'),
(4, '2026-05-16 23:30:00', '2026-05-17 07:00:00', 'Discoteca', 'Experiencia VIP.', 'Isla de la Cartuja, Sevilla', 'antiquetheteatro.com'),
(5, '2026-03-12 09:00:00', '2026-03-12 14:00:00', 'Trail', 'Carrera sobre nieve.', 'Sierra Nevada, Granada', 'sierranevada.es'),
(6, '2026-06-20 22:00:00', '2026-06-21 06:00:00', 'Flamenco', 'Conciertos en plazas.', 'Plaza de las Tendillas, Córdoba', 'Gratis'),
(7, '2026-07-10 09:00:00', '2026-07-10 13:00:00', 'Patrimonio', 'Guía especializado.', 'Alhambra, Granada', 'alhambra-tickets.es'),
(8, '2026-07-20 10:00:00', '2026-07-20 20:00:00', 'Voley', 'Torneo de verano.', 'Playa de Almería', 'Inscripción abierta'),
(9, '2026-04-18 12:00:00', '2026-04-25 06:00:00', 'Feria', 'Casetas y rebujito.', 'Recinto Ferial, Sevilla', 'Libre'),
(10, '2026-08-10 17:00:00', '2026-08-12 20:00:00', 'Hípica', 'Carreras en la playa.', 'Cádiz Costa', 'Gratis'),
(11, '2026-05-05 13:00:00', '2026-05-05 17:00:00', 'Tapas', 'Vino y gastronomía.', 'Judería, Córdoba', '25 euros'),
(12, '2026-02-22 08:30:00', '2026-02-22 14:30:00', 'Atletismo', 'Circuito histórico.', 'Sevilla Centro', 'zurichmaratonsevilla.es'),
(13, '2026-05-22 23:00:00', '2026-05-23 06:30:00', 'Show', 'Música comercial.', 'Calle Arabial, Granada', 'teatregranada.com'),
(14, '2026-05-10 13:00:00', '2026-05-17 04:00:00', 'Feria', 'Caballos y vino.', 'Recinto ferial, Cádiz', 'Libre'),
(15, '2026-06-26 08:00:00', '2026-06-26 15:00:00', 'Tradición', 'Ganado en marismas.', 'Huelva alrededores', 'Gratis'),
(16, '2026-07-01 22:00:00', '2026-08-31 03:00:00', 'Festival', 'Conciertos de élite.', 'Marbella, Málaga', 'starlitemarbella.com'),
(17, '2026-02-15 10:00:00', '2026-02-15 15:00:00', 'Ciclismo', 'Carrera UCI.', 'Centro Ciudad, Almería', 'ciclismoalmeria.es'),
(18, '2026-09-01 20:00:00', '2026-09-30 23:00:00', 'Flamenco', 'Máximo exponente.', 'Teatro Maestranza, Sevilla', 'labienal.com'),
(19, '2026-07-20 23:00:00', '2026-07-21 07:00:00', 'Party', 'DJ Internacional.', 'Puerto Banús, Málaga', 'Reserva VIP'),
(20, '2026-12-15 09:00:00', '2026-12-15 15:00:00', 'Running', 'Vistas al mar.', 'Paseo del Parque, Málaga', 'malagamaraton.com');


-- PRUEBAS FINALES
select * from usuario;
select * from municipio;
