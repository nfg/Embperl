
###################################################################################
#
#   Embperl - Copyright (c) 1997-2004 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: Select.pm,v 1.2 2004/01/23 06:50:57 richter Exp $
#
###################################################################################


package Embperl::Form::Validate::Select ;

use base qw(Embperl::Form::Validate::Default);


# --------------------------------------------------------------

sub getscript_required
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ('obj.selectedIndex != 0', ['validate_required']) ;
    }


1;

