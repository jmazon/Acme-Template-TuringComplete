#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

#plan tests => 1;

use Acme::Template::TuringComplete;

sub interpret { Acme::Template::TuringComplete->interpret(@_) }

is( interpret( 'Straight text' ), 'Straight text', 'Straight text' );

is( interpret( <<TEMPLATE ), <<RESULT, 'Iteration' );
+++[
  * repeated three times
-]
TEMPLATE

  * repeated three times

  * repeated three times

  * repeated three times

RESULT

is( interpret( <<TEMPLATE ), <<RESULT, 'Iteration' );
++++++++++[>+++++++>++++++++++>+++>+++++++++<<<<-]
>++.>+.+++++++..+++.>++.>---.<<.+++.------.--------.>+.
TEMPLATE

Hello World!
RESULT

is( interpret( ',>[-]+++[<{.}>-]', 'Badger' ), 
    '{Badger}{Badger}{Badger}',
    'Repetition' );

is( interpret( ',[.]', [qw(Iterating on an array)] ),
    'Iteratingonanarray',
    'Array iteration' );

is( interpret( ',[=.]=', 'Iterating within a string' ),
    '=I=t=e=r=a=t=i=n=g= =w=i=t=h=i=n= =a= =s=t=r=i=n=g=',
    'String Iteration' );

is( interpret( <<TEMPLATE, 'Qrpelcgvat n zvyvgnel-tenqr pvcure' ),
,[[>>++++[>++++++++<-]<+<-[>+>+>-[>>>]<[[>+<-]>>+>]<<<<<-]]>>>[-]+>--[-[<->+++[-]]]<[++++++++++++<[>-[>+>>]>[+[<+>-]>+>>]<<<<<-]>>[<+>-]>[-[-<<[-]>>]<<[<<->>-]>>]<<[<<+>>-]]<[-]<.[-]<-]
TEMPLATE
    "Decrypting a military-grade cipher\n",
    'Military-grade cipher decryption' );

done_testing;
