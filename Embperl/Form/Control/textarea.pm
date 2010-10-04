
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

package Embperl::Form::Control::textarea ;

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

<textarea type="text"  class="cBase cControl"  name="[+ $self->{name} +]"
[$if $self -> {cols} $]cols="[+ $self->{cols} +]"[$endif$]
[$if $self -> {rows} $]rows="[+ $self->{rows} +]"[$endif$]
[$if $self -> {id}   $]id="[+ $self->{id} +]"[$endif$]
></textarea>
[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::textarea - A textarea input control inside an Embperl Form


=head1 SYNOPSIS

  { 
  type => 'textarea',
  text => 'blabla', 
  name => 'foo',
  id   => 'id_foo',
  rows => 10,
  cols => 80,
  }

=head1 DESCRIPTION

Used to create an input control inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'textarea'

=head3 text 

Will be used as label for the text input control

=head3 name 

Will be used as field name for the text input control

=head3 name 

Will be used as id of the text input control

=head3 cols

Number of columns

=head3 rows

Number of rows

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


