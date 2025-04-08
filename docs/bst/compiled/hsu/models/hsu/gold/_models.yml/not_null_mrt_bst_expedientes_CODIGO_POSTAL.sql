
    
    

select * from (
select count(*) as null_count
from HSU.mrt_bst_expedientes
where CODIGO_POSTAL is null) c where c.null_count != 0


