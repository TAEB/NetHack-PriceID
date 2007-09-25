#!perl -T
use strict;
use warnings;
use Test::More tests => 36;
use NetHack::PriceID 'priceid';

sub test_tool
{
    my ($subtype, $sell, $buy, $expectedbuy, $fullsell, $fullbuy, $charisma) = @_;
    $charisma ||= 10;
    my $expectedsell = $expectedbuy;
    $fullbuy  ||= $expectedbuy;
    $fullsell ||= $expectedsell;

    for my $type ($subtype, 'tool', '(')
    {
        my @p = priceid
        (
            charisma => $charisma,
            in       => 'sell',
            amount   => $sell,
            type     => $type,
        );
        is_deeply(\@p, $expectedsell, "Selling (@$expectedsell) as $type for $sell at $charisma charisma");

        @p = priceid
        (
            charisma => $charisma,
            in       => 'buy',
            amount   => $buy,
            type     => $type,
        );
        is_deeply(\@p, $expectedbuy, "Buying (@$expectedbuy) as $type for $buy at $charisma charisma");

        # after $subtype is run, we need to check the full hits, not just the
        # subtype's hits
        $expectedbuy = $fullbuy;
        $expectedsell = $fullsell;
    }
}

test_tool('lamp', 25, 66, ['magic lamp']);
test_tool('lamp',  5, 13, ['oil lamp'], ['oil lamp', 'wooden flute']);

test_tool('bag', 1, 2, ['sack']);
test_tool('bag', 38, 133, ['bag of holding', 'bag of tricks', 'oilskin sack']);

test_tool('flute',  6, 16, ['wooden flute']);
test_tool('flute', 18, 48, ['magic flute']);

