
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
#   $Id: App.pm,v 1.1.2.2 2002/03/11 08:47:27 richter Exp $
#
###################################################################################
 


package Embperl::App ;

use strict ;
use vars qw{%Recipes} ;

# ---------------------------------------------------------------------------------
#
#   Get/create named recipe
#
# ---------------------------------------------------------------------------------


sub get_recipe

    {
    my ($self, $r, $name) = @_ ;

    $name ||= 'Embperl' ;
    my @names = split (/\s/, $name) ;

    foreach my $recipe (@names)
        {
        my $mod ;
        $recipe =~ /([a-zA-Z0-9_:]*)/ ;
        $recipe = $1 ;
        if (!($mod = $Recipes{$recipe})) 
            {
            $mod = ($name =~ /::/)?$recipe:'Embperl::Recipe::'. $recipe ;
            if (!defined (&{$mod . '::get_recipe'}))
                {
                eval "require $mod" ;
                if ($@) 
                    {
                    warn $@ ;
                    return undef ;
                    }
                }
            $Recipes{$recipe} = $mod ;
            }
        print Embperl::LOG "[$$] Use Recipe $recipe\n" if ($r -> component -> config -> debug) ;
        my $obj = $mod -> get_recipe ($r, $recipe) ;
        return $obj if ($obj) ;
        }
        
    return undef ;                
    }


# ---------------------------------------------------------------------------------
#
#   send error page
#
# ---------------------------------------------------------------------------------


sub send_error_page

    {
    my ($self, $r) = @_ ;

    local $SIG{__WARN__} = 'Default' ;
    
    my $virtlog     = '' ; # $r -> VirtLogURI || '' ;
    my $logfilepos  = $r -> log_file_start_pos ;
    my $url         = '' ; # $Embperl::dbgLogLink?"<A HREF=\"$virtlog\?$logfilepos\&$$\">Logfile</A>":'' ;    
    my $req_rec     = $r -> apache_req ;
    my $err ;
    my $cnt = 0 ;
    local $Embperl::escmode = 0 ;
    my $time = localtime ;
    my $mail = $req_rec -> server -> server_admin if (defined ($req_rec)) ;
    $mail ||= '' ;

    $req_rec -> content_type('text/html') if (defined ($req_rec)) ;

    $r -> output ("<HTML><HEAD><TITLE>Embperl Error</TITLE></HEAD><BODY bgcolor=\"#FFFFFF\">\r\n$url") ;
    $r -> output ("<H1>Internal Server Error</H1>\r\n") ;
    $r -> output ("The server encountered an internal error or misconfiguration and was unable to complete your request.<P>\r\n") ;
    $r -> output ("Please contact the server administrator, $mail and inform them of the time the error occurred, and anything you might have done that may have caused the error.<P><P>\r\n") ;

    my $errors = $r -> errors ;
    if ($virtlog ne '' && $Embperl::dbgLogLink)
        {
        foreach $err (@$errors)
            {
            $r -> output ("<A HREF=\"$virtlog?$logfilepos&$$#E$cnt\">") ; #<tt>") ;
            $Embperl::escmode = 3 ;
            $err =~ s|\\|\\\\|g;
            $err =~ s|\n|\n\\<br\\>\\&nbsp;\\&nbsp;\\&nbsp;\\&nbsp;|g;
            $err =~ s|(Line [0-9]*:)|$1\\</a\\>|;
            $r -> output ($err) ;
            $Embperl::escmode = 0 ;
            $r -> output ("<p>\r\n") ;
            #$r -> output ("</tt><p>\r\n") ;
            $cnt++ ;
            }
        }
    else
        {
        $Embperl::escmode = 3 ;
        foreach $err (@$errors)
            {
            $err =~ s|\\|\\\\|g;
            $err =~ s|\n|\n\\<br\\>\\&nbsp;\\&nbsp;\\&nbsp;\\&nbsp;|g;
            $r -> output ("$err\\<p\\>\r\n") ;
            #$r -> output ("\\<tt\\>$err\\</tt\\>\\<p\\>\r\n") ;
            $cnt++ ;
            }
        $Embperl::escmode = 0 ;
        }
         
    my $server = $ENV{SERVER_SOFTWARE} || 'Offline' ;

    $r -> output ("$server Embperl $Embperl::VERSION [$time]<P>\r\n") ;
    $r -> output ("</BODY></HTML>\r\n\r\n") ;
    }

# ---------------------------------------------------------------------------------
#
#   mail errors
#
# ---------------------------------------------------------------------------------


sub mail_errors

    {
    my ($self, $r) = @_ ;

    local $SIG{__WARN__} = 'Default' ;
    
    my $to = $self -> config -> mail_errors_to  ;
    return undef if (!$to) ;

    $r -> log ("[$$]ERR:  Mail errors to $to\n") ;

    my $time = localtime ;

    require Net::SMTP ;

    my $mailhost = $self -> config -> mailhost || 'localhost' ;
    my $smtp = Net::SMTP->new($mailhost, Debug => $self -> config -> maildebug) or die "Cannot connect to mailhost $mailhost" ;
    $smtp->mail("Embperl\@$ENV{SERVER_NAME}");
    $smtp->to($to);
    my $ok = $smtp->data();
    $ok and $ok = $smtp->datasend("To: $to\r\n");
    $ok and $ok = $smtp->datasend("Subject: ERROR in Embperl page " . $r -> param -> uri . " on $ENV{HTTP_HOST}\r\n");
    $ok and $ok = $smtp->datasend("\r\n");

    $ok and $ok = $smtp->datasend("ERROR in Embperl page $ENV{HTTP_HOST}$ENV{SCRIPT_NAME}\r\n");
    $ok and $ok = $smtp->datasend("\r\n");

    $ok and $ok = $smtp->datasend("-------\r\n");
    $ok and $ok = $smtp->datasend("Errors:\r\n");
    $ok and $ok = $smtp->datasend("-------\r\n");
    my $errors = $r -> errors ;
    my $err ;
        
    foreach $err (@$errors)
        {
	$ok and $ok = $smtp->datasend("$err\r\n");
        }
    
    $ok and $ok = $smtp->datasend("-----------\r\n");
    $ok and $ok = $smtp->datasend("Formfields:\r\n");
    $ok and $ok = $smtp->datasend("-----------\r\n");
    
    my $ffld = $r -> thread -> form_array ;
    my $fdat = $r -> thread -> form_hash ;
    my $k ;
    my $v ;
    
    foreach $k (@$ffld)
        { 
        $v = $fdat->{$k} ;
        $ok and $ok = $smtp->datasend("$k\t= \"$v\" \n" );
        }
    $ok and $ok = $smtp->datasend("-------------\r\n");
    $ok and $ok = $smtp->datasend("Environment:\r\n");
    $ok and $ok = $smtp->datasend("-------------\r\n");

    my $env = $r -> thread -> env_hash ;

    foreach $k (sort keys %$env)
        { 
        $v = $env -> {$k} ;
        $ok and $ok = $smtp->datasend("$k\t= \"$v\" \n" );
        }

    my $server = $ENV{SERVER_SOFTWARE} || 'Offline' ;

    $ok and $ok = $smtp->datasend("-------------\r\n");
    $ok and $ok = $smtp->datasend("$server Embperl $Embperl::VERSION [$time]\r\n") ;

    $ok and $ok = $smtp->dataend() ;
    $smtp->quit; 

    return $ok ;
    }    



1;


__END__        


=pod

=head1 NAME

Embperl base class for application objects

=head1 SYNOPSIS


=head1 DESCRIPTION

