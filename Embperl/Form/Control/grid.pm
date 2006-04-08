
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
    
    $self -> {width} = 1 ;
    return $self ;
    }


# ---------------------------------------------------------------------------
#
#   get_on_show_code 
#
#   retuns js code that should be excuted when form becomes visible
#

sub get_on_show_code 
    {
    my ($self) = @_ ;
    return "switch_grid('$self->{id}')";
    }

# ---------------------------------------------------------------------------
    
sub get_object
    {
    my $self = shift;
    return 'grid-entry';
    }    

# -------------------------------------------------------------------------------------- ----    

sub gridname
    {
    return 'cGridSimple';
    }   
    
# ------------------------------------------------------------------------------------------    

sub prepare_fdat
    {
    my $self = shift;
    
    my %list;
    my $gridname = $self->gridname;
    my $ldap = $epreq->{ldap}; 
 

    foreach my $entry (keys %fdat)
        {

        next if ($entry !~ /_($gridname)_/);
 
        if( $entry =~ /^_grid_[^_]+_([^_]+)_(\d+)/ )
            {

            my $name  = $1;
            my $index = $2;
            my $value = $fdat{$entry};
            $list{$index}->{$name} = $value;
            delete $fdat{$entry};
            }
        }    
    
    my @entries;
            
    foreach my $index (keys %list)
        {
        my $entry = $list{$index};
        $entry->{address}   =~ s/^--(.*)--$//;
        $entry->{param}     =~ s/^--(.*)--$//;        
        my $attr = $ldap->joinAttrValue([$index,$entry->{active},$entry->{param}]);
        push @entries,$attr;
        } 
 
    $fdat{$self->get_object} = join ("\t",@entries);
    }



# ------------------------------------------------------------------------------------------

sub get_data
    {
    my $self = shift;
    my $ldap = $epreq->{ldap}; 
    my @data;        
    my @create =
                (
                    {
                    param => '-- Bitte Daten eintragen --',                                      
                    active  => 0,
                    }
                ) ;
                                            
    my @entries     = split("\t",$fdat{$self->get_object});
                
    foreach my $entry (@entries)
        {
        my ($index,$active,$param) = $ldap->splitAttrValue($entry);     
        my $field           = {};
        $param              ||= $self->empty_line;
        $field->{active}    = $active;
        $field->{param}     = $param;       
         
        push @data,$field;
        }        
                         
    @data = @create if (! @data);    
    
    return (\@data, \@create) ;
    }
    
sub init
    {
    my ($self) = @_;            
    $self -> {gridname} = $self -> gridname ;  
    ($self -> {data}, $self -> {create}) = $self -> get_data ;    
    }

sub trclass { 'cGridData' }
sub hiddentrclass { '' }
sub gridname { 'default' }
sub onSubmit {'post_grid_data();return 1;'};
sub prepare_fdat {}
#sub empty_line {'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'}
sub empty_line {'                           '}
sub passmask {'****'}
sub passmask {'****'}
sub compare_pw_list
    {
    my ($self,$dn,$attrname,$attr2write,$attrindex,$savedindex) = @_;
    my $ldap    = $epreq->{ldap};
    my $attrs   = [$attrname];
    my $ldap_obj = $ldap->search($dn,'objectclass=*','base',$attrs);
    my $attrsaved = $ldap_obj->{$dn}->{$attrname};
    my %attrsaved;
    my %attr2write;
    my $passmask = $self->passmask;

#print STDERR 'START';
#print STDERR Data::Dumper::Dumper($attr2write);
#print STDERR Data::Dumper::Dumper($attrsaved);

    foreach my $entry (@$attrsaved)
        {
        my @entry = $ldap->splitAttrValue($entry);
        my $index = $entry[$savedindex];
        my $pass  = $entry[$attrindex];
        $attrsaved{$index} = $pass;
        }

#print STDERR Data::Dumper::Dumper(\%attrsaved);

    my $i = 0;
    foreach my $entry (@$attr2write)
        {
        my @entry = $ldap->splitAttrValue($entry);
        my $index = $entry[$savedindex];
        my $pass  = $entry[$attrindex];
        if ($pass eq $passmask)
            {
            $pass = $attrsaved{$index};
            $entry[$attrindex] = $pass;
            }
        my $entry2write = $ldap->joinAttrValue(\@entry);
        $attr2write->[$i] = $entry2write;
        $i++;
        }
#print STDERR Data::Dumper::Dumper($attr2write);
    return $attr2write;
    }
    



1 ;

__EMBPERL__
    
[# ---------------------------------------------------------------------------
#
#   show - output the control
#]

[$ sub show ($self) 

my $span = ($self->{width_percent})  ;
$]
  <td class="cBase cLabelBox" colspan="[+ $span +]">
  [- shift -> showgrid (@_) -]
  </td>
[$endsub$]



[# ################################################################################################
    draw_additional_div
   ################################################################################################ #]
[$ sub draw_additional_div $]
<div id="additional[- $self->draw_table_id; -]"  class="cGridHidden">
</div>
[$ endsub $]
[# #--- draw_additional_div ----# #]

[# ################################################################################################
    draw_auto_table
   ################################################################################################ #]
[$ sub draw_auto_table $]
<table id="auto_table" class="cGridHidden"></table>
[$ endsub $]
[# #--- draw_auto_table ----# #]

[# ################################################################################################
    draw_grid_table     Erzeugt eine Grid-Tabelle
    in                  hidden wenn gestetzt wird eine dynamische Tabelle erzeugt
   ################################################################################################ #]
[$ sub draw_grid_table $]
    [-
    my ($self,$hidden) = @_;

    if($hidden)
        { 
        $grid_data = $self -> {create};
        $trclass   = $self ->  hiddentrclass ;
        }
    else
        {
        $grid_data = $self -> {data};
        $trclass   = $self ->  trclass ;
        }
    $fields = $self -> {fields} ;
    $id = $self->{currentid};
    $id ||= 1 ;
    -]
    [$foreach $entry (@$grid_data)$]

    <TR [$if( $trclass )$]class="[+ $trclass +]"[$endif$]>

        [$foreach $field (@$fields)$]
            [-
            $val    = $entry->{$field->{'name'}};
            $domid  = '_grid_'.$self->{gridname}.'_'.$field->{name}."_$id" ;
            if($field->{type} && $epreq -> can ($field->{type}))
                {
                my $method = $field -> {type} ;
                $epreq -> $method ($field);
                }

            -] 

         [$if($field->{'type'} eq 'checkbox')$]
            <TD id="[+$domid+]" class="cGrid[+ ucfirst(lc($field->{'type'}))+]"><input name="[+$domid+]" type="checkbox" value="1" [$if($val)$]checked[$endif$]></TD>
         [$elsif($field->{'type'} eq 'select')$]
[-
#use Data::Dumper;
#print STDERR Dumper($field);
-]
               <TD id="[+$domid+]" class="cGrid[+ ucfirst(lc($field->{'type'}))+]">
               <select name="[+$domid+]" size="[+ $field->{size} | 1 +]">
                    [-$i=0-]
                    [$foreach my $option (@{$field->{options}}) $][-$value = $field->{values}->[$i] -]
                        <option value="[+$value+]" [$ if( $val eq $value)$]selected[$endif$]>[+$option+]</option>
                    [-$i++-]
                    [$endforeach$]
                  </select></TD>
         [$elsif($field->{'type'} eq 'blank')$]
            <TD id="[+$domid+]" class="cGrid[+ ucfirst(lc($field->{'type'}))+]" width="[+$field->{'width'}+]"></TD>
         [$elsif($field->{'type'} eq 'hidden')$]
           <TD style="display:none;"> <input type="hidden" name="[+$domid+]" value="[+$val+]"></TD>
         [$else$]
            <TD id="[+$domid+]" class="cGrid[+ ucfirst(lc($field->{'type'}))+]" width="[+$field->{'width'}+]">[+$val+]</TD>
         [$endif$]
                [$endforeach$]

        </TR>
        [- $id++;-]
           [$endforeach$]
      [-$self->{currentid} = $id;-]       
[$ endsub $]
[# #--- draw_grid_table ----# #]

[# ################################################################################################
    draw_grid_control    Erzeugt die Buttons zur Grid Steuerung 
   ################################################################################################ #]
[$ sub draw_grid_control $]
  [-
  ($self) = @_;
  -]
  <table class="control" align="center" cellpadding=0 cellspacing=0 border=0 rules="none" >
   <TR class="control">
     <TD colspan="[+self->{'control_colspan'}+]" align="center">
      <input class="cStandardButton" type="button" id="cmdAdd" name="-add" value="Hinzuf&uuml;gen" onclick="appendRow('[+$self->{'appendline_for_js'}+]')" title="Hinzuf&uuml;gen">
      <input class="cStandardButton" type="button" id="cmdDelete"  name="-delete" value="L&ouml;schen" onclick="delete_from_form('[+$self->{'appendline_for_js'}+]')" title="L&ouml;schen">
     </TD>
    </TR>
   </table> 
[$ endsub $]
[# #--- draw_grid_control ----# #]

[# ################################################################################################
    draw_grid_header    Erzeugt den Tabellenkopf  
   ################################################################################################ #]
[$ sub draw_grid_header $]
  [-
  ($self) = @_;
  $gridfields = $self->{'fields'};
  -]
         <TR class="cGridHeader">[-$i=0-]
         [* for (my $i = 0; $i < @$gridfields ; $i++) { *]
            [$if ($gridfields->[$i]->{text} )$]<TD class="cGridHeader" [$ if ($gridfields->[$i]->{sorted})$]axis="sorted"[$endif$] [$if($width = $gridfields->[$i]->{width})$]width="[+$width+]"[$endif$]>[+$gridfields->[$i]->{text}+]</TD>[$endif$]
         [* } *]
         </TR>
[$ endsub $] 
[# #--- draw_grid_header ----# #]

[# -----------------------------------------------------------------------------
#
#   show_grid_title - Zeigt den Titel der Tabelle an
#]

[$ sub show_grid_title $]
[- 
($self) = @_;
-]
<table class="cBase cGridTitle">
  <tr class="cTableRow">
    <td class="cBase cGridLabelBox">[+ $self->{text} +]</td> 
    <td class="cBase cGridControlBox">
        <img src="button_neu.gif" id="cmdAdd" name="-add" title="Zeile Hinzuf&uuml;gen" onclick="appendRow('[+$self->{'appendline_for_js'}+]')">
        <img src="button_loeschen.gif"  id="cmdDelete"  name="-delete" title="Markierte Zeile L&ouml;schen" onclick="delete_from_form('[+$self->{'appendline_for_js'}+]')">
    </td> 
  </tr>
</table>    
[$ endsub $]

[# ################################################################################################
    draw_table_id   Zeigt die DOM Id der Tabelle an  
   ################################################################################################ #]   

[$ sub draw_table_id $][- ($self) = @_;-][+$self -> {id} +][$ endsub $]
[# #--- draw_title ----# #]



[# ################################################################################################
    show    Erzeugt eine dynamische Tabelle 
        
    in      objektspezifische Grid-Daten Struktur :
    
            gridfields      =  Felder der Grid-Tabelle (angelehnt an das fields Format)
            griddata        =  Datensatz mit den Werten der Tabelle
            initdata        =  Datensatz mit den initialen Werten der Tabelle
            names2display   =  (optional) Arrayref mit den Titeln des Tabellenkopfes
            title           =  Titel der Grid-Tabelle
            trclass         =  css Klasse der Tabellenzeilen
            hiddentrclass   =  (optional) css Klasse für versteckte Tabellenfelder  
   ################################################################################################ #]
   
[$ sub showgrid $]
[-
($self) = @_;

$self -> init() ;
$epreq -> {'onSubmitLdapData'} = $self -> onSubmit ; 

-]

[#
<link rel="stylesheet" type="text/css" href="/grid.css">
<link rel="stylesheet" type="text/css" href="/base.css">
<SCRIPT src="/js/TableCtrl.js"></SCRIPT>
#]

[- $self->show_grid_title; -]
<table class="cBase cGridTable" id="[- $self->draw_table_id; -]" name="[- $self->draw_table_id; -]">
[- $self->draw_grid_header; -]
[- $self-> draw_grid_table; -]
</table>

[- $self->draw_auto_table;-]
[- $self->draw_additional_div;  -]

<div id="hidden_table_container[- $self->draw_table_id; -]"  class="cGridHidden">

<table id="hidden[- $self->draw_table_id; -]" class="cGridHidden">
[- $self-> draw_grid_table(1); -]
</table>
</div>

<div id="temp[- $self->draw_table_id; -]">
</div>

<SCRIPT language="javascript">
init('[- $self->draw_table_id; -]');
</SCRIPT>

[$endsub$]
[# #--- show ----# #]



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


=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


