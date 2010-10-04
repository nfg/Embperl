
###################################################################################
#
#   Embperl - Copyright (c) 1997-2010 Gerald Richter / ecos gmbh   www.ecos.de
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

package Embperl::Form::DataSource ;

use strict ;

# ---------------------------------------------------------------------------
#
#   new - create a new datasource object
#


sub new

    {
    my ($class, $args) = @_ ;

    my $self = {} ;
    bless $self, $class ;

    $self -> init ($args) ;

    return $self ;
    }

# ---------------------------------------------------------------------------
#
#   init - init the new datasource object
#

sub init

    {
    my ($self) = @_ ;

    return $self ;
    }

# ---------------------------------------------------------------------------
#
#   get_values - returns the values and options
#

sub get_values

    {
    my ($self, $req) = @_ ;

    die "Please overwrite get_values in " . ref $self ;
    }

# ---------------------------------------------------------------------------
#
#   get_datasource_controls - returns additional controls provided by the
#   datasource object e.g. a browse button
#

sub get_datasource_controls

    {
    my ($self, $req, $ctrl) = @_ ;

    return ;
    }


1 ;

__END__

=pod

=head1 NAME

Embperl::Form::DataSource - Base class for data source objects
which provides the data for ControlMutlValue objects.


=head1 SYNOPSIS

Do not use directly, instead derive a class

=head1 DESCRIPTION

This class is not used directly, it is used as a base class for
all data source objects.
It provides a set of methods
that could be overwritten to customize the behaviour of your controls.

=head1 METHODS

=head2 get_values

returns the values and options. Must be overwritten.

=head3 get_datasource_controls 

returns additional controls provided by the
datasource object e.g. a browse button

=head1 AUTHOR

G. Richter (richter@dev.ecos.de)

=head1 SEE ALSO

perl(1), Embperl, Embperl::Form, Embperl::From::ControlMultValue



