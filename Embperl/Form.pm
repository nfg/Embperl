
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


package Embperl::Form ;

use strict ;

use lib qw{..} ;

use Embperl ;
use Embperl::Form::Control ;
use Embperl::Form::Validate ;
use Embperl::Form::Control::blank ;

use Embperl::Inline ;

use Data::Dumper ;

our %forms ;
our %CLEANUP = ('forms' => 0) ;

# ---------------------------------------------------------------------------
#
#   new - create a new form
#


sub new

    {
    my ($class, $controls, $options, $id, $validate_rules, $parentptr) = @_ ;

    my $toplevel = $validate_rules?0:1 ;
    $id ||= 'topdiv' ;
    $options ||= {} ;

    my $self = ref $class?$class:{} ;

    $self -> {controls}       = $controls ;
    $self -> {options}        = $options ;
    $self -> {id}             = $id ;
    $self -> {parentptr}      = $parentptr ;
    $self -> {formname}       = $options -> {formname} || 'topform' ;
    $self -> {bottom_code}    = [] ;
    $self -> {validate_rules} = [] ;
    $self -> {toplevel}       = $toplevel ;
    $self -> {valign}         = $options -> {valign}   || 'top' ;
    $self -> {jsnamespace}    = $options -> {jsnamespace} || '' ;
    $self -> {jsnamespace}   .= '.' if ($self -> {jsnamespace}) ;
    
    bless $self, $class if (!ref $class);

    $Embperl::FormData::forms{"$self"} = $self ;
    if (!$validate_rules)
        {
        $validate_rules = $self -> {validate_rules} = [] ;
        }

    if ($toplevel)
        {
	$self -> {fields2empty} = [] ;
        $self -> {init_data}    = [] ;
        $self -> {prepare_fdat} = [] ;
        }
    else
        {
        $self -> {fields2empty} = $self -> parent_form -> {fields2empty} ;
        $self -> {init_data}    = $self -> parent_form -> {init_data} ;
        $self -> {prepare_fdat} = $self -> parent_form -> {prepare_fdat} ;
        }

    $self -> new_controls ($controls, $options, undef, $id, $validate_rules, $options -> {masks}, $options -> {defaults}) ;

    $self -> {noframe} = 1 if ($controls && @$controls > 0 &&
                               $controls -> [0] -> noframe) ;


    if ($toplevel)
        {
        my $epf = $self -> {validate} = Embperl::Form::Validate -> new ($validate_rules, $self -> {formname}) if ($self -> {validate_rules}) ;
        $self -> add_code_at_bottom ($epf -> get_script_code) ;
        }

    return $self ;
    }

# ---------------------------------------------------------------------------
#
#   DESTROY
#

sub DESTROY
    {
    my ($self) = @_ ;

    delete $Embperl::FormData::forms{"$self"} ;
    }

# ---------------------------------------------------------------------------
#
#   get_control_packages
#
#   returns an array ref with packges where to search for control classes
#

sub get_control_packages
    {
    my ($self) = @_ ;

    return $self -> {control_packages} || ['Embperl::Form::Control'] ;
    }

# ---------------------------------------------------------------------------
#
#   get_datasrc_packages
#
#   returns an array ref with packges where to search for data source classes
#

sub get_datasrc_packages
    {
    my ($self) = @_ ;

    return $self -> {datasrc_packages} || ['Embperl::Form::DataSource'] ;
    }

# ---------------------------------------------------------------------------
#
#   new_object - load a control or datasrc class and create a new object of
#                this class
#
#   in  $packages   arrayref of packages to search the class
#       $name       name of the class. Either a full package name or
#                   only the last part of the package. In the later
#                   @$packages are searched for this class
#   ret             reference to the object
#

sub new_object

    {
    my ($self, $packages, $name, $args) = @_ ;

    my $ctlmod ;
    my $obj ;

    $args ||= {} ;

    if ($name =~ /::/)
        {
        if (!defined (&{"$name\:\:new"}))
            {
            eval "require $name" ;
            warn $@ if ($@ && ($@ !~ /Can\'t locate/)) ;
            }
        $obj = $name -> new ($args) ;
        $ctlmod = $name ;
        }
    else
        {
        foreach my $package (@$packages)
            {
            my $mod = "$package\:\:$name"  ;
            if ($mod -> can('new'))
                {
                $obj = $mod -> new ($args) ;
                $ctlmod = $mod ;
                last ;
                }
            }
        if (!$ctlmod)
            {
            foreach my $package (@$packages)
                {
                my $mod = "$package\:\:$name"  ;
                eval "require $mod" ;
                warn $@ if ($@ && ($@ !~ /Can\'t locate/)) ;
                if ($mod -> can('new'))
                    {
                    $obj = $mod -> new ($args) ;
                    $ctlmod = $mod ;
                    last ;
                    }
                }
            }
        }
    die "No Module found for type = $name, searched: @$packages" if (!$ctlmod || !$obj) ;

    return $obj ;
    }


# ---------------------------------------------------------------------------
#
#   new_controls - transform elements to control objects
#


sub new_controls

    {
    my ($self, $controls, $options, $id, $formid, $validate_rules, $masks, $defaults) = @_ ;

    my $n = 0 ;
    my $packages = $self -> get_control_packages ;

    foreach my $control (@$controls)
        {
        die "control definition must be a hashref or an object, is '$control' " if (!ref $control || ref $control eq 'ARRAY');

        my $name = $control -> {name} ;
        $control -> {type} =~ s/sf_select.+/select/ ;
        $control -> {parentid}   = $id if ($id) ;
        $control -> {id} ||= "$control->{name}-$n" ;
        $control -> {formid} = $formid ;
        $control -> {formptr} = "$self" ;

        my $type    = $control -> {type} ;
        my $default = $defaults -> {$name} || $defaults -> {"*$type"} || $defaults -> {'*'};
        my $mask    = $masks    -> {$name} || $masks -> {"*$type"} || $masks -> {'*'};
        if ($mask)
            {
            foreach (keys %$mask)
                {
                $control -> {$_} = $mask -> {$_}  ;
                }
            }
        if ($default)
            {
            foreach (keys %$default)
                {
                $control -> {$_} = $default -> {$_} if (!exists $control -> {$_}) ;
                }
            }


        if (ref $control eq 'HASH')
            {
            my $type = $control -> {type} || ($control -> {name}?'input':'blank') ;
            $control = $self -> new_object ($packages, $type, $control) ;
            push @{$self -> {init_data}}, $control if ($control -> can ('init_data')) ;
            push @{$self -> {prepare_fdat}}, $control if ($control -> can ('prepare_fdat')) ;

            }

        next if ($control -> is_disabled) ;
        push @{$validate_rules}, $control -> get_validate_rules ;
        if ($control -> {sublines})
            {
            my $i = 0 ;
            my $name = $control -> {name} ;
            foreach my $subcontrols (@{$control -> {sublines}})
                {
                next if (!$subcontrols) ;
                $self -> new_controls ($subcontrols, $options, "$name-$i", $formid, $validate_rules, $masks, $defaults) ;
                $i++ ;
                }
            }
        if ($control -> {subforms})
            {
            my @obj ;
            my @ids ;
            my $i = 1 ;

            foreach my $subcontrols (@{$control -> {subforms}})
                {
                next if (!$subcontrols) ;
                my $id = "$control->{name}-$i" ;
                my $class = ref $self ;
                my $subform = $class -> new ($subcontrols, $options, $id, $validate_rules, "$self") ;
                push @ids, $id ;
                push @obj, $subform ;
                $i++ ;
                }
            $control -> {subobjects} = \@obj ;
            $control -> {subids}     = \@ids ;
            }
        $n++ ;
        }
    }

# ---------------------------------------------------------------------------
#
#   parent_form - return parent form object if any
#

sub parent_form
    {
    my ($self) = @_ ;

    return $Embperl::FormData::forms{$self -> {parentptr}} ;
    }


# ---------------------------------------------------------------------------
#
#   add_code_at_bottom - add js code at the bottom of the page
#

sub add_code_at_bottom

    {
    my ($self, $code) = @_ ;

    push @{$self->{bottom_code}}, $code ;
    }


# ---------------------------------------------------------------------------
#
#   layout - build the layout of the form
#

sub layout

    {
    my ($self, $controls, $level) = @_ ;

    $controls ||= $self -> {controls} ;
    $level    ||= 1 ;

    my $x     = 0 ;
    my $max_x = 100 ;
    my $line  = [] ;
    my @lines ;
    my $max_num = 0 ;
    my $num = 0 ;
    foreach my $control (@$controls)
        {
        next if ($control -> is_disabled) ;
        my $width = $control -> {width_percent} || int($max_x / ($control -> {width} || 2)) ;
        if ($x + $width > $max_x || $control -> {newline} > 0 || (($control -> {sublines} || $control -> {subobjects}) && @$line))
            { # new line
            if ($x < $max_x)
                {
                push @$line, Embperl::Form::Control::blank -> new (
                        {width_percent => $max_x - $x, level => $level }) ;
                }
            push @lines, $line ;
            $line = [] ;
            $x    = 0 ;
            $num  = 0 ;
            }
        push @$line, $control  ;
        $control -> {width_percent} = $width ;
        $control -> {x_percent}     = $x ;
	$control -> {level}         = $level ;
        $x += $width ;
        $num++ ;
        $max_num = $num if ($num > $max_num) ;

        if ($control -> {subobjects} || $control -> {sublines} || $control -> {newline} < 0)
            { # new line
            if ($x < $max_x)
                {
                push @$line, Embperl::Form::Control::blank -> new (
                        {width_percent => $max_x - $x }) ;
                }
            push @lines, $line ;
            $line = [] ;
            $x    = 0 ;
            $num  = 0 ;
            }

        if ($control -> {sublines})
            {
            foreach my $subcontrols (@{$control -> {sublines}})
                {
                next if (!$subcontrols) ;
                my $sublines = $self -> layout ($subcontrols, $level + 1) ;
                push @lines, @$sublines ;
                }
            }
        if ($control -> {subobjects})
            {
            my @obj ;
            foreach my $subobj (@{$control -> {subobjects}})
                {
                next if (!$subobj) ;
                $subobj -> layout ;
                }
            }
        }

    push @lines, $line if (@$line);
    $self -> {max_num} = $max_num ;
    return $self -> {layout} = \@lines ;
    }


# ---------------------------------------------------------------------------
#
#   show_controls - output the form control area
#

sub show_controls

    {
    my ($self, $req, $activeid) = @_ ;

    my $lines = $self -> {layout} ;
    my %n ;
    my $activesubid ;
    my @activesubid ;

    $self -> show_controls_begin ($req, $activeid) ;
    my $lineno = 0 ;
    foreach my $line (@$lines)
        {
        my $linelevel = @$line?$line->[0]{level}:0 ;
        my $lineid    = @$line && $line->[0]{parentid}?"$line->[0]{parentid}":'id' ;
        $n{$lineid} ||= 10 ;

        my $visible = $self -> show_line_begin ($req, $lineno, "$lineid-$n{$lineid}", $activesubid[$linelevel-1] || $activeid);
        foreach my $control (@$line)
            {
            my $newactivesubid = $visible?$control -> get_active_id ($req):'-' ;
            $control -> show ($req);
            $activesubid[$control -> {level}] = $newactivesubid if ($newactivesubid) ;
            if ($control -> {subobjects})
                {
                my @obj ;
                $control -> show_sub_begin ($req) ;
                foreach my $subobj (@{$control -> {subobjects}})
                    {
                    next if (!$subobj || !$subobj -> {controls} || !@{$subobj -> {controls}}) ;
                    $subobj -> show ($req, $activesubid[$control -> {level}]) ;
                    }
                $control -> show_sub_end ($req) ;
                }
            }
        $self -> show_line_end ($req, $lineno);
        $lineno++ ;
        $n{$lineid}++ ;
        }
    $self -> show_controls_end ($req) ;

    return ;
    }


# ---------------------------------------------------------------------------
#
#   show - output the form
#

sub show

    {
    my ($self, $req, $activeid) = @_ ;

    $self -> init_data ($req) if ($self -> {toplevel});
    #$self -> validate ($req) if ($self -> {toplevel});
    $self -> show_form_begin ($req) if ($self -> {toplevel});
    $self -> show_controls ($req, $activeid) ;
    $self -> show_form_end  ($req) if ($self -> {toplevel});
    }


# ---------------------------------------------------------------------------
#
#   init_data - init fdat before showing
#

sub init_data

    {
    my ($self, $req) = @_ ;

    foreach my $control (@{$self -> {init_data}})
        {
        $control -> init_data ($req) ;
        }
    }

# ---------------------------------------------------------------------------
#
#   prepare_fdat - change fdat after submit
#

sub prepare_fdat

    {
    my ($self, $req) = @_ ;
warn "embperl::form::prepare_fdat c=@{$self->{prepare_fdat}}" ;
    foreach my $control (@{$self -> {prepare_fdat}})
        {
        $control -> prepare_fdat ($req) ;
        }
    }

# ---------------------------------------------------------------------------
#
#   validate - validate the form input
#

sub validate

    {

    }


#------------------------------------------------------------------------------------------
#
#   add_tabs
#
#   fügt ein tab elsement mit subforms zu einem Formular hinzu
#
#   in $subform     array mit hashs
#                       text => <anzeige text>
#                       fn   => Dateiname
#                       fields => Felddefinitionen (alternativ zu fn)
#

sub add_tabs

    {
    my ($self, $subforms, $args) = @_ ;
    my @forms ;
    my @values ;
    my @options ;
    my @grids;
    $args ||= {} ;

    foreach my $file (@$subforms)
        {
        my $fn        = $file -> {fn} ;
        my $subfields = $file -> {fields} ;

        push @options, $file -> {text};
        if ($fn)
            {
            my $obj = Execute ({object => "./$fn"} ) ;
            #$subfields = eval {$obj -> fields ($r, {%$file, %$args}) || undef};
            }
        push @forms,  $subfields;
        push @grids,  $file -> {grid};
        push @values, $file -> {value} ||= scalar(@forms);
        }

    return {
            section => 'cSectionText',
            name    => '__auswahl',
            type    => 'tabs',
            values  => \@values,
            grids   => \@grids,
            options => \@options,
            subforms=> \@forms,
            width   => 1,
            },
    }

#------------------------------------------------------------------------------------------
#
#   add_line
#
#   adds the given controls into one line
#
#

sub add_line

    {
    my ($self, $controls, $cnt) = @_ ;

    $cnt ||= @$controls ;
    foreach my $control (@$controls)
        {
        $control -> {width} = $cnt ;
        }

    return @$controls ;
    }

#------------------------------------------------------------------------------------------
#
#   add_sublines
#
#   fügt ein tab elsement mit subforms zu einem Formular hinzu
#
#   in $subform     array mit hashs
#                       text => <anzeige text>
#                       fn   => Dateiname
#                       fields => Felddefinitionen (alternativ zu fn)
#


sub add_sublines
    {
    my ($self, $object_data, $subforms, $type) = @_;

    my $name    = $object_data->{name};
    my $text    = $object_data->{text};
    my $width   = $object_data->{width};
    my $section = $object_data->{section};

    $text ||= $name;

    my @forms ;
    my @values ;
    my @options ;

    foreach my $file (@$subforms)
        {
        my $fn        = $file -> {fn} ;
        my $subfields = $file -> {fields} ;
        if ($fn)
            {
            my $obj = Execute ({object => "./$fn"} ) ;
            #$subfields = eval {$obj -> fields ($r,$file) || undef};
            }
        push @forms,   $subfields || [];
        push @values,  $file->{value} || $file->{name};
        push @options, $file -> {text} || $file->{value} || $file->{name};
        }

    return { section => $section , width => $width, name => $name , text => $text, type => $type || 'select',
             values => \@values, options => \@options, sublines => \@forms,
             class  => $object_data->{class}, controlclass  => $object_data->{controlclass}};

    }

#------------------------------------------------------------------------------------------
#
#   fields_add_checkbox_subform
#
#   fügt ein checkbox Element mit Subforms hinzu
#
#   in $subform     array mit hashs
#                       text => <anzeige text>
#                       name => <name des Attributes>
#                       value => <Wert der checkbox>
#                       fn   => Dateiname
#                       fields => Felddefinitionen (alternativ zu fn)
#

sub add_checkbox_subform
    {
    my ($self, $subform, $args) = @_ ;
    $args ||= {} ;

    my $name    = $subform->{name};
    my $text    = $subform->{text};
    my $value   = $subform->{value} || 1 ;

    my $width   = $subform->{width};
    my $section;

    if(! $subform->{nosection})
        {
        $section = $subform->{section};
        $section ||= 1;
        }

    $name   ||= "__$value";
    $width  ||= 1;

    my $subfield;
    my $fn;
    if($subfield = $subform->{fields})
        {
        # .... ok
        }
    elsif($fn = $subform->{fn})
        {
        my $obj = Execute ({object => "./$fn"} ) ;
        #$subfield = [eval {$obj -> fields ($r, { %$file, %$args} ) || undef}];
        }


    return  {type => 'checkbox' , section => $section, width => $width, name => $name, text => $text, value => $value, sublines => $subfield}

    }


1;


__EMBPERL__

[$syntax EmbperlBlocks $]

[# ---------------------------------------------------------------------------
#
#   show_form_begin - output begin of form
#]

[$ sub show_form_begin ($self, $req) $]
<script language="javascript">var doValidate = 1 ;</script>
<script src="/js/EmbperlForm.js"></script>
<script src="/js/TableCtrl.js"></script>

<form id="[+ $self->{formname} +]" name="[+ $self->{formname} +]" method="post" action="[+ $self->{actionurl}+]"
[$ if ($self -> {on_submit_function}) $]
onSubmit="s=[+ $self->{on_submit_function} +];if (s) { v=doValidate; doValidate=1; return ((!v) || epform_validate_[+ $self->{formname} +]()); } else { return false; }"
[$else$]
onSubmit="v=doValidate; doValidate=1; return ( (!v) || epform_validate_[+ $self->{formname}+]());"
[$endif$]
>
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_form_end - output end of form
#]

[$ sub show_form_end ($req) $]
</form>
[$endsub$]

[ ---------------------------------------------------------------------------
#
#   show_controls_begin - output begin of form controls area
#]

[$ sub show_controls_begin  ($self, $req, $activeid)

my $parent = $self -> parent_form ;
my $class = $parent -> {noframe}?'cTableDivU':'cTableDiv' ;
$]
<div  id="[+ $self->{id} +]"
[$if ($activeid && $self->{id} ne $activeid) $] style="display: none" [$endif$]
>
[$if (!$self -> {noframe}) $]<table class="[+ $class +]"><tr><td class="cTabTD"> [$endif$]
<table class="cBase cTable">
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_controls_end - output end of form controls area
#]

[$sub show_controls_end ($self, $req) $]
</table>
[$ if (!$self -> {noframe}) $]</td></tr></table> [$endif$]
</div>

[$ if (@{$self->{bottom_code}}) $]
<script language="javascript">
[+ do { local $escmode = 0; join ("\n", @{$self->{bottom_code}}) } +]
</script>
[$endif$]
[$ if ($self -> {toplevel} && @{$self -> {fields2empty}}) $]
<input type="hidden" name="-fields2empty" value="[+ join (' ', @{$self -> {fields2empty}}) +]">
[$endif$]
[$endsub$]


[# ---------------------------------------------------------------------------
#
#   show_line_begin - output begin of line
#]

[$ sub show_line_begin ($self, $req, $lineno, $id, $activeid)

    $id =~ /^(.+)-(\d+?)-(\d+?)$/ ;
    my $baseid = $1 ;
    my $baseidn = $2 ;
    $activeid =~ /^(.+)-(\d+?)$/ ;
    my $baseaid = $1 ;
    my $baseaidn = $2 ;

    my $class = $lineno == 0?'cTableRow1':'cTableRow' ;
$]
    <tr class="[+ $class +]" valign="[+ $self->{valign} +]"
    [$if $id $] id="[+ $id +]" [$endif$]
    [$if ($activeid eq '-' || ($baseid eq $baseaid && $baseidn != $baseaidn)) $] style="display: none" [$endif$]
    >
[* return !($activeid eq '-' || ($baseid eq $baseaid && $baseidn != $baseaidn)) *]
[$endsub$]

[# ---------------------------------------------------------------------------
#
#   show_line_end - output end of line
#]

[$ sub show_line_end ($req) $]
  </tr>
[$endsub$]


__END__

=pod

=head1 NAME

Embperl::Form - Embperl Form class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 new ($controls, $options)

=over 4

=item * $controls

Array ref with controls which should be displayed
inside the form. Each control needs either to be a
hashref with all parameters for the control or
a control object.

If hash refs are given it's necessary to specify
the C<type> parameter, to let Embperl::Form
know which control to create.

See Embperl::Form::Control and Embperl::Form::Control::*
for a list of available parameters.

=item * $options

Hash ref which can take the following parameters:

=over 4

=item * formname

Will be used as name and id attribute of the form. If you have more
then one form on a page it's necessary to have different form names
to make form validation work correctly.

=item * masks

Contains a hash ref which can specify a set of masks
for the controls. A mask is a set of parameter which
overwrite the setting of a control. You can specify
a mask for a control name (key is name), for a control
type (key is *type) or for all controls (key is *).

Example:

    {
    'info'      => { readonly => 1},
    '*textarea' => { cols => 80 },
    '*'         => { labelclass => 'myclass', labelnowrap => 1}
    }

This will force the control with the name C<info> to be readonly, it
will force all C<textarea> controls to have 80 columns and
it will force the label of all controls to have a class of myclass
and not to wrap the text.

=item * defaults

Contains a hash ref which can specify a set of defaults
for the controls. You can specify
a default for a control name (key is name), for a control
type (key is *type) or for all controls (key is *).

Example:

    {
    'info'      => { readonly => 1},
    '*textarea' => { cols => 80 },
    '*'         => { labelclass => 'myclass', labelnowrap => 1}
    }

This will make the control with the name C<info> to default to be readonly, it
will deafult all C<textarea> controls to have 80 columns and
it will set the default class for the labels of all controls to
myclass and not to wrap the text.

=item * valign

valign for control cells. Defaults to 'top' .

=item * jsnamespace

Give the JavaScript Namespace. This allows to load js Files in
a top frame or different frame, which will speed up page loading,
because the browser does not need to reload the js code on every load.

Example:

    jsnamespace => 'top'

=back

=back

=head2 layout

=head2 show


=head1 AUTHOR

G. Richter (richter@dev.ecos.de)

=head1 SEE ALSO

perl(1), Embperl, Embperl::Form::Control





