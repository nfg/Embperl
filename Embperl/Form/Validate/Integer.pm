
###################################################################################
#
#   Embperl - Copyright (c) 1997-2010 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: Integer.pm 294756 2005-08-07 00:03:03Z richter $
#
###################################################################################


package Embperl::Form::Validate::Integer ;

use base qw(Embperl::Form::Validate::Number);


# --------------------------------------------------------------

sub validate 
    {
    my ($self, $key, $value, $fdat, $pref) = @_ ;
    
    return $value =~ /^\s*[0-9+-][0-9]*\s*$/ ? undef : ['validate_number', $value] ;
    }

# --------------------------------------------------------------

sub getscript_validate 
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ('obj.value.search(/^\s*[0-9+-][0-9]*\s*$/) >= 0', ['validate_number', "'+obj.value+'"]) ;
    }



1;
