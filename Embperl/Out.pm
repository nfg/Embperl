
###################################################################################
#
#   Embperl - Copyright (c) 1997-2002 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: Out.pm,v 1.2 2002/10/22 05:39:48 richter Exp $
#
###################################################################################


package Embperl::Out ;

use Embperl ;
use Embperl::Constant ;


sub TIEHANDLE 

    {
    my $class ;
    
    return bless \$class, shift ;
    }


sub PRINT

    {
    shift ;
    Embperl::output(join ('', @_)) ;
    }

sub PRINTF

    {
    shift ;
    my $fmt = shift ;
    Embperl::output(sprintf ($fmt, @_)) ;
    }

1 ;
