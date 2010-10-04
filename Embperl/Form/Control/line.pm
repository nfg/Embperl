
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

package Embperl::Form::Control::line ;

use strict ;
use base 'Embperl::Form::Control' ;

use Embperl::Inline ;

1 ;

__EMBPERL__

[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show ($self, $req)

my $span = ($self->{width_percent})  ;
$]
<td class="cBase cTransparentBox" colspan="[+ $span +]"><hr class="cControlLine"></td>
[$endsub$]


__END__

=pod

=head1 NAME

Embperl::Form::Control::line - A horizontal line an Embperl Form


=head1 SYNOPSIS

  {
  type => 'line',
  }

=head1 DESCRIPTION

Used to create a horizontal line inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'line'


=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


