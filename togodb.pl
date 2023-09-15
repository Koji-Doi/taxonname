#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Data::Dumper;
use JSON::PP;
use lib '/home/kdoi2/l';
use mylib;
use arg;
use Encode;
use Lingua::JA::Regular::Unicode qw/hiragana2katakana/;

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

open(my $fhi, '<',      'species_names_latin_vs_japanese.json') or die;
open(my $fho, '>:utf8', 'species_names_latin_vs_japanese.tsv') or die;
my $d = join('', <$fhi>);
my $data = decode_json $d;
for(my $i=0; $i<=$#$data; $i++){
  $data->[$i]{col2} = hiragana2katakana($data->[$i]{col2});
  print {$fho} join("\t", map {$data->[$i]{$_}} qw/col1 col2 col3 col4 col5/), "\n";
}
