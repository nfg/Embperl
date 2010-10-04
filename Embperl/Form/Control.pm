
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

    my $self = { %$args } ;
    bless $self, $class ;

    $self -> init ;

    return $self ;
    }

# ---------------------------------------------------------------------------
#
#   init - init the new control
#

sub init

    {
    my ($self) = @_ ;

    my $eventattrs = '' ;	
    if (my $e = $self -> {event}) 
	{
	for (my $i = 0; $i < @$e; $i += 2) 
	    {
	    $eventattrs .= $e -> [$i] . '="' . $e -> [$i+1] . '" ' ;
	    }
	}
    $self -> {eventattrs} = $eventattrs ;

    return $self ;
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
    my ($self, $req) = @_ ;

    return $self -> {disable} ;
    }

# ---------------------------------------------------------------------------
#
#   is_readonly - could value of this control be changed ?
#

sub is_readonly

    {
    my ($self, $req) = @_ ;

    return $self -> {readonly} ;
    }

# ---------------------------------------------------------------------------
#
#   is_hidden - returns true if this is a hidden control
#

sub is_hidden

    {
    my ($self, $req) = @_ ;

    return  ;
    }

# ---------------------------------------------------------------------------
#
#   show - output the whole control including the label
#

sub show

    {
    my ($self, $req) = @_ ;

    $fdat{$self -> {name}} = $self -> {default} if ($fdat{$self -> {name}} eq '' && exists ($self -> {default})) ;
    my $span = 0 ;
    $span += $self -> show_label_cell ($req, $span);
    return $self -> show_control_cell ($req, $span) ;
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

    return $Embperl::FormData::forms{$self -> {formptr}} ;
    }

# ---------------------------------------------------------------------------
#
#   label_text - return text of label
#

sub label_text
    {
    my ($self) = @_ ;

    return $self -> {label_text} if ($self -> {label_text}) ;

    return $self -> {label_text} = $self -> {showtext}?($self->{text} ||
			$self->{name}):$self -> form -> convert_label ($self) ;
    }


# ---------------------------------------------------------------------------
#
#   get_validate_rules - get rules for validation
#

sub get_validate_rules
    {
    my ($self, $req) = @_ ;

    my @local_rules ;
    if ($self -> {validate})
        {

        @local_rules = ( -key => $self->{name} );
        push @local_rules, -name => $self -> label_text ;
        push @local_rules, @{$self -> {validate}};
        }
    return \@local_rules ;
    }

# ---------------------------------------------------------------------------
#
#   has_auto_label_size - returns true if label should be auto sized for this control
#

sub has_auto_label_size
    {
    return 1 ;
    }

1 ;

# ===========================================================================

__EMBPERL__

[$syntax EmbperlBlocks $]

[# ---------------------------------------------------------------------------
#
#   show_sub_begin - output begin of sub form
#]

[$sub show_sub_begin ($self, $req)

my $span = $self->{width_percent}  ;
$]
</tr><tr><td class="cBase cTabTD" colspan="[+ $span +]">
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_sub_end - output end of sub form
#]

[$sub show_sub_end ($self, $req) $]
</td>
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show - output the label
#]

[$ sub show_label ($self, $req) $][-

    if ($self -> {showoptionslabel})
	{
	my $opts = $self -> form -> convert_options ($self, [$self -> {value}]) ;
	$self -> {text} = $opts -> [0] ;
	$self -> {showtext} = 1 ;
	}
-][+ $self -> label_text +][$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_label_icon - output the icon before the label
#]

[$sub show_label_icon ($self, $req) $]
[$if $self -> {xxsublines} $]&nbsp;<img src="/images/plus.png" style="vertical-align: middle;">[$endif$]
[$if $self -> {xxparentid} $]&nbsp;<img src="/images/vline.png" style="vertical-align: middle;">[$endif$]
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show_label_cell ($self, $req)

my $style = '';
my $addclass = '' ;
my $span = 20 ;
if ($self -> {width} > 2 && $self -> has_auto_label_size ())
    {
    $span = int(40 / $self -> {width}) if ($self -> {x_percent} != 0) ;
    }

$style = 'white-space:nowrap; ' if ($self->{labelnowrap}) ;
if ($self -> {width_precent} && !$self -> {width})
    {
    $style .= 'width: 20%; '  ;
    }
else
    {
    $addclass = 'cLabelBoxWidth' . ($self->{width} || 2 ) ;
    }
$]
  <td class="cLabelBox [+ $addclass +] [$ if $self->{labelclass} $][+ " $self->{labelclass}" +][$ endif $]"
      colspan="[+ $span +]" [$ if $style $]style="[+ $style +]"[$ endif $]>
    [-
    $self -> show_label ($req);
    $self -> show_label_icon ($req) ;
    -]
  </td>
  [- return $span ; -]
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_control - output the control itself
#]

[$ sub show_control ($self, $req) $][+ $self->{value} +][$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_control_readonly - output the control as readonly
#]

[$ sub show_control_readonly ($self, $req) $][+ $self -> {value} || $fdat{$self -> {name}} +][$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_control_addons - output additional things after the control
#]

[$ sub show_control_addons ($self, $req) $][$endsub$]


[# ---------------------------------------------------------------------------
#
#   show_controll_cell - output the table cell for the control
#]

[$ sub show_control_cell ($self, $req, $x)

    my $span = $self->{width_percent} - $x ;
    my $addclass = '' ;
    my $style    = '' ;
    if ($self -> {width_precent} && !$self -> {width})
        {
        $style = "width: " . int($self -> {width_precent} * 100 / 80) . '; '  ;
        }
    else
        {
        $addclass = 'cControlBoxWidth' . ($self->{width} || 2 ) ;
        }
$]
    <td class="cControlBox [+ $addclass +]" colspan="[+ $span +]" [$ if $style $]style="[+ $style +]"[$ endif $]>
    [*
     my @ret = $self -> is_readonly?$self -> show_control_readonly($req):$self -> show_control ($req);
     $self -> show_control_addons ($req) ;
     *]
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

=head2 init

Init the new control

=head2 noframe

Do not draw frame border if this is the only control

=head2 is_disabled

Do not display this control at all.

=head2 is_readonly

Could value of this control be changed ?

=head2 label_text

Returns the text of the label

=head2 show

Output the control

=head2 get_on_show_code

Returns JavaScript code that should be executed when the form becomes visible

=head2 get_active_id

Get the id of the value which is currently active

=head2 form

Return the form object of this control

=head2 show_sub_begin

Output begin of sub form

=head2 show_sub_end

Output end of sub form

=head2 show_label

Output the label of the control

=head2 show_label_icon

Output the icon after the label

=head2 show_label_cell

Output the table cell in which the label will be displayed

Must return the columns it spans (default: 1)

=head2 show_control

Output the control itself

=head2 show_control_readonly

Output the control itself as readonly

=head2 show_control_addons

output additional things after the control

=head2 show_control_cell

Output the table cell in which the control will be displayed

Gets the x position as argument


=head1 PARAMETERS

=head3 name

Specifies the name of the control

=head3 text

Will be used as label for the control, if not given
'name' is used as default.

Normaly the the name and text parameters are processed
by the method C<convert_label> of the C<Embperl::Form>
object. This method can be overwritten, to allow translation etc.

If the parameter C<showtext> is given a true value, C<convert_label>
is not called and the text is displayed as it is.

=head3 showtext

Display label without passing it through C<convert_label>. See C<text>.

=head2 labelnowrap

If set, the text label will not be line wrapped.

=head2 labelclass

If set, will be used as additional CSS classes for the label text cell.

=head2 readonly

If set, displays a readonly version of the control.

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

=head2 default

Default value of the control

=head1 AUTHOR

G. Richter (richter@dev.ecos.de)

=head1 SEE ALSO

perl(1), Embperl, Embperl::Form

