
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
#   $Id: Text.pm,v 1.2 2002/10/22 05:39:49 richter Exp $
#
###################################################################################
 
package Embperl::Syntax::Text ;

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

    return $self ;
    }




1; 

__END__

=pod

=head1 NAME

Text syntax module for Embperl 

=head1 SYNOPSIS

Execute ({inputfile => 'sometext.htm', syntax => 'Text'}) ;

=head1 DESCRIPTION

This syntax does simply literal pass the text thru. That's usefull if you
want to include text, without any interpretation. (e.g. with EmbperlObject)

=head1 Author

Gerald Richter <richter@dev.ecos.de>

=head1 See Also

Embperl::Syntax


=cut


