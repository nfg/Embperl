

use DBIx::Recordset ;

BEGIN { Execute ({isa => '../epwebapp.pl', syntax => 'Perl'}) ;  }


sub init 
    {
    my $self     = shift ;
    my $r        = shift ;

    $self -> SUPER::init ($r) ;

    $self -> initdb ($r) ;

    my $db = $r -> {db} ;

    $r -> {language_set} = DBIx::Recordset -> Search ({'!DataSource' => $db, 
                                                       '!Table' => 'language'}) ;
    
    if ($fdat{-add_category})
        {
        $self -> add_category ($r) ;
        $self -> get_category($r) ;
        }
    elsif ($fdat{-add_item})
        {
        $self -> add_item ($r) ;
        $self -> get_category($r) ;
        $self -> get_item_lang($r) ;
        }
    elsif ($fdat{-show_item})
        {
        $self -> get_category($r) ;
        $self -> get_item_lang($r) ;
        }
    else
        {
        $self -> get_category($r) ;
        $self -> get_item($r) ;
        }

    return 0 ;
    }


# ----------------------------------------------------------------------------

sub initdb
    {
    my $self     = shift ;
    my $r        = shift ;


    $DBIx::Recordset::Debug = 2 ;
    *DBIx::Recordset::LOG = \*STDERR ;
    my $db = DBIx::Database -> new ({'!DataSource' => $r -> {dbdsn},
                                     '!Username'   => $r -> {dbuser},
                                     '!Password'   => $r -> {dbpassword},
                                     '!DBIAttr'    => { RaiseError => 1, PrintError => 1, LongReadLen => 32765, LongTruncOk => 0, },
                                     
                                     }) ;

    $db -> TableAttr ('*', '!SeqClass', "DBIx::Recordset::FileSeq,$r->{root}/db") if ($^O eq 'MSWin32') ;
    $db -> TableAttr ('*', '!Filter', 
        {
        'creationtime'  => [\&current_time, undef, DBIx::Recordset::rqINSERT  ],
        'modtime'       => [\&current_time, undef, DBIx::Recordset::rqINSERT + DBIx::Recordset::rqUPDATE ],
        }) ;

    $r -> {db} = $db ;
   
    }

# ----------------------------------------------------------------------------

sub current_time

    {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                             localtime(time);

    return "$year-$mon-$mday $hour:$min:$sec" ;
    }


# ----------------------------------------------------------------------------

sub add_category
    {
    my $self     = shift ;
    my $r        = shift ;

    my $set = DBIx::Recordset -> Insert ({'!DataSource' => $r -> {db}, 
                                          '!Table'      => 'category',
                                          '!Serial'     => 'id',
                                           state        => 0}) ;
    my $id = $$set -> LastSerial ;
    my $langset = $r -> {language_set} ;
    my $txtset = DBIx::Recordset -> Setup ({'!DataSource' => $r -> {db}, 
                                            '!Table'      => 'categorytext'}) ;
    
    $$langset -> Reset ;
    while ($rec = $$langset -> Next)
        {
        $$txtset -> Insert ({category_id => $id,
                             language_id => $rec->{id},
                             category    => $fdat{"category_$rec->{id}"}}) if ($fdat{"category_$rec->{id}"}) ;
        delete $fdat{"category_$rec->{id}"} ;
        }
    }


# ----------------------------------------------------------------------------

sub add_item
    {
    my $self     = shift ;
    my $r        = shift ;

    my $set = DBIx::Recordset -> Insert ({'!DataSource' => $r -> {db}, 
                                          '!Table'      => 'item',
                                          '!Serial'     => 'id',
                                           url          => $fdat{url},
                                           category_id  => $fdat{category_id},
                                           state        => 0}) ;
    my $id = $$set -> LastSerial ;
    my $langset = $r -> {language_set} ;
    my $txtset = DBIx::Recordset -> Setup ({'!DataSource' => $r -> {db}, 
                                            '!Table'      => 'itemtext'}) ;
    
    $$langset -> Reset ;
    while ($rec = $$langset -> Next)
        {
        $$txtset -> Insert ({item_id => $id,
                             language_id => $rec->{id},
                             description => $fdat{"description_$rec->{id}"},
                             url         => $fdat{"url_$rec->{id}"} || $fdat{url},
                             heading     => $fdat{"heading_$rec->{id}"}}) if ($fdat{"heading_$rec->{id}"}) ;
        }

    $fdat{item_id} = $id ;
    }




# ----------------------------------------------------------------------------

sub get_category
    {
    my $self     = shift ;
    my $r        = shift ;

    $r -> {category_set} = DBIx::Recordset -> Search ({'!DataSource' => $r -> {db}, 
                                                       '!Table' => 'category, categorytext', 
                                                       '!TabRelation' => 'category_id = category.id',
                                                       'language_id'  => $r -> param -> language,
                                                       $fdat{category_id}?(category_id => $fdat{category_id}):()}) ;

    }


# ----------------------------------------------------------------------------

sub get_item
    {
    my $self     = shift ;
    my $r        = shift ;

    $r -> {item_set} = DBIx::Recordset -> Search ({'!DataSource' => $r -> {db}, 
                                                       '!Table' => 'item, itemtext', 
                                                       '!TabRelation' => 'item_id = item.id',
                                                       'language_id'  => $r -> param -> language,
                                                       $fdat{category_id}?(category_id => $fdat{category_id}):(),
                                                       $fdat{item_id}?(item_id => $fdat{item_id}):()}) ;
    }


# ----------------------------------------------------------------------------

sub get_item_lang
    {
    my $self     = shift ;
    my $r        = shift ;

    $r -> {item_set} = DBIx::Recordset -> Search ({'!DataSource' => $r -> {db}, 
                                                       '!Table' => 'item, itemtext, language', 
                                                       '!TabRelation' => 'item_id = item.id and language_id = language.id',
                                                       $fdat{category_id}?(category_id => $fdat{category_id}):(),
                                                       $fdat{item_id}?(item_id => $fdat{item_id}):()}) ;
    }