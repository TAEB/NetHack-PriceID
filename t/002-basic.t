#!perl -T
use strict;
use warnings;
use Test::More tests => 1;
use NetHack::PriceID 'priceid';

my @p = priceid
(
    charisma => 10,
    in       => 'buy',
    cost     => 106,
    type     => '?',
);
is_deeply(\@p, ['enchant armor', 'remove curse'],
    'Buying a scroll for $106 at 10 charisma');

