
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
#   $Id: Embperl.pm,v 1.3 2004/01/23 06:50:57 richter Exp $
#
###################################################################################


package Embperl::Recipe::Embperl ;

use strict ;
use vars qw{@ISA} ;

@ISA = ('Embperl::Recipe') ;

# ---------------------------------------------------------------------------------
#
#   Create a new recipe by converting request parameter
#
# ---------------------------------------------------------------------------------


sub get_recipe

    {
    my ($class, $r, $recipe, $src, $syntax) = @_ ;

    my $self ;
    my $param  = $r -> component -> param  ;
    my @recipe ;

    if (!$src)
        {
        push @recipe, {'type'   =>  ref ($param -> input)?'memory':($param -> subreq?'apoutfilter':'file') } ;
        }
    else
        {
        push @recipe, ref $src eq 'ARRAY'?@$src:$src ;
        }

    push @recipe, {'type'   =>  'epparse', $syntax?(syntax => $syntax):()   } ;
    push @recipe, {'type'   =>  'epcompile', cache => 1 } ;
    push @recipe, {'type'   =>  'eprun'     } if ($param -> import < 0) ;

    return \@recipe ;
    }

1;
