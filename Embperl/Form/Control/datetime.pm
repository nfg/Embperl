
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

package Embperl::Form::Control::datetime ;

use strict ;
use base 'Embperl::Form::Control::number' ;

use Embperl::Inline ;
use POSIX qw(strftime);
use Time::Local qw(timelocal_nocheck timegm_nocheck);
use Date::Calc qw{Delta_DHMS Add_Delta_Days} ;

use vars qw{%fdat} ;

our $tz_local = (timegm_nocheck(localtime())-time())/60;


# ---------------------------------------------------------------------------
#
#   init - init the new control
#

sub init

    {
    my ($self) = @_ ;

    $self->{unit}      ||= '' ;

    
    return $self ;
    }
    
# ------------------------------------------------------------------------------------------
#
#   init_data - daten aufteilen
#

sub init_data
    {
    my ($self, $req, $parentctrl) = @_ ;
    
    my $name    = $self->{name} ;
    my $time    = $fdat{$name} ;
    return if ($time eq '') ;

    my ($y, $m, $d, $h, $min, $s, $z) = ($time =~ /^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(.)/) ;

    # Getting the local timezone

    my $date = eval
       {
       my @time = gmtime(timegm_nocheck($s,$min,$h,$d,$m-1,$y-1900)+($tz_local*60));

       my $format = $s == 0 && $h == 0 && $min == 0?'%d.%m.%Y':'%d.%m.%Y, %H:%M' ;
       strftime ($format, @time[0..5]) ;
       } ;

    if ($time && !$date && ($time =~ /\d+\.\d+\.\d+/))
	{
	$date = $time ;
	}

    $fdat{$name} = $date ;
    }

# ------------------------------------------------------------------------------------------
#
#   prepare_fdat - daten zusammenfuehren
#

sub prepare_fdat
    {
    my ($self, $req) = @_ ;

    return if ($self -> {readonly}) ;
    
    my $name    = $self->{name} ;
    my $date    = $fdat{$name} ;
    return if ($date eq '') ;
    
    my ($year, $mon, $day, $hour, $min, $sec) ;
    if ($date eq '*' || $date eq '.')
        {
        my $offset ||= 0 ;
        ($sec, $min, $hour, $day, $mon, $year) = gmtime (time + $offset) ;
        $year += 1900 ;
        $mon++ ;
        }
    else
        {
        $date =~ tr/,;/  / ;
        my ($d, $t) = split (/\s+/, $date) ;
        if ($d =~ /:/)
	    {
	    $t = $d ;
 	    $d = '' ;
	    }
        ($day, $mon, $year) = map { $_ + 0 } split (/\./, $d) ;
        ($hour, $min, $sec) = map { $_ + 0 } split (/\:/, $t) ;

        if ($year == 0 || $mon == 0 || $day == 0)
            {
            my ($s, $min, $h, $md, $m, $y) = localtime ;

            $day  ||= $md ;
            $mon  ||= $m + 1;
            $year ||= $y + 1900 ;
            }

        if ($year < 70)
            {
            $year += 2000 ;
            }
        elsif ($year >= 70 && $year < 100)
            {
            $year += 1900 ;
            }
        if ($year < 1907)
            {
            $year = $year % 100 + 2000 ;
            }

        ($year,$mon,$day, $hour,$min,$sec) =
             Date::Calc::Add_Delta_DHMS($year,$mon,$day, $hour,$min,$sec,
                            0, 0, -$tz_local, 0) if ($hour || $min || $sec) ;
        }

    $fdat{$name} = $year?sprintf ('%04d%02d%02d%02d%02d%02dZ', $year, $mon, $day, $hour, $min, $sec):'' ;
    }

1 ;

__EMBPERL__


[# ---------------------------------------------------------------------------
#
#   show_control - output the control
#]

[$ sub show_control ($self)

$self -> {size} ||= 80 / ($self -> {width} || 2) ;
my $class = $self -> {class} ||= 'cControlWidthInput' ;
my $nsprefix = $self -> form -> {jsnamespace} ;
$]

<input type="text"  class="cBase cControl [+ $class +]"  name="[+ $self->{name} +]" id="[+ $self->{id} +]"
[$if $self -> {size} $]size="[+ $self->{size} +]"[$endif$]
[$if $self -> {maxlength} $]maxlength="[+ $self->{maxlength} +]"[$endif$]
>
<script type="text/javascript">
  [+ $nsprefix +]Calendar.setup(
    {
      inputField  : document.getElementById('[+ $self -> {id} +]'),         // ID of the input field
      ifFormat    : "%d.%m.%Y",    // the date format
      //button      : "trigger"       // ID of the button
    }
  );
</script>



[$endsub$]


__END__

=pod

=head1 NAME

Embperl::Form::Control::price - A price input control with optional unit inside an Embperl Form


=head1 SYNOPSIS

  {
  type => 'price',
  text => 'blabla',
  name => 'foo',
  unit => 'sec',
  }

=head1 DESCRIPTION

Used to create a price input control inside an Embperl Form.
Will format number as a money ammout.
Optionaly it can display an unit after the input field.
See Embperl::Form on how to specify parameters.

=head2 PARAMETER

=head3 type

Needs to be 'price'

=head3 name

Specifies the name of the control

=head3 text

Will be used as label for the numeric input control

=head3 size

Gives the size in characters. (Default: 10)

=head3 maxlength

Gives the maximun length in characters

=head3 unit

Gives a string that should be displayed right of the input field.
(Default: €)

=head3 use_comma

If set the decimal character is comma instead of point (Default: on)

=head1 Author

G. Richter (richter@dev.ecos.de)

=head1 See Also

perl(1), Embperl, Embperl::Form


