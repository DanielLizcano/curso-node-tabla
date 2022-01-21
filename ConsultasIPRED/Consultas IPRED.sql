/* Consultar el número de horas teórico prácticas de las 
 *//*asignaturas(asignaturas) en comparación a las horas 
 *programas (asignatura_actividades). -------------------------------------------------------------------------------------------------------*/
select * from asignaturas where horas_teorico_practicas <> '0'

group by codigo_asignatura 

select * from asignatura_actividades where horas_teorico_practicas <> '0'

select horas_teorico_practicas from asignaturas
/*PUNTO 1*/

/*este es el bueno METODO 1*/
select a.codigo_asignatura, a.nombre_asignatura, a.horas_teorico_practicas, sum(b.duracion_horas) as duracion_horas 
from asignatura_actividades b, asignaturas a
where a.horas_teorico_practicas <>'0' and a.codigo_asignatura = b.codigo_asignatura
group by a.codigo_asignatura, b.codigo_asignatura 

/*este es el bueno METODO 2*/
select a.codigo_asignatura, a.nombre_asignatura, a.horas_teorico_practicas, sum(b.duracion_horas) as duracion_horas 
from asignatura_actividades b, asignaturas a
where a.codigo_asignatura = b.codigo_asignatura
group by a.codigo_asignatura, b.codigo_asignatura 
having a.horas_teorico_practicas <>'0'

/*este es el bueno METODO 3 SIN <> '0'*/
select a.codigo_asignatura, a.nombre_asignatura, a.horas_teorico_practicas, sum(b.duracion_horas) as duracion_horas 
from asignatura_actividades b, asignaturas a
where a.codigo_asignatura = b.codigo_asignatura
group by a.codigo_asignatura
/* -------------------------------------------------------------------------------------------------------*/

/*PUNTO 2 -------------------------------------------------------------------------------------------------------*/
/*Realizar una consulta que me traiga por asignatura y grupo, la cantidad de horas teóricas, 
 teórico prácticas, practicas, la fecha inicio de nombramiento y la fecha fin de nombramiento 
 del profesor para ese grupo, e identificar cada fila de la consulta con un id construido por 
 la concatenación de código asignatura y grupo; recuerda tener en cuenta las tablas de grupos_actividades, 
 programa_sede_asignatura_grupos y asignaturas.*/
select ga.codigo_asignatura,
	      			ga.grupo,
	      			concat(ga.codigo_asignatura,ga.grupo) as ID,
	      			a.horas_teoricas,
	      			a.horas_practicas,
	      			a.horas_teorico_practicas,
	      			psag.fecha_inicio_nombramiento,
	      			psag.fecha_fin_nombramiento
	      from grupos_actividades ga
	      left join asignaturas a on (ga.codigo_asignatura=a.codigo_asignatura)
	      left join programa_sede_asignatura_grupos psag  on 
	      			(psag.codigo_asignatura,psag.grupo,psag.id_semestre,psag.profesor_documento_identidad) = 
	      			(ga.codigo_asignatura,ga.grupo,ga.id_semestre,ga.profesor_documento_identidad)
	      where ga.codigo_asignatura != 0
/* -------------------------------------------------------------------------------------------------------*/


/*CONSULTA Y UPDATE PARA ELIMINAR ESPACION EN BLANCO AL FINAL Y AL INICIO DE LOS DOCUMENTOS DE IDENTIDAD DE LA TABLA PERSONAS*/
select * from persona where documento_identidad like '% ' or documento_identidad like' % '
update persona set documento_identidad = rtrim (documento_identidad);
select * from persona p 
SELECT * FROM asignaturas
/* -------------------------------------------------------------------------------------------------------*/

/*CONSULTA PARA VERIFICAR NUEVOS CODIGOS DE EL PLAN DE ESTUDIO 71 DE GERENCIA*/
SELECT * FROM asignaturas where codigo_asignatura in ('29666',
'29667',
'29668',
'29669',
'29670',
'29671',
'29672',
'29673',
'29674',
'29675',
'29676',
'29677',
'29679',
'29680',
'29681',
'29682',
'29683',
'29684',
'29685',
'29686',
'29687',
'29689',
'29690',
'29691',
'29692',
'29678',
'29693'
)
/* -------------------------------------------------------------------------------------------------------*/

/*CONSULTA PARA VISUALIZAR LOD DATOS PERSONALES DE LOS PROFESORES ASIGNADOS AL SEMESTRE 2019-2, VISUALIZAR SU PROGRAMA, GRUPO Y UBICACION DE RESIDENCIA*/
select pr.documento_identidad,
			p.primer_nombre, 
			p.segundo_nombre, 
			p.primer_apellido, 
			p.segundo_apellido,
			/*ppsag.id_semestre,*/ 
			/*ppsag.decision,*/
			a.codigo_asignatura, 
			a.nombre_asignatura,
			ppsag.grupo,
			s.nombre as sede,
			pa.nombre as programa_academico,
			pa.codigo as codigo_programa,
			m.nombre as mun_res_profesor,
			d.nombre as dep_res_profesor
			
from proy_programa_sede_asignatura_grupos ppsag
join profesor pr on (pr.documento_identidad=ppsag.profesor_documento_identidad)
left join persona p on (p.documento_identidad=ppsag.profesor_documento_identidad)
left join asignaturas a on (a.codigo_asignatura=ppsag.codigo_asignatura)
left join sede s on (s.codigo=ppsag.codigo_sede)
left join programa_academico pa on (pa.codigo=ppsag.codigo_programa)
left join municipio m on (m.id=p.id_municipio)
left join departamento d on (d.id=m.id_departamento)
where ppsag.id_semestre = 20192
and ppsag.decision = 'true'
/* -------------------------------------------------------------------------------------------------------*/
/*CONSULTA Y UPDATE PARA NORMALIZAR LOS CARACTERES DE LOS NOMBRES DE LA TALBA PERSONA. CRITERIO:PRIMERA LETRA MAYUSCULA Y EL RESTO EN MINUSCULA EN CADA CAMPO, ADEMAS DE ELIMINAR ACENTOS (TILDES)*/
CREATE EXTENSION unaccent;
select * from persona p  where documento_identidad ='1005177716'
/*13180 usuarios*/
update persona set primer_nombre = 
(select unaccent(concat((select substring(primer_nombre from 0 for 2)), (select lower(substring(primer_nombre from 2 for (select char_length(primer_nombre)))))))) where documento_identidad = '1005177716'

update persona set primer_nombre = 
(select unaccent(concat((select substring(primer_nombre from 0 for 2)), (select lower(substring(primer_nombre from 2 for (select char_length(primer_nombre))))))))

update persona set segundo_nombre = 
(select unaccent(concat((select substring(segundo_nombre from 0 for 2)), (select lower(substring(segundo_nombre from 2 for (select char_length(segundo_nombre))))))))

update persona set primer_apellido = 
(select unaccent(concat((select substring(primer_apellido from 0 for 2)), (select lower(substring(primer_apellido from 2 for (select char_length(primer_apellido))))))))

update persona set segundo_apellido = 
(select unaccent(concat((select substring(segundo_apellido from 0 for 2)), (select lower(substring(segundo_apellido from 2 for (select char_length(segundo_apellido))))))))
/* -------------------------------------------------------------------------------------------------------*/




/*CREAR UNA TABLA NUEVA PARA ALMACENAR CUANDO SE ACTUALICE UN PROFESOR, GUARDAR UNICAMENTE LA FECHA EN QUE SE HIZO EL REGISTRO Y EL USUARIO QUE LO REALIZO.*/
/*SE CREA LA FUNCION QUE EJECUTA EL TRIGER  -------------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION public.punto4()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$DECLARE
BEGIN
  IF(TG_OP = 'INSERT')then
           /*'aud_Punto4': NOMBRE DE LA TABLA DESTINO HACIA DONDE SE DIRIGEN LOS REGISTROS DE LA AUDITORIA */
INSERT INTO aud_Punto4(
            usuario, fecha)
            /*EN 'VALUES' SE INGRESAN LOS VALORES CON LOS CUALES SE DESEA LLENAR LA NUEVA TABLA, SI SE DESEARA LLENAR UNA TABLA ENTERA SE HARIA: 
             * (VALUES (user, current_timestamp, (NEW.* Ó OLD.*) DEPENDIENDO DE LA INSTRUCCION 'INSERT' 'DELETE' O 'UPDATE' )*/
	VALUES (user, current_timestamp);
ELSIF (TG_OP = 'UPDATE')THEN
INSERT INTO aud_Punto4(
            usuario, fecha)
	VALUES (user, current_timestamp);return new;

ELSIF (TG_OP = 'DELETE')THEN
INSERT INTO aud_Punto4(
            usuario, fecha)
	VALUES (user, current_timestamp);return old;
END IF;
return new;
END;
$function$
;
/* -------------------------------------------------------------------------------------------------------*/

/*SE CREAN LOS TRIGGER  -------------------------------------------------------------------------------------------------------*/
			/*EL NOMBRE DE LOS TRIGGER ES INDEPENDIENTE PERO ES BUENO CONSERVARLO*/
create trigger punto4 after
insert
    or
delete
    or
update
    on
    /*public.profesor: ES LA TABLA DE DONDE PROVIENEN LOS DATOS CON LOS CUALES SE DESEA LLENAR LA AUDITORIO O RESPALDO*/
    public.profesor for each row execute function punto4();
/* -------------------------------------------------------------------------------------------------------*/
   
   
/*SE CREA LA TALBA DESTINO DE LA AUDITORIA UNICAMENTE CON CAMPOS 'Ususario' Y 'Fecha' 4*/
CREATE TABLE public.aud_punto4(
	usuario varchar(200) NULL,
	fecha timestamp NULL
);
/* -------------------------------------------------------------------------------------------------------*/

/*CONSULTA PARA VISUALIZAR CUANTOS GRUPOS SE ABRIERON PARA EL 2019-2 Y LA SEDE EN EL CUAL ESTAN ASIGNADOS DICHOS CURSOS*/
select pa.nombre as programa, s.nombre as sede, count(distinct(grupo)) as grupos_abiertos
from proy_programa_sede_asignatura_grupos ppsag
left join programa_academico pa on (pa.codigo=ppsag.codigo_programa)
left join sede s on (s.codigo=ppsag.codigo_sede)
where ppsag.id_semestre = 20192
and ppsag.decision = 'true'
/*and ppsag.codigo_programa =70*/
group by pa.nombre, s.nombre
/* -------------------------------------------------------------------------------------------------------*/

/*CONSULTA Y UPDATE PARA NORMALIZAR LOS CARACTERES DE LOS NOMBRES DE LA TALBA PERSONA. CRITERIO:PRIMERA LETRA MAYUSCULA Y EL RESTO EN MINUSCULA EN CADA CAMPO, ADEMAS DE ELIMINAR ACENTOS (TILDES)*/
CREATE EXTENSION unaccent;
select * from persona p  where documento_identidad ='1005177716'
/*13180 usuarios*/
update persona set primer_nombre = 
(select unaccent(concat((select substring(primer_nombre from 0 for 2)), (select lower(substring(primer_nombre from 2 for (select char_length(primer_nombre)))))))) where documento_identidad = '1005177716'

update persona set primer_nombre = 
(select unaccent(concat((select substring(primer_nombre from 0 for 2)), (select lower(substring(primer_nombre from 2 for (select char_length(primer_nombre))))))))

update persona set segundo_nombre = 
(select unaccent(concat((select substring(segundo_nombre from 0 for 2)), (select lower(substring(segundo_nombre from 2 for (select char_length(segundo_nombre))))))))

update persona set primer_apellido = 
(select unaccent(concat((select substring(primer_apellido from 0 for 2)), (select lower(substring(primer_apellido from 2 for (select char_length(primer_apellido))))))))

update persona set segundo_apellido = 
(select unaccent(concat((select substring(segundo_apellido from 0 for 2)), (select lower(substring(segundo_apellido from 2 for (select char_length(segundo_apellido))))))))
/* -------------------------------------------------------------------------------------------------------*/


/* Recuperacion de registros de p´rofesor_sede_asignaturas*/
insert into programa_sede_asignatura_profesor 
select codigo_programa, codigo_sede, codigo_asignatura, documento_profesor, id_tipo_contratacion, resolucion_banco_elegibles_id from aud_programa_sede_asignatura_profesor apsap 
where fecha::varchar like '2021-11-30%' and operacion = 'DELETE' and (codigo_programa,codigo_sede,codigo_asignatura,documento_profesor,resolucion_banco_elegibles_id) 
not in (select codigo_programa,codigo_sede,codigo_asignatura,documento_profesor,resolucion_banco_elegibles_id from programa_sede_asignatura_profesor psap2)
select * from programa_sede_asignatura_profesor psap

/*controllerCronograma*/
select a.codigo_asignatura, a.nombre_asignatura from asignaturas_plan ap
join asignaturas a on a.codigo_asignatura = ap.codigo_asignatura 
join programa_academico pa on ap.codigo_plan = pa.id_plan_estudio_activo
and ap.codigo_programa = pa.codigo 
where pa.codigo = :codigo_programa 



/*INSERT para fechas especiales calses profesores ipred presencial, se hizo ocn ayuda de una falsa consulta para traer los datos, falta automatizacion en caso de mas fechas*/
/*Fecha 26 feb*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-02-26'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 23 feb*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-02-23'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 2 marzo*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-03-02'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 5 marzo*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-03-05'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 10 marzo*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-03-10'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 12 marzo*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-03-12'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 4 junio*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-06-04'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 16 junio*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-06-16'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 11 junio*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-06-11'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 8 junio*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-06-08'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 18 junio*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-06-18'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)

/*Fecha 31 mayo*/
insert into horario_profesor_fechas_especiales (fecha ,profesor_documento_identidad, semestre_academico_id, tipo)
(select distinct '2022-05-31'::date, profesor_documento_identidad, id_semestre, 'clase_presencial' from proy_programa_sede_asignatura_grupos psag where id_semestre = 20221)


/*CONSULTA PARA ELIMINAR LOS PUNTOS DE LAS CEDULAS DE PERSONAS, ASI DIRECTAMENTE SE EDITA DENTRO DE PROFESORES Y ESTUDIANTES: EJEMPLO 14.253.254 QUEDARIA 14253254 YA QUE ES UN CAMPO DE TEXTO*/
update persona set documento_identidad = regexp_replace(documento_identidad, '[^0-9]+', '', 'g')


/*DISTINGUIR POR 3 PARAMETROS, SEDE=23 PARA BARBOSA Y JORNADA = 3, PARA PRESENCIAL JORNADA = 3 Y SEDE = 10, DISTANCIAIPRED JORNADA = 1 Y 2 */
select * from legalizacion_matricula lm
join programa_acad_est pae on lm.codigo_programa = pae.codigo_programa and lm.sede_estudiante = pae.codigo_sede and lm.codigo_estudiante = pae.codigo_estudiante 
where lm.id_semestre = 20212 and pae.codigo_jornada in (1,2)

/*DESDE EL ACCESO REMOTO EN LAS BASES DE DATOS PRESENCIAL SE HACE LA CONSULTA PARA FILTRAR 
LOS SEMESTRES QUE HAN PERMANECIDO ESTUDIANDO EN LA UNIVERSIDAD, LA CONSULTA DEVUELVE NOMBRES Y APELLIDO
CODIGO DEL PROGRAMA CODIGO DEL ESTUDIANTE*/
select * from insed001.datos_periodo_est dp 
where dp.ano_academico=2021
and dp.periodo_acad=2
/*por cada estudiante en cada programa cuantos semestre a cursado a al fecha, añoperiodo academico, */
select dp.codigo_est, 
				dp.programa_academico,
				dp2.primer_nombre,
                 dp2.segundo_nombre,
                 dp2.primer_apellido,
                 dp2.segundo_apellido, 
                 dp2.doc_ident_est,
                 
               count(dp.codigo_est)as semestrescursados from insed001.datos_periodo_est dp 
join insed001.datos_personal_est dp2 on (dp2.codigo_est=dp.codigo_est)
where dp.ano_academico>=2016
group by dp.codigo_est, dp.programa_academico, dp2.primer_nombre,
                 dp2.segundo_nombre,
                 dp2.primer_apellido,
                 dp2.segundo_apellido, 
                 dp2.doc_ident_est
order by dp.codigo_est

select * from insed001.datos_periodo_est dp where codigo_est = 2065454
select * from insed001.datos_personal_est


select m.codigo_est, 
				m.programa_academico,
				m.ano_matric,
				m.periodo_matric,
				count(m.codigo_est)as matriculas,
				dp2.primer_nombre,
                 dp2.segundo_nombre,
                 dp2.primer_apellido,
                 dp2.segundo_apellido, 
                 dp2.doc_ident_est
                 
                from insed001.matriculas m 
join insed001.datos_personal_est dp2 on (m.codigo_est=dp2.codigo_est)
where ano_matric=2021 and periodo_matric in (1,2)
group by m.codigo_est, m.programa_academico, 
				dp2.primer_nombre,
                 dp2.segundo_nombre,
                 dp2.primer_apellido,
                 dp2.segundo_apellido, 
                 dp2.doc_ident_est,
                 m.ano_matric,
				m.periodo_matric
order by m.codigo_est
/*CERTIFICADO SSL*/
/*https://www.youtube.com/watch?v=rfo_7J_0MGw&t=735s&ab_channel=AlbertCoronado*/

select m.codigo_est, m.programa_academico, 
count(distinct (m.ano_matric||m.periodo_matric)) as matriculas,
				dp2.primer_nombre,
                 dp2.segundo_nombre,
                 dp2.primer_apellido,
                 dp2.segundo_apellido, 
                 dp2.doc_ident_est
             
from insed001.matriculas m
join insed001.datos_personal_est dp2 on (m.codigo_est=dp2.codigo_est)
where m.ano_matric>=2018
and m.periodo_matric in (1,2)
group by m.codigo_est, m.programa_academico, 
				dp2.primer_nombre,
                 dp2.segundo_nombre,
                 dp2.primer_apellido,
                 dp2.segundo_apellido, 
                 dp2.doc_ident_est
order by m.codigo_est