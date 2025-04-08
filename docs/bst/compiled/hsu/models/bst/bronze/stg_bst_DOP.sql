

SELECT 
        CENTRO_GESTOR,
        PARTIDA,
        FONDO,
        NIF, 
        IMPORTE, 
        IBAN,
        NOMBRE,
        DIRECCION,
        CP,
        PROVINCIA,
        REFE_CONCESION,
        CODIGO_MUNICIPIO,
        REGION,
        TIPO_BENEFICIARIO,
        SECTOR_ECONOMICO,
        COSTE_ACTIVIDAD,
        REGION_CONCESION,
        ANIO,
        FECHA_INSERCION,
        IS_REFORÇ
    FROM HSU.RAW_BST_DOPS
    WHERE NIF IS NOT NULL
    OR IMPORTE IS NOT NULL
    OR CODIGO_MUNICIPIO IS NOT NULL