
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
            }
        ) ;

    @menu = (
        { menu => 'Home',                   uri => '',                          file => { en => 'eg/web/index.htm', de => 'eg/web/indexD.htm'} },
        { menu => 'Features',               uri => 'pod/Features.htm',          file => 'Features.pod' },
        { menu => 'Introduction',           uri => 'pod/intro/', sub =>
            [
            { menu => 'Embperl',            uri => 'Intro.htm',                 file => { en => 'Intro.pod', 'de' => 'IntroD.pod'}},
            { menu => 'Embperl::Object',    uri => 'IntroEmbperlObject.htm',    file => 'IntroEmbperlObject.pod'},
            #{ menu => 'DBIx::Recordset',   uri => 'IntroEmbperlObject.htm',    file => 'IntroEmbperlObject.pod'},
            ]
        },
        { menu => 'Documentation',          uri => 'pod/doc/', sub => 
            [
            { menu => 'Embperl',            uri => 'Embperl.htm',               file => { en => 'Embperl.pod', de => 'EmbperlD.pod'}},
            { menu => 'Embperl::Object',    uri => 'EmbperlObject.htm',         file => 'Embperl/Object.pm'},
            { menu => 'Embperl::Form::Validate',  uri => 'EmbperlFormValidate.htm',         file => 'Embperl/Form/Validate.pm' },
            { menu => 'Embperl::Syntax',    uri => 'EmbperlSyntax.htm',         file => 'Embperl/Syntax.pm', sub =>
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
            { menu => 'Embperl::Recipe',    uri => 'EmbperlRecipe.htm',         file => 'Embperl/Recipe.pm', sub =>
                [
                { menu => 'Embperl',        uri => 'Embperl.htm',               file => 'Embperl/Recipe/Embperl.pm'},
                { menu => 'EmbperlXSLT',    uri => 'EmbperlXSLT.htm',           file => 'Embperl/Recipe/EmbperlXSLT.pm'},
                { menu => 'XSLT',           uri => 'XSLT.htm',                  file => 'Embperl/Recipe/XSLT.pm'},
                ],
            },
            ],
        },
        { menu => 'Installation',           uri => 'pod/INSTALL.htm',           file => 'INSTALL.pod' },
        { menu => 'FAQ',                    uri => 'pod/Faq.htm',               file => 'Faq.pod' },
        { menu => 'Tips & Tricks',          uri => 'pod/TipsAndTricks.htm',     file => 'TipsAndTricks.pod' },
        { menu => 'Examples',               uri => 'examples/' },
        { menu => 'Changes',                uri => 'pod/Changes.htm',           file => 'Changes.pod' },
        #{ menu => 'Sites using Embperl',    uri => 'pod/Sites.htm',             file => 'Sites.pod' },
        { menu => 'News',                   uri => 'db/news/news.htm',          file => 'eg/web/db/data.epd', fdat => { 'category_id' => 1 } },
        { menu => 'Sites using Embperl',    uri => 'db/sites/sites.htm',        file => 'eg/web/db/data.epd', fdat => { 'category_id' => 2 } },
        { menu => 'Add info about Embperl',             uri => 'db/addsel.epl', same => 
            [
            { menu => 'Hinzufügen',             uri => 'db/add.epl' },
            { menu => 'Hinzufügen',             uri => 'db/show.epl'},
            { menu => 'Hinzufügen',             uri => 'db/data.epd' },
            ],
        },
        ) ;


    } ;



sub new
    {
    my ($self, $r) = @_ ;

    $r -> {imageuri}  = '/eg/images/' ;
    $r -> {baseuri}   = '/eg/web/' ;
    $r -> {root}      = $^O eq 'MSWin32'?'/perl/msrc/ep2a/':'/usr/msrc/ep2a/' ;
    $r -> {dbdsn}     = $^O eq 'MSWin32'?'dbi:ODBC:embperl':'dbi:mysql:embperl' ;
    $r -> {dbuser}    = 'www' ;
    }

      

sub get_menu 
    { 
    my ($self, $r) = @_ ;

    push @{$r -> messages}, $messages{$r -> param -> language} ;

    return \@menu ; 
    } 


