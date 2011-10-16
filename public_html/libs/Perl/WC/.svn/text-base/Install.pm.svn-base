#!/usr/bin/perl
# WC::Install - Web Console 'Install' module, contains methods for Web Console installation
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::Install;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Install::DATA = {
	'CONST' => { 'MAX_PATH_LENGTH_TO_SHOW' => 55 },
	'DYNAMIC' => {} # Here will be DATA after initialization
};

# 'NL::Error' for error storage support
sub _error_reset { &NL::Error::reset(__PACKAGE__); }
sub _error_set { &NL::Error::set(__PACKAGE__, @_); }
sub get_last_error { &NL::Error::get(__PACKAGE__); }
sub get_last_error_ARR { &NL::Error::get_ARR(__PACKAGE__); }
sub get_last_error_ID { &NL::Error::get_id(__PACKAGE__); }
sub get_last_error_TEXT { &NL::Error::get_text(__PACKAGE__); }
sub get_last_error_INFO { &NL::Error::get_info(__PACKAGE__); }

# Checking is Web Console installed
# IN: NOTHING
# RETURN: 1 - YES | 0 - NO | -1 - ERROR
sub CHECK_IS_WEB_CONSOLE_INSTALLED {
	my $result_CONFIG = &WC::Config::Main::IS_WEB_CONSOLE_INSTALLED();
	my $result_USERS = &WC::Users::IS_WEB_CONSOLE_INSTALLED();

	if ($result_CONFIG == 1) {
		if ($result_USERS == 1) { return 1; }
		elsif ($result_USERS == 0) { &_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' users DB not found', $WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object exists, but users DB does not exists', 'INIT_CONFIG_OK_USERS_NO'); }
		else { &_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' users DB checking error', $WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object exists, but unable to check if users DB is exists', 'INIT_CONFIG_OK_USERS_BAD'); }
	}
	elsif ($result_CONFIG == 0) {
		if ($result_USERS == 0) { return 0; }
		elsif ($result_USERS == 1) { &_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object not found', 'No '.$WC::c->{'APP_SETTINGS'}->{'name'}.' configuration file exists, but users DB is exists', 'INIT_CONFIG_NO_USERS_OK'); }
		else { &_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object not found', 'No '.$WC::c->{'APP_SETTINGS'}->{'name'}.' configuration object exists and unable to check if users DB is exists', 'INIT_CONFIG_NO_USERS_BAD'); }
	}
	else {
		if ($result_USERS == 0) { &_error_set('Unable to check if configuration file is exists', 'Unable to check if configuration file is exists, but users DB not found', 'INIT_CONFIG_BAD_USERS_NO'); }
		elsif ($result_USERS == 1) { &_error_set('Unable to check if configuration file is exists', 'Unable to check if configuration file is exists, but users DB is exists', 'INIT_CONFIG_BAD_USERS_OK'); }
		else { &_error_set('Unable to check if configuration file is exists', 'Unable to check if configuration file is exists and unable to check if users DB is exists', 'INIT_CONFIG_BAD_USERS_BAD'); }
	}
	return -1;
}
# Making CONTENT for '.htaccess' file HEADER
# IN: STRING
# RETURN: STRING
sub make_DATA_htaccess_HEADER {
	my ($in_TYPE) = @_;
	my $TEXT = '';
	$TEXT .= "# This is Web Console $in_TYPE '.htaccess' file\n";
	$TEXT .= "# Web Console version: '".( defined $WC::CONST->{'VERSION'}->{'NUMBER'} ? $WC::CONST->{'VERSION'}->{'NUMBER'} : '_UNKNOWN_' )."'\n";
	$TEXT .= "# Edit this file manually is not recommended\n";
	$TEXT .= "#\n";
	$TEXT .= "# Web Console author: Kovalev Nick\n";
	$TEXT .= "# Web Console author's resume: http://resume.nickola.ru\n";
	$TEXT .= "#\n";
	$TEXT .= "# Web Console URL: http://www.web-console.org\n";
	$TEXT .= "# Last version of Web Console can be downloaded from: http://www.web-console.org/download/\n";
	$TEXT .= "# Web Console Group services: http://services.web-console.org\n";
	$TEXT .= "\n";
	return $TEXT;
}
# Making CONTENT for '.htaccess' file FOOTER
# IN: STRING
# RETURN: STRING
sub make_DATA_htaccess_FOOTER {
	my ($in_TYPE) = @_;
	my $TEXT = '';
	$TEXT .= "\n";
	$TEXT .= '# ERRORDOCUMENT'."\n";
	$TEXT .= "ErrorDocument 401 \"<html><title>401: Authorization Required</title><body bgcolor='#000000' text='#bbbbbb'><font style='font-family: verdana, helvetica, arial, sans-serif; color: #1196cb; font-size: 18px; font-weight: bold;'>401: Authorization Required</font></body></html>\n";
	$TEXT .= "ErrorDocument 403 \"<html><title>403: Access Forbidden</title><body bgcolor='#000000' text='#bbbbbb'><font style='font-family: verdana, helvetica, arial, sans-serif; color: #1196cb; font-size: 18px; font-weight: bold;'>403: Access Forbidden</font></body></html><!-- IE FIX: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->\n";
	$TEXT .= "ErrorDocument 404 \"<html><title>404: File not found</title><body bgcolor='#000000' text='#bbbbbb'><font style='font-family: verdana, helvetica, arial, sans-serif; color: #1196cb; font-size: 18px; font-weight: bold;'>404: File not found</font></body></html><!-- IE FIX: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->\n";
	$TEXT .= "ErrorDocument 500 \"500: Internal Server Error\n";
	return $TEXT;
}
# Making CONTENT for '.htaccess' file, called when we need to create that file
# IN: NOTHING
# RETURN: STRING
sub make_DATA_htaccess {
	my $file_name_RE = $WC::c->{'APP_SETTINGS'}->{'file_name'};
	$file_name_RE =~ s/([\\|\.|\-])/\\$1/g;
	my $TEXT = &make_DATA_htaccess_HEADER('MAIN');
		# $TEXT .= '# DROP ALL'."\n";
		# $TEXT .= 'Order Deny,Allow'."\n";
		# $TEXT .= 'Deny from all'."\n";
		# $TEXT .= 'RedirectMatch ^(.*/)((\?.*)|)$ $1'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'$2'."\n";
	$TEXT .= 'Options -Indexes +ExecCGI'."\n";
	$TEXT .= '# Allow ONLY: "" | "index.html" | "'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'"'."\n";
	$TEXT .= '<IfModule mod_rewrite.c>'."\n";
	$TEXT .= '	Options +FollowSymLinks'."\n";
	$TEXT .= '	RewriteEngine On'."\n";
	$TEXT .= '	RewriteRule ^/?$ %{REQUEST_URI}'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.' [L]'."\n";
	# $TEXT .= '	RewriteRule !^(|/|index\.html|'.$file_name_RE.')$ - [F]'."\n";
	$TEXT .= '	RewriteRule !^(/|index\.html|'.$file_name_RE.')$ - [F]'."\n";
	$TEXT .= '</IfModule>'."\n";
	$TEXT .= '<IfModule !mod_rewrite.c>'."\n";
	$TEXT .= '	# DROP ALL'."\n";
	$TEXT .= '	Order Deny,Allow'."\n";
	$TEXT .= '	Deny from all'."\n";
	$TEXT .= '	<Files "'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'">'."\n";
	$TEXT .= '		Order Deny,Allow'."\n";
	$TEXT .= '		Allow from all'."\n";
	$TEXT .= '	</Files>'."\n";
	$TEXT .= '	<Files "index.html">'."\n";
	$TEXT .= '		Order Deny,Allow'."\n";
	$TEXT .= '		Allow from all'."\n";
	$TEXT .= '	</Files> '."\n";
	$TEXT .= '	<Files "">'."\n";
	$TEXT .= '		Order Deny,Allow'."\n";
	$TEXT .= '		Allow from all'."\n";
	$TEXT .= '	</Files>'."\n";
	$TEXT .= '</IfModule> '."\n";
	$TEXT .= &make_DATA_htaccess_FOOTER();
		# $TEXT .= '# Saving 500 predefined'."\n";
		# Next don't works good at FireFox and Opera
		# $TEXT .= 'ErrorDocument 500 "<html><title>500: Internal Server Error</title><body bgcolor=\"#000000\" text=\"#bbbbbb\"><font style=\"font-family: verdana, helvetica, arial, sans-serif; color: #1196cb; font-size: 18px; font-weight: bold;\">500: Internal Server Error</font></body></html>"'."\n";
	return $TEXT;
}
# Making CONTENT for '.htaccess' file, called when we need to create that file for subdirectorys
# IN: NOTHING
# RETURN: STRING
sub make_DATA_htaccess_SUBDIR {
	my $file_name_RE = $WC::c->{'APP_SETTINGS'}->{'file_name'};
	$file_name_RE =~ s/([\\|\.|\-])/\\$1/g;
	my $TEXT = &make_DATA_htaccess_HEADER('SUBDIRECTORYS');
	$TEXT .= "<Files *>\n";
	$TEXT .= "	Order Allow,Deny\n";
	$TEXT .= "	Deny from All\n";
	$TEXT .= "</Files>\n";
	$TEXT .= &make_DATA_htaccess_FOOTER();
	return $TEXT;
}

# Making CONTENT for MAIN 'index.html' file, called when we need to create that file
# IN: NOTHING
# RETURN: STRING
sub make_DATA_index {
	my $TEXT = '';
	$TEXT .= '<?xml version="1.0" encoding="UTF-8"?>'."\n";
	$TEXT .= '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'."\n";
	$TEXT .= '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">'."\n";
	$TEXT .= '<head>'."\n";
	$TEXT .= '	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'."\n";
	$TEXT .= '	<meta name="author" content="Nickolay Kovalev | http://resume.nickola.ru" />'."\n";
	$TEXT .= '	<meta name="robots" content="NONE" />'."\n";
	$TEXT .= '	<meta http-equiv="refresh" content="0; url='.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'" />'."\n";
	$TEXT .= '	<title>Loading...</title>'."\n";
	$TEXT .= '	<style>'."\n";
	$TEXT .= '		* {'."\n";
	$TEXT .= '			background-color: #000; color: #23d500; margin: 0; padding: 0;'."\n";
	$TEXT .= '			font-weight: normal; font-family: verdana, helvetica, arial, sans-serif; font-size: 12px;'."\n";
	$TEXT .= '		} '."\n";
	$TEXT .= '		a, a:visited, a:hover { background-color: #000; color: #bbbbbb; text-decoration: underline; }'."\n";
	$TEXT .= '		html, body { margin: 0; padding: 0; height: 100%; }'."\n";
	$TEXT .= '		body { margin: 7px 12px; }'."\n";
	$TEXT .= '		.wait { margin: 2px 0 0 0; color: #1196cb; }'."\n";
	$TEXT .= '		.wait a, .wait a:visited, .wait a:hover { color: #1196cb; }'."\n";
	$TEXT .= '	</style>'."\n";
	$TEXT .= '	<script type="text/javascript">'."\n";
	$TEXT .= '	<!--'."\n";
	$TEXT .= '	location.href=\''.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'\';'."\n";
	$TEXT .= '	//-->'."\n";
	$TEXT .= '	</script>'."\n";
	$TEXT .= '</head>'."\n";
	$TEXT .= '<body>Loading...<div class="wait">If you are waiting too long &mdash; <a href="'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'">click here</a>.</div></body>'."\n";
	$TEXT .= '</html>'."\n";
	return $TEXT;
}
# Initialization of data needed to be created, called always first before installation
# IN: NOTHING
# RETURN: NOTHING
sub INIT_DATA_TO_CREATE {
	my $ref_hash_TEST = { 'test_name' => 'test_value' };
	$WC::Install::DATA->{'DYNAMIC'}->{'TO_CREATE'} = [
		# file: index.html (at 'HOME')
		{ 'id' => 'file_index_home', 'path' => $WC::c->{'config'}->{'directorys'}->{'home'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html', 'DATA' => '<!-- [PERMISSIONS TEST] -->' },
		# dir 'DATA'
		{ 'id' => 'dir_data', 'path' => $WC::c->{'config'}->{'directorys'}->{'data'} },
		{ 'id' => 'file_index_data', 'path' => $WC::c->{'config'}->{'directorys'}->{'data'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html', 'DATA' => '' },
		{ 'id' => 'file_htaccess_data', 'path' => $WC::c->{'config'}->{'directorys'}->{'data'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess', 'DATA' => &make_DATA_htaccess_SUBDIR() },
		# dir 'TEMP'
		{ 'id' => 'dir_temp', 'path' => $WC::c->{'config'}->{'directorys'}->{'temp'} },
		{ 'id' => 'file_index_temp', 'path' => $WC::c->{'config'}->{'directorys'}->{'temp'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html', 'DATA' => '' },
		{ 'id' => 'file_htaccess_temp', 'path' => $WC::c->{'config'}->{'directorys'}->{'temp'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess', 'DATA' => &make_DATA_htaccess_SUBDIR() },
		# dir 'CONFIGS'
		{ 'id' => 'dir_configs', 'path' => $WC::c->{'config'}->{'directorys'}->{'configs'} },
		{ 'id' => 'file_index_configs', 'path' => $WC::c->{'config'}->{'directorys'}->{'configs'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html', 'DATA' => '' },
		{ 'id' => 'file_htaccess_configs', 'path' => $WC::c->{'config'}->{'directorys'}->{'configs'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess', 'DATA' => &make_DATA_htaccess_SUBDIR() },
		# dir 'PLUGINS'
		# { 'id' => 'dir_plugins', 'path' => $WC::c->{'config'}->{'directorys'}->{'plugins'} },
		# { 'id' => 'file_index_plugins', 'path' => $WC::c->{'config'}->{'directorys'}->{'plugins'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html', 'DATA' => '' },
		# { 'id' => 'file_htaccess_plugins', 'path' => $WC::c->{'config'}->{'directorys'}->{'plugins'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess', 'DATA' => &make_DATA_htaccess_SUBDIR() },
		# dir 'PLUGINS CONFIGS'
		# { 'id' => 'dir_plugins_configs', 'path' => $WC::c->{'config'}->{'directorys'}->{'plugins_configs'} },
		# { 'id' => 'file_index_plugins_configs', 'path' => $WC::c->{'config'}->{'directorys'}->{'plugins_configs'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html', 'DATA' => '' },
		# { 'id' => 'file_htaccess_plugins_configs', 'path' => $WC::c->{'config'}->{'directorys'}->{'plugins_configs'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess', 'DATA' => &make_DATA_htaccess_SUBDIR() },
		# files: 'CONFIG', 'USERS'
		{ 'id' => 'file_config', 'path' => $WC::c->{'config'}->{'files'}->{'config'}, 'config_HASH' => $ref_hash_TEST, 'config_PARAM_NAME' => '$WC::Config::FILE::CONFIG_MAIN', 'config_NAME' => 'MAIN (PERMISSIONS TEST)' },
		{ 'id' => 'file_users', 'path' => $WC::c->{'config'}->{'files'}->{'users'}, 'config_HASH' => $ref_hash_TEST, 'config_PARAM_NAME' => '$WC::Config::FILE::USERS_DB', 'config_NAME' => 'USERS DB (PERMISSIONS TEST)' },
		# dir 'WORK'
		{ 'id' => 'dir_work', 'path' => $WC::c->{'config'}->{'directorys'}->{'work'} },
		{ 'id' => 'file_index_work', 'path' => $WC::c->{'config'}->{'directorys'}->{'work'}.$WC::c->{'config'}->{'directorys_splitter'}.'index.html', 'DATA' => '' },
		{ 'id' => 'file_htaccess_work', 'path' => $WC::c->{'config'}->{'directorys'}->{'work'}.$WC::c->{'config'}->{'directorys_splitter'}.'.htaccess', 'DATA' => &make_DATA_htaccess_SUBDIR() },
		# file: '.HTACCESS'
		{ 'id' => 'file_htaccess', 'path' => $WC::c->{'config'}->{'files'}->{'.HTACCESS'}, 'DATA' => '[PERMISSIONS TEST]', 'CHMOD' => $WC::CONST->{'CHMODS'}->{'.HTACCESS'} },
 	];
}
# Main installation action, called when Web Console is not installed
# IN: NOTHING
# RETURN: NOTHING
sub start {
	my $reqPARAMS = $WC::c->{'request'}->{'params'};

	my @parameters_ERRORS = ();
	my $is_make_DEFAULT = 1;
	my $HTML_PAGE_TYPE = 'html_install';
	my $hash_TO_HTML = {};
	my $hash_TO_SAVE = {};
	if (defined $reqPARAMS->{'q_action'} && $reqPARAMS->{'q_action'} ne '') {
		if ($reqPARAMS->{'q_action'} eq 'install') {
			my @arr_NEEDED = ({'user_login' => 'Login'}, {'user_password' => 'Password'}, {'user_email' => 'E-mail'});
			foreach my $elem (@arr_NEEDED) {
				foreach (keys %{ $elem }) {
					if (!defined $reqPARAMS->{$_} || $reqPARAMS->{$_} eq '') {
						push @parameters_ERRORS, {'TYPE' => 'ERROR', 'variable' => $elem->{$_}, 'html_element' => '_'.$_.'_MAIN', 'message' => "can't be empty"};
					}
					else { $hash_TO_SAVE->{$_} = $reqPARAMS->{$_}; }
				}
			}
			if (defined $hash_TO_SAVE->{'user_email'}) {
				&NL::String::str_trim(\$hash_TO_SAVE->{'user_email'});
				my $hash_CHECK_EMAIL = &NL::Parameter::FUNC_CHECK_email($hash_TO_SAVE->{'user_email'});
				if (!$hash_CHECK_EMAIL->{'ID'}) {
					push @parameters_ERRORS, {'TYPE' => 'ERROR', 'variable' => 'E-mail', 'html_element' => '_user_email_MAIN', 'message' => 'is incorrect'};
				}
			}
			# Checking if we have errors
			if (scalar @parameters_ERRORS > 0) {
				# Generating report
				my $report_PARAMETERS = &WC::HTML::Report::make_REPORT_PARAMETERS(\@parameters_ERRORS);
				$hash_TO_HTML->{'main_info'} = $report_PARAMETERS->{'TEXT'};
				foreach ('user_login', 'user_email', 'encoding_SERVER_CONSOLE', 'encoding_SERVER_SYSTEM', 'encoding_EDITOR_TEXT') {
					if (defined $reqPARAMS->{$_} && $reqPARAMS->{$_} !~ /^[ \t\n\r]{0,}$/) {
						$hash_TO_HTML->{$_} = &NL::String::str_HTML_value($reqPARAMS->{$_});
					}
				}
				if (defined $hash_TO_HTML->{'encoding_SERVER_CONSOLE'} || defined $hash_TO_HTML->{'encoding_SERVER_SYSTEM'} || defined $hash_TO_HTML->{'encoding_EDITOR_TEXT'}) {
					$hash_TO_HTML->{'ENCODE_AREA_SHOW'} = 1;
				}
			}
			else {
				foreach ('encoding_SERVER_CONSOLE', 'encoding_SERVER_SYSTEM', 'encoding_EDITOR_TEXT') {
					if (defined $reqPARAMS->{$_} && $reqPARAMS->{$_} !~ /^[ \t\n\r]{0,}$/) {
						$hash_TO_SAVE->{$_} = $reqPARAMS->{$_};
					}
				}
				# Now we have all needed information for installation
				my $saveRESULTS = &MAKE_INSTALL($hash_TO_SAVE);
				if (!$saveRESULTS->{'ID'}) {
					# We have errors
					my $report = &WC::HTML::Report::make_REPORT_INSTALL($saveRESULTS->{'ERRORS'});
					$hash_TO_HTML->{'PAGE_ACTION'} = 'ERROR';
					$hash_TO_HTML->{'main_info'} = $report->{'TEXT'};
				}
				else {
					$HTML_PAGE_TYPE = 'html_installed';
				}
			}
			$is_make_DEFAULT = 0;
			&set_ENCODE_INFO($hash_TO_HTML) if ($HTML_PAGE_TYPE ne 'html_installed');
			&WC::Response::show_HTML_PAGE($HTML_PAGE_TYPE, $hash_TO_HTML);
		}
	}
	# If that is default (unknown) action
	if ($is_make_DEFAULT) {
		# Initializing VARIABLES_DEFAULTS
		&WC::Config::Main::init_variables_defaults();
		# Initializing DATA that will be created
		&INIT_DATA_TO_CREATE();
		my $testRESULTS = &MAKE_ALL($WC::Install::DATA->{'DYNAMIC'}->{'TO_CREATE'}, { 'IS_TESTING' => 1 });
		if (!$testRESULTS->{'ID'}) {
			my $report = &WC::HTML::Report::make_REPORT_INSTALL($testRESULTS->{'ERRORS'});
			$hash_TO_HTML->{'PAGE_ACTION'} = 'ERROR';
			$hash_TO_HTML->{'main_info'} = $report->{'TEXT'};
		}
		else {
			&set_ENCODE_INFO($hash_TO_HTML);
		}
		&WC::Response::show_HTML_PAGE($HTML_PAGE_TYPE, $hash_TO_HTML);
	}
}
sub set_ENCODE_INFO {
	my ($hash_TO_HTML) = @_;

	# Setting ERROR information for 'Encode.pm' if it's needed
	my $HTML_ENCODE_PM_MESSAGE = '';
	if (!$WC::Encode::ENCODE_ON) {
		$hash_TO_HTML->{'ENCODE_ON'} = 0;
		my $error_HTML = $WC::Encode::ENCODE_ERROR;
		$error_HTML = &NL::String::fix_width($error_HTML, 80);
		&NL::String::str_HTML_value(\$error_HTML);
		$error_HTML =~ s/\n/<br \/>/g;
		$hash_TO_HTML->{'ENCODE_ERROR'} = <<HTML_EOF;
		<table id="block-encoding-WARNING"><tr><td>
			<div class="encoding-WARNING-title">*** WARNING:</div>
			<div class="encoding-WARNING-main">
				ENCODINGS CONVERSION FEATURE WILL BE DISABLED.<br />
				Unable to load 'Encode.pm' Perl module, that module is needed for encodings conversion.<br />
				You can download that Perl module from CPAN: <a class="link-warning" href="http://search.cpan.org/~dankogai/Encode/Encode.pm" target="_blank">http://search.cpan.org/~dankogai/Encode/Encode.pm</a>
				<div class="encoding-WARNING-main-info">Additional information:</div>
				<div class="encoding-WARNING-main-info-DIV">$error_HTML</div>
			</div>
		</td></tr></table>
HTML_EOF
	}
	else {
		$hash_TO_HTML->{'ENCODE_ENCODING'} = '';
		foreach (@{ $WC::Internal::Data::Settings::ENCODINGS_LIST }) {
			$hash_TO_HTML->{'ENCODE_ENCODING'} .= ", " if ($hash_TO_HTML->{'ENCODE_ENCODING'} ne '');
			$hash_TO_HTML->{'ENCODE_ENCODING'} .= '<a class="link" href="#" onclick="WC.Other.paste_at_active_INPUT(this, \''.$_.'\'); return false" title="Click to paste at active (or last active) encodings input">'.$_.'</a>';
		}
	}
}
# Installing Web Console action, called when we have all data needed for installation
# IN: HASH that contains installation data
# RETURN:
# {
#            'ID' => 1 - OK || 0 - ERROR
#            'ERRORS' => [{problem 1}, {problem 2}] || []
# }
sub MAKE_INSTALL {
	my ($hash_TO_SAVE) = @_;

	# Initializing VARIABLES_DEFAULTS
	&WC::Config::Main::init_variables_defaults();
	# Initializing DATA that will be created
	&INIT_DATA_TO_CREATE();
	# Making hashes to saving
	my $save_USERS = {
		'users' => {
			$hash_TO_SAVE->{'user_login'} => {
				'group' => 'admin',
				'password' => $hash_TO_SAVE->{'user_password'},
				'e-mail' => &NL::String::str_trim($hash_TO_SAVE->{'user_email'})
			}
		},
		'groups' => {
			'admin' => {},
			'user' => {}
		}
	};
	my $save_CONFIG = $WC::c->{'config'};

	# Setting DATA
	$save_CONFIG->{'encodings'}->{'server_console'} = &NL::String::str_trim($hash_TO_SAVE->{'encoding_SERVER_CONSOLE'}) if (defined $hash_TO_SAVE->{'encoding_SERVER_CONSOLE'});
	$save_CONFIG->{'encodings'}->{'server_system'} = &NL::String::str_trim($hash_TO_SAVE->{'encoding_SERVER_SYSTEM'}) if (defined $hash_TO_SAVE->{'encoding_SERVER_SYSTEM'});
	$save_CONFIG->{'encodings'}->{'editor_text'} = &NL::String::str_trim($hash_TO_SAVE->{'encoding_EDITOR_TEXT'}) if (defined $hash_TO_SAVE->{'encoding_EDITOR_TEXT'});

	# Making hash of actions
	my $hash_ACTIONS = $WC::Install::DATA->{'DYNAMIC'}->{'TO_CREATE'};
	foreach (@{ $hash_ACTIONS }) {
		if (defined $_->{'id'}) {
			if ($_->{'id'} eq 'file_users') {
				$_->{'config_HASH'} = $save_USERS;
				$_->{'config_NAME'} = 'USERS DB';
			}
			elsif ($_->{'id'} eq 'file_config') {
				$_->{'config_HASH'} = $save_CONFIG;
				$_->{'config_NAME'} = 'MAIN';
			}
			elsif ($_->{'id'} eq 'file_htaccess') { $_->{'DATA'} = &make_DATA_htaccess(); }
			elsif ($_->{'id'} eq 'file_index_home') { $_->{'DATA'} = &make_DATA_index(); }
		}
	}
	return &MAKE_ALL($hash_ACTIONS);
}
# Creating all Web Console installation data and checking permissions problems
# IN: HASH that contains installation data, HASH that contains settings data
# RETURN:
# {
#            'ID' => 1 - OK || 0 - ERROR
#            'ERRORS' => [{problem 1}, {problem 2}] || []
# }
sub MAKE_ALL {
	my ($ref_DATA, $is_SETTINGS) = @_;
	$is_SETTINGS = {} if (!defined $is_SETTINGS);
	$is_SETTINGS->{'IS_TESTING'} = 0 if (!defined $is_SETTINGS->{'IS_TESTING'});

	my $result_ERRORS = [];
	my $result_RM = [];
	foreach my $obj (@{ $ref_DATA }) {
		# DIRECTORY
		if ($obj->{'id'} =~ /^dir_/) {
			my $dir_path = $obj->{'path'};
			if (-d $dir_path) {
				$dir_path = &NL::String::get_right($dir_path, $WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'}, 1);
				push @{$result_ERRORS}, {'TYPE' => 'ERROR', 'id' => 'INSTALL_DIRECTORY_EXISTS',
					'message' => $WC::c->{'APP_SETTINGS'}->{'name'}." has find a directory that should not exists\n(directory '$dir_path').",
					'info' => 'Try to remove that directory - then '.$WC::c->{'APP_SETTINGS'}->{'name'}.' can be installed.'};
				last;
			}
			else {
				if (!mkdir($dir_path)) {
					$dir_path = &NL::String::get_right($dir_path, $WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'}, 1);
					push @{$result_ERRORS}, {'TYPE' => 'ERROR', 'id' => 'INSTALL_DIRECTORY_UNABLE_CREATE',
						'message' => $WC::c->{'APP_SETTINGS'}->{'name'}." haven't permissions to create directory:\n'$dir_path'",
						'info' => $!};
					last;
				}
				else {
					# OK, created
					push @{$result_RM}, { 'type' => 'dir', 'path' => $dir_path };
				}
			}
		}
		# FILE
		elsif ($obj->{'id'} =~ /file_/) {
			my $file_path = $obj->{'path'};
			if (-f $file_path) {
				$file_path = &NL::String::get_right($file_path, $WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'}, 1);
				push @{$result_ERRORS}, {'TYPE' => 'ERROR', 'id' => 'INSTALL_FILE_EXISTS',
					'message' => $WC::c->{'APP_SETTINGS'}->{'name'}." has find a file that should not exists\n(file '$file_path').",
					'info' => 'Try to remove that file - then '.$WC::c->{'APP_SETTINGS'}->{'name'}.' can be installed.'};
				last;
			}
			else {
				my $isOK = 0;
				my $err_info = '';
				# Making file
				if (defined $obj->{'config_HASH'}) {
					if ($obj->{'id'} eq 'file_config') {
						if (&WC::Config::Main::save($obj->{'config_HASH'}) == 1) {
							$isOK = 1;
						}
						else { $err_info = &WC::Config::Main::get_last_error_TEXT(); }
					}
					else {
						if (&WC::Config::save($file_path, $obj->{'config_HASH'}, $obj->{'config_PARAM_NAME'}, $obj->{'config_NAME'}) == 1) {
							$isOK = 1;
						}
						else { $err_info = &WC::Config::get_last_error_TEXT(); }
					}
				}
				elsif (defined $obj->{'DATA'}) {
					if (&WC::File::save($file_path, $obj->{'DATA'}, { 'CHMOD' => (defined $obj->{'CHMOD'}) ? $obj->{'CHMOD'} : '' }) == 1) {
						$isOK = 1;
					}
					else { $err_info = &WC::File::get_last_error_TEXT(); }
				}
				# Checking result
				if (!$isOK) {
					$file_path = &NL::String::get_right($file_path, $WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'}, 1);
					push @{$result_ERRORS}, {'TYPE' => 'ERROR', 'id' => 'INSTALL_FILE_UNABLE_CREATE',
						'message' => $WC::c->{'APP_SETTINGS'}->{'name'}." haven't permissions to create file:\n'$file_path'",
						'info' => $err_info};
					last;
				}
				else {
					# OK, created
					push @{$result_RM}, { 'type' => 'file', 'path' => $file_path };
				}
			}
		}
	}
	# last step, if that is was testing (not installation) or we have errors - removing test directorys and files
	if ($is_SETTINGS->{'IS_TESTING'} || scalar @{ $result_ERRORS } > 0) {
		foreach my $obj_RM (reverse @{ $result_RM }) { # last created will be first removed
			if ($obj_RM->{'type'} eq 'file') {
				if (unlink($obj_RM->{'path'}) <= 0) {
					$obj_RM->{'path'} = &NL::String::get_right($obj_RM->{'path'}, $WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'}, 1);
					push @{$result_ERRORS}, {'TYPE' => 'ERROR', 'id' => 'INSTALL_FILE_UNABLE_DELETE',
						'message' => $WC::c->{'APP_SETTINGS'}->{'name'}." haven't permissions to delete file:\n'".$obj_RM->{'path'}."'",
						'info' => $!};
				}
			}
			elsif ($obj_RM->{'type'} eq 'dir') {
				if (!rmdir($obj_RM->{'path'})) {
					$obj_RM->{'path'} = &NL::String::get_right($obj_RM->{'path'}, $WC::Install::DATA->{'CONST'}->{'MAX_PATH_LENGTH_TO_SHOW'}, 1);
					push @{$result_ERRORS}, {'TYPE' => 'ERROR', 'id' => 'INSTALL_DIRECTORY_UNABLE_DELETE',
						'message' => $WC::c->{'APP_SETTINGS'}->{'name'}." haven't permissions to delete directory:\n'".$obj_RM->{'path'}."'",
						'info' => $!};
				}
			}
		}
	}
	return { 'ID' => (scalar @{ $result_ERRORS } > 0) ? 0 : 1, 'ERRORS' => $result_ERRORS };
}

1; #EOF
