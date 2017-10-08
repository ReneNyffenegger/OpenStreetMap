#!/usr/bin/perl
use warnings;
use strict;
use utf8;

use DBI;
use osm_queries;

my $dbh = DBI->connect('dbi:SQLite:dbname=../../db/ch.db',  '', '', { sqlite_unicode => 1 }) or die "Could not create the.db";

my $sth = $dbh->prepare(<<SQL);
select
  m.rel_id rel_id,
  m.name   name_municipality,
  p.*
from
  parkplaetze          p join
  municipalities_ch_v  m on p.lat between m.lat_min and m.lat_max and
                            p.lon between m.lon_min and m.lon_max
order by
  m.name
SQL

$sth->execute;
my $last_rel_id = 0;
my $kml;
while (my $r = $sth->fetchrow_hashref) {

# print join "\n", keys %{$r};
# exit;

# print $r->{rel_id}, "\n";
# next;

  if ($last_rel_id != $r->{rel_id}) {

    if ($last_rel_id) {
       osm_queries::end_kml($kml );
    }

    my $name_municipality = "$r->{name_municipality}-$r->{rel_id}";
    $name_municipality =~ s/ /_/g;
    $name_municipality =~ s/ä/ae/g;
    $name_municipality =~ s/ö/oe/g;
    $name_municipality =~ s/ü/ue/g;
    $name_municipality =~ s/Ä/Ae/g;
    $name_municipality =~ s/Ö/Oe/g;
    $name_municipality =~ s/Ü/Ue/g;
    $name_municipality =~ s/ë/e/g;
    $name_municipality =~ s/è/e/g;
    $name_municipality =~ s/é/e/g;
    $name_municipality =~ s/à/a/g;
    $name_municipality =~ s/á/a/g;
    $name_municipality =~ s/\//_/g;

    $kml = osm_queries::start_kml("Parkplaetze/$name_municipality");

    $last_rel_id = $r->{rel_id};

  }

  my $name_tag = '';
  if (defined $r->{name}) {
    my $name = $r->{name};
    $name =~ s/&/&amp;/g;
    $name_tag = "<name>$name</name>";
  }

  my $style_url;
  if (defined $r->{fee}) {
    if ($r->{fee} eq 'no') {
       $style_url = '#green-pin';
    }
    elsif ($r->{fee} eq 'yes') {
       $style_url = '#red-pin';
    }
    else {
       $style_url = '#white-pin';
    }
  }
  else {
       $style_url = '#white-pin';
  }


     print $kml "<Placemark>
		<styleUrl>$style_url</styleUrl>
     $name_tag
     <Point>
    <coordinates>$r->{lon},$r->{lat}</coordinates>
    </Point>
  </Placemark>";

} #_}

osm_queries::end_kml($kml );
