
    
    

select * from (
select count(*) as null_count
from HSU.mrt_bst_expedientes
where NOMBRE_MUNICIPIO is null) c where c.null_count != 0


