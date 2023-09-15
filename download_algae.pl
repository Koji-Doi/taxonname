#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Data::Dumper;
use lib '/home/kdoi2/l';
use mylib;
use arg;
use mysystem;

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

foreach my $a (qw/Red Green Brown/){
  foreach my $b (qw/A Ka Sa Ta Na Ha Ma Ya Ra Wa/){
    my $url = "https://tonysharks.com/Seaweeds_list/Seaweeds_index/${a}_${b}_all.html";
    my $r = mysystem("wget $url");
    if($r==0){
      print STDERR "Succeeded to access $url, probably.\n";
    }else{
      die "Trouble occurred. Possibly we failed to execute 'wget $url'";
    }
    sleep 5;
  }
}
