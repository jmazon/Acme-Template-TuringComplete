#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Acme::Template::TuringComplete' ) || print "Bail out!\n";
}

diag( "Testing Acme::Template::TuringComplete $Acme::Template::TuringComplete::VERSION, Perl $], $^X" );
