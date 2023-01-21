USE HOTEL;

--Llenado de las tablas en la BD
--Registros en la tabla roles
--INSERT INTO roles VALUES('Administrador');
INSERT INTO roles VALUES('Recepcionista');
INSERT INTO roles VALUES('Cocinero');
INSERT INTO roles VALUES('Limpieza');
INSERT INTO roles VALUES('Cliente');

--Registros en tabla estatus_habitacion
INSERT INTO estatus_habitacion VALUES('Disponible');
INSERT INTO estatus_habitacion VALUES('Ocupada');
INSERT INTO estatus_habitacion VALUES('Limpieza');

--Registros en tabla tipo_habitacion
INSERT INTO tipo_habitacion VALUES(1,'Habitacion Individual',200);
INSERT INTO tipo_habitacion VALUES(2,'Habitacion Doble',400);
INSERT INTO tipo_habitacion VALUES(4,'Habitacion Cuadruple',800);

--Registros en la tabla habitacion
INSERT INTO habitacion VALUES(100,1,1);
INSERT INTO habitacion VALUES(101,1,1);
INSERT INTO habitacion VALUES(102,1,1);
INSERT INTO habitacion VALUES(103,1,1);
INSERT INTO habitacion VALUES(104,1,1);
INSERT INTO habitacion VALUES(105,1,1);
INSERT INTO habitacion VALUES(106,1,1);
INSERT INTO habitacion VALUES(107,1,1);
INSERT INTO habitacion VALUES(108,1,1);
INSERT INTO habitacion VALUES(109,1,1);
INSERT INTO habitacion VALUES(110,1,1);
INSERT INTO habitacion VALUES(111,1,1);
INSERT INTO habitacion VALUES(112,1,1);
INSERT INTO habitacion VALUES(113,1,1);
INSERT INTO habitacion VALUES(114,1,1);
INSERT INTO habitacion VALUES(115,1,1);
INSERT INTO habitacion VALUES(116,1,1);
INSERT INTO habitacion VALUES(117,1,1);
INSERT INTO habitacion VALUES(118,1,1);
INSERT INTO habitacion VALUES(119,1,1);
INSERT INTO habitacion VALUES(120,1,1); --20 Habitaciones individuales
INSERT INTO habitacion VALUES(121,2,1);
INSERT INTO habitacion VALUES(122,2,1);
INSERT INTO habitacion VALUES(123,2,1);
INSERT INTO habitacion VALUES(124,2,1);
INSERT INTO habitacion VALUES(125,2,1);
INSERT INTO habitacion VALUES(126,2,1);
INSERT INTO habitacion VALUES(127,2,1);
INSERT INTO habitacion VALUES(128,2,1);
INSERT INTO habitacion VALUES(129,2,1);
INSERT INTO habitacion VALUES(130,2,1);
INSERT INTO habitacion VALUES(131,2,1);
INSERT INTO habitacion VALUES(132,2,1);
INSERT INTO habitacion VALUES(133,2,1);
INSERT INTO habitacion VALUES(134,2,1);
INSERT INTO habitacion VALUES(135,2,1);
INSERT INTO habitacion VALUES(136,2,1);
INSERT INTO habitacion VALUES(137,2,1);
INSERT INTO habitacion VALUES(138,2,1);
INSERT INTO habitacion VALUES(139,2,1);
INSERT INTO habitacion VALUES(140,2,1); --20 habitaciones dobles
INSERT INTO habitacion VALUES(141,3,1);
INSERT INTO habitacion VALUES(142,3,1);
INSERT INTO habitacion VALUES(143,3,1);
INSERT INTO habitacion VALUES(144,3,1);
INSERT INTO habitacion VALUES(145,3,1);
INSERT INTO habitacion VALUES(146,3,1);
INSERT INTO habitacion VALUES(147,3,1);
INSERT INTO habitacion VALUES(148,3,1);
INSERT INTO habitacion VALUES(149,3,1);
INSERT INTO habitacion VALUES(150,3,1); --10 habitaciones cuadruples

--Registros en la tabla tipo_pago               //Hasta aqui voy XD
INSERT INTO tipo_pago VALUES('Efectivo');
INSERT INTO tipo_pago VALUES('Tarjeta');

--Registros en la tabla usuario
--VALUES('nombre_usuario','email',clave,'apellido_paterno','apellido_materno','nombre',telefono,'direccion',rfc,id_rol)
/*
    id_rol  |   descripcion
    1       |   Administrador  
    8       |   Recepcionista
    9       |   Cocinero
    10      |   Limpieza
    11      |   Cliente
*/
--Clientes (10)
INSERT INTO usuario VALUES('Alex99','alex@gmail.com',12345,'Santes','Herrera','Mauricio Alexander','5510203040','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('Edgar_Prz','Edgar@gmail.com',12345,'Flores','Perez','Edgar','5599826310','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('AlanCrz_2030','AlanCRZ@gmail.com',12345,'Cruz','Chavez','Alan Francisco','5544846471','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('GoldenEscorpion_2023','GoldenScorpion@gmmail.com',12345,'Quien','Sabe','Golden Scorpion','5512629578','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('AdrianX23','Adrian@gmail.com',12345,'Flores','Herrera','Adrian','5599875432','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('Sheldon13','Sheldon@gmail.com',12345,'Shelly','Cooper','Sheldon','5545658423','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('Leonardo69','leo@gmail.com',12345,'Hernandez','Morales','Leonardo','5525854693','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('Howard54','Howard10@gmail.com',12345,'Wologitz','Quien sabe','Howard','5530257892','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('Enrique_Esponja','mito@gmail.com',12345,'Ramirez','Morales','Enrique','5512457896','AV Prueba','rfc',11);
INSERT INTO usuario VALUES('GokuSjj','goku13@gmail.com',12345,'Gomez','Zarate','Ezequiel','5511223366','AV Prueba','rfc',11);

--Trabajadores
--Limpieza 20
INSERT INTO usuario VALUES('Sandra01','SandraGmz@gmail.com',12345,'Gomez','Garcia','Sandra','5599887754','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Andrea02','AndreaMtz@gmail.com',12345,'Martinez','Lopez','Andrea','5515987436','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Ruben03','RubenPrz@gmail.com',12345,'Perez','Ramirez','Ruben','5515658478','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Pedro04','PedroGzl@gmail.com',12345,'Gonzales','Robles','Pedro','5512369875','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Juan05','JuanReyes@gmail.com',12345,'Reyes','Robles','Juan','5566558749','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Hugo06','JuanReyes@gmail.com',12345,'Reyes','Robles','Juan','5566558749','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Rodrigo07','RodrigMoreno@gmail.com',12345,'Moreno','Ortiz','Rodrigo','5514589674','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Javier08','JavierO@gmail.com',12345,'Ortiz','Castillo','Javier','5514586974','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Perla09','Perla@gmail.com',12345,'Jimenez','Mendoza','Perla','5512058941','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Sofia10','Sofia@gmail.com',12345,'Aguilar','Chavez','Sofia','551263965','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Ximena11','Ximena@gmail.com',12345,'Rivera','Hernandez','Ximena','5578956345','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Sergio12','Sergio12@gmail.com',12345,'Mendez','Juarez','Sergio','5545789630','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Mateo13','MateoG@gmail.com',12345,'Gutierrez','Ramos','Mateo','5512458630','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Manuel14','ManuelH@gmail.com',12345,'Herrera','Castro','Manuel','5516968752','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Yuliana15','YuliE@gmail.com',12345,'Elizalde','Castro','Yuliana','5566558749','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Marcos16','MarcosSalazar@gmail.com',12345,'Salazar','Contreras','Marcos','5515489630','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Hector17','HectorMdz@gmail.com',12345,'Mendez','Gonzales','Hector','5588996532','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Samuel18','Samuel@gmail.com',12345,'Rojas','Paredes','Samuel','5578445230','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Leticia19','LeticiaMorales@gmail.com',12345,'Morales','Luna','Leticia','5511235699','AV Prueba','rfc',10);
INSERT INTO usuario VALUES('Wendy20','Wendy15@gmail.com',12345,'Santiago','Velazquez','Wendy','5577885532','AV Prueba','rfc',10);

--Cocineros 10
INSERT INTO usuario VALUES('David001','David@gmail.com',12345,'Guerrero','Marquez','David','5555448844','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Haziel002','Haziel002@gmail.com',12345,'Cuevas','Mendez','Haziel','5588775522','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Pablo003','Pablo003@gmail.com',12345,'Montero','Velazquez','Pablo','5588663300','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Alejandra004','Alejandra004@gmail.com',12345,'Gomez','Sanchez','Alejandra','5544598712','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Edith005','Edith005@gmail.com',12345,'Ortega','Jimenez','Edith','5548623010','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Beatriz006','Bety006@gmail.com',12345,'Luna','Gimenez','Beatriz','5512036908','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Maria007','Maria007@gmail.com',12345,'Robles','Salazar','Maria','5510258941','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Ikery008','Iker008@gmail.com',12345,'Vargas','Rojas','Iker','5578963012','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Saul009','Saul009@gmail.com',12345,'Perez','Linares','Saul','5512986354','AV Prueba','rfc',9);
INSERT INTO usuario VALUES('Miguel010','Miguel010@gmail.com',12345,'Rivera','Herrera','Miguel','5545869520','AV Prueba','rfc',9);

--Recepcionistas 10
INSERT INTO usuario VALUES('Pedro_r0','Pedror0@gmail.com',12345,'Dominguez','Morales','Pedro','5578496315','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Cristhian_r1','Cristhianr1@gmail.com',12345,'Avila','Camacho','Crisrthian','5588552202','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Mikel_r2','Mikelr2@gmail.com',12345,'Lara','Hernanzdez','Mikel','5578496352','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Isaac_r3','Isaacr3@gmail.com',12345,'Soto','Ramirez','Isaac','5599663300','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Manuel_r4','Manuelr4@gmail.com',12345,'Silva','Delgado','Manuel','5579635412','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Jorge_r5','Jorger5@gmail.com',12345,'Rios','Cervantes','Jorge','5585468310','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Julia_r6','Juliar6@gmail.com',12345,'Espinoza','Cortes','Julia','5578964520','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Daniel_r7','Danielr7@gmail.com',12345,'Valdez','Mejia','Daniel','5556103084','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Andrea_r8','Andrear8@gmail.com',12345,'Campos','Ibarra','Andrea','5520369410','AV Prueba','rfc',8);
INSERT INTO usuario VALUES('Cesar_r9','Cesarr9@gmail.com',12345,'Solis','Fernandez','Cesar','5510203060','AV Prueba','rfc',8);

--Registros en la tabla trabajador
--Trabajadores de recepcion
INSERT INTO trabajador VALUES(46,6800);
INSERT INTO trabajador VALUES(47,6800);
INSERT INTO trabajador VALUES(48,6800);
INSERT INTO trabajador VALUES(49,6800);
INSERT INTO trabajador VALUES(50,6800);
INSERT INTO trabajador VALUES(51,6800);
INSERT INTO trabajador VALUES(52,6800);
INSERT INTO trabajador VALUES(53,6800);
INSERT INTO trabajador VALUES(54,6800);
INSERT INTO trabajador VALUES(55,6800);
--Trabajadores de cocina
INSERT INTO trabajador VALUES(36,6000);
INSERT INTO trabajador VALUES(37,6000);
INSERT INTO trabajador VALUES(38,6000);
INSERT INTO trabajador VALUES(39,6000);
INSERT INTO trabajador VALUES(40,6000);
INSERT INTO trabajador VALUES(41,6000);
INSERT INTO trabajador VALUES(42,6000);
INSERT INTO trabajador VALUES(43,6000);
INSERT INTO trabajador VALUES(44,6000);
INSERT INTO trabajador VALUES(45,6000);
--Trabajadores de limpieza
INSERT INTO trabajador VALUES(16,5500);
INSERT INTO trabajador VALUES(17,5500);
INSERT INTO trabajador VALUES(18,5500);
INSERT INTO trabajador VALUES(19,5500);
INSERT INTO trabajador VALUES(20,5500);
INSERT INTO trabajador VALUES(21,5500);
INSERT INTO trabajador VALUES(22,5500);
INSERT INTO trabajador VALUES(23,5500);
INSERT INTO trabajador VALUES(24,5500);
INSERT INTO trabajador VALUES(25,5500);
INSERT INTO trabajador VALUES(26,5500);
INSERT INTO trabajador VALUES(27,5500);
INSERT INTO trabajador VALUES(28,5500);
INSERT INTO trabajador VALUES(29,5500);
INSERT INTO trabajador VALUES(30,5500);
INSERT INTO trabajador VALUES(31,5500);
INSERT INTO trabajador VALUES(32,5500);
INSERT INTO trabajador VALUES(33,5500);
INSERT INTO trabajador VALUES(34,5500);
INSERT INTO trabajador VALUES(35,5500);


--REGISTROS EN LA TABLA reservacion
--(id_cliente,id_habitacion,fecha_inicio,fecha_fin)
INSERT INTO reservacion VALUES(5,20,2323,2323)
INSERT INTO reservacion VALUES(5,30,2323,2323)