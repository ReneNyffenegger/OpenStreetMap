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

  my ($html_file) = $sql_file =~ m/(.*)\.sql$/;
  $html_file .= '.html';

  my $db_file = "$ENV{github_root}OpenStreetMap/db/ch.db";
  die "DB $db_file does not exist" unless -f $db_file;

  my $dbh = DBI->connect("dbi:SQLite:dbname=$db_file", '', '', 
    { sqlite_unicode => 1 }
  ) or die;

  open (my $html, '>:utf8', "../web/$html_file") or die;
  print $html qq{<html><head>
  <meta http-equiv="Content-Type" content="text/html"; charset="utf-8">
  <title>$title</title></head></html>};

  my $sql_text = slurp_file($sql_file);

  $sql_text =~ s/--.*$//gm;
  $sql_text =~ s/^ *\..*$//gm;
  print $sql_text;

  my $sth = $dbh->prepare($sql_text);
  $sth->execute;


  print $html "<table>\n";
  while (my $row = $sth->fetchrow_hashref) {
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

  }
  print $html "</table>";

  print $html "</body></html>";

} #_}

sub slurp_file { #_{
  my $file = shift;
  open (my $fh, '<', $file) or die;

  my $ret = '';
  $ret .= $_ while (<$fh>);
  return $ret;

} #_}
