
###################################################################################
#
#   Embperl - Copyright (c) 1997-2002 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED 'AS IS' AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: EmbperlPODXSLT.pm,v 1.1.2.3 2002/03/13 06:29:36 richter Exp $
#
###################################################################################
 


package Embperl::Recipe::EmbperlPODXSLT ;

use strict ;
use vars qw{@ISA} ;

use Embperl::Recipe::Embperl ;

@ISA = ('Embperl::Recipe::EmbperlXSLT') ;

# ---------------------------------------------------------------------------------
#
#   Create a new recipe by converting request parameter
#
# ---------------------------------------------------------------------------------


sub get_recipe

    {
    my ($class, $r, $recipe) = @_ ;

    my $epsrc = Embperl::Recipe::Embperl -> get_recipe ($r, $recipe, undef, 'EmbperlBlocks') ;

    push @$epsrc, { type => 'eptostring' } ;
    
    my $ep = Embperl::Recipe::EmbperlXSLT -> get_recipe ($r, $recipe, $epsrc, 'POD') ;
    for (my $i = @$epsrc; $i < @$ep; $i++)
        {
        $ep -> [$i] -> {'cache'} = 0 if (exists $ep -> [$i] -> {'cache'}) ;
        }

    return $ep ;
    }


    
