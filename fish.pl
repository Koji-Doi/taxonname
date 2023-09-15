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
my @f;
# CSV_FISH=20230801_JAFList.csv
open(my $fhi, '<:utf8', $ARGV[0]) or die;
$_=<$fhi>;
while(<$fhi>){
  my(undef, $fam_wa, $fam_sci, $wa, $sci, @f) = split(/\t/, $_);
  $sci=~s/\(.*?\)//g;
  my @s = split(/\s+/, $sci);
  my $sci1; # remove author names
  if($s[2]){
    $sci1 = join(' ', ($s[2]=~/^[A-Z]/) ? @s[0,1] : @s[0..2]);
  }else{
    ($s[1]) or print "!!! $.:$sci\n";
    $sci1 = "$s[0] $s[1]";
  }
  #print "wa=$wa, sci=$sci sci1=$sci1\n";
  $f{$fam_sci}=$fam_wa;
  push(@d, {wa=>$wa, sci=>$sci, rank=>'species', src=>'fish'});
}
foreach my $s (sort keys %f){
  push(@f, {sci=>$s, wa=>$f{$s}, rank=>'family', src=>'fish'});
}

tsv(\@d);
tsv(\@f);
