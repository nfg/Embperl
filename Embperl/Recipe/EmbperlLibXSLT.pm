
###################################################################################
#
#   Embperl - Copyright (c) 1997-2001 Gerald Richter / ECOS
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED 'AS IS' AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: EmbperlLibXSLT.pm,v 1.2 2002/10/22 05:39:49 richter Exp $
#
###################################################################################
 


package Embperl::Recipe::EmbperlLibXSLT ;

use strict ;
use vars qw{@ISA} ;

use Embperl::Recipe::EmbperlXSLT ;

@ISA = ('Embperl::Recipe::EmbperlXSLT') ;

# ---------------------------------------------------------------------------------
#
#   Create a new recipe by converting request parameter
#
# ---------------------------------------------------------------------------------


sub get_recipe

    {
    my ($class, $r, $recipe) = @_ ;

    $r -> component -> config -> xsltproc ('libxslt') ;
    return  Embperl::Recipe::EmbperlXSLT -> get_recipe ($r, $recipe) ;
    }


1 ;