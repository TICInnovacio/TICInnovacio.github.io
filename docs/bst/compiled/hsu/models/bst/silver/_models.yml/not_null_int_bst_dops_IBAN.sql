
    
    

select * from (
select count(*) as null_count
from HSU.int_bst_dops
where IBAN is null) c where c.null_count != 0


