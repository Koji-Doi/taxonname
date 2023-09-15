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

{
my @d;
# $(CSV_TOGO)
open(my $fhi, '<:utf8', 'species_names_latin_vs_japanese.tsv') or die;
while(<$fhi>){
  (/virus$/ or /virus\s/) and next;
  s/[\n\r]*$//;
  my($sci, $wa, $ref1, $ref2, $date) = split(/\t/, $_);
  my $rank='species';
  $sci=~/^\[-a-zA-Z]+ [-a-zA-Z]+ [-a-zA-Z]+/ and $rank='subspecies';
  $sci=~/subsp\./      and $rank='subspecies';
  $sci=~/var\./        and $rank='variety';
  $sci=~/f\./          and $rank='form';

  push(@d, {sci=>$sci, wa=>$wa, rank=>$rank, src=>"$ref1 $ref2"});
}
tsv(\@d);
}
