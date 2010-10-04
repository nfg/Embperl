
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

package Embperl::Form::Control::password ;

use strict ;
use base 'Embperl::Form::Control' ;

use Embperl::Inline ;

1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self) $]

<input type="password"  class="cBase cControl cControlWidthInput"  name="[+ $self->{name} +]"
[$if $self -> {size} $]size="[+ $self->{size} +]"[$endif$]
[$if $self -> {maxlength} $]size="[+ $self->{maxlength} +]"[$endif$]
>
[$endsub$]


[# ---------------------------------------------------------------------------
#
#   show_control_readonly - output the control as readonly
#]

[$ sub show_control_readonly ($self) $]*****[$endsub$]



__END__

=pod

=head1 NAME

Embperl::Form::Control::password - A password input control inside an Embperl Form


=head1 SYNOPSIS

  { 
  type => 'password',
  text => 'blabla', 
  name => 'foo',
  size => 10,
  }

=head1 DESCRIPTION

Used to create a password control inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'password'

=head3 name

Specifies the name of the control

=head3 text 

Will be used as label for the text input control

=head3 size

Gives the size in characters

=head3 maxlength

Gives the maximun length in characters

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


