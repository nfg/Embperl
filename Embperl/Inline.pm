
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
#   $Id$
#
###################################################################################


package Embperl::Inline ;

sub compile

    {
    my ($code, $line, $file, $package) = @_ ;
        
    my $debug = 0 ; #0x7fffffff ;
    if ($Embperl::req)
        {
        #$debug = $Embperl::req -> config -> debug ;
        }

    #print STDERR "compile: $file, code = $code\n" ;

    Embperl::Execute ({ 'inputfile' => $file, 
		        'input'     => $code,
		        'mtime'     => -M $file,
		        'import'    => 0,
		        'firstline' => $line,
		        'package'   => $package,
		        #'debug'     => $debug,
                        'use_env'   => 1}) ;
    }


use Filter::Simple ;
use Embperl ;

FILTER 
    { 
    s/\n__EMBPERL__(.+)$/\nBEGIN { my \$line = __LINE__ - 2 ; my \$code = q{$1}; Embperl::Inline::compile (\\\$code, \$line, __FILE__, __PACKAGE__)}/s ;
    } ; 


1 ;

=pod

=head1 NAME

Embperl::Inline - Inline Embperl code in Perl modules

=head1 SYNOPSIS

    package MyTest ;
    
    use Embperl::Inline ;
    
    __EMBPERL__
    
    [$ sub foo $]
    
    [-
    $a = 99 ;
    -]
    
    <p>a=[+ $a +]</p>
    [$endsub$]


=head1 DESCRIPTION

Embperl::Inline allow to inline Embperl code in Perl modules.
The benfit is that you are able to install it like a normal
Perl module and it's available site wide, without the need
for any programm to know where it resides.

Also it allows to add markup sections to Perl objects and
calling (and overriding it) like normal Perl methods.

The only thing that needs to be done for using it, is to
use Embperl::Inline and to place your Embperl code after
the C<__EMBPERL__> keyword.

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl
