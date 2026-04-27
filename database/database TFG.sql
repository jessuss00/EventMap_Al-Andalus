drop database if exists TFG;
create database TFG;
use TFG;

-- MUNICIPIOS
create table municipio(
	id int auto_increment primary key,
    nombre varchar(100),
    provincia varchar(100) not null
);

-- USUARIOS
create table usuario(
	id int auto_increment primary key,
	nombre varchar(100),
    apellidos varchar(100),
    email varchar(100),
    contraseña varchar(255) not null,
    dni char(9),
    edad int,
	constraint chk_edad check (edad BETWEEN 17 AND 30)
);

-- EVENTOS
create table evento(
	id int auto_increment primary key,
    nombre varchar(100),
    tipo varchar(20) not null,
    descripcion_simple text,
    confirmada boolean,
    municipio int, 
    imagen varchar(255),
    constraint chk_tipo_evento check (tipo IN ('Cultural', 'Nocturno', 'Deportivo')),
    constraint fk_evento_municipio foreign key(municipio) references municipio(id)
);
    

-- DETALLES SEGÚN EL TIPO DE EVENTO
create table detalle_evento(
	id int auto_increment primary key,
    evento int not null,
    fecha_inicio datetime,
    fecha_fin datetime,
    subtipo varchar(100), -- Ejemplo: fútbol, teatro, flamenco, tapas, feria...
    descripcion_detallada text,
    localizacion_exacta varchar(200),
    entradas varchar(255),
    constraint fk_detalle_evento foreign key(evento) references evento(id)
);

-- VISITAS DE USUARIOS A EVENTOS
create table visita(
	usuario int,
    evento int,
    comentarios text,
    constraint pk_visita primary key(usuario, evento),
    constraint fk_visita_evento foreign key(evento) references evento(id),
    constraint fk_visita_usuario foreign key(usuario) references usuario(id)
);



INSERT INTO municipio (nombre, provincia) VALUES 
('Granada', 'Granada'), 
('Córdoba', 'Córdoba'), 
('Sevilla', 'Sevilla');

INSERT INTO evento (nombre, tipo, descripcion_simple, confirmada, municipio, imagen) VALUES 
('Concierto Flamenco Mágico', 'Nocturno', 'Disfruta de una noche inolvidable con el mejor flamenco en el corazón de Andalucía.', true, 1, 'https://conciertos.club/doc/a/2017/a_FMC_Vimaambi.jpg'),
('Visita Guiada Alhambra', 'Cultural', 'Recorrido completo por la Alhambra, Generalife y palacios nazaríes.', true, 1, 'https://cdn-imgix.headout.com/media/images/b976375b5f1a1d87578c9d9fe12e2c7e-Alhambra%20Tickets.jpg'),
('Feria de Abril', 'Nocturno', 'Vive la magia de la feria con casetas, rebujito y baile hasta el amanecer.', true, 3, 'https://elflamencoensevilla.com/wp-content/uploads/2023/04/feria-de-sevilla.jpeg'),
('Ruta de Tapas y Vino', 'Cultural', 'Una ruta exquisita por las mejores tabernas tradicionales de Córdoba.', true, 2, 'https://images.unsplash.com/photo-1544148103-0773bf10d330?auto=format&fit=crop&q=80&w=600'),
('Maratón Ciudad de Sevilla', 'Deportivo', 'Participa en la carrera legendaria a través de los monumentos históricos.', true, 3, 'https://images.unsplash.com/photo-1552674605-15cff24f362f?auto=format&fit=crop&q=80&w=600');

INSERT INTO detalle_evento (evento, fecha_inicio, fecha_fin, subtipo, descripcion_detallada, localizacion_exacta, entradas) VALUES
(1, '2026-05-15 21:00:00', '2026-05-15 23:30:00', 'Flamenco', 'Una experiencia inmersiva con cantaores de renombre y un ambiente único.', 'Cuevas del Sacromonte', 'Desde 30€ en taquilla'),
(2, '2026-06-10 10:00:00', '2026-06-10 14:00:00', 'Visita histórica', 'Un guía oficial te acompañará por los misterios de la fortaleza roja.', 'Acceso Principal Alhambra', '25€ online'),
(3, '2026-04-20 12:00:00', '2026-04-26 23:59:00', 'Feria', 'Semanas de diversión garantizada, música, comida típica y atracciones.', 'Recinto Ferial Los Remedios', 'Entrada gratuita al recinto'),
(4, '2026-05-02 13:00:00', '2026-05-02 18:00:00', 'Tapas', 'Degustación de 5 tapas premium con maridaje de vinos locales.', 'Centro histórico de Córdoba', '15€ ticket de ruta'),
(5, '2026-02-15 08:00:00', '2026-02-15 14:30:00', 'Atletismo', 'Disfruta de 42 km recorriendo las calles más bellas y llanas de Europa.', 'Paseo de las Delicias, Sevilla', 'Participación 75€, público gratis');

select * from usuario;
