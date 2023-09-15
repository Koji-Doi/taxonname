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

open(my $fhi, '<:utf8', $ARGV[0]) or die;
# 学名 withAuthor       和名    別名    ステータス      LAPG 科名       LAPG Family     LAPG no.        Cronquist 科名  Cronquist family        cronquist No.   Engler 科名     Engler family   Engler no.      生態    学名    修正日  ID      発表年  LAPGII::LAPG Family広義 LAPGII::LAPG Order      LAPGII::LAPG 目 LAPGII::LAPGno. LAPGII::LAPG科名        LAPGII::LAPG Family狭義
$_=<$fhi>;
my $data = join('', <$fhi>);
my @d; # output
$data=~s{"([\s\S]*?)"}{
  my $x=$1;
  $x=~s/[\r\n]/ /g;
  $x=~s/\s{1,}/ /g;
  $x;
}eg;
#print $data;

foreach my $l (split(/\n/, $data)){
  my @f = split(/\t/, $l);
#  print join("\t", $i, @f[14,1]),"\n";
  push(@d, {wa=>$f[1], sci=>$f[14]}, rank=>$rank, src=>'ylist'});
}

tsv(\@d);
