#!/usr/bin/env perl
=head1 NAME

Arg.pm - wrapper of Getopts::Long

=head1 SYNOPSIS

useAarg;

my($infile, $outfile, $overwrite);

arg(
  "input=s input file name"   => \$infile,
  "output=s output file name" => \$outfile,
  "overwrite"                 => \$overwrite

);

=head1 DESCRIPTION

Getopts::Long is a very useful module. However, there is one problem that makes the module seriously difficult to use. It is the use of both upper and lower case letters in the module and function names. I can't find any reasonable rules on how to use them. Another thing that annoys me as a Japanese speaker is the use of singular and plural forms. Why is GetOpt::Long not Getopt::long? And why is Getoptions not Getoption or GetOptions?

I've been using GetOpt::Long from time to time for over a decade now, and every time I call a module or use a function, I'm forced to consult the online help to make sure I spelled it correctly. I'm sick of it. So I decided to create a wrapper for the module so that I don't have to worry about this at all in the future.

The module is called arg.pm, and it can call GetOptions() as arg() of the same name. Simple and foolproof. No more online help, no more shift key. Good riddance.

In addition, arg.pm can give the target perl script the command line option "-h" for brief description of command line options.

=cut

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;

sub argv{
  my(%x)=@_;
  my %opt; my @dl;
  foreach my $key (sort keys %x){
    my($key1, $desc) = $key=~/(\S+)?(?:\s*(.*))?/;
    my($k,$k2,$t)    = $key1=~/(([^=]+)(?:=(\S+))?)/;
    $opt{$key1}         = $x{$key};
    ($t) or       $t = "s";
    my $t2 = ($t eq 's')?'string'
            :($t eq 'i')?'integer'
            :($t eq 'f')?'floating point value':'';
    push(@dl, "--$k2:\ttype=$t2. $desc");
  }
  (defined $dl[0]) and (not defined $opt{help}) and $opt{help}=sub {print join("\n", @dl), "\n"; exit()};
  GetOptions(%opt);
}
*arg = *argv;
1;

