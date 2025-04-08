

WITH companyies_electriques AS (
    SELECT * FROM HSU.int_bst_expedientes
),

dops AS (
    SELECT * FROM HSU.stg_bst_DOP
)

SELECT
    ce.DOCUMENTACION,
    ce.CONSIDERACION,
    ce.PROVINCIA,
    ce.MUNICIPIO,
    ce.NOMBRE_MUNICIPIO,
    ce.CODIGO_MUNICIPIO_INE,
    ce.CODIGO_POSTAL,
    ce.COMERCIALIZADORA,
    ce.ANIO,
    ce.ZONA_CLIMATICA,
    ce.ZONA_GEOGRAFICA,
    ce.IMPORTE as IMPORT
FROM companyies_electriques ce
WHERE NOT EXISTS (
    SELECT 1 FROM dops
    WHERE TRIM(ce.DOCUMENTACION) = TRIM(dops.NIF)
    AND ce.ANIO = dops.ANIO
    AND ce.IMPORTE = dops.IMPORTE
)