
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

package Embperl::Form::Control::grid ;

use strict ;
use base 'Embperl::Form::ControlMultValue' ;

use vars qw{%fdat $epreq} ;

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

    $self -> {header_bottom} = 10 if (!exists ($self -> {header_bottom})) ;
    $self -> {width} = 1 ;
    
    my $form = $self -> form ;
    $form -> new_controls ($self -> {fields}, $form -> {options}) ;

    return $self ;
    }

# ------------------------------------------------------------------------------------------
#
#   init_data - daten aufteilen
#

sub init_data
    {
    my ($self, $req) = @_ ;
    
    my $ldap    = $req->{ldap};
    my $name    = $self->{name} ;
    my @entries = ref $fdat{$name} eq 'ARRAY'?@{$fdat{$name}}:split("\t",$fdat{$name});
    my $fields  = $self -> {fields} ;

    my @data;
    my $i = 0 ;
    my $j ;
    my $col ;
    foreach my $entry (@entries)
        {
        @data = ecos::LdapBase -> splitAttrValue($entry);
        my $rowno = shift @data ;
        $j = 0 ;
        foreach my $field (@$fields)
            {
            $col = exists $field -> {col}?$field -> {col}:$j ;
            $fdat{"$name-$field->{name}-$i"} = $data[$col] ;
            if ($field -> can ('init_data'))
                {
                local $field->{name} = "$name-$field->{name}-$i" ;
                $field -> init_data ($req, $self)  ;
                }
            $j++ ;    
            }
        $i++ ;
        }
    $fdat{"$name-max"} = $i?$i:1;
    }

# ------------------------------------------------------------------------------------------
#
#   prepare_fdat_sub - wird aufgerufen nachdem die einzelen Controls abgearbeitet sind abd
#                   bevor die daten zusammenfuehrt werden
#

sub prepare_fdat_sub
    {
    my ($self, $req) = @_ ;
    
    }
    
# ------------------------------------------------------------------------------------------
#
#   prepare_fdat - daten zusammenfuehren
#

sub prepare_fdat
    {
    my ($self, $req) = @_ ;
    
    return if ($self -> {readonly}) ;
    
    my $ldap    = $req->{ldap};
    my $name    = $self->{name} ;
    my $fields  = $self -> {fields} ;
    my $max     = $fdat{"$name-max"} ;

    my @rows;
    my $j ;
    my $i ;
    my $val ;
    my $col ;
    my %orders ;
    my $order ;
    for (my $i = 0; $i < $max; $i++)
        {
	my $ok = 0 ;
        foreach my $field (@$fields)
            {
            if ((ref ($field) =~ /::/) && $field -> can ('prepare_fdat'))
                {
                local $field->{name} = "$name-$field->{name}-$i" ;
                $field -> prepare_fdat ($req)  ;
                }
	    $ok++ ;
            }
        
	next if (!$ok) ;

        $order = $fdat{"$name-#row#-$i"} ;
        $order = $i + 10000 if (!defined($order)) ;
        $orders{$order} = $i ;
        }

    $self -> prepare_fdat_sub ($req) if ((ref ($self) =~ /::/));

    foreach my $order (sort keys %orders)
        {
        $i = $orders{$order} ;
        $j = 0 ;
        my @data = ($i+1) ;
        foreach my $field (@$fields)
            {
            $col = exists $field -> {col}?$field -> {col}:$j ;
            $data[$col+1] = $fdat{"$name-$field->{name}-$i"} ;
            $j++ ;
            }
        $val = ecos::LdapBase -> joinAttrValue(\@data) ;
        push @rows, $val if ($val ne '') ;    
        }
    $fdat{$name} = \@rows ;    
    }

1 ;

__EMBPERL__


[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show ($self, $req)

    my $name     = $self -> {name} ;
    my $span = ($self->{width_percent})  ;
    my $nsprefix = $self -> form -> {jsnamespace} ;
    my $jsname = $name ;
    $jsname =~ s/[^a-zA-Z0-9]/_/g ;
    $jsname .= 'Grid' ;
    my $max    = $fdat{"$name-max"} ;
$]
  <td class="cBase cLabelBox" colspan="[+ $span +]">
  [-
    $fdat{$name} = $self -> {default} if ($fdat{$name} eq '' && exists ($self -> {default})) ;
    my $span = 0 ;
    $self -> show_grid_title ($jsname);
  -]
  <input type="hidden" name="[+ $self -> {name} +]-max" id="[+ $self -> {id} +]-max">
  <table class="cGridTable cBase" id="[+ $self -> {id} +]">
    [- $self -> show_grid_header ($req); -]
    [- $self -> show_grid_table ($req) ; -]
  </table>
  [- $self -> show_grid_title ($jsname)
            if ($max > $self -> {header_bottom}) -]
  <table id="[+ $self -> {id} +]-newrow" style="display: none">
    [-
    local $req -> {epf_no_script} = 1 ;
    $self -> show_grid_table_row ($req, '%row%') ;
    -]
  </table>
  <script>
      [+ $jsname +] = new [+ $nsprefix +]Grid (document.getElementById('[+ $self -> {id} +]'),
                                               document.getElementById('[+ $self -> {id} +]-newrow'),
                                               document.getElementById('[+ $self -> {id} +]-max')) ;
  </script>
  </td>
[$endsub$]
  

[# -----------------------------------------------------------------------------
#
#   show_grid_title - Zeigt den Titel der Tabelle an
#]

[$ sub show_grid_title ($self, $jsname)
$]
<table class="cBase cGridTitle">
  <tr class="cTableRow">
    <td class="cBase cGridLabelBox">[+ $self -> form -> convert_label ($self) +]</td>
    [$if !($self -> {readonly}) $]
    <td class="cBase cGridControlBox">
        <img src="/images/toup.gif" id="cmdUp" name="-up" title="Zeile Hoch" onclick="[+ $jsname +].upRow()">
        <img src="/images/todown.gif"  id="cmdDown"  name="-down" title="Zeile runter" onclick="[+ $jsname +].downRow()">
        <img src="/images/button_neu.gif" id="cmdAdd" name="-add" title="Zeile Hinzuf&uuml;gen  Alt-NUM+" onclick="[+ $jsname +].addRow()">
        <img src="/images/button_loeschen.gif"  id="cmdDelete"  name="-delete" title="Markierte Zeile L&ouml;schen  Alt-NUM-" onclick="[+ $jsname +].delRow()">
    </td>
    [$endif$]
  </tr>
</table>
[$ endsub $]
  
[# ---------------------------------------------------------------------------
#
#    show_grid_header    Erzeugt den Tabellenkopf
#]

[$ sub show_grid_header ($self, $req)

  my $fields = $self->{'fields'};
 $]
         <tr class="cGridHeader">
         [$ foreach my $field (@$fields) $]
            <td class="cGridHeader" [$if($width = $field->{width})$]width="[+$width+]"[$endif$]>[+ $self -> form -> convert_label ($self, $field->{name}, $field->{text}) +]</td>
         [$ endforeach $]
         </tr>
[$ endsub $]

[# ---------------------------------------------------------------------------
#
#    show_grid_table_row     Erzeugt eine Grid-Tabelle-Zeile
#]

[$ sub show_grid_table_row ($self, $req, $i) 

    my $fields = $self -> {fields} ;
    my $id     = $self -> {id};
    my $name   = $self -> {name} ;
    my $n      = 0 ;
    $]

    <tr class="cGridRow" id="[+ "$id-row-$i" +]">
        [$foreach $field (@$fields)$]
            <td class="cGridCell">[$if $n++ == 0$]<input type="hidden" name="[+ "$name-#row#-$i" +]" value="[+ $i +]">[$endif$][-
                local $field -> {name} = "$name-$field->{name}-$i" ;
                if ($self -> {readonly})
                    {
                    $field -> show_control_readonly ($req)
                    }
                else    
                    {
                    $field -> show_control ($req)
                    }
                -]</td>
        [$endforeach$]     
    </tr>             
[$ endsub $]
             
[# ---------------------------------------------------------------------------
#
#    show_grid_table     Erzeugt eine Grid-Tabelle
#]

[$ sub show_grid_table ($self, $req) 
    my $name    = $self->{name} ;
    my $fields = $self -> {fields} ;
    my $id     = $self -> {id};
    my $i      = 0 ;
    my $max    = $fdat{"$name-max"} || 1 ;
    $]

    [* for ($i = 0; $i < $max ; $i++ ) { *]
        [- $self -> show_grid_table_row ($req, $i) ; -]
    [* } *]
    
[$endsub$]



__END__

=pod

=head1 NAME

Embperl::Form::Control::grid - A grid control inside an Embperl Form


=head1 SYNOPSIS


=head1 DESCRIPTION

Used to create a grid control inside an Embperl Form.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'grid'

=head3 fields

Array ref with field definitions. Should look like any normal field definition.

The following extra attributes are available:

=over

=item col

Column number inside the @data array, which should be used for this cell

=back

=head3 header_bottom

If grid has more rows as given in this parameter,
a header line is also displayed at the bottom of the
grid. Default is 10. Set to -1 to always get a
header at the bottom.

=head2 Example

     {
     name => 'provider-path',
     text => 'Suchpfad',
     type => 'grid', 
     fields =>
        [
        { name => 'active', text => 'Aktiv', type => 'checkbox', width => '30' },
        { name => 'path',   text => 'Pfad' },
        ],
    },

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


