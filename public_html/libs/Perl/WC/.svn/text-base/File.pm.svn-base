#!/usr/bin/perl
# WC::File - Web Console 'File' module, contains methods for files manipulations
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::File;
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

# Initialization of 'WC::File' locking system, called always first before locking
# IN: STRING - directory for lock files
# RETURN: 1 - OK | 0 - NOT OK, see 'get_last_error()'
sub lock_init {
	&_error_reset();
	my ($in_DIR, $in_DONT_REMOVE_FILES) = @_;
	$in_DONT_REMOVE_FILES = 0 if (!defined $in_DONT_REMOVE_FILES);
	if (!defined $in_DIR) {
		&_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' temp directory is not defined', "Uncorrect call of method 'WC::File::lock_init()'", 'WC_FILE_LOCK_INIT_DIR_TMP_NOT_DEFINED');
		return 0;
	}

	my $dir_TMP = '';
	# Defining TMP directory
    if ($in_DIR ne '' && -d $in_DIR) { $dir_TMP = $in_DIR; }
	# 'NL::File::Lock' initialization
	if ($dir_TMP ne '') {
		# if (&NL::File::Lock::init($dir_TMP, { 'REMOVE_OLD' => 1 })) {
		if (&NL::File::Lock::init($dir_TMP)) {
			if (!$in_DONT_REMOVE_FILES) {
				&NL::Dir::remove_old_files($dir_TMP, {
						'SECONDS_OLD' => 3600*24, # 3600 = 1 hour
						'SKIP_FILES' => ['.htaccess', 'index.html']
					});
			}
			return 1;
		}
		else { &_error_set("Unable to initialize 'NL::File::Lock'", 'Hm... that is strange...', 'FILE_INIT_TMP_NL_UNABLE'); }
	}
	else { &_error_set($WC::c->{'APP_SETTINGS'}->{'name'}.' temp directory &quot;<b>'.$in_DIR.'</b>&quot; does not exists', 'Are you shure that '.$WC::c->{'APP_SETTINGS'}->{'name'}.' temp directory has not been removed?', 'WC_FILE_LOCK_INIT_DIR_TMP_NOT_FOUND'); }
	return 0;
}
# Getting file size
# IN: STRING - file name
# RETURN: >= 0 - size | -1 - error, see 'get_last_error()'
sub get_size {
	my ($file) = @_;
	$file = '' if (!defined $file);

	my $size = &NL::File::get_size($file);
	if ($size >= 0) { return $size; }
	elsif ($size == -1) { &_error_set("WC::File::get_size(): Unable to get size of the file", 'Filename is not defined or it is empty', 'WC_FILE_GET_SIZE_NO_FILENAME'); }
	elsif ($size == -2) { &_error_set("WC::File::get_size(): Unable to get size of the file '$file'", "File '$file' does not exists", 'WC_FILE_GET_SIZE_NO_FILE_FOUND'); }
	elsif ($size == -3) { &_error_set("WC::File::get_size(): Unable to get size of the file '$file'", 'Information about file does not contain file size', 'WC_FILE_GET_SIZE_NO_SIZE_INFO'); }
	else { &_error_set("WC::File::get_size(): Unable to get size of file '$file'"); }
	return -1;
}
# Getting file name
# IN: STRING - full file path or name
# RETURN: STRING - file name
sub get_name {
	my ($file) = @_;
	return '' if (!defined $file);

	my ($main, $extra) = &WC::Dir::get_dir_splitters();
	foreach my $splitter ($main, @{ $extra }) {
		my $qms = quotemeta($splitter);
		$file =~ s/^.*[$qms]([^$qms]{0,})$/$1/;
	}
	return $file;
}
# Getting directory name
# IN: STRING - full file path or name
# RETURN: STRING - directory nam
sub get_dir {
	my ($file) = @_;
	return '' if (!defined $file);

	my ($main, $extra) = &WC::Dir::get_dir_splitters();
	foreach my $splitter ($main, @{ $extra }) {
		my $qms = quotemeta($splitter);
		$file =~ s/(^.*)[$qms][^$qms]{0,}$/$1/;
	}
	return $file;
}
# Locking wrappers
#sub lock_read { return &NL::File::Lock::lock_read(@_); }
#sub lock_write { return &NL::File::Lock::lock_write(@_); }
sub lock_read { return 1; }
sub lock_write { return 1; }
sub unlock { return &NL::File::Lock::unlock(@_); }
# Saving file
# IN: STRING - file name, STRING - text to file, STRING - chmod value if needed
# RETURN: 0 - error, unable to open file | 1 - ok, saved | -1 - other error, see 'get_last_error()'
sub save {
	&_error_reset();
	my ($in_config_file, $in_text, $in_settings) = @_;
	$in_settings = {} if (!defined $in_settings);

	# Checking parameters
	if (!defined $in_config_file || $in_config_file eq '') {
		&_error_set('WC::File::save(): File name is not specified', 'Incorrect call of function', 'WC_FILE_SAVE_NO_FILE_NAME');
		return -1;
	}
	if (!defined $in_text) {
		&_error_set('WC::File::save(): File DATA is not specified', 'Incorrect call of function', 'WC_FILE_SAVE_NO_FILE_DATA');
		return -1;
	}
	# Saving
	if( !&lock_write($in_config_file, { 'timeout' => 15, 'time_sleep' => 0.1 } ) ) {
		&_error_set("WC::File::save(): Unable to lock file '$in_config_file' for writing", 'Please ensure that filename is correct and locking system is configured correctry', 'WC_FILE_SAVE_UNABLE_LOCK');
		return -1;
	}
	else {
		if (!open(FH_CONFIG, '>'.$in_config_file)) {
			&_error_set("WC::File::save(): Unable to open file '$in_config_file' for writing (file is successfully locked)", $!, 'WC_FILE_SAVE_UNABLE_OPEN_BUT_LOCKED');
			return 0;
		}
		else {
			binmode FH_CONFIG if (defined $in_settings->{'BINMODE'} && $in_settings->{'BINMODE'});
			print FH_CONFIG $in_text;
			truncate (FH_CONFIG, tell FH_CONFIG); # if new size is less than old, that is not needed for '>', but it's will be not bad
			close (FH_CONFIG);
			&unlock($in_config_file);
			# Making 'chmod' if needed
			chmod(oct($in_settings->{'CHMOD'}), $in_config_file) if (defined $in_settings->{'CHMOD'} && $in_settings->{'CHMOD'} ne '');
		}
	}
	return 1;
}

1; #EOF
