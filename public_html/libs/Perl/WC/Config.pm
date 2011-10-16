#!/usr/bin/perl
# WC::Config - Web Console 'Config' module, contains config files manutulation methods
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Config::FILE; # Container for configs data
package WC::Config;
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
# IN: NOTHING
# RETURN: 1 - installed | 0 - not installed | -1 - 'file_config' is not defined
sub check_is_installed {
	if (defined $WC::c->{'config'}->{'file_config'} && $WC::c->{'config'}->{'file_config'} ne '') {
		return &is_exists($WC::c->{'config'}->{'file_config'});
	}
	else { return -1; }
}
# Checking is config file exists
# IN: STRING - file name
# RETURN: 1 - exists | 0 - not exists | -1 - ARG1 is not defined
sub is_exists {
	my ($in_config_file) = @_;

	if (defined $in_config_file && $in_config_file ne '') { return &NL::File::is_exists($in_config_file); }
	else { return -1; }
}
# Loading config
# IN: STRING - file name, STRING - config hash name, HASH_REF - save data to
# RETURN: 0 - error, file not found | 1 - ok, loaded | -1 - other error, see 'get_last_error()'
sub load {
	&_error_reset();
	my ($in_config_file, $in_str_hash_FROM, $in_ref_hash_TO) = @_;

	if (!defined $in_config_file || $in_config_file eq '') {
		&_error_set("WC::Config::load(): Input paremeter ARG1 is not defiend", "Incorrect call of 'WC::Config::load()'");
		return -1;
	}
	else {
		if (!-f $in_config_file) {
			&_error_set("WC::Config::load(): Config file '$in_config_file' not found", '', 'WC_CONFIG_LOAD_FILE_NOT_FOUND');
			return 0;
		}
		else {
			if( !&WC::File::lock_read($in_config_file, { 'timeout' => 10, 'time_sleep' => 0.1 }) ) {
				&_error_set("WC::Config::load(): Unable to lock file '$in_config_file' for reading", '', 'WC_CONFIG_LOAD_FILE_UNABLE_LOCK');
				return -1;
			}
			else {
				# OK, now file is locked
				eval { require $in_config_file; };
				&WC::File::unlock($in_config_file);
				if ($@) {
					# error, something wrong at config
					&_error_set('WC::Config::load(): Config syntax error', $@, 'WC_CONFIG_LOAD_EVAL_ERROR');
					return -1;
				}
				else {
					my $dir_temp = $in_ref_hash_TO->{'directorys'}->{'temp'};
                    my $dir_work = $in_ref_hash_TO->{'directorys'}->{'work'};
                    # ok, loaded
					# Merging loaded config and pre-defined configuration, pre-defined parameters will be replaced at config
					eval '&NL::Utils::hash_update($in_ref_hash_TO, '.$in_str_hash_FROM.') if defined '.$in_str_hash_FROM;
					$in_ref_hash_TO->{'directorys'}->{'temp'} = $dir_temp;
                    $in_ref_hash_TO->{'directorys'}->{'work'} = $dir_work;
					return 1;
				}
			}
		}
	}
}

# Saving config
# IN: STRING - file name, HASH_REF - data to save, STRING - config hash name, STRING - config name
# RETURN: 0 - unable to save, see 'get_last_error()' | 1 - ok, saved
sub save {
	&_error_reset();
	my ($in_FILE, $in_HASH_DATA, $in_PARAM_NAME, $in_CONFIG_NAME) = @_;
	$in_CONFIG_NAME = '_UNKNOWN_' if (!defined $in_CONFIG_NAME);

	if (!defined $in_FILE  || $in_FILE eq '') { &_error_set('WC::Config::save(): Incorrect call', 'Parameter 0 (config filename) is needed and can\'t be empty'); }
	elsif (!defined $in_HASH_DATA) { &_error_set('WC::Config::save(): Incorrect call', 'Parameter 1 (HASH with config data) is needed'); }
	elsif (!defined $in_PARAM_NAME || $in_PARAM_NAME eq '') { &_error_set('WC::Config::save(): Incorrect call', 'Parameter 2 (config parameter name) is needed and can\'t be empty'); }
	else {
		my $conf_text = &make_text($in_HASH_DATA, $in_PARAM_NAME, $in_CONFIG_NAME);
		if ($conf_text eq '') {
			&_error_set("WC::Config::save(): Unable to create config text for file '$in_FILE' (config name '".$in_CONFIG_NAME."')", "Looks like incorret call of 'WC::Config::save()'");
		}
		else {
			# Saving and making 'chmod' for execution permissions
			# If config will be requested via browser, web server will not show it like plain-text
			my $result = &WC::File::save($in_FILE, $conf_text, { 'CHMOD' => $WC::CONST->{'CHMODS'}->{'CONFIGS'} });
			if($result == 1) { return 1; }
			else { &_error_set(&WC::File::get_last_error_ARR()); }
		}
	}
	return 0;
}
# Preparing text for config file
# Config file looks like Perl script, so it can be included by any other Perl script
# IN: HASH_REF - data to save, STRING - config hash name, STRING - config name
# RETURN: STRING - text for config
sub make_text {
	my ($in_ref_hash_config, $in_config_param_name, $in_config_name) = @_;

	my $conf_text = '';
	my $conf_text_hash = &NL::String::VAR_to_PERL($in_ref_hash_config, { 'SPACES' => 1, 'SORT' => 1 });
	if ($conf_text_hash ne '') {
		$conf_text = '#!/usr/bin/perl'."\n";
		$conf_text .= "# This is Web Console ".( ($in_config_name ne '') ? "'$in_config_name' " : '' )."configuration file\n";
		$conf_text .= "# Web Console version: '".( (defined $WC::CONST->{'VERSION'}->{'NUMBER'}) ? $WC::CONST->{'VERSION'}->{'NUMBER'} : '_UNKNOWN_' )."'\n";
		$conf_text .= "# Edit this file manually is not recommended\n";
		$conf_text .= "#\n";
		$conf_text .= "# Web Console author: Kovalev Nick\n";
		$conf_text .= "# Web Console author's resume: http://resume.nickola.ru\n";
		$conf_text .= "#\n";
		$conf_text .= "# Web Console URL: http://www.web-console.org\n";
		$conf_text .= "# Last version of Web Console can be downloaded from: http://www.web-console.org/download/\n";
		$conf_text .= "# Web Console Group services: http://services.web-console.org\n";
		$conf_text .= "\n";
		$conf_text .= 'if (!defined $WC::ENGINE_LOADED || !$WC::ENGINE_LOADED) { print "Content-type: text/html; charset=utf-8\n\n"; exit; }'."\n\n";
		$conf_text .= $in_config_param_name.' = '.$conf_text_hash.";\n";
		$conf_text .= "\n1; #EOF";
	}
	return $conf_text;
}

1; #EOF
