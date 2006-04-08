
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

package Embperl::Form::Control::tabs ;

use strict ;
use vars qw{%fdat} ;

use Embperl::Form::ControlMultValue ;
use base 'Embperl::Form::ControlMultValue' ;

use Embperl::Inline ;

# ---------------------------------------------------------------------------
#
#   new - create a new control
#


sub new

    {
    my ($class, $args) = @_ ;
    
    my $self = Embperl::Form::ControlMultValue -> new($args) ;
    bless $self, $class ;
    
    $self -> {width} = 1 ;
    return $self ;
    }

# ---------------------------------------------------------------------------
#
#   noframe - do not draw frame border if this is the first control
#


sub noframe

    {
    return 1 ;
    }

# ---------------------------------------------------------------------------
#
#   get_active_id - get the id of the value which is currently active
#

sub get_active_id

    {
    my ($self)   = @_ ;

    my ($values, $options) = $self -> get_values ;
    my $name     = $self -> {name} ;
    my $dataval  = $fdat{$name} || $values -> [0] ;
    my $activeid ;

    my $i = 0 ;
    foreach my $val (@$values)
        {
        if ($val eq $dataval || $self -> {subids}[$i] eq $dataval)
            {
            $activeid = $self -> {subids}[$i] ;
            last ;
            }
        $i++ ;
        }

    return $activeid || $self -> {subids}[0];
    }


1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show ($self) 

    my ($values, $options) = $self -> get_values ;
    my $span = ($self->{width_percent})  ;
    my $name     = $self -> {name} ;
    my $dataval  = $fdat{$name} || $values -> [0] ;
    my $activeid = $self -> get_active_id ;
    
    my $val ;     
    my $i = 0 ;
$]    

<td class="cBase cTabTD" colspan="[+ $span +]">
    <table  class="cBase cTabTable" ><tr  class="cBase cTabRow">
    [$ foreach $val (@$values) $]
        [*
        my $id        = $self -> {subids}[$i] ;
        my $cellclass = $id eq $activeid?'cTabCellOn':'cTabCellOff' ;
        my $divclass  = $id eq $activeid?'cTabDivOn':'cTabDivOff' ;

        my $form = $self -> form ;
        my @switch_code ;
    
        foreach my $sub (@{$form -> {controls}})
            {
            my $code = $sub -> get_on_show_code ;
            push @switch_code, $code if ($code) ;
            }
        my $js = join (';', @switch_code) ;    
        *]   
        <td class="cBase $cellclass"><div class="cBase [+ $divclass +]" id="__tabs_[+ $id +]">
        <a href="#" onClick="tab_selected('[+ $id +]','[+ $name +]'); [+ do { local $escmode = 0 ; $js } +]" style="color:black; text-decoration: none;">[+ $options ->[$i] || $val +]</a></div></td>
        [* $i++ *]
    [$endforeach $]
    <td class="cBase cTabCellBlank">&nbsp;</td>
    <input type="hidden" name="[+ $name +]" id="[+ $name +]" value="[+ $activeid +]">
    </tr></table>
</td>
[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::tabs - A tab control inside an Embperl Form


=head1 SYNOPSIS

            Embperl::Form -> add_tabs ( 
                [
                    {
                    text => 'First Tab',
                    fields => [
                              ...
                              ]
                    },
                    { 
                    text => 'Second Tab',
                    fields => [
                              ...
                              ]
                    }
                ])



=head1 DESCRIPTION

Control to display tabs at the top of the form and control the switching between sub forms.
The switching is done by Javascript, so it can only be used in environment where 
Javascript is available.

You can use the method Embperl::Form -> add_tabs
to setup a tabbed form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER


=head3 text 

Text that will be displayed on the tab

=head3 fields

List of fields that should be displayed in this subform. 
Given in the same form as form Embperl::Form.


=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


