
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

package Embperl::Form::Control::addremove ;

use strict ;
use base 'Embperl::Form::Control' ;

use Embperl::Inline ;


# ---------------------------------------------------------------------------
#
#   new - create a new control
#


sub new

    {
    my ($class, $args) = @_ ;
    
    my $self = Embperl::Form::Control -> new($args) ;
    bless $self, $class ;
    
    $self -> {removesource} ||= 0 ;
    $self -> form -> add_code_at_bottom("addremoveInitOptions (document.getElementById('$self->{src}'), document.getElementById('$self->{dest}'), document.getElementById('$self->{name}'), $self->{removesource})") ;
    return $self ;
    }



1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show ($self) 

    my $span = $self->{width_percent}  ;
    my $name = $self->{name} ;
$]    

<td class="cBase cControlBox" colspan="[+ $span +]">
<input type="hidden" id="[+ $name +]" name="[+ $name +]">
<img src="toleft.gif" title="Hinzufügen" onClick="addremoveAddOption (document.getElementById('[+ $self->{src} +]'), document.getElementById('[+ $self->{dest} +]'), document.getElementById('[+ $name +]'), [+ $self->{removesource} +])">
<br>
<img src="toright.gif" title="Entfernen" onClick="addremoveRemoveOption (document.getElementById('[+ $self->{src} +]'), document.getElementById('[+ $self->{dest} +]'), document.getElementById('[+ $name +]'), [+ $self->{removesource} +])">

[#
    print "<input class="cStandardButton" type=button value="Hinzufügen" onClick="addremoveAddOption (this.form.elements['$self->{src}'], this.form.elements['$self->{dest}'], this.form.elements['$self->{name}'], $self->{removesource})">\n" ;
    print "<input class="cStandardButton" type=button value="Entfernen" onClick="addremoveRemoveOption (this.form.elements['$self->{src}'], this.form.elements['$self->{dest}'], this.form.elements['$self->{name}'], $self->{removesource})">\n" ;
#]
</td>
[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::addremove - A control to add and remove items from two select boxes inside an Embperl Form


=head1 SYNOPSIS

  { 
  type         => 'addremove',
  name         => 'foo',
  src          => 'src_select_name', 
  dest         => 'dest_select_name', 
  removesource => 1, 
  }

=head1 DESCRIPTION

A control to add and remove items from two select boxes
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'addremove'

=head3 name

Specifies the name of the addremove control

=head3 src

Gives the name of the select box which serves as source of the data items

=head3 dest

Gives the name of the select box which serves as destionations of the data items

=head3 removesource

If set to a true value the items will be removed from the source select box and 
move to the destionation box. If set to false, the items will be copied.

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


