#!/usr/bin/perl
use warnings;
use strict;

use DBI;
use Geo::Coordinates::Converter::LV03 qw(lat_lng_2_y_x);

my $db = shift;
die unless -e $db;
my $dbh = DBI->connect("dbi:SQLite:dbname=$db") or die "$db does not exist";


my ($lat_min, $lat_max, $lng_min, $lng_max) = (46, 48, 6, 10);
# my ($lat_min, $lat_max, $lng_min, $lng_max) = ( 47.4974391,    47.5218535,    8.6176417,     8.6611279);


my ($y_min, $y_max,
    $x_min, $x_max,
    $width, $height,
    $inkscape_width, $inkscape_height);

my $max_inksape_width_or_height = 1000;

determine_width_height();

my $svg_doc_name = "out.svg";
open(my $inkscape, '>', $svg_doc_name) or die;
binmode($inkscape, ':utf8');
inkscapeHeader($inkscape, $inkscape_width, $inkscape_height, $svg_doc_name);

draw_svg($inkscape, $dbh);

print $inkscape "</svg>";
close $inkscape;

sub determine_width_height { #_{

  ($x_min, $y_min, $x_max, $y_max) = (
     lat_lng_2_y_x($lat_min, $lng_min),
     lat_lng_2_y_x($lat_max, $lng_max)
  );

  $width  = $x_max - $x_min;
  $height = $y_max - $y_min;

  printf ("bounding box in LV03 Coordinates:\n");
  printf ("  x %7.3f .. %7.3f   %7.3f\n",  $x_min / 1000, $x_max / 1000, $width / 1000);
  printf ("  y %7.3f .. %7.3f   %7.3f\n",  $y_min / 1000, $y_max / 1000, $height / 1000);


  if ($width > $height) {
    $inkscape_width  = $max_inksape_width_or_height;
    $inkscape_height = $max_inksape_width_or_height /$width*$height;
  }
  else {
    $inkscape_height = $max_inksape_width_or_height;
    $inkscape_width  = $max_inksape_width_or_height /$width*$height;
  }


} #_}

sub lat_lon_to_inkscape { #_{

  my $lat = shift;
  my $lon = shift;

  my ($x_, $y_) = lat_lng_2_y_x($lat, $lon);

# In SVG, the coordinate 0/0 marks the *upper* left corner, so
# for y, we have to make an additional substraction
  my $x =                    ($x_ - $x_min) / $width  * $inkscape_width ;
  my $y = $inkscape_height - ($y_ - $y_min) / $height * $inkscape_height; 

  return ($x, $y);

} #_}


sub draw_svg { #_{
  my $inkscape = shift;
  my $dbh      = shift;

# draw_nodes($inkscape, $dbh);

  draw_buildings($inkscape, $dbh);

} #_}


sub draw_nodes { #_{
  my $inkscape = shift;
  my $dbh      = shift;

  my $sth_node = $dbh -> prepare("select id, lat, lon from nod");
  $sth_node -> execute;

  while (my $r = $sth_node -> fetchrow_hashref) {
    draw_node($inkscape, $r->{lat}, $r->{lon}, $r->{id});
  }

} #_}


sub draw_buildings { # {

  my $inkscape = shift;
  my $dbh      = shift;

  my $cnt_building = 0;
  my $sth = $dbh -> prepare("
    select
      bd.way_id,
      nd.lat,
      nd.lon 
    from
      nod_way                bd                           join
      nod                    nd on bd.nod_id = nd.id
    where
      way_id in (select way_id from tag where key = 'building')
    order by
      bd.way_id,
      bd.order_
    ");
  $sth -> execute;
    
  my $last_way_id = 0;

# See C:\github\development_misc\open_street_map\local_database\OSM\Way.pm
  my $path; #  = "<path style='fill:#aaaaaa;stroke:#888888;stroke-width:1' d='M"; # M: moveto (absolute)
  while (my $r = $sth -> fetchrow_hashref) {

    if ($last_way_id == $r->{way_id}) {

       my ($x, $y) = lat_lon_to_inkscape($r->{lat}, $r->{lon});
       $path .= " $x,$y";
    }
    else {
       if ($last_way_id != 0) {
         
         $path .= " Z' />"; # close the path (What's the difference to a small z?)
         print $inkscape $path;
       }
       $cnt_building ++;

       $path = "\n<path style='fill:#aaaaaa;stroke:#888888;stroke-width:1' id='$r->{way_id}' d='M"; # M: moveto (absolute)

       my ($x, $y) = lat_lon_to_inkscape($r->{lat}, $r->{lon});
       $path .= " $x,$y";

       $last_way_id = $r->{way_id};

    }

  }

  $path .= " Z' />"; # close the path
  print $inkscape $path;

  print "Buildings: $cnt_building\n";

} # }

sub draw_node { #_{

  my $inkscape = shift;
  my $lat      = shift;
  my $lon      = shift;
  my $id       = shift;


  my ($x, $y) = lat_lon_to_inkscape($lat, $lon);


  my $x_text = $x+3.5;
  my $y_text = $y+4.5;

  my $text = <<TEXT;
  <text
     style="font-size:9px;font-family:Arial Narrow;fill:#000000;"
     x="$x"
     y="$y_text"
     sodipodi:linespacing="100%"
  >
     <tspan sodipodi:role="line" x="$x" y="$y">$id</tspan>
  </text>
TEXT

  $text = '';

print $inkscape <<NODE;
  <circle
     style="opacity:1;fill:#000000;stroke:#000000;stroke-width:1"
     cx="$x" cy="$y" r="1" id="$id"/>
  $text
NODE

} #_}


sub inkscapeHeader { #_{
  
  my $inkscape = shift;
  my $width    = shift;
  my $height   = shift;
  my $docname  = shift;

  my $center_x = $width / 2;
  my $center_y = $height / 2;

  print $inkscape <<"HEADER";
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with $0 -->

<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   width="$width"
   height="$height"
   id="svg4662"
   version="1.1"
   inkscape:version="0.48.1 "
   sodipodi:docname="$docname">
   
<sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="0.75"
     inkscape:cx="$center_x"
     inkscape:cy="$center_y"
     inkscape:document-units="px"
     inkscape:current-layer="layer1"
     showgrid="false"
     inkscape:window-width="1600"
     inkscape:window-height="1152"
     inkscape:window-x="1912"
     inkscape:window-y="-8"
     inkscape:window-maximized="1" />
  <metadata
     id="metadata29714">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs
     id="defs29712" />
HEADER

} #_}
