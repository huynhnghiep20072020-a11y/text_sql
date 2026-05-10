USE telephone_directory_db;

SELECT AVG(contact_count) acc FROM contacts;
SELECT *FROM contacts
WHERE contact_count >(SELECT AVG(contact_count) acc FROM contacts);
select city from contacts;
select city, max(contact_count) mcc from contacts group by city;
select c.*
from contacts c
join (select city, max(contact_count) mcc from contacts group by city ) list_mcc
on c.city = list_mcc.city  and c.contac_count =list_mcc.mcc;
select nickname from contacts where nickname is not null;
select avg(contact_count)
from(select contact_count from contacts where nickname is not null) nnnn;

select * 
from contacts 
where nickname is not null and contact_count <(select avg(contact_count)from contacts where nickname is not null);

