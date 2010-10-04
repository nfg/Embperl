
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
#   $Id: Select.pm 294756 2005-08-07 00:03:03Z richter $
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

