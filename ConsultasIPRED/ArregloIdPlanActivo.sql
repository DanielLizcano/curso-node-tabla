--controllerCronograma.js
--linea 228 hasta 238

--anterior consulta ---------------------------------------------------------------------------------
(select a.codigo_asignatura, a.nombre_asignatura from asignaturas_plan ap
join asignaturas a on a.codigo_asignatura = ap.codigo_asignatura 
join programa_academico pa on ap.codigo_plan = pa.id_plan_estudio_activo
and ap.codigo_programa = pa.codigo 
where pa.codigo = :codigo_programa )
----------------------------------------------------------------------------------------------------

--nueva consulta------------------------------------------------------------------------------------
(select a.codigo_asignatura, a.nombre_asignatura from asignaturas a
join asignaturas_plan ap on a.codigo_asignatura = ap.codigo_asignatura 
join plan_estudio pe on ap.codigo_plan =pe.codigo_plan 
and pe.codigo_programa = ap.codigo_programa 
and pe.estado_plan = 'activo'
where ap.codigo_programa = '70')
-----------------------------------------------------------------------------------------------------



--modelGruposActividades.js
--linea 206 hasta la linea 291

--anterior consulta ---------------------------------------------------------------------------------
(SELECT psag.*,
                      MIN(aplan.nivel_asignatura) AS nivel,
                      CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
                      a.nombre_asignatura,
                      p.documento_identidad,
                      STRING_AGG(ghp.codigo_gh::character varying, ', ') as codigos_gh,
                      STRING_AGG(gh.nombre_gh, ', ') as nombres_gh
                    FROM programa_sede_asignatura_grupos psag
                    JOIN persona p ON
                      p.documento_identidad = psag.profesor_documento_identidad
                    JOIN asignaturas a ON
                      a.codigo_asignatura = psag.codigo_asignatura
                    JOIN programa_academico pa ON
                      psag.codigo_programa = pa.codigo 
                    JOIN asignaturas_plan aplan ON
                      psag.codigo_programa = aplan.codigo_programa AND
                      psag.codigo_asignatura = aplan.codigo_asignatura and
                      --cambio necesario
                      pa.id_plan_estudio_activo = aplan.codigo_plan
                      ----------------
                      LEFT JOIN gh_psag ghp ON
                      psag.codigo_programa = ghp.codigo_programa AND
                      psag.profesor_documento_identidad = ghp.profesor_documento_identidad AND
                      psag.id_semestre = ghp.id_semestre AND
                      psag.codigo_asignatura = ghp.codigo_asignatura AND
                      psag.codigo_sede = ghp.codigo_sede AND
                      psag.grupo = ghp.grupo
                    LEFT JOIN grupo_homologacion gh ON
                      gh.codigo_gh = ghp.codigo_gh
                    WHERE psag.id_semestre = :semestre
                      AND psag.codigo_programa in (:programas)
                      AND psag.codigo_sede in (:sedes)
                      AND psag.id_jornada in (:jornadas)
                    GROUP BY
                      psag.codigo_programa,
                      psag.codigo_asignatura,
                      psag.grupo,
                      psag.codigo_sede,
                      psag.id_semestre,
                      nombre_profesor,
                      a.nombre_asignatura,
                      p.documento_identidad,
                      psag.profesor_documento_identidad
                    ORDER BY profesor_documento_identidad 
                    )UNION(
                    SELECT psag.*,
                      aeos.nivel,
                      CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
                      a.nombre_asignatura,
                      p.documento_identidad,
                      STRING_AGG(gh.codigo_gh::character varying, ', ') as codigos_gh,
                      STRING_AGG(gh.nombre_gh, ', ') as nombres_gh
                    FROM programa_sede_asignatura_grupos psag
                    JOIN asignaturas_electivas_ofertadas_semestre aeos ON
                      psag.codigo_programa = aeos.codigo_programa AND
                      psag.codigo_asignatura = aeos.codigo_asignatura  and
                      aeos.id_semestre= psag.id_semestre
                    JOIN persona p ON
                      p.documento_identidad = psag.profesor_documento_identidad
                    JOIN asignaturas a ON
                      a.codigo_asignatura = psag.codigo_asignatura
                    LEFT JOIN gh_psag ghp ON
                      psag.codigo_programa = ghp.codigo_programa AND
                      psag.profesor_documento_identidad = ghp.profesor_documento_identidad AND
                      psag.id_semestre = ghp.id_semestre AND
                      psag.codigo_asignatura = ghp.codigo_asignatura AND
                      psag.codigo_sede = ghp.codigo_sede AND
                      psag.grupo = ghp.grupo
                    LEFT JOIN grupo_homologacion gh ON
                      gh.codigo_gh = ghp.codigo_gh         
                    WHERE psag.id_semestre = :semestre
                      AND psag.codigo_programa in (:programas)
                      AND psag.codigo_sede in (:sedes)
                      AND psag.id_jornada in (:jornadas)
                    GROUP BY
                      psag.codigo_programa,
                      psag.codigo_asignatura,
                      psag.grupo,
                      psag.codigo_sede,
                      psag.id_semestre,
                      nombre_profesor,
                      a.nombre_asignatura,
                      p.documento_identidad,
                      psag.profesor_documento_identidad,
                      nivel
                    ORDER BY profesor_documento_identidad);
-----------------------------------------------------------------------------------------------------

--nueva consulta-------------------------------------------------------------------------------------
(SELECT psag.*,
                      MIN(aplan.nivel_asignatura) AS nivel,
                      CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
                      a.nombre_asignatura,
                      p.documento_identidad,
                      STRING_AGG(ghp.codigo_gh::character varying, ', ') as codigos_gh,
                      STRING_AGG(gh.nombre_gh, ', ') as nombres_gh
                    FROM programa_sede_asignatura_grupos psag
                    JOIN persona p ON
                      p.documento_identidad = psag.profesor_documento_identidad
                    JOIN asignaturas a ON
                      a.codigo_asignatura = psag.codigo_asignatura
                    JOIN programa_academico pa ON
                      psag.codigo_programa = pa.codigo 
                    JOIN asignaturas_plan aplan ON
                      psag.codigo_programa = aplan.codigo_programa AND
                      psag.codigo_asignatura = aplan.codigo_asignatura
                      --cambio implementado--------------------
                      join plan_estudio pe on aplan.codigo_plan =pe.codigo_plan 
					  and pe.codigo_programa = aplan.codigo_programa
                      ------------------------------------------
                      
                      LEFT JOIN gh_psag ghp ON
                      psag.codigo_programa = ghp.codigo_programa AND
                      psag.profesor_documento_identidad = ghp.profesor_documento_identidad AND
                      psag.id_semestre = ghp.id_semestre AND
                      psag.codigo_asignatura = ghp.codigo_asignatura AND
                      psag.codigo_sede = ghp.codigo_sede AND
                      psag.grupo = ghp.grupo
                    LEFT JOIN grupo_homologacion gh ON
                      gh.codigo_gh = ghp.codigo_gh
                    WHERE psag.id_semestre = :semestre
                      AND psag.codigo_programa in (:programas)
                      AND psag.codigo_sede in (:sedes)
                      AND psag.id_jornada in (:jornadas)
                    GROUP BY
                      psag.codigo_programa,
                      psag.codigo_asignatura,
                      psag.grupo,
                      psag.codigo_sede,
                      psag.id_semestre,
                      nombre_profesor,
                      a.nombre_asignatura,
                      p.documento_identidad,
                      psag.profesor_documento_identidad
                    ORDER BY profesor_documento_identidad 
                    )UNION(
                    SELECT psag.*,
                      aeos.nivel,
                      CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
                      a.nombre_asignatura,
                      p.documento_identidad,
                      STRING_AGG(gh.codigo_gh::character varying, ', ') as codigos_gh,
                      STRING_AGG(gh.nombre_gh, ', ') as nombres_gh
                    FROM programa_sede_asignatura_grupos psag
                    JOIN asignaturas_electivas_ofertadas_semestre aeos ON
                      psag.codigo_programa = aeos.codigo_programa AND
                      psag.codigo_asignatura = aeos.codigo_asignatura  and
                      aeos.id_semestre= psag.id_semestre
                    JOIN persona p ON
                      p.documento_identidad = psag.profesor_documento_identidad
                    JOIN asignaturas a ON
                      a.codigo_asignatura = psag.codigo_asignatura
                    LEFT JOIN gh_psag ghp ON
                      psag.codigo_programa = ghp.codigo_programa AND
                      psag.profesor_documento_identidad = ghp.profesor_documento_identidad AND
                      psag.id_semestre = ghp.id_semestre AND
                      psag.codigo_asignatura = ghp.codigo_asignatura AND
                      psag.codigo_sede = ghp.codigo_sede AND
                      psag.grupo = ghp.grupo
                    LEFT JOIN grupo_homologacion gh ON
                      gh.codigo_gh = ghp.codigo_gh         
                    WHERE psag.id_semestre = :semestre
                      AND psag.codigo_programa in (:programas)
                      AND psag.codigo_sede in (:sedes)
                      AND psag.id_jornada in (:jornadas)
                    GROUP BY
                      psag.codigo_programa,
                      psag.codigo_asignatura,
                      psag.grupo,
                      psag.codigo_sede,
                      psag.id_semestre,
                      nombre_profesor,
                      a.nombre_asignatura,
                      p.documento_identidad,
                      psag.profesor_documento_identidad,
                      nivel
                    ORDER BY profesor_documento_identidad);
----------------------------------------------------------------------------------------------------


--modelGruposActividades.js
--linea 306 hasta 399

--anterior consulta ----------------------------------------------------------------------------------
(SELECT ga.*,
                      psag.id_jornada,
                      ta.nombre AS nombre_tipo_actividad,
                      au.numero AS numero_aula,
                      au.nombre AS nombre_aula,
                      ed.id AS id_edificio,
                      ed.nombre AS nombre_edificio,
                      MIN(aplan.nivel_asignatura) AS nivel
                    FROM programa_sede_asignatura_grupos psag
                    JOIN grupos_actividades ga ON 
                      psag.codigo_programa              = ga.codigo_programa AND
                      psag.codigo_sede                  = ga.codigo_sede AND
                      psag.codigo_asignatura            = ga.codigo_asignatura AND
                      psag.id_semestre                  = ga.id_semestre AND
                      psag.grupo                        = ga.grupo AND
                      psag.profesor_documento_identidad = ga.profesor_documento_identidad
                    JOIN programa_academico pa ON
                      psag.codigo_programa = pa.codigo 
                    JOIN asignaturas_plan aplan ON
                      psag.codigo_programa = aplan.codigo_programa AND
                      psag.codigo_asignatura = aplan.codigo_asignatura and
                      --cambio necesario-----------------------------------------------
                      pa.id_plan_estudio_activo = aplan.codigo_plan
                      --------------------------------------------------------
                    JOIN tipos_actividades ta ON
                      ga.codigo_tipo_actividad = ta.codigo
                    LEFT JOIN aulas au ON
                      ga.id_aula = au.id_aula
                    LEFT JOIN edificios ed ON
                      ed.id = au.id_edificio
                    WHERE ga.codigo_programa in (:programas) AND
                      ga.codigo_sede in (:sedes) AND
                      psag.id_jornada in (:jornadas) AND
                      ga.id_semestre     = :semestre AND
                      ga.fecha_inicio::varchar    >= :fechaInicial AND
                      ga.fecha_inicio::varchar    <= :fechaFinal
                    GROUP BY
                      psag.id_jornada,
                      ga.codigo_programa,
                      ta.nombre,
                      au.numero,
                      au.nombre,
                      ed.id,
                      ed.nombre,
                      ga.codigo_asignatura,
                      ga.id_actividad,
                      ga.grupo,
                      ga.codigo_sede,
                      ga.profesor_documento_identidad
                  ) UNION (
                    SELECT ga.*,
                      psag.id_jornada,
                      ta.nombre AS nombre_tipo_actividad,
                      au.numero AS numero_aula,
                      au.nombre AS nombre_aula,
                      ed.id AS id_edificio,
                      ed.nombre AS nombre_edificio,
                      aeos.nivel
                    FROM programa_sede_asignatura_grupos psag
                    JOIN grupos_actividades ga ON 
                      psag.codigo_programa              = ga.codigo_programa AND
                      psag.codigo_sede                  = ga.codigo_sede AND
                      psag.codigo_asignatura            = ga.codigo_asignatura AND
                      psag.id_semestre                  = ga.id_semestre AND
                      psag.grupo                        = ga.grupo AND
                      psag.profesor_documento_identidad = ga.profesor_documento_identidad
                    JOIN asignaturas_electivas_ofertadas_semestre aeos ON
                      psag.codigo_programa = aeos.codigo_programa AND
                      psag.codigo_asignatura = aeos.codigo_asignatura  AND
                      psag.id_semestre = aeos.id_semestre
                    JOIN tipos_actividades ta ON
                      ga.codigo_tipo_actividad = ta.codigo
                    LEFT JOIN aulas au ON
                      ga.id_aula = au.id_aula
                    LEFT JOIN edificios ed ON
                      ed.id = au.id_edificio
                    WHERE ga.codigo_programa in (:programas) AND
                      ga.codigo_sede in (:sedes) AND
                      psag.id_jornada in (:jornadas) AND 
                      ga.id_semestre     = :semestre AND
                      ga.fecha_inicio::varchar    >= :fechaInicial AND
                      ga.fecha_inicio::varchar    <= :fechaFinal
                    GROUP BY
                      psag.id_jornada,
                      ga.codigo_programa,
                      ta.nombre,
                      au.numero,
                      au.nombre,
                      ed.id,
                      ed.nombre,
                      ga.codigo_asignatura,
                      ga.id_actividad,
                      ga.grupo,
                      ga.codigo_sede,
                      ga.profesor_documento_identidad,
                      nivel);
----------------------------------------------------------------------------------------------------

-- nueva consulta
(SELECT ga.*,
                      psag.id_jornada,
                      ta.nombre AS nombre_tipo_actividad,
                      au.numero AS numero_aula,
                      au.nombre AS nombre_aula,
                      ed.id AS id_edificio,
                      ed.nombre AS nombre_edificio,
                      MIN(aplan.nivel_asignatura) AS nivel
                    FROM programa_sede_asignatura_grupos psag
                    JOIN grupos_actividades ga ON 
                      psag.codigo_programa              = ga.codigo_programa AND
                      psag.codigo_sede                  = ga.codigo_sede AND
                      psag.codigo_asignatura            = ga.codigo_asignatura AND
                      psag.id_semestre                  = ga.id_semestre AND
                      psag.grupo                        = ga.grupo AND
                      psag.profesor_documento_identidad = ga.profesor_documento_identidad
                    JOIN programa_academico pa ON
                      psag.codigo_programa = pa.codigo 
                    JOIN asignaturas_plan aplan ON
                      psag.codigo_programa = aplan.codigo_programa AND
                      psag.codigo_asignatura = aplan.codigo_asignatura
                      --cambio implementado---------------------------------
                    JOIN plan_estudio pe on aplan.codigo_plan =pe.codigo_plan 
					  and pe.codigo_programa = aplan.codigo_programa
					  -------------------------------------------------------
                    JOIN tipos_actividades ta ON
                      ga.codigo_tipo_actividad = ta.codigo
                    LEFT JOIN aulas au ON
                      ga.id_aula = au.id_aula
                    LEFT JOIN edificios ed ON
                      ed.id = au.id_edificio
                    WHERE ga.codigo_programa in (:programas) AND
                      ga.codigo_sede in (:sedes) AND
                      psag.id_jornada in (:jornadas) AND
                      ga.id_semestre     = :semestre AND
                      ga.fecha_inicio::varchar    >= :fechaInicial AND
                      ga.fecha_inicio::varchar    <= :fechaFinal
                    GROUP BY
                      psag.id_jornada,
                      ga.codigo_programa,
                      ta.nombre,
                      au.numero,
                      au.nombre,
                      ed.id,
                      ed.nombre,
                      ga.codigo_asignatura,
                      ga.id_actividad,
                      ga.grupo,
                      ga.codigo_sede,
                      ga.profesor_documento_identidad
                  ) UNION (
                    SELECT ga.*,
                      psag.id_jornada,
                      ta.nombre AS nombre_tipo_actividad,
                      au.numero AS numero_aula,
                      au.nombre AS nombre_aula,
                      ed.id AS id_edificio,
                      ed.nombre AS nombre_edificio,
                      aeos.nivel
                    FROM programa_sede_asignatura_grupos psag
                    JOIN grupos_actividades ga ON 
                      psag.codigo_programa              = ga.codigo_programa AND
                      psag.codigo_sede                  = ga.codigo_sede AND
                      psag.codigo_asignatura            = ga.codigo_asignatura AND
                      psag.id_semestre                  = ga.id_semestre AND
                      psag.grupo                        = ga.grupo AND
                      psag.profesor_documento_identidad = ga.profesor_documento_identidad
                    JOIN asignaturas_electivas_ofertadas_semestre aeos ON
                      psag.codigo_programa = aeos.codigo_programa AND
                      psag.codigo_asignatura = aeos.codigo_asignatura  AND
                      psag.id_semestre = aeos.id_semestre
                    JOIN tipos_actividades ta ON
                      ga.codigo_tipo_actividad = ta.codigo
                    LEFT JOIN aulas au ON
                      ga.id_aula = au.id_aula
                    LEFT JOIN edificios ed ON
                      ed.id = au.id_edificio
                    WHERE ga.codigo_programa in (:programas) AND
                      ga.codigo_sede in (:sedes) AND
                      psag.id_jornada in (:jornadas) AND 
                      ga.id_semestre     = :semestre AND
                      ga.fecha_inicio::varchar    >= :fechaInicial AND
                      ga.fecha_inicio::varchar    <= :fechaFinal
                    GROUP BY
                      psag.id_jornada,
                      ga.codigo_programa,
                      ta.nombre,
                      au.numero,
                      au.nombre,
                      ed.id,
                      ed.nombre,
                      ga.codigo_asignatura,
                      ga.id_actividad,
                      ga.grupo,
                      ga.codigo_sede,
                      ga.profesor_documento_identidad,
                      nivel);
----------------------------------------------------------------------------------------------------
			  

--modelGruposActividades.js					  
--linea 413 hasta 490	

--anterior consulta------------------------------------------------------------------------------------
(SELECT 
                      ga.codigo_sede,
                      SUM(EXTRACT(hour from (ga.fecha_fin - ga.fecha_inicio) )+ 24*EXTRACT(day from (fecha_fin - fecha_inicio) )) as horas, ta.nombre,
                      ga.codigo_programa,
                      ga.codigo_asignatura,
                      ga.id_semestre,
                      ga.grupo,
                      ga.profesor_documento_identidad,
                      MIN(aplan.nivel_asignatura) AS nivel,
                      ta.codigo
                    FROM programa_sede_asignatura_grupos psag
                    JOIN grupos_actividades ga ON 
                      psag.codigo_programa              = ga.codigo_programa AND
                      psag.codigo_sede                  = ga.codigo_sede AND
                      psag.codigo_asignatura            = ga.codigo_asignatura AND
                      psag.id_semestre                  = ga.id_semestre AND
                      psag.grupo                        = ga.grupo AND
                      psag.profesor_documento_identidad = ga.profesor_documento_identidad
                    JOIN tipos_actividades ta ON 
                      ta.codigo = ga.codigo_tipo_actividad
                    JOIN programa_academico pa ON
                      ga.codigo_programa = pa.codigo 
                    JOIN asignaturas_plan aplan ON
                      ga.codigo_programa = aplan.codigo_programa AND
                      ga.codigo_asignatura = aplan.codigo_asignatura AND
					  --cambio necesario---------------------------
                      pa.id_plan_estudio_activo = aplan.codigo_plan
					  -------------------------------------------------
                    WHERE ga.codigo_programa in (:programas) AND
                      ga.codigo_sede in (:sedes) AND
                      psag.id_jornada in (:jornadas) AND 
                      ga.id_semestre     = :semestre 
                    GROUP BY
                      ga.codigo_sede,
                      ga.codigo_programa,
                      ga.codigo_asignatura,
                      ga.id_semestre,
                      ga.grupo,
                      ga.profesor_documento_identidad,
                      ta.codigo,
                      ta.nombre
                    ) UNION(
                      SELECT 
                        ga.codigo_sede,
                        SUM(EXTRACT(hour from (ga.fecha_fin - ga.fecha_inicio) )+ 24*EXTRACT(day from (fecha_fin - fecha_inicio) )) as horas, ta.nombre,
                        ga.codigo_programa,
                        ga.codigo_asignatura,
                        ga.id_semestre,
                        ga.grupo,
                        ga.profesor_documento_identidad,
                        aeos.nivel,
                        ta.codigo
                      FROM programa_sede_asignatura_grupos psag
                      JOIN grupos_actividades ga ON 
                        psag.codigo_programa              = ga.codigo_programa AND
                        psag.codigo_sede                  = ga.codigo_sede AND
                        psag.codigo_asignatura            = ga.codigo_asignatura AND
                        psag.id_semestre                  = ga.id_semestre AND
                        psag.grupo                        = ga.grupo AND
                        psag.profesor_documento_identidad = ga.profesor_documento_identidad
                      JOIN tipos_actividades ta ON 
                        ta.codigo = ga.codigo_tipo_actividad
                      JOIN asignaturas_electivas_ofertadas_semestre aeos ON
                        psag.codigo_programa = aeos.codigo_programa AND
                        psag.codigo_asignatura = aeos.codigo_asignatura  and
                        psag.id_semestre = aeos.id_semestre
                      WHERE ga.codigo_programa in (:programas) AND
                        ga.codigo_sede in (:sedes) AND
                        psag.id_jornada in (:jornadas) AND
                        ga.id_semestre = :semestre
                      GROUP BY
                        ga.codigo_sede,
                        ga.codigo_programa,
                        ga.codigo_asignatura,
                        ga.id_semestre,
                        ga.grupo,
                        ga.profesor_documento_identidad,
                        ta.codigo,
                        ta.nombre,
                        nivel);
-----------------------------------------------------------------------------------------------------------

						
--nueva consulta------------------------------------------------------------------------------------
(SELECT 
                      ga.codigo_sede,
                      SUM(EXTRACT(hour from (ga.fecha_fin - ga.fecha_inicio) )+ 24*EXTRACT(day from (fecha_fin - fecha_inicio) )) as horas, ta.nombre,
                      ga.codigo_programa,
                      ga.codigo_asignatura,
                      ga.id_semestre,
                      ga.grupo,
                      ga.profesor_documento_identidad,
                      MIN(aplan.nivel_asignatura) AS nivel,
                      ta.codigo
                    FROM programa_sede_asignatura_grupos psag
                    JOIN grupos_actividades ga ON 
                      psag.codigo_programa              = ga.codigo_programa AND
                      psag.codigo_sede                  = ga.codigo_sede AND
                      psag.codigo_asignatura            = ga.codigo_asignatura AND
                      psag.id_semestre                  = ga.id_semestre AND
                      psag.grupo                        = ga.grupo AND
                      psag.profesor_documento_identidad = ga.profesor_documento_identidad
                    JOIN tipos_actividades ta ON 
                      ta.codigo = ga.codigo_tipo_actividad
                    JOIN programa_academico pa ON
                      ga.codigo_programa = pa.codigo 
                    JOIN asignaturas_plan aplan ON
                      ga.codigo_programa = aplan.codigo_programa AND
                      ga.codigo_asignatura = aplan.codigo_asignatura
                      --cambio implementado-------------------------
                      JOIN plan_estudio pe on aplan.codigo_plan =pe.codigo_plan 
					  and pe.codigo_programa = aplan.codigo_programa
                      ----------------------------------------------                     
                    WHERE ga.codigo_programa in (:programas) AND
                      ga.codigo_sede in (:sedes) AND
                      psag.id_jornada in (:jornadas) AND 
                      ga.id_semestre     = :semestre 
                    GROUP BY
                      ga.codigo_sede,
                      ga.codigo_programa,
                      ga.codigo_asignatura,
                      ga.id_semestre,
                      ga.grupo,
                      ga.profesor_documento_identidad,
                      ta.codigo,
                      ta.nombre
                    ) UNION(
                      SELECT 
                        ga.codigo_sede,
                        SUM(EXTRACT(hour from (ga.fecha_fin - ga.fecha_inicio) )+ 24*EXTRACT(day from (fecha_fin - fecha_inicio) )) as horas, ta.nombre,
                        ga.codigo_programa,
                        ga.codigo_asignatura,
                        ga.id_semestre,
                        ga.grupo,
                        ga.profesor_documento_identidad,
                        aeos.nivel,
                        ta.codigo
                      FROM programa_sede_asignatura_grupos psag
                      JOIN grupos_actividades ga ON 
                        psag.codigo_programa              = ga.codigo_programa AND
                        psag.codigo_sede                  = ga.codigo_sede AND
                        psag.codigo_asignatura            = ga.codigo_asignatura AND
                        psag.id_semestre                  = ga.id_semestre AND
                        psag.grupo                        = ga.grupo AND
                        psag.profesor_documento_identidad = ga.profesor_documento_identidad
                      JOIN tipos_actividades ta ON 
                        ta.codigo = ga.codigo_tipo_actividad
                      JOIN asignaturas_electivas_ofertadas_semestre aeos ON
                        psag.codigo_programa = aeos.codigo_programa AND
                        psag.codigo_asignatura = aeos.codigo_asignatura  AND
                        psag.id_semestre = aeos.id_semestre
                      WHERE ga.codigo_programa in (:programas) AND
                        ga.codigo_sede in (:sedes) AND
                        psag.id_jornada in (:jornadas) AND
                        ga.id_semestre = :semestre
                      GROUP BY
                        ga.codigo_sede,
                        ga.codigo_programa,
                        ga.codigo_asignatura,
                        ga.id_semestre,
                        ga.grupo,
                        ga.profesor_documento_identidad,
                        ta.codigo,
                        ta.nombre,
                        nivel);
-----------------------------------------------------------------------------------------------------------

--modelGruposActividades.js		
--linea 1975 hasta 2042

--anterior consulta------------------------------------------------------------------------------------
(
        SELECT psag.*,
          MIN(aplan.nivel_asignatura) AS nivel,
          CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad
        FROM programa_sede_asignatura_grupos psag
        JOIN persona p ON
          p.documento_identidad = psag.profesor_documento_identidad
        JOIN asignaturas a ON
          a.codigo_asignatura = psag.codigo_asignatura
        JOIN programa_academico pa ON
          psag.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          psag.codigo_programa = aplan.codigo_programa AND
          psag.codigo_asignatura = aplan.codigo_asignatura AND
		  --cambio necesario-----------------------------------------------
          pa.id_plan_estudio_activo = aplan.codigo_plan
		  -------------------------------------------------------------
        WHERE  
          
          psag.codigo_sede     = :codSede AND
          psag.id_jornada      = :jornada AND
          psag.id_semestre     = :semestre 
          
        GROUP BY 
          psag.codigo_programa,
          psag.codigo_asignatura,
          psag.grupo,
          psag.codigo_sede,
          psag.id_semestre,
          nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          psag.profesor_documento_identidad
        ORDER BY profesor_documento_identidad

        ) UNION (

        SELECT psag.*,
          aeos.nivel,
          CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad
        FROM programa_sede_asignatura_grupos psag
        JOIN asignaturas_electivas_ofertadas_semestre aeos ON
          psag.codigo_programa = aeos.codigo_programa AND
          psag.codigo_asignatura = aeos.codigo_asignatura  and
          aeos.id_semestre= psag.id_semestre
        JOIN persona p ON
          p.documento_identidad = psag.profesor_documento_identidad
        JOIN asignaturas a ON
          a.codigo_asignatura = psag.codigo_asignatura         
        WHERE  
          
          psag.codigo_sede     = :codSede AND
          psag.id_jornada      = :jornada AND
          psag.id_semestre     = :semestre 
          
        GROUP BY 
          psag.codigo_programa,
          psag.codigo_asignatura,
          psag.grupo,
          psag.codigo_sede,
          psag.id_semestre,
          nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          psag.profesor_documento_identidad,
          nivel
        ORDER BY profesor_documento_identidad) ;
-----------------------------------------------------------------------------------------------------------
--nueva consulta------------------------------------------------------------------------------------
 (
        SELECT psag.*,
          MIN(aplan.nivel_asignatura) AS nivel,
          CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad
        FROM programa_sede_asignatura_grupos psag
        JOIN persona p ON
          p.documento_identidad = psag.profesor_documento_identidad
        JOIN asignaturas a ON
          a.codigo_asignatura = psag.codigo_asignatura
        JOIN programa_academico pa ON
          psag.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          psag.codigo_programa = aplan.codigo_programa AND
          psag.codigo_asignatura = aplan.codigo_asignatura
           --cambio implementado-------------------------
          JOIN plan_estudio pe on aplan.codigo_plan =pe.codigo_plan 
			and pe.codigo_programa = aplan.codigo_programa
          ----------------------------------------------    
        
        WHERE  
         
          psag.codigo_sede     = :codSede AND
          psag.id_jornada      = :jornada AND
          psag.id_semestre     = :semestre 
          
        GROUP BY 
          psag.codigo_programa,
          psag.codigo_asignatura,
          psag.grupo,
          psag.codigo_sede,
          psag.id_semestre,
          nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          psag.profesor_documento_identidad
        ORDER BY profesor_documento_identidad

        ) UNION (

        SELECT psag.*,
          aeos.nivel,
          CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad
        FROM programa_sede_asignatura_grupos psag
        JOIN asignaturas_electivas_ofertadas_semestre aeos ON
          psag.codigo_programa = aeos.codigo_programa AND
          psag.codigo_asignatura = aeos.codigo_asignatura  and
          aeos.id_semestre= psag.id_semestre
        JOIN persona p ON
          p.documento_identidad = psag.profesor_documento_identidad
        JOIN asignaturas a ON
          a.codigo_asignatura = psag.codigo_asignatura         
        WHERE  
    
          psag.codigo_sede     = :codSede AND
          psag.id_jornada      = :jornada AND
          psag.id_semestre     = :semestre 
         
        GROUP BY 
          psag.codigo_programa,
          psag.codigo_asignatura,
          psag.grupo,
          psag.codigo_sede,
          psag.id_semestre,
          nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          psag.profesor_documento_identidad,
          nivel
        ORDER BY profesor_documento_identidad) ;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--modelGruposActividades.js	
--linea 2050 hasta 2149

--anterior consulta------------------------------------------------------------------------------------
  --cambio necesario---------------------------------------------------
    
(
        SELECT ga.*,
          ta.nombre AS nombre_tipo_actividad,
          au.numero AS numero_aula,
          au.nombre AS nombre_aula,
          ed.id AS id_edificio,
          ed.nombre AS nombre_edificio,
          MIN(aplan.nivel_asignatura) AS nivel
        FROM programa_sede_asignatura_grupos psag
        JOIN grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN programa_academico pa ON
          psag.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          psag.codigo_programa = aplan.codigo_programa AND
          psag.codigo_asignatura = aplan.codigo_asignatura AND
          --cambio necesario---------------------------------------------------
          pa.id_plan_estudio_activo = aplan.codigo_plan
          ---------------------------------------------------------------
        JOIN tipos_actividades ta ON
          ga.codigo_tipo_actividad = ta.codigo
        LEFT JOIN aulas au ON
          ga.id_aula = au.id_aula
        LEFT JOIN edificios ed ON
          ed.id = au.id_edificio
        WHERE  
           
          psag.codigo_sede     = :codSede AND
          ga.codigo_sede     = :codSede AND
          psag.id_jornada    = :jornada AND
          ga.id_semestre     = :semestre AND
          ga.fecha_inicio::varchar    >= :desde AND
          ga.fecha_inicio::varchar    <= :hasta
          
        GROUP BY
          ga.codigo_programa,
          ta.nombre,
          au.numero,
          au.nombre,
          ed.id,
          ed.nombre,
          ga.codigo_asignatura,
          ga.id_actividad,
          ga.grupo,
          ga.codigo_sede,
          ga.profesor_documento_identidad
        ) UNION (
        SELECT ga.*,
          ta.nombre AS nombre_tipo_actividad,
          au.numero AS numero_aula,
          au.nombre AS nombre_aula,
          ed.id AS id_edificio,
          ed.nombre AS nombre_edificio,
          aeos.nivel
        FROM programa_sede_asignatura_grupos psag
        JOIN grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN asignaturas_electivas_ofertadas_semestre aeos ON
          psag.codigo_programa = aeos.codigo_programa AND
          psag.codigo_asignatura = aeos.codigo_asignatura  AND
          psag.id_semestre = aeos.id_semestre
        JOIN tipos_actividades ta ON
          ga.codigo_tipo_actividad = ta.codigo
        LEFT JOIN aulas au ON
          ga.id_aula = au.id_aula
        LEFT JOIN edificios ed ON
          ed.id = au.id_edificio
        WHERE
          
          psag.codigo_sede     = :codSede AND
          ga.codigo_sede     = :codSede AND
          psag.id_jornada    = :jornada AND
          ga.id_semestre     = :semestre AND
          ga.fecha_inicio::varchar    >= :desde AND
          ga.fecha_inicio::varchar    <= :hasta
          
        GROUP BY 
          ga.codigo_programa,
          ta.nombre,
          au.numero,
          au.nombre,
          ed.id,
          ed.nombre,
          ga.codigo_asignatura,
          ga.id_actividad,
          ga.grupo,
          ga.codigo_sede,
          ga.profesor_documento_identidad,
          nivel
        )
        
--nueva consulta------------------------------------------------------------------------------------
 (
        SELECT ga.*,
          ta.nombre AS nombre_tipo_actividad,
          au.numero AS numero_aula,
          au.nombre AS nombre_aula,
          ed.id AS id_edificio,
          ed.nombre AS nombre_edificio,
          MIN(aplan.nivel_asignatura) AS nivel
        FROM programa_sede_asignatura_grupos psag
        JOIN grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN programa_academico pa ON
          psag.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          psag.codigo_programa = aplan.codigo_programa AND
          psag.codigo_asignatura = aplan.codigo_asignatura  
          --cambio implementado-------------------------
          JOIN plan_estudio pe on aplan.codigo_plan =pe.codigo_plan 
			and pe.codigo_programa = aplan.codigo_programa
          ---------------------------------------------- 
        JOIN tipos_actividades ta ON
          ga.codigo_tipo_actividad = ta.codigo
        LEFT JOIN aulas au ON
          ga.id_aula = au.id_aula
        LEFT JOIN edificios ed ON
          ed.id = au.id_edificio
        WHERE  
           
          psag.codigo_sede     = :codSede AND
          ga.codigo_sede     = :codSede AND
          psag.id_jornada    = :jornada AND
          ga.id_semestre     = :semestre AND
          ga.fecha_inicio::varchar    >= :desde AND
          ga.fecha_inicio::varchar    <= :hasta
          
        GROUP BY
          ga.codigo_programa,
          ta.nombre,
          au.numero,
          au.nombre,
          ed.id,
          ed.nombre,
          ga.codigo_asignatura,
          ga.id_actividad,
          ga.grupo,
          ga.codigo_sede,
          ga.profesor_documento_identidad
        ) UNION (
        SELECT ga.*,
          ta.nombre AS nombre_tipo_actividad,
          au.numero AS numero_aula,
          au.nombre AS nombre_aula,
          ed.id AS id_edificio,
          ed.nombre AS nombre_edificio,
          aeos.nivel
        FROM programa_sede_asignatura_grupos psag
        JOIN grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN asignaturas_electivas_ofertadas_semestre aeos ON
          psag.codigo_programa = aeos.codigo_programa AND
          psag.codigo_asignatura = aeos.codigo_asignatura  AND
          psag.id_semestre = aeos.id_semestre
        JOIN tipos_actividades ta ON
          ga.codigo_tipo_actividad = ta.codigo
        LEFT JOIN aulas au ON
          ga.id_aula = au.id_aula
        LEFT JOIN edificios ed ON
          ed.id = au.id_edificio
        WHERE
          
          psag.codigo_sede     = :codSede AND
          ga.codigo_sede     = :codSede AND
          psag.id_jornada    = :jornada AND
          ga.id_semestre     = :semestre AND
          ga.fecha_inicio::varchar    >= :desde AND
          ga.fecha_inicio::varchar    <= :hasta
          
        GROUP BY 
          ga.codigo_programa,
          ta.nombre,
          au.numero,
          au.nombre,
          ed.id,
          ed.nombre,
          ga.codigo_asignatura,
          ga.id_actividad,
          ga.grupo,
          ga.codigo_sede,
          ga.profesor_documento_identidad,
          nivel
        )
        

--modelHistoricoProyProgramaSedeGrupos
--linea 279 hasta la 290, aun queda pendiente que hacer en la linea 296, pues alli se encuentra 

--anterior consulta-------------------------------------------------------------------------------------
(SELECT
                      pa.codigo as codigo_programa,
                      uaa.nombre as nombre_unidad,
                      m.nombre as nombre_modalidad,
                      pa.nombre as nombre_programa,
                      --cambio necesario----------------------------------------------------
                     pa.id_plan_estudio_activo 
                     ---------------------------------------------------------------------
                    FROM programa_academico pa 
                      JOIN unidad_academicoadministrativa uaa
                        ON uaa.codigo = pa.codigo_unidad
                      JOIN modalidad m
                        ON m.codigo = pa.codigo_modalidad              
                    WHERE pa.codigo = :programa)
--------------------------------------------------------------------------------------------------------
					
--nueva consulta----------------------------------------------------------------------------------------				
(SELECT
                      pa.codigo as codigo_programa,
                      uaa.nombre as nombre_unidad,
                      m.nombre as nombre_modalidad,
                      pa.nombre as nombre_programa,
                      --cambio implementado--------------------------------------------
                     pe.estado_plan 
                     -------------------------------------------------------
                    FROM programa_academico pa 
                      JOIN unidad_academicoadministrativa uaa
                        ON uaa.codigo = pa.codigo_unidad
                      JOIN modalidad m
                        ON m.codigo = pa.codigo_modalidad
                      --cambio implementado----------------------------------------------
                      JOIN plan_estudio pe             
                        ON pe.codigo_programa = pa.codigo 
					  ---------------------------------------------- 
                    WHERE pa.codigo = :programa)
--------------------------------------------------------------------------------------------------------

--modelHistoricoProyProgramaSedeGrupos
--linea 298 hasta la 328

--anterior consulta-------------------------------------------------------------------------------------
(SELECT
                            a.codigo_asignatura,
                            a.nombre_asignatura,
                            ap.codigo_tipo_asignatura,
                            
                            MIN(ap.nivel_asignatura) as nivel_asignatura,
                            NULL as clase_asignatura
                          FROM plan_estudio pe
                            JOIN asignaturas_plan ap
                              ON pe.codigo_programa = ap.codigo_programa
                                AND pe.codigo_plan = ap.codigo_plan
                            JOIN asignaturas a
                              ON ap.codigo_asignatura = a.codigo_asignatura
                          WHERE pe.codigo_plan = (select id_plan_estudio_activo from programa_academico pa2 where pa2.codigo = :programa  )
                          AND pe.codigo_programa = :programa
                          GROUP BY a.codigo_asignatura,ap.codigo_tipo_asignatura, a.nombre_asignatura
                          ORDER BY MIN(ap.nivel_asignatura), a.codigo_asignatura)
                          UNION
                          (SELECT  aeos.codigo_asignatura,
                                  a.nombre_asignatura,
                                  aeos.codigo_clase as codigo_tipo_asignatura,
                                  aeos.nivel as nivel_asignatura,
                                  ce.descripcion_clase as clase_asignatura
                            FROM asignaturas_electivas_ofertadas_semestre aeos
                            JOIN asignaturas a
                              ON aeos.codigo_asignatura = a.codigo_asignatura
                              AND aeos.codigo_programa = :programa
                              AND aeos.id_semestre = :semestre
                            JOIN clase_electiva ce
                            ON aeos.codigo_clase = ce.codigo_clase
                            where codigo_sede = :sede)
                            ORDER BY nivel_asignatura asc
--------------------------------------------------------------------------------------------------------
--nueva consulta----------------------------------------------------------------------------------------				
(SELECT
                            a.codigo_asignatura,
                            a.nombre_asignatura,
                            ap.codigo_tipo_asignatura,
                            
                            MIN(ap.nivel_asignatura) as nivel_asignatura,
                            NULL as clase_asignatura
                          FROM plan_estudio pe
                            JOIN asignaturas_plan ap
                              ON pe.codigo_programa = ap.codigo_programa
                                AND pe.codigo_plan = ap.codigo_plan
                            JOIN asignaturas a
                              ON ap.codigo_asignatura = a.codigo_asignatura
                          WHERE pe.codigo_programa = :programa
                          GROUP BY a.codigo_asignatura,ap.codigo_tipo_asignatura, a.nombre_asignatura
                          ORDER BY MIN(ap.nivel_asignatura), a.codigo_asignatura)
                          UNION
                          (SELECT  aeos.codigo_asignatura,
                                  a.nombre_asignatura,
                                  aeos.codigo_clase as codigo_tipo_asignatura,
                                  aeos.nivel as nivel_asignatura,
                                  ce.descripcion_clase as clase_asignatura
                            FROM asignaturas_electivas_ofertadas_semestre aeos
                            JOIN asignaturas a
                              ON aeos.codigo_asignatura = a.codigo_asignatura
                              AND aeos.codigo_programa = :programa
                              AND aeos.id_semestre = :semestre
                            JOIN clase_electiva ce
                            ON aeos.codigo_clase = ce.codigo_clase
                            where codigo_sede = :sede)
                            ORDER BY nivel_asignatura asc
--------------------------------------------------------------------------------------------------------


--modelProgramaAcademico.js
--linea 13 existe el parametro "id_plan_estudio_activo"
--anterior consulta-------------------------------------------------------------------------------------
  id_plan_estudio_activo: null
--------------------------------------------------------------------------------------------------------

--nueva consulta----------------------------------------------------------------------------------------				
  "---------------"
--------------------------------------------------------------------------------------------------------


--modelProyGrupoActividades.js
--linea 125 hasta 214

--linea 13 existe el parametro "id_plan_estudio_activo"
--anterior consulta-------------------------------------------------------------------------------------
(
        SELECT psag.*,
          MIN(aplan.nivel_asignatura) AS nivel,
          CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          STRING_AGG(gh.codigo_gh::character varying, ', ') as codigos_gh,
          STRING_AGG(gh.nombre_gh, ', ') as nombres_gh
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN persona p ON
          p.documento_identidad = psag.profesor_documento_identidad
        JOIN asignaturas a ON
          a.codigo_asignatura = psag.codigo_asignatura
        JOIN programa_academico pa ON
          psag.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          psag.codigo_programa = aplan.codigo_programa AND
          psag.codigo_asignatura = aplan.codigo_asignatura and
          --cambio necesario.-------
          pa.id_plan_estudio_activo = aplan.codigo_plan
          ---------------------
        LEFT JOIN gh_ppsag ghp ON
          psag.codigo_programa = ghp.codigo_programa AND
          psag.profesor_documento_identidad = ghp.profesor_documento_identidad AND
          psag.id_semestre = ghp.id_semestre AND
          psag.codigo_asignatura = ghp.codigo_asignatura AND
          psag.codigo_sede = ghp.codigo_sede AND
          psag.grupo = ghp.grupo
        LEFT JOIN grupo_homologacion gh ON
          gh.codigo_gh = ghp.codigo_gh
        WHERE 
          psag.codigo_programa in (:programas) AND
          psag.codigo_sede in (:sedes) AND
          psag.id_jornada in (:jornadas) AND
          psag.id_semestre     = :semestre AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          psag.codigo_programa,
          psag.codigo_asignatura,
          psag.grupo,
          psag.codigo_sede,
          psag.id_semestre,
          nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          psag.profesor_documento_identidad
        ORDER BY profesor_documento_identidad

      ) UNION (

        SELECT psag.*,
          aeos.nivel,
          CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          STRING_AGG(gh.codigo_gh::character varying, ', ') as codigos_gh,
          STRING_AGG(gh.nombre_gh, ', ') as nombres_gh
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN asignaturas_electivas_ofertadas_semestre aeos ON
          psag.codigo_programa = aeos.codigo_programa AND
          psag.codigo_asignatura = aeos.codigo_asignatura  and
          aeos.id_semestre= psag.id_semestre
        JOIN persona p ON
          p.documento_identidad = psag.profesor_documento_identidad
        JOIN asignaturas a ON
          a.codigo_asignatura = psag.codigo_asignatura
        LEFT JOIN gh_ppsag ghp ON
          psag.codigo_programa = ghp.codigo_programa AND
          psag.profesor_documento_identidad = ghp.profesor_documento_identidad AND
          psag.id_semestre = ghp.id_semestre AND
          psag.codigo_asignatura = ghp.codigo_asignatura AND
          psag.codigo_sede = ghp.codigo_sede AND
          psag.grupo = ghp.grupo
        LEFT JOIN grupo_homologacion gh ON
          gh.codigo_gh = ghp.codigo_gh
        WHERE 
          psag.codigo_programa in (:programas) AND
          psag.codigo_sede in (:sedes) AND
          psag.id_jornada in (:jornadas) AND
          psag.id_semestre     = :semestre AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          psag.codigo_programa,
          psag.codigo_asignatura,
          psag.grupo,
          psag.codigo_sede,
          psag.id_semestre,
          nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          psag.profesor_documento_identidad,
          nivel
        ORDER BY profesor_documento_identidad);
--------------------------------------------------------------------------------------------------------

--nueva consulta----------------------------------------------------------------------------------------				
 (
        SELECT psag.*,
          MIN(aplan.nivel_asignatura) AS nivel,
          CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          STRING_AGG(gh.codigo_gh::character varying, ', ') as codigos_gh,
          STRING_AGG(gh.nombre_gh, ', ') as nombres_gh
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN persona p ON
          p.documento_identidad = psag.profesor_documento_identidad
        JOIN asignaturas a ON
          a.codigo_asignatura = psag.codigo_asignatura
        JOIN programa_academico pa ON
          psag.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          psag.codigo_programa = aplan.codigo_programa AND
          psag.codigo_asignatura = aplan.codigo_asignatura  
          --cambio implementado-------------------------
          JOIN plan_estudio pe on aplan.codigo_plan =pe.codigo_plan 
			and pe.codigo_programa = aplan.codigo_programa
          ----------------------------------------------  
        LEFT JOIN gh_ppsag ghp ON
          psag.codigo_programa = ghp.codigo_programa AND
          psag.profesor_documento_identidad = ghp.profesor_documento_identidad AND
          psag.id_semestre = ghp.id_semestre AND
          psag.codigo_asignatura = ghp.codigo_asignatura AND
          psag.codigo_sede = ghp.codigo_sede AND
          psag.grupo = ghp.grupo
        LEFT JOIN grupo_homologacion gh ON
          gh.codigo_gh = ghp.codigo_gh
        WHERE 
          psag.codigo_programa in (:programas) AND
          psag.codigo_sede in (:sedes) AND
          psag.id_jornada in (:jornadas) AND
          psag.id_semestre     = :semestre AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          psag.codigo_programa,
          psag.codigo_asignatura,
          psag.grupo,
          psag.codigo_sede,
          psag.id_semestre,
          nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          psag.profesor_documento_identidad
        ORDER BY profesor_documento_identidad

      ) UNION (

        SELECT psag.*,
          aeos.nivel,
          CONCAT_WS( ' ',p.primer_nombre, p.segundo_nombre, p.primer_apellido, p.segundo_apellido) AS nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          STRING_AGG(gh.codigo_gh::character varying, ', ') as codigos_gh,
          STRING_AGG(gh.nombre_gh, ', ') as nombres_gh
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN asignaturas_electivas_ofertadas_semestre aeos ON
          psag.codigo_programa = aeos.codigo_programa AND
          psag.codigo_asignatura = aeos.codigo_asignatura  and
          aeos.id_semestre= psag.id_semestre
        JOIN persona p ON
          p.documento_identidad = psag.profesor_documento_identidad
        JOIN asignaturas a ON
          a.codigo_asignatura = psag.codigo_asignatura
        LEFT JOIN gh_ppsag ghp ON
          psag.codigo_programa = ghp.codigo_programa AND
          psag.profesor_documento_identidad = ghp.profesor_documento_identidad AND
          psag.id_semestre = ghp.id_semestre AND
          psag.codigo_asignatura = ghp.codigo_asignatura AND
          psag.codigo_sede = ghp.codigo_sede AND
          psag.grupo = ghp.grupo
        LEFT JOIN grupo_homologacion gh ON
          gh.codigo_gh = ghp.codigo_gh
        WHERE 
          psag.codigo_programa in (:programas) AND
          psag.codigo_sede in (:sedes) AND
          psag.id_jornada in (:jornadas) AND
          psag.id_semestre     = :semestre AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          psag.codigo_programa,
          psag.codigo_asignatura,
          psag.grupo,
          psag.codigo_sede,
          psag.id_semestre,
          nombre_profesor,
          a.nombre_asignatura,
          p.documento_identidad,
          psag.profesor_documento_identidad,
          nivel
        ORDER BY profesor_documento_identidad);
--------------------------------------------------------------------------------------------------------




--modelProgramaActividades.js
--linea 230 hasta 329
--anterior consulta-------------------------------------------------------------------------------------
(
        SELECT ga.*,
          psag.id_jornada,
          ta.nombre AS nombre_tipo_actividad,
          au.numero AS numero_aula,
          au.nombre AS nombre_aula,
          ed.id AS id_edificio,
          ed.nombre AS nombre_edificio,
          MIN(aplan.nivel_asignatura) AS nivel
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN proy_grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN programa_academico pa ON
          psag.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          psag.codigo_programa = aplan.codigo_programa AND
          psag.codigo_asignatura = aplan.codigo_asignatura AND
           --cambio necesario.-------
          pa.id_plan_estudio_activo = aplan.codigo_plan
          ---------------------
        JOIN tipos_actividades ta ON
          ga.codigo_tipo_actividad = ta.codigo
        LEFT JOIN aulas au ON
          ga.id_aula = au.id_aula
        LEFT JOIN edificios ed ON
          ed.id = au.id_edificio
        WHERE 
          ga.codigo_programa in (:programas) AND 
          ga.codigo_sede in (:sedes) AND 
          psag.id_jornada in (:jornadas) AND
          ga.id_semestre     = :semestre AND
          ga.fecha_inicio::varchar    >= :desde AND
          (ga.migrado != 'eliminado' or ga.migrado is null) AND
          ga.fecha_inicio::varchar    <= :hasta AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          psag.id_jornada,
          ga.codigo_programa,
          ta.nombre,
          au.numero,
          au.nombre,
          ed.id,
          ed.nombre,
          ga.codigo_asignatura,
          ga.id_actividad,
          ga.grupo,
          ga.codigo_sede,
          ga.profesor_documento_identidad
        ) UNION (
        SELECT ga.*,
          psag.id_jornada,
          ta.nombre AS nombre_tipo_actividad,
          au.numero AS numero_aula,
          au.nombre AS nombre_aula,
          ed.id AS id_edificio,
          ed.nombre AS nombre_edificio,
          aeos.nivel
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN proy_grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN asignaturas_electivas_ofertadas_semestre aeos ON
          psag.codigo_programa = aeos.codigo_programa AND
          psag.codigo_asignatura = aeos.codigo_asignatura  AND
          psag.id_semestre = aeos.id_semestre
        JOIN tipos_actividades ta ON
          ga.codigo_tipo_actividad = ta.codigo
        LEFT JOIN aulas au ON
          ga.id_aula = au.id_aula
        LEFT JOIN edificios ed ON
          ed.id = au.id_edificio
        WHERE 
          ga.codigo_programa in (:programas) AND 
          ga.codigo_sede in (:sedes) AND 
          psag.id_jornada in (:jornadas) AND
          ga.id_semestre     = :semestre AND
          ga.fecha_inicio::varchar    >= :desde AND
          (ga.migrado != 'eliminado' or ga.migrado is null) AND
          ga.fecha_inicio::varchar    <= :hasta AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          psag.id_jornada,
          ga.codigo_programa,
          ta.nombre,
          au.numero,
          au.nombre,
          ed.id,
          ed.nombre,
          ga.codigo_asignatura,
          ga.id_actividad,
          ga.grupo,
          ga.codigo_sede,
          ga.profesor_documento_identidad,
          nivel);
--------------------------------------------------------------------------------------------------------

--nueva consulta----------------------------------------------------------------------------------------				
 (
        SELECT ga.*,
          psag.id_jornada,
          ta.nombre AS nombre_tipo_actividad,
          au.numero AS numero_aula,
          au.nombre AS nombre_aula,
          ed.id AS id_edificio,
          ed.nombre AS nombre_edificio,
          MIN(aplan.nivel_asignatura) AS nivel
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN proy_grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN programa_academico pa ON
          psag.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          psag.codigo_programa = aplan.codigo_programa AND
          psag.codigo_asignatura = aplan.codigo_asignatura
          --cambio implementado-------------------------
          JOIN plan_estudio pe on aplan.codigo_plan =pe.codigo_plan 
			and pe.codigo_programa = aplan.codigo_programa
          ----------------------------------------------  
        JOIN tipos_actividades ta ON
          ga.codigo_tipo_actividad = ta.codigo
        LEFT JOIN aulas au ON
          ga.id_aula = au.id_aula
        LEFT JOIN edificios ed ON
          ed.id = au.id_edificio
        WHERE 
          ga.codigo_programa in (:programas) AND 
          ga.codigo_sede in (:sedes) AND 
          psag.id_jornada in (:jornadas) AND
          ga.id_semestre     = :semestre AND
          ga.fecha_inicio::varchar    >= :desde AND
          (ga.migrado != 'eliminado' or ga.migrado is null) AND
          ga.fecha_inicio::varchar    <= :hasta AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          psag.id_jornada,
          ga.codigo_programa,
          ta.nombre,
          au.numero,
          au.nombre,
          ed.id,
          ed.nombre,
          ga.codigo_asignatura,
          ga.id_actividad,
          ga.grupo,
          ga.codigo_sede,
          ga.profesor_documento_identidad
        ) UNION (
        SELECT ga.*,
          psag.id_jornada,
          ta.nombre AS nombre_tipo_actividad,
          au.numero AS numero_aula,
          au.nombre AS nombre_aula,
          ed.id AS id_edificio,
          ed.nombre AS nombre_edificio,
          aeos.nivel
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN proy_grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN asignaturas_electivas_ofertadas_semestre aeos ON
          psag.codigo_programa = aeos.codigo_programa AND
          psag.codigo_asignatura = aeos.codigo_asignatura  AND
          psag.id_semestre = aeos.id_semestre
        JOIN tipos_actividades ta ON
          ga.codigo_tipo_actividad = ta.codigo
        LEFT JOIN aulas au ON
          ga.id_aula = au.id_aula
        LEFT JOIN edificios ed ON
          ed.id = au.id_edificio
        WHERE 
          ga.codigo_programa in (:programas) AND 
          ga.codigo_sede in (:sedes) AND 
          psag.id_jornada in (:jornadas) AND
          ga.id_semestre     = :semestre AND
          ga.fecha_inicio::varchar    >= :desde AND
          (ga.migrado != 'eliminado' or ga.migrado is null) AND
          ga.fecha_inicio::varchar    <= :hasta AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          psag.id_jornada,
          ga.codigo_programa,
          ta.nombre,
          au.numero,
          au.nombre,
          ed.id,
          ed.nombre,
          ga.codigo_asignatura,
          ga.id_actividad,
          ga.grupo,
          ga.codigo_sede,
          ga.profesor_documento_identidad,
          nivel);
--------------------------------------------------------------------------------------------------------



--modelProgramaActividades.js
--linea 344 hasta 434

--anterior consulta-------------------------------------------------------------------------------------
(
        SELECT 
          ga.codigo_sede,
          SUM(EXTRACT(hour from (ga.fecha_fin - ga.fecha_inicio) )+ 24*EXTRACT(day from (fecha_fin - fecha_inicio) )) as horas, ta.nombre,
          ga.codigo_programa,
          ga.codigo_asignatura,
          ga.id_semestre,
          ga.grupo,
          ga.profesor_documento_identidad,
          MIN(aplan.nivel_asignatura) AS nivel,
          ta.codigo,
          ta.nombre
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN proy_grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN tipos_actividades ta ON 
          ta.codigo = ga.codigo_tipo_actividad
        JOIN programa_academico pa ON
          ga.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          ga.codigo_programa = aplan.codigo_programa AND
          ga.codigo_asignatura = aplan.codigo_asignatura and
          ---------------cambio necesario---------------------------------------------
          pa.id_plan_estudio_activo = aplan.codigo_plan
          ----------------------------------------------------------------------------
        WHERE 
          ga.codigo_programa in (:programas) AND 
          ga.codigo_sede in (:sedes) AND 
          psag.id_jornada in (:jornadas) AND
          ga.codigo_tipo_actividad <> 13 AND
          ga.id_semestre     = :semestre AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          ga.codigo_sede,
          ga.codigo_programa,
          ga.codigo_asignatura,
          ga.id_semestre,
          ga.grupo,
          ga.profesor_documento_identidad,
          ta.codigo,
          ta.nombre
        ORDER BY 
          ta.codigo,
          ta.nombre
        ) UNION(
          SELECT 
            ga.codigo_sede,
            SUM(EXTRACT(hour from (ga.fecha_fin - ga.fecha_inicio) )+ 24*EXTRACT(day from (fecha_fin - fecha_inicio) )) as horas, ta.nombre,
            ga.codigo_programa,
            ga.codigo_asignatura,
            ga.id_semestre,
            ga.grupo,
            ga.profesor_documento_identidad,
            aeos.nivel,
            ta.codigo,
            ta.nombre
          FROM proy_programa_sede_asignatura_grupos psag
          JOIN proy_grupos_actividades ga ON 
            psag.codigo_programa              = ga.codigo_programa AND
            psag.codigo_sede                  = ga.codigo_sede AND
            psag.codigo_asignatura            = ga.codigo_asignatura AND
            psag.id_semestre                  = ga.id_semestre AND
            psag.grupo                        = ga.grupo AND
            psag.profesor_documento_identidad = ga.profesor_documento_identidad
          JOIN tipos_actividades ta ON 
            ta.codigo = ga.codigo_tipo_actividad
          JOIN asignaturas_electivas_ofertadas_semestre aeos ON
            psag.codigo_programa = aeos.codigo_programa AND
            psag.codigo_asignatura = aeos.codigo_asignatura  AND
            psag.id_semestre = aeos.id_semestre
          WHERE 
            ga.codigo_programa in (:programas) AND 
            ga.codigo_sede in (:sedes) AND 
            psag.id_jornada in (:jornadas) AND
            ga.codigo_tipo_actividad <> 13 AND
            ga.id_semestre     = :semestre AND
            ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
          GROUP BY
            ga.codigo_sede,
            ga.codigo_programa,
            ga.codigo_asignatura,
            ga.id_semestre,
            ga.grupo,
            ga.profesor_documento_identidad,
            ta.codigo,
            ta.nombre,
            nivel
          ORDER BY 
            ta.codigo,
            ta.nombre);
--------------------------------------------------------------------------------------------------------

--nueva consulta----------------------------------------------------------------------------------------				
 (
        SELECT 
          ga.codigo_sede,
          SUM(EXTRACT(hour from (ga.fecha_fin - ga.fecha_inicio) )+ 24*EXTRACT(day from (fecha_fin - fecha_inicio) )) as horas, ta.nombre,
          ga.codigo_programa,
          ga.codigo_asignatura,
          ga.id_semestre,
          ga.grupo,
          ga.profesor_documento_identidad,
          MIN(aplan.nivel_asignatura) AS nivel,
          ta.codigo,
          ta.nombre
        FROM proy_programa_sede_asignatura_grupos psag
        JOIN proy_grupos_actividades ga ON 
          psag.codigo_programa              = ga.codigo_programa AND
          psag.codigo_sede                  = ga.codigo_sede AND
          psag.codigo_asignatura            = ga.codigo_asignatura AND
          psag.id_semestre                  = ga.id_semestre AND
          psag.grupo                        = ga.grupo AND
          psag.profesor_documento_identidad = ga.profesor_documento_identidad
        JOIN tipos_actividades ta ON 
          ta.codigo = ga.codigo_tipo_actividad
        JOIN programa_academico pa ON
          ga.codigo_programa = pa.codigo 
        JOIN asignaturas_plan aplan ON
          ga.codigo_programa = aplan.codigo_programa AND
          ga.codigo_asignatura = aplan.codigo_asignatura 
          --cambio implementado-------------------------
          JOIN plan_estudio pe on aplan.codigo_plan =pe.codigo_plan 
			and pe.codigo_programa = aplan.codigo_programa
          ---------------------------------------------- 
        WHERE 
          ga.codigo_programa in (:programas) AND 
          ga.codigo_sede in (:sedes) AND 
          psag.id_jornada in (:jornadas) AND
          ga.codigo_tipo_actividad <> 13 AND
          ga.id_semestre     = :semestre AND
          ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
        GROUP BY
          ga.codigo_sede,
          ga.codigo_programa,
          ga.codigo_asignatura,
          ga.id_semestre,
          ga.grupo,
          ga.profesor_documento_identidad,
          ta.codigo,
          ta.nombre
        ORDER BY 
          ta.codigo,
          ta.nombre
        ) UNION(
          SELECT 
            ga.codigo_sede,
            SUM(EXTRACT(hour from (ga.fecha_fin - ga.fecha_inicio) )+ 24*EXTRACT(day from (fecha_fin - fecha_inicio) )) as horas, ta.nombre,
            ga.codigo_programa,
            ga.codigo_asignatura,
            ga.id_semestre,
            ga.grupo,
            ga.profesor_documento_identidad,
            aeos.nivel,
            ta.codigo,
            ta.nombre
          FROM proy_programa_sede_asignatura_grupos psag
          JOIN proy_grupos_actividades ga ON 
            psag.codigo_programa              = ga.codigo_programa AND
            psag.codigo_sede                  = ga.codigo_sede AND
            psag.codigo_asignatura            = ga.codigo_asignatura AND
            psag.id_semestre                  = ga.id_semestre AND
            psag.grupo                        = ga.grupo AND
            psag.profesor_documento_identidad = ga.profesor_documento_identidad
          JOIN tipos_actividades ta ON 
            ta.codigo = ga.codigo_tipo_actividad
          JOIN asignaturas_electivas_ofertadas_semestre aeos ON
            psag.codigo_programa = aeos.codigo_programa AND
            psag.codigo_asignatura = aeos.codigo_asignatura  AND
            psag.id_semestre = aeos.id_semestre
          WHERE 
            ga.codigo_programa in (:programas) AND 
            ga.codigo_sede in (:sedes) AND 
            psag.id_jornada in (:jornadas) AND
            ga.codigo_tipo_actividad <> 13 AND
            ga.id_semestre     = :semestre AND
            ( psag.decision in ('true','null') OR psag.decision IS NULL OR psag.profesor_documento_identidad = '0')
          GROUP BY
            ga.codigo_sede,
            ga.codigo_programa,
            ga.codigo_asignatura,
            ga.id_semestre,
            ga.grupo,
            ga.profesor_documento_identidad,
            ta.codigo,
            ta.nombre,
            nivel
          ORDER BY 
            ta.codigo,
            ta.nombre);
--------------------------------------------------------------------------------------------------------


--modelProgramaActividades.js
--linea 261 hasta 291

--anterior consulta-------------------------------------------------------------------------------------
(SELECT
                      a.codigo_asignatura,
                      a.nombre_asignatura,
                      ap.codigo_tipo_asignatura,
                      MIN(ap.nivel_asignatura) as nivel_asignatura,
                      NULL as clase_asignatura
                    FROM plan_estudio pe
                      JOIN asignaturas_plan ap
                        ON pe.codigo_programa = ap.codigo_programa
                          AND pe.codigo_plan = ap.codigo_plan
                      JOIN asignaturas a
                        ON ap.codigo_asignatura = a.codigo_asignatura
                    WHERE pe.codigo_plan = (select id_plan_estudio_activo from programa_academico pa2 where pa2.codigo = :codigoPrograma  )
                    AND pe.codigo_programa = :codigoPrograma
                    GROUP BY a.codigo_asignatura,ap.codigo_tipo_asignatura, a.nombre_asignatura 
                    ORDER BY MIN(ap.nivel_asignatura), a.codigo_asignatura)
                    UNION
                    (SELECT  aeos.codigo_asignatura,
                            a.nombre_asignatura,
                            aeos.codigo_clase as codigo_tipo_asignatura,
                            aeos.nivel as nivel_asignatura,
                            ce.descripcion_clase as clase_asignatura
                      FROM asignaturas_electivas_ofertadas_semestre aeos
                      JOIN asignaturas a
                        ON aeos.codigo_asignatura = a.codigo_asignatura
                        AND aeos.codigo_programa = :codigoPrograma
                        AND aeos.id_semestre = :semestre
                      JOIN clase_electiva ce
                      ON aeos.codigo_clase = ce.codigo_clase
                      where codigo_sede = :codigoSede)
                      ORDER BY nivel_asignatura asc

--nueva consulta----------------------------------------------------------------------------------------				
   (select
               		
                      a.codigo_asignatura,
                      a.nombre_asignatura,
                      ap.codigo_tipo_asignatura,
                      MIN(ap.nivel_asignatura) as nivel_asignatura,
                      NULL as clase_asignatura
                    FROM plan_estudio pe
                      JOIN asignaturas_plan ap
                        ON pe.codigo_programa = ap.codigo_programa
                          AND pe.codigo_plan = ap.codigo_plan
                      JOIN asignaturas a
                        ON ap.codigo_asignatura = a.codigo_asignatura
                     
                        
                    
                                     
                        
                        WHERE pe.codigo_programa = :codigoPrograma
                        and pe.estado_plan = 'activo'
                    GROUP BY a.codigo_asignatura,ap.codigo_tipo_asignatura, a.nombre_asignatura, pe.codigo_programa
                    ORDER BY MIN(ap.nivel_asignatura), a.codigo_asignatura)
                    UNION
                    (SELECT  
                    
                    aeos.codigo_asignatura,
                            a.nombre_asignatura,
                            aeos.codigo_clase as codigo_tipo_asignatura,
                            aeos.nivel as nivel_asignatura,
                            ce.descripcion_clase as clase_asignatura
                      FROM asignaturas_electivas_ofertadas_semestre aeos
                      JOIN asignaturas a
                        ON aeos.codigo_asignatura = a.codigo_asignatura
                        AND aeos.codigo_programa = :codigoPrograma
                        AND aeos.id_semestre = :semestre
                      JOIN clase_electiva ce
                      ON aeos.codigo_clase = ce.codigo_clase
                      where codigo_sede = :codigoSede)
                      ORDER BY nivel_asignatura asc



