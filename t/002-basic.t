#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use NetHack::PriceID 'priceid';

my @p = priceid
(
    charisma => 10,
    in       => 'buy',
    cost     => 106,
    type     => '?',
);
is_deeply(\@p,
    ['blank paper', 'enchant armor', 'enchant weapon', 'remove curse'],
        'Buying a scroll for $106 at 10 charisma');

@p = priceid
(
    charisma => 10,
    in       => 'buy',
    cost     => 80,
    type     => '?',
);
is_deeply(\@p, ['blank paper', 'enchant weapon'],
    'Buying a scroll for $80 at 10 charisma');

@p = priceid
(
    charisma => 10,
    in       => 'buy',
    cost     => 141,
    type     => '?',
);
is_deeply(\@p, ['enchant armor', 'remove curse'],
    'Buying a scroll for $141 at 10 charisma');

