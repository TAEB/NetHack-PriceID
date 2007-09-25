#!perl -T
use strict;
use warnings;
use Test::More tests => 7;
use NetHack::PriceID 'priceid';

my @p = priceid
(
    charisma => 10,
    in       => 'sell',
    amount   => 40,
    type     => 'armor',
);
is_deeply(\@p, ['cornuthaum'], 'Selling armor for $40 at 10 charisma');

for (1..6)
{
    my $price = 40 + 5 * $_;

    @p = priceid
    (
        charisma => 10,
        in       => 'sell',
        amount   => $price,
        type     => 'armor',
    );
    is_deeply(\@p, ["+$_ cornuthaum"],
        "Selling armor for \$$price at 10 charisma");
}

