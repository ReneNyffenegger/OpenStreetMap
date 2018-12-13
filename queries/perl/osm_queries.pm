package osm_queries;
use warnings;
use strict;

use DBI;


sub open_db { #_{

  my $dbh = DBI->connect('dbi:SQLite:dbname=../../db/ch.db',  '', '', { sqlite_unicode => 1 }) or die "Could not open db";
  return $dbh;

} #_}

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

  print $html qq{<!DOCTYPE html>
<html><head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>$title</title>
<style type='text/css'> 
  table {border-collapse: collapse}

  td { border-left: 1px solid #dea; vertical-align: top }

  tr.nextRow { border-bottom: 1px solid #333 }

  \@media all and (max-width: 599px) {

    /* Force table to not be like tables anymore */
    thead, tbody, th, td, tr {
      display: block !important;
    }

  }

</style>
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
    <a href='https://renenyffenegger.ch/development/OpenStreetMap/queries/key-val'>Weitere key-val Open Street Map queries</a>
  </body>
</html>};
  close $html;
} #_}

sub html_escape { #_{
  my $text = shift;
  return '' unless defined $text;
  $text =~ s/&/&amp;/g;
  $text =~ s/</&lt;/g;
  $text =~ s/>/&gt;/g;

  return $text;

} #_}

sub html_a { #_{
  my $url       = shift;
  my $text_html = shift;

  if ($url !~ /^http/) {
    $url = "http://$url";
  }

  return "<a href='$url'>$text_html</a>";
  
} #_}


sub html_website { #_{
  my $url_raw  = shift;

  html_a($url_raw, html_escape($url_raw));
} #_}

sub html_email { #_{
  my $email_raw  = shift;
  return "<a href='emailto:$email_raw'>" . html_escape($email_raw) . "</a>";

} #_}

sub html_country_zip_city {
  my $val = shift;

  my $ret = '';

  if (exists $val->{'addr:country'}) {
    $ret = html_escape (delete $val->{'addr:country'});
  }
  if (exists $val->{'addr:postcode'}) {
    $ret .= ' ' if $ret;
    $ret .= html_escape (delete $val->{'addr:postcode'});
  }
  elsif (exists $val->{'postcode'}) {
    $ret .= ' ' if $ret;
    $ret .= html_escape (delete $val->{'postcode'});
  }
  elsif (exists $val->{'postal_code'}) {
    $ret .= ' ' if $ret;
    $ret .= html_escape (delete $val->{'postal_code'});
  }
  if (exists $val->{'addr:city'}) {
    $ret .= ' ' if $ret;
    $ret .= html_escape (delete $val->{'addr:city'});
  }
  elsif (exists $val->{'x:city'}) {
    $ret .= ' ' if $ret;
    $ret .= html_escape(delete $val->{'x:city'});
#   print $val->{'x:city'};
  }
  else {
#   $ret .= ' !!! city expected !!!';
  }

  return $ret;
}

sub html_a_way_nod_id { #_{
  my $sql_r = shift;

  if ($sql_r->{nod_id}) {return "<a href='http://www.openstreetmap.org/node/$sql_r->{nod_id}'>Node $sql_r->{nod_id}</a>"; }
  if ($sql_r->{way_id}) {return "<a href='http://www.openstreetmap.org/way/$sql_r->{way_id}' >Way $sql_r->{way_id} </a>"; }
  if ($sql_r->{rel_id}) {return "<a href='http://www.openstreetmap.org/relation/$sql_r->{rel_id}'>Relation  $sql_r->{rel_id} </a>"; }

} #_}

sub html_td_shop { #_{
  my $sql_r = shift;

  my $text = '';

  goto RET unless defined $sql_r->{shop};
  goto RET        if      $sql_r->{shop} eq 'no';

  if ($sql_r->{shop} eq 'yes') {
    $text = 'Mit Shop';
    goto RET;
  }
  if ($sql_r->{shop} eq 'yes') {
    $text = 'Mit Shop';
    goto RET;
  }


RET:
  return "<td>$text</td>";

} #_}

sub td_key_val { #_{
  my $key_textHuman = shift;
  my $val           = shift;

  if ($val) { return sprintf("<tr><td>%s:</td><td>%s</td></tr>", html_escape($key_textHuman), html_escape($val)); }
  return '';

} #_}

sub kml_placemark { #_{

  my $kml   = shift;
  my $sql_r = shift;

  die unless defined $sql_r->{lon};
  die unless defined $sql_r->{lat};

  my $style_url = '#white-pin';

  my $trs = '';


# $trs .= td_key_val('Way ID'   , $sql_r->{way_id       });
# $trs .= td_key_val('Rel ID'   , $sql_r->{rel_id       });

  if ($sql_r->{parking          } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Parking:'        , $sql_r->{parking          }); }
  if ($sql_r->{access           } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Access:'         , $sql_r->{access           }); }
  if ($sql_r->{fee              } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Fee:'            , $sql_r->{fee              }); }
  if ($sql_r->{capacity         } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Capacity:'       , $sql_r->{capacity         }); }
  if ($sql_r->{surface          } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Surface:'        , $sql_r->{surface          }); }
  if ($sql_r->{source           } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Source:'         , $sql_r->{source           }); }
  if ($sql_r->{park_ride        } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Park &amp; ride:', $sql_r->{park_ride        }); }
  if ($sql_r->{supervise        } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Supervised:'     , $sql_r->{supervised       }); }
  if ($sql_r->{wheelchair       } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Wheelchair:'     , $sql_r->{wheelchair       }); }
  if ($sql_r->{description      } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Description'     , $sql_r->{description      }); }
  if ($sql_r->{addr_street      } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Street:'         , $sql_r->{addr_street      }); }
  if ($sql_r->{addr_housuenumber} ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Street:'         , $sql_r->{addr_housuenumber}); }
  if ($sql_r->{addr_postcode    } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'PLZ:'            , $sql_r->{addr_postcode    }); }

# tankstellen.pl

  $trs .= td_key_val('Operator'   , $sql_r->{operator       });
  $trs .= td_key_val('Shop'       , $sql_r->{shop           });
  $trs .= td_key_val('Diesel'     , $sql_r->{diesel         });
  $trs .= td_key_val('Okt 95'     , $sql_r->{fuel_octane_95 });
  $trs .= td_key_val('Okt 91'     , $sql_r->{fuel_octane_91 });
  $trs .= td_key_val('Okt 98'     , $sql_r->{fuel_octane_98 });
  $trs .= td_key_val('Okt 100'    , $sql_r->{fuel_octane_100});
  $trs .= td_key_val('Buione 100' , $sql_r->{fuel_buione_100});

# if ($r->{operator         } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Operator:'       , $r->{operator         }); }
# if ($r->{shop             } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Shop'            , $r->{shop             }); }
# if ($r->{diesel           } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Diesel:'         , $r->{dierator         }); }
# if ($r->{fuel_octane_95   } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Okt 95:'         , $r->{operator         }); }

  my $table = '';

  my $html_a_nod_or_way;
  if ($sql_r->{nod_id}) { $html_a_nod_or_way = "<a name='link_id' id='link_id' href='javascript:window.open(\"about:blank\");' onclick=\"window.open('http://www.openstreetmap.org/node/$sql_r->{nod_id}');\">Node $sql_r->{nod_id}</a>"; }
  if ($sql_r->{way_id}) { $html_a_nod_or_way = "<a name='link_id' id='link_id' href='javascript:window.open(\"about:blank\");' onclick=\"window.open('http://www.openstreetmap.org/way/$sql_r->{way_id}' );\">Way $sql_r->{way_id}</a>"; }

# if ($trs) {
    $table = "<description> <![CDATA[ 
    $html_a_nod_or_way
    <table>$trs</table> 
    ]]> </description>";
# }

  my $name_tag = '';
  if (defined $sql_r->{name}) {
    my $name = html_escape($sql_r->{name});
    $name_tag = "<name>$name</name>";
  }


     print $kml "\n<Placemark>";



     print $kml "
		<styleUrl>$style_url</styleUrl>
     $name_tag
     $table
     <Point><coordinates>$sql_r->{lon},$sql_r->{lat}</coordinates></Point>

  </Placemark>";


} #_}

sub create_pivot_sql { #_{

  my $key      = shift;
  my $val      = shift;
  my $cols_ref = shift;
  
  my @cols = @$cols_ref;

  unshift @cols, (
    { key => 'name'             , w => 30},
    { key => 'addr:street'      , w => 30},
    { key => 'addr:housenumber' , w =>  4},
    { key => 'addr:postcode'    , w =>  4},
    { key => 'addr:city'        , w => 30},
  );

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
    val = '$val' and
   (nod_id is not null or way_id is not null)
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
;"; #_}

  return $sql_stmt;

} #_}

1;
