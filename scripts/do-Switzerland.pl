#!/usr/bin/perl
use warnings;
use strict;

use DBI;
use Geo::OSM::DBI::CH;
use File::Compare;

my $dbh = DBI->connect("dbi:SQLite:dbname=../db/ch.db", '', '', {sqlite_unicode=>1}) or die "does not exist";
$dbh->{AutoCommit} = 0;

my $osm_db = Geo::OSM::DBI::CH->new($dbh);

municipalities();
municipalities_area_tables();

sub municipalities { #_{
  $osm_db->create_table_municipalities_ch();
  $dbh->commit;

  my %municipalities = $osm_db->municipalities_ch;

  open (my $gotten, '>:utf8', 'gotten/municipalities_ch') or die;
  for my $rel_id (sort { ( $municipalities{$a}{name  } cmp $municipalities{$b}{name  } ) or
                         ( $municipalities{$a}{bfs_no} <=> $municipalities{$b}{bfs_no} )
                       } keys %municipalities )
  {
    printf $gotten "%11d %-35s %4d %11.9f %11.9f %11.9f %11.9f\n",
      $rel_id,
      $municipalities{$rel_id}{name},
      $municipalities{$rel_id}{bfs_no},
      $municipalities{$rel_id}{lat_min},
      $municipalities{$rel_id}{lat_max},
      $municipalities{$rel_id}{lon_min},
      $municipalities{$rel_id}{lon_max};

  }
  close $gotten;

  if (compare("expected/municipalities_ch", "gotten/municipalities_ch")) {
    print "! municipalities_ch differs !\n";
  }


} #_}
sub municipalities_area_tables { #_{

  my %municipalities = $osm_db->municipalities_ch;

  for my $rel_id (keys %municipalities) {

    if ($municipalities{$rel_id}{name} eq 'Pfungen') {
      print "Pfungen found: $rel_id\n";

      my $name = $municipalities{$rel_id}{name};
      $name =~ s/[(). ]/-/g;

      $name = "${name}_$municipalities{$rel_id}{bfs_no}_$rel_id";

      print $name, "\n";

      $dbh->{AutoCommit} = 1; # Why is this necessary?
#     my $dbh = DBI->connect("dbi:SQLite:dbname=$db_test") or die "Could not create $db_test";
      $dbh->do("attach database '../db/area/$name.db' as area");
      $dbh->{AutoCommit} = 0; # Why is this necessary?

      $osm_db->create_area_tables({schema_name_to=>'area', municipality_rel_id=>$rel_id});

      $dbh->commit;
      $dbh->{AutoCommit} = 1; # Why is this necessary?
      $dbh->do("detach database area");
      $dbh->{AutoCommit} = 0; # Why is this necessary?

    }

  }

} #_}
