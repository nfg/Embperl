
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

package Embperl::Form::Control::display ;

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

my $name = $self->{name};
my $value = exists $self->{value} ? $self->{value} : $fdat{$name};

$][+ $value +]
[$ if $self->{hidden} $]
<input type="hidden" name="[+ $name +]" value="[+ $value +]">
[$endif$]
[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::display - A text display control inside an Embperl Form


=head1 SYNOPSIS

  { 
  type   => 'display',
  text   => 'blabla', 
  hidden => 1,
  name   => 'foo',
  }

=head1 DESCRIPTION

Used to create a display only control inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be set to 'display'.

=head3 text 

Will be used as label for the text display control.

=head3 hidden 

If set, an appropriate hidden input field will be created
automatically.

=head3 name 

Will be used as name for the hidden input field.

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


