#!/usr/bin/perl
use warnings;
use strict;
use utf8;

use Geo::OSM::API;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=$ENV{github_root}OpenStreetMap/db/ch.db", '', '', { sqlite_unicode => 1 }) or die "Could not open the db;";
my $osm_api = Geo::OSM::API->new();


my $test = '_TEST';
   $test = '';


# $dbh -> do('pragma case_sensitive_like = true');
# my $sth = $dbh->prepare("select * from tag where val like '\%Neuchatel\%'");

$dbh -> do('pragma case_sensitive_like = false');


#my $sth = $dbh->prepare("select * from tag where key in ('phone', 'contact:phone', 'contact:fax', 'fax', 'contact:mobile') and val regexp '^\\+\\d\\d \\d\\d \\d\\d\\d\\d\\d\\d\\d *\$'");
 my $sth = $dbh->prepare("select * from tag where key in ('phone', 'contact:phone', 'contact:fax', 'fax', 'contact:mobile') and val regexp '^\\+\\d\\d \\d\\d\\d \\d\\d\\d \\d\\d\\d *\$'");
$sth -> execute;
while (my $r = $sth -> fetchrow_hashref()) {


  my $primitive;
  my $id;

  if     ($r->{nod_id}) {
      $id        =  $r->{nod_id};
      $primitive = 'node';
  }
  elsif ($r->{way_id}) {
      $id        =  $r->{way_id};
      $primitive = 'way';
  }
  elsif ($r->{rel_id}) {
      $id        =  $r->{rel_id};
      $primitive = 'relation';
  }
  else {
      print "Neither nod_id, nor rel_id nor way_id\n";
      next;
  }

  my $val_new = $r->{val};

  print $r->{val}, "\n";

# if ($val_new =~ s/^(\+\d\d \d\d) (\d\d\d)(\d\d)(\d\d) *$/$1 $2 $3 $4/) {
# if ($val_new =~ s/^(\+\d\d \d\d)(\d) (\d\d\d)(\d\d\d) *$/$1 $2 $3 $4/) {
#   print "$r->{val} -> $val_new\n";
# }
# else {
#   die "unexpected!";
# }

# if ($val_new =~ s/\bNeuchatel\b/Neuchâtel/g) {
#   set_tag($id, $primitive, $r->{key}, $r->{val}, $val_new);
# }
# else {
#   print "No change in $val_new\n";
# }

#print "$primitive $id $r->{val}\n";
}

exit;

$osm_api->testing($test);

print $osm_api->authenticate($ENV{"TQ84_OSM_USERNAME$test"}, $ENV{"TQ84_OSM_PW$test"});

my $changeset_id = $osm_api -> create_changeset('Fix Sonico -> Sonvico');
print "changeset_id = $changeset_id\n";

print $osm_api->set_tag($changeset_id, 'node', 417175662, 'addr:city', 'Sonvico');
print $osm_api->close_changeset($changeset_id), "\n";

sub set_tag {
  my $id        = shift;
  my $primitive = shift;
  my $key       = shift;
  my $val_db    = shift;
  my $val_new   = shift;

  print "Changing $primitive / $id $key=$val_db ... to $val_new\n";

}
