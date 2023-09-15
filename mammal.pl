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
my %ranks;
my @ranknames =qw/order suborder infraorder family subfamily tribe genus/;
# CSV_MAMMAL0=list_20211223.csv
open(my $fhi, '<:utf8', $ARGV[0]) or die;
$_=<$fhi>;
while(<$fhi>){
  my %la; my %wa;
  ($la{order},  $wa{order},  $la{suborder},  $wa{suborder},  $la{infraorder}, $wa{infraorder},
   $la{family}, $wa{family}, $la{subfamily}, $wa{subfamily}, $la{tribe},      $wa{tribe},
   $la{genus},  $wa{genus},  $la{species},   $wa{species}) = split(/\t/, $_);
  $wa{species} or next;
  my $sci = "$la{genus} $la{species}";
  my @s = split(/\s+/, $sci);
  my $sci1; # remove author names
  if($s[2]){
    $sci1 = join(' ', ($s[2]=~/^[A-Z]/) ? @s[0,1] : @s[0..2]);
  }else{
    ($s[1]) or print "!!! $.:$sci\n";
    $sci1 = "$s[0] $s[1]";
  }
  foreach my $r (@ranknames){
    ($r eq 'species') or $la{$r} = ucase($la{$r});
    ($wa{$r}) and $ranks{$r}{$la{$r}} = $wa{$r};
  }
  push(@d, {wa=>$wa{species}, sci=>$sci, rank=>'species', src=>'mammal'});
}
#print Dumper %ranks; exit;

tsv(\@d);
foreach my $r (@ranknames){
  my @x;
  foreach my $k (keys %{$ranks{$r}}){
    push(@x, {wa=>$ranks{$r}{$k}, sci=>$k, src=>'mammal', rank=>$r});
  }
  tsv(\@x);
}
