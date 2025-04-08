

WITH companyies_electriques AS (
    SELECT * 
    FROM HSU.stg_bst_CE  -- Usamos no_quotes_ref() en el CTE, aplicando tu macro
)

SELECT
    TIPO_DOCUMENTACION,
    DOCUMENTACION,
    NOMBRE,
    APELLIDO1,
    APELLIDO2
FROM companyies_electriques