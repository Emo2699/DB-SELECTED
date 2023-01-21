--SP DE LA BASE DE DATOS HOTEL

/*----------------  TABLA DE ROLES   ---------------*/ 
--INSERCION
DROP PROCEDURE SP_AgregarRol
CREATE PROCEDURE SP_AgregarRol(
	@descripcion VARCHAR(255)
)
AS
BEGIN 
	IF NOT EXISTS(SELECT id_rol FROM roles WHERE descripcion = @descripcion)
		BEGIN 
			--INSERTAMOS EN LA TABLA roles
			INSERT INTO roles VALUES(@descripcion)
		END
	ELSE
	BEGIN
		--EN CASO DE QUE EXISTA MANDAMOS UN MENSAJE
		PRINT 'Rol existente en la base de datos'
	END
END



--BORRADO
DROP PROCEDURE SP_BorrarRol
CREATE PROCEDURE SP_BorrarRol(
	@descripcion VARCHAR(255)
)
AS
BEGIN 
	IF NOT EXISTS(SELECT id_rol FROM roles WHERE descripcion = @descripcion)
		BEGIN 
			--SI NO EXISTE MANDAMOS UN MENSAJE
			PRINT 'El rol no existe en la Base de datos'
		END
	ELSE
	BEGIN
		--SI EXISTE PROCEDEMOS A BORRARLO DE LA TABLA 
		DELETE FROM roles WHERE descripcion = @descripcion
	END
END




/*--------------- TABLA DE USUARIOS ------------*/
--INSERCION
DROP PROCEDURE SP_AgregarUsuario
CREATE PROCEDURE SP_AgregarUsuario(
    @nombre_usuario VARCHAR(255),
    @email VARCHAR(255),
    @clave VARCHAR(500),
    @apellido_paterno VARCHAR(255),
    @apellido_materno VARCHAR(255),
    @nombre VARCHAR(255),
    @telefono VARCHAR(127),
    @direccion VARCHAR(255),
    @rfc VARCHAR(127),
    @id_rol INT
)
AS
BEGIN
	--VERIFICAMOS QUE NO EXISTA EL USUARIO EN LA BD
	IF NOT EXISTS(SELECT id_usuario FROM usuario WHERE apellido_paterno=@apellido_paterno AND apellido_materno=@apellido_materno AND nombre=@nombre)
		BEGIN
			--VERIFICAMOS QUE EL ROL AL QUE PERTENECE EL NUEVO USUARIO EXISTA EN LA BD
			IF NOT EXISTS(SELECT id_rol FROM roles WHERE id_rol = @id_rol)
				BEGIN
					PRINT 'Rol incorrecto'
				END
			--AGREGAMOS AL NUEVO USUARIO EN LA BD
			ELSE
				BEGIN
					INSERT INTO usuario VALUES (
						@nombre_usuario,@email,@clave,@apellido_paterno,@apellido_materno,@nombre,@telefono,@direccion,@rfc,@id_rol
					)
				END
		END

	--SI EXISTE 
	ELSE
		--MANDAMOS UN MENSAJE
		BEGIN
			PRINT 'El usuario ya existe en la BD '
		END

END 
--BORRADO
DROP PROCEDURE SP_BorrarUsuario
CREATE PROCEDURE SP_BorrarUsuario(@id_usuario INT)
AS
BEGIN
	--VERIFICAMOS SI EXISTE EL USUARIO EN LA BD
	IF NOT EXISTS(SELECT id_usuario FROM usuario WHERE id_usuario = @id_usuario)
		BEGIN 
			PRINT 'Usuario incorrecto :v'
		END
	ELSE
	--PROCEDEMOS A BORRAR AL USUARIO DE LA BD
		BEGIN
			DELETE FROM usuario WHERE id_usuario = @id_usuario
			PRINT 'Usuario eliminado'
		END
END



/*------------ LOGIN -----------------*/
DROP PROCEDURE SP_Login
CREATE PROCEDURE SP_Login(
	@email VARCHAR(255),
	@clave VARCHAR(500)
)
AS 
BEGIN
DECLARE @id_usr INT
	--BUSCAMOS LA EXISTENCIA DEL USUARIO CON DICHAS CREDENCIALES EN LA BD
	IF EXISTS (SELECT id_usuario FROM usuario WHERE email = @email AND clave = @clave)
	BEGIN
		PRINT 'Bienvenido al Sistema'
	END
	ELSE
		--SI NO EXISTE EL USUARIO CON ESAS CREDENCIALES MANDAMOS UN MENSAJE
		BEGIN
			PRINT 'Correo o clave incorrectos -_-'
		END
END


/*------------- TABLA DE HABITACIONES ----------------*/
DROP PROCEDURE SP_AgregarHabitacion
CREATE PROCEDURE SP_AgregarHabitacion()
AS
BEGIN
END

--ACTUALIZACION DEL 19-01-2023
-- SP_reservar2 YA TIENE TRANSACCION
--DROP PROCEDURE SP_reservar2
CREATE PROCEDURE SP_reservar2(
    @id_cliente INT,
    @tipo_habitacion INT,
    @tipo_pago INT,
    @fecha_inicio DATETIME,
    @fecha_fin DATETIME
)
AS
BEGIN --Inicio del sp
    --Validamos la existencia del cliente en la BD
    IF NOT EXISTS (SELECT id_usuario FROM usuario WHERE id_usuario = @id_cliente)
        BEGIN
			PRINT 'El cliente no existe en la base de datos'
			RETURN
		END
    --Validamos que las fechas sean correctas
    /*
        La fecha de inicio debe de ser igual o mayor a la Actual para hacer una reservacion
        La fecha de fin debe de ser mayor a la de inicio
        NOTA: SI NO SE CUMPLE LAS CONDICIONES SE TERMINA EL SP
    */    
    IF ( DATEDIFF(dd,@fecha_inicio,GETDATE()) > 0 OR @fecha_fin < @fecha_inicio)
        BEGIN
			PRINT 'No hay habitaciones disponibles de ese tipo'
			RETURN
		END
    --Verificamos que exista habitaciones disponibles
    IF NOT EXISTS (SELECT id_habitacion FROM habitacion WHERE id_status = 1 AND id_tipo_habitacion = @tipo_habitacion)
        BEGIN
			PRINT 'Error en las fechas ingresadas'
			RETURN
        END
    --Iniciamos el proceso para realizar una reservacion
    BEGIN TRY
        BEGIN TRAN
            SET NOCOUNT ON
            DECLARE @id_habitacion_disponible INT
            SELECT TOP(1) @id_habitacion_disponible = id_habitacion FROM habitacion WHERE id_status = 1 AND id_tipo_habitacion = @tipo_habitacion
            --Insertamos la reservacion en la tabla 'reservacion'
            INSERT INTO reservacion VALUES (@id_cliente,@id_habitacion_disponible,@fecha_inicio,@fecha_fin)
		    
            --Actualizamos el status de la habitacion a ocupada
            UPDATE habitacion SET id_status = 2 WHERE id_habitacion = @id_habitacion_disponible

            --Insercion en la tabla pago
            DECLARE @id_pago INT
            INSERT INTO pago VALUES(@tipo_pago,GETDATE())
            SELECT @id_pago = MAX(id_pago) FROM pago

            --Insercion en la tabla cargo
            DECLARE @id_reservacion INT
            DECLARE @precio MONEY
            --Obtenemos el precio de la habitacion
            SELECT @precio = precio FROM habitacion INNER JOIN tipo_habitacion ON habitacion.id_tipo_habitacion = tipo_habitacion.id_tipo_habitacion WHERE habitacion.id_tipo_habitacion = @tipo_habitacion AND habitacion.id_habitacion = @id_habitacion_disponible

            SELECT @id_reservacion = MAX(id_reservacion) FROM reservacion --Recuperamos el ID de la reservacion previamente generada
            INSERT INTO cargo VALUES(@id_reservacion, 'Apertura de reservacion', @precio,GETDATE(), @id_pago)

            PRINT 'Reservacion realizada correctamente'
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN
        SELECT ERROR_MESSAGE() AS 'Mensaje de Error'
    END CATCH    
    
END --Fin del Sp