
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
#   $Id$
#
###################################################################################

package Embperl::Form::Control::displaylink ;

use strict ;
use base 'Embperl::Form::Control' ;

use Embperl::Inline ;

1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self)

my $name     = $self->{name};
my $hrefs    = $self -> {href} ;
my $targets  = $self -> {target} ;
my $opens    = $self -> {open} ;
my $displays = $self -> {link} || $self -> {value} ;

$hrefs     = [$hrefs] if (!ref $hrefs) ;
$targets   = [$targets] if ($targets && !ref $targets) ;
$opens     = [$opens] if ($opens && !ref $opens) ;
$displays  = [$displays] if (!ref $displays) ;

my $dispn = 0 ;
$]

[$ foreach $display (@$displays) $]
    [$if $opens -> [$dispn] $]
        <a href="#" onclick="[+ $opens -> [$dispn] +]('[+ $hrefs -> [$dispn] +]')">
    [$else$]
        <a href="[+ do {local $escmode=0;$hrefs -> [$dispn]} +]"
	    [$if $targets -> [$dispn] $]target="[+ $targets -> [$dispn] +]"[$endif$]>
    [$endif$][+ $display +]</a>&nbsp;
    [- $dispn++ -]
[$endforeach$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::displaylink - A control to display links inside an Embperl Form


=head1 SYNOPSIS

  { 
  type   => 'displaylink',
  text   => 'blabla', 
  link   => ['ecos', 'bb5000'],
  href   => ['http://www.ecos.de', 'http://www.bb5000.info']  
  }

=head1 DESCRIPTION

Used to create a control which displays links inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be set to 'displaylink'.

=head3 text 

Will be used as label for the text display control.

=head3 link

Arrayref with texts for the links that should be shown to the user

=head3 href

Arrayref with hrefs

=head3 open

Arrayref, if a value is given for the link, the value will be used as
javascript function which is executed onclick. href will be pass as
argument.

=head3 target

Arrayref with targets

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form

