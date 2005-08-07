#!/usr/bin/perl
##############################################################################
#
#   Embperl - Copyright (c) 1997-2005 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#   For use with Apache httpd and mod_perl, see also Apache copyright.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: setupdb.pl,v 1.4 2005/08/07 00:03:02 richter Exp $
#
##############################################################################


use FindBin ;
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

my $dbshema     = "$FindBin::Bin/db.schema" ;

    
my $db = DBIx::Database -> new ({'!DataSource' => $ds,
                                 '!Username'   => $suuser,
                                 '!Password'   => $supass,
                                 '!KeepOpen'   => 1,
                                 }) ;
  
die DBIx::Database->LastError . "; Datenbank muß bereits bestehen" if (DBIx::Database->LastError) ;
  

$db -> CreateTables ($dbshema, '', $user)  ;


