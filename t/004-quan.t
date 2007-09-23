#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use NetHack::PriceID 'priceid';

my @p = priceid
(
    charisma => 10,
    in       => 'buy',
    amount   => 212,
    type     => '?',
    quan     => 2,
);
is_deeply(\@p,
    ['blank paper', 'enchant armor', 'enchant weapon', 'remove curse'],
        'Buying 2 scrolls for $212 at 10 charisma');

@p = priceid
(
    charisma => 10,
    in       => 'buy',
    amount   => 160,
    type     => '?',
    quan     => 2,
);
is_deeply(\@p,
    ['blank paper', 'enchant weapon'],
        'Buying 2 scrolls for $160 at 10 charisma');

@p = priceid
(
    charisma => 10,
    in       => 'buy',
    amount   => 282,
    type     => '?',
    quan     => 2,
);
is_deeply(\@p,
    ['enchant armor', 'remove curse'],
        'Buying 2 scrolls for $282 at 10 charisma');

