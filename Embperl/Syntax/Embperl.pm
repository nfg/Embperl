
###################################################################################
#
#   Embperl - Copyright (c) 1997-2004 Gerald Richter / ECOS
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
 


package Embperl::Syntax::Embperl ;

use Embperl::Syntax qw{:types} ;
use Embperl::Syntax::EmbperlHTML ;
use Embperl::Syntax::EmbperlBlocks ;

@ISA = qw(Embperl::Syntax::EmbperlBlocks Embperl::Syntax::EmbperlHTML) ;


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
    
    my $self = Embperl::Syntax::EmbperlBlocks::new ($class) ;
    Embperl::Syntax::EmbperlHTML::new ($self) ;

    return $self ;
    }


1 ;
__END__

=pod

=head1 NAME

Embperl syntax module for Embperl. 

=head1 SYNOPSIS

[$ syntax Embperl $]

=head1 DESCRIPTION

This module provides the default syntax for Embperl and include all defintions
from EmbperlHTML and EmbperlBlocks.

=head1 Author

Gerald Richter <richter@dev.ecos.de>

=head1 See Also

Embperl::Syntax, Embperl::Syntax::EmbperlHTML, Embperl::Syntax::EmbperlBlocks

