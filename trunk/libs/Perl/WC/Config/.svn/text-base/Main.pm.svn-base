#!/usr/bin/perl
# WC::Config::Main - Web Console 'Config::Main' module, contains main config manutulation methods
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Config::Main;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# 'NL::Error' for error storage support
sub _error_reset { &NL::Error::reset(__PACKAGE__); }
sub _error_set { &NL::Error::set(__PACKAGE__, @_); }
sub get_last_error { &NL::Error::get(__PACKAGE__); }
sub get_last_error_ARR { &NL::Error::get_ARR(__PACKAGE__); }
sub get_last_error_ID { &NL::Error::get_id(__PACKAGE__); }
sub get_last_error_TEXT { &NL::Error::get_text(__PACKAGE__); }
sub get_last_error_INFO { &NL::Error::get_info(__PACKAGE__); }

# Checking is Web Console installed (is MAIN config exists)
sub IS_WEB_CONSOLE_INSTALLED { return &is_exists(); }
# Checking is MAIN config file exists
# IN: NOTHING
# RETURN: 1 - exists | 0 - not exists | -1 - VARIABLE is not defined
sub is_exists {
	if (defined $WC::c->{'config'}->{'files'}->{'config'} && $WC::c->{'config'}->{'files'}->{'config'} ne '') {
		return &NL::File::is_exists($WC::c->{'config'}->{'files'}->{'config'});
	}
	else { return -1; }
}
# Loading MAIN config
# IN: NOTHING
# RETURN: 0 - error, file not found | 1 - ok, loaded | -1 - other error, see 'get_last_error()'
sub load {
	&_error_reset();
	# Checking filename
	if (!defined $WC::c->{'config'}->{'files'}->{'config'} || $WC::c->{'config'}->{'files'}->{'config'} eq '') {
		&_error_set('Main '.$WC::c->{'APP_SETTINGS'}->{'name'}.' config filename is not defined', 'Looks very strange, are you shure that '.$WC::c->{'APP_SETTINGS'}->{'name'}.' has not been modified?');
		return -1;
	}
	# Loading
	my $result = &WC::Config::load($WC::c->{'config'}->{'files'}->{'config'}, '$WC::Config::FILE::CONFIG_MAIN', $WC::c->{'config'});
	if ($result != 1) {
		&_error_set("Unable to load config file '".$WC::c->{'config'}->{'files'}->{'config'}."'", &WC::Config::get_last_error_TEXT(), &WC::Config::get_last_error_ID());
		if ($result == 0) { return 0; }
		else { return -1; }
	}
	else { return 1; }
}
# Saving MAIN config
# IN: STRING - file name, HASH_REF - data to save, STRING - config hash name, STRING - config name
# RETURN: 0 - unable to save, see 'get_last_error()' | 1 - ok, saved
sub save {
	&_error_reset();
	my ($in_HASH_DATA) = @_;

	if (!defined $WC::c->{'config'}->{'files'}->{'config'}  || $WC::c->{'config'}->{'files'}->{'config'} eq '') { &_error_set('WC::Config::Main::save(): Unable to get config filename', 'Variable is not defined'); }
	elsif (!defined $in_HASH_DATA) { &_error_set('WC::Config::Main::save(): Incorrect call', 'Parameter 0 (HASH with config data) is needed'); }
	else {
		my $conf_NAME = 'MAIN';
		my $conf_PARAM_NAME = '$WC::Config::FILE::CONFIG_MAIN';
		my %config_NEW;
		&NL::Utils::hash_clone(\%config_NEW, &get_variables_defaults()); #$WC::c->{'config'});
		# Updating current settings with new data
		&NL::Utils::hash_update(\%config_NEW, $in_HASH_DATA);
		$config_NEW{'directorys'} = {} if (!defined $config_NEW{'directorys'});
		$config_NEW{'directorys'}->{'temp'} = $WC::c->{'config'}->{'directorys'}->{'temp'} if (!defined $config_NEW{'directorys'}->{'temp'} || $config_NEW{'directorys'}->{'temp'} eq '');
		$config_NEW{'directorys'}->{'work'} = $WC::c->{'config'}->{'directorys'}->{'work'} if (!defined $config_NEW{'directorys'}->{'work'} || $config_NEW{'directorys'}->{'work'} eq '');

		# Removing from settings DYMANIC data (that is generates automatically at startup)
		&NL::Parameter::remove(\%config_NEW, [
			'encodings|internal',
			'directorys_splitter',
			'directorys|home',
			'directorys|data',
			'directorys|configs',
			'directorys|plugins',
			'directorys|plugins_configs',
			'files'
		]);

		my $conf_text = &WC::Config::make_text(\%config_NEW, $conf_PARAM_NAME, $conf_NAME);
		if ($conf_text eq '') {
			&_error_set("WC::Config::Main::save(): Unable to create config text for file '".$WC::c->{'config'}->{'files'}->{'config'}."' (config name '".$conf_NAME."')", "Looks like incorret call of 'WC::Config::Main::save()'");
		}
		else {
			# Saving and making 'chmod' for execution permissions
			# If config will be requested via browser, web server will not show it like plain-text
			my $result = &WC::File::save($WC::c->{'config'}->{'files'}->{'config'}.'', $conf_text, { 'CHMOD' => $WC::CONST->{'CHMODS'}->{'CONFIGS'} });
			if($result == 1) { return 1; }
			else { &_error_set(&WC::File::get_last_error_ARR()); }
		}
	}
	return 0;
}
# Getting default config variables (with default values)
# IN: NOTHING
# RETURN: NOTHING
sub get_variables_defaults {
	my $default_CONFIG_HASH = {
		'encodings' => {
			'editor_text' => '',
			'server_console' => '',
			'server_system' => '',
			'file_download' => '',
			'internal' => 'utf8'
		},
		'logon' => {
			'javascript' => '',
			'show_welcome' => 1,
			'show_warnings' => 1

		},
		'directorys_splitter' => '/',
		'directorys' => {},
		'files' => {},
		'uploading' => {
			'limit' => 50
		},
		'styles' => {
			'console' => {
				'font' => {
					'color' => '#bbbbbb',
					'size' => '10pt',
					'family' => 'fixedsys, courier new, courier, verdana, helvetica, arial, sans-serif'
				}
			}
		}
	};
	# Setting dynamic data :: directorys
	# $default_CONFIG_HASH->{'directorys'}->{'home'} = &WC::Dir::get_current_dir();
	# Next is for mod_perl
	$default_CONFIG_HASH->{'directorys_splitter'} = &WC::Dir::get_dir_splitter();
	$default_CONFIG_HASH->{'directorys'}->{'home'} = $WC::c->{'APP_SETTINGS'}->{'dir_path'};
	$default_CONFIG_HASH->{'directorys'}->{'data'} = $default_CONFIG_HASH->{'directorys'}->{'home'}.$default_CONFIG_HASH->{'directorys_splitter'}.'wc_data';
	$default_CONFIG_HASH->{'directorys'}->{'work'} = $default_CONFIG_HASH->{'directorys'}->{'home'}.$default_CONFIG_HASH->{'directorys_splitter'}.'wc_work';
	$default_CONFIG_HASH->{'directorys'}->{'configs'} = $default_CONFIG_HASH->{'directorys'}->{'data'}.$default_CONFIG_HASH->{'directorys_splitter'}.'configs';
	$default_CONFIG_HASH->{'directorys'}->{'plugins'} = $default_CONFIG_HASH->{'directorys'}->{'data'}.$default_CONFIG_HASH->{'directorys_splitter'}.'plugins';
	$default_CONFIG_HASH->{'directorys'}->{'plugins_configs'} = $default_CONFIG_HASH->{'directorys'}->{'plugins'}.$default_CONFIG_HASH->{'directorys_splitter'}.'configs';
	$default_CONFIG_HASH->{'directorys'}->{'temp'} = $default_CONFIG_HASH->{'directorys'}->{'data'}.$default_CONFIG_HASH->{'directorys_splitter'}.'temp';
	# Setting dynamic data :: files
	$default_CONFIG_HASH->{'files'}->{'config'} = $default_CONFIG_HASH->{'directorys'}->{'configs'}.$default_CONFIG_HASH->{'directorys_splitter'}.'wc_config.pl';
	$default_CONFIG_HASH->{'files'}->{'users'} = $default_CONFIG_HASH->{'directorys'}->{'configs'}.$default_CONFIG_HASH->{'directorys_splitter'}.'wc_users.pl';
	$default_CONFIG_HASH->{'files'}->{'.HTACCESS'} = $default_CONFIG_HASH->{'directorys'}->{'home'}.$default_CONFIG_HASH->{'directorys_splitter'}.'.htaccess';
	return $default_CONFIG_HASH;
}
# Initializing default config variables (with default values)
# IN: NOTHING
# RETURN: NOTHING
sub init_variables_defaults { $WC::c->{'config'} = &get_variables_defaults(); }

1; #EOF
