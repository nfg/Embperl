
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

package Embperl::Form::Control::mult ;

use strict ;
use base 'Embperl::Form::Control::grid' ;

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
    
    my $form = $self -> form ;
    $self -> {fields} ||= [$self -> {field}] ;
    $self -> {class}  ||= 'cMult' ;
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
    my @entries = split("\t",$fdat{$name});

    my $i = 0 ;
    foreach my $entry (@entries)
        {
        $fdat{"$name--$i"} = $entry ;
            
        $i++ ;
        }
    $fdat{"$name-max"} = $i?$i:1;
    }

# ------------------------------------------------------------------------------------------
#
#   prepare_fdat - daten zusammenfuehren
#

sub prepare_fdat
    {
    my ($self, $req) = @_ ;
    my $ldap    = $req->{ldap};
    my $name    = $self->{name} ;
    my $max     = $fdat{"$name-max"} || 1 ;

    my @rows;
    my $val ;
    for (my $i = 0; $i < $max; $i++)
        {
        $val = $fdat{"$name--$i"} ;
        push @rows, $val if ($val ne '') ;
        }
    $fdat{$name} = \@rows ;    
    }

sub show { Embperl::Form::Control::show (@_) } 

1 ;

__EMBPERL__


[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self, $req)

    my $name     = $self -> {name} ;
    my $span = ($self->{width_percent})  ;
    my $nsprefix = $self -> form -> {jsnamespace} ;
    my $jsname = $name ;
    $jsname =~ s/[^a-zA-Z0-9]/_/g ;
    $jsname .= 'Grid' ;
    my $max    = $fdat{"$name-max"} ;
$]
  [-
    $fdat{$name} = $self -> {default} if ($fdat{$name} eq '' && exists ($self -> {default})) ;
    my $span = 0 ;
  -]
  <input type="hidden" name="[+ $self -> {name} +]-max" id="[+ $self -> {id} +]-max">
  <table class="[+ $self -> {class} +]Table cBase" id="[+ $self -> {id} +]">
    [- $self -> show_grid_table ($req) ; -]
  </table>
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
[$endsub$]
  


[# ---------------------------------------------------------------------------
#
#    show_grid_table_row     Erzeugt eine Grid-Tabelle-Zeile
#]

[$ sub show_grid_table_row ($self, $req, $i) 

    $field = $self -> {fields}[0] ;
    $id     = $self -> {id};
    $name   = $self -> {name} ;
    my $jsname = $name ;
    $jsname =~ s/[^a-zA-Z0-9]/_/g ;
    $jsname .= 'Grid' ;
    $]

    <tr class="cGridRow" id="[+ "$id-row-$i" +]">

            <td class="[+ $self -> {class} +]Cell">
              [-
                local $field -> {name} = "$name--$i" ;
                $field -> show_control ($req)
                -]
            </td>
    </tr>             
[$ endsub $]


[$ sub show_label_icon ($self)
    $name   = $self -> {name} ;
    my $jsname = $name ;
    $jsname =~ s/[^a-zA-Z0-9]/_/g ;
    $jsname .= 'Grid' ;
 
 
 $]
              <img src="/images/button_plus.gif" id="cmdAdd" name="-add" title="Zeile Hinzuf&uuml;gen" onclick="[+ $jsname +].addRow()">
              <img src="/images/button_kreuz.gif"  id="cmdDelete"  name="-delete" title="Zeile L&ouml;schen" onclick="[+ $jsname +].delRow()">
[$endsub$]
             
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

Array ref with field definitions

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


