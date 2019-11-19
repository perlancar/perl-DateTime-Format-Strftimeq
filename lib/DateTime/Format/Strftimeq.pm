package DateTime::Format::Strftimeq;

# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use DateTimeX::strftimeq;

sub new {
    my ($class, %args) = @_;

    my $self = {};

    if (defined(my $time_zone = delete $args{time_zone})) {
        $self->{time_zone} = do {
            if (ref $time_zone) {
                $time_zone;
            } else {
                require DateTime::TimeZone;
                DateTime::TimeZone->new(name => $time_zone);
            }
        };
    }

    $self->{format} = delete $args{format};
    defined $self->{format} or die "Please specify 'format'";

    if (keys %args) {
        die "Unknown attribute(s): ".join(", ", sort keys %args);
    }

    bless $self, $class;
}

sub format_datetime {
    my ($self, $dt) = @_;

    if ($self->{time_zone}) {
        $dt = $dt->clone->set_time_zone($self->{time_zone});
    }

    strftimeq($self->{format}, $dt);
}

1;
# ABSTRACT: Format DateTime object using DateTimeX::strftimeq

=head1 SYNOPSIS

 use DateTime::Format::Strftimeq;

 my $format = DateTime::Format::Strftimeq->new(
     # time_zone => '...',    # optional, default is DateTime object's time zone
     format => '%Y-%m-%d%( $_->day_of_week == 7 ? "su" : "" )q',
 );

 my $dt1 = DateTime->new(year=>2019, month=>11, day=>19);
 my $dt1 = DateTime->new(year=>2019, month=>11, day=>24);

 say $format->format_datetime($dt1); # 2019-11-19
 say $format->format_datetime($dt1); # 2019-11-24su


=head1 DESCRIPTION

This module formats L<DateTime> objects using L<DateTimeX::strftimeq>.


=head1 ATTRIBUTES

=head2 format

Required. Will be passed to strftimeq.

=head2 time_zone

Optional. Used to force the time zone of DateTime objects to be formatted.
Either string containing time zone name (e.g. "Asia/Jakarta", "UTC") or
L<DateTime::TimeZone> object. Will be converted to DateTime::TimeZone
internally.

The default is to use the DateTime object's time zone.


=head1 METHODS

=head2 new

Usage:

 DateTime::Format::ISO8601::Format->new(%attrs) => obj

=head2 format_datetime

Usage:

 $format->format_datetime($dt) => str


=head1 SEE ALSO

L<DateTimeX::strftimeq>

=cut
