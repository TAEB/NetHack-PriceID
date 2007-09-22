#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use NetHack::PriceID 'priceid';

my @p = priceid
(
    charisma => 10,
    sell => 1,
    cost => 250,
    type => '/',
);
is_deeply(\@p, ['death', 'wishing'], 'Selling a wand for $250 at 10 charisma');

@p = priceid
(
    charisma => 10,
    buy      => 1,
    cost     => 500,
    type     => '/',
);
is_deeply(\@p, ['death', 'wishing'], 'Buying a wand for $500 at 10 charisma');

@p = priceid
(
    base     => 1,
    cost     => 500,
    type     => '/',
);
is_deeply(\@p, ['death', 'wishing'], 'Base $500 wands');

