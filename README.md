# Cambios Vistos

--Funcion convenios
version actual - se encuentra asi actualmente en la base de datos de produccion

CREATE OR REPLACE FUNCTION public.convenios()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
  IF(TG_OP = 'INSERT')THEN
  INSERT INTO public.aud_convenios(
	usuario, fecha, procedimiento, id, numero, nombre, valor, memoria_tecnica, acta_consejo_facultad, acta_inicio, acta_terminacion, 
	informe_ejecucion, id_municipio, semestre_academico_id)
	VALUES (user, current_timestamp,'INSERT',new.*); return new;
ELSIF (TG_OP = 'UPDATE')THEN
   INSERT INTO public.aud_convenios(
	usuario, fecha, procedimiento, id, numero, nombre, valor, memoria_tecnica, acta_consejo_facultad, acta_inicio, acta_terminacion, informe_ejecucion, id_municipio, semestre_academico_id)
	VALUES (user, current_timestamp,'UPDATE',old.*);return new;

ELSIF (TG_OP = 'DELETE')THEN
   INSERT INTO public.aud_convenios(
	usuario, fecha, procedimiento, id, numero, nombre, valor, memoria_tecnica, acta_consejo_facultad, acta_inicio, acta_terminacion, informe_ejecucion, id_municipio, semestre_academico_id)
	VALUES (user, current_timestamp,'DELETE',old.*);return old;
END IF;
return new;
END;
$function$
;
=================================================================
version nueva - este trigger cuenta con mas campos en la tabla de auditoria y viene directamente de la tabla convenios, lo cual significa que esta igual tiene estos nuevo campos

CREATE FUNCTION public.convenios() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  IF(TG_OP = 'INSERT')THEN
  INSERT INTO public.aud_convenios(
	usuario, fecha, procedimiento, id, numero, nombre, valor, memoria_tecnica, acta_consejo_facultad, acta_inicio, acta_terminacion, informe_ejecucion,
	tipo,institucion,tipo_institucion,subscriptor,fecha_subscriptor,fecha_inicio,fecha_final,cupos_estudiantes_beneficiados,objeto,recursos_ingresador,duracion_beneficio,promedio_requerido,
	procedencia_estudiante_requerida,puntaje_sisbe_requerido,imputacion_presupuestal,acta_liquidacion,carta_vecindad,pagare,carta_compromiso,firma,imagenCon,contacto,seguidor,estado_vigencia,documentos,categoria_institucion)
	VALUES (current_setting('myapp.username'), current_timestamp,'INSERT',new.*); return new;
ELSIF (TG_OP = 'UPDATE')THEN
   INSERT INTO public.aud_convenios(
	usuario, fecha, procedimiento, id, numero, nombre, valor, memoria_tecnica, acta_consejo_facultad, acta_inicio, acta_terminacion, informe_ejecucion,
	tipo,institucion,tipo_institucion,subscriptor,fecha_subscriptor,fecha_inicio,fecha_final,cupos_estudiantes_beneficiados,objeto,recursos_ingresador,duracion_beneficio,promedio_requerido,
	procedencia_estudiante_requerida,puntaje_sisbe_requerido,imputacion_presupuestal,acta_liquidacion,carta_vecindad,pagare,carta_compromiso,firma,imagenCon,contacto,seguidor,estado_vigencia,documentos,categoria_institucion)
	VALUES (current_setting('myapp.username'), current_timestamp,'UPDATE',old.*);return new;

ELSIF (TG_OP = 'DELETE')THEN
   INSERT INTO public.aud_convenios(
	usuario, fecha, procedimiento, id, numero, nombre, valor, memoria_tecnica, acta_consejo_facultad, acta_inicio, acta_terminacion, informe_ejecucion,
	tipo,institucion,tipo_institucion,subscriptor,fecha_subscriptor,fecha_inicio,fecha_final,cupos_estudiantes_beneficiados,objeto,recursos_ingresador,duracion_beneficio,promedio_requerido,
	procedencia_estudiante_requerida,puntaje_sisbe_requerido,imputacion_presupuestal,acta_liquidacion,carta_vecindad,pagare,carta_compromiso,firma,imagenCon,contacto,seguidor,estado_vigencia,documentos,categoria_institucion)
	VALUES (current_setting('myapp.username'), current_timestamp,'DELETE',old.*);return old;
END IF;
return new;
END;
$$;
