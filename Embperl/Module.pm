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
#   $Id: Module.pm,v 1.31 2004/01/23 06:50:56 richter Exp $
#
###################################################################################



package Embperl::Module ;

use Embperl ;


$VERSION = '0.01_dev-1';


# define subs

sub init
    {
    local $/ = undef ;
    my $hdl  = shift ;
    my $data = <$hdl> ;

    # compile page

    Embperl::Execute ({'inputfile' => __FILE__, 
			    'input' => \$data,
			    'mtime' => -M __FILE__ ,
			    'import' => 0,
			    'options' => Embperl::optKeepSrcInMemory,
			    'package' => __PACKAGE__}) ;


    }

# import subs

sub import

    {
    Embperl::Execute ({'inputfile' => __FILE__, 
			    'import' => 2,
			    'package' => __PACKAGE__}) ;


    1 ;
    }



1 ;
