
use Embperl::Recipe::XSLT ;
use Embperl::Recipe::Embperl  ;
use Embperl::Recipe::EmbperlXSLT  ;
use Embperl::Recipe::EmbperlPODXSLT  ;
use Embperl::Constant ;

   
sub fill_menu 

    {
    my ($config, $item, $baseuri, $root, $parent) = @_ ;

    foreach $m (@$item)
        {
        $m -> {parent} ||= $parent ;
        $m -> {url}  ||= "$baseuri$m->{uri}" ;
        if (!$m -> {file})
            {
            $m -> {path} = $root . $m -> {url} ;
            $m -> {path} .= 'index.htm' if ($m -> {path} =~ m#/$#) ;
            }
        elsif (ref $m -> {file})
            {
            $m -> {path} = { map { $_ => $root . $m->{file}{$_} } keys %{$m->{file}} } ;
            }
        else
            {
            $m -> {path} = $root . $m->{file} ;
            $m -> {path} .= 'index.htm' if ($m -> {path} =~ m#/$#) ;
            }
        $config -> {map1}{$m -> {url}} = $m ;
        $m  -> {url} =~ /^(.*)\./ ;
        $config -> {map2}{$1} = $m ;

        my $subbase ;
        if ($m -> {url} !~ m#/$#)
            {
            $m -> {url} =~ /^(.*)\./ ;
            $subbase = "$1/" ;
            }
        else
            {
            $subbase = $m -> {url} ;
            }

        fill_menu ($config, $m -> {sub}, $subbase, $root, $m) if ($m -> {sub}) ;        
        fill_menu ($config, $m -> {same}, $baseuri, $root, $parent) if ($m -> {same}) ;        
        }
    }


sub map_file
    {
    my ($r) = @_ ;
    my $uri = $r -> param -> uri ;
    my $config = $r -> {config} ;

    my $m ;
    $uri =~ /^(.*)\./ ;
    print STDERR "map_file uri=$uri 1=$1\n" ;
    if (!($m = $config -> {map1}{$uri} || $config -> {map2}{$1}))
        {
        $m = $config -> {map1}{$1} if ($uri =~ m#^(.*?/)index\..*$#) ;
        print STDERR "map_file uri=$uri 1=$1\n" ;
        }    

    if ($m)
        {
        my @menuitems = ($m) ;
        my $item = $m ;
        while ($item = $item -> {parent})
            {
            unshift @menuitems, $item ;
            }
        $r -> {menuitems} = \@menuitems ;
                print STDERR "fdat hash $m->{fdat}\n" ;
        if ($m -> {fdat})
            {
            while (my ($k, $v) = each %{$m -> {fdat}}) 
                {
                $fdat{$k} = $v ;
                print STDERR "fdat $k = $v \n" ;
                }
            }

        my $path = $m -> {path} ;
        if (ref $path)
            {
            return $path -> {$r -> param -> language} || $path -> {'en'} ;
            }

        return $path ;
        }
    return "$r->{root}$r->{baseuri}notfound.htm" ;
    }


sub init 
    {
    my $self     = shift ;
    my $r        = shift ;

    my $config = Execute ({object => 'config.pl', syntax => 'Perl'}) ;

    $config -> new ($r) ;    
    
    $r -> {config} = $config  ;    
    $r -> {menu}   = $config -> get_menu ($r) ;    
    fill_menu ($config, $r -> {menu}, $r -> {baseuri}, $r -> {root}) ;
    $pf = map_file ($r) ;
    $r -> param -> filename ($pf) ;

    #use Data::Dumper ;
    #print STDERR Dumper ($r -> {menu}, $r -> param -> uri, $pf, \%fdat) ;
    
    Execute ({inputfile => 'messages.pl', syntax => 'Perl'}) ;

    return 0 ;
    }





sub get_recipe

    {
    my ($class, $r, $recipe) = @_ ;

    my $self ;
    my $param  = $r -> component -> param  ;
    my $config = $r -> component -> config  ;
    my ($src)  = $param -> inputfile =~ /^.*\.(.*?)$/ ;
    my ($dest) = $r -> param -> uri =~ /^.*\.(.*?)$/ ;

   

    if ($src eq 'pl')
        {
        $config -> syntax('Perl') ;
        return Embperl::Recipe::Embperl -> get_recipe ($r, $recipe) ;
        }

    if ($src eq 'pod' || $src eq 'pm')
        {
        $config -> escmode(0) ;
        if ($dest eq 'pod')
            {
            $config -> syntax('Text') ;
            return Embperl::Recipe::Embperl -> get_recipe ($r, $recipe) ;
            }

        $config -> syntax('POD') ;
        if ($dest eq 'xml')
            {
            return Embperl::Recipe::Embperl -> get_recipe ($r, $recipe) ;
            }

        $config -> xsltstylesheet('pod.xsl') ;
        #$config -> xsltstylesheet($r -> {root} . $r -> {baseuri} . 'xml/pod.xsl') ;
        $r -> param -> uri =~ /^.*\/(.*)(\..*?)$/ ;
        $param -> xsltparam({page => $r -> thread -> form_hash -> {page} || 0, basename => "'$1'", extension => "'$2'"}) ;
        return Embperl::Recipe::EmbperlXSLT -> get_recipe ($r, $recipe) ;
        }
    
    if ($src eq 'epd')
        {
        $config -> escmode(0) ;
        $config -> options($config -> options | &Embperl::Constant::optKeepSpaces) ;

        if ($dest eq 'pod')
            {
            $config -> syntax('EmbperlBlocks') ;
            return Embperl::Recipe::Embperl -> get_recipe ($r, $recipe) ;
            }


        $config -> xsltstylesheet('pod.xsl') ;
        $r -> param -> uri =~ /^.*\/(.*)(\..*?)$/ ;
        my $fdat = $r -> thread -> form_hash ;
        $fdat->{page} ||= 0 ;
        $fdat->{basename} = "'$1'" ;
        $fdat->{extension} = "'$2'" ;
        return Embperl::Recipe::EmbperlPODXSLT -> get_recipe ($r, $recipe) ;
        }
    
    if ($src eq 'epl' || $src eq 'htm')
        {
        $config -> syntax('Embperl') ;
        return Embperl::Recipe::Embperl -> get_recipe ($r, $recipe) ;
        }

    $config -> syntax('Text') ;
    return Embperl::Recipe::Embperl -> get_recipe ($r, $recipe) ;
    }
