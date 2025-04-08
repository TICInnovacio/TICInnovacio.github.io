
    
    

select * from (
select count(*) as null_count
from HSU.mrt_bst_expedientes_matriz
where ANIO is null) c where c.null_count != 0


