

SELECT 
    bst_expedientes.anio, 
    MAX(bst_expedientes.zona_geografica) as zona_geografica, 
    bst_expedientes.consideracion as TIPO_VULNERABILIDAD, 
    COUNT(DISTINCT bst_expedientes.documentacion) as num_titulares,
    sum(importe) as total_importe,
    bst_expedientes.nombre_municipio as municipio
FROM HSU.int_bst_expedientes bst_expedientes
WHERE bst_expedientes.anio_resolt = 'S'
GROUP BY ANIO, NOMBRE_MUNICIPIO, CONSIDERACION