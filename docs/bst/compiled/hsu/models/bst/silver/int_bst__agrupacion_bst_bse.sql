

select 
    bse.zona_geografica, 
    bse.tipo_vulnerabilidad, 
    bse.anio, 
    sum(bse.num_titulares) as total_titulares_bse,
    sum(bst.num_titulares) as total_titulares_bst,
    CASE 
        WHEN sum(bse.num_titulares) > 0 THEN COALESCE(sum(bst.num_titulares), 0) * 1.0 / sum(bse.num_titulares)
        ELSE 0
    END AS "Relacion titulares BST/BSE"
from int_bst__agrupacion_bse bse
left join int_bst__agrupacion_bst bst
ON 
    bse."ANIO" = bst."ANIO" AND 
    bse."MUNICIPIO" = bst."MUNICIPIO" AND 
    bse."TIPO_VULNERABILIDAD" = bst."TIPO_VULNERABILIDAD"
group by bse.zona_geografica, bse.tipo_vulnerabilidad, bse.anio