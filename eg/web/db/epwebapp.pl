

use DBIx::Recordset ;
use Data::Dumper ;
use Embperl::Mail ;
use File::Basename ;

BEGIN { Execute ({isa => '../epwebapp.pl', syntax => 'Perl'}) ;  }


sub init 
    {
    my $self     = shift ;
    my $r        = shift ;

    my $ret ;

    $r -> {error}   = $fdat{-error} ;
    $r -> {success} = $fdat{-success} ;

    $self -> SUPER::init ($r) ;

    $self -> initdb ($r) ;

    my $db = $r -> {db} ;

    $r->{warning} = [];

    $self -> checkuser ($r) ;

    $r -> {language_set} = DBIx::Recordset -> Search ({'!DataSource' => $db, 
                                                       '!Table' => 'language'}) ;

    
    if ($fdat{-add_category})
        {
        $self -> add_category($r) ;
        $self -> get_category($r) ;
        }
    elsif ($fdat{-add_item})
        {
        $self -> get_category($r) ;
        $ret = $self -> add_item($r) ;
        }
    elsif ($fdat{-update_item})
        {
        $self -> get_category($r) ;
        $ret = $self -> update_item ($r) ;
        }
    elsif ($fdat{-delete_item})
        {
        $self -> get_category($r) ;
        $ret = $self -> delete_item($r) ;
        }
    elsif ($fdat{-edit_item})
        {
        $self -> get_category($r) ;
        $self -> get_item_lang($r) ;
        $self -> setup_edit_item($r) ;
        }
    elsif ($fdat{-show_item})
        {
        $self -> get_category($r) ;
        $self -> get_item_lang($r) ;
        }
    elsif ($fdat{-update_user})
        {
        $self -> update_user($r) ;
	}
    else
        {
        $self -> get_category($r) ;
        $self -> get_item($r) ;
	#$self -> get_user($r);
        }


    #d# if ($r->param->uri =~ m|/user\.epl$|)
    #d#	{
    #	$self -> get_users($r) if $r->{user_admin};
    #	}

    return defined ($ret)?$ret:0 ;
    }


# ----------------------------------------------------------------------------

sub initdb
    {
    my $self     = shift ;
    my $r        = shift ;
    my $config   = $r -> {config} ;

    $DBIx::Recordset::Debug = 1 ;
    #*DBIx::Recordset::LOG = \*STDERR ;
    my $db = DBIx::Database -> new ({'!DataSource' => $config -> {dbdsn},
                                     '!Username'   => $config -> {dbuser},
                                     '!Password'   => $config -> {dbpassword},
                                     '!DBIAttr'    => { RaiseError => 1, PrintError => 1, LongReadLen => 32765, LongTruncOk => 0, },
                                     
                                     }) ;

    $db -> TableAttr ('*', '!SeqClass', "DBIx::Recordset::FileSeq,$config->{root}/db") if ($^O eq 'MSWin32') ;
    $db -> TableAttr ('*', '!Filter', 
        {
        'creationtime'  => [\&current_time, undef, DBIx::Recordset::rqINSERT  ],
        'modtime'       => [\&current_time, undef, DBIx::Recordset::rqINSERT + DBIx::Recordset::rqUPDATE ],
        }) ;

    $r -> {db} = $db ;
   
    if ($config->{always_need_login} && ($self -> checkuser($r) < 1))
        {
        $r -> {need_login} = 1 ;
        return ;
	}
    }

# ----------------------------------------------------------------------------

sub current_time

    {
    return $_[0] if ($_[0]) ;

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                             localtime(time);

    $mon++ ;
    $year += 1900 ;
    return "$year-$mon-$mday $hour:$min:$sec" ;
    }



# ----------------------------------------------------------------------------
#
# Get url for postings forms
#
# $dest = path relativ to current uri
#

sub posturl
    {
    my ($self, $dest) = @_ ;

    my $r = $self -> curr_req ;

    return $dest if (!$r -> {action_prefix}) ;


    my $buri = $r->{config}{baseuri} ;
    my $uri  = $r-> param -> uri ;
    my $path = ($uri =~ /$buri(.*?)$/)?$1:$uri ;
    my $lang = (@{$config -> {supported_languages}} > 1)?$r -> param -> language . '/':'' ;

    return $r -> {action_prefix} . $buri . $lang . $path if (!$dest) ;
    return $r -> {action_prefix} . $buri . $lang . dirname("/$path") .'/' . $dest ;
    }



# ----------------------------------------------------------------------------
#
# check if user is loged in, handle login/out and createing of new users
#
# allowed actions parameters:
#   -login
#   -logout
#   -newuser
#   -newpassword
# formfields expected:
#   user_email
#   user_password
#
# returns:
#   undef   not logged in
#   1       user logged in
#   2       admin logged in
#

sub checkuser_light
    {
    my $self     = shift ;
    my $r        = shift ;

    if ($udat{user_id} && $udat{user_email} && !$fdat{-logout})
        {
        $r -> {user_id}    = $udat{user_id} ;
        $r -> {user_email} = $udat{user_email} ;
        $r -> {user_admin} = $udat{user_admin} ;
        return $r -> {user_admin}?2:1 ;
        }
    return 0;
    }

sub checkuser
    {
    my $self     = shift ;
    my $r        = shift ;

    if ($udat{user_id} && $udat{user_email} && !$fdat{-logout})
        {
        $r -> {user_id}    = $udat{user_id} ;
        $r -> {user_email} = $udat{user_email} ;
        $r -> {user_admin} = $udat{user_admin} ;
        return $r -> {user_admin}?2:1 ;
        }

    if (($fdat{-login} || $fdat{-newuser} || $fdat{-newpassword}) 
	&& !$fdat{user_email})
        {
        $r -> {error} = 'err_email_needed' ;
        return ;
        }

    my $user ;

    if ($fdat{user_email})
        {
        $user = DBIx::Recordset -> Search ({'!DataSource' => $r -> {db}, 
                                              '!Table' => 'user', 
                                              'email'  => $fdat{user_email}}) ;
        }

    if ($fdat{-login} && $fdat{user_email})
        {
        if ($user -> {id} && $user -> {password} eq $fdat{user_password})
            {
            $r -> {user_id}    = $udat{user_id}    = $user -> {id} ;
            $r -> {user_email} = $udat{user_email} = $user -> {email} ;
            $r -> {user_admin} = $udat{user_admin} = $user -> {admin} ;
	    $r -> {success} = "suc_login";
            return $r -> {user_admin}?2:1 ;
            }
            
        $r -> {error} = 'err_access_denied' ;
        return ;
        }

    if ($fdat{-logout})
        {
        $r -> {user_id}    = $udat{user_id}    = undef ;
        $r -> {user_email} = $udat{user_email} = undef ;
        $r -> {user_admin} = $udat{user_admin} = undef ;
	$r -> {success} = 'suc_logout';
        return ;
        }
            
    if ($fdat{-newuser} && $user -> {id})
        {
	$r -> {error} = 'err_user_exists';
        return ;
        }

    if ($fdat{-newpassword} && !$user -> {id})
        {
        $r -> {error} = 'err_user_not_exists' ;
        return ;
        }

    my $user_password = '' ;
    if ($fdat{-newuser} || $fdat{-newpassword})
        {
        my $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-+$!#*=@1234567890-+$!#*=@' ;
        for (my $i = 0; $i < 6; $i++)
            {
            $user_password .= substr($chars, rand(length($chars)), 1) ;
            }
        }


    if ($fdat{-newuser} && $fdat{user_email})
        {
	my @errors_user = ();
	my @errors_admin = ();
        my $set = DBIx::Recordset -> Insert ({'!DataSource' => $r -> {db}, 
                                              '!Table'      => 'user', 
					      'password'    => $user_password,
                                              'email'       => $fdat{user_email}}) ;
	if (DBIx::Recordset -> LastError)
	    {
	    $r -> {error} = 'err_db';
	    $r -> {error_details} = DBIx::Recordset -> LastError;
	    }

        my $usermail = Embperl::Mail::Execute ({
	    inputfile => 'newuser.mail', 
	    from => $r->{config}->{emailfrom},
	    to => $fdat{user_email}, 
	    subject =>  $r->gettext('mail_subj_newuser'),
	    param => [$user_password],
	    errors => \@errors_user});
	if ($usermail) 
	    {
	    $r->{error} = 'err_user_mail';
	    $r->{error_details} = join("\n",@errors_user);
	    }
	else
	    {
	    $r->{success} = 'suc_password_sent';
	    }

        my $adminmail = Embperl::Mail::Execute ({
	    inputfile => 'newuser.admin.mail',  
	    from => $r->{config}->{emailfrom},
	    to => $r->{config}->{adminemail},
	    subject => ($r->{error} ? 
			"Error while creating new Embperl website user '$fdat{user_email}'" :
			"New Embperl website user: $fdat{user_email}"),
	    errors => \@errors_admin});

	if ($adminmail)
	    {
	    $r->{error} = 'err_user_admin_mail';
	    $r->{error_details} = join('; ',@errors_admin);
	    }

        return ;
        }

    if ($fdat{-newpassword} && $fdat{user_email})
        {
	my @errors_pw;
        my $set = DBIx::Recordset -> Update ({'!DataSource' => $r -> {db}, 
                                              '!Table'      => 'user', 
					      'password'    => $user_password,
                                              'email'       => $fdat{user_email}},
					     {'id'          => $user -> {id}}) ;

        my $newpw_mail = Embperl::Mail::Execute ({
	    inputfile => 'newpw.mail', 
	    from => $r->{config}->{emailfrom},
	    to => $fdat{user_email}, 
	    subject => $r->gettext('mail_subj_newpw'),
	    param => [$user_password],
	    errors => \@errors_pw});
	if ($newpw_mail) 
	    {
	    $r->{error} .= 'err_pw_mail';
	    $r->{error_details} .= join("\n",@errors_pw);
	    }
	else
	    {
	    $r->{success} = 'suc_password_sent';
	    }

        return ;
        }
    
    return ;
    }

# ----------------------------------------------------------------------------

###
### Not yet working with new db-scheme
###

sub add_category
    {
    my $self     = shift ;
    my $r        = shift ;

    if ($self -> checkuser($r) < 2)
        {
        $r -> {need_login} = 1 ;
        return ;
        }
    
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

    if ($self -> checkuser($r) < $r->{category_set}{edit_level})
        {
        $r -> {need_login} = 1 ;
        return ;
        }

    # Check the URL

    my $tt = $r->{category_set}{table_type};
    my $cf = $r->{category_fields};

    foreach (@$cf)
    {
	next unless $r->{category_types}{$_} =~ /url/;
	
	if ($fdat{$_} && $fdat{$_} =~ /\s/)
        {
	    $fdat{$_} =~ s/\s//g;
	    push(@{$r->{warning}}, 'warn_url_removed_white_space');
        }

	if ($fdat{$_} && $fdat{$_} !~ m{http://})
        {
	    $fdat{$_} =~ s{^}{http://};
	    push(@{$r->{warning}}, 'warn_url_added_http');
        }

    }

    my $set = DBIx::Recordset -> Insert ({'!DataSource' => $r -> {db}, 
                                          '!Table'      => $tt,
                                          '!Serial'     => 'id',
                                           url          => $fdat{url},
				           $fdat{modtime} ? (modtime  => $fdat{modtime}) : (),
                                           category_id  => $fdat{category_id},
                                           user_id      => $r -> {user_id},
                                           state        => $r ->{user_admin} ? ($fdat{state}?1:0):0}) ;

    my $id = $$set -> LastSerial ;
    my $langset = $r -> {language_set} ;
    my $txtset = DBIx::Recordset -> Setup ({'!DataSource' => $r -> {db}, 
                                            '!Table'      => "${tt}text"}) ;
    
    $$langset -> Reset ;
    while ($rec = $$langset -> Next)
        {
	# Check the URL
	
	my $lang = $rec->{id};

	foreach (@$cf)
	{
	    next unless $r->{category_types}{$_.'_'.$lang} =~ /url/;
	    
	    if ($fdat{$_.'_'.$lang} && $fdat{$_.'_'.$lang} =~ /\s/)
	    {
		$fdat{$_.'_'.$lang} =~ s/\s//g;
		push(@{$r->{warning}}, 'warn_url_removed_white_space');
	    }
	    
	    if ($fdat{$_.'_'.$lang} && $fdat{$_.'_'.$lang} !~ m{http://})
	    {
		$fdat{$_.'_'.$lang} =~ s{^}{http://};
		push(@{$r->{warning}}, 'warn_url_added_http');
	    }
	    
	}

        $$txtset -> Insert ({ (map { $_ => $fdat{$_.'_'.$lang} || $fdat{$_} } @$cf),
			      "${tt}_id"  => $id,
                              language_id => $lang })
	    if (grep { $fdat{$_.'_'.$lang} || $fdat{$_} } @$cf) ;
        }

    $fdat{"${tt}_id"} = $id ;

    $r->{item_set} = undef ;
    $self->get_item_lang($r);

    if (!$udat{user_admin}) 
        {
	my @errors;
	my $newitemmail = Embperl::Mail::Execute ({
	    inputfile => 'updateditem.mail', 
	    from => $r->{config}->{emailfrom},
	    to => $r->{config}->{adminemail},
	    subject => 'New item on Embperl Website (Category '.$r->{category_set}{category}.')'.($udat{user_email}?" by $udat{user_email}":''),
	    errors => \@errors});
	if ($newitemmail)
            {
	    $r->{error} = 'err_item_admin_mail';
	    $r->{error_details} = join("\n",@errors);
	    
	    return;
            }
        }

    $r->{success} = 'suc_item_created';

    return $self -> redir_to_show ($r) ;
    }

# ----------------------------------------------------------------------------

sub update_item
    {
    my $self     = shift ;
    my $r        = shift ;

    if ($self -> checkuser($r) < $r->{category_set}{edit_level})
        {
        $r -> {need_login} = 1 ;
        return ;
        }

    my $tt = $r->{category_set}{table_type};
    my $cf = $r->{category_fields};

    # make sure we have an id
    if (!$fdat{"${tt}_id"})
        {
	$r -> {error} = 'err_cannot_update_no_id';
        return ;
        }

    my $set = DBIx::Recordset -> Setup  ({'!DataSource' => $r -> {db}, 
                                          '!Table'      => $tt }) ;

    # update the entry, but only if it has the correct user id or the has admin rights
    my $rows = $$set -> Update ({ url => $fdat{url},
				  $fdat{modtime} ? (modtime  => $fdat{modtime}) : (),
				  $fdat{category_id} ? (category_id  => $fdat{category_id}) : (),
				  $r->{user_admin}   ? (state        => $fdat{state})       : () },
				{ id => $fdat{"${tt}_id"},
				  $r ->{user_admin} ? () : (user_id => $r->{user_id}) }) ;
    
    if ($rows <= 0)
        { # error if nothing was found (this will happen when the record isdn't owned by the user)
        $r -> {error} = 'err_cannot_update_maybe_wrong_user' ; 
        return ;
        }

    my $id = $fdat{"${tt}_id"} ;
    my $langset = $r -> {language_set} ;
    my $txtset = DBIx::Recordset -> Setup ({'!DataSource' => $r -> {db}, 
                                            '!Table'      => "${tt}text"}) ;

    if (DBIx::Recordset->LastError)
        {
	$r -> {error} = 'err_update_db' ; 
	return ;
        }

    # Update the texts for every languange, but only if they belong to
    # the item we have updated above

    $$langset -> Reset ;
    while ($rec = $$langset -> Next)
        {
	my $lang = $rec->{id};
        if (grep { $fdat{$_.'_'.$lang} || $fdat{$_} } @$cf)
            {
            $rows = $$txtset -> Update ({ (map { $_ => $fdat{$_.'_'.$lang} || $fdat{$_} } @$cf),
			          language_id => $lang,
			      }, {
			          "${tt}_id" => $id, 
			          id         => $fdat{"id_$lang"}
			      }) ;

	    if (DBIx::Recordset->LastError)
	        {
	        $r -> {error} = 'err_update_lang_db' ; 
	        return ;
	        }
            elsif ($rows == 0)
                {
                $$txtset -> Insert ({ (map { $_ => $fdat{$_.'_'.$lang} || $fdat{$_} } @$cf),
			          language_id   => $lang,
			          "${tt}_id"    => $id, 
			      }) ;

	        if (DBIx::Recordset->LastError)
	            {
	            $r -> {error} = 'err_update_lang_db' ; 
	            return ;
	            }
                }
            }
        }

    $r -> {item_set} = undef ;
    $self->get_item_lang($r) ;

    if (!$udat{user_admin}) 
        {
	my @errors;
	$r->{is_update} = 1;
	my $newitemmail = Embperl::Mail::Execute ({
	    inputfile => 'updateditem.mail', 
	    from => $r->{config}->{emailfrom},
	    to => $r->{config}->{adminemail},
	    subject => 'Updated item on Embperl Website (Category '.$r->{category_set}{category}.')'.($udat{user_email}?" by $udat{user_email}":''),
	    errors => \@errors});
	if ($newitemmail)
            {
	    $r->{error} = 'err_item_admin_mail';
	    $r->{error_details} = join('; ',@errors);
	    
	    return;
            }
        }

    $r->{success} = 'suc_item_updated' ;

    return $self -> redir_to_show ($r) ;
    }


# ----------------------------------------------------------------------------

sub delete_item
    {
    my $self     = shift ;
    my $r        = shift ;

    if (!$self -> checkuser($r))
        {
        $r -> {need_login} = 1 ;
        return ;
        }

    my $tt = $r->{category_set}{table_type};
    my $cf = $r->{category_fields};

    # make sure we have an id
    if (!$fdat{"${tt}_id"})
        {
        $r -> {error} = 'err_cannot_delete_no_id' ; 
        return ;
        }

    # first see if the entry exists and has the correct user_id
    my $set = DBIx::Recordset -> Search  ({'!DataSource' => $r->{db}, 
					   '!Table'      => $tt,
					   id            => $fdat{"${tt}_id"},
					   $r->{user_admin} ? () : (user_id => $r->{user_id}) }) ;

    if (!$$set -> MoreRecords())
        { # error if nothing was found (this will happen when the record isdn't owned by the user
        $r -> {error} = 'err_cannot_delete_maybe_wrong_user_or_no_such_item' ; 
        return ;
        }

    # delete the entry, but only if it has the correct user id or the has admin rights
    $$set -> Delete ({id => $fdat{"${tt}_id"},
		      $r ->{user_admin}?():(user_id => $r->{user_id})}) ;

    if (DBIx::Recordset->LastError)
        {
	$r->{error} = 'err_cannot_delete_db_error';
	$r->{error_details} = DBIx::Recordset->LastError;
	return;
        }

    my $id = $fdat{"${tt}_id"} ;
    my $langset = $r -> {language_set} ;
    my $txtset = DBIx::Recordset -> Setup ({'!DataSource' => $r -> {db}, 
                                            '!Table'      => "${tt}text"}) ;
    
    # Delete the texts for every languange, but only if they belong to the item we have delete above
    $$langset -> Reset ;
    while ($rec = $$langset -> Next)
        {
        $$txtset -> Delete ({ "${tt}_id" => $id, 
			      id         => $fdat{"id_$rec->{id}"}}) ;
                             
	if (DBIx::Recordset->LastError)
            {
	    $r->{error} = 'err_cannot_delete_db_error';
	    $r->{error_details} = DBIx::Recordset->LastError;
	    return;
            }
        }

    if (!$udat{user_admin}) 
        {
	my @errors;
	$r->{is_update} = -1;
	my $newitemmail = Embperl::Mail::Execute ({
	    inputfile   => 'updateditem.mail', 
	    from        => $r->{config}->{emailfrom},
	    to          => $r->{config}->{adminemail},
	    subject     => 'Delete item on Embperl Website (Category '.$r->{category_set}{category}.')'.($udat{user_email}?" by $udat{user_email}":''),
	    errors      => \@errors});
	if ($newitemmail)
            {
	    $r->{error} = 'err_item_admin_mail';
	    $r->{error_details} = join('; ',@errors);
	    
	    return;
            }
        }

    $r->{success} = 'suc_item_deleted' ;

    return $self -> redir_to_show ($r) ;
    }


# ----------------------------------------------------------------------------

sub redir_to_show 
    {
    my $self     = shift ;
    my $r        = shift ;
    
    my $tt = $r->{category_set}{table_type};

    my %params =
        (
        -show_item  => 1,
        $fdat{category_id} ? (category_id => $fdat{category_id}) : (),
        $fdat{"${tt}_id"}  ? ("${tt}_id"  => $fdat{"${tt}_id"})  : (),
        $r -> {error}   ? (-error      => $r -> {error})   : (),
        $r -> {success} ? (-success    => $r -> {success}) : (),
        ) ;

    my $dest = join ('&', map { $_ . '=' . $r -> Escape (ref ($params{$_})?join("\t", @{$params{$_}}):$params{$_} , 2) } keys %params) ;

    #$http_headers_out{'location'} = "show.epl?$dest";
    Apache -> request -> err_header_out('location', $r -> param -> server_addr . dirname ($r -> param -> uri) ."/show.epl?$dest") ;
    #Apache -> request -> err_header_out('location', 'http://www.ecos.de:8766' . dirname ($r -> param -> uri) ."/show.epl?$dest") ;
    
    return 302 ;
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
                                                       $fdat{category_id}?(category_id => $fdat{category_id}):(),
                                                       $r -> {user_admin}?():(state => 1)}) ;

    *fields = DBIx::Recordset -> Search ({'!DataSource' => $r -> {db}, 
					  '!Table' => 'category, categoryfields', 
					  '!TabRelation' => 'category_id = category.id',
					  'language_id'  => $r -> param -> language,
					  $fdat{category_id}?(category_id => $fdat{category_id}):(),
					  $r -> {user_admin}?():(state => 1),
				          '$order' => 'position' }) ;

    my %texts = ();
    my %types = ();
#    my %position = ();
    my @textfields = ();

    while (my $field = $fields->Next)
    {
	push(@textfields, $field->{fieldname});
	$texts{$field->{fieldname}.'_text'} = $field->{txt};
	$types{$field->{fieldname}} = $field->{typeinfo};
#	$position{$field->{fieldname}} = $field->{position};
    }

    $r -> {category_fields} = \@textfields;
    $r -> {category_texts} = \%texts;
    $r -> {category_types} = \%types;
#    $r -> {category_position} = \%position;

    my $title_type = 'heading';
    foreach my $f (@textfields)
	{
	if ($types{$f} =~ /title/)
	    {
	    $title_type = $f;
	    last;
	    }
	}

    $r -> {category_title_type} = $title_type;

    }


# ----------------------------------------------------------------------------

sub get_item
    {
    my $self     = shift ;
    my $r        = shift ;
    my %state ;

    if (!$r -> {user_admin})
        {
        if ($r -> {user_id})
            {
            %state = ('$expr' => { '$conj' => 'or', state => 1, user_id => $r -> {user_id} } ) ;
            }
        else
            {
            %state = (state => 1) ;
            }
        }

    $tt = $r->{category_set}{table_type};

    $r -> {item_set} = DBIx::Recordset -> Search ({'!DataSource'  => $r->{db}, 
						   '!Table'       => "user, ${tt}, ${tt}text", 
						   '!TabRelation' => "${tt}_id = ${tt}.id and ${tt}.user_id = user.id",
						   'language_id'  => $r->param->language,
						   '!Order'       => 'modtime desc',
						   $fdat{category_id} ? (category_id => $fdat{category_id}) : (),
						   $fdat{"${tt}_id"}  ? ("${tt}_id"  => $fdat{"${tt}_id"})  : (), 
						   %state}) ;
    }


# ----------------------------------------------------------------------------

sub get_item_lang
    {
    my $self     = shift ;
    my $r        = shift ;

    my %state ;

    if (!$r -> {user_admin})
        {
        if ($r -> {user_id})
            {
            %state = ('$expr' => { '$conj' => 'or', state => 1, user_id => $r -> {user_id} } ) ;
            }
        else
            {
            %state = (state => 1) ;
            }
        }

    $tt = $r->{category_set}{table_type};

    $r -> {item_set} = DBIx::Recordset -> Search ({'!DataSource'  => $r->{db}, 
						   '!Table'       => "user, ${tt}, language, ${tt}text", # ${tt}text must be last to get it's id 
						   '!TabRelation' => "${tt}_id = ${tt}.id and language_id = language.id and ${tt}.user_id = user.id",
						   '!Order'       => 'modtime desc',
						   $fdat{category_id} ? (category_id => $fdat{category_id}) : (),
						   $fdat{"${tt}_id"}  ? ("${tt}_id"  => $fdat{"${tt}_id"})  : (),
						   %state}) ;
    
#    push(@{$r->{warning}}, 'get_item_lang =>', $tt, @{$r->{item_set}});
#    ${$r->{item_set}}->Reset;

    $r->{item_set} = undef unless ${$r->{item_set}}->MoreRecords;
    ${$r->{item_set}} -> Reset if ($r->{item_set}) ;
    
    }

# ----------------------------------------------------------------------------

sub setup_edit_item
    {
    my $self     = shift ;
    my $r        = shift ;

    if (!$self -> checkuser($r))
        {
        $r -> {need_login} = 1 ;
        return ;
        }

    my $set = $r -> {item_set} ;

    unless (defined $set)
        {
	$r->{error} = 'err_item_not_found_or_access_denied';

	return;
	}

    my $tt = $r->{category_set}{table_type};
    my $cf = $r->{category_fields};

    $fdat{"${tt}_id"} = $set->{"${tt}_id"} if $set->{"${tt}_id"};
    
    $$set -> Reset ;
    while ($rec = $$set -> Next)
        {
        my $lang = $rec -> {language_id} ;
        $fdat{'id_' . $lang} = $rec -> {id};
        foreach my $type (@$cf)
            {
            $fdat{$type . '_' . $lang} = $rec -> {$type} ;
            }
        }
    
    $$set -> Reset ;
    $r -> {edit} = 1 ;
    }


# ----------------------------------------------------------------------------

sub get_user
    {
    my $self     = shift ;
    my $r        = shift ;

    $fdat{user_id} = undef unless $r -> {user_admin};

    $r -> {user_set} = DBIx::Recordset -> Search ({'!DataSource'  => $r->{db}, 
						   '!Table'       => "user",
						   id => $fdat{user_id} || $udat{user_id}
						   }) ;
    $r->{user_set} = undef unless ${$r->{user_set}}->MoreRecords;
    }

# ----------------------------------------------------------------------------

sub get_users
    {
    my $self     = shift ;
    my $r        = shift ;

    if ($self -> checkuser_light($r) < 1)
        {
        $r -> {need_login} = 1 ;
        return ;
        }

    return unless $r -> {user_admin};

    $r -> {users} = DBIx::Recordset -> Search ({'!DataSource'  => $r->{db}, 
						   '!Table'       => "user" }) ;
    $r->{users} = undef unless ${$r->{users}}->MoreRecords;
    }


# ----------------------------------------------------------------------------

sub update_user
    {
    my $self     = shift ;
    my $r        = shift ;

    if ($self -> checkuser_light($r) < 1)
        {
        $r -> {need_login} = 1 ;
        return ;
        }

    unless (($fdat{user_id} == $udat{user_id}) or $r->{user_admin})
	{
	$r->{error} = 'err_cannot_update_wrong_user_xxx';
	return;
	}

    eval { *set = DBIx::Recordset -> Update ({'!DataSource'  => $r->{db}, 
					      '!Table'       => "user", 
					      'name' => $fdat{name},
					      'pid'  => $fdat{pid} },
					     { id => $fdat{user_id} || $udat{user_id}}) ; };


    if ($@ and $@ =~ 'Duplicate entry')
	{
	$r->{error} = 'err_pid_exists';
	return;
	}
    
    if (DBIx::Recordset->LastError)
	{
	$r->{error} = 'err_update_db';
	push(@{$r->{error_details}}, DBIx::Recordset->LastError
	     );
	}

    $r->{success} = 'suc_user_update';

    }

# ----------------------------------------------------------------------------
# Warning: This will not yet work as intended if there is more than
# one category using $table as category type!

sub get_title 
    {
    my ($self, $r, $col, $id) = @_;

    (my $table = $col) =~ s/_id$// or die "Can't strip '_id'";

    my $config = $r->{config};
    my $db = DBIx::Database -> new ({'!DataSource' => $config -> {dbdsn},
                                     '!Username'   => $config -> {dbuser},
                                     '!Password'   => $config -> {dbpassword},
                                     '!DBIAttr'    => { RaiseError => 1, PrintError => 1, LongReadLen => 32765, LongTruncOk => 0, }});


    # SQL can't handle such kind soft links, so we need two requests
    *fields = DBIx::Recordset -> Search ({'!DataSource'  => $db, 
					  '!Table'       => 'category, categoryfields', 
					  'table_type'   => $table,
					  'state'        => 1,
					  'typeinfo'     => 'title',
					  '*typeinfo'    => 'LIKE',
				          '$order'       => 'position' }) ;

    *set = DBIx::Recordset -> Search ({'!DataSource'  => $db, 
				       '!Table'       => $table.'text',
				       'language_id' => $r -> param -> language,
				       $table.'_id'   => $id }) ;

    return $set{$fields{fieldname}};
    }

# ----------------------------------------------------------------------------
# Warning: This will not yet work as intended if there is more than
# one category using $table as category type!

sub get_titles
    {
    my ($self, $r, $table) = @_;

#    *set = DBIx::Recordset -> Search ({'!DataSource'  => $r->{db}, 
#				       '!Fields'      => "id,$r->{category_title_type} as title",
#				       '!Table'       => $table, }) ;
#    print OUT Dumper $config;
#
#    return;

    my $config = $r->{config};
    my $db = DBIx::Database -> new ({'!DataSource' => $config -> {dbdsn},
                                     '!Username'   => $config -> {dbuser},
                                     '!Password'   => $config -> {dbpassword},
                                     '!DBIAttr'    => { RaiseError => 1, PrintError => 1, LongReadLen => 32765, LongTruncOk => 0, },
                                     }) ;

    # SQL can't handle such kind soft links, so we need two requests
    *fields = DBIx::Recordset -> Search ({'!DataSource'  => $db, 
					  '!Table'       => 'category, categoryfields', 
					  'table_type'   => $table,
					  'state'        => 1,
					  'typeinfo'     => 'title',
					  '*typeinfo'    => 'LIKE',
				          '$order'       => 'position' }) ;
    my $title_type = $fields{fieldname};
    #print OUT $title_type;

    *set = DBIx::Recordset -> Search ({'!DataSource' => $db,
				       '!Table'      => $table.'text',
				       'language_id' => $r -> param -> language,
				       '!Fields'     => $table."_id as id,$title_type as title",
				       }) ;

    return \@set;
    }

# ----------------------------------------------------------------------------

sub set_xslt_param
    {
    my ($class, $r, $config, $param) = @_ ;

    $class -> SUPER::set_xslt_param ($r, $config, $param) ;

    my $p = $param -> xsltparam ;
    $p -> {category_id} = $fdat{category_id} || 0 ;
    }


    
