#!/usr/bin/perl

# read nodes.dmp and names.dmp, and construct inner-db based on CDB

use strict;
use CDB_File;
use lib '.';
my $srcdir;
use Getopt::Long;
GetOptions(
  "s|sdir=s" => \$srcdir
);
my %dbfile;
my %cdb;
$dbfile{sn} = "taxonname.cdb"; # id -> scientific name 
$dbfile{pa} = "taxonparent.cdb";
$dbfile{ra} = "taxonrank.cdb";
$dbfile{an} = "taxonname2.cdb"; # id -> all names (including synonyms, common names)
$dbfile{id} = "taxonid.cdb";    # name -> id
$dbfile{i2} = "taxonid2.cdb";   # all types of name -> id
$dbfile{ch} = "taxonchildren.cdb";

foreach my $k (keys %dbfile){
  unlink $dbfile{$k} if -e $dbfile{$k};
  $cdb{$k} = new CDB_File($dbfile{$k}, "$dbfile{$k}.$$") or die;
}

open(my $fhi, "<", "$srcdir/names.dmp") or die;
while(<$fhi>){
  s/[\n\r]*$//;
  my @f=split(/\|/, $_);
  for(my $i=1; $i<=$#f; $i++){
    $f[$i]=~s/^\s+//;
    $f[$i]=~s/\s+$//;
  }
  $f[0]+=0;

  # id -> name (inc. synonym, common name ...)
  $f[3]=($f[3] eq 'scientific name')?"s"
    :($f[3] eq 'synonym')?"y"
      :($f[3] eq 'authority')?"a"
        :($f[3] eq 'common name')?"c"
          :($f[3] eq 'equivalent name')?"e":$f[3];
  my $x=join("\t",@f[1,3]); # name, name type (common, synonym,...)
  $cdb{an}->insert($f[0], $x);
  # all name -> id
  $cdb{i2}->insert($f[1],$f[0]);

  if($f[3] eq "s"){
    # id -> scientific name
    $cdb{sn}->insert($f[0], $f[1]);
    # scientific name -> id
    $cdb{id}->insert($f[1],$f[0]);
  }

}
close $fhi;

open($fhi, "<", "$srcdir/nodes.dmp") or die;
while(<$fhi>){
  my($tid,$ptid,$rank)=/(\d+)\s*\|\s*(\d+)\s*\|\s*([^|]+)/;
#  print "tid=$tid ptid=$ptid rand=$rank\n";
  $cdb{pa}->insert($tid,$ptid);
  $cdb{ch}->insert($ptid,$tid);
  $rank=~s/^\s+//;
  $rank=~s/\s+$//;
  $cdb{ra}->insert($tid,$rank);
}
close $fhi;

foreach my $k (keys %cdb){
  $cdb{$k}->finish;
  unlink "$dbfile{$k}.$$";
}
