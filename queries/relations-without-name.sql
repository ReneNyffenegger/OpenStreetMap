-- explain query plan
select distinct rel_of from rel_mem
except
select rel_id from tag not indexed where key = 'name' and rel_id is not null
;
