
    
    

select * from (
select count(*) as null_count
from HSU.int_bst_dops
where REGION_CONCESION is null) c where c.null_count != 0


