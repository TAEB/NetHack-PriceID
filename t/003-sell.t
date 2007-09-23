#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use NetHack::PriceID 'priceid';

my @p = priceid
(
    charisma => 10,
    in       => 'sell',
    cost     => 30,
    type     => '?',
);

is_deeply(\@p,
    ['blank paper', 'enchant armor', 'enchant weapon', 'remove curse'],
        'Selling a scroll for $30 at 10 charisma');

my @p = priceid
(
    charisma => 10,
    in       => 'sell',
    cost     => 23,
    type     => '?',
);

is_deeply(\@p,
    ['blank paper', 'enchant weapon'],
        'Selling a scroll for $23 at 10 charisma');

my @p = priceid
(
    charisma => 10,
    in       => 'sell',
    cost     => 40,
    type     => '?',
);

is_deeply(\@p,
    ['enchant armor', 'remove curse'],
        'Selling a scroll for $40 at 10 charisma');

