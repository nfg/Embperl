
###################################################################################
#
#   Embperl - Copyright (c) 1997-2002 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: Default.pm,v 1.1.2.3 2002/03/08 06:44:14 richter Exp $
#
###################################################################################


package Embperl::Form::Validate::Default;

use strict;
use vars qw($VERSION %error_messages %script_functions %prefixes);

$VERSION = q$Id: Default.pm,v 1.1.2.3 2002/03/08 06:44:14 richter Exp $;

%script_functions = ();
%prefixes = ();

%error_messages = 
(
    de => 
    {
	validate_required => 'Bitte Feld "%0" ausf�llen',
	validate_eq => 'Falscher Inhalt "%1" des Feldes "%0": Erwartet wird "%2"',
	validate_lt => '%0 mu� kleiner als %2 sein',
	validate_gt => '%0 mu� gr��er als %2 sein',
	validate_le => '%0 mu� kleiner oder gleich wie %2 sein',
	validate_ge => '%0 mu� gr��er oder gleich %2 sein',
	validate_ne => '%0 mu� ungleich %2 sein',
	validate_length_max => 'Inhalt des Feldes %0 ist zu lang, maximale L�nge sind %2, eingegeben wurden %1 Zeichen',
	validate_length_min => 'Inhalt des Feldes %0 ist zu kurz, minimal L�nge sind %2, eingegeben wurden %1 Zeichen',
	validate_length_eq => 'Inhalt des Feldes %0 hat die falsche L�nge: Er sollte %2 Zeichen lang sein, ist aber %1 lang',
	validate_matches_regexp => 'Inhalt "%1" des Feldes %0 entspricht nicht dem regul�ren Ausdruck /%2/',
	validate_matches_wildcard => 'Inhalt "%1" des Feldes %0 entspricht nicht dem Wildcard-Ausdruck "%2"',
	validate_must_only_contain => 'Das Feld %0 darf nur folgende Zeichen enthalten: "%2"',
	validate_must_contain_one_of => 'Das Feld %0 mu� mindestens eines der folgenden Zeichen enthalten: "%2"',
	validate_must_not_contain => 'Das Feld %0 darf folgende Zeichen nicht enthalten: "%2"'
    },

    en =>
    {
	validate_required => 'Please enter a value in %0',
	validate_eq => 'Wrong content "%1" of field %0: Expected "%2"',
	validate_lt => '%0 must be less then %2',
	validate_gt => '%0 must be greater then %2',
	validate_le => '%0 must be less or equal then %2',
	validate_ge => '%0 must be greater or equal then %2',
	validate_ne => 'Wrong content "%1" of field %0: Expected not "%2"',
	validate_length_max => 'Content of field %0 is too long, has %1 characters, maximum is %2 characters',
	validate_length_min => 'Content of field %0 is too short, has %1 characters, minimum is %2 characters',
	validate_length_eq => 'Content of field %0 has wrong length: It is %1 characters long, but should be %2 characters long',
	validate_matches_regexp => 'Field %0 doesn"t match regexp /%2/',
	validate_matches_wildcard => 'Field %0 doesn"t match wildcard expression "%2"',
	validate_must_only_contain => 'Field %0 must contain only the following characters: "%2"',
	validate_must_contain_one_of => 'Field %0 must contain one of the following characters: "%2"',
	validate_must_not_contain => 'Field %0 must not contain the following characters: "%2"'
    }
 );



# --------------------------------------------------------------

sub new 
    {
    my $invokedby = shift;
    my $class = ref($invokedby) || $invokedby;
    my $self = {} ;
    bless($self, $class);
    $self->init;
    return $self;
    }

# --------------------------------------------------------------

sub getmsg
    {
    my ($self, $id, $language, $default_language) = @_ ;

    return $error_messages{$language}{$id} || $error_messages{$default_language}{$id} ;
    }

# --------------------------------------------------------------

sub init
    {
    my $self = shift;
    return 1;
    }

# --------------------------------------------------------------

sub validate 
    {
    return undef ; 
    }

# --------------------------------------------------------------

sub validate_required
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return defined($value) ? undef : ['validate_required'] ;
    }

# --------------------------------------------------------------

sub getscript_required
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ('obj.value', ['validate_required']) ;
    }

# --------------------------------------------------------------

sub validate_emptyok
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return defined($value) ? undef : [] ;
    }

# --------------------------------------------------------------

sub getscript_emptyok
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ('obj.value') ;
    }

# --------------------------------------------------------------

sub validate_eq 
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return $value eq $arg ? undef : ['validate_eq', $value, $arg] ;
    }

# --------------------------------------------------------------

sub getscript_eq 
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value == '$arg'", ['validate_eq', "+'obj.value'+", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_gt
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return $value gt $arg ? undef : ['validate_gt', $value, $arg] ;
    }

# --------------------------------------------------------------

sub getscript_gt
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value > '$arg'", ['validate_gt', "+'obj.value'+", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_lt
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return $value lt $arg ? undef : ['validate_lt', $value, $arg] ;
    }

# --------------------------------------------------------------

sub getscript_lt
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value < '$arg'", ['validate_lt', "+'obj.value'+", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_ge
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return $value ge $arg ? undef : ['validate_ge', $value, $arg] ;
    }

# --------------------------------------------------------------

sub getscript_ge
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value >= '$arg'", ['validate_ge', "+'obj.value'+", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_le
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return $value le $arg ? undef : ['validate_le', $value, $arg] ;
    }

# --------------------------------------------------------------

sub getscript_le
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value <= '$arg'", ['validate_gt', "+'obj.value'+", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_ne
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return $value ne $arg ? undef : ['validate_ne', $value, $arg] ;
    }

# --------------------------------------------------------------

sub getscript_ne
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value != '$arg'", ['validate_gt', "+'obj.value'+", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_length_max
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return length($value) <= $arg ? undef : ['validate_length_max', length($value), $arg] ;
    }

# --------------------------------------------------------------

sub getscript_length_max
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value.length <= $arg", ['validate_length_max', "'+obj.value.length+'", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_length_min
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return length($value) >= $arg ? undef : ['validate_length_min', length($value), $arg] ;
    }

# --------------------------------------------------------------

sub getscript_length_min
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value.length >= $arg", ['validate_length_min', "'+obj.value.length+'", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_length_eq
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return length($value) == $arg ? undef : ['validate_length_eq', length($value), $arg] ;
    }

# --------------------------------------------------------------

sub getscript_length_eq
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value.length == $arg", ['validate_length_eq', "'+obj.value.length+'", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_matches_regex
    {
    my ($self, $key, $value, $arg, $fdat, $pref) = @_ ;
    
    return ($value =~ /$arg/) ? undef : ['validate_matches_regex', $value, $arg] ;
    }

# --------------------------------------------------------------

sub validate_matches_wildcard
    {
    my ($self, $key, $value, $wc, $fdat, $pref) = @_ ;
    
    $wc =~ s/=/==/g;
    $wc =~ s/(^|[^\\])\?/$1=./g;
    $wc =~ s/([^\\])\*/$1=.=*/g;
    $wc =~ s/([^\\])([][])/$1=$2/g;
    $wc =~ s/=(.)/$1/g;

    return ($value =~ /$wc/) ? undef : ['validate_matches_wildcard', $value, $wc] ;
    }

# --------------------------------------------------------------

sub validate_must_only_contain
    {
    my ($self, $key, $value, $moc, $fdat, $pref) = @_ ;
    
    $moc =~ s/^\^(.)/$1^/;
    $moc =~ s/^(.*)\]/\]$1/;
    $moc =~ s/^(.*)-/-$1/;
    return ($value =~ /^[$moc]$/) ? undef : ['validate_must_only_contain', $value, $moc] ;
    }

# --------------------------------------------------------------

sub getscript_must_only_contain
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value.search(/^[$arg]*$/) >= 0", ['validate_must_only_contain', "'+obj.value+'", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_must_not_contain
    {
    my ($self, $key, $value, $mnc, $fdat, $pref) = @_ ;
    
    $mnc =~ s/^\^(.)/$1^/;
    return ($value !~ /[$mnc]/) ? undef : ['validate_must_only_contain', $value, $mnc] ;
    }

# --------------------------------------------------------------

sub getscript_must_not_contain
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value.search(/[$arg]/) == -1", ['validate_must_not_contain', "'+obj.value+'", $arg]) ;
    }

# --------------------------------------------------------------

sub validate_must_contain_one_of
    {
    my ($self, $key, $value, $mcoo, $fdat, $pref) = @_ ;
    
    $mcoo =~ s/^\^(.)/$1^/;
    return ($value =~ /[$mcoo]/) ? undef : ['validate_must_only_contain', $value, $mcoo] ;
    }

# --------------------------------------------------------------

sub getscript_must_contain_one_of
    {
    my ($self, $arg, $pref) = @_ ;
    
    return ("obj.value.search(/[$arg]/) >= 0", ['validate_must_contain_one_of', "'+obj.value+'", $arg]) ;
    }

# --------------------------------------------------------------


1 ;