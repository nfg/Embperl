package Embperl::WrapXS ;
use strict;
use vars qw{@ISA $VERSION $verbose} ;

use warnings FATAL => 'all';

use ExtUtils::XSBuilder::WrapXS ;

@ISA = ('ExtUtils::XSBuilder::WrapXS') ;

$VERSION = '0.01';

# ============================================================================

sub new_parsesource  { [ Embperl::ParseSource->new ] }

# ============================================================================

sub my_xs_prefix  { 'epxs_' }

# ============================================================================

sub h_filename_prefix  { 'ep_xs_' }

# ============================================================================

sub xs_includes  
    { 
    my $self = shift ;

    my $inc = $self -> SUPER::xs_includes ;

    unshift @$inc, "epmacro.h" ;
    unshift @$inc, "ep.h" ;

    return $inc ;
    }


sub xs_map_dir    { "$FindBin::Bin/maps" } ;

sub xs_target_dir { "$FindBin::Bin/../xs" } ;

sub xs_include_dir { "$FindBin::Bin/../xsinclude" } ;

sub trans
    {
    my $name = shift ;

    return $name if ($name !~ /[A-Z]/) ;
    $name =~ s/^.*?([A-Z])/$1/ ;
    $name =~ s/([A-Z]+)/'_' . lc($1)/eg ;
    $name =~ s/^_// ;
    return $name ;
    }



sub mapline_elem

    {
    my ($self, $name) = @_ ;

    my $perl_name = trans ($name) ;

    return "$name | $perl_name" if ($name ne $perl_name) ;
    return $name ;
    }


sub pm_text { undef } ;

sub makefilepl_text {
    my $self = shift ;

    my $code = $self -> SUPER::makefilepl_text (@_) ;

    $code .= q[

sub MY::top_targets
	{
	my ($txt) = shift -> MM::top_targets (@_) ;
        $txt =~ s/config\s+pm_to_blib\s+subdirs\s+linkext/\$(O_FILES) subdirs/ ; 
	return $txt ;
	}

] ;

    return $code ;
    }

