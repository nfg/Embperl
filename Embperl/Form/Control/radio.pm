
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

package Embperl::Form::Control::radio ;

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

    my ($values, $options) = $self -> get_values ;
    my $name     = $self -> {name} ;
    my $addtop   = $self -> {addtop} || [] ;
    my $addbottom= $self -> {addbottom} || [] ;
    my $set      = !defined ($fdat{$name})?1:0 ;
    my $filter   = $self -> {filter} ;

    my $val ;
    my $i = 0 ;

    if ($set)
        {
        foreach $val ((@$addtop, @$values, @$addbottom))
            {
            if (!defined ($filter) || (ref $val?$val -> [0]:$val =~ /$filter/i))
                {
                $fdat{$name} = ref $val?$val -> [0]:$val  ;
                last ;
                }
            }
        }

    $self -> show_control ($req, "^\Q$fdat{$name}\E\$", $values, $options) ;
    }

# ---------------------------------------------------------------------------

sub show_control_addons
    {
    my ($self, $req) = @_ ;

    }

1 ;

__EMBPERL__

[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self, $req, $filter, $values, $options)

    ($values, $options) = $self -> get_values ($req) if (!$values) ;
    my $name     = $self -> {name} ;
    $filter    ||= $self -> {filter} ;
    my $addtop   = $self -> {addtop} || [] ;
    my $addbottom= $self -> {addbottom} || [] ;
    my $ignorecase= $self -> {ignorecase} ;
    my $max      = @$values ;
    my $set      = !defined ($fdat{$name})?1:0 ;
    my $nsprefix = $self -> form -> {jsnamespace} ;

    my $val ;
    my $i = 0 ;

if ($self -> {vert})
    {
    $tr = '<tr>' ;
    $trend = '</tr>' ;
    $trglob = '' ;
    $trendglob = '' ;
    }
else
    {
    $tr = '' ;
    $trend = '' ;
    $trglob = '<tr>' ;
    $trendglob = '</tr>' ;
    }

$]
<table class="cRadioTab">[+ do { local $escmode = 0 ; $trglob }+]
[$ foreach $val (@$addtop) $]
    [$if !defined ($filter) || ($val->[0] =~ /$filter/i) $]
    [- $fdat{$name} = $val -> [0], $set = 0 if ($set) ; -]
    [+ do { local $escmode = 0 ; $tr }+]<td><input type="radio" name="[+ $name +]" value="[+ $val -> [0] +]"
    ></td><td>[+ $val ->[1] || $val -> [0] +]</td>[+ do { local $escmode = 0 ; $trend }+]
    [$endif$]
[$endforeach$]
[$ foreach $val (@$values) $][- $x = ($val =~ /$filter/i) -]
    [$if !defined ($filter) || ($val =~ /$filter/i) $]
    [- $fdat{$name} = $val, $set = 0 if ($set) ;
       $fdat{$name} = $val if ($ignorecase && lc($fdat{$name}) eq lc($val)) ; -]
    [+ do { local $escmode = 0 ; $tr }+]<td><input type="radio" name="[+ $name +]" value="[+ $val +]" id="[+ "$name-_-$val" +]"
    [$if ($self -> {sublines} || $self -> {subobjects}) $] OnClick="[+ $nsprefix +]show_radio_checked(document, this,[+ $i +],[+ $max +])" [$endif$]
    ></td><td>[+ $options ->[$i] || $val +]</td>[+ do { local $escmode = 0 ; $trend }+]
    [$endif$]
    [* $i++ ; *]
[$endforeach$]
[$ foreach $val (@$addbottom) $]
    [$if !defined ($filter) || ($val->[0] =~ /$filter/i) $]
    [- $fdat{$name} = $val -> [0], $set = 0 if ($set) ; -]
    [+ do { local $escmode = 0 ; $tr }+]<td><input type="radio" name="[+ $name +]" value="[+ $val -> [0] +]"
    ></td><td>[+ $val ->[1] || $val -> [0] +]</td>[+ do { local $escmode = 0 ; $trend }+]
    [$endif$]
[$endforeach$]
[+ do { local $escmode = 0 ; $trendglob }+]</table>
[$endsub$]



__END__

=pod

=head1 NAME

Embperl::Form::Control::radio - A radio control inside an Embperl Form


=head1 SYNOPSIS

  {
  type    => 'radio',
  text    => 'blabla',
  name    => 'foo',
  values  => [1,2,3],
  options => ['foo', 'bar', 'none'],
  }

=head1 DESCRIPTION

Used to create an radio control inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'radio'

=head3 name

Specifies the name of the radio control

=head3 text

Will be used as label for the radio control

=head3 values

Gives the values as an array ref of the radio control.

=head3 options

Gives the options as an array ref that should be displayed to the user.
If no options are given, the values from values are used.

=head3 vert

If specified arranges the radio button vertically. The number given specifies
the number of <br>'s used the separate the radio buttons.

=head3 ignorecase

If given, ignore the case of the posted values in %fdat, when selecting
a radio button.

=head3 addtop

Array ref which contains items that should be added at the left or top
of the radio buttons. Each item consists of an array ref with two
entries, the first is the value and the second is the option
that is displayed on the page. If the second is missing the
value (first entry)is displayed. Example:

    addtop => [ [1 => 'first item'], [2 => 'second item']]

=head3 addbottom

Array ref which contains items that should be added at the right or bottom
of the radio buttons. Each item consists of an array ref with two
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


