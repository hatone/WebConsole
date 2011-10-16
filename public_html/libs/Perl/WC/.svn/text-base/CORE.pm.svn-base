#!/usr/bin/perl
# WC::CORE - Web Console 'CORE' module
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::CORE;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Constant DATA
$WC::CONST = {
	'MOD_PERL_ON' => (defined $ENV{'MOD_PERL'}) ? 1 : 0,
	'APP_SETTINGS' => {
		'name' => 'Web Console'
	},
	'VERSION' => {
		'NUMBER' => '$WC_VERSION_NUMBER$', # 0.3 beta
		'DATE' => '$WC_VERSION_DATE$' # 2008.03.25
	},
	'DEBUG' => 0,
	'CHMODS' => {
		'CONFIGS' => '755',
		'.HTACCESS' => '644'
	},
	'URLS' => {
		'SITE' => 'http://www.web-console.org',
		'BUGS' => 'http://www.web-console.org/bugs/',
		'FEATURE_REQUESTS' => 'http://www.web-console.org/feature_requests/',
		'FAQ' => 'http://www.web-console.org/faq/',
		'FAQ_ID' => 'http://www.web-console.org/faq/#',
		'DOWNLOAD' => 'http://www.web-console.org/download/',
		'USAGE' => 'http://www.web-console.org/usage/',
		'FORUM' => 'http://forum.web-console.org',
		'ADDONS' => 'http://addons.web-console.org',
		'SERVICES' => 'http://services.web-console.org',
		'ABOUT_US' => 'http://www.web-console.org/about_us/'
	},
	'INTERNAL' => {
		'HEADER_PREFIX' => 'Web Console: ',
		'MAX_EDIT_FILE_SIZE' => 1048576, # in bytes (1 MB = 1048576 bytes)
		'HEADERS' => {
			'content-type' => {
				'default' => 'Content-type: text/html; charset=utf-8',
				'sub' => sub {
					my ($in) = @_;
					my $result = {};
					if (defined $in && $in ne '' && $in =~ /^[ ]{0,}Content-type:[ ]+([^ ]+);([ ]+charset=([^ ]+);?)?[ ]{0,}$/i) {
						$result->{'name'} = 'content-type';
						$result->{'type'} = $1;
						$result->{'charset'} = defined $3 ? $3 : '';
					}
					return $result;
				}
			}
		}
	},
	'HTTP_EXTRA_HEADERS' => [
		'X-Powered-By: Web Console (http://www.web-console.org)'
	]
};

# 'NL::Error' for error storage support
sub _error_reset { &NL::Error::reset(__PACKAGE__); }
sub _error_set { &NL::Error::set(__PACKAGE__, @_); }
sub get_last_error { &NL::Error::get(__PACKAGE__); }
sub get_last_error_ARR { &NL::Error::get_ARR(__PACKAGE__); }
sub get_last_error_ID { &NL::Error::get_id(__PACKAGE__); }
sub get_last_error_TEXT { &NL::Error::get_text(__PACKAGE__); }
sub get_last_error_INFO { &NL::Error::get_info(__PACKAGE__); }

# Internal error wrappers, after error - stopping all and exit
# WE DON'T GENERATING THAT SUBS AUTOMATICALLY TO BE READY TO SHOW ERROR AT ANY TIME AND FOR FASTER LOADING
# IN: STRING - message, STRING - info, STRING - id
# RETURN: NOTHING
sub die_exit { exit; }
sub die_error { &WC::Response::show_error(@_); &die_exit(); }
sub die_error_no_header { &WC::Response::show_error_no_header(@_); &die_exit(); }
sub die_info { &WC::Response::show_info(@_); &die_exit(); }
sub die_info_no_header { &WC::Response::show_info_no_header(@_); &die_exit(); }
sub die_warning { &WC::Response::show_warning(@_); &die_exit(); }
sub die_warning_no_header { &WC::Response::show_warning_no_header(@_); &die_exit(); }
# Wrappers for TYPES (with headers)
sub die_error_AJAX { &WC::Response::show_error_AJAX(@_); &die_exit(); }
sub die_error_HTML { &WC::Response::show_error_HTML(@_); &die_exit(); }
sub die_error_TEXT { &WC::Response::show_error_TEXT(@_); &die_exit(); }
sub die_info_AJAX { &WC::Response::show_info_AJAX(@_); &die_exit(); }
sub die_info_HTML { &WC::Response::show_info_HTML(@_); &die_exit(); }
sub die_info_TEXT { &WC::Response::show_info_TEXT(@_); &die_exit(); }
sub die_warning_AJAX { &WC::Response::show_warning_AJAX(@_); &die_exit(); }
sub die_warning_HTML { &WC::Response::show_warning_HTML(@_); &die_exit(); }
sub die_warning_TEXT { &WC::Response::show_warning_TEXT(@_); &die_exit(); }
# Wrappers for TYPES (without headers)
sub die_error_AJAX_no_header { &WC::Response::show_error_AJAX_no_header(@_); &die_exit(); }
sub die_error_HTML_no_header { &WC::Response::show_error_HTML_no_header(@_); &die_exit(); }
sub die_error_TEXT_no_header { &WC::Response::show_error_TEXT_no_header(@_); &die_exit(); }
sub die_info_AJAX_no_header { &WC::Response::show_info_AJAX_no_header(@_); &die_exit(); }
sub die_info_HTML_no_header { &WC::Response::show_info_HTML_no_header(@_); &die_exit(); }
sub die_info_TEXT_no_header { &WC::Response::show_info_TEXT_no_header(@_); &die_exit(); }
sub die_warning_AJAX_no_header { &WC::Response::show_warning_AJAX_no_header(@_); &die_exit(); }
sub die_warning_HTML_no_header { &WC::Response::show_warning_HTML_no_header(@_); &die_exit(); }
sub die_warning_TEXT_no_header { &WC::Response::show_warning_TEXT_no_header(@_); &die_exit(); }

# Starting of Web Console, called always first (initializing ALL needed, executing, printing result back to browser)
# IN: NOTHING
# RETURN: NOTHING
sub start {
	$WC::context = {};
	*WC::c = \$WC::context; # Alias to '$WC::context'

	# setting configuration information
	$WC::c->{'APP_SETTINGS'} = {
		'name' => $WC::CONST->{'APP_SETTINGS'}->{'name'},
		'dir_path' => '',
		'file_path' => $0,
		'file_name' => ''
	};
	$WC::c->{'ACTION'} = ''; # Web Console action
	$WC::c->{'config'} = {}; # Full configuration HASH
	$WC::c->{'user'} = {};  # Current user HASH
	$WC::c->{'stash'} = {};  # Buffer to share information between methods / modules
	$WC::c->{'state'} = {};  # Buffer to share status information
	$WC::c->{'request'} = { 'params' => {}, 'cmd' => '', 'cmd_' => '', 'cmd_params' => '', 'cmd_params_arr' => [] };
	$WC::c->{'response'} = { 'type' => 'HTML', 'text' => '', 'ajax_data' => {} };
	$WC::c->{'req'} = $WC::c->{'request'}; # Alias to '$WC::c->{'request'}'
	$WC::c->{'res'} = $WC::c->{'response'}; # Alias to '$WC::c->{'response'}'

	# OK, setting MARK that Web Console engine is loaded
	$WC::ENGINE_LOADED = 1;

	# Initializing very important modules
	&WC::Debug::init() if $WC::CONST->{'DEBUG'}; # For development only, will be removed at compact release | NL_CODE: RM_LINE
	&WC::Dir::init(); # Directorys processing - used by 'WC::File::get_name',
			  # at initialization calls: &WC::Dir::update_current_dir(), &WC::Dir::update_dir_splitters()
	$WC::c->{'APP_SETTINGS'}->{'file_name'} = &WC::File::get_name($WC::c->{'APP_SETTINGS'}->{'file_path'});
	$WC::c->{'APP_SETTINGS'}->{'dir_path'} = &WC::File::get_dir($WC::c->{'APP_SETTINGS'}->{'file_path'});

	# For MOD_PERL
	if ($WC::CONST->{'MOD_PERL_ON'}) {
		&WC::Dir::change_dir($WC::c->{'APP_SETTINGS'}->{'dir_path'});
		# if (!&WC::Dir::change_dir($WC::c->{'APP_SETTINGS'}->{'dir_path'})) { &WC::CORE::die_error("Unable change directory to '".$WC::c->{'APP_SETTINGS'}->{'dir_path'}."'", $!); }
		&WC::Response::show_HTML_PAGE('html_MOD_PERL');
		return;
	}

	# Setting default config data
	&WC::Config::Main::init_variables_defaults();

	# Getting parameters from query string (not from POST, because at POST can be uploaded files)
	# Parameters from GET will be at '$WC::c->{'req'}->{'params'}'
	&WC::CGI::init(); # At initialization will set wrapper to convert encodings
	&WC::CGI::get_input_from_GET_SET();

	# Ajax initialization (all needed parameters should be at GET parameters)
	# AJAX for initialization uses '$WC::c->{'req'}->{'params'}'
	if (&WC::AJAX::init()) { $WC::c->{'response'}->{'type'} = 'AJAX'; }

	if ($WC::DEMO) { # NL_CODE: RM_BLOCK [DEMO_MODE]
		$WC::c->{'config'}->{'directorys'}->{'work'} = '/demo';
		&ACTION_process();
	}
	else { # NL_CODE: / RM_BLOCK [DEMO_MODE]

		# Checking is Web Console installed
		my $IS_WEB_CONSOLE_INSTALLED = &WC::Install::CHECK_IS_WEB_CONSOLE_INSTALLED();
		# Web Console is not installed
		if ($IS_WEB_CONSOLE_INSTALLED == 0) {
			# Initializing file locking system with TEMP DIRECTORY = '$WC::c->{'config'}->{'directorys'}->{'home'}'
			if (!&WC::File::lock_init($WC::c->{'config'}->{'directorys'}->{'home'}, 1)) { &WC::CORE::die_error(&WC::File::get_last_error_ARR()); }
			# Getting parameters from POST (installation do not POST any files, so all data from client is need to bee readed)
			&WC::CGI::get_input_from_POST_UPDATE();
			# Main installation action
			&WC::Install::start();
		}
		# Web Console is installed
		elsif ($IS_WEB_CONSOLE_INSTALLED == 1) {
			# Loading MAIN config
			if (&WC::Config::Main::load() != 1) { &WC::CORE::die_error(&WC::Config::get_last_error_ARR()); }
			else {
				# OK, config loaded
				# Initializing file locking system with TEMP DIRECTORY = '$WC::c->{'config'}->{'directorys'}->{'temp'}'
				if (!&WC::File::lock_init($WC::c->{'config'}->{'directorys'}->{'temp'})) { &WC::CORE::die_error(&WC::File::get_last_error_ARR()); }
				# Initializing modules 'Encode' and 'EXEC' (system commands execution)
				&WC::Encode::init(); # At initialization parameters from '$WC::c->{'config'}->{'encodings'}' will be checked
				&WC::EXEC::init(); # At initialization parameter '$WC::c->{'config'}->{'encodings'}->{'server_console'}' will be used
				# Initializing USERS DB
				if (&WC::Users::init() != 1) { &WC::CORE::die_error(&WC::Users::get_last_error_ARR()); }
				else {
					# OK, USERS DB initialized
					if ($WC::c->{'config'}->{'directorys'}->{'work'} ne '') {
						if (!&WC::Dir::change_dir($WC::c->{'config'}->{'directorys'}->{'work'})) {
							&WC::Warning::add("Unable change directory to WORK DIRECTORY = '".$WC::c->{'config'}->{'directorys'}->{'work'}."'", $!);
						}
					}
					# If we are here - ALL IS FINE, starting main action
					&ACTION_process();
				}
			}
		}
		# Error while checking installation
		else {
			&WC::CORE::die_error(&WC::Install::get_last_error_ARR());
		}
	} # NL_CODE: RM_LINE [DEMO_MODE]
}
# Updating action from '$WC::c->{'req'}->{'params'}->{'q_action'}'
# IN: NOTHING
# RETURN: 1 - 'q_action' is defined | 0 - 'q_action' is not defined
sub ACTION_update_from_Q_ACTION {
	if (defined $WC::c->{'req'}->{'params'}->{'q_action'}) {
		if ($WC::c->{'req'}->{'params'}->{'q_action'} ne '') {
			$WC::c->{'ACTION'} = $WC::c->{'req'}->{'params'}->{'q_action'};
		}
		return 1;
	}
	return 0;
}
# Processing action from '$WC::c->{'ACTION'}'
# IN: NOTHING
# RETURN: NOTHING
sub ACTION_process {
	my $is_LOG_PASS_from_GET = (defined $WC::c->{'req'}->{'params'}->{'user_login'} || defined $WC::c->{'req'}->{'params'}->{'user_password'});
	# Trying to find 'q_action' at GET
	if (!&ACTION_update_from_Q_ACTION()) {
		# No, action at GET, trying to find 'q_action' at POST
		&WC::CGI::get_input_from_POST_UPDATE();
		&ACTION_update_from_Q_ACTION();
	}

	# If we have ACTION = 'logon' and 'login' or 'password' from GET - that is not good, looks like hacker...
	# Resetting all, we will show 'html_logon' page
	if ($is_LOG_PASS_from_GET && $WC::c->{'ACTION'} eq 'logon') { $WC::c->{'ACTION'} = ''; }

	my $is_INCORRECT_CALL = 0;
	# Default action
	if ($WC::c->{'ACTION'} eq '') {
		$WC::c->{'response'}->{'type'} = 'HTML';
		&WC::Response::show_HTML_PAGE('html_logon');
	}
	elsif ($WC::c->{'ACTION'} eq 'logon') {
		$WC::c->{'response'}->{'type'} = 'HTML';
		# Getting parameters from POST, if it's not getted (that automatically will not be called more that once)
		&WC::CGI::get_input_from_POST_UPDATE();
		# Authenticating user
		if (&WC::Users::authenticate('HTML')) {
			&WC::Response::show_HTML_PAGE('html_console', {
				'user_login' => &NL::String::str_escape_JSON($WC::c->{'req'}->{'params'}->{'user_login'}),
				'user_password_encrypted' => &NL::String::str_escape_JSON($WC::c->{'req'}->{'params'}->{'user_password'})
			});
		}
	}
	elsif ($WC::c->{'ACTION'} eq 'download') {
		if ($WC::DEMO) { $is_INCORRECT_CALL = 1; } # NL_CODE: RM_BLOCK [DEMO_MODE]
		else { # NL_CODE: / RM_BLOCK [DEMO_MODE]
			# Authenticating user
			if (&WC::Users::authenticate('HTML')) {
				# Calling action (there we must make all that we need)
				&WC::Response::Download::start($WC::c->{'req'}->{'params'});
			}
		} # NL_CODE: RM_LINE [DEMO_MODE]
	}
	elsif ($WC::c->{'ACTION'} =~ /^AJAX_[^\s]+$/) {
		if ($WC::c->{'response'}->{'type'} eq 'AJAX') {
			# If we don't have login/password from GET - getting parameters from POST (login/password from GET is at AJAX where POST contain files)
			if (!$is_LOG_PASS_from_GET) {
				# Getting parameters from POST, if it's not getted (that automatically will not be called more that once)
				&WC::CGI::get_input_from_POST_UPDATE();
			}
			# Authenticating user
			if (&WC::Users::authenticate('AJAX')) {
				# Calling AJAX action (there we must make all that we need)
				if (!&ACTION_process_AJAX( $WC::c->{'ACTION'} )) { $is_INCORRECT_CALL = 1; }
			}
		}
		else { $is_INCORRECT_CALL = 1; }
	}
	else { $is_INCORRECT_CALL = 1; }

	# If it was incorrect call
	if ($is_INCORRECT_CALL) {
		&die_info('Incorrect '.$WC::c->{'APP_SETTINGS'}->{'name'}.' call', 'Undefined '.$WC::c->{'APP_SETTINGS'}->{'name'}.' action was called or action needs more parameter(s), are you hacker?', 'WC_CORE_UNDEFINED_ACTION');
	}
}

# Processing AJAX action (here we must make all that we need and send output to client if it's needed)
# IN: STRING - AJAX action
# RETURN: 1 - OK, processed | 0 - not processed
sub ACTION_process_AJAX {
	my ($in_ACTION) = @_;
	return 0 if (!defined $in_ACTION || $in_ACTION eq '');

	if ($WC::DEMO) { # NL_CODE: RM_BLOCK [DEMO_MODE]
		$WC::c->{'req'}->{'params'}->{'STATE_dir_current'} = '.';
		my $hash_DEMO = &WC::Demo::ACTION_process_AJAX($in_ACTION);
		if (!$hash_DEMO->{'ALLOWED'}) {
			&WC::AJAX::show_response( @{ $hash_DEMO->{'AJAX_RESPONSE_ARRAY'} } );
			return 1;
		}
		# ELSE - THAT IS ALLOWED
	} # NL_CODE: / RM_BLOCK [DEMO_MODE]

	if ($in_ACTION eq 'AJAX_CMD') {
		if(&WC::EXEC::init_INPUT_CMD()) {
			# Updating current directory from input and going to the needed directory
			my $name_not_contain = '\|'; #'\&\|\;';
			if (!&WC::Dir::change_dir_TO_CURRENT() && $WC::c->{'request'}->{'cmd'} !~ /^[ \t]{0,}cd( [ \t]{0,}([^$name_not_contain]{0,})[ \t]{0,}|)$/i) {
				&WC::CORE::die_info_AJAX(&WC::Dir::get_last_error_ARR());
			}
			else {
				# Special command (will be maked some action)
				# if ($WC::c->{'request'}->{'cmd'} =~ /^[ \t]{0,}cd( [ \t]{0,}([^$name_not_contain]{0,})[ \t]{0,}|)$/i) {
				if ($WC::c->{'request'}->{'cmd'} =~ /^cd( [ \t]{0,}([^$name_not_contain]{0,})[ \t]{0,}|)$/i) {
					my $dir = '';
					if (defined $2 && $2 ne '') {
						$dir = &NL::String::str_trim($2);
						$dir = &WC::Dir::check_in($dir);
					}
					$dir = $WC::c->{'config'}->{'directorys'}->{'work'} if ($dir eq '');
					if (&WC::Dir::change_dir($dir)) {
						$dir = &WC::Dir::get_current_dir();
						&WC::Response::show_AJAX_RESPONSE('DIR_CHANGE', '', {
							'dir_now' => $dir,
							'JS_REQUEST_ID' => &NL::AJAX::get_request_id()
						});
					}
					else {
						&WC::Response::show_AJAX_RESPONSE('CMD_RESULT', '<div class="t-lime">'.
						$WC::c->{'APP_SETTINGS'}->{'name'}." unable change directory to ".( &WC::HTML::get_short_value($dir, { 'MAX_LENGTH' => 55 }) ).':</div>'.
						'<div class="t-blue">&nbsp;&nbsp; - '.(($! && $! ne '') ? $! : 'Unknown error').'</div>'.
						'<span class="t-green">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you are trying to execute few commands as \'one-liner\' and first<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;command is "cd", please add space character before first "cd" command.');
					}
				}
				# Usual command (will be executed)
				else {
					# Checking if it is internal command
					my $internal_exec = &WC::Internal::exec_autocompletion($WC::c->{'request'}->{'cmd'});
					if ($internal_exec->{'ID'}) {
						if (defined $internal_exec->{'SHOW_AS_TAB_RESULT'} && $internal_exec->{'SHOW_AS_TAB_RESULT'}) {
							# Making result HASH
							my $hash_RESULT = $internal_exec;
							delete $hash_RESULT->{'ID'};
							delete $hash_RESULT->{'SHOW_AS_TAB_RESULT'};
							$hash_RESULT->{'ALWAYS_SHOW'} = 1;
							$hash_RESULT->{'str_IN'} = '';
							$hash_RESULT->{'cmd_add'} = '';
							$hash_RESULT->{'values'} = [];
							foreach ('INFO', 'SUBTITLE') { # 'TITLE',
								&NL::String::str_HTML_full(\$hash_RESULT->{$_}) if (defined $hash_RESULT->{$_});
							}
							# Escaping 'TEXT' only if there is no header 'Web Console: Content-type: text/html;'
							if (defined $hash_RESULT->{'TEXT'} && $hash_RESULT->{'TEXT'} ne '') {
								my $hash_internal = &WC::Internal::process_output(\$hash_RESULT->{'TEXT'}, $hash_RESULT->{'BACK_STASH'});
								&NL::Utils::hash_update($hash_RESULT, $hash_internal);
							}
							# Sending response
							&WC::Response::show_AJAX_RESPONSE('TAB_RESULT', '', $hash_RESULT);
						}
						else {
							my $hash_internal = &WC::Internal::process_output(\$internal_exec->{'text'}, $internal_exec->{'BACK_STASH'}) if (defined $internal_exec->{'text'} && $internal_exec->{'text'} ne '');
							&WC::Response::show_AJAX_RESPONSE_NO_TEXT_ENCODE('CMD_RESULT', $internal_exec->{'text'}, $hash_internal);
						}
					}
					# No - that is not internal command
					else {
						my $result_EXEC = &WC::EXEC::execute_encoding_WC($WC::c->{'request'}->{'cmd'});
						if ($result_EXEC->{'ID'} == 1) {
							# Command executed
							&WC::Response::show_AJAX_RESPONSE_NO_TEXT_ENCODE('CMD_RESULT', &NL::String::str_HTML_full($result_EXEC->{'text'}));
						}
						else {
							# Command not executed
							&WC::CORE::die_info_AJAX("Unable to execute command '".( &NL::String::str_HTML_full($WC::c->{'request'}->{'cmd'}) )."'", &NL::String::str_HTML_full(@{ $result_EXEC->{'error'} }[1]), 'AJAX_CMD_UNABLE_EXECUTE');
						}
					}
				}
			}
			return 1;
		}
		else { return 0; }
	}
	elsif ($in_ACTION eq 'AJAX_TAB') {
		if (defined $WC::c->{'req'}->{'params'}->{'cmd_query'}) {
			my $auto = &WC::Autocomplete::start($WC::c->{'req'}->{'params'}->{'cmd_query'});
			if ($auto->{'ID'}) {
				# Making result HASH
				my $hash_RESULT = $auto;
				delete $hash_RESULT->{'ID'};
				$hash_RESULT->{'str_IN'} = $WC::c->{'req'}->{'params'}->{'cmd_query'};
				foreach ('INFO', 'SUBTITLE') { # 'TITLE',
					&NL::String::str_HTML_full(\$hash_RESULT->{$_}) if (defined $hash_RESULT->{$_});
				}
				# Escaping 'TEXT' only if there is no header 'Web Console: Content-type: text/html;'
				if (defined $hash_RESULT->{'TEXT'} && $hash_RESULT->{'TEXT'} ne '') {
					my $hash_internal = &WC::Internal::process_output(\$hash_RESULT->{'TEXT'});
					&NL::Utils::hash_update($hash_RESULT, $hash_internal);
				}
				if (defined $hash_RESULT->{'values'}) { foreach (@{ $hash_RESULT->{'values'} }) { &NL::String::str_HTML_full(\$_); } }
				# Sending response
				&WC::Response::show_AJAX_RESPONSE('TAB_RESULT', '', $hash_RESULT);
			}
			else {
				delete $auto->{'ID'};
				&WC::Response::show_AJAX_RESPONSE('TAB_RESULT', '', $auto);
			}
			return 1;
		}
		else { return 0; }
	}
	elsif ($in_ACTION eq 'AJAX_FILE_SAVE') {
		if (&WC::Internal::Data::File::AJAX_save($WC::c->{'req'}->{'params'})) { return 1; }
	}
	elsif ($in_ACTION eq 'AJAX_FILE_SAVE_CLOSE') {
		if (&WC::Internal::Data::File::AJAX_save($WC::c->{'req'}->{'params'}, 1)) { return 1; }
	}
	elsif ($in_ACTION eq 'AJAX_UPLOAD') {
		if (&WC::Upload::process()) { return 1; }
	}
	elsif ($in_ACTION eq 'AJAX_UPLOAD_STATUS') {
		if (&WC::Upload::process_get_status()) { return 1; }
	}
	return 0;
}

1; #EOF
