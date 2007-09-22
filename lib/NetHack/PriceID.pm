#!perl
package NetHack::PriceID;
use strict;
use warnings;
use parent 'Exporter';
our @EXPORT_OK = qw(priceid);

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
    my %args = _canonicalize_input(@_);

    return $args{cost} if $args{out} eq 'base';
    return @{ $item_table{ $args{type} }{ $args{cost} } };
}

sub _canonicalize_input
{
    my %args =
    (
        in => 'base',
        out => 'hits',
        charisma => 10,
        @_,
    );

    $args{cost} *= 2 if $args{in} eq 'sell';
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

