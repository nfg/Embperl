
BEGIN { 
    use lib qw{ . } ;
    use ExtUtils::testlib ;
    use Cwd ;
    
    my $cwd       = $ENV{EMBPERL_SRC} ;
    my $i = 0 ;
    foreach (@INC)
        {
        $INC[$i] = "$cwd/$_" if (/^(\.\/)?blib/) ;
        $i++ ;
        }
   

    } ;

use Apache ;
use Apache::Registry ;
use Embperl ;
use Embperl::Object ;

require "$ENV{EMBPERL_SRC}/test/testapp.pl" ;

$cp = Embperl::Util::AddCompartment ('TEST') ;

$cp -> deny (':base_loop') ;
$testshare = "Shared Data" ;
$cp -> share ('$testshare') ;  



1 ;
