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

my %data;
# old data file
# $(CSV_FUNGIOLD)
# CSV_FUNGIOLD=Katumoto-Wamei.csv
open(my $fhi, '<utf8:', $ARGV[0]) or die;
$_=<$fhi>;
while(<$fhi>){
  my @f = split(/\t/, $_);
  my $sci = join(" ", @f[3,4,5,6]);
  #my $rank = ($f[5] eq 'var.')   ? 'variety'
  #          : ($f[5] eq 'subsp.') ? 'subspecies'
  #          : ($f[5] eq 'forma')  ? 'form'
  #          : 'species';
  my $rank = rank($sci);
  $f[1] or next; # no wamei defined
  $data{$sci} = {wa=>$f[1], rank=>$rank, src=>'fungiold'};
}
close $fhi;

# new data file
# $(CSV_FUNGI)
# CSV_FUNGI=DB20200311.csv
open($fhi, '<utf8:', $ARGV[1]) or die;
$_=<$fhi>;
my $data = join('', <$fhi>);
$data=~s{"([\s\S]*?)"}{
  my $x=$1;
  $x=~s/[\r\n]/ /g;
  $x=~s/\s{1,}/ /g;
  $x;
}eg;
#print $data;

foreach my $l (split(/\n/, $data)){
  my @f = split(/\t/, $l);
  my($genus, $sp, $wa) = @f[2,3,16];
  $wa or next;
  $wa=~/[\p{Han}\p{Hiragana}]/ and next;
  $wa and $data{"$genus $sp"} = {wa=>$wa, rank=>"species", src=>'fungi'};
}

my @d;
foreach my $s (keys %data){
  push(@d, {sci=>$s, wa=>$data{$s}{wa}, rank=>$data{$s}{class}, src=>$data{$s}{src}});
}
tsv(\@d);
