
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

package Embperl::Form::Control::number ;

use strict ;
use base 'Embperl::Form::Control::input' ;

use Embperl::Inline ;

1 ;

__EMBPERL__

[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self)

    $self->{size}      ||= 10 ;
    $self->{class}     ||= 'cControlWidthNumber' ;

    my $unit = $self->{unit} ;
$]
[-     $self -> SUPER::show_control ; -]
[$if ($unit) $][+ $self -> form -> convert_text ($self, ($unit =~ /:/)?$unit:"unit:$unit", $unit) +][$endif$]
[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::number - A numeric input control with optional unit inside an Embperl Form


=head1 SYNOPSIS

  {
  type => 'input',
  text => 'blabla',
  name => 'foo',
  unit => 'sec',
  }

=head1 DESCRIPTION

Used to create a numeric input control inside an Embperl Form.
Optionaly it can display an unit after the input field.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'number'

=head3 name

Specifies the name of the control

=head3 text

Will be used as label for the numeric input control

=head3 size

Gives the size in characters. (Default: 10)

=head3 maxlength

Gives the maximun length in characters

=head3 unit

Gives a string that should be displayed right of the input field.


=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


