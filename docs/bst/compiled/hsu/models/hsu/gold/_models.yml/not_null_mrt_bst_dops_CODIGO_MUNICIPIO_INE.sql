
    
    

select * from (
select count(*) as null_count
from HSU.mrt_bst_dops
where CODIGO_MUNICIPIO_INE is null) c where c.null_count != 0


