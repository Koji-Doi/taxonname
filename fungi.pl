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
  my @f = split(/ *\t */, $_);
  #my $sci = join(" ", map {$_||''} @f[3,4,5,6]);
  #my $rank = ($f[5] eq 'var.')   ? 'variety'
  #          : ($f[5] eq 'subsp.') ? 'subspecies'
  #          : ($f[5] eq 'forma')  ? 'form'
  #          : 'species';
  my $sci = $f[2];
  my $rank = rank($sci);
  unless($f[0]){
    print "$.: ?????\n";
  }
  $f[1] or next; # no wamei defined
  $data{$sci} = {wa=>$f[1], rank=>$rank, src=>'fungi1'};
}
close $fhi;

# new data file
# $(CSV_FUNGI)
# CSV_FUNGI=DB20200311.csv
open($fhi, '<utf8:', $ARGV[1]) or die;

=begin c
1-0       : NID
1-1       : Status
1-2       : Genus
1-3       : SpEpithet
1-4       : Author
1-5       : ISRank
1-6       : ISEpithet
1-7       : ISAuthor
1-8       : MB
1-9       : Basionym
1-10      : BasJoun
1-11      : Journal
1-12      : Vol
1-13      : Page
1-14      : Year
1-15      : Writer
1-16      : Wamei
1-17      : Habitat
1-18      : Specimen
1-19      : Note
1-20      : RecBy
1-21      : RegDate
=end c
=cut

$_=<$fhi>;

=begin c
my $data = join('', <$fhi>);
$data=~s{"([\s\S]*?)"}{
  my $x=$1;
  $x=~s/[\r\n]/ /g;
  $x=~s/\s{1,}/ /g;
  $x;
}eg;
#print $data;

foreach my $l (split(/\n/, $data)){
  my @f = split(/\s*\t\s*/, $l);
  if($#f!=21){
    print STDERR $#f, " $f[2] $f[3]\n";
    $DB::single=$DB::single=1;
  }
  if($f[16]=~/\w/){
    $DB::single=$DB::single=1;
  }
=end c
=cut

while(<$fhi>){
  s/\s*$//;
  my @f = split(/ *\t */, $_);
  my($genus, $sp, $wa) = @f[2,3,16];
  $wa or next;
  $wa=~s/　.*//;
  $wa=~s/（.*//;
  if($wa=~/\d/){
    $DB::single=$DB::single=1;
  }
  $wa=~/[\p{Han}\p{Hiragana}]/ and next;
  $wa and $data{"$genus $sp"} = {wa=>$wa, rank=>"species", src=>'fungi2'};
}

my @d;
foreach my $s (keys %data){
  push(@d, {sci=>$s, wa=>$data{$s}{wa}, rank=>$data{$s}{rank}, src=>$data{$s}{src}});
}
tsv(\@d);
