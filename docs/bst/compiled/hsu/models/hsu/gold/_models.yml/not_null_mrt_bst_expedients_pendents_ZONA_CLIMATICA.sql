
    
    

select * from (
select count(*) as null_count
from HSU.mrt_bst_expedients_pendents
where ZONA_CLIMATICA is null) c where c.null_count != 0


