
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

package Embperl::Form::Control ;

use strict ;
use vars qw{%fdat} ;

use Embperl::Inline ;

# ---------------------------------------------------------------------------
#
#   new - create a new control
#


sub new

    {
    my ($class, $args) = @_ ;
    
    bless $args, $class ;
    
    return $args ;
    }
    
# ---------------------------------------------------------------------------
#
#   noframe - do not draw frame border if this is the only control
#


sub noframe

    {
    return ;
    }

# ---------------------------------------------------------------------------
#
#   is_disabled - do not display this control at all
#


sub is_disabled

    {
    my ($self) = @_ ;
    
    return $self -> {disable} ;
    }

# ---------------------------------------------------------------------------
#
#   is_readonly - could value of this control be changed ?
#


sub is_readonly

    {
    my ($self) = @_ ;
    
    return $self -> {readonly} ;
    }



# ---------------------------------------------------------------------------
#
#   show - output the control
#

sub show

    {
    my ($self, $data) = @_ ;

    $fdat{$self -> {name}} = $self -> {default} if ($fdat{$self -> {name}} eq '' && exists ($self -> {default})) ;
    my $span = 0 ;
    $span += $self -> show_label_cell ($span);
    return $self -> show_control_cell ($span, $data) ;
    }
    
# ---------------------------------------------------------------------------
#
#   get_on_show_code 
#
#   retuns js code that should be excuted when form becomes visible
#

sub get_on_show_code 
    {
    return ;
    }

# ---------------------------------------------------------------------------
#
#   get_active_id - get the id of the value which is currently active
#

sub get_active_id

    {
    return ;
    }


# ---------------------------------------------------------------------------
#
#   form - return form object
#

sub form
    {
    my ($self) = @_ ;

    return $Embperl::Form::forms{$self -> {formid}} ;
    }


# ---------------------------------------------------------------------------
#
#   get_validate_rules - get rules for validation
#
    
sub get_validate_rules
    {
    my ($self) = @_ ;

    my @local_rules ;
    if ($self -> {validate})
        {
    
        @local_rules = ( -key => $self->{name} );
        push @local_rules, -name => $self->{text} if ($self -> {text}) ;
        push @local_rules, @{$self -> {validate}};
        }
    return \@local_rules ;
    }


1 ;

# ===========================================================================

__EMBPERL__

[$syntax EmbperlBlocks $]
    
[# ---------------------------------------------------------------------------
#
#   show_sub_begin - output begin of sub form
#]

[$sub show_sub_begin ($self)
    
my $span = $self->{width_percent}  ;
$]
</tr><tr><td class="cBase cTabTD" colspan="[+ $span +]">
[$endsub$]
    
[# ---------------------------------------------------------------------------
#
#   show_sub_end - output end of sub form
#]

[$sub show_sub_end ($self) $]
</td>
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show_label ($self) $][+ $self->{text} || $self->{name} +][$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_label_icon - output the icon before the label
#]

[$sub show_label_icon ($self) $]
[$if $self -> {sublines} $]&nbsp;<img src="plus.png" style="vertical-align: middle;">[$endif$]
[$if $self -> {parentid} $]&nbsp;<img src="vline.png" style="vertical-align: middle;">[$endif$]
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show_label_cell ($self) 

my $style = "";
$style = "white-space:nowrap;" if ($self->{labelnowrap}) ;

$]
  <td class="cLabelBox[$ if $self->{labelclass} $][+ " $self->{labelclass}" +][$ endif $]"
      colspan="1" [$ if $style $]style="[+ $style +]"[$ endif $]>
    [-
    $self -> show_label ;
    $self -> show_label_icon ;
    -]
  </td>
  [- return 1; -]
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self) $][+ $self->{value} +][$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_control_readonly - output the control as readonly
#]

[$ sub show_control_readonly ($self) $][+ $self -> {value} || $fdat{$self -> {name}} +][$endsub$]


[# ---------------------------------------------------------------------------
#
#   show_controll_cell - output the table cell for the control
#]

[$ sub show_control_cell ($self, $x)

    my $span = $self->{width_percent} - $x ;
$]
    <td class="cControlBox" colspan="[+ $span +]">
    [* my @ret = $self -> is_readonly?$self -> show_control_readonly:$self -> show_control ; *]
    </td>
[* return @ret ; *]
[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control - Base class for controls inside an Embperl Form


=head1 SYNOPSIS

Do not use directly, instead derive a class

=head1 DESCRIPTION

This class is not used directly, it is used as a base class for
all controls inside an Embperl Form. It provides a set of methods
that could be overwritten to customize the behaviour of your controls.

=head1 METHODS

=head2 new

Create a new control

=head2 noframe

Do not draw frame border if this is the only control

=head2 is_disabled

Do not display this control at all.

=head2 is_readonly

Could value of this control be changed ?

=head2 show

output the control

=head2 get_on_show_code 

returns JavaScript code that should be executed when the form becomes visible

=head2 form

return the form object of this control

=head2 show_sub_begin

output begin of sub form

=head2 show_sub_end

output end of sub form

=head2 show_label

output the label of the control

=head2 show_label_icon

output the icon after the label

=head2 show_label_cell

output the table cell in which the label will be displayed

Must return the columns it spans (default: 1)

=head2 show_control

output the control itself

=head2 show_control_cell

output the table cell in which the control will be displayed

Gets the x position as argument


=head1 PARAMETERS

=head3 name

Specifies the name of the control

=head3 text 

Will be used as label for the control, if not given
name is used as default

=head2 labelnowrap

If set, the text label will not be line wrapped.

=head2 labelclass

If set, will be used as additional CSS classes for the label text cell.

=head2 readonly

If set, displays a readonly version of t control.

=head2 disable

If set, the control will not be displayed at all.

=head2 newline

If set to 1, forces a new line before the control.
If set to -1, forces a new line after the control.

=head2 width

Gives the widths of the control. The value is C<1/width>
of the the whole width of the form. So if you want to
have four controls in one line set C<width> to 4. The default value
is 2.

=head2 width_percent

With this parameter you can also specify the width of
the control in percent. This parameter take precendence over
C<width>

=head1 AUTHOR

G. Richter (richter@dev.ecos.de)

=head1 SEE ALSO

perl(1), Embperl, Embperl::Form

