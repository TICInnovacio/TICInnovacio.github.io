



WITH filtered_data AS (
    SELECT 
        DOCUMENTACION,
        TIPO_DOCUMENTACION, 
        NOMBRE,
        NOMBRE_Y_APELLIDOS,
        APELLIDO1,
        APELLIDO2,
        APELLIDOS,
        MAIL,
        MAIL_1,
        MAIL_2,
        TELEFONO,
        TELEFONO_1,
        TELEFONO_2,
        TELEFONO_3,
        CONSIDERACION,
        DIRECCION,
        TIPO_VIA,
        NOMBRE_VIA,
        NUMERO,
        BLOQUE,
        PORTAL,
        ESCALERA,
        PISO,
        PUERTA,
        PROVINCIA,
        MUNICIPIO,
        CODIGO_POSTAL,
        CUENTA_BANCARIA,
        COMERCIALIZADORA,
        ANIO,
        FECHA_INSERCION,
        ROW_NUMBER() OVER (ORDER BY ANIO) AS row_id
        FROM HSU.stg_bst_CE
),

codis_postals AS (
    SELECT 
        CODIGO_MUNICIPIO,
        municipio,
        codigo_postal
    FROM HSU.raw_codis_postal
),


mapeo_municipis AS (
    SELECT * FROM HSU.raw_mapeo_municipios
),

master_municipis AS (
    SELECT * FROM HSU.raw_master_municipios
),

zones AS (
    SELECT * FROM HSU.raw_zones
),

anios_resolts AS (
    SELECT * FROM HSU.raw_anios_resolts
),

tipus_pagaments AS (
    SELECT
        anio,
        import,
        vulnerabilidad,
        reforç,
        zona
    FROM HSU.raw_tipus_pagament
),

consideracion AS (
    SELECT
        CASE
            WHEN UPPER(CONSIDERACION) IN ('VU', 'VULNERABLE', 'CONSUMIDOR VULNERABLE') THEN 'Vulnerable'
            WHEN UPPER(CONSIDERACION) IN ('VS', 'VULNERABLE SEVERO', 'CONSUMIDOR VULNERABLE SEVERO', 'EX', 'RE') THEN 'Vulnerable Greu'
            ELSE CONSIDERACION 
        END AS CONSIDERACION,
        CASE
            WHEN UPPER(CONSIDERACION) IN ('VU', 'VULNERABLE', 'CONSUMIDOR VULNERABLE') THEN 'VU'
            WHEN UPPER(CONSIDERACION) IN ('VS', 'VULNERABLE SEVERO', 'CONSUMIDOR VULNERABLE SEVERO', 'EX', 'RE') THEN 'VS'
            ELSE CONSIDERACION 
        END AS CONSIDERACION_CODE,
        ROW_NUMBER() OVER (ORDER BY ANIO) AS row_id
    FROM companyies_electriques
),

nombre AS(
    SELECT
        CASE
            WHEN cen.NOMBRE IS NOT NULL AND cen.APELLIDO1 IS NOT NULL THEN cen.NOMBRE
            WHEN cen.NOMBRE IS NOT NULL AND cen.APELLIDO1 IS NULL AND cen.APELLIDOS IS NOT NULL THEN cen.NOMBRE || ' ' || cen.APELLIDOS
            WHEN cen.NOMBRE IS NULL AND cen.NOMBRE_Y_APELLIDOS IS NOT NULL THEN cen.NOMBRE_Y_APELLIDOS
            ELSE NULL
        END AS NOMBRE,

        CASE
            WHEN cen.APELLIDO1 IS NOT NULL THEN cen.APELLIDO1
            ELSE NULL
        END AS APELLIDO1,

        CASE
            WHEN cen.APELLIDO2 IS NOT NULL THEN cen.APELLIDO2
            ELSE NULL
        END AS APELLIDO2,
        row_id
    FROM companyies_electriques cen
)

SELECT
    ce.TIPO_DOCUMENTACION,
    ce.DOCUMENTACION,
    '***' || SUBSTR(ce.DOCUMENTACION, 4, 4) || '**' AS DNI_ANONIMO,
    nom.NOMBRE,
    nom.APELLIDO1,
    nom.APELLIDO2,
    LOWER(
        CASE
            WHEN LENGTH(nom.NOMBRE) - LENGTH(REPLACE(nom.NOMBRE, ' ', '')) > 0 THEN
                SUBSTR(nom.NOMBRE, 1, 1) || 
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 2), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 3), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 4), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 5), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 6), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 7), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 8), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 9), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.NOMBRE, '\w+', 1, 10), 1, 1)
            ELSE
                SUBSTR(nom.NOMBRE, 1, 1)
        END ||
        CASE
            WHEN LENGTH(nom.APELLIDO1) - LENGTH(REPLACE(nom.APELLIDO1, ' ', '')) > 0 THEN
                SUBSTR(nom.APELLIDO1, 1, 1) || 
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO1, '\w+', 1, 2), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO1, '\w+', 1, 3), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO1, '\w+', 1, 4), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO1, '\w+', 1, 5), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO1, '\w+', 1, 6), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO1, '\w+', 1, 7), 1, 1)
            ELSE
                SUBSTR(nom.APELLIDO1, 1, 1)
        END ||
        CASE
            WHEN LENGTH(nom.APELLIDO2) - LENGTH(REPLACE(nom.APELLIDO2, ' ', '')) > 0 THEN
                SUBSTR(nom.APELLIDO2, 1, 1) || 
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO2, '\w+', 1, 2), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO2, '\w+', 1, 3), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO2, '\w+', 1, 4), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO2, '\w+', 1, 5), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO2, '\w+', 1, 6), 1, 1) ||
                SUBSTR(REGEXP_SUBSTR(nom.APELLIDO2, '\w+', 1, 7), 1, 1)
            ELSE
                SUBSTR(nom.APELLIDO2, 1, 1)
        END
    ) AS INICIALS_NOM_I_2_LLINATGES,
    COALESCE(ce.MAIL, ce.MAIL_1, ce.MAIL_2) AS MAIL,
    COALESCE(ce.TELEFONO, ce.TELEFONO_1, ce.TELEFONO_2, ce.TELEFONO_3) AS TELEFONO,
    c.CONSIDERACION,
    CASE 
        WHEN ce.DIRECCION IS NOT NULL THEN ce.DIRECCION
        ELSE ce.TIPO_VIA || ' ' || ce.NOMBRE_VIA || ' ' || ce.NUMERO || ' ' || ce.BLOQUE || ' ' || ce.PORTAL || ' ' || ce.ESCALERA || ' ' || ce.PISO || ' ' || ce.PUERTA
    END AS DIRECCION,
    ce.PROVINCIA AS PROVINCIA,
    cp.codigo_municipio as MUNICIPIO,
    TO_CHAR(cp.codigo_postal) as CODIGO_POSTAL,
    ce.CUENTA_BANCARIA,
    ce.COMERCIALIZADORA,
    ce.ANIO,
    z.zona_climatica as ZONA_CLIMATICA,
    masmu.zona_geografica as ZONA_GEOGRAFICA,
    masmu.nombre as NOMBRE_MUNICIPIO,
    TO_NUMBER(masmu.codigo_ine) as CODIGO_MUNICIPIO_INE,
    tp.import as IMPORTE,
    ar.resuelto as ANIO_RESOLT

FROM companyies_electriques ce
LEFT JOIN consideracion c
    ON ce.row_id = c.row_id
LEFT JOIN nombre nom
    ON ce.row_id = nom.row_id
LEFT JOIN codis_postals cp
    ON TO_NUMBER(ce.CODIGO_POSTAL) = TO_NUMBER(cp.codigo_postal)
LEFT JOIN zones z
    ON TO_NUMBER(cp.codigo_municipio) = TO_NUMBER(z.codigo_municipio)
JOIN mapeo_municipis mapmu
    ON TO_NUMBER(cp.codigo_municipio) = TO_NUMBER(mapmu.codigo_bst)
JOIN master_municipis masmu
    ON TO_NUMBER(mapmu.codigo_ine) = TO_NUMBER(masmu.codigo_ine)
LEFT JOIN tipus_pagaments tp
    ON z.zona_climatica = tp.zona
    AND TO_NUMBER(ce.anio) = TO_NUMBER(tp.anio)
    AND c.CONSIDERACION_CODE = tp.vulnerabilidad
    AND tp.reforç = 'false'
LEFT JOIN anios_resolts ar
    ON TO_NUMBER(ce.ANIO) = TO_NUMBER(ar.ANIO)
ORDER BY 
    ce.ANIO