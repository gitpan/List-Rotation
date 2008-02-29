package List::Rotation;
use vars qw( $VERSION );
$VERSION = sprintf "%d.%03d", q$Revision: 1.9 $ =~ m/ (\d+) \.? (\d+)? /x;

package List::Rotation::Cycle;
use strict;
use warnings;

use Memoize;
memoize('new');

sub new {
    my $class = shift;

    do {
        require Carp;
        Carp::croak ("Incorrect number of arguments; must be >= 1.");
    } unless 1 <= @_;
    my $r_values = [ @_ ];
    my $next = 0;
    my $length = @$r_values;

    my $method = {
        _next => sub {
            my $i = $next % $length;
            $next++;
            return $r_values->[$i];
        },
        _reset => sub {
            $next = 0;
        },
    };

    my $closure = sub {
        my $call = shift;
        &{ $method->{$call} };
    };

    bless $closure, $class;
}

sub next  { my $self = shift; &{ $self }( '_next'  ); }
sub reset { my $self = shift; &{ $self }( '_reset' ); }

#-------------------------------------------------------------------------------

package List::Rotation::Alternate;

use strict;

use vars qw( @ISA );
@ISA = qw(List::Rotation::Cycle);  

sub new {
    my $class = shift;

    do {
        require Carp;
        Carp::croak ("Incorrect number of arguments; must be <2>.");
    } unless 2 == @_;

    $class->SUPER::new(@_);
}

#-------------------------------------------------------------------------------

package List::Rotation::Toggle;

use strict;

use vars qw( @ISA );
@ISA = qw(List::Rotation::Alternate);  

sub new {
    my $class = shift;

    do {
        require Carp;
        Carp::croak ("No arguments accepted.");
    } unless 0 == @_;

    $class->SUPER::new( 1 == 1, 0 == 1 );
}

#-------------------------------------------------------------------------------

1;


__END__

=head1 NAME

List::Rotation - Loop (Cycle, Alternate or Toggle) through a list of values via a singleton object implemented as closure.

=head1 SYNOPSIS

    use List::Rotation;

    my @array = qw( A B C );

    my $first_cycle  = List::Rotation::Cycle->new(@array);
    my $second_cycle = List::Rotation::Cycle->new(@array);  ##  the same object is returned as above

    print $first_cycle->next;  ## prints A
    print $second_cycle->next; ## prints B
    print $first_cycle->next;  ## prints C
    print $second_cycle->next; ## prints A, looping back to beginning

    my $alternation  = List::Rotation::Alternate->new( qw( odd even ) );

    print $alternation->next;  ## prints odd
    print $alternation->next;  ## prints even
    print $alternation->next;  ## prints odd
    $alternation->reset;       ## reset the alternation to first item
    print $alternation->next;  ## prints odd

    my $switch  = List::Rotation::Toggle->new;

    ##  prints even numbers between 2 and 10
    foreach ( 2..10 ) {
        print "$_\n" if $switch->next;
    }

=head1 DESCRIPTION

Use C<List::Rotation> to loop through a list of values.
Once you get to the end of the list, you go back to the beginning.

C<List::Rotation> is implemented as a Singleton Pattern. You always just
get 1 (the very same) Rotation object even if you use the C<new> method several times
with the same set of parameters.
This is done by using C<Memoize> on the C<new> method. It returns the same object
for every use of C<new> that comes with the same list of parameters.

The class C<List::Rotation> contains three subclasses:

=over 4

=item C<List::Rotation::Cycle>

Loop through a list of arbitrary values. The list must not be empty.

=item C<List::Rotation::Alternate>

Alternate two values.

=item C<List::Rotation::Toggle>

Toggle between true and false.

=back

=head1 OBJECT METHODS

=over 4

=item new

Create a Cycle object for the list of values in the list.

=item next

Return the next element.  This method is implemented as a closure.

=item reset

Reset the list to the beginning; the following call of C<next> will return the first item of the list again.  This method is implemented as a closure.

=back

=head1 References

There are several similar modules available:

=over 4

=item C<Tie::FlipFlop>

by Abigail:
Alternate between two values.

=item C<List::Cycle>

by Andi Lester:
Objects for cycling through a list of values

=item C<Tie::Cycle>

by Brian D. Foy:
Cycle through a list of values via a scalar.

=item C<Tie::Toggle>

by Brian D. Foy:
False and true, alternately, ad infinitum.

=back

=head1 AUTHOR

Imre Saling, C<< <pelagicatcpandotorg> >>

=head1 COPYRIGHT and LICENSE

Copyright 2007, Imre Saling, All rights reserved.

This software is available under the same terms as perl.

=cut
