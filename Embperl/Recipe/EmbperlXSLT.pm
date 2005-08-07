
###################################################################################
#
#   Embperl - Copyright (c) 1997-2005 Gerald Richter / ECOS
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED 'AS IS' AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: EmbperlXSLT.pm,v 1.7 2005/08/07 00:03:01 richter Exp $
#
###################################################################################
 


package Embperl::Recipe::EmbperlXSLT ;

use strict ;
use vars qw{@ISA} ;

use Embperl::Recipe::Embperl ;

@ISA = ('Embperl::Recipe::Embperl') ;

# ---------------------------------------------------------------------------------
#
#   Create a new recipe by converting request parameter
#
# ---------------------------------------------------------------------------------


sub get_recipe

    {
    my ($class, $r, $recipe, $src, $syntax) = @_ ;

    my $ep = Embperl::Recipe::Embperl -> get_recipe ($r, $recipe, $src, $syntax) ;
    my $param  = $r -> component -> param  ;
    return $ep if ($param -> import >= 0) ;

    my $config = $r -> component -> config  ;
    my $xsltproc = $config -> xsltproc ;

    my @stylesheet =
        (
        { type => 'file',  filename  => $config -> xsltstylesheet, },
        { type =>  $xsltproc . '-compile-xsl', cache => 1 },
        ) ;


    push @$ep, {'type'   =>  'eptostring' } ;
    push @$ep, {'type'   =>  $xsltproc . '-parse-xml', } ;
    push @$ep, {'type'   =>  $xsltproc, stylesheet => \@stylesheet, $param -> xsltparam?():
                (param => { map { my $v = $Embperl::fdat{$_} ; $v =~ s/\'/&apos;/g ; ($_ => "'$v'") } keys %Embperl::fdat }) } ;

    return $ep ;
    }


1 ;
