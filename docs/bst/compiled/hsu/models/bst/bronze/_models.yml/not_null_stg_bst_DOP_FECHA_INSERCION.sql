
    
    

select * from (
select count(*) as null_count
from HSU.stg_bst_DOP
where FECHA_INSERCION is null) c where c.null_count != 0


