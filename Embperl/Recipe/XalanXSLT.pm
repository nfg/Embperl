
###################################################################################
#
#   Embperl - Copyright (c) 1997-2004 Gerald Richter / ECOS
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED 'AS IS' AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: XalanXSLT.pm,v 1.3 2004/01/23 06:50:57 richter Exp $
#
###################################################################################
 


package Embperl::Recipe::XalanXSLT ;

use strict ;
use vars qw{@ISA} ;

use Embperl::Recipe::XSLT ;

@ISA = ('Embperl::Recipe::XSLT') ;

# ---------------------------------------------------------------------------------
#
#   Create a new recipe by converting request parameter
#
# ---------------------------------------------------------------------------------


sub get_recipe

    {
    my ($class, $r, $recipe) = @_ ;

    $r -> component -> config -> xsltproc ('xalan') ;
    return  Embperl::Recipe::XSLT -> get_recipe ($r, $recipe) ;
    }


1 ;
