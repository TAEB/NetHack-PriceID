#!perl -T
use strict;
use warnings;
use Test::More tests => 24;
use NetHack::PriceID 'priceid';

sub test_tool
{
    my ($subtype, $expected, $full, $sell, $buy, $charisma) = @_;
    $charisma ||= 10;
    $full ||= $expected;

    for my $type ($subtype, 'tool', '(')
    {
        my @p = priceid
        (
            charisma => $charisma,
            in       => 'sell',
            amount   => $sell,
            type     => $type,
        );
        is_deeply(\@p, $expected, "Selling (@$expected) as $type for $sell at $charisma charisma");

        @p = priceid
        (
            charisma => $charisma,
            in       => 'buy',
            amount   => $buy,
            type     => $type,
        );
        is_deeply(\@p, $expected, "Buying (@$expected) as $type for $buy at $charisma charisma");

        # after $subtype is run, we need to check the full hits, not just the
        # subtype's hits
        $expected = $full;
    }
}

test_tool('lamp', ['magic lamp'], undef, 25, 66);
test_tool('lamp', ['oil lamp'],   undef,  5, 13);

test_tool('bag',  ['sack'], undef, 1, 2);
test_tool('bag',  ['bag of holding', 'bag of tricks', 'oilskin sack'], undef, 38, 133);

