USE master;
ALTER DATABASE HOTEL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE HOTEL ;

CREATE DATABASE HOTEL

USE HOTEL;

CREATE TABLE roles
(
    id_rol INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE usuario
(
    id_usuario INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre_usuario VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    clave VARCHAR(500) NOT NULL,
    apellido_paterno VARCHAR(255),
    apellido_materno VARCHAR(255),
    nombre VARCHAR(255) NOT NULL,
    telefono VARCHAR(127) NOT NULL,
    direccion VARCHAR(255),
    rfc VARCHAR(127) NOT NULL,
    id_rol INT FOREIGN KEY REFERENCES roles(id_rol) NOT NULL
);

CREATE INDEX idx_user
ON usuario (id_usuario,nombre_usuario);

CREATE TABLE trabajador
(
    id_trabajador INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_usuario INT FOREIGN KEY REFERENCES usuario(id_usuario) NOT NULL,
    salario INT NOT NULL,
);

CREATE INDEX idx_trabajador
ON trabajador (id_trabajador,id_usuario);

CREATE TABLE tipo_habitacion
(
    id_tipo_habitacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    capacidad INT NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    precio MONEY NOT NULL
);

CREATE TABLE estatus_habitacion
(
    id_status INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);


CREATE TABLE habitacion
(
    id_habitacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    numero INT NOT NULL,
    id_tipo_habitacion INT FOREIGN KEY REFERENCES tipo_habitacion(id_tipo_habitacion) NOT NULL,
    id_status INT FOREIGN KEY REFERENCES estatus_habitacion(id_status) NOT NULL,
);

CREATE TABLE reservacion
(
    id_reservacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_cliente INT FOREIGN KEY REFERENCES usuario(id_usuario) NOT NULL,
    id_habitacion INT FOREIGN KEY REFERENCES habitacion(id_habitacion) NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL
);

CREATE TABLE tipo_pago
(
    id_tipo_pago INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE pago
(
    id_pago INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_tipo_pago INT FOREIGN KEY REFERENCES tipo_pago(id_tipo_pago) NOT NULL,
    fecha DATETIME NOT NULL,
);

CREATE TABLE cargo
(
    id_cargo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_reservacion INT FOREIGN KEY REFERENCES reservacion(id_reservacion) NOT NULL,
    descripcion VARCHAR(255),
    monto MONEY NOT NULL,
    fecha DATETIME NOT NULL,
    id_pago INT FOREIGN KEY REFERENCES pago(id_pago) DEFAULT null,
);

SELECT id_trabajador,salario,usuario.* FROM trabajador INNER JOIN usuario ON usuario.id_usuario=trabajador.id_usuario