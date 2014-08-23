#! /usr/bin/env perl

package Acme::Template::TuringComplete;
use 5.010;
use strict;
use warnings;

use Scalar::Util qw( looks_like_number );

use Exporter;
our @EXPORT = qw(interpret);

sub interpret {
  my $class = shift;
  my %translation =
    (
      '+' => '$ram[$p]++;',
      '-' => '$ram[$p]--;',
      '>' => '$p++;',
      '<' => '$p--;',
      '[' => '{my$r=$ram[$p];while($ram[$p]=ref$r?shift@$r:looks_like_number$r?$ram[$p]:defined$r?ord substr$r,0,1,"":0){',
      ']' => '}}',
      '.' => '$output.=defined$ram[$p]&&looks_like_number$ram[$p]?chr$ram[$p]:$ram[$p];',
      ',' => '$ram[$p]=shift@args;',
    );
  my ($template,@args) = @_;
  my $program = '';
  for my $c ( $template =~ /./gs ) {
    my $op = $translation{$c};
    $program .= $op // "\$output .= '$c';";
  }

  my @ram;
  my $p = 0;
  my $output = '';

  eval $program;
  $output;
}
