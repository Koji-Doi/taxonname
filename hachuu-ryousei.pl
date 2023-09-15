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
init();

# TSV_HACHU=hachuu-ryousei.tsv
open(my $fhi, '<:utf8', $ARGV[0]) or die 'File not found';
my $rank='';
my @data;
while(<$fhi>){
  if(m{^<hr/>} .. /footer/){
    if(m{<ul class="rank_(.*)"}){
    #  $rank = $1;
    }elsif(m{<span class="wamei.*?">(.*?)</span><span class="sciname.*?">(.*?)</span>}){
      #print "[$rank] wamei:$1 sci:$2\n";
      my($wa, $sci) = ($1, $2);
      if($wa=~/(\p{Han})$/){
        if(exists $rank{$1}){
          $rank=$rank{$1};
        }else{
          $rank='????';
        }
      }else{
        $rank = 'species';
      }
      push(@data, {sci=>$sci, wa=>$wa, rank=>$rank, src=>'hachuu-ryousei'});
    }elsif(m{^\s*(?:</li>|</ul>)}){
    }else{
      #print "XXXX $_\n";
    }
  }
}

tsv(\@data);
