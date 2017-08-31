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


sub municipalities {
# $osm_db->create_table_municipalities_ch();
# $dbh->commit;

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
      $municipalities{$rel_id}{min_lat},
      $municipalities{$rel_id}{max_lat},
      $municipalities{$rel_id}{min_lon},
      $municipalities{$rel_id}{max_lon};
    
  }
  close $gotten;

  if (compare("expected/municipalities_ch", "gotten/municipalities_ch")) {
    print "! municipalities_ch differs !\n";
  }


}

