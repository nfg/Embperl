
use File::Basename ;

sub new
    {
    my ($self, $r) = @_ ;

    # The following two values must be changed to meet your local setup
    # Additionaly DBI and DBIx::Recordset must be installed
   
    $self -> {dbdsn}      = $^O eq 'MSWin32'?'dbi:ODBC:embperl':'dbi:mysql:embperl' ;
    $self -> {dbuser}     = 'www' ;
    $self -> {dbpassword} = undef ;

    # There is normaly no need to change anything below this line

    $self -> {basepath}  = '/eg/web/' ;
    $self -> {baseuri}   = $ENV{EMBPERL_BASEURI} || '/eg/web/' ;
    $self -> {basedepth} = $ENV{EMBPERL_BASEDEPTH} || 2 ;
    $self -> {imageuri}  = $ENV{EMBPERL_IMAGES} || '../images/' ;

    $self -> {supported_languages} = ['en', 'de'] ;
    
    # Embperl 2 source directory
    $self -> {root}      = $ENV{EMBPERL_SRC} . '/' ;
    
    # check if Embperl 1.3 is installed
    my $lib_1_3 = dirname ($INC{'Apache.pm'})  ;
    if (-e ($lib_1_3 . '/HTML/Embperl.pod'))
        {
        $self -> {lib_1_3}     = $lib_1_3 ;
        }
    else
        {
        $self -> {lib_1_3}     = '' ;
        }

    # check if DBIx::Recordset is installed
    my $lib_dbix = $lib_1_3  ;
    if (-e ($lib_dbix . '/DBIx/Intrors.pod'))
        {
        $self -> {lib_dbix}     = $lib_dbix ;
        }
    elsif (-e (dirname($lib_dbix) . '/DBIx/Intrors.pod'))
        {
        $self -> {lib_dbix}     = dirname($lib_dbix) ;
        }
    else
        {
        $self -> {lib_dbix}     = '' ;
        }


    }




BEGIN 
    {
    %messages = (
        'de' =>
            {
            'Introduction'  => 'Einführung',
            'Documentation' => 'Dokumentation',
            'Examples'      => 'Beispiele',
            'Changes'       => 'Änderungen',
            'Sites using Embperl' => 'Sites mit Embperl',
            'Add info about Embperl' => 'Hinzufügen Infos',
            '1.3.4 documentation' => '1.3.4 Dokumentation',
            'Configuration'  => 'Konfiguration',
            }
        ) ;

    @menu = (
        { menu => 'Home',                   uri => '',                          file => { en => 'eg/web/index.htm', de => 'eg/web/indexD.htm'} },
        { menu => 'Features',               uri => 'pod/Features.htm',          file => { en => 'Features.pod',     de => 'FeaturesD.pod' } },
        { menu => 'Introduction',           uri => 'pod/intro/', sub =>
            [
            { menu => 'Embperl',            uri => 'Intro.htm',                 file => { en => 'Intro.pod', 'de' => 'IntroD.pod'},
                  desc => { en => 'Introduction of Embperl basic capablitities', 
                            de => 'Einführung in die grundlegenden Möglichkeiten von Embperl' }},
            { menu => 'Embperl::Object',    uri => 'IntroEmbperlObject.htm',    file => 'IntroEmbperlObject.pod',
                  desc => { en => 'Introduction to object-oriented website creation with Embperl', 
                            de => 'Einführung in das objekt-orientierte Erstellen von Websites mit Embperl' }},
            { menu => 'DBIx::Recordset',   uri => 'IntroRecordset.htm',    path => '%lib_dbix%/DBIx/Intrors.pod',
                  desc => { en => 'Introduction to database access with DBIx::Recordset', 
                            de => 'Einführung in den Datenbankzugriff mit DBIx::Recordset' }},
            ]
        },
        { menu => 'Documentation',          uri => 'pod/doc/', sub => 
            [
                { menu => 'README.v2',            uri => 'README.v2',             file => { en => 'README.v2', de => 'README.v2'},
                  desc => { en => 'Contains differences to Embperl 1.3 and all docs for Embperl 2 that have not made it yet into the real docs',
                            de => 'Enthält die Unterschiede zu Embperl 1.3 und alle Dokumentation die noch nicht in eigentliche Dokumentation eingearbeitet wurde' }},
                { menu => 'Configuration',           uri => 'Config.htm',               file => { en => 'Config.pod', de => 'Config.pod'},
                  desc => { en => 'Configuration and calling of Embperl', 
                            de => 'Konfiguration und Aufruf von Embperl' }},
                { menu => 'Embperl',            uri => 'Embperl.htm',               file => { en => 'Embperl.pod', de => 'EmbperlD.pod'},
                  desc => { en => 'Main Embperl documentation', de => 'Hauptdokumentation' }},
                { menu => 'Embperl::Object',    uri => 'EmbperlObject.htm',         file => 'Embperl/Object.pm',
                  desc => { en => 'Documentation for creating object-oriented websites', 
                            de => 'Dokumentation zur Erstellung von Objekt-Orientierten Websites' }},
                { menu => 'Embperl::Form::Validate',  uri => 'EmbperlFormValidate.htm',         file => 'Embperl/Form/Validate.pm' ,
                  desc => { en => 'Documentation for easy form validation (client- and server-side)', 
                            de => 'Dokumentation zur einfachen Überprüfung von Formulareingaben (Client- und Serverseitig)' }},
                { menu => 'Embperl::Syntax',    uri => 'EmbperlSyntax.htm',         file => 'Embperl/Syntax.pm', 
                  desc => { en => 'Documentation about differnent syntaxes in Embperl and how to create your own syntax', 
                            de => 'Dokumentation über verschiedene Syntaxen von Embperl und wie man eingene Syntaxen erstellt' },
                  sub =>
                    [
                    { menu => 'Embperl',        uri => 'Embperl.htm',               file => 'Embperl/Syntax/Embperl.pm'},
                    { menu => 'EmbperlBlocks',  uri => 'EmbperlBlocks.htm',         file => 'Embperl/Syntax/EmbperlBlocks.pm'},
                    { menu => 'EmbperlHTML',    uri => 'EmbperlHTML.htm',           file => 'Embperl/Syntax/EmbperlHTML.pm'},
                    { menu => 'HTML',           uri => 'HTML.htm',                  file => 'Embperl/Syntax/HTML.pm'},
                    { menu => 'ASP',            uri => 'ASP.htm',                   file => 'Embperl/Syntax/ASP.pm'},
                    { menu => 'SSI',            uri => 'SSI.htm',                   file => 'Embperl/Syntax/SSI.pm'},
                    { menu => 'Perl',           uri => 'Perl.htm',                  file => 'Embperl/Syntax/Perl.pm'},
                    { menu => 'POD',            uri => 'POD.htm',                   file => 'Embperl/Syntax/POD.pm'},
                    { menu => 'Text',           uri => 'Text.htm',                  file => 'Embperl/Syntax/Text.pm'},
                    { menu => 'RTF',            uri => 'RTF.htm',                   file => 'Embperl/Syntax/RTF.pm'},
                    { menu => 'Mail',           uri => 'Mail.htm',                  file => 'Embperl/Syntax/Mail.pm'},
                    ],
                },
                { menu => 'Embperl::Recipe',    uri => 'EmbperlRecipe.htm',         file => 'Embperl/Recipe.pm', 
                  desc => { en => 'Documentation about recipes and providers', 
                            de => 'Dokumentation über recipes und provider' },
                  sub =>
                    [
                    { menu => 'Embperl',        uri => 'Embperl.htm',               file => 'Embperl/Recipe/Embperl.pm'},
                    { menu => 'EmbperlXSLT',    uri => 'EmbperlXSLT.htm',           file => 'Embperl/Recipe/EmbperlXSLT.pm'},
                    { menu => 'XSLT',           uri => 'XSLT.htm',                  file => 'Embperl/Recipe/XSLT.pm'},
                    ],
                },
#                { menu => 'Embperl::Constant',    uri => 'EmbperlConstant.htm',         file => 'Embperl/Constant.pm'},
#                { menu => 'Embperl::Log',    uri => 'EmbperlLog.htm',         file => 'Embperl/Log.pm'},
#                { menu => 'Embperl::Out',    uri => 'EmbperlOut.htm',         file => 'Embperl/Out.pm'},
#                { menu => 'Embperl::Run',    uri => 'EmbperlRun.htm',         file => 'Embperl/Run.pm'},
                { menu => 'Embperl::Mail',    uri => 'EmbperlMail.htm',         file => 'Embperl/Mail.pm',
                  desc => { en => 'Documentation on how to use Embperl for generating and sending mail', 
                            de => 'Dokumentation wie man Embperl benutzt um Mail zu erstellen und zu senden' }},
#                { menu => 'Embperl::Util',    uri => 'EmbperlUtil.htm',         file => 'Embperl/Util.pm'},
            { menu => '1.3.4 documentation',              uri => 'doc13.htm', 
              desc => { en => 'Old documentation from Embperl 1.3.4', 
                        de => 'Alte Dokumentation von Embperl 1.3.4' },
              sub => ,
                [
                { menu => 'HTML::Embperl',         uri => 'HTML/Embperl.htm',               path => { en => '%lib_1_3%/HTML/Embperl.pod', de => '%lib_1_3%/HTML/EmbperlD.pod'},
                  desc => { en => 'Main Embperl documentation: Configuration, Syntax, Usage etc.', 
                            de => 'Hauptdokumentation: Konfiguration, Syntax, Benutzung, etc.' },
                },
                { menu => 'HTML::EmbperlObject',   uri => 'HTML/EmbperlObject.htm',         path => '%lib_1_3%/HTML/EmbperlObject.pm',
                  desc => { en => 'Documentation for creating object-oriented websites', 
                            de => 'Dokumentation zur Erstellung von Objekt-Orientierten Websites' }},
                { menu => 'HTML::Embperl::Mail',   uri => 'HTML/Embperl/Mail.htm',          path => '%lib_1_3%/HTML/Embperl/Mail.pm' ,
                  desc => { en => 'Documentation on how to use Embperl for generating and sending mail', 
                            de => 'Dokumentation wie man Embperl benutzt um Mail zu erstellen und zu senden' }},
                { menu => 'HTML::Embperl::Session',uri => 'HTML/Embperl/Session.htm',       path => '%lib_1_3%/HTML/Embperl/Session.pm' ,
                  desc => { en => 'Documentation for Embperls session handling object', 
                            de => 'Dokumentation über Embperls Session Objekt' }},
                { menu => 'Tips & Tricks',         uri => 'HTML/Embperl/TipsAndTricks.htm', path => '%lib_1_3%/HTML/TipsAndTricks.pod' ,
                  desc => { en => 'Tips & Tricks for Embperl 1.3.4', 
                            de => 'Tips & Tricks für Embperl 1.3.4' }},

                { menu => 'FAQ',                    uri => 'pod/Faq.htm',               path => '%lib_1_3%/HTML/Faq.pod',
                  desc => { en => 'FAQ for Embperl 1.3.4', 
                            de => 'FAQ für Embperl 1.3.4' }},

                ],
            },
            ],
        },
        { menu => 'Installation',           uri => 'pod/INSTALL.htm',           file => 'INSTALL.pod' },
        #{ menu => 'FAQ',                    uri => 'pod/Faq.htm',               file => 'Faq.pod' },
        #{ menu => 'Examples',               uri => 'examples/' },
        { menu => 'Download',                uri => 'pod/doc/Embperl.-page-13-.htm#sect_44' },
        { menu => 'Support',                uri => 'pod/doc/Embperl.-page-12-.htm' },
        { menu => 'Changes',                 uri => 'pod/Changes.htm',           file => 'Changes.pod' },
        #{ menu => 'Sites using Embperl',    uri => 'pod/Sites.htm',             file => 'Sites.pod' },
        { menu => 'News',                    uri => 'db/news/news.htm',          file => 'eg/web/db/data.epd', fdat => { 'category_id' => 1 } },
        { menu => 'Sites using Embperl',     uri => 'db/sites/sites.htm',        file => 'eg/web/db/data.epd', fdat => { 'category_id' => 2 } },
        { menu => 'Add info about Embperl',  uri => 'db/addsel.epl', same => 
            [
            { menu => 'Enter info to add about Embperl',    uri => 'db/add.epl' },
            { menu => 'Show info added about Embperl',      uri => 'db/show.epl'},
            { menu => 'Add info about Embperl',             uri => 'db/data.epd' },
            ],
        },
        ) ;


    } ;



      

sub get_menu 
    { 
    my ($self, $r) = @_ ;

    push @{$r -> messages}, $messages{$r -> param -> language} ;

    return \@menu ; 
    } 


