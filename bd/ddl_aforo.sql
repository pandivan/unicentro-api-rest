/*
CREATE SCHEMA referencial;
CREATE SCHEMA dimension;
CREATE SCHEMA hechos;
CREATE SCHEMA sisbol;


drop SCHEMA referencial;
drop SCHEMA dimension;
drop SCHEMA hechos; 
drop SCHEMA sisbol; 
*/



drop table hechos.aforo;
drop table hechos.visita;
drop table dimension.cliente;
drop table dimension.barrio;
--drop table dimension.tiempo;
drop table dimension.estado;
drop table dimension.geografia;





create table dimension.estado
(
id_estado bigserial not null,
descripcion varchar(255) NULL,
primary key (id_estado)
);






create table dimension.geografia
(
id_geografia bigserial not null,
id_pais varchar(2) not null,
pais varchar(50) not null,
departamento varchar(50) not null,
ciudad varchar(50) not null,
primary key (id_geografia)
);





/*
create table dimension.tiempo
(
id_tiempo integer not null,
fecha date not null,
año smallint not null,
semestre smallint not null,
trimestre smallint not null,
mes smallint not null,
mes_nombre varchar(10) null,
semana smallint not null,
dia_semana varchar(10) null,
fecha_inicio_año date not null,
fecha_fin_año date not null,
fecha_inicio_semestre date not null,
fecha_fin_semestre date not null,
fecha_inicio_trimestre date not null,
fecha_fin_trimestre date not null,
fecha_inicio_mes date not null,
fecha_fin_mes date not null,
fecha_inicio_semana date not null,
fecha_fin_semana date not null,
primary key (id_tiempo)
);
*/



create table dimension.barrio
(
id_barrio bigserial not null,
nombre varchar(255) not null,
primary key (id_barrio)
);




create table dimension.cliente
(
id_cliente bigserial not null,
id_geografia bigint null,
id_barrio bigint null,
id_tiempo_fecha_creacion integer DEFAULT cast(to_char(NOW()::timestamp, 'YYYYMMDD') as integer) not null,
cedula varchar(20) null,
nombre varchar(255) not null,
telefono varchar(50) not null,
direccion varchar(255) null,
email varchar(100) null,
fecha_nacimiento date null,
sexo varchar(1) not null,
tipo_cliente varchar(10) not null,
password varchar(255) null,
barrio varchar(255) null,
estado smallint default 1 not null,
primary key (id_cliente)
);

ALTER TABLE dimension.cliente ADD CONSTRAINT cliente_barrio_fk FOREIGN KEY (id_barrio) REFERENCES dimension.barrio (id_barrio);
ALTER TABLE dimension.cliente ADD CONSTRAINT cliente_tiempo_fk FOREIGN KEY (id_tiempo_fecha_creacion) REFERENCES dimension.tiempo (id_tiempo);
ALTER TABLE dimension.cliente ADD CONSTRAINT cliente_geografia_fk FOREIGN KEY (id_geografia) REFERENCES dimension.geografia (id_geografia);





create table hechos.visita
(
id_visita bigserial not null,
id_cliente bigint not null,
id_tienda bigint not null,
id_tiempo integer DEFAULT cast(to_char(now(), 'YYYYMMDD') as integer) not null,
temperatura numeric(4,2) not null,
fecha_visita TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP not null,
primary key (id_visita)
);


ALTER TABLE hechos.visita ADD CONSTRAINT visita_cliente_fk FOREIGN KEY (id_cliente) REFERENCES dimension.cliente (id_cliente);
ALTER TABLE hechos.visita ADD CONSTRAINT visita_tienda_fk  FOREIGN KEY (id_cliente) REFERENCES dimension.cliente (id_cliente);
ALTER TABLE hechos.visita ADD CONSTRAINT visita_tiempo_fk  FOREIGN KEY (id_tiempo) REFERENCES dimension.tiempo (id_tiempo);




create table hechos.aforo
(
id_aforo bigserial not null,
fecha_ingreso TIMESTAMP WITH TIME ZONE null,
fecha_salida TIMESTAMP WITH TIME ZONE null,
primary key (id_aforo)
);







SET timezone TO 'America/Bogota';



commit;





insert into dimension.geografia(id_pais,pais,departamento,ciudad) values('CO','Colombia','Nariño','Pasto');
insert into dimension.barrio(nombre) values('Valle de Lili');
insert into dimension.cliente (id_geografia,id_tiempo_fecha_creacion,cedula,nombre,password,direccion,telefono, email, tipo_cliente, sexo, id_barrio, barrio ) values(1,20200701,'900.317.814-5','unicentro','1234','Calle 11 Nº 34-78 Barrio La Aurora de Pasto','3104709828', 'unicentro@unicentro.com', 'tienda', 'M', 1, 'Valle de Lili');
insert into dimension.estado(id_estado, descripcion) values(100, 'PENDIENTE');
insert into dimension.estado(id_estado, descripcion) values(101, 'ACEPTADO');
insert into dimension.estado(id_estado, descripcion) values(102, 'CANCELADO');
insert into dimension.estado(id_estado, descripcion) values(103, 'ACTIVO');
insert into dimension.estado(id_estado, descripcion) values(104, 'INACTIVO');
insert into dimension.estado(id_estado, descripcion) values(105, 'DESPACHADO');
commit;



--insert into dimension.aforo(fecha_ingreso) values(TIMESTAMP '2011-05-16 15:36:38');
--insert into dimension.aforo(fecha_salida) values(TIMESTAMP '2011-05-16 16:36:38');

commit;



