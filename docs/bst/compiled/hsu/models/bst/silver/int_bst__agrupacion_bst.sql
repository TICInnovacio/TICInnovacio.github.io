

SELECT 
    bst_dops.anio, 
    MAX(bst_dops.zona_geografica) as zona_geografica, 
    bst_dops.consideracion as TIPO_VULNERABILIDAD, 
    COUNT(DISTINCT bst_dops.documentacion) as num_titulares,
    sum(coste_actividad) as total_coste,
    bst_dops.nombre_municipio as municipio
FROM HSU.int_bst_dops bst_dops
WHERE bst_dops.anio_resolt = 'S'
GROUP BY ANIO, NOMBRE_MUNICIPIO, CONSIDERACION