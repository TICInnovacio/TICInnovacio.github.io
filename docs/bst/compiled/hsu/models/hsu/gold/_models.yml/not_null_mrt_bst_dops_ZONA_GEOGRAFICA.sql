
    
    

select * from (
select count(*) as null_count
from HSU.mrt_bst_dops
where ZONA_GEOGRAFICA is null) c where c.null_count != 0


