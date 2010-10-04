
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

package Embperl::Form::Control::checkbox ;

use strict ;
use vars qw{%fdat} ;

use base 'Embperl::Form::Control' ;

use Embperl::Inline ;


# ---------------------------------------------------------------------------
#
#   get_active_id - get the id of the value which is currently active
#

sub get_active_id

    {
    my ($self)   = @_ ;

    my $name     = $self -> {name} ;
    my $val      = $self -> {value} || 1 ;

    return $val eq $fdat{$name}?"$name-0":"$name-1" ;
    }


# ---------------------------------------------------------------------------
#
#   has_auto_label_size - returns true if label should be auto sized for this control
#

sub has_auto_label_size
    {
    return 0 ;
    }

# ---------------------------------------------------------------------------
#
#   show_control_readonly - output readonly control
#

sub show_control_readonly
    {
    my ($self, $req) = @_ ;

    my $name     = $self -> {name} ;
    my $val      = $self -> {value} ;
    $val = 1 if ($val eq '') ;

    $self -> {value} = $fdat{$name} eq $val?'X':'-' ;
    $self -> SUPER::show_control_readonly ($req) ;
    }



1 ;

__EMBPERL__

[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self)

    my $name     = $self -> {name} ;
    my $val      = $self -> {value} || 1 ;
    my $nsprefix = $self -> form -> {jsnamespace} ;

    push @{$self -> form -> {fields2empty}}, $name ;
$]
<input type="checkbox"   class="cBase cControlCheckbox"  name="[+ $name +]" value="[+ $val +]"
[$if ($self -> {sublines} || $self -> {subobjects}) $] OnClick="[+ $nsprefix +]show_checked(document, this)" [$endif$]
[+ do { local $escmode = 0 ; $self -> {eventattrs} } +]>
[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::checkbox - A checkbox control inside an Embperl Form


=head1 SYNOPSIS

  {
  type  => 'checkbox',
  text  => 'blabla',
  name  => 'foo',
  value => 'bar'
  }

=head1 DESCRIPTION

Used to create an checkbox control inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'checkbox'

=head3 name

Specifies the name of the checkbox control

=head3 text

Will be used as label for the checkbox control

=head3 value

Gives the value of the checkbox

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


