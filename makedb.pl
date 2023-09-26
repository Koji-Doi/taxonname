#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Data::Dumper;
use CDB_File;
use lib '/home/kdoi2/l';
use mylib;
use arg;

no warnings;
*Data::Dumper::qquote  = sub { return encode "utf8", shift } ;
$Data::Dumper::Useperl = 1 ;
$Data::Dumper::Indent  = 3; # pretty print 配列インデクス付き
# specify hash key/value separator
# $Data::Dumper::Pair = " : ";
use warnings;

binmode STDIN,  ':utf8';
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

my %lj; # latin -> japanese
my %jl; # japanese -> latin

open(my $fhi, '<:utf8', $ARGV[0]) or die "Cannnot open $ARGV[0]";
while(<$fhi>){
  s/\s*$//;
  my @f = split(/\t/, $_);
  ($f[1] eq '－') and next;
  #print STDERR "latin=$f[0], wamei=$f[1]\n";
  $lj{$f[0]}{$f[1]}++;
  $jl{$f[1]}{$f[0]}++;
}

my $dbfile_lj = "taxon_lj.cdb";
my $dbfile_jl = "taxon_jl.cdb";
my $taxondb_lj = new CDB_File($dbfile_lj, $dbfile_lj) or die;
my $taxondb_jl = new CDB_File($dbfile_jl, $dbfile_jl) or die;
foreach my $k (sort keys %lj){
  my $jap = join('/', keys %{$lj{$k}});
  #print STDERR "$jap\n";
  $taxondb_lj->insert($k, $jap);
}
foreach my $k (sort keys %jl){
  my $latin = join('/', keys %{$jl{$k}});
  #print STDERR "$k -> $latin\n";
  $taxondb_jl->insert($k, $latin);
}
$taxondb_lj->finish;
$taxondb_jl->finish;


