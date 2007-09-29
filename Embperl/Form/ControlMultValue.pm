
###################################################################################
#
#   Embperl - Copyright (c) 1997-2005 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id$
#
###################################################################################

package Embperl::Form::ControlMultValue ;

use strict ;
use vars qw{%fdat} ;

use base 'Embperl::Form::Control' ;

use Embperl::Inline ;

# ---------------------------------------------------------------------------
#
#   init - Init the new control
#


sub init

    {
    my ($self) = @_ ;

    if ($self -> {datasrc})
        {
        my $form = $self -> form ;
        my $packages = $form -> get_datasrc_packages ;
        $self -> {datasrcobj} = $form -> new_object ($packages, $self -> {datasrc}, $self) ;
        }

    return $self ;
    }


# ---------------------------------------------------------------------------
#
#   get_values - returns the values and options
#

sub get_values

    {
    my ($self, $req) = @_ ;

    return $self -> {datasrcobj} -> get_values ($req, $self) if ($self -> {datasrcobj}) ;
    return ($self -> {values}, $self -> {options}) ;
    }


# ---------------------------------------------------------------------------
#
#   get_active_id - get the id of the value which is currently active
#

sub get_active_id

    {
    my ($self, $req)   = @_ ;

    my ($values, $options) = $self -> get_values ($req) ;
    my $name     = $self -> {name} ;
    my $dataval  = $fdat{$name} || $values -> [0] ;
    my $activeid ;

    my $i = 0 ;
    foreach my $val (@$values)
        {
        if ($val eq $dataval)
            {
            $activeid = "$name-$i" ;
            last ;
            }
        $i++ ;
        }

    return $activeid ;
    }


1 ;

# damit %fdat etc definiert ist
__EMBPERL__

__END__

=pod

=head1 NAME

Embperl::Form::ControlMultValue - Base class for controls inside
an Embperl Form which have multiple values to select from, like
a select box or radio buttons.


=head1 SYNOPSIS

Do not use directly, instead derive a class

=head1 DESCRIPTION

This class is not used directly, it is used as a base class for
all controls which have multiple values to select from inside
an Embperl Form. It provides a set of methods
that could be overwritten to customize the behaviour of your controls.

=head1 METHODS

=head2 get_values

returns the values and options

=head2 get_active_id

get the id of the value which is currently active

=head1 PARAMETERS

=head3 values

Arrayref with the values to select from. This is what gets
submited back to the server.

=head3 options

Arrayref with the options to select from. This is what the user sees.

=head3 datasrc

Name of an class which provides the values for the
values and options parameters. Either a full package name or
a name, in which case all packages which are returned
by Embperl::Form::get_datasrc_packages are searched.

=head1 AUTHOR

G. Richter (richter@dev.ecos.de)

=head1 SEE ALSO

perl(1), Embperl, Embperl::Form, Embperl::From::Control, Embperl::Form::DataSource

