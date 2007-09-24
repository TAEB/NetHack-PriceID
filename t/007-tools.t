#!perl -T
use strict;
use warnings;
use Test::More tests => 12;
use NetHack::PriceID 'priceid';

my @p = priceid
(
    charisma => 12,
    in       => 'sell',
    amount   => 25,
    type     => '(',
);
is_deeply(\@p, ['magic lamp'], 'Selling a lamp for $25 at 12 charisma');

@p = priceid
(
    charisma => 12,
    in       => 'sell',
    amount   => 25,
    type     => 'lamp',
);
is_deeply(\@p, ['magic lamp'], 'Selling a lamp for $25 at 12 charisma');

@p = priceid
(
    charisma => 12,
    in       => 'sell',
    amount   => 4,
    type     => 'lamp',
);
is_deeply(\@p, ['oil lamp'], 'Selling a lamp for $12 at 12 charisma');

@p = priceid
(
    charisma => 12,
    in       => 'sell',
    amount   => 4,
    type     => '(',
);
is_deeply(\@p, ['oil lamp'], 'Selling a lamp for $12 at 12 charisma');

@p = priceid
(
    charisma => 25,
    in       => 'buy',
    amount   => 5,
    type     => 'lamp',
);
is_deeply(\@p, ['oil lamp'], 'Buying a lamp for $5 at 25 charisma');

@p = priceid
(
    charisma => 25,
    in       => 'buy',
    amount   => 5,
    type     => '(',
);
is_deeply(\@p, ['oil lamp'], 'Buying a lamp for $5 at 25 charisma');

@p = priceid
(
    charisma => 25,
    in       => 'sell',
    amount   => 5,
    type     => 'lamp',
);
is_deeply(\@p, ['oil lamp'], 'Selling a lamp for $5 at 25 charisma');

@p = priceid
(
    charisma => 25,
    in       => 'sell',
    amount   => 5,
    type     => '(',
);
is_deeply(\@p, ['oil lamp'], 'Selling a lamp for $5 at 25 charisma');

@p = priceid
(
    charisma => 25,
    in       => 'sell',
    amount   => 1,
    type     => 'bag',
);
is_deeply(\@p, ['sack'], 'Selling a bag for $1 at 25 charisma');

@p = priceid
(
    charisma => 25,
    in       => 'sell',
    amount   => 1,
    type     => '(',
);
is_deeply(\@p, ['sack'], 'Selling a bag for $1 at 25 charisma');

@p = priceid
(
    charisma => 25,
    in       => 'buy',
    amount   => 1,
    type     => 'bag',
);
is_deeply(\@p, ['sack'], 'Buying a bag for $1 at 25 charisma');

@p = priceid
(
    charisma => 25,
    in       => 'buy',
    amount   => 1,
    type     => '(',
);
is_deeply(\@p, ['sack'], 'Buying a bag for $1 at 25 charisma');

