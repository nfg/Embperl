
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
#   $Id: XSLT.pm 294769 2005-08-13 19:43:05Z richter $
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


__END__

=pod

=head1 NAME

Embperl::Recipe::XSLT

=head1 SYNOPSIS


=head1 DESCRIPTION

This recipe does an XSLT transformation.

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

L<Embperl::Recipe|EmbperlRecipe.pod>

L<Embperl::Recipe::EmbperlXSLT|EmbperlRecipe/XSLT.pod>
