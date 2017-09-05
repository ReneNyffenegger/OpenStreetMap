.mode column
.header on
.width  10 50

select wd.val wikidata, nm.val name from tag wd join tag nm using (nod_id) where wd.key = 'wikidata' and nm.key = 'name' union all
select wd.val wikidata, nm.val name from tag wd join tag nm using (way_id) where wd.key = 'wikidata' and nm.key = 'name' union all
select wd.val wikidata, nm.val name from tag wd join tag nm using (rel_id) where wd.key = 'wikidata' and nm.key = 'name';
