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

my @infiles = @ARGV;
my %d;

# $(CSV_TOGO)
#open(my $fhi, '<:utf8', 'species_names_latin_vs_japanese.tsv') or die;
open(my $fhi, '<:utf8', $infiles[0]) or die "$infiles[0] not accessible";
while(<$fhi>){
  (/virus$/ or /virus\s/) and next;
  s/[\n\r]*$//;
  my($sci, $wa, $ref1, $ref2, $date) = split(/\t/, $_);
  my $rank='species';
  $sci=~/^\[-a-zA-Z]+ [-a-zA-Z]+ [-a-zA-Z]+/ and $rank='subspecies';
  $sci=~/subsp\./      and $rank='subspecies';
  $sci=~/var\./        and $rank='variety';
  $sci=~/f\./          and $rank='form';
  my $src = join(", ", $ref1, $ref2, $date);
  $d{$sci}{$wa} = {rank=>$rank, src=>$src};
}

foreach my $infile (@infiles[1..$#infiles]){
  open(my $fhi, '<:utf8', $infile) or die "$infile not accessible";
  while(<$fhi>){
    chomp;
    my($sci, $wa, $rank, $src) = split(/\t/, $_);
    $d{$sci}{$wa} = {rank=>$rank, src=>$src};
  }
}
$DB::single=$DB::single=1;
my @d;
foreach my $sci (keys %d){
  foreach my $wa (keys %{$d{$sci}}){
  #print join("\t", $sci, $wa, $rank, $src), "\n";
    push(@d, {wa=>$wa, sci=>$sci, rank=>$d{$sci}{$wa}{rank}, src=>$d{$sci}{$wa}{src}});
  }
}

tsv(\@d);

