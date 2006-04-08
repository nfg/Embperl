
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

package Embperl::Form::Control::select ;

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
    my ($self) = @_ ;
    
    my $name     = $self -> {name} ;
    $self -> show_control ("^\Q$fdat{$name}\\E\$") ;
    }



1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self) 

    my ($values, $options) = $self -> get_values ;
    my $name     = $self -> {name} ;
    my $filter   = $self -> {filter} ;
    my $addtop   = $self -> {addtop} || [] ;
    my $addbottom= $self -> {addbottom} || [] ;
    my $val ;     
    my $i = 0 ;
$]    
<select  class="cBase cControl" name="[+ $name +]" id="[+ $name +]"
[$if ($self -> {sublines} || $self -> {subobjects}) $] OnChange="show_selected(this)" [$endif$]
[$if ($self -> {rows}) $] size="[+ $self->{rows} +]" [$endif$]
>
[$ foreach $val (@$addtop) $]
    [$if !defined ($filter) || ($val->[0] =~ /$filter/i) $]
    <option value="[+ $val->[0] +]">[+ $val ->[1] || $val -> [0] +]</option>
    [$endif$]
[$endforeach$]
[$ foreach $val (@$values) $]
    [$if !defined ($filter) || ($val =~ /$filter/i) $]
    <option value="[+ $val +]">[+ $options ->[$i] || $val +]</option>
    [$endif$]
    [* $i++ ; *]
[$endforeach$]
[$ foreach $val (@$addbottom) $]
    [$if !defined ($filter) || ($val->[0] =~ /$filter/i) $]
    <option value="[+ $val->[0] +]">[+ $val ->[1] || $val -> [0] +]</option>
    [$endif$]
[$endforeach$]
</select>

[$endsub$]

__END__

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


