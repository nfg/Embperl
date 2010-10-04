
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

package Embperl::Form::Control::input ;

use strict ;
use base 'Embperl::Form::Control' ;

use Embperl::Inline ;

1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self) 

$self -> {size} ||= 80 / ($self -> {width} || 2) ;
$class = $self -> {class} ||= 'cControlWidthInput' ;
$]

<input type="text"  class="cBase cControl [+ $class +]"  name="[+ $self->{name} +]" id="[+ $self->{name} +]"
[$if $self -> {size} $]size="[+ $self->{size} +]"[$endif$]
[$if $self -> {maxlength} $]maxlength="[+ $self->{maxlength} +]"[$endif$]
[+ do { local $escmode = 0 ; $self -> {eventattrs} } +]>
[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::input - A text input control inside an Embperl Form


=head1 SYNOPSIS

  { 
  type      => 'input',
  text      => 'blabla', 
  name      => 'foo',
  size      => 10,
  maxlength => 50,
  }

=head1 DESCRIPTION

Used to create an input control inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'input'

=head3 name

Specifies the name of the control

=head3 text 

Will be used as label for the text input control

=head3 size

Gives the size in characters

=head3 maxlength

Gives the maximum possible input length in characters

=head3 class

Alternative CSS class name

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


