
###################################################################################
#
#   Embperl - Copyright (c) 1997-2001 Gerald Richter / ECOS
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: Perl.pm,v 1.1.2.6 2002/01/22 09:29:56 richter Exp $
#
###################################################################################
 
package Embperl::Syntax::Perl ;

use Embperl::Syntax qw{:types} ;
use Embperl::Syntax ;

use strict ;
use vars qw{@ISA} ;

@ISA = qw(Embperl::Syntax) ;


###################################################################################
#
#   Methods
#
###################################################################################

# ---------------------------------------------------------------------------------
#
#   Create new Syntax Object
#
# ---------------------------------------------------------------------------------


sub new

    {
    my $class = shift ;

    my $self = Embperl::Syntax::new ($class) ;

    if (!$self -> {-perlInit})
        {
        $self -> {-perlInit} = 1 ;    
        
        $self -> AddInitCode (undef, '$_ep_node=%$x%+2; %#1% ;', undef,
                            {
                            removenode  => 32,
                            compilechilds => 0,
                            }) ;

        }


    return $self ;
    }




1; 

__END__

=pod

=head1 NAME

Perl syntax module for Embperl 

=head1 SYNOPSIS

Execute ({inputfile => 'code.pl', syntax => 'Perl'}) ;

=head1 DESCRIPTION

This syntax cause Embperl to interpret the whole file as Perl script
without any markup.

=head1 Author

Gerald Richter <richter@dev.ecos.de>


=cut


