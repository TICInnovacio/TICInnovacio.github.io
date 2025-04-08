
    
    

select * from (
select count(*) as null_count
from HSU.stg_bst_DOP
where NIF is null) c where c.null_count != 0


