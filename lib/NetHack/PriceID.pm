#!perl
package NetHack::PriceID;
use strict;
use warnings;
use integer;

use parent 'Exporter';
our @EXPORT_OK = qw(priceid priceid_buy priceid_sell priceid_base);

our %glyph2type =
(
    '"' => 'amulet',
    '?' => 'scroll',
    '+' => 'spellbook',
    '=' => 'ring',
    '!' => 'potion',
    '/' => 'wand',
);

our %item_table =
(
    amulet =>
    {
            0 => ['cheap plastic imitation of the Amulet of Yendor'],
          150 => ['change', 'ESP', 'life saving', 'magical breathing',
                  'reflection', 'restful sleep', 'strangulation',
                  'unchanging', 'versus poison'],
        30000 => ['Amulet of Yendor'],
    },

    scroll =>
    {
        20  => ['identify'],
        50  => ['light'],
        60  => ['blank paper', 'enchant weapon'],
        80  => ['enchant armor', 'remove curse'],
        100 => ['confuse monster', 'destroy armor', 'fire',
                'food detection', 'gold detection', 'magic mapping',
                'scare monster', 'teleportation'],
        200 => ['amnesia', 'create monster', 'earth', 'taming'],
        300 => ['charging', 'genocide', 'punishment', 'stinking cloud'],
    },

    spellbook =>
    {
        100 => ['detect monsters', 'force bolt', 'healing', 'jumping',
                'knock', 'light', 'protection', 'sleep'],
        200 => ['confuse monster', 'create monster', 'cure blindness',
                'detect food', 'drain life', 'magic missile',
                'slow monster', 'wizard lock'],
        300 => ['cause fear', 'charm monster', 'clairvoyance',
                'cure sickness', 'detect unseen', 'extra healing',
                'haste self', 'identify', 'remove curse',
                'stone to flesh'],
        400 => ['cone of cold', 'detect treasure', 'fireball',
                'invisibility', 'levitation', 'restore ability'],
        500 => ['dig', 'magic mapping'],
        600 => ['create familiar', 'polymorph', 'teleport away',
                'turn undead'],
        700 => ['cancellation', 'finger of death'],
    },

    potion =>
    {
        0   => ['uncursed water'],
        50  => ['booze', 'fruit juice', 'see invisible', 'sickness'],
        100 => ['confusion', 'extra healing', 'hallucination', 'healing',
                'restore ability', 'sleeping', '(un)holy water'],
        150 => ['blindness', 'gain energy', 'invisibility',
                'monster detection', 'object detection'],
        200 => ['enlightenment', 'full healing', 'levitation', 'polymorph',
                'speed'],
        250 => ['acid', 'oil'],
        300 => ['gain ability', 'gain level', 'paralysis'],
    },

    ring =>
    {
        100 => ['adornment', 'hunger', 'protection',
                'protection from shape changers', 'stealth',
                'sustain ability', 'warning'],
        150 => ['aggravate monster', 'cold resistance',
                'gain constitution', 'gain strength', 'increase accuracy',
                'increase damage', 'invisibility', 'poison resistance',
                'see invisible', 'shock resistance'],
        200 => ['fire resistance', 'free action', 'levitation',
                'regeneration', 'searching', 'slow digestion',
                'teleportation'],
        300 => ['conflict', 'polymorph', 'polymorph control',
                'teleport control'],
    },

    wand =>
    {
        0   => ['uncharged'],
        100 => ['light', 'nothing'],
        150 => ['digging', 'enlightenment', 'locking', 'magic missile',
                'make invisible', 'opening', 'probing',
                'secret door detection', 'slow monster', 'speed monster',
                'striking', 'undead turning'],
        175 => ['cold', 'fire', 'lightning', 'sleep'],
        200 => ['cancellation', 'create monster', 'polymorph',
                'teleportation'],
        500 => ['death', 'wishing'],
    },
);

sub priceid
{
    my %args = _canonicalize_args(@_);
    my @base;

    if ($args{in} eq 'sell')
    {
        @base = priceid_sell(%args, out => 'base');
    }
    elsif ($args{in} eq 'buy')
    {
        @base = priceid_buy(%args, out => 'base');
    }
    elsif ($args{in} eq 'base')
    {
        @base = priceid_base(%args, out => 'base');
    }

    return _canonicalize_output(\%args, @base);
}

sub priceid_buy
{
    my %args = _canonicalize_args(@_);
    my @base;

    for my $base (keys %{ $item_table{ $args{type} } })
    {
        my $tmp = $base;

        $tmp = 5 if !$tmp;

        my $surcharge = $tmp + $tmp / 3;

        for ($tmp, $surcharge)
        {
            $_ += $_ / 3 if $args{tourist};
            $_ += $_ / 3 if $args{dunce};

               if ($args{charisma} > 18) { $_ /= 2      }
            elsif ($args{charisma} > 17) { $_ -= $_ / 3 }
            elsif ($args{charisma} > 15) { $_ -= $_ / 4 }
            elsif ($args{charisma} < 6)  { $_ *= 2      }
            elsif ($args{charisma} < 8)  { $_ += $_ / 2 }
            elsif ($args{charisma} < 11) { $_ += $_ / 3 }

            $_ = 1 if $_ <= 0;

            if ($args{angry}) { $_ += ($_ + 2) / 3 }

            if ($_ == $args{amount})
            {
                push @base, $base;
                last;
            }
        }
    }

    return _canonicalize_output(\%args, @base);
}

sub priceid_sell
{
    my %args = _canonicalize_args(@_);
    my @base;

    for my $base (keys %{ $item_table{ $args{type} } })
    {
        my $tmp = $base;

        if ($args{tourist})  { $tmp /= 3 }
        elsif ($args{dunce}) { $tmp /= 3 }
        else                 { $tmp /= 2 }

        my $surcharge = $tmp - $tmp / 4;
        $surcharge = $tmp unless $tmp > 1;

        for ($tmp, $surcharge)
        {
            if ($_ == $args{amount})
            {
                push @base, $base;
                last;
            }
        }
    }

    return _canonicalize_output(\%args, @base);
}

sub priceid_base
{
    my %args = _canonicalize_args(@_);
    return _canonicalize_output(\%args, $args{amount});
}

sub _canonicalize_args
{
    my %args =
    (
        in => 'base',
        out => 'hits',
        charisma => 10,
        @_,
    );

    $args{type} = $glyph2type{ $args{type} } || $args{type};

    return %args;
}

sub _canonicalize_output
{
    my $args = shift;

    return sort @_ if $args->{out} eq 'base';
    return sort map {@{ $item_table{ $args->{type} }{ $_ } }} @_;
}

=head1 NAME

NetHack::PriceID - identify items using shopkeepers

=head1 VERSION

Version 0.01 released 23 Sep 07

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use NetHack::PriceID 'priceid';
    print join ', ', priceid(charisma => 13,
                             type => '?',
                             amount => 100,
                             in => 'sell');

=head1 DESCRIPTION

NetHack, the game of hackers, has a large item-identification subgame. The
quickest way to gauge how useful an item is is to "price identify" it. This
involves trying to buy or sell the item in a store, which tells you its price.
Item types (scrolls, potions, wands, etc) are divided into about five price
groups each -- price IDing cuts down a large number of possible identities of
an item.

The calculations for price IDing aren't that difficult, but making sure to get
all the edge cases (such as trying to identify items while the shopkeeper is
attacking you -- and charging you more money) can be twiddly.

=head1 FUNCTIONS

=head2 priceid PARAMHASH

This is the method most people will be using. It will transform a amount and
other information into possible identities. Its arguments are passed as a
hash:

=over 4

=item amount => INT (required)

The amount ("cost") of the item. How the priceid function interprets this
amount is dependent on the C<in> parameter.

=item in => buy|sell|base

What kind of operation. C<base> assumes the C<amount> is the base price. C<buy>
assumes the C<amount> is the amount of money the shopkeeper is charging you for
the item. C<sell> assumes the C<amount> is the amount of money the shopkeeper is
willing to give you in exchange for the item.

=item charisma => 3..25 (required for buy and sell)

The charisma of the character. Base price is independent of charisma, so it's
required only for buying and selling.

=item out => base|hits (default: hits)

The output format. C<base> will return 0, 1, or 2 possible base prices that
the input can be. Buying and selling always map to two prices, but some of
those prices do not have items. C<hits> will return the actual names of the
possible items.

=item tourist => BOOL (default: false)

Determines whether the character suffers from the "tourist" charge. Shopkeepers
(as they presumably do in real life) will charge extra if they think you're a
tourist. Characters 

=head1 SEE ALSO

L<Foo::Bar>

=head1 AUTHOR

Shawn M Moore, C<< <sartak at gmail.com> >>

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-nethack-priceid at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=NetHack-PriceID>.

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc NetHack::PriceID

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/NetHack-PriceID>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/NetHack-PriceID>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=NetHack-PriceID>

=item * Search CPAN

L<http://search.cpan.org/dist/NetHack-PriceID>

=back

=head1 COPYRIGHT AND LICENSE

Copyright 2007 Shawn M Moore.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

