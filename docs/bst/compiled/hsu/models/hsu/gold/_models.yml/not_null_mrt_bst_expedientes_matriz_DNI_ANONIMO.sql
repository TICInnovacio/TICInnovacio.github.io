
    
    

select * from (
select count(*) as null_count
from HSU.mrt_bst_expedientes_matriz
where DNI_ANONIMO is null) c where c.null_count != 0


