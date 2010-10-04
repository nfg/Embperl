
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

package Embperl::Form::Control::info ;

use strict ;
use base 'Embperl::Form::Control' ;

use Embperl::Inline ;

1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show ($self, $data)

my $span = ($self->{width_percent});
my $section = $self->{section};
$]
<td class="cBase cInfoBox" colspan="[+ $span +]">[$ if $section $]<b>[$ endif $][+ $self -> {showtext}?($self->{text}):$self -> form -> convert_text ($self) +]&nbsp;[$ if $section $]</b>[$ endif $]</td>
[$endsub$]


__END__

=pod

=head1 NAME

Embperl::Form::Control::blank - A info area inside an Embperl Form


=head1 SYNOPSIS

  { 
  type => 'info',
  text => 'blabla' 
  }

=head1 DESCRIPTION

Used to create a info area with optional text inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'info'

=head3 text (optional)

Could be used to give a text that should be displayed inside the blank area


=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


