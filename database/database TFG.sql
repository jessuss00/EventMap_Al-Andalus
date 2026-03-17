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
    tipo varchar(200) not null,
    descripcion_simple text,
    confirmada boolean,
    municipio int, 
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

INSERT INTO usuario (nombre, apellidos, email, contraseña, dni, edad)
VALUES ('Test', 'User', 'test@test.com', '1234', '12345678Z', 25);


