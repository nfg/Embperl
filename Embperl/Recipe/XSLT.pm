
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
#   $Id: XSLT.pm,v 1.1.2.9 2002/02/25 11:20:28 richter Exp $
#
###################################################################################
 


package Embperl::Recipe::XSLT ;

use strict ;
use vars qw{@ISA} ;

use Embperl::Recipe ;

@ISA = ('Embperl::Recipe') ;

# ---------------------------------------------------------------------------------
#
#   Create a new recipe by converting request parameter
#
# ---------------------------------------------------------------------------------


sub get_recipe

    {
    my ($class, $r, $recipe, $src) = @_ ;

    my $param  = $r -> component -> param  ;
    my $config = $r -> component -> config  ;
    my $xsltproc = $config -> xsltproc ;
    my @recipe ;

    my @stylesheet =
        (
        { type => 'file', 'filename'  => $config -> xsltstylesheet, },
        { type =>  $xsltproc . '-compile-xsl', cache => 1 },
        ) ;

    if (!$src)
        {
        push @recipe, {'type'   =>  ref ($param -> input)?'memory':'file' } ;
        }
    else
        {
        push @recipe, ref $src eq 'ARRAY'?@$src:$src ;
        }

    push @recipe, {'type'   =>  $xsltproc . '-parse-xml', } ;
    push @recipe, {'type'   =>  $xsltproc, stylesheet => \@stylesheet } ;

    return \@recipe ;
    }

1 ;