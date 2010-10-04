
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

package Embperl::Form::Control::table ;

use strict ;
use base 'Embperl::Form::Control' ;

use Embperl::Inline ;

sub cellstyle { '' } ;

1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show_table - output the control
#]

[$ sub show_table ($self, $data) 

    my $span = ($self->{width_percent})  ;
    my $showtext = $self -> {showtext} ;
$]
<td class="cBase cTabTD" colspan="[+ $span +]">
[$if $self -> {text} $]
[# --- heading text --- #]
<table width="100%"><tr><td class="cLabelBox">
[+ $self -> {showtext}?($self->{text} || $self->{name}):$self -> form -> convert_label ($self) +]<br>
</td></tr></table>
[$endif$]
<table width="100%">

[# --- heading columns --- #]
[- $i = 0 -]
[$foreach $line (@{$self->{columns}}) $]
<tr style="background: white">
[$foreach $c (@$line) $]
<td colspan="[+ ref $c?$c -> [2] || 1:1 +]" class="[+$self -> {line2} || (@{$self->{columns}} > 1 && $i == 0)?'cGridLabelBox':'cControlBox'+]  cLdapReportColumnHead">[+ $showtext?(ref $c?$c -> [1] || $c -> [0]:$c):$self -> form -> convert_label ($self, ref $c?$c -> [1]:$c) +]</td>
[$endforeach$]
[- $i++ -]
</tr>
[$endforeach$]

[# --- data --- #]
[- $r = 0 -]
[$foreach $o (@$data) $]
[- $i = 0 -]
[$foreach $line (@{$self->{columns}}) $]
<tr style="background: white">
[$foreach $c (@$line) $][-
    $attr = ref $c?$c -> [0]:$c ;
    $item = $o -> {$attr} ;
    $item = ref $item?join ('; ',@$item):$item ;
    if ($filter = $c -> [6])
	{
	die "unknown filter '$filter'" if (!($filtercode = $self -> {filters}{$filter})) ;
	$item = &{$filtercode}($item, $c, $o, $epreq) ;
	}
    -]<td colspan="[+ ref $c?$c -> [2] || 1:1 +]" class="[# +$self -> {line2} || (@{$self->{columns}} > 1 && $i == 0)?'cGridLabelBox':'cControlBox'+ #] cLdapReportTd" style="[+ $self -> cellstyle ($item, $o, $r, $i, $attr) +]">[$ if $c -> [3] && ($item =~ /^&(.*?),(.*?),(.*)$/) $]
            [$ if $1 eq 'checkbox' $]<input type="checkbox" name="[+ $2 +]" value="[+ $3 +]">[$endif$]
            [$ if $1 eq 'radio' $]<input type="radio" name="[+ $2 +]" value="[+ $3 +]">[$endif$]
            [$elsif ($c -> [4] && $o -> {$c -> [4]}) $]<a href="[+ do { local $escmode = 0 ; $o -> {$c -> [4]} } +]" target="[+ $c -> [5] +]">[+ ref $item?join ('; ',@$item):$item +]</a>
            [$else$][+ ref $item?join ('; ',@$item):$item +][$endif$]</td>
[$endforeach$]
[- $i++ -]
</tr>
[$endforeach$]
[$if $self -> {line2} $]
    <tr>
    <td class="cControlBox" colspan="[+ scalar(@{$self->{columns}})+]">[+ join ('<br>', @{$o->{$self -> {line2}}}) +]</td>
    </tr>
[$endif$]
[- $r++ -]
[$endforeach$]
</table>
</td>

[$endsub$]

__END__

=pod

=head1 NAME

Embperl::Form::Control::table - A table which get data from LDAP composed via joinAttrValue


=head1 SYNOPSIS

  { 
  type => 'table',
  text => 'blabla', 
  columns => [['foo', 'Foo item'], 'bar'],
  }

=head1 DESCRIPTION

Used as a base class to create an table control inside an Embperl Form.
See Embperl::Form on how to specify parameters.
You need to overwrite this class and call the method
show_table. show_table takes an arrayref of hashrefs as parameter
which is used as data to display.

=head2 PARAMETER

=head3 type

Needs to be 'table'

=head3 text 

Will be used as label for the control

=head3 columns

Arraryref which contains an arrayrefs with definition of columns names.
Allows to specify multiple rows per data entry. Column definition
is either the name in the data hashref or an arrayref with the name in
the hash ref and the text to display as heading. Example:

    [
     [['email', 'E-Mail Address'], ['phone', 'Phone']],
     [['foo', 'Foo'], ['bar', 'Bar']],
    ]

email and phone will be display on the first line with headings
'E-Mail Address' and 'Phone' and foo and bar will be displayed
on the second line for each entry.

It is possible to add additional information. One entry might
contain the following entries:

=over

=item 0

Key for into data hashref

=item 1

Text to display

=item 2

Colspan (how many colums this cell should span)

=item 3

If set a control is displayed instead of a text. Must contain:

radio,<name>,<value> or checkbox,<name>,<value>

=item 4

Display as link. This item contains the name of the key in the data hashref
that holds the href.

=item 5

target for link

=item 6

Name of filter function. The value of the cell is process through this filter.
Filter functions are passed as hashref of subs in the paramter 'filters' .

=back

=head3 line2

Arrayref with names of which the values should concated and displayed
below each entry.

=head3 filters

Hashref of coderefs which contains filter functions. The following example
shows one filter called 'date' which passes the data throught the perl
function format_date. The value is passed as first argument to the filter
function. The second argument is the column description (see above), 
the third argument is the row data and the last argument is the 
current Embperl request record.

  filters => 
	{
	'date' => sub
	    {
	    return format_date ($_[0]) ;
	    }
        }

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


