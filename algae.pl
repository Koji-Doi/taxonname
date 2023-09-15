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

our %rank;
my @data;
init();

foreach my $infile (@ARGV){
  #print "$infile\n";
  open(my $fhi, '<:utf8', $infile);
  my $body = join('', map {s/[\n\r]*$//; $_} <$fhi>);
  while($body=~m{<tr>(.*?)</tr>}g){
    my $x = $1;
    $x=~s/([<>])\s*/$1/g;
    $x=~s/\s*([<>])/$1/g;
    my($wa, $rank0, $sci) = $x=~m{(\p{Katakana}+)(\p{Han}*)\s*<em>(.*?)</em>};
    my $rank;
    if($wa){
      $rank = ($rank{$rank0})||'????';
    }elsif($x=~m{(\p{Katakana}+)(\p{Han}+)\s*(\w+)</a></td>}){
      ($wa, $rank0, $sci) = ($1, $2, $3);
      $rank = ($rank{$rank0})||'????';
      #print STDERR "---- $1|$2|$3\n";
      $DB::single=1;
    }elsif($x=~m{<td>\s*(\p{Katakana}+)(\p{Han}+)\s*(\w+)\s*</td>}){
      ($wa, $rank0, $sci) = ($1, $2, $3);
      $rank = ($rank{$rank0})||'????';
    }else{
      #print STDERR "$infile:$.:",($_||'?'), "\n";
      next;
    }
    unless($sci and $wa and $rank){
      #print STDERR "infile=$infile\n";
      #print STDERR "$x\n";
      $DB::single=$DB::single=1;
    }
    push(@data, {sci=>$sci, wa=>$wa.$rank0, rank=>$rank, src=>'sorui'});
  }
}

tsv(\@data);
