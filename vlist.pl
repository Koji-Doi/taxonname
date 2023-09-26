#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Data::Dumper;
use lib '/home/kdoi2/l';
use mylib;
use arg;
use lib '.';
use Taxon;

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

my @d;
my %f;
# CSV_VPLANT=wamei_checklist_ver.1.10a.csv
open(my $fhi, '<:utf8', $ARGV[0]) or die;
$_=<$fhi>;
while(<$fhi>){
  s/\s*$//;
  my(undef, undef, $fam, $fam_wa, $wa, undef, undef, undef, undef, undef, $sci) = split(/\t/, $_);
#  print join("\t", $., "fam=$fam $fam_wa", "sci=$sci"),"\n";
  $wa=~/[a-zA-Z0-9]/ and next; # Not wamei
  my $rank = rank($sci);
  push(@d, {sci=>$sci, wa=>$wa, rank=>$rank, src=>'vlist'});
  $f{$fam} = $fam_wa;
}
foreach my $f (sort keys %f){
  push(@d, {sci=>$f, wa=>$f{$f}, rank=>'family', src=>'vlist'});
}
tsv(\@d);
