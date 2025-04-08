

WITH companyies_electriques AS (
    SELECT * FROM HSU.int_bst_expedientes
),

dops AS (
    SELECT * FROM HSU.stg_bst_DOP
),

mapeo_municipis AS (
    SELECT * FROM HSU.raw_mapeo_municipios
),

master_municipis AS (
    SELECT * FROM HSU.raw_master_municipios
),

anios_resolts AS (
    SELECT * FROM HSU.raw_anios_resolts
),

anios_resolts AS (
    SELECT * FROM HSU.raw_anios_resolts
),

zones AS (
    SELECT * FROM HSU.raw_zones
),

hereus AS (
    SELECT * FROM HSU.raw_hereus
),

tipus_pagament AS (
    SELECT * FROM HSU.raw_tipus_pagament
)

SELECT DISTINCT
    CENTRO_GESTOR,
    PARTIDA,
    FONDO,
    CASE
        WHEN h.DNI_HEREU IS NOT NULL THEN
            CASE
                WHEN h.DNI_BENEFICIARI_BST in (select distinct documentacion from companyies_electriques where anio = dop.anio) THEN h.DNI_BENEFICIARI_BST
                ELSE h.DNI_HEREU
            END
        ELSE dop.NIF
    END AS DOCUMENTACION,
    dop.IMPORTE AS IMPORT, 
    dop.IBAN,
    dop.NOMBRE,
    dop.DIRECCION,
    dop.CP AS CODIGO_POSTAL,
    dop.PROVINCIA,
    REFE_CONCESION,
    REGION,
    TIPO_BENEFICIARIO,
    SECTOR_ECONOMICO,
    COSTE_ACTIVIDAD,
    REGION_CONCESION,
    dop.CODIGO_MUNICIPIO AS MUNICIPIO,
    dop.ANIO,
    masmu.NOMBRE AS NOMBRE_MUNICIPIO,
    masmu.CODIGO_INE AS CODIGO_MUNICIPIO_INE,
    masmu.ZONA_GEOGRAFICA AS ZONA_GEOGRAFICA,
    z.ZONA_CLIMATICA AS ZONA_CLIMATICA,
    CASE
        WHEN ce.CONSIDERACION = 'VS' THEN 'Vulnerable Greu'
        WHEN ce.CONSIDERACION = 'VU' THEN 'Vulnerable'
        WHEN ce.CONSIDERACION is null THEN 
        CASE 
            WHEN tp.VULNERABILIDAD = 'VU' THEN 'Vulnerable'
            WHEN tp.VULNERABILIDAD = 'VS' THEN 'Vulnerable Greu'
            WHEN tp.VULNERABILIDAD = 'EX' THEN 'Vulnerable Greu'
        END
        ELSE ce.CONSIDERACION
    END AS CONSIDERACION,
    ar.resuelto as ANIO_RESOLT
FROM dops dop
JOIN mapeo_municipis mapmu
    ON TO_NUMBER(dop.CODIGO_MUNICIPIO) = TO_NUMBER(mapmu.CODIGO_BST)
JOIN master_municipis masmu
    ON TO_NUMBER(mapmu.CODIGO_INE) = TO_NUMBER(masmu.CODIGO_INE)
LEFT JOIN zones z
    ON TO_NUMBER(dop.codigo_municipio) = TO_NUMBER(z.codigo_municipio)
LEFT JOIN companyies_electriques ce
    ON TRIM(ce.DOCUMENTACION) = TRIM(dop.NIF)
    AND ce.ANIO = dop.ANIO
LEFT JOIN tipus_pagament tp
    ON z.ZONA_CLIMATICA = tp.ZONA
    AND TO_NUMBER(dop.ANIO) = TO_NUMBER(tp.ANIO)
    AND dop.IMPORTE = tp.IMPORT
LEFT JOIN anios_resolts ar
    ON TO_NUMBER(dop.ANIO) = TO_NUMBER(ar.ANIO)
LEFT JOIN hereus h
    ON dop.NIF = h.DNI_BENEFICIARI_BST
    OR dop.NIF = h.DNI_HEREU