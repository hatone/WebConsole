#!/usr/bin/perl
# WC::Users - Web Console 'Users' module, contains methods for Users management
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_PRE_OK

package WC::Users;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Users::DATA = {
	'DYNAMIC' => {
		'LOADED_DB' => {}
	}
};

# 'NL::Error' for error storage support
sub _error_reset { &NL::Error::reset(__PACKAGE__); }
sub _error_set { &NL::Error::set(__PACKAGE__, @_); }
sub get_last_error { &NL::Error::get(__PACKAGE__); }
sub get_last_error_ARR { &NL::Error::get_ARR(__PACKAGE__); }
sub get_last_error_ID { &NL::Error::get_id(__PACKAGE__); }
sub get_last_error_TEXT { &NL::Error::get_text(__PACKAGE__); }
sub get_last_error_INFO { &NL::Error::get_info(__PACKAGE__); }

# Checking is Web Console installed (is Users DB exists)
# IN: NOTHING
# RETURN: 1 - installed | 0 - not installed | -1 - users config filename is not defined
sub IS_WEB_CONSOLE_INSTALLED {
	if (defined $WC::c->{'config'}->{'files'}->{'users'} && $WC::c->{'config'}->{'files'}->{'users'} ne '') {
		return &WC::Config::is_exists($WC::c->{'config'}->{'files'}->{'users'});
	}
	else { return -1; }
}
# Initialization of 'WC::Users', called always first
# That method can be replaced by plugin if we need new type of initializaton
# By default it's == 'LOADING USERS DB FROM FILE'
# IN: NOTHING
# RETURN:
#	 0 - error, not found (that should be returned if we can't find object (file, DB, ...) that contains users information)
#	 1 - ok, initialized (loaded)
#	-1 - other error, see 'get_last_error()'
sub init  {
	&_error_reset();
	if (!defined $WC::c->{'config'}->{'files'}->{'users'} || $WC::c->{'config'}->{'files'}->{'users'} eq '') {
		&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' Users DB file name is not defined', 'Looks very strange, are you shure that '.$WC::c->{'APP_SETTINGS'}->{'name'}.' has not been modified?');
		return -1;
	}

	my $result = &WC::Config::load($WC::c->{'config'}->{'files'}->{'users'}, '$WC::Config::FILE::USERS_DB', $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'});
	if ($result != 1) {
		&_error_set("Unable to load Users DB file '".$WC::c->{'config'}->{'files'}->{'users'}."'", &WC::Config::get_last_error_TEXT(), &WC::Config::get_last_error_ID());
		if ($result == 0) { return 0; }
		else { return -1; }
	}
	else { return 1; }
}
# Getting users list
# IN: NOTHING
# RETURN: HASH_REF - Users HASH
sub get_users_list {
	if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'} && defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}) {
		return $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'};
	}
	else { return {}; }
}
# Getting groups list
# IN: NOTHING
# RETURN: HASH_REF - Groups HASH
sub get_groups_list {
	if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'} && defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'groups'}) {
		return $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'groups'};
	}
	else { return {}; }
}
# Saving users information to file
# IN: HASH_REF - HASH with users DATA
# RETURN:
#	 0 - not created, see 'get_last_error()'
#	 1 - ok, created
sub save_file {
	&_error_reset();
	my ($in_HASH_DATA) = @_;

	if (!defined $in_HASH_DATA) { &_error_set('WC::Users::save_file(): Incorrect call, parameter is needed'); }
	elsif (!defined $WC::c->{'config'}->{'files'}->{'users'}) { &_error_set("WC::Users::save_file(): Users DB file is not defined"); }
	else {
		if (&WC::Config::save($WC::c->{'config'}->{'files'}->{'users'}, $in_HASH_DATA, '$WC::Config::FILE::USERS_DB', 'USERS DB') == 1) { return 1; }
		else { &_error_set(&WC::Config::get_last_error_TEXT()); }
	}
	return 0;
}
# User creation
# IN: HASH_REF - HASH with user DATA
# RETURN:
#	 0 - not created, see 'get_last_error()'
#	 1 - ok, created
sub create {
	&_error_reset();
	my ($in_HASH_DATA) = @_;

	if (!defined $in_HASH_DATA) { &_error_set('WC::Users::create(): Incorrect call, parameter is needed'); }
	else {
		my $check_PARAMETERS = {
			'login' => { 'name' => 'Login', 'needed' => 1, 'can_be_empty' => 0 },
			'password' => { 'name' => 'Password', 'needed' => 1, 'can_be_empty' => 0 },
			'e-mail' => { 'name' => 'E-mail', 'needed' => 1,, 'can_be_empty' => 0, 'func_CHECK' => \&NL::Parameter::FUNC_CHECK_email }
		};
		my $check_RESULT = &NL::Parameter::check($in_HASH_DATA, $check_PARAMETERS);
		if (!$check_RESULT->{'ID'}) { &_error_set($check_RESULT->{'ERROR_MESSAGE'}); }
		else {
			if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'} && defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}) {
				if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $in_HASH_DATA->{'login'} }) {
					&_error_set("User with that login ('".$in_HASH_DATA->{'login'}."') is already registred");
				}
				else {
					my $user_login = $in_HASH_DATA->{'login'};
					delete $in_HASH_DATA->{'login'};
					$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $user_login } = $in_HASH_DATA;
					if (&save_file($WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}) == 1) { return 1; }
					else { &_error_set(&get_last_error_TEXT()); }
				}
			}
			else { &_error_set('ERROR: Users DB is not loaded'); }
		}
	}
	return 0;
}
# User removing
# IN: STRING - user login
# RETURN:
#	 0 - not removed, see 'get_last_error()'
#	 1 - ok, removed
sub remove {
	&_error_reset();
	my ($in_login) = @_;

	if (!defined $in_login) { &_error_set('WC::Users::remove(): Incorrect call, parameter 1 is needed'); }
	else {
		if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'} && defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}) {
			if (!defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $in_login }) {
				&_error_set("User ('$in_login') is not registred");
			}
			else {
				delete $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $in_login };
				if (&save_file($WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}) == 1) { return 1; }
				else { &_error_set(&get_last_error_TEXT()); }
			}
		}
		else { &_error_set('ERROR: Users DB is not loaded'); }
	}
	return 0;
}
# User modification
# IN: STRING - user login, HASH_REF - HASH with user new DATA
# RETURN:
#	 0 - not modifyed, see 'get_last_error()'
#	 1 - ok, modifyed
sub modify {
	&_error_reset();
	my ($in_login, $in_HASH_DATA) = @_;

	if (!defined $in_login) { &_error_set('WC::Users::create(): Incorrect call, parameter 1 is needed'); }
	if (!defined $in_HASH_DATA) { &_error_set('WC::Users::create(): Incorrect call, parameter 2 is needed'); }
	else {
		my $check_PARAMETERS = {
			'login' => { 'name' => 'Login', 'needed' => 0, 'can_be_empty' => 0 },
			'password' => { 'name' => 'Password', 'needed' => 0, 'can_be_empty' => 0 },
			'e-mail' => { 'name' => 'E-mail', 'needed' => 0, , 'can_be_empty' => 0, 'func_CHECK' => \&NL::Parameter::FUNC_CHECK_email }
		};
		my $check_RESULT = &NL::Parameter::check($in_HASH_DATA, $check_PARAMETERS);
		if (!$check_RESULT->{'ID'}) { &_error_set($check_RESULT->{'ERROR_MESSAGE'}); }
		else {
			if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'} && defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}) {
				if (!defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $in_login }) {
					&_error_set("User ('$in_login') is not registred");
				}
				else {
					my $user_login = $in_login;
					if (defined $in_HASH_DATA->{'login'}) {
						# User renamed
						if ($in_HASH_DATA->{'login'} ne $in_login) {
							if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $in_HASH_DATA->{'login'} }) {
								&_error_set("User with login ('".$in_HASH_DATA->{'login'}."') is already registred, if you need to set that login for user - please remove existing user with same login before");
								return 0;
							}
							else {
								$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $in_HASH_DATA->{'login'} } = $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $in_login };
								delete $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $in_login };
								$user_login = $in_HASH_DATA->{'login'};
							}
						}
						delete $in_HASH_DATA->{'login'};
					}
					if (!defined $in_HASH_DATA->{'password'}) {
						if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $user_login }->{'password'}) {
							$in_HASH_DATA->{'password'} = $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $user_login }->{'password'};
						}
					}
					$WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{ $user_login } = $in_HASH_DATA;
					if (&save_file($WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}) == 1) { return 1; }
					else { &_error_set(&get_last_error_TEXT()); }
				}
			}
			else { &_error_set('ERROR: Users DB is not loaded'); }
		}
	}
	return 0;
}
# User authentication
# IN: STRING - type of response ('HTML' or 'AJAX')
# RETURN:
#	 0 - not authenticated (needed message is already printed to user)
#	 1 - ok, authenticated
sub authenticate {
	&_error_reset();
	my ($response_TYPE) = @_;
	$response_TYPE = $WC::c->{'response'}->{'type'} if (!defined $response_TYPE);

	if (defined $WC::c->{'req'}->{'params'}->{'user_login'} && $WC::c->{'req'}->{'params'}->{'user_login'} ne '' &&
	    defined $WC::c->{'req'}->{'params'}->{'user_password'} && $WC::c->{'req'}->{'params'}->{'user_password'} ne '') {
	    	my $result_AUTH = 0;
	    	if ($WC::DEMO) { # NL_CODE: RM_BLOCK [DEMO_MODE]
			# login: 'demo', password: 'demo'
			if ($WC::c->{'req'}->{'params'}->{'user_login'} eq 'demo' && $WC::c->{'req'}->{'params'}->{'user_password'} eq '89e495e7941cf9e40e6980d14a16bf023ccd4c91') {
				$result_AUTH = 1;
			}
			else { $result_AUTH = 0; }
		}
		else { # NL_CODE: / RM_BLOCK [DEMO_MODE]
			$result_AUTH = &_authenticate_LP($WC::c->{'req'}->{'params'}->{'user_login'}, $WC::c->{'req'}->{'params'}->{'user_password'});
		} # NL_CODE: RM_LINE [DEMO_MODE]
		if ($result_AUTH == 1) { return 1; }
		if ($result_AUTH == 0) {
			if ($response_TYPE eq 'HTML') {
				my $stash = {
					'user_login' => &NL::String::str_HTML_value($WC::c->{'req'}->{'params'}->{'user_login'}),
					'main_info' => '<div class="logon-INCORRECT">Incorrect login/password</div><div class="logon-TODO">Please try again</div>'
				};
				$stash->{'main_info'} =~ s/(try again)/$1 (DEMO ACCESS: demo\/demo)/ if ($WC::DEMO); # NL_CODE: RM_LINE [DEMO_MODE]
				&WC::Response::show_HTML_PAGE('html_logon', $stash);
			}
			elsif ($response_TYPE eq 'AJAX') { &WC::CORE::die_info_AJAX('Incorrect login/password', 'Entered login/password is incorrect, are you hacker?'); }
		}
		else {
			my @arr_ERROR = ('Unable to authenticate', &WC::Users::get_last_error_TEXT(), &WC::Users::get_last_error_ID());
			if ($response_TYPE eq 'HTML') { &WC::CORE::die_info_HTML(@arr_ERROR); }
			elsif ($response_TYPE eq 'AJAX') { &WC::CORE::die_info_AJAX(@arr_ERROR); }
		}
	}
	else {
		my @arr_ERROR = ('Login or password is not defined', 'That is incorrect '.$WC::c->{'APP_SETTINGS'}->{'name'}.' call, are you hacker?', 'WC_USERS_AUTHENTICATE_NO_LOGIN_OR_PASSWORD');
		if ($response_TYPE eq 'HTML') { &WC::CORE::die_info_HTML(@arr_ERROR); }
		elsif ($response_TYPE eq 'AJAX') { &WC::CORE::die_info_AJAX(@arr_ERROR); }
	}
	return 0;
}
# User authentication (internal)
# IN: STRING - login, STRING - password
# RETURN:
#	 0 - incorrect login/password
#	 1 - ok, authenticated
#	-1 - error, see 'get_last_error()'
sub _authenticate_LP {
	&_error_reset();
	my ($in_login, $in_password) = @_;

	my $return_code = 1;
	if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'} && defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}) {
		if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login}) {
			if (defined $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login}->{'password'}) {
				if ($WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login}->{'password'} eq $in_password) {
					$WC::c->{'user'} = $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'}->{'users'}->{$in_login};
					$return_code = 1;
				}
				else {
					&_error_set('Incorrect password');
					$return_code = 0;
				}
			}
			else {
				&_error_set("User don't have password at Users DB");
				$return_code = 0;
			}
		}
		else {
			&_error_set('Incorrect login');
			$return_code = 0;
		}
		# Do not removing 'LOADED_DB' - we will use it if we need update 'Users DB' file
		# $WC::Users::DATA->{'DYNAMIC'}->{'LOADED_DB'} = {};
	}
	else  {
		&_error_set('Users DB is not loaded', '', 'WC_USERS_AUTHENTICATE_DB_NOT_LOADED');
		$return_code = -1;
	}
	return $return_code;
}

1; #EOF
