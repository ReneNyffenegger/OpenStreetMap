osm "select count(*), val from tag where key='$1' group by val order by count(*)"
