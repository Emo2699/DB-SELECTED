/*SCRIPT DONDE ESTAN LOS TRIGGERS Y LA BITACORA*/

USE HOTEL;

SELECT * FROM reservacion;

--CREACION DE LA TABLA DE LA BITACORA DONDE ALMACENAREMOS LA INFORMACION QUE DESEAMOS REGISTRAR

CREATE TABLE Bitacora_reservacion(
	id INT IDENTITY NOT NULL PRIMARY KEY, --Id del movimiento realizado
	operacion VARCHAR(10) NOT NULL, -- referencia al tipo de movimiento realizado
	usuario VARCHAR(40) DEFAULT NULL, --usuario quien realizo el movimiento
	host VARCHAR(30) DEFAULT NULL, --Host donde ocurrio el movimiento
	fecha_modificacion DATETIME DEFAULT NULL, --fecha de cuando se realizo el movimiento
	tabla VARCHAR(40) NOT NULL,  --tabla donde ocurrio el movimiento


	--Agregamos una constrain para los valores aceptados en operacion
	CONSTRAINT ck_operacion CHECK (operacion in ('I','U','D'))
	/*
		I --> Insert
		U --> Update
		D --> Delete
	*/
);

SELECT * FROM Bitacora_reservacion;

/*Creamos los triggers para la tabla reservacion*/


--Trigger de Insert
CREATE TRIGGER TR_INS_reservacion
ON reservacion
AFTER INSERT --> Especificamos que el movimiento lo registre despues de hacer la insercion
AS BEGIN
	--insertamos los datos en la tabla bitacora_reservacion
	INSERT INTO Bitacora_reservacion(operacion,usuario,host,fecha_modificacion,tabla)
	VALUES(
		'I',
		SUSER_NAME(), --> nombre del usuario quien realizo la insercion
		@@SERVERNAME, --> nombre del servidor quien hizo la insercion
		GETDATE(), --> fecha de cuando se realizo la insercion
		'reservacion' --> nombre de la tabla donde se realizo la insercion
	)
END

--PRUEBA DEL TRIGGER
INSERT INTO reservacion VALUES (8,24,'2023-01-9', '2023-01-16');
SELECT * FROM Bitacora_reservacion;


--Trigger de Delete
CREATE TRIGGER TR_DEL_reservacion
ON reservacion
AFTER DELETE --> Especificamos que el movimiento lo registre despues de hacer la eliminacion
AS BEGIN
	--insertamos los datos en la tabla bitacora_reservacion
	INSERT INTO Bitacora_reservacion(operacion,usuario,host,fecha_modificacion,tabla)
	VALUES(
		'D',
		SUSER_NAME(), --> nombre del usuario quien realizo la insercion
		@@SERVERNAME, --> nombre del servidor quien hizo la insercion
		GETDATE(), --> fecha de cuando se realizo la insercion
		'reservacion' --> nombre de la tabla donde se realizo la insercion
	)
END
--Prueba del trigger
SELECT * FROM reservacion;
DELETE FROM reservacion WHERE id_reservacion = 6

SELECT * FROM Bitacora_reservacion;


--Bitacora de actualizacion en la tabla reservacion
CREATE TABLE Bitacora_UPD_reservacion(
	id INT IDENTITY NOT NULL PRIMARY KEY, --Id del movimiento realizado
	operacion VARCHAR(2) NOT NULL, -- referencia al tipo de movimiento realizado SOLO 'U'
	usuario VARCHAR(40) DEFAULT NULL, --usuario quien realizo el movimiento
	host VARCHAR(30) DEFAULT NULL, --Host donde ocurrio el movimiento
	fecha_modificacion DATETIME DEFAULT NULL, --fecha de cuando se realizo el movimiento
	PK VARCHAR(5) NOT NULL, --> PK del registro modificado
	tabla VARCHAR(40) NOT NULL,  --tabla donde ocurrio el movimiento
	campo VARCHAR(30) NOT NULL, --> Columna en donde se realizo la modificacion
	valor_viejo VARCHAR(30) NOT NULL, --> Valor antes de la modificacion
	valor_nuevo VARCHAR(30) NOT NULL, --Valor nuevo despues de la modificacion
	accion_inversa VARCHAR(200) NOT NULL --> Accion para recuperar el valor anterior
);


--CREACION DEL TRIGGER
--DROP TRIGGER TR_UPD_reservacion
CREATE TRIGGER TR_UPD_reservacion
ON reservacion
AFTER UPDATE -->Especificamos que el movimiento lo registre despues de hacer la eliminacion
AS BEGIN
	SET NOCOUNT ON --> DDescativamos el conteo de las  filas modificadas
	
	/*		DECLARAMOS LAS VARIABLES PARA LOS VALORES NUEVOS		*/
	DECLARE @@Id_reservacion_Inserted INT
	DECLARE @@Id_cliente_Inserted INT
	DECLARE @@Id_habitacion_Inserted INT
	DECLARE @@fechaInicio_Inserted DATETIME
	DECLARE @@fechaFin_Inserted DATETIME

	/*		DECLARAMOS LAS VARIABLES PARA LOS VALORES VIEJOS		*/
	DECLARE @@Id_reservacion_Deleted INT
	DECLARE @@Id_cliente_Deleted INT
	DECLARE @@Id_habitacion_Deleted INT
	DECLARE @@fechaInicio_Deleted DATETIME
	DECLARE @@fechaFin_Deleted DATETIME

	--Declaramos nuestros cursores para leer los registros
	--Cursor para la tabla inserted
	DECLARE cursor_inserta_reservacion CURSOR
	FOR SELECT id_reservacion,id_cliente,id_habitacion,fecha_inicio,fecha_fin FROM INSERTED
	FOR READ ONLY
	OPEN cursor_inserta_reservacion

	--Cursor para la tabla deleted
	DECLARE cursor_borra_reservacion CURSOR
	FOR SELECT id_reservacion,id_cliente,id_habitacion,fecha_inicio,fecha_fin FROM DELETED
	FOR READ ONLY
	OPEN cursor_borra_reservacion

	--Llenamos las variables, asignandoles su cursor correspondiente
	FETCH NEXT FROM cursor_inserta_reservacion INTO @@Id_reservacion_Inserted, @@Id_cliente_Inserted,@@Id_habitacion_Inserted,@@fechaInicio_Inserted,@@fechaFin_Inserted
	FETCH NEXT FROM cursor_borra_reservacion INTO @@Id_reservacion_Deleted, @@Id_cliente_Deleted,@@Id_habitacion_Deleted,@@fechaInicio_Deleted,@@fechaFin_Deleted

	/*
		Iniciamos un bucle donde estaremos leyendo tuplas hasta que lleguemos al EOF,
		esto sirve cuando tenemos más de una modificacion que tratar a la vez
	*/
	WHILE(@@FETCH_STATUS <> -1)
	BEGIN -->Inicio del bucle
		
		--Verificamos que el registro no sea nulo
		IF @@Id_reservacion_Inserted IS NOT NULL
		BEGIN
			--INICIO DE LAS COMPARACIONES DE CAMBIOS EN CADA UNO DE LOS CAMPOS
			IF(@@Id_cliente_Inserted <> @@Id_cliente_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_reservacion(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_reservacion_Inserted,'Reservacion','Id_cliente',@@Id_cliente_Deleted,@@Id_cliente_Inserted,
				'UPDATE reservacion SET id_cliente = '+CHAR(39)+@@Id_cliente_Deleted+CHAR(39)+'WHERE id_reservacion = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_reservacion_Inserted)+CHAR(39)
			END
		
			IF(@@Id_habitacion_Inserted <> @@Id_habitacion_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_reservacion(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_reservacion_Inserted,'Reservacion','Id_habitacion',@@Id_habitacion_Deleted,@@Id_habitacion_Inserted,
				'UPDATE reservacion SET id_habitacion = '+CHAR(39)+@@Id_habitacion_Deleted+CHAR(39)+'WHERE id_reservacion = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_reservacion_Inserted)+CHAR(39)
			END

			IF(@@fechaInicio_Inserted <> @@fechaInicio_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_reservacion(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_reservacion_Inserted,'Reservacion','fecha_inicio',@@fechaInicio_Deleted,@@fechaInicio_Inserted,
				'UPDATE reservacion SET fecha_inicio = '+CHAR(39)+CONVERT(NVARCHAR(11),@@fechaInicio_Deleted)+CHAR(39)+'WHERE id_reservacion = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_reservacion_Inserted)+CHAR(39)
			END

			IF(@@fechaFin_Inserted <> @@fechaFin_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_reservacion(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_reservacion_Inserted,'Reservacion','fecha_fin',@@fechaFin_Deleted,@@fechaFin_Inserted,
				'UPDATE reservacion SET fecha_fin = '+CHAR(39)+CONVERT(NVARCHAR(11),@@fechaFin_Deleted)+CHAR(39)+'WHERE id_reservacion = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_reservacion_Inserted)+CHAR(39)
			END
		
		END--fin IF del Id_reservacion

		--Avanzamos el cursor para leer el siguiente registro que pudiese existir
		FETCH NEXT FROM cursor_inserta_reservacion INTO @@Id_reservacion_Inserted, @@Id_cliente_Inserted,@@Id_habitacion_Inserted,@@fechaInicio_Inserted,@@fechaFin_Inserted
		FETCH NEXT FROM cursor_borra_reservacion INTO @@Id_reservacion_Deleted, @@Id_cliente_Deleted,@@Id_habitacion_Deleted,@@fechaInicio_Deleted,@@fechaFin_Deleted

	END --> Fin del bucle

	--CERRAMOS LOS CURSORES
	CLOSE cursor_inserta_reservacion
	DEALLOCATE  cursor_inserta_reservacion

	CLOSE cursor_borra_reservacion
	DEALLOCATE  cursor_borra_reservacion

END -->fin del trigger

--Pruebas del trigger
SELECT * FROM reservacion;
UPDATE reservacion SET fecha_fin = '2024-01-25' WHERE id_reservacion = 4
SELECT * FROM reservacion;
SELECT * FROM Bitacora_UPD_reservacion;




--CREACION DE LA TABLA PARA LA BITACORA EN LA TABLA usuario
CREATE TABLE Bitacora_usuario(
	id INT IDENTITY NOT NULL PRIMARY KEY, --Id del movimiento realizado
	operacion VARCHAR(2) NOT NULL, -- referencia al tipo de movimiento realizado
	usuario VARCHAR(40) DEFAULT NULL, --usuario quien realizo el movimiento
	host VARCHAR(30) DEFAULT NULL, --Host donde ocurrio el movimiento
	fecha_modificacion DATETIME DEFAULT NULL, --fecha de cuando se realizo el movimiento
	tabla VARCHAR(40) NOT NULL,  --tabla donde ocurrio el movimiento

	--Agregamos una constrain para los valores aceptados en operacion
	CONSTRAINT ck_operacion_bt_usuario CHECK (operacion in ('I','D'))
	/*
		I --> Insert
		D --> Delete
	*/
);

/*	Creacion de los trigger para la tabla usuario	*/
--Trigger de Insert
CREATE TRIGGER TR_INS_usuario
ON usuario
AFTER INSERT --> Especificamos que el movimiento lo registre despues de hacer la insercion
AS BEGIN
	--insertamos los datos en la tabla Bitacora_usuario
	INSERT INTO Bitacora_usuario(operacion,usuario,host,fecha_modificacion,tabla)
	VALUES(
		'I',
		SUSER_NAME(), --> nombre del usuario quien realizo la insercion
		@@SERVERNAME, --> nombre del servidor quien hizo la insercion
		GETDATE(), --> fecha de cuando se realizo la insercion
		'usuario' --> nombre de la tabla donde se realizo la insercion
	)
END

--PRUEBA DEL TRIGGER
SELECT * FROM usuario;
INSERT INTO usuario VALUES ('nombre_usuario','email','clave','paterno','materno','nombre','telefono','direccion','rfc',11);
SELECT * FROM usuario;
SELECT * FROM Bitacora_usuario;

--Trigger de Delete
CREATE TRIGGER TR_DEL_usuario
ON usuario
AFTER DELETE --> Especificamos que el movimiento lo registre despues de hacer la eliminacion
AS BEGIN
	--insertamos los datos en la tabla Bitacora_usuario
	INSERT INTO Bitacora_usuario(operacion,usuario,host,fecha_modificacion,tabla)
	VALUES(
		'D',
		SUSER_NAME(), --> nombre del usuario quien realizo la insercion
		@@SERVERNAME, --> nombre del servidor quien hizo la insercion
		GETDATE(), --> fecha de cuando se realizo la insercion
		'usuario' --> nombre de la tabla donde se realizo la insercion
	)
END

SELECT * FROM usuario
DELETE FROM usuario WHERE id_usuario = 56
SELECT * FROM usuario
SELECT * FROM Bitacora_usuario;


--Bitacora de actualizacion en la tabla reservacion
CREATE TABLE Bitacora_UPD_usuario(
	id INT IDENTITY NOT NULL PRIMARY KEY, --Id del movimiento realizado
	operacion VARCHAR(2) NOT NULL, -- referencia al tipo de movimiento realizado SOLO 'U'
	usuario VARCHAR(40) DEFAULT NULL, --usuario quien realizo el movimiento
	host VARCHAR(30) DEFAULT NULL, --Host donde ocurrio el movimiento
	fecha_modificacion DATETIME DEFAULT NULL, --fecha de cuando se realizo el movimiento
	PK VARCHAR(5) NOT NULL, --> PK del registro modificado
	tabla VARCHAR(40) NOT NULL,  --tabla donde ocurrio el movimiento
	campo VARCHAR(30) NOT NULL, --> Columna en donde se realizo la modificacion
	valor_viejo VARCHAR(30) NOT NULL, --> Valor antes de la modificacion
	valor_nuevo VARCHAR(30) NOT NULL, --Valor nuevo despues de la modificacion
	accion_inversa VARCHAR(200) NOT NULL --> Accion para recuperar el valor anterior
);


--CREACION DEL TRIGGER
--DROP TRIGGER TR_UPD_usuario
CREATE TRIGGER TR_UPD_usuario
ON usuario
AFTER UPDATE -->Especificamos que el movimiento lo registre despues de hacer la eliminacion
AS BEGIN
	SET NOCOUNT ON --> DDescativamos el conteo de las  filas modificadas
	
	/*		DECLARAMOS LAS VARIABLES PARA LOS VALORES NUEVOS		*/
	DECLARE @@Id_usuario_Inserted INT
	DECLARE @@nombre_usuario_Inserted VARCHAR(255)
	DECLARE @@email_Inserted VARCHAR(255)
	DECLARE @@clave_Inserted VARCHAR(255)
	DECLARE @@apellido_paterno_Inserted VARCHAR(255)
	DECLARE @@apellido_materno_Inserted VARCHAR(255)
	DECLARE @@nombre_Inserted VARCHAR(255)
	DECLARE @@telefono_Inserted VARCHAR(127)
	DECLARE @@direccion_Inserted VARCHAR(255)
	DECLARE @@rfc_Inserted VARCHAR(127)
	DECLARE @@Id_rol_Inserted INT

	/*		DECLARAMOS LAS VARIABLES PARA LOS VALORES VIEJOS		*/
	DECLARE @@Id_usuario_Deleted INT
	DECLARE @@nombre_usuario_Deleted VARCHAR(255)
	DECLARE @@email_Deleted VARCHAR(255)
	DECLARE @@clave_Deleted VARCHAR(255)
	DECLARE @@apellido_paterno_Deleted VARCHAR(255)
	DECLARE @@apellido_materno_Deleted VARCHAR(255)
	DECLARE @@nombre_Deleted VARCHAR(255)
	DECLARE @@telefono_Deleted VARCHAR(127)
	DECLARE @@direccion_Deleted VARCHAR(255)
	DECLARE @@rfc_Deleted VARCHAR(127)
	DECLARE @@Id_rol_Deleted INT

	--Declaramos nuestros cursores para leer los registros
	--Cursor para la tabla inserted
	DECLARE cursor_inserta_usuario CURSOR
	FOR SELECT id_usuario,nombre_usuario,email,clave,apellido_paterno,apellido_materno,nombre,telefono,direccion,rfc,id_rol FROM INSERTED
	FOR READ ONLY
	OPEN cursor_inserta_usuario

	--Cursor para la tabla deleted
	DECLARE cursor_borra_usuario CURSOR
	FOR SELECT id_usuario,nombre_usuario,email,clave,apellido_paterno,apellido_materno,nombre,telefono,direccion,rfc,id_rol FROM DELETED
	FOR READ ONLY
	OPEN cursor_borra_usuario

	--Llenamos las variables, asignandoles su cursor correspondiente
	FETCH NEXT FROM cursor_inserta_usuario INTO @@Id_usuario_Inserted,@@nombre_usuario_Inserted,@@email_Inserted,@@clave_Inserted,
	@@apellido_paterno_Inserted,@@apellido_materno_Inserted,@@nombre_Inserted,@@telefono_Inserted,@@direccion_Inserted,@@rfc_Inserted,@@Id_rol_Inserted
	
	FETCH NEXT FROM cursor_borra_usuario INTO @@Id_usuario_Deleted,@@nombre_usuario_Deleted,@@email_Deleted,@@clave_Deleted,
	@@apellido_paterno_Deleted,@@apellido_materno_Deleted,@@nombre_Deleted,@@telefono_Deleted,@@direccion_Deleted,@@rfc_Deleted,@@Id_rol_Deleted

	/*
		Iniciamos un bucle donde estaremos leyendo tuplas hasta que lleguemos al EOF,
		esto sirve cuando tenemos más de una modificacion que tratar a la vez
	*/
	WHILE(@@FETCH_STATUS <> -1)
	BEGIN -->Inicio del bucle
		
		--Verificamos que el registro no sea nulo
		IF @@Id_usuario_Inserted IS NOT NULL
		BEGIN
			--INICIO DE LAS COMPARACIONES DE CAMBIOS EN CADA UNO DE LOS CAMPOS
			IF(@@nombre_usuario_Inserted <> @@nombre_usuario_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','nombre_usuario',@@nombre_usuario_Deleted,@@nombre_usuario_Inserted,
				'UPDATE usuario SET nombre_usuario = '+CHAR(39)+@@nombre_usuario_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END
		
			IF(@@email_Inserted <> @@email_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','email',@@email_Deleted,@@email_Inserted,
				'UPDATE usuario SET email = '+CHAR(39)+@@email_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END

			IF(@@clave_Inserted <> @@clave_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','clave',@@clave_Deleted,@@clave_Inserted,
				'UPDATE usuario SET clave = '+CHAR(39)+@@clave_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END

			IF(@@apellido_paterno_Inserted <> @@apellido_paterno_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','apellido_paterno',@@apellido_paterno_Deleted,@@apellido_paterno_Inserted,
				'UPDATE usuario SET apellido_paterno = '+CHAR(39)+@@apellido_paterno_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END

			IF(@@apellido_materno_Inserted <> @@apellido_materno_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','apellido_materno',@@apellido_materno_Deleted,@@apellido_materno_Inserted,
				'UPDATE usuario SET apellido_materno = '+CHAR(39)+@@apellido_materno_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END

			IF(@@nombre_Inserted <> @@nombre_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','nombre',@@nombre_Deleted,@@nombre_Inserted,
				'UPDATE usuario SET nombre = '+CHAR(39)+@@nombre_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END

			IF(@@telefono_Inserted <> @@telefono_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','telefono',@@telefono_Deleted,@@telefono_Inserted,
				'UPDATE usuario SET telefono = '+CHAR(39)+@@telefono_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END

			IF(@@direccion_Inserted <> @@direccion_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','direccion',@@direccion_Deleted,@@direccion_Inserted,
				'UPDATE usuario SET direccion = '+CHAR(39)+@@direccion_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END

			IF(@@rfc_Inserted <> @@rfc_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','rfc',@@rfc_Deleted,@@rfc_Inserted,
				'UPDATE usuario SET rfc = '+CHAR(39)+@@rfc_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END

			IF(@@Id_rol_Inserted <> @@Id_rol_Deleted)
			BEGIN
				INSERT INTO Bitacora_UPD_usuario(operacion,usuario,host,fecha_modificacion,PK,tabla,campo,valor_viejo,valor_nuevo,accion_inversa)
				SELECT 'U',SUSER_NAME(),@@SERVERNAME,GETDATE(),@@Id_usuario_Inserted,'Usuario','Id_rol',@@Id_rol_Deleted,@@Id_rol_Inserted,
				'UPDATE usuario SET Id_rol = '+CHAR(39)+@@Id_rol_Deleted+CHAR(39)+'WHERE id_usuario = '+CHAR(39)+CONVERT(NVARCHAR(3),@@Id_usuario_Inserted)+CHAR(39)
			END
		
		END--fin IF del Id_reservacion

		--Avanzamos el cursor para leer el siguiente registro que pudiese existir
		FETCH NEXT FROM cursor_inserta_usuario INTO @@Id_usuario_Inserted,@@nombre_usuario_Inserted,@@email_Inserted,@@clave_Inserted,
		@@apellido_paterno_Inserted,@@apellido_materno_Inserted,@@nombre_Inserted,@@telefono_Inserted,@@direccion_Inserted,@@rfc_Inserted,@@Id_rol_Inserted
	
		FETCH NEXT FROM cursor_borra_usuario INTO @@Id_usuario_Deleted,@@nombre_usuario_Deleted,@@email_Deleted,@@clave_Deleted,
		@@apellido_paterno_Deleted,@@apellido_materno_Deleted,@@nombre_Deleted,@@telefono_Deleted,@@direccion_Deleted,@@rfc_Deleted,@@Id_rol_Deleted

	END --> Fin del bucle

	--CERRAMOS LOS CURSORES
	CLOSE cursor_inserta_usuario
	DEALLOCATE  cursor_inserta_usuario

	CLOSE cursor_borra_usuario
	DEALLOCATE  cursor_borra_usuario

END -->fin del trigger

--Prueba Trigger
SELECT TOP(5) * FROM usuario;
UPDATE usuario SET direccion = 'PRUEBA 3 XD' WHERE id_usuario = 3

SELECT TOP(5) * FROM usuario
SELECT * FROM Bitacora_UPD_usuario;
SELECT * FROM Bitacora_UPD_reservacion;

DELETE FROM Bitacora_UPD_reservacion WHERE tabla = 'Usuario'