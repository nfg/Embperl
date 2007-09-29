
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

package Embperl::Form::Control::selectdyn ;

use strict ;
use vars qw{%fdat} ;
use base 'Embperl::Form::ControlMultValue' ;

use Embperl::Inline ;

# ---------------------------------------------------------------------------
#
#   show_control_readonly - output readonly control
#

sub show_control_readonly
    {
    my ($self, $req) = @_ ;

    my $name     = $self -> {name} ;
    $self -> show_control ($req, "^\Q$fdat{$name}\\E\$") ;
    }



1 ;

__EMBPERL__

[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self, $req, $filter)

    my ($values, $options) = $self -> get_values ($req) ;
    my $name     = $self -> {name} ;
    #$filter      ||= $self -> {filter} ;
    #my $addtop   = $self -> {addtop} || [] ;
    #my $addbottom= $self -> {addbottom} || [] ;
    my $noscript  = $req -> {epf_no_script} ;
    my $nsprefix = $self -> form -> {jsnamespace} ;
    my $jsname = $name ;
    if ($noscript)
        {
        $jsname =~ s/[^a-zA-Z0-9%]/_/g ;
        }
    else
        {
        $jsname =~ s/[^a-zA-Z0-9]/_/g ;
        }
    $self -> {size} ||= 75 / ($self -> {width} || 2) ;
    my $initval ;
    my $fdatval = $fdat{$name} ;
    my $i = 0 ;
    foreach (@$values)
        {
        if ($_ eq $fdatval)
            {
            $initval = $options->[$i] ;
            last ;
            }
        $i++ ;
        }

$]

<div class="cAutoCompDiv">

[# --- Popup --- #]
<div class="cPopupMenu" id="_menu_[+ $jsname +]"
style="display:none; position: absolute; top: 15px; z-index: 99; margin: 0px; padding: 0px;
border: 2px grey outset; background: white; text-align: center;"
>

<a href="#" onClick="location.href='ldapTreeData.epl?-id=' + encodeURIComponent([+ $jsname +]Popup.idval)">Anzeigen</a>&nbsp;
[#
<a href="#" onClick="alert('ldapTreeData.epl?-id=' + [+ $jsname +]Popup.idval)">Durchsuchen</a>&nbsp;
<a href="ldapTreeData?-id=">Neu</a>
#]
<div class="cPopupContainer" id="_info_[+ $jsname +]" style="margin: 0px; padding: 0px;">
</div>
</div>

[# --- Autocomplete --- #]
<div class="cAutoCompContainer" id="_cont_[+ $jsname +]" style="display:none">
</div>

[# --- input --- #]
<input class="cBase cControl cAutoCompInput" id="_inp_[+ $jsname +]" type="text"
[$if $self -> {size} $]size="[+ $self->{size} +]"[$endif$]
value="[+ $initval +]"
>
<div  class="cAutoCompArrow" onclick="[+ $jsname +]Popup.showPopup()"
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<input type="hidden" name="[+ $name +]" id="[+ $name +]" >
</div>

[# --- interface --- #]
<[$if $noscript $]x-[$endif$]script type="text/javascript">

        [+ $jsname +]Popup = new [+ $nsprefix +]Popup (document.getElementById('_menu_[+ $jsname +]'),
                                        document.getElementById('[+ $name +]'),
                                        document.getElementById('_info_[+ $jsname +]'),
                                        document.getElementById('_inp_[+ $jsname +]')) ;

        [+ $jsname +]AutoComp = new [+ $nsprefix +]Ajax.Autocompleter(document.getElementById('_inp_[+ $jsname +]'),document.getElementById('_cont_[+ $jsname +]'),
            '/epfctrl/datasrc.exml', {paramName: "query", parameters: "datasrc=[+ $self -> {datasrc} +]", frequency: 0.3, update: document.getElementById('[+ $name +]')}) ; 
        [+ $jsname +]AutoComp.updateChoices ;

</[$if $noscript $]x-[$endif$]script>

[$endsub$]

__END__
, afterUpdateElement: [+ $jsname +]savevalue
=pod

=head1 NAME

Embperl::Form::Control::select - A select control inside an Embperl Form


=head1 SYNOPSIS

  {
  type    => 'select',
  text    => 'blabla',
  name    => 'foo',
  values  => [1,2,3],
  options => ['foo', 'bar', 'none'],
  rows    => 5
  }

=head1 DESCRIPTION

Used to create an select control inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'select'

=head3 name

Specifies the name of the select control

=head3 text

Will be used as label for the select control

=head3 values

Gives the values as an array ref of the select control.

=head3 options

Gives the options as an array ref that should be displayed to the user.
If no options are given, the values from values are used.

=head3 rows

If specified a select box is display with the given number of lines.
If not specified or undef, a drop down list is shown.

=head3 addtop

Array ref which contains items that should be added at the top
of the select box. Each item consists of an array ref with two
entries, the first is the value and the second is the option
that is displayed on the page. If the second is missing the
value (first entry)is displayed. Example:

    addtop => [ [1 => 'first item'], [2 => 'second item']]

=head3 addbottom

Array ref which contains items that should be added at the bottom
of the select box. Each item consists of an array ref with two
entries, the first is the value and the second is the option
that is displayed on the page. If the second is missing the
value (first entry)is displayed. Example:

    addbottom => [ [9999 => 'last item'], [9999 => 'very last item']]

=head3 filter

If given, only items where the value matches the regex given in
C<filter> are displayed.


=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


