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

            if ($_ == $args{cost})
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
            if ($_ == $args{cost})
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
    return _canonicalize_output(\%args, $args{cost});
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

NetHack::PriceID - ???

=head1 VERSION

Version 0.01 released ???

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use NetHack::PriceID;
    do_stuff();

=head1 DESCRIPTION



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

