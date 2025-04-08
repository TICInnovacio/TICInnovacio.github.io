

SELECT 
    COALESCE(TO_NUMBER(bse.anio), TO_NUMBER(bst.anio)) AS anio,
    COALESCE(bse.municipio, bst.municipio) AS municipio,
    COALESCE(bse.tipo_vulnerabilidad, bst.tipo_vulnerabilidad) AS tipo_vulnerabilidad,
    COALESCE(bst.zona_geografica, bse.zona_geografica) AS zona_geografica,
    bst.num_titulares as Titulares_BST,
    bst.total_coste as Coste_BST,
    bse.num_titulares as Titulares_BSE,
    bse.total_importe as Importe_BSE
FROM HSU.int_bst__agrupacion_bst bst
    FULL JOIN HSU.int_bst__agrupacion_bse bse 
        ON bst.anio = bse.anio and 
           bst.municipio = bse.municipio and
           bst.tipo_vulnerabilidad = bse.tipo_vulnerabilidad