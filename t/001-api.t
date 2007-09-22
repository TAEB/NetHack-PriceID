#!perl -T
use strict;
use warnings;
use Test::More tests => 10;
use NetHack::PriceID 'priceid';

my @p = priceid
(
    charisma => 10,
    in       => 'sell',
    cost     => 250,
    type     => '/',
);
is_deeply(\@p, ['death', 'wishing'], 'Selling a wand for $250 at 10 charisma');

@p = priceid
(
    charisma => 10,
    in       => 'buy',
    cost     => 666,
    type     => '/',
);
is_deeply(\@p, ['death', 'wishing'], 'Buying a wand for $666 at 10 charisma');

@p = priceid
(
    in       => 'base',
    cost     => 500,
    type     => '/',
);
is_deeply(\@p, ['death', 'wishing'], 'Base $500 wands');

@p = priceid
(
    charisma => 10,
    in       => 'sell',
    cost     => 250,
    type     => '/',
    out      => 'base',
);
is_deeply(\@p, [500], 'out => "base" lists only valid prices');

@p = priceid
(
    charisma => 10,
    in       => 'base',
    cost     => 500,
    type     => '/',
    out      => 'base',
);
is_deeply(\@p, [500], 'out => "base" lists only valid prices');

@p = priceid
(
    charisma => 10,
    in       => 'base',
    cost     => 500,
    type     => 'wand',
    out      => 'hits',
);
is_deeply(\@p, ['death', 'wishing'], 'type works with words and glyphs');

@p = priceid
(
    charisma => 10,
    in       => 'base',
    cost     => 50,
    type     => 'potion',
    out      => 'hits',
);
is_deeply(\@p, ['booze', 'fruit juice', 'see invisible', 'sickness'],
    'testing different types');

@p = priceid
(
    charisma => 10,
    in       => 'base',
    cost     => 50,
    type     => '!',
    out      => 'base',
);
is_deeply(\@p, [50], 'base price of base 50 potions');

@p = priceid
(
    charisma => 10,
    in       => 'base',
    cost     => 250,
    type     => '!',
    out      => 'base',
);
is_deeply(\@p, [250], 'base price of base 250 potions');

@p = priceid
(
    charisma => 10,
    in       => 'base',
    cost     => 250,
    type     => '!',
);
is_deeply(\@p, [qw/acid oil/], 'base 250 potions');

