
BEGIN { 
    use lib qw{ . } ;
    use ExtUtils::testlib ;

    $ENV{MOD_PERL} =~ m#/(\d+)\.(\d+)# ;
    $mp2 = 1 if ($1 == 2 || ($1 == 1 && $2 >= 99)) ;
    
    if ($mp2 && $ENV{PERL5LIB}) 
        {
        $ENV{PERL5LIB} =~ /^(.*)$/ ;
        eval 'use lib split (/:/, $1) ;' ;
        }

    $ENV{EMBPERL_SRC} =~ /^(.*?)$/;
    my $cwd       = $1 ; # untaint
    my $i = 0 ;
    foreach (@INC)
        {
        $INC[$i] = "$cwd/$_" if (/^\.?\/?blib/) ;
        $INC[$i] =~ s#//#/#g ;
        $i++ ;
        }
   


    if (!$mp2)
        {
        require Apache ;
        require Apache::Registry ;
        }
    else
        {
	eval 'use Apache2' ;
        require ModPerl::Registry ;
        }
    } ;


use Embperl ;
use Embperl::Object ;

$ENV{EMBPERL_SRC} =~ /^(.*?)$/;
my $cwd       = $1 ;

require "$cwd/test/testapp.pl" ;

$cp = Embperl::Util::AddCompartment ('TEST') ;

$cp -> deny (':base_loop') ;
$testshare = "Shared Data" ;
$cp -> share ('$testshare') ;  


##Embperl::Execute ({ inputfile  => "$ENV{EMBPERL_SRC}/test/html/div.htm", import => 0, input_escmode => 7 }) ;


1 ;
