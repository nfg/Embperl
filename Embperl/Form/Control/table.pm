
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

package Embperl::Form::Control::table ;

use strict ;
use base 'Embperl::Form::Control' ;

use Embperl::Inline ;

1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show_table - output the control
#]

[$ sub show_table ($self, $data) 

    my $span = ($self->{width_percent})  ;

$]
<td class="cBase cTabTD" colspan="[+ $span +]">
[$if $self -> {text} $]
[# --- heading text --- #]
<table width="100%"><tr><td class="cLabelBox">
[+ $self -> {text} +]<br>
</td></tr></table>
[$endif$]
<table width="100%">

[# --- heading columns --- #]
[- $i = 0 -]
[$foreach $line (@{$self->{columns}}) $]
<tr style="background: white">
[$foreach $c (@$line) $]
<td colspan="[+ ref $c?$c -> [2] || 1:1 +]" class="[+$self -> {line2} || (@{$self->{columns}} > 1 && $i == 0)?'cGridLabelBox':'cControlBox'+]">[+ ref $c?$c -> [1] || $c -> [0]:$c +]</td>
[$endforeach$]
[- $i++ -]
</tr>
[$endforeach$]

[# --- data --- #]
[$foreach $o (@$data) $]
[- $i = 0 -]
[$foreach $line (@{$self->{columns}}) $]
<tr style="background: white">
[$foreach $c (@$line) $]
<td colspan="[+ ref $c?$c -> [2] || 1:1 +]" class="[+$self -> {line2} || (@{$self->{columns}} > 1 && $i == 0)?'cGridLabelBox':'cControlBox'+]">[- $item = ref $c?$o -> {$c -> [0]}:$o -> {$c} -][+ ref $item?join ('; ',@$item):$item +]</td>
[$endforeach$]
[- $i++ -]
</tr>
[$endforeach$]
[$if $self -> {line2} $]
    <tr>
    <td class="cControlBox" colspan="[+ scalar(@{$self->{columns}})+]">[+ join ('<br>', @{$o->{$self -> {line2}}}) +]</td>
    </tr>
[$endif$]
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

=head3 line2

Arrayref with names of which the values should concated and displayed
below each entry.


=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


