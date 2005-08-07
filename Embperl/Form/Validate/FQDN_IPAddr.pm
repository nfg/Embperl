
###################################################################################
#
#   Embperl - Copyright (c) 1997-2005 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: FQDN_IPAddr.pm,v 1.3 2005/08/07 00:03:01 richter Exp $
#
###################################################################################


package Embperl::Form::Validate::FQDN_IPAddr ;

use base qw(Embperl::Form::Validate::Default);

my %error_messages = 
(
    de => 
    {
	validate_fqdn_ipaddr => 'Feld %0: "%1" ist keine gültiger Hostname oder IP-Adresse.',
    },

    en =>
    {
	validate_fqdn_ipaddr => 'Field %0: "%1" isn\\\'t a valid hostname or ip-address.',
    }
 );

# --------------------------------------------------------------

sub getmsg
    {
    my ($self, $id, $language, $default_language) = @_ ;

    return $error_messages{$language}{$id} || 
           $error_messages{$default_language}{$id} ||
           $self -> SUPER::getmsg ($id, $language, $default_language) ;
    }


# --------------------------------------------------------------

sub validate 
    {
    my ($self, $key, $value, $fdat, $pref) = @_ ;
    
    if ($value =~ /^(\d+)\.(\d+).(\d+)\.(\d+)$/)
	{
	if ($1 < 0 || $1 > 255 ||
	    $2 < 0 || $2 > 255 ||
	    $3 < 0 || $3 > 255 ||
	    $4 < 0 || $4 > 255)
	    {
             ;		
	    }
	else
		{	    
		return undef ;
		}
	}
	
	return undef if ($value =~ /^[-.a-zA-Z0-9]+$/) ;
    return ['validate_fqdn_ipaddr', $value] ; 
    }

# --------------------------------------------------------------

sub getscript_validate 
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ('obj.value.search(/^[-.a-zA-Z0-9]+$/) >= 0 ', ['validate_fqdn_ipaddr', "'+obj.value+'"]) ;
    }


1;
