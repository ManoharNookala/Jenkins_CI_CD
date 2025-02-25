insert into `learn-436612.ProProd.sample_accounts`
select distinct * 
from `learn-436612.ProProd.sample_accounts`;


create table `learn-436612.ProProd.sample_accounts_temp_data` as 
select distinct *
from `learn-436612.ProProd.sample_accounts`;

drop table `learn-436612.ProProd.sample_accounts`;

alter table  `learn-436612.ProProd.sample_accounts_temp_data` RENAME TO `sample_accounts`;