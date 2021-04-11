create table hechos.aforo
(
id_aforo bigserial not null,
fecha_ingreso TIMESTAMP WITH TIME ZONE null,
fecha_salida TIMESTAMP WITH TIME ZONE null,
primary key (id_aforo)
);



SET timezone TO 'America/Bogota';



select * 
from hechos.aforo 
where id_aforo >= 1678083
order by 1 desc
;

--delete 
--from hechos.aforo 
--where id_aforo >= 1678017
--;

select count(1), max(id_aforo), min(id_aforo), max(fecha_ingreso), min(fecha_ingreso) from hechos.aforo;



select ingreso, salida, (ingreso - salida) aforo, (ingreso + salida) total
from 
(
	select 
	(
		select count(1)
		from hechos.aforo
		where fecha_ingreso is not null and fecha_ingreso >= CURRENT_DATE
	) ingreso,
	(
		select count(1)
		from hechos.aforo
		where fecha_salida is not null and fecha_salida >= CURRENT_DATE
	) salida
) tabla
;

select count(1)
from hechos.aforo
where fecha_ingreso is not null and fecha_ingreso >= CURRENT_DATE;


CREATE INDEX aforo_fecha_ingreso_idx ON hechos.aforo (fecha_ingreso);

CREATE INDEX aforo_fecha_salida_idx ON hechos.aforo (fecha_salida);








/************************************************************************************
 * CAMPAÑAS QLIK
 ************************************************************************************/


select * from sisbol.campania;

11 "Entrega de Bolsos Reciclados Disponibilidad hasta agotar existencias"
13 Raspa y Gana
12 ENTREGA DE BOLSOS ECOLÓGICOS POR COMPRAS



--DIMENSION CAMPAÑA
select id_camp as campañas, nombre_camp as campaña, numpersonas_camp as numero_personas, valor_camp as valor, fechafin_camp as fecha_campaña
from sisbol.campania
;


--DIMENSION BARRIO
select id_barrio as barrios, comuna_bar as comuna, nombre_bar barrio
from sisbol.barrio
;



--DIMENSION CATEGORIAS
select codi_tip as categorias, desc_tip as categoria
from sisbol.vw_categoria
;



--DIMENSION LOCALES
select * --codi_tip as locales, desc_tip as local
from sisbol.tipo
where codi_gru = '03'
and valo_tip is not null
;



--DIMENSION CLIENTE
SELECT 
c.codi_cli as clientes, 
c.nrod_cli as numero_documento, 
tp.desc_tip as tipo_documento, 
c.nomb_cli as nombre_cliente, 
c.apel_cli as apellido_cliente, 
c.dire_cli as direccion_cliente, 
c.tele_cli as telefono_cliente, 
c.emai_cli as mail_cliente, 
case c.sexo_cli WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Femenino' ELSE 'NA' end as sexo_cliente,
c.fnac_cli as fecha_nacimiento
FROM sisbol.cliente c
inner join sisbol.tipo tp on tp.codi_tip = c.tpid_cli
where 1=1
and c.codi_cli in ('57451','48592')
;


select *
from sisbol.boleta b
where b.id_camp = 9
;

select 
--count(1) 
--count(distinct b.codi_cli )
from sisbol.compra c 
where c.codi_bol in (select codi_bol from sisbol.boleta where id_camp = 7)
--and c.loca_com is null
;



select * from sisbol.tipo t where t.codi_tip = '02001';

select hc.*
--count(1) 
--count(distinct b.codi_cli )
FROM sisbol.compra hc
inner join sisbol.boleta b on b.codi_bol = hc.codi_bol and b.anul_bol <> 'S' 
inner join sisbol.campania cam on cam.id_camp = b.id_camp 
inner join sisbol.cliente c on c.codi_cli = b.codi_cli
inner join sisbol.barrio ba on ba.id_barrio = c.id_barrio 
inner join sisbol.tipo t on t.codi_tip = hc.loca_com 
where hc.codi_bol in (select codi_bol from sisbol.boleta where id_camp = 7)
order by 5
;


--HECHOS COMPRA
select 
--count(1)  
count(distinct b.codi_cli)
--distinct hc.fech_com, valo_com 
/*hc.codi_com as compras, 
cam.id_camp as campañas,  
ba.id_barrio as barrios, 
cate.codi_tip as categorias, 
hc.loca_com as locales, 
c.codi_cli as clientes, 
hc.valo_com as valor_compra, 
hc.fech_com as fecha_compra*/
FROM sisbol.compra hc
inner join sisbol.boleta b on b.codi_bol = hc.codi_bol and b.anul_bol <> 'S' 
inner join sisbol.campania cam on cam.id_camp = b.id_camp 
inner join sisbol.cliente c on c.codi_cli = b.codi_cli
inner join sisbol.barrio ba on ba.id_barrio = c.id_barrio 
inner join sisbol.tipo t on t.codi_tip = hc.loca_com 
inner join sisbol.vw_categoria cate on cate.codi_tip = t.valo_tip 
where cam.id_camp in (7)
--and c.codi_cli in ('57451','48592')
and date_trunc('day', hc.fech_com) between TO_DATE('20191201','YYYYMMDD') and TO_DATE('20191201','YYYYMMDD')
and cate.codi_tip = '05017'
order by 1
;






/************************************************************************************
 * VALIDACION DATA
 ************************************************************************************/

6503 clientes 6	junio 	7	Campaña Noviembre
4743 clientes 8	Campaña Diciembre
246	 clientes 9	PAPÁ NOEL SE MUDÓ A UNICENTRO PASTO


--CLIENTES NUEVOS
select COUNT(distinct c.codi_cli)
FROM sisbol.compra hc
inner join sisbol.boleta b on b.codi_bol = hc.codi_bol and b.anul_bol <> 'S' 
inner join sisbol.campania cam on cam.id_camp = b.id_camp 
inner join sisbol.cliente c on c.codi_cli = b.codi_cli
inner join sisbol.barrio ba on ba.id_barrio = c.id_barrio 
inner join sisbol.tipo t on t.codi_tip = hc.loca_com 
inner join sisbol.vw_categoria cate on cate.codi_tip = t.valo_tip 
where cam.id_camp = 8
and c.codi_cli not in 
(
select distinct c.codi_cli 
FROM sisbol.compra hc
inner join sisbol.boleta b on b.codi_bol = hc.codi_bol and b.anul_bol <> 'S' 
inner join sisbol.campania cam on cam.id_camp = b.id_camp 
inner join sisbol.cliente c on c.codi_cli = b.codi_cli
inner join sisbol.barrio ba on ba.id_barrio = c.id_barrio 
inner join sisbol.tipo t on t.codi_tip = hc.loca_com 
inner join sisbol.vw_categoria cate on cate.codi_tip = t.valo_tip 
where cam.id_camp in (7)
)
;



--CLIENTES PERDIDOS
select distinct c.nrod_cli, c.nomb_cli, catee.codi_tip, catee.desc_tip, cam.nombre_camp --COUNT(distinct c.codi_cli)
FROM sisbol.compra hc
inner join sisbol.boleta b on b.codi_bol = hc.codi_bol and b.anul_bol <> 'S' 
inner join sisbol.campania cam on cam.id_camp = b.id_camp 
inner join sisbol.cliente c on c.codi_cli = b.codi_cli
inner join sisbol.barrio ba on ba.id_barrio = c.id_barrio 
inner join sisbol.tipo t on t.codi_tip = hc.loca_com 
inner join sisbol.vw_categoria catee on catee.codi_tip = t.valo_tip 
where 1=1
and cam.id_camp = 7
and catee.codi_tip = '05019'
and c.codi_cli not in 
(
	select distinct c.codi_cli 
	FROM sisbol.compra hc
	inner join sisbol.boleta b on b.codi_bol = hc.codi_bol and b.anul_bol <> 'S' 
	inner join sisbol.campania cam on cam.id_camp = b.id_camp 
	inner join sisbol.cliente c on c.codi_cli = b.codi_cli
	inner join sisbol.barrio ba on ba.id_barrio = c.id_barrio 
	inner join sisbol.tipo t on t.codi_tip = hc.loca_com 
	inner join sisbol.vw_categoria cate on cate.codi_tip = t.valo_tip 
	where 1=1
	and cam.id_camp = 8
	--and date_trunc('day', hc.fech_com) between TO_DATE('20191201','YYYYMMDD') and TO_DATE('20191201','YYYYMMDD')
	--and cate.codi_tip = '05017'
	--and c.nrod_cli in ('13005784')
)
--and date_trunc('day', hc.fech_com) between TO_DATE('20191201','YYYYMMDD') and TO_DATE('20191201','YYYYMMDD')
--and c.nrod_cli in ('13005784')
;


--CLIENTES FIDELIZADOS
select COUNT(distinct c.codi_cli)
FROM sisbol.compra hc
inner join sisbol.boleta b on b.codi_bol = hc.codi_bol and b.anul_bol <> 'S' 
inner join sisbol.campania cam on cam.id_camp = b.id_camp 
inner join sisbol.cliente c on c.codi_cli = b.codi_cli
inner join sisbol.barrio ba on ba.id_barrio = c.id_barrio 
inner join sisbol.tipo t on t.codi_tip = hc.loca_com 
inner join sisbol.vw_categoria cate on cate.codi_tip = t.valo_tip 
where 1=1
and cam.id_camp in (7)
and c.codi_cli in 
(
select distinct c.codi_cli 
FROM sisbol.compra hc
inner join sisbol.boleta b on b.codi_bol = hc.codi_bol and b.anul_bol <> 'S' 
inner join sisbol.campania cam on cam.id_camp = b.id_camp 
inner join sisbol.cliente c on c.codi_cli = b.codi_cli
inner join sisbol.barrio ba on ba.id_barrio = c.id_barrio 
inner join sisbol.tipo t on t.codi_tip = hc.loca_com 
inner join sisbol.vw_categoria cate on cate.codi_tip = t.valo_tip 
where 1=1
and cam.id_camp = 8
--and c.nrod_cli in ('30712024','13005784')
)
--and c.nrod_cli in ('30712024','13005784')
;



select hc.* FROM sisbol.compra hc 
where 1=1
--and hc.codi_bol = '12693'
and date_trunc('day', hc.fech_com) between TO_DATE('20201001','YYYYMMDD') and TO_DATE('20201031','YYYYMMDD')
;

select * -- sum(case p.total WHEN 0 THEN p.total_convenio ELSE p.total end) as valor
from hechos.parking p
where date_trunc('day', p.fecha_factura) between TO_DATE('20201001','YYYYMMDD') and TO_DATE('20201001','YYYYMMDD')
;




select *
FROM hechos.aforo 
where date_trunc('day', fecha_ingreso) between TO_DATE('20201001','YYYYMMDD') and TO_DATE('20201001','YYYYMMDD')
;



select * FROM sisbol.boleta where codi_bol = '12693';

select * FROM sisbol.cliente where codi_cli = '48592';

select * FROM sisbol.barrio where id_barrio = 561;

select * FROM sisbol.campania order by 1;--where id_camp = 7;

select * from sisbol.tipo where codi_gru = '03' and valo_tip is not null and codi_tip in ('03027','03077','03071');

select * from sisbol.vw_categoria where codi_tip in ('05015');








/************************************************************************************
 * ACTUALIZACION DATA
 ************************************************************************************/

select * from  sisbol.cliente where id_barrio is null;

select * 
from sisbol.compra c 
where c.loca_com is null
;

select * from sisbol.campania c order by 1;

delete from sisbol.campania c where c.id_camp = 10;

update sisbol.compra set loca_com = '03113' where loca_com is null;


select * from sisbol.boleta where id_camp = 10;

update sisbol.boleta set id_camp = 8 where id_camp = 10;












/********************************************************************************************************************************
PARKING
********************************************************************************************************************************/

select 
--count(1), id_billing 
--p.id_billing, p.dispositivo_pago, p.punto_pago, p.consola_ing as entrada, p.fecha_factura, (p.minutos_facturados / 60) as horas_facturadas, 
--p.minutos_facturados, case p.total WHEN 0 THEN p.total_convenio ELSE p.total end as total, 
--p.tarifa, case when 0 != position('bicicleta' in lower(p.tarifa)) then 'BICICLETA' else upper(p.zona) end zona, p.placa2
* 
from hechos.parking p 
where 1=1
--and p.id_billing = 1598974311448
--and p.total > 2800
--and p.placa2 is null 
--and p.tarifa like '%Perno%'
--group by id_billing having count(1) > 1;

;


select 
      p.id_billing as cantidad, 
      p.punto_pago, 
      p.consola_ing as entrada, 
      p.fecha_factura as fecha_ingreso, 
      case when 0 != p.minutos_facturados then (p.minutos_facturados / 60) else 0 end as horas, 
      p.minutos_facturados as minutos, 
      case p.total WHEN 0 THEN p.total_convenio ELSE p.total end as valor, 
      p.tarifa as descripcion, 
      case when 0 != position('bicicleta' in lower(p.tarifa)) then 'BICICLETA' else upper(p.zona) end tipos_vehiculo, 
      p.placa2 as vehiculo,
      case when p.minutos_facturados <= 60 then 1 when (p.minutos_facturados > 60 and p.minutos_facturados <= 120) then 2 when (p.minutos_facturados > 120 and p.minutos_facturados <= 180) then 3 
      when (p.minutos_facturados > 180 and p.minutos_facturados <= 240) then 4 else 5 end as rango
from hechos.parking p
where 1=1
and p.fecha_factura >= (current_date) 
--and p.tarifa = 'Salida Parqueadero'
--and p.placa2 in ('KIB787')
--and p.minutos_facturados is null
--and p.punto_pago = 'PQ3'
order by p.total, p.punto_pago desc
;




--select minutos_facturados 
update hechos.parking set 
fecha_factura = '2020-12-01 00:30:00'
--minutos_facturados = 240,
--total = 2800,
--punto_pago = null
--fecha_factura = (current_date+1)
where id_billing in (1010)
;


SELECT
id_aforo as personas,
fecha_ingreso,
fecha_salida
FROM hechos.aforo 
where id_aforo = 11354
;





