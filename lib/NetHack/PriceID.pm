#!perl
package NetHack::PriceID;
use strict;
use warnings;
use parent 'Exporter';
our @EXPORT_OK = qw(priceid priceid_buy priceid_sell priceid_base);

our %glyph2type =
(
    '/' => 'wand',
    '!' => 'potion',
);

our %item_table =
(
    wand =>
    {
        500 => [qw/death wishing/],
    },
    potion =>
    {
        50 => ['booze', 'fruit juice', 'see invisible', 'sickness'],
        250 => [qw/acid oil/],
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

    return @base if $args{out} eq 'base';
    return sort map {@{ $item_table{ $args{type} }{ $_ } }} @base;
}

sub priceid_buy
{
    my %args = _canonicalize_args(@_);
    return $args{cost};
}

sub priceid_sell
{
    my %args = _canonicalize_args(@_);
    return $args{cost} * 2;
}

sub priceid_base
{
    my %args = _canonicalize_args(@_);
    return $args{cost};
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

