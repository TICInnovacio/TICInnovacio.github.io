
    
    

select * from (
select count(*) as null_count
from HSU.int_bst_expedientes
where INICIALS_NOM_I_2_LLINATGES is null) c where c.null_count != 0


