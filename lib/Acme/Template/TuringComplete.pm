#! /usr/bin/env perl

package Acme::Template::TuringComplete;
use 5.010;
use strict;
use warnings;

use Scalar::Util qw( looks_like_number );

our $VERSION = '0.01';

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

1;

__END__

=encoding utf-8

=head1 NAME

Acme::Template::TuringComplete - the full power of Turing machines at your templates' fingertips

=head1 SYNOPSIS

 use Acme::Template::TuringComplete;
 my $output = Acme::Template::TuringComplete->interpret(
   $template,
   @input_arguments
 );

=head1 DESCRIPTION

Acme::Template::TuringComplete aims at providing an alternative to the
legacy templating systems' users, in which Turing completeness would
be an actual serious design element.

The actual language is based on Urban Müller's seminal 1993
programming language research project, with two minor adjustments:

=over 4

=item *

Where there were comments, there are now output string literals.

=item *

Where there were only numbers, there is now support for the major Perl
data types.

=back

=head1 WRITING TEMPLATES

=head2 Language

The following characters are recognized:

=over 4

=item <

Move to the left neighbor on the tape.

=item >

Move to the right neighbor on the tape.

=item +

Increment the item at the current tape position.

=item -

Decrement the item at the current tape position.

=item ,

Read the next positional parameter from the queue to the current tape
position.

=item .

Output the item at the current tape position.

=item [

The behavior of this operator depends on the item at the current tape
position, but the general idea is always that of structured branching.
It is always paired with the closing ] at the matching nesting level.

=over 8

=item *

On a numerical value, perform the inside of the block if strictly
positive, else skip over the block.

=item *

On a string value, perform the inside of the block once per character
in the string, writing them at the current tape position.

=item *

On an array value, perform the inside of the block once per element,
writing them at the current tape position.

=back

=item ]

Match an opening [ character.

=item x

Any other character is output.

=back

=head2 Machine specification

The tape length is infinite and loops.  Going left from the leftmost
tape position is unspecified.

Tape elements are Perl scalars.  Numerics are delegated to the native
Perl numerics.

=head1 EXAMPLES

 interpret('Straight text');
 interpret(',. . . ,. .', Badger, Mushroom);
 interpret(",[After . comes [+++.]\n]", [abc, uvw])
   # anybody say "barewords"?

=head1 META

=over 4

=item *

Author: Jean-Baptiste Mazon

=item *

Context: This was written during YAPC::EU 2014 as supporting material
for a lightning talk.

=item *

Homepage: https://github.com/jmazon/Acme-Template-TuringComplete

=back

=head1 BUGS

I take a generic defined-by-the-implementation approach to this sort
of module.  On the other hand, this didn't make the cut for the talk
and can stil be considered TODO:

=over 4

=item *

compiled templates

=back

=cut
