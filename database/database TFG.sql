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
('Granada', 'Granada'), ('Motril', 'Granada'),
('Almería', 'Almería'), ('Roquetas de Mar', 'Almería'),
('Málaga', 'Málaga'), ('Marbella', 'Málaga'),
('Córdoba', 'Córdoba'), ('Lucena', 'Córdoba'),
('Sevilla', 'Sevilla'), ('Dos Hermanas', 'Sevilla'),
('Huelva', 'Huelva'), ('Almonte', 'Huelva'),
('Cádiz', 'Cádiz'), ('Jerez de la Frontera', 'Cádiz'),
('Jaén', 'Jaén'), ('Úbeda', 'Jaén');

INSERT INTO evento (nombre, tipo, descripcion_simple, confirmada, municipio, imagen) VALUES 
('Concierto Flamenco Mágico', 'Nocturno', 'Disfruta de una noche inolvidable con el mejor flamenco en el corazón de Andalucía.', true, 1, 'https://conciertos.club/doc/a/2017/a_FMC_Vimaambi.jpg'),
('Visita Guiada Alhambra', 'Cultural', 'Recorrido completo por la Alhambra, Generalife y palacios nazaríes.', true, 1, 'https://cdn-imgix.headout.com/media/images/b976375b5f1a1d87578c9d9fe12e2c7e-Alhambra%20Tickets.jpg'),
('Feria de Abril', 'Nocturno', 'Vive la magia de la feria con casetas, rebujito y baile hasta el amanecer.', true, 3, 'https://elflamencoensevilla.com/wp-content/uploads/2023/04/feria-de-sevilla.jpeg'),
('Ruta de Tapas y Vino', 'Cultural', 'Una ruta exquisita por las mejores tabernas tradicionales de Córdoba.', true, 2, 'https://images.unsplash.com/photo-1544148103-0773bf10d330?auto=format&fit=crop&q=80&w=600'),
('Maratón Ciudad de Sevilla', 'Deportivo', 'Participa en la carrera legendaria a través de los monumentos históricos.', true, 3, 'https://deporticket.blob.core.windows.net/awebs/zurich-maraton-de-sevilla-2023/2302-el-zurich-maraton-de-sevilla-vuelve-a-superarse-a-si-mismo-1.jpg');
-- 50 INSERTS DE EVENTOS VARIADOS
INSERT INTO evento (nombre, tipo, descripcion_simple, confirmada, municipio, imagen) VALUES 
-- ALMERÍA (IDs 3, 4)
-- ('Festival Flamenco Almería', 'Cultural', 'Cante hondo frente al mar.', true, 3, 'https://picsum.photos/400/300?random=11'),
-- ('Voley Playa Aguadulce', 'Deportivo', 'Torneo amateur de verano.', true, 4, 'https://picsum.photos/400/300?random=12'),
-- ('Noche de Cortos Almería', 'Nocturno', 'Cine bajo las estrellas.', true, 3, 'https://picsum.photos/400/300?random=13'),
-- ('Ruta del Cine Tabernas', 'Cultural', 'Visita a escenarios de Western.', true, 3, 'https://picsum.photos/400/300?random=14'),
-- ('Fiesta Blanca Roquetas', 'Nocturno', 'Evento en la orilla de la playa.', true, 4, 'https://picsum.photos/400/300?random=15'),
-- ('Clásica Ciclista Almería', 'Deportivo', 'Carrera profesional UCI.', true, 3, 'https://picsum.photos/400/300?random=16'),

-- -- CÁDIZ (IDs 13, 14)
-- ('Carnaval de Verano Cádiz', 'Cultural', 'Coplas y chirigotas en la calle.', true, 13, 'https://picsum.photos/400/300?random=17'),
-- ('Carreras de Caballos Sanlúcar', 'Deportivo', 'Carreras en la arena de la playa.', true, 13, 'https://picsum.photos/400/300?random=18'),
-- ('Feria del Caballo Jerez', 'Cultural', 'Doma, vino y tradición.', true, 14, 'https://picsum.photos/400/300?random=19'),
-- ('Noche de Jazz en el Baluarte', 'Nocturno', 'Concierto con brisa marina.', true, 13, 'https://picsum.photos/400/300?random=20'),
-- ('Gran Premio de Motociclismo', 'Deportivo', 'Mundial de MotoGP en el circuito.', true, 14, 'https://picsum.photos/400/300?random=21'),
-- ('Zambomba Jerezana', 'Cultural', 'Villancicos flamencos tradicionales.', true, 14, 'https://picsum.photos/400/300?random=22'),

-- -- CÓRDOBA (IDs 7, 8)
-- ('Noche Blanca del Flamenco', 'Nocturno', 'Toda la ciudad cantando hasta el alba.', true, 7, 'https://picsum.photos/400/300?random=23'),
-- ('Festival de la Guitarra', 'Cultural', 'Conciertos en el Alcázar.', true, 7, 'https://picsum.photos/400/300?random=24'),
-- ('Media Maratón de Lucena', 'Deportivo', 'Carrera urbana por el centro histórico.', true, 8, 'https://picsum.photos/400/300?random=25'),
-- ('Mercado Romano Lucena', 'Cultural', 'Artesanía y luchas de gladiadores.', true, 8, 'https://picsum.photos/400/300?random=26'),

-- -- GRANADA (IDs 1, 2)
-- ('Festival Jazz en la Costa', 'Cultural', 'Música en el Parque del Majuelo.', true, 2, 'https://picsum.photos/400/300?random=27'),
-- ('Sierra Nevada Ski Trail', 'Deportivo', 'Carrera de montaña sobre nieve.', true, 1, 'https://picsum.photos/400/300?random=28'),
-- ('Cine de Verano Motril', 'Nocturno', 'Pantalla gigante en Playa Granada.', true, 2, 'https://picsum.photos/400/300?random=29'),
-- ('Certamen de Guitarra Clásica', 'Cultural', 'Concurso internacional Andrés Segovia.', true, 2, 'https://picsum.photos/400/300?random=30'),

-- -- HUELVA (IDs 11, 12)
-- ('Saca de las Yeguas', 'Cultural', 'Tradición ganadera en Doñana.', true, 12, 'https://picsum.photos/400/300?random=31'),
-- ('Travesía a Nado Huelva', 'Deportivo', 'Cruce a nado por la ría.', true, 11, 'https://picsum.photos/400/300?random=32'),
-- ('Festival Iberoamericano de Cine', 'Cultural', 'Estrenos y alfombra roja.', true, 11, 'https://picsum.photos/400/300?random=33'),
-- ('Concierto Nocturno Muelle', 'Nocturno', 'Música pop junto a las carabelas.', true, 11, 'https://picsum.photos/400/300?random=34'),
-- ('Rocío de Verano', 'Cultural', 'Peregrinación y convivencia.', true, 12, 'https://picsum.photos/400/300?random=35'),

-- -- JAÉN (IDs 15, 16)
-- ('Festival Internacional Música y Danza', 'Cultural', 'Representaciones en los cerros de Úbeda.', true, 16, 'https://picsum.photos/400/300?random=36'),
-- ('Carrera de San Antón', 'Deportivo', 'Carrera popular con antorchas.', true, 15, 'https://picsum.photos/400/300?random=37'),
-- ('Ruta de la Tapa Jaén', 'Cultural', 'Degustación por el casco antiguo.', true, 15, 'https://picsum.photos/400/300?random=38'),
-- ('Noche en el Castillo de Úbeda', 'Nocturno', 'Cenas con teatro medieval.', true, 16, 'https://picsum.photos/400/300?random=39'),
-- ('Vía Verde del Aceite', 'Deportivo', 'Ruta ciclista por antiguos túneles.', true, 15, 'https://picsum.photos/400/300?random=40'),

-- -- MÁLAGA (IDs 5, 6)
-- ('Starlite Occident', 'Nocturno', 'El festival de las estrellas en la cantera.', true, 6, 'https://picsum.photos/400/300?random=41'),
-- ('Maratón de Málaga', 'Deportivo', '42km con vistas al Mediterráneo.', true, 5, 'https://picsum.photos/400/300?random=42'),
-- ('Feria de Agosto Málaga', 'Cultural', 'Casetas en el centro y Real.', true, 5, 'https://picsum.photos/400/300?random=43'),
-- ('Open Tenis Marbella', 'Deportivo', 'Torneo internacional en tierra batida.', true, 6, 'https://picsum.photos/400/300?random=44'),
-- ('Gastro-Festival Málaga', 'Cultural', 'Feria del producto local y espetos.', true, 5, 'https://picsum.photos/400/300?random=45'),
-- ('Beach Club Party Marbella', 'Nocturno', 'Sesión de DJ en club de lujo.', true, 6, 'https://picsum.photos/400/300?random=46'),

-- -- SEVILLA (IDs 9, 10)
-- ('Bienal de Flamenco', 'Cultural', 'El evento más importante del género.', true, 9, 'https://picsum.photos/400/300?random=47'),
-- ('Nocturama', 'Nocturno', 'Conciertos de música independiente.', true, 9, 'https://picsum.photos/400/300?random=48'),
-- ('Campeonato Remo Guadalquivir', 'Deportivo', 'Regata histórica de ocho con timonel.', true, 9, 'https://picsum.photos/400/300?random=49'),
-- ('Festival Rock Dos Hermanas', 'Nocturno', 'Bandas locales e invitadas.', true, 10, 'https://picsum.photos/400/300?random=50'),
-- ('Carrera Popular Dos Hermanas', 'Deportivo', 'Evento familiar por el municipio.', true, 10, 'https://picsum.photos/400/300?random=51'),

-- EXTRA MIX (Para completar 50)
('Semana Santa Granada', 'Cultural', 'Procesiones por el Albaicín.', true, 1, 'https://www.spain.info/export/sites/segtur/.content/imagenes/cabeceras-grandes/eventos-fiestas/andalucia/Semana-Santa-Granada.jpg'),
('Romería de Valme', 'Cultural', 'Fiesta de Interés Turístico Nacional.', true, 10, 'https://www.periodicoelnazareno.es/wp-content/uploads/2018/10/romeria-valme_017.jpg'),
('Trail Nocturno Almería', 'Deportivo', 'Carrera por el Cabo de Gata.', true, 3, 'https://www.trailrun.es/uploads/s1/11/14/80/11/trail-dels-fars-nocturna-corganizacion.jpeg'),
('Concierto Órgano Catedral Jaén', 'Cultural', 'Música sacra en templo renacentista.', true, 15, 'https://picsum.photos/400/300?random=55'),
('Blues en el Puerto', 'Nocturno', 'Festival de blues de Motril.', true, 2, 'https://www.lacomarcadepuertollano.com/asset/zoomcrop,480,270,center,center/media/lacomarcadepuertollano/images/2024/06/26/2024062614394193968.jpg'),
('Enoturismo Condado Huelva', 'Cultural', 'Visita a bodegas centenarias.', true, 11, 'https://condavision.es/wp-content/uploads/2024/12/foto-2copa-vino-blanco-y-vinedos.-do-condado-de-huelva-scaled.jpg'),
('Triatlón de Cádiz', 'Deportivo', 'Natación en la Caleta y ciclismo.', true, 13, 'https://static.grupojoly.com/clip/bca956e9-7036-4ac5-b919-41dcd6fe6111_source-aspect-ratio_1600w_0.jpg'),
('Noche de las Velas', 'Nocturno', 'Iluminación mágica del pueblo.', true, 16, 'https://populo.es/wp-content/uploads/2025/08/Renacimiento-a-la-luz-de-las-velas-2025-en-baeza-1080x675.jpg'),
('Skate Fest Dos Hermanas', 'Deportivo', 'Exhibiciones y campeonato libre.', true, 10, 'https://www.periodicoelnazareno.es/wp-content/uploads/2019/10/pista-pump-truck.jpg');


select * from usuario;
