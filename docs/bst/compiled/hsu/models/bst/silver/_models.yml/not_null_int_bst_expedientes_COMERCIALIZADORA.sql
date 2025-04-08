
    
    

select * from (
select count(*) as null_count
from HSU.int_bst_expedientes
where COMERCIALIZADORA is null) c where c.null_count != 0


