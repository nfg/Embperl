
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
#   $Id: Embperl.pm,v 1.185 2004/01/23 06:50:54 richter Exp $
#
###################################################################################


package Embperl;

require Cwd ;

require Exporter;
require DynaLoader;

use Embperl::Syntax ;
use Embperl::Recipe ;
use Embperl::Constant ;
use Embperl::Util ;
use Embperl::Out ;
use Embperl::Log ;
use Embperl::App ;

use strict ;
use vars qw(
    @ISA
    $VERSION
    $cwd 
    $req_rec
    $importno 
    %initparam
    $modperl
    $modperl2
    $req
    $app
    ) ;


@ISA = qw(Exporter DynaLoader);

$VERSION = '2.0b10' ;


if ($modperl  = $ENV{MOD_PERL})
    {
    $modperl  =~ m#/(\d+)\.(\d+)# ;
    $modperl2 = 1 if ($1 == 2 || ($1 == 1 && $2 >= 99)) ;
    }


if ($ENV{PERL_DL_NONLAZY}
	&& substr($ENV{GATEWAY_INTERFACE} || '', 0, 8) ne 'CGI-Perl'
	&& defined &DynaLoader::boot_DynaLoader)
    {
    $ENV{PERL_DL_NONLAZY} = '0';
    DynaLoader::boot_DynaLoader ('DynaLoader');
    }

if ($modperl2)
    {
    require Apache::Server ;
    require Apache::ServerUtil ;
    require Apache::RequestRec ;
    require Apache::RequestUtil ;
    require Apache::SubRequest ;
    }

if (!defined(&Embperl::Init))
    {
    bootstrap Embperl $VERSION  ;
    Boot ($VERSION) ;
    Init ($modperl?Apache -> server:undef, \%initparam) ;
    }


$cwd       = Cwd::fastcwd();

tie *Embperl::LOG, 'Embperl::Log' ;

1 ;

#######################################################################################

sub Execute
    
    {
    my $_ep_param = shift ;

    local $SIG{__WARN__} = \&Warn ;

    # when called inside a Embperl Request, Execute the component only
    return Embperl::Req::ExecuteComponent ($_ep_param, @_) if ($req) ;

    my $rc ;
    if (!ref $_ep_param)
        {
        $rc = Embperl::Req::ExecuteRequest (undef, { inputfile => $_ep_param, param => [@_]}) ;
        }
    else
        {
        $rc = Embperl::Req::ExecuteRequest (undef, $_ep_param) ;
        }
use Data::Dumper ;
use Devel::Peek ;
    #print "2 rc = $rc", Dumper ($rc), , Dump ($rc) ;
    return $rc ;
    }

#######################################################################################

sub handler
    
    {
    local $SIG{__WARN__} = \&Warn ;
    $req_rec = $_[0] ;
    #$req_rec -> log_error ("1 rc = ") ;
    my $rc = Embperl::Req::ExecuteRequest ($_[0]) ;
use Data::Dumper ;
use Devel::Peek ;
    #$req_rec -> log_error ( "2 rc = $rc", Dumper ($rc), Dump ($rc)) ;
    return $rc ;
    }

#######################################################################################

sub Warn 
    {
    local $^W = 0 ;
    my $msg = $_[0] ;
    chop ($msg) ;
    
    my $lineno = getlineno () ;
    my $Inputfile = Sourcefile () ;
    if ($msg =~ /Embperl\.pm/)
        {
        $msg =~ s/at (.*?) line (\d*)/at $Inputfile in block starting at line $lineno/ ;
        }
    logerror (Embperl::Constant::rcPerlWarn, $msg);
    }

#######################################################################################

package Embperl::Req ; 

#######################################################################################

use strict ;

if ($Embperl::modperl)
    { 
    if (!$Embperl::modperl2)
        { 
        eval 'use Apache::Constants qw(&OPT_EXECCGI &DECLINED &OK &FORBIDDEN)' ;
        die "use Apache::Constants failed: $@" if ($@); 
        }
    else
        { 
        eval 'use Apache::Const qw(&OPT_EXECCGI &DECLINED &OK &FORBIDDEN)' ;
        die "use Apache::Const failed: $@" if ($@); 
        }
    }

#######################################################################################

sub ExecuteComponent
    
    {
    my $_ep_param = shift ;
    my $rc ;

    if (!ref $_ep_param)
        {
        $rc = $Embperl::req -> execute_component ({ inputfile => $_ep_param, param => [@_]}) ;
        }
    elsif ($_ep_param -> {object})
        {
        my $c = $Embperl::req -> setup_component ($_ep_param) ;
        my $rc = $c -> run ;
        my $package = $c -> curr_package ;
        $c -> cleanup ;
        if (!$rc)
            {
            my $object = {} ;
            bless $object, $package ;
            return $object ;
            }
        return undef ;
        }
    else
        {
        $rc = $Embperl::req -> execute_component ($_ep_param) ;
        }
    Embperl::exit() if ($Embperl::req -> had_exit) ;

    return $rc ;
    }

#######################################################################################

sub get_multipart_formdata
    {
    my ($self) = @_ ;

    my $dbgForm = $self -> config -> debug & Embperl::Constant::dbgForm ;

    # just let CGI.pm read the multipart form data, see cgi docu
    require Apache::compat if ($Embperl::modperl2) ; # Apache::compat is need for CGI.pm
    require CGI ;

    my $cgi = new CGI ;
    my $fdat = $self -> thread -> form_hash ;
    my $ffld = $self -> thread -> form_array ;
    @$ffld = $cgi->param;

    $self -> log ("[$$]FORM: Read multipart formdata, length=$ENV{CONTENT_LENGTH}\n") if ($dbgForm) ; 
    my $params ;
    foreach ( @$ffld )
	{
    	# the param_fetch needs CGI.pm 2.43
	#$params = $cgi->param_fetch( $_ ) ;
    	$params = $cgi->{$_} ;
	if ($#$params > 0)
	    {
	    $fdat->{ $_ } = join ("\t", @$params) ;
	    }
	else
	    {
	    $fdat->{ $_ } = $params -> [0] ;
	    }
	
	$self -> log ("[$$]FORM: $_=$fdat->{$_}\n") if ($dbgForm) ; 

	if (ref($fdat->{$_}) eq 'Fh') 
	    {
	    $fdat->{"-$_"} = $cgi -> uploadInfo($fdat->{$_}) ;
	    }
        }
    }



#######################################################################################

sub SetupSession

    {
    die "SetupSession Not implemented yet in 2.0" ;
    }

#######################################################################################

sub GetSession

    {
    my $r = shift || Embperl::CurrReq () ;

    if ($r -> session_mgnt)
	{
        return wantarray?($r -> app -> udat, $r -> app -> mdat, $r -> app -> sdat):$r -> app -> udat ;
	}
    else
        {
        return undef ; # No session Management
        }
    }

#######################################################################################

sub DeleteSession

    {
    my $r = shift || Embperl::CurrReq () ;
    my $disabledelete = shift ;

    my $udat = $r -> app -> user_session ;
    if (!$disabledelete)  # Delete session data
        {
        $udat -> delete  ;
        }
    else
        {
        $udat-> {data} = {} ; # for make test only
        $udat->{initial_session_id} = "!DELETE" ;
        }
    $udat->{status} = 0;
    }


#######################################################################################

sub RefreshSession

    {
    my $r = shift || Embperl::CurrReq () ;

    $r -> session_mgnt ($r -> session_mgnt | 4) if ($r -> session_mgnt) ; # resend cookie 
    }

#######################################################################################

sub CleanupSession

    {
    die "CleanupSession Not implemented yet in 2.0" ;
    }


#######################################################################################

sub SetSessionCookie

    {
    die "SetSessionCookie Not implemented yet in 2.0" ;
    }



#######################################################################################

sub export

    {
    my ($r, $caller) = @_ ;
    
    my $package = $r -> component -> curr_package ;
    no strict ;
    my $exports = \%{"$package\:\:_ep_exports"} ;

    print Embperl::LOG  "[$$]IMP:  Create Imports for $caller from $package\n" ;

    foreach $k (keys %$exports)
	{
        *{"$caller\:\:$k"}    = $exports -> {$k} ; #\&{"$package\:\:$k"} ;
        print Embperl::LOG  "[$$]IMP:  Created Import for $package\:\:$k -> $caller\n" ;
        }

    use strict ;
    }

#######################################################################################

package Apache::Embperl; 

*handler2 = \&Embperl::handler ;

package HTML::Embperl; 

*handler2 = \&Embperl::handler ;

package XML::Embperl; 

*handler2 = \&Embperl::handler ;

1 ;
