#!/usr/bin/perl


###############################################################################
###############################################################################
###                                                                         ###
###   perlwww - Copyright (c) 1999, 2000  ecos                              ###
###                                                                         ###
###   - Setup -                                                             ###
###                                                                         ###
###   $Id: setupdb.pl,v 1.1.2.1 2002/02/12 07:20:36 richter Exp $                 ###
###                                                                         ###
###############################################################################
###############################################################################



use DBIx::Recordset ;
use Getopt::Long ;

GetOptions ("debug|d:i") ;


$DBIx::Recordset::Debug = $opt_debug ;



if ($^O eq 'MSWin32')
    {
    $user = '' ;
    $suuser = '' ;
    $supass = '' ;
    $ds = 'dbi:ODBC:embperl' ;
    }
else
    {
    $user = 'www' ;
    $suuser = 'root' ;
    $supass = '' ;
    $ds = 'dbi:mysql:embperl' ;
    }

    
$DBIx::Recordset::Debug = $opt_debug ;

my $dbshema     = "db.schema" ;

    
my $db = DBIx::Database -> new ({'!DataSource' => $ds,
                                 '!Username'   => $suuser,
                                 '!Password'   => $supass,
                                 '!KeepOpen'   => 1,
                                 }) ;
  
die DBIx::Database->LastError . "; Datenbank muß bereits bestehen" if (DBIx::Database->LastError) ;
  

$db -> CreateTables ($dbshema, '', $user)  ;


