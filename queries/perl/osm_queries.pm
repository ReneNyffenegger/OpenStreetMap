package osm_queries;
use warnings;
use strict;

sub start_file { #_{
 
  my $filename = shift;
  open (my $file, '>:utf8', "../../web/$filename") or die "could not open $filename - $!";

  return $file;

} #_}
sub start_kml { #_{

  my $filename_no_suffix = shift;
  my $title              = shift;

  my $kml = start_file("$filename_no_suffix.kml");
# open (my $kml, '>:utf8', "../../web/$filename_no_suffix.kml") or die "$filename_no_suffix - $!";

  print $kml qq{<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
<name>$title</name>

	<Style id="blue-pin"      ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/blue-pushpin.png  </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="blue-light-pin"><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/ltblu-pushpin.png </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="green-pin"     ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/grn-pushpin.png   </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="pink-pin"      ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/pink-pushpin.png  </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="purple-pin"    ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/purple-pushpin.png</href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="red-pin"       ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/red-pushpin.png   </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="white-pin"     ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/wht-pushpin.png   </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="yellow-pin"    ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png   </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 


};

my $drop_me = qq{
<!--

	<Style id="alphuette">
		<IconStyle><Icon></Icon>
		</IconStyle>
		<LabelStyle>
			<color>ffc341ff</color>
		</LabelStyle>
		<ListStyle>
		</ListStyle>
		<LineStyle>
			<color>ffc341ff</color>
			<width>3</width>
		</LineStyle>
	</Style>

	<Style id="alphuette_normal">
		<IconStyle>
			<Icon>
			</Icon>
		</IconStyle>
		<LabelStyle>
			<color>ffc341ff</color>
		</LabelStyle>
		<ListStyle>
		</ListStyle>
		<LineStyle>
			<color>ffc341ff</color>
			<width>3</width>
		</LineStyle>
	</Style>

	<Style id="alphuette_highlight">
		<IconStyle>
			<Icon>
			</Icon>
		</IconStyle>
		<LabelStyle>
			<color>ff00aaff</color>
		</LabelStyle>
		<ListStyle>
		</ListStyle>
		<LineStyle>
			<color>ff0000ff</color>
			<width>3</width>
		</LineStyle>
	</Style>

	<StyleMap id="alphuette">
		<Pair><key>normal</key>   <styleUrl>#alphuette_normal</styleUrl>   </Pair>
		<Pair><key>highlight</key><styleUrl>#alphuette_highlight</styleUrl></Pair>
	</StyleMap>
  -->
  };

  return $kml;

} #_}
sub start_html { #_{
  my $filename_no_suffix = shift;
  my $title              = shift;
  my $introText          = shift;
  my $html = start_file("$filename_no_suffix.html");

  print $html qq{<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>$title</title>
</head><body>
<h1>$title</h1>
$introText
<p>
};
  return $html;
} #_}
sub end_kml { #_{
  my $kml = shift;

  print $kml "</Document>
</kml>";
  close $kml;
} #_}
sub end_html { #_{
  my $html = shift;

  print $html qq{
  <hr>
    <a href='http://renenyffenegger.ch/development/OpenStreetMap/queries'>Weitere Open Street Map queries</a>.
  </body>
</html>};
  close $html;
} #_}

sub create_pivot_sql { #_{

  my $key      = shift;
  my $val      = shift;
  my $cols_ref = shift;
  
  my @cols = @$cols_ref;

  my $dot_width = ".width 11 11 11 11";

  my $cols_stmt = 'wy.nod_id
, wy.way_id
, wy.lat
, wy.lon';

  my $table_stmt = ' wy';

  my $no_alias = 0;
  for my $col (@cols) { #_{
  
    my $alias = "t$no_alias";
  
    my $key = $col->{key};
   (my $col_name  = $key) =~ s/:/_/g;
  
    $cols_stmt  .= "\n, $alias.val $col_name";
    $table_stmt .= " left join\n   tag $alias on $alias.key ='$key' and (wy.nod_id = $alias.nod_id  or wy.way_id = $alias.way_id /* or wy.rel_id = $alias.rel_id */)";
  
    $dot_width .= " $col->{w}";
  
    $no_alias ++;

} #_}

  my $sql_stmt =  #_{
"
with ini as (
  select
    nod_id,
    way_id
  from
    tag
  where
    key = '$key' and
    val = '$val'
),
nd as (
  select
    ini.nod_id,
    ini.way_id,
    nod.lat,
    nod.lon
  from
    ini left join
    nod on ini.nod_id = nod.id
),
wy as (
  select
    nd.nod_id,
    nd.way_id,
    coalesce(nd.lat, (max(nod.lat) + min(nod.lat)) / 2) lat,
    coalesce(nd.lon, (max(nod.lon) + min(nod.lon)) / 2) lon
  from
    nd                                    left join
    nod_way on nd.way_id = nod_way.way_id left join
    nod     on nod.id    = nod_way.nod_id
  group by
    nd.nod_id,
    nd.way_id
)
select
  $cols_stmt
from
  $table_stmt
-- where
--   ini.key = '$key' and
--   ini.val = '$val'
;"; #_}

  return $sql_stmt;

} #_}

1;
