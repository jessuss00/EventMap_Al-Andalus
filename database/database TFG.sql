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
    constraint chk_edad check (edad BETWEEN 17 AND 60)
);

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

create table detalle_evento(
    id int auto_increment primary key,
    evento int not null,
    fecha_inicio datetime,
    fecha_fin datetime,
    subtipo varchar(100),
    descripcion_detallada text,
    localizacion_exacta varchar(200),
    entradas varchar(255),
    constraint fk_detalle_evento foreign key(evento) references evento(id)
);

-- ==========================================
-- INSERCIONES DE DATOS
-- ==========================================

INSERT INTO municipio (id, nombre, provincia) VALUES 
(1, 'Granada', 'Granada'), (2, 'Motril', 'Granada'),
(3, 'Almería', 'Almería'), (4, 'Roquetas de Mar', 'Almería'),
(5, 'Málaga', 'Málaga'), (6, 'Marbella', 'Málaga'),
(7, 'Córdoba', 'Córdoba'), (8, 'Lucena', 'Córdoba'),
(9, 'Sevilla', 'Sevilla'), (10, 'Dos Hermanas', 'Sevilla'),
(11, 'Huelva', 'Huelva'), (12, 'Almonte', 'Huelva'),
(13, 'Cádiz', 'Cádiz'), (14, 'Jerez de la Frontera', 'Cádiz'),
(15, 'Jaén', 'Jaén'), (16, 'Úbeda', 'Jaén');

INSERT INTO usuario (nombre, apellidos, email, contraseña, dni, edad) 
VALUES ('jesus', 'madro','jesusmadro17@gmail.com','$2a$10$ZbHUeGgB2hgd3bOD.f8DXuH2uVq7iTfhrvpFFPXL8VFx70lyz.1ta','48122271s',20);

-- INSERT DE TODOS LOS EVENTOS (MEZCLADOS)
INSERT INTO evento (id, nombre, tipo, descripcion_simple, confirmada, municipio, imagen) VALUES 
(1, 'Concierto Flamenco Mágico', 'Nocturno', 'Disfruta de una noche inolvidable con el mejor flamenco.', true, 1, 'https://conciertos.club/doc/a/2017/a_FMC_Vimaambi.jpg'),
(2, 'Festival Flamenco Almería', 'Cultural', 'Cante hondo frente al mar.', true, 3, 'https://picsum.photos/400/300?random=11'),
(3, 'Carnaval de Verano Cádiz', 'Cultural', 'Coplas y chirigotas en la calle.', true, 13, 'https://picsum.photos/400/300?random=17'),
(4, 'Antique The Teatro', 'Nocturno', 'La fiesta más exclusiva en el antiguo pabellón del 92.', true, 9, 'https://www.antiquetheteatro.com/wp-content/uploads/2023/05/antique-disco-sevilla.jpg'),
(5, 'Sierra Nevada Ski Trail', 'Deportivo', 'Carrera de montaña sobre nieve.', true, 1, 'https://picsum.photos/400/300?random=28'),
(6, 'Noche Blanca del Flamenco', 'Nocturno', 'Toda la ciudad cantando hasta el alba.', true, 7, 'https://picsum.photos/400/300?random=23'),
(7, 'Visita Guiada Alhambra', 'Cultural', 'Recorrido completo por los palacios nazaríes.', true, 1, 'https://cdn-imgix.headout.com/media/images/b976375b5f1a1d87578c9d9fe12e2c7e-Alhambra%20Tickets.jpg'),
(8, 'Voley Playa Aguadulce', 'Deportivo', 'Torneo amateur de verano.', true, 4, 'https://picsum.photos/400/300?random=12'),
(9, 'Feria de Abril', 'Nocturno', 'Vive la magia de la feria con casetas y rebujito.', true, 9, 'https://elflamencoensevilla.com/wp-content/uploads/2023/04/feria-de-sevilla.jpeg'),
(10, 'Carreras de Caballos Sanlúcar', 'Deportivo', 'Carreras en la arena de la playa.', true, 13, 'https://picsum.photos/400/300?random=18'),
(11, 'Ruta de Tapas y Vino', 'Cultural', 'Ruta exquisita por las tabernas de Córdoba.', true, 7, 'https://images.unsplash.com/photo-1544148103-0773bf10d330?auto=format&fit=crop&q=80&w=600'),
(12, 'Maratón Ciudad de Sevilla', 'Deportivo', 'Participa en la carrera legendaria.', true, 9, 'https://deporticket.blob.core.windows.net/awebs/zurich-maraton-de-sevilla-2023/2302-el-zurich-maraton-de-sevilla-vuelve-a-superarse-a-si-mismo-1.jpg'),
(13, 'Teatre - Show & Club', 'Nocturno', 'Espectáculo en vivo en un teatro rehabilitado.', true, 1, 'https://teatregranada.com/wp-content/uploads/2021/09/teatre-granada-sala.jpg'),
(14, 'Feria del Caballo Jerez', 'Cultural', 'Doma, vino y tradición.', true, 14, 'https://picsum.photos/400/300?random=19'),
(15, 'Saca de las Yeguas', 'Cultural', 'Tradición ganadera en Doñana.', true, 12, 'https://picsum.photos/400/300?random=31'),
(16, 'Starlite Occident', 'Nocturno', 'El festival de las estrellas en la cantera.', true, 6, 'https://picsum.photos/400/300?random=41'),
(17, 'Clásica Ciclista Almería', 'Deportivo', 'Carrera profesional UCI.', true, 3, 'https://picsum.photos/400/300?random=16'),
(18, 'Bienal de Flamenco', 'Cultural', 'El evento más importante del género.', true, 9, 'https://picsum.photos/400/300?random=47'),
(19, 'Beach Club Party Marbella', 'Nocturno', 'Sesión de DJ en club de lujo.', true, 6, 'https://picsum.photos/400/300?random=46'),
(20, 'Maratón de Málaga', 'Deportivo', '42km con vistas al Mediterráneo.', true, 5, 'https://picsum.photos/400/300?random=42'),
(21, 'Noche de las Velas', 'Nocturno', 'Iluminación mágica del pueblo.', true, 16, 'https://populo.es/wp-content/uploads/2025/08/Renacimiento-a-la-luz-de-las-velas-2025-en-baeza-1080x675.jpg'),
(22, 'Travesía a Nado Huelva', 'Deportivo', 'Cruce a nado por la ría.', true, 11, 'https://picsum.photos/400/300?random=32'),
(23, 'Semana Santa Granada', 'Cultural', 'Procesiones por el Albaicín.', true, 1, 'https://www.spain.info/export/sites/segtur/.content/imagenes/cabeceras-grandes/eventos-fiestas/andalucia/Semana-Santa-Granada.jpg'),
(24, 'Mae West Granada', 'Nocturno', 'Referente de la noche granadina.', true, 1, 'https://lh5.googleusercontent.com/p/AF1QipN3-y1G_vY_UvU_vU'),
(25, 'Carrera de San Antón', 'Deportivo', 'Carrera popular con antorchas.', true, 15, 'https://picsum.photos/400/300?random=37'),
(26, 'Enoturismo Condado Huelva', 'Cultural', 'Visita a bodegas centenarias.', true, 11, 'https://condavision.es/wp-content/uploads/2024/12/foto-2copa-vino-blanco-y-vinedos.-do-condado-de-huelva-scaled.jpg'),
(27, 'Sala Gold Málaga', 'Nocturno', 'Discoteca elegante en pleno centro.', true, 5, 'https://lh5.googleusercontent.com/p/AF1QipM_x1y2z3_4v5_6w'),
(28, 'Triatlón de Cádiz', 'Deportivo', 'Natación en la Caleta.', true, 13, 'https://static.grupojoly.com/clip/bca956e9-7036-4ac5-b919-41dcd6fe6111_source-aspect-ratio_1600w_0.jpg'),
(29, 'Festival Rock Dos Hermanas', 'Nocturno', 'Bandas locales e invitadas.', true, 10, 'https://picsum.photos/400/300?random=50'),
(30, 'Romería de Valme', 'Cultural', 'Fiesta de Interés Turístico Nacional.', true, 10, 'https://www.periodicoelnazareno.es/wp-content/uploads/2018/10/romeria-valme_017.jpg'),
(31, 'Skate Fest Dos Hermanas', 'Deportivo', 'Exhibiciones y campeonato libre.', true, 10, 'https://www.periodicoelnazareno.es/wp-content/uploads/2019/10/pista-pump-truck.jpg'),
(32, 'Olivia Valere Marbella', 'Nocturno', 'Exclusivo club de lujo.', true, 6, 'https://www.oliviavalere.com/wp-content/uploads/2021/05/olivia-valere-marbella.jpg'),
(33, 'Vía Verde del Aceite', 'Deportivo', 'Ruta ciclista por antiguos túneles.', true, 15, 'https://picsum.photos/400/300?random=40'),
(34, 'Zambomba Jerezana', 'Cultural', 'Villancicos flamencos tradicionales.', true, 14, 'https://picsum.photos/400/300?random=22'),
(35, 'Sala Moma Córdoba', 'Nocturno', 'Punto de encuentro universitario.', true, 7, 'https://estaticos-cdn.prensaiberica.es/clip/5c4f27e5-8f6a-4b9e-9d2a-1c7b8c9d0e1f_16-9-aspect-ratio_default_0.jpg'),
(36, 'Trail Nocturno Almería', 'Deportivo', 'Carrera por el Cabo de Gata.', true, 3, 'https://www.trailrun.es/uploads/s1/11/14/80/11/trail-dels-fars-nocturna-corganizacion.jpeg'),
(37, 'Festival Iberoamericano Cine', 'Cultural', 'Estrenos y alfombra roja en Huelva.', true, 11, 'https://picsum.photos/400/300?random=33'),
(38, 'Occo Art Club', 'Nocturno', 'Mezcla de arte y electrónica en Cádiz.', true, 13, 'https://occoartclub.com/wp-content/uploads/2022/01/occo-cadiz-interior.jpg'),
(39, 'Campeonato Remo Guadalquivir', 'Deportivo', 'Regata histórica de ocho con timonel.', true, 9, 'https://picsum.photos/400/300?random=49'),
(40, 'Concierto Órgano Jaén', 'Cultural', 'Música sacra en templo renacentista.', true, 15, 'https://picsum.photos/400/300?random=55'),
(41, 'Nocturama Sevilla', 'Nocturno', 'Conciertos de música independiente.', true, 9, 'https://picsum.photos/400/300?random=48'),
(42, 'Open Tenis Marbella', 'Deportivo', 'Torneo internacional en tierra batida.', true, 6, 'https://picsum.photos/400/300?random=44'),
(43, 'Ruta del Cine Tabernas', 'Cultural', 'Visita a escenarios de Western.', true, 3, 'https://picsum.photos/400/300?random=14'),
(44, 'Mandalay Beach Club', 'Nocturno', 'Fiesta frente al mar en Roquetas.', true, 4, 'https://mandalaybeachclub.com/wp-content/uploads/2023/04/mandalay-roquetas.jpg'),
(45, 'Media Maratón Lucena', 'Deportivo', 'Carrera urbana por centro histórico.', true, 8, 'https://picsum.photos/400/300?random=25'),
(46, 'Festival Jazz Costa', 'Cultural', 'Música en el Parque del Majuelo.', true, 2, 'https://picsum.photos/400/300?random=27'),
(47, 'KOKO Sevilla', 'Nocturno', 'Club moderno en la Encarnación.', true, 9, 'https://lh5.googleusercontent.com/p/AF1QipO_a7b8c9d0e1f2g'),
(48, 'Gran Premio Motociclismo', 'Deportivo', 'Mundial de MotoGP en Jerez.', true, 14, 'https://picsum.photos/400/300?random=21'),
(49, 'Mercado Romano Lucena', 'Cultural', 'Artesanía y luchas de gladiadores.', true, 8, 'https://picsum.photos/400/300?random=26'),
(50, 'Blues en el Puerto', 'Nocturno', 'Festival de blues de Motril.', true, 2, 'https://www.lacomarcadepuertollano.com/asset/zoomcrop,480,270,center,center/media/lacomarcadepuertollano/images/2024/06/26/2024062614394193968.jpg');

-- INSERT DE DETALLES (Sincronizados con los IDs de arriba)
INSERT INTO detalle_evento (evento, fecha_inicio, fecha_fin, subtipo, descripcion_detallada, localizacion_exacta, entradas) VALUES 
(1, '2026-06-15 21:00:00', '2026-06-15 23:30:00', 'Flamenco', 'Espectáculo íntimo.', 'Cueva de la Rocío, Cam. del Sacromonte, 70, Granada', 'flamencogranada.com'),
(2, '2026-07-05 20:00:00', '2026-07-05 23:59:00', 'Flamenco', 'Cante hondo frente al mar.', 'Puerto de Almería, 04001 Almería', 'Taquilla puerto'),
(3, '2026-08-15 19:00:00', '2026-08-16 02:00:00', 'Carnaval', 'Coplas y chirigotas.', 'Plaza de las Flores, 11001 Cádiz', 'Gratis'),
(4, '2026-05-16 23:30:00', '2026-05-17 07:00:00', 'Discoteca', 'Experiencia VIP +21.', 'Calle Matemática Rey Pastor, 41092 Sevilla', 'antiquetheteatro.com'),
(5, '2026-03-12 09:00:00', '2026-03-12 14:00:00', 'Trail', 'Carrera sobre nieve.', 'Estación Sierra Nevada, Granada', 'sierranevada.es'),
(6, '2026-06-20 22:00:00', '2026-06-21 06:00:00', 'Flamenco', 'Conciertos en plazas.', 'Plaza de las Tendillas, Córdoba', 'Gratis'),
(7, '2026-07-10 09:00:00', '2026-07-10 13:00:00', 'Patrimonio', 'Guía especializado.', 'C. Real de la Alhambra, s/n, Granada', 'alhambra-tickets.es'),
(8, '2026-07-20 10:00:00', '2026-07-20 20:00:00', 'Voley', 'Torneo de verano.', 'Playa de Aguadulce, Roquetas', 'Inscripción abierta'),
(9, '2026-04-18 12:00:00', '2026-04-25 06:00:00', 'Feria', 'Casetas y rebujito.', 'Recinto Ferial Los Remedios, Sevilla', 'Libre'),
(10, '2026-08-10 17:00:00', '2026-08-12 20:00:00', 'Hípica', 'Carreras en la playa.', 'Playa de la Calzada, Sanlúcar', 'Gratis'),
(11, '2026-05-05 13:00:00', '2026-05-05 17:00:00', 'Tapas', 'Vino y gastronomía.', 'Barrio de la Judería, Córdoba', '25 euros'),
(12, '2026-02-22 08:30:00', '2026-02-22 14:30:00', 'Atletismo', 'Circuito histórico.', 'Paseo de las Delicias, Sevilla', 'zurichmaratonsevilla.es'),
(13, '2026-05-22 23:00:00', '2026-05-23 06:30:00', 'Show', 'Música comercial.', 'Calle Arabial, 62, Granada', 'teatregranada.com'),
(14, '2026-05-10 13:00:00', '2026-05-17 04:00:00', 'Feria', 'Caballos y vino.', 'Parque González Hontoria, Jerez', 'Libre'),
(15, '2026-06-26 08:00:00', '2026-06-26 15:00:00', 'Tradición', 'Ganado en Doñana.', 'Marismas del Rocío, Almonte', 'Gratis'),
(16, '2026-07-01 22:00:00', '2026-08-31 03:00:00', 'Festival', 'Conciertos de élite.', 'Cantera de Nagüeles, Marbella', 'starlitemarbella.com'),
(17, '2026-02-15 10:00:00', '2026-02-15 15:00:00', 'Ciclismo', 'Carrera UCI.', 'Av. Federico García Lorca, Almería', 'ciclismoalmeria.es'),
(18, '2026-09-01 20:00:00', '2026-09-30 23:00:00', 'Flamenco', 'Máximo exponente.', 'Teatro de la Maestranza, Sevilla', 'labienal.com'),
(19, '2026-07-20 23:00:00', '2026-07-21 07:00:00', 'Party', 'DJ Internacional.', 'Playa de Puerto Banús, Marbella', 'Reserva VIP'),
(20, '2026-12-15 09:00:00', '2026-12-15 15:00:00', 'Running', 'Vistas al mar.', 'Paseo del Parque, Málaga', 'malagamaraton.com'),
(21, '2026-07-15 21:00:00', '2026-07-16 01:00:00', 'Visual', 'Velas en el centro.', 'Plaza Vázquez de Molina, Úbeda', 'Gratis'),
(22, '2026-07-12 10:00:00', '2026-07-12 13:00:00', 'Natación', 'Cruce de la ría.', 'Muelle de las Carabelas, Huelva', 'Inscripción online'),
(23, '2026-03-29 18:00:00', '2026-04-05 23:59:00', 'Religioso', 'Procesiones Albaicín.', 'Plaza Pasiegas, Granada', 'Libre'),
(24, '2026-05-20 23:00:00', '2026-05-21 06:00:00', 'Club', 'Tres ambientes.', 'CC Neptuno, Granada', 'maewest.com'),
(25, '2026-01-16 20:00:00', '2026-01-16 22:00:00', 'Running', 'Carrera de antorchas.', 'Av. de Andalucía, Jaén', 'Inscripción dorsalchip'),
(26, '2026-09-12 11:00:00', '2026-09-12 14:00:00', 'Vino', 'Cata en bodegas.', 'Bollullos Par del Condado, Huelva', 'turismohuelva.es'),
(27, '2026-05-22 23:00:00', '2026-05-23 07:00:00', 'Club', 'Junto a C. Larios.', 'C. Luis de Velázquez, Málaga', 'salagold.es'),
(28, '2026-06-21 09:00:00', '2026-06-21 13:00:00', 'Triatlón', 'Playa de la Victoria.', 'Paseo Marítimo, Cádiz', 'triatlonandalucia.org'),
(29, '2026-06-15 21:00:00', '2026-06-16 02:00:00', 'Rock', 'Bandas en directo.', 'Auditorio Municipal, Dos Hermanas', 'Gratis'),
(30, '2026-10-18 08:00:00', '2026-10-18 21:00:00', 'Romería', 'Carretas de papel.', 'Plaza Constitución, Dos Hermanas', 'Gratis'),
(31, '2026-05-30 10:00:00', '2026-05-30 20:00:00', 'Skate', 'Campeonato local.', 'Skatepark Montecillos, Dos Hermanas', 'Libre'),
(32, '2026-08-08 00:00:00', '2026-08-08 07:00:00', 'Luxury', 'Ambiente internacional.', 'Carr. Istán, Km 0.8, Marbella', 'oliviavalere.com'),
(33, '2026-04-10 10:00:00', '2026-04-10 18:00:00', 'Cicloturismo', 'Túneles y olivos.', 'Antigua estación FFCC, Jaén', 'Libre'),
(34, '2026-12-15 20:00:00', '2026-12-24 02:00:00', 'Flamenco', 'Villancicos.', 'Barrio de Santiago, Jerez', 'Gratis'),
(35, '2026-05-14 23:30:00', '2026-05-15 06:00:00', 'Club', 'Noches universitarias.', 'Calle de la Bodega, 2, Córdoba', 'Taquilla'),
(36, '2026-08-12 21:00:00', '2026-08-13 01:00:00', 'Trail', 'Luna llena.', 'Playa San José, Almería', 'dorsalchip.es'),
(37, '2026-11-10 10:00:00', '2026-11-18 23:00:00', 'Cine', 'Alfombra roja.', 'Casa Colón, Huelva', 'festicinehuelva.com'),
(38, '2026-06-20 23:45:00', '2026-06-21 07:00:00', 'Club', 'Diseño vanguardista.', 'Paseo Marítimo, Cádiz', 'occoartclub.com'),
(39, '2026-05-30 09:00:00', '2026-05-30 14:00:00', 'Remo', 'Regata histórica.', 'Muelle de Nueva York, Sevilla', 'Gratis'),
(40, '2026-11-20 20:00:00', '2026-11-20 21:30:00', 'Clásica', 'Órgano barroco.', 'Catedral de Jaén', '5 euros'),
(41, '2026-07-15 21:00:00', '2026-07-31 01:00:00', 'Indie', 'Conciertos verano.', 'Monasterio de la Cartuja, Sevilla', 'nocturama.es'),
(42, '2026-04-05 10:00:00', '2026-04-12 18:00:00', 'Tenis', 'Open internacional.', 'Puente Romano, Marbella', 'atptour.com'),
(43, '2026-05-10 10:00:00', '2026-05-10 14:00:00', 'Cine', 'Escenarios Western.', 'Desierto de Tabernas, Almería', 'Visita guiada'),
(44, '2026-07-25 23:00:00', '2026-07-26 06:00:00', 'Beach Club', 'Cócteles de autor.', 'Paseo del Mar, Roquetas', 'mandalay.com'),
(45, '2026-03-08 09:30:00', '2026-03-08 12:30:00', 'Atletismo', 'Centro histórico.', 'Plaza Nueva, Lucena', 'lucena.es'),
(46, '2026-07-18 22:30:00', '2026-07-25 02:00:00', 'Jazz', 'Parque Majuelo.', 'Castillo de San Miguel, Almuñécar', 'jazzalmunecar.es'),
(47, '2026-05-21 23:00:00', '2026-05-22 07:00:00', 'Club', 'Bajo las Setas.', 'Plaza Encarnación, Sevilla', 'kokosevilla.com'),
(48, '2026-05-01 08:00:00', '2026-05-03 16:00:00', 'Motor', 'Mundial MotoGP.', 'Circuito de Jerez', 'circuitodejerez.com'),
(49, '2026-09-15 10:00:00', '2026-09-17 22:00:00', 'Cultura', 'Gladiadores.', 'Recinto ferial Lucena', 'Gratis'),
(50, '2026-07-04 22:00:00', '2026-07-05 02:00:00', 'Blues', 'Junto al mar.', 'Puerto de Motril', 'Gratis');

-- PRUEBAS FINALES
select * from usuario;