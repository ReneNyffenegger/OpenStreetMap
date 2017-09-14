.mode column
.width 11 11 11 20 50

select * from tag where (
    upper(val) like 'SAC%'   or
    upper(val) like '%SAC-%' or
    upper(val) like '% SAC'  or
    upper(val) like 'SAC %'  or
    upper(val) like '%ALPINE HUT%'
) and
  upper(val) not like '%SACK%' and
  upper(val) not like '%SACL%' and
  upper(val) not like '%SACH%';

