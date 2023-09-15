use strict;
use warnings;
use utf8;
use Data::Dumper;

our %rank;
our %rank_lj;

sub init{
  %rank = qw{門 division/phylum
   亜門 subdivision/subphylum
   上区 supercohort
   区 cohort
   亜区 subcohort
   下区 infracohort
   上綱 superclass
   綱 class
   亜綱 subclass
   上団 superlegion
   団 legion
   亜団 sublegion
   下団 infralegion
   上区 supercohort
   区 cohort
   亜区 subcohort
   巨目 magnorder
   上目 superorder
   大目 grandorder
   中目 mirorder
   目 order
   亜目 suborder
   下目 infraorder
   小目 parvorder
   上科 superfamily
   科 family
   亜科 subfamily
   族 tribe
   亜族 subtribe
   連 tribe
   亜連 subtribe
   属 genus
   亜属 subgenus
   節 section
   亜節 subsection
   種 species
   亜種 subspicies
   変種 variety
   品種 form
  };
  $rank{''} = 'species';
  foreach my $k (keys %rank){
    $rank_lj{$rank{$k}} = $k;
  }
}

sub tsv{
  my($x) = @_;
  my $xx;
  (defined $rank{'種'}) or init();
  if(ref $x eq 'ARRAY'){
    $xx = $x;
  }else{
    $xx->[0] = $x;
  }
  foreach my $i (@$xx){
    $DB::single=1;
    exists($rank_lj{$i->{rank}}) or warn("Illegal rank name: ".$i->{rank});
    print join(
      "\t", map {
        my $x = $i->{$_}; $x=~s/^\s*//; $x=~s/\s*$//; $x;
      } qw/sci wa rank src/
    ), "\n";
  }
}

sub rank{
  my($x0) = @_;
  (defined $rank{'種'}) or init();
  $DB::single=$DB::single=1;
  my(@w) =  split(/\s+/, $x0);
  $w[2] ||= '';
  my $rank = ($x0=~/^\[-a-zA-Z]+ [-a-zA-Z]+ [-a-zA-Z]+/) ? 'subspecies' : 'species';
     $rank = ($x0=~/var\./)   ? 'variety'
           : ($x0=~/subsp\./) ? 'subspecies'
           : ($x0=~/forma/)   ? 'form'
           : ($x0=~/f\./)     ? 'form'
           : $rank;
  return($rank);
}

sub ucase{
  my($x) = @_;
  return(ucfirst(lc($x)));
}

1;
