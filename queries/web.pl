#!/usr/bin/perl
use warnings;
use strict;
use utf8;

use DBI;

process_query('alphuetten.sql', 'Schweizer Alphütten');

sub process_query { #_{

  my $sql_file = shift;
  my $title    = shift;

  die unless -f $sql_file;

  my ($filename_no_suffix) = $sql_file =~ m/(.*)\.sql$/;
# my ($html_file) = $sql_file =~ m/(.*)\.sql$/;
# $html_file .= '.html';

  my $db_file = "$ENV{github_root}OpenStreetMap/db/ch.db";
  die "DB $db_file does not exist" unless -f $db_file;

  my $dbh = DBI->connect("dbi:SQLite:dbname=$db_file", '', '', 
    { sqlite_unicode => 1 }
  ) or die;

  my $html = start_html($filename_no_suffix, $title);
  my $kml  = start_kml ($filename_no_suffix, $title);


  my $sql_text = slurp_file($sql_file);

  $sql_text =~ s/--.*$//gm;
  $sql_text =~ s/^ *\..*$//gm;
  print $sql_text;

  my $sth = $dbh->prepare($sql_text);
  $sth->execute;


  print $html "<table>\n";
  while (my $row = $sth->fetchrow_hashref) { #_{

     my $name = $row->{name_de};
     $name = $row->{name} unless $name;
     next unless $name;

     my $osm_link = "<a href='http://www.openstreetmap.org/";
     if ($row->{nod_id}) {
       $osm_link .= "node/$row->{nod_id}";
     }
     elsif ($row->{way_id}) {
       $osm_link .= "way/$row->{way_id}";
     }
     else {
       die "expected nod_id or way_id, name = $name";
     }
     $osm_link .= "'>OSM</a>";

     my $elev = $row->{elev} // '';

     my $url = '';

     if (my $url_ = $row->{url}) {
       if (substr($url_, 0, 3) eq 'www') {
         $url_ = "http://$url_";
       }
       $url = "<a href='$url_'>$row->{url}</a>" if $row->{url};
     }


     print $html "<tr>";
     print $html "<td>$name</a></td>";
     print $html "<td>$elev</a></td>";
     print $html "<td>$osm_link</td>";
     print $html "<td>$url</td>";
     print $html "</tr>\n";


     print $kml "<Placemark>
  <name>$name</name>
  <styleUrl>#alphuette</styleUrl>
  <Point>
    <extrude>1</extrude>
    <altitudeMode>relativeToGround</altitudeMode>
    <coordinates>$row->{lon},$row->{lat},800</coordinates>
  </Point></Placemark>";

  } #_}

  print $html "</table>";
  end_html($html);
  end_kml ($kml );

} #_}

sub slurp_file { #_{
  my $file = shift;
  open (my $fh, '<', $file) or die;

  my $ret = '';
  $ret .= $_ while (<$fh>);
  return $ret;

} #_}

sub start_html { #_{

  my $filename_no_suffix = shift;
  my $title              = shift;

  open (my $html, '>:utf8', "../web/$filename_no_suffix.html") or die;
  print $html qq{<html><head>
  <meta http-equiv="Content-Type" content="text/html"; charset="utf-8">
  <title>$title</title></head></html>
  
  <img src="$filename_no_suffix.png"/>

  <p>
  Diese <a href="$filename_no_suffix.kml">Google Earth (kml) Datei</a> enthält alle Alphütten, die ich in Open Street Map mit
  <a href='https://github.com/ReneNyffenegger/OpenStreetMap/blob/master/queries/alphuetten.sql'>diesem SQL Query</a> gefunden habe.

  <p>Die Alphütten auch aus Liste mit Links auf die Open Street Map Karte:

};

  return $html;

} #_}

sub start_kml  { #_{
  my $filename_no_suffix = shift;
  my $title              = shift;
  open (my $kml, '>:utf8', "../web/$filename_no_suffix.kml") or die;

  print $kml qq{<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
<name>$title</name>

	<Style id="alphuette">
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

<!--
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

sub end_html { #_{
  my $html = shift;

  print $html "</body></html>";
  close $html;
} #_}

sub end_kml { #_{
  my $kml = shift;

  print $kml "</Document>
</kml>";
  close $kml;
} #_}
