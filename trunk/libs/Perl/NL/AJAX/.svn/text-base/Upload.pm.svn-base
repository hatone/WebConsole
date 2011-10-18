#!/usr/bin/perl
# NL::AJAX::Upload - mostNeeded Libs :: Library for multi-file AJAX uploading (progress-bar supported)
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: REVISION NEEDED

package NL::AJAX::Upload;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# INTERNAL DATA
$NL::AJAX::Upload::CGI_PM_LOADED = 0;
$NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK = 0;
$NL::Upload::DATA = {
	'CONST' => {},
	'DYNAMIC' => {
		# MAIN DATA
		'POST_MAX' => 1024 * (1024 * 1024), # MAX UPLOAD SIZE: 1024 MB
		'DIR_TEMP' => '',
		# UPLOAD DATA
		'UPLOAD' => {
			'SID' => '',
			'METHOD' => '',
			'STATUS' => {
				'file_name' => '',
				'file_handle' => undef,
				'file_locked' => 0,
				'file_locked_time' => 0,
				'INFO' => {
					'status' => 'UPLOADING',
					'file_current_name' => '',
					'file_current_number' => 0,
					'size_current' => 0,
					'size_total' => 0,
					'time_start' => 0
				}
			},
			'FILES' => {},
			'TEMP' => {}
		}
	},
	'ACTIVE_OBJECT' => {} # For 'END'
};

# INITIALIZATION (THIS MODULE MUST BE INITIALIZED BEFORE USAGE)
# During initialization module 'CGI.pm' will be loaded
sub init {
	my ($in_SETTINGS) = @_;
	$in_SETTINGS = {} if (!defined $in_SETTINGS);

	# Setting values from INPUT
	$NL::Upload::DATA->{'DYNAMIC'}->{'POST_MAX'} = $in_SETTINGS->{'POST_MAX'} if (defined $in_SETTINGS->{'POST_MAX'} && $in_SETTINGS->{'POST_MAX'} > 0);
	$NL::Upload::DATA->{'DYNAMIC'}->{'DIR_TEMP'} = $in_SETTINGS->{'DIR_TEMP'} if (defined $in_SETTINGS->{'DIR_TEMP'} && $in_SETTINGS->{'DIR_TEMP'} ne '');

	# Loading 'CGI.pm' module
	my $INIT_RESULT = { 'ID' => 1, 'ERROR_MSG' => '' };
	eval { require CGI; };
	if ($@) {
		# 'CGI.pm' module is not loaded
		$INIT_RESULT = { 'ID' => 0, 'ERROR_MSG' => "Unable to load module 'CGI.pm', that module is needed for uploading:\n$@" };
	}
	else {
		# 'CGI.pm' module is loaded
		$NL::AJAX::Upload::CGI_PM_LOADED = 1;
		$NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK = $CGI::VERSION >= 3.03 ? 1 : 0;
		# Setting 'POST_MAX'
		$CGI::POST_MAX = $NL::Upload::DATA->{'DYNAMIC'}->{'POST_MAX'};
	}
	# Returning result
	return $INIT_RESULT;
}

# UPLOADING
# Before calling this method, should be maked 'chdir' to the directory where we will save uploaded files
sub start_upload {
	my ($in_SETTINGS, $in_PARAMETERS) = @_;
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_PARAMETERS = {} if (!defined $in_PARAMETERS);

	# Preparing default result
	my $UPLOAD_RESULT = { 'ID' => 0, 'UPLOADS' => {}, 'ERROR_MSG' => '' };

	# Getting needed values
	my $DIR_TEMP = $NL::Upload::DATA->{'DYNAMIC'}->{'DIR_TEMP'};
	my $POST_MAX = $NL::Upload::DATA->{'DYNAMIC'}->{'POST_MAX'};
	if (defined $in_SETTINGS->{'DIR_TEMP'} && $in_SETTINGS->{'DIR_TEMP'} ne '') { $DIR_TEMP = $in_SETTINGS->{'DIR_TEMP'}; }
	if (defined $in_SETTINGS->{'POST_MAX'} && $in_SETTINGS->{'POST_MAX'} > 0) {
		$POST_MAX = $in_SETTINGS->{'POST_MAX'};
		$CGI::POST_MAX = $POST_MAX if ($NL::AJAX::Upload::CGI_PM_LOADED);
	}

	# Checking parameters
	if (!defined $in_SETTINGS->{'SID'} || $in_SETTINGS->{'SID'} eq '') {
		$UPLOAD_RESULT->{'ERROR_MSG'} = '"SID" is not specified, unable to start uploading';
	}
	elsif ($DIR_TEMP ne '' && !-d $DIR_TEMP) {
		$UPLOAD_RESULT->{'ERROR_MSG'} = 'TEMP directory "'.&NL::String::get_right($DIR_TEMP, 40, 1).'" not found';
	}
	elsif (!defined $ENV{'CONTENT_LENGTH'}) {
		$UPLOAD_RESULT->{'ERROR_MSG'} = '"CONTENT_LENGTH" is not defined';
	}
	elsif ($ENV{'CONTENT_LENGTH'} > $POST_MAX) {
		$UPLOAD_RESULT->{'ERROR_MSG'} = "You tried to send ".&NL::String::get_str_of_bytes($ENV{'CONTENT_LENGTH'}).", but the current limit is ".&NL::String::get_str_of_bytes($POST_MAX).".\nPlease choose a smaller file(s).";
	}
	# If that is not OK - returning
	if ($UPLOAD_RESULT->{'ERROR_MSG'} ne '') { return $UPLOAD_RESULT; }

	# Making 'DIR_TEMP' good, adding tailing splitter
	if ($DIR_TEMP ne '') {
		my $dir_splitter = &NL::Dir::get_dir_splitter();
		$DIR_TEMP .= $dir_splitter if ($DIR_TEMP !~ /${dir_splitter}$/);
	}

	# Making new uploading DATA CONTAINER
	my $DATA_CONTAINER = {};
	&NL::Utils::hash_clone($DATA_CONTAINER, $NL::Upload::DATA->{'DYNAMIC'});
	$DATA_CONTAINER->{'POST_MAX'} = $POST_MAX;
	$DATA_CONTAINER->{'DIR_TEMP'} = $DIR_TEMP;
	$DATA_CONTAINER->{'UPLOAD'}->{'SID'} = $in_SETTINGS->{'SID'};
	$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'time_start'} = time();
	$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_total'} = $ENV{'CONTENT_LENGTH'};
	$DATA_CONTAINER->{'UPLOAD'}->{'TEMP'}->{'STATUS_UPDATE_SIZE_INTERVAL'} = $ENV{'CONTENT_LENGTH'} * 0.05; # 5% of 'CONTENT_LENGTH'

	# Setting 'ACTIVE_OBJECT'
	$NL::Upload::DATA->{'ACTIVE_OBJECT'} = $DATA_CONTAINER;

	# OK, starting uploading
	my $OLD_STDIN = undef;
	if ($NL::AJAX::Upload::CGI_PM_LOADED) {
		my $CGI_QUERY;
		# Setting TEMP directory for 'CGI.pm'
		if ($DIR_TEMP ne '') {
			if (defined $TempFile::TMPDIRECTORY && $TempFile::TMPDIRECTORY) { $TempFile::TMPDIRECTORY = $DIR_TEMP; }
			elsif (defined $CGITempFile::TMPDIRECTORY && $CGITempFile::TMPDIRECTORY) { $CGITempFile::TMPDIRECTORY = $DIR_TEMP; }
		}
		if ($NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK) {
			# 'CGI.pm' hook supported
			$DATA_CONTAINER->{'UPLOAD'}->{'METHOD'} = 'STATUS_FILE';
			$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'file_name'} = $DIR_TEMP.&status_filename_make($in_SETTINGS->{'SID'});
			$CGI_QUERY = CGI->new(\&NL::AJAX::Upload::CGI_hook, { 'DATA_CONTAINER' => $DATA_CONTAINER, 'FUNC_SAVE' => \&status_save });
			# Saving to STATUS that uploading is finished
			&status_save($DATA_CONTAINER, 1);
			sleep(3);
			$UPLOAD_RESULT->{'UPLOADS'} = &CGI_process_uploads($CGI_QUERY, $in_PARAMETERS);
			$UPLOAD_RESULT->{'INFO'} = &make_upload_info($DATA_CONTAINER, $in_PARAMETERS);

			$UPLOAD_RESULT->{'ID'} = 1;
			# Files uploaded, closing status file
			return $UPLOAD_RESULT;
			&status_close($DATA_CONTAINER);
		}
		else {
			# 'CGI.pm' hook unsupported
			$DATA_CONTAINER->{'UPLOAD'}->{'METHOD'} = 'POST_FILE';
			$DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'file_name'} = $DIR_TEMP.&status_filename_make_RAW($DATA_CONTAINER->{'UPLOAD'}->{'SID'}, $ENV{'CONTENT_LENGTH'}, $DATA_CONTAINER->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'time_start'});
			my $MANUAL_HOOK_RESULT = &CGI_hook_manual($DATA_CONTAINER);
			if ($MANUAL_HOOK_RESULT->{'ID'}) {
				my $file_RAW_POST = $MANUAL_HOOK_RESULT->{'FILE_NAME'};
				# Re-open 'RAW_POST' file on STDIN - 'CGI.pm' will process it
				if (!&NL::File::Lock::lock_read($file_RAW_POST, { 'timeout' => 10, 'time_sleep' => 0.1 } )) {
					$UPLOAD_RESULT->{'ERROR_MSG'} = "Can't lock RAW_POST_DATA file ".&NL::String::get_right($file_RAW_POST, 40, 1)." for reading";
					return $UPLOAD_RESULT;
				}
				open(OLDIN,  "<&STDIN") or return { 'ID' => 0, 'UPLOADS' => {}, 'ERROR_MSG' => "Can't save original STDIN handle: $!" };
				open(STDIN, "<$file_RAW_POST") or return { 'ID' => 0, 'UPLOADS' => {}, 'ERROR_MSG' => "Can't open RAW_POST_DATA file ".&NL::String::get_right($file_RAW_POST, 40, 1)." on STDIN: $!" };
				# binmode STDIN;
				seek(STDIN, 0, 0);
				$CGI_QUERY = new CGI();
				$UPLOAD_RESULT->{'UPLOADS'} = &CGI_process_uploads($CGI_QUERY, $in_PARAMETERS);
				$UPLOAD_RESULT->{'INFO'} = &make_upload_info($DATA_CONTAINER, $in_PARAMETERS);
				$UPLOAD_RESULT->{'ID'} = 1;
				close(STDIN);
				open(STDIN, "<&OLDIN") or return { 'ID' => 0, 'UPLOADS' => {}, 'ERROR_MSG' => "Can't open original STDIN handle: $!" };
				close(OLDIN);
				# Removing 'RAW_POST' file and unlocking it
				unlink($file_RAW_POST);
				&NL::File::Lock::unlock($file_RAW_POST);
			}
			else { $UPLOAD_RESULT->{'ERROR_MSG'} = $MANUAL_HOOK_RESULT->{'ERROR_MSG'}; }
		}
	}
	else {
		$UPLOAD_RESULT->{'ERROR_MSG'} = "Module 'CGI.pm' is not loaded";
		return $UPLOAD_RESULT;

		# TODO: Uploading without 'CGI.pm'
		my $MANUAL_HOOK_RESULT = &CGI_hook_manual($DATA_CONTAINER);
		if ($MANUAL_HOOK_RESULT->{'ID'}) {
			my $file_RAW_POST = $MANUAL_HOOK_RESULT->{'FILE_NAME'};
			if (!&NL::File::Lock::lock_read($file_RAW_POST, { 'timeout' => 10, 'time_sleep' => 0.1 } )) {
				return { 'ID' => 0, 'ERROR_MSG' => "Can't lock RAW_POST_DATA file ".&NL::String::get_right($file_RAW_POST, 40, 1)." for reading" };
			}
			# TODO
			# &process_uploads($CGI_QUERY);

			# Removing 'RAW_POST' file and unlocking it
			unlink($file_RAW_POST);
			&NL::File::Lock::unlock($file_RAW_POST);
		}
		else { $UPLOAD_RESULT->{'ERROR_MSG'} = $MANUAL_HOOK_RESULT->{'ERROR_MSG'}; }
	}

	# OK, DONE
	return $UPLOAD_RESULT;
}

# HOOKS
# HOOKS :: 'CGI.pm' hook
sub CGI_hook {
	my ($filename, $buffer, $bytes_read, $ref_DATA) = @_;

	if (defined $filename && $filename ne '' && defined $ref_DATA && defined $ref_DATA->{'DATA_CONTAINER'} && defined $ref_DATA->{'FUNC_SAVE'}) {
		if (defined $ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'} && defined $ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}) {
			my $in_FILENAME = &CGI_process_uploads_GET_FILE_NAME($filename);
			if (!defined $ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}->{ $in_FILENAME } ||
			     $bytes_read > $ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}->{ $in_FILENAME }) {
				# Updating uploading DATA
				$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}->{ $in_FILENAME } = $bytes_read;
				$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'file_current_name'} = $in_FILENAME;
				$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'file_current_number'} = 0;
				$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'} = 0;
				map {
					$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'} += $ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'}->{ $_ };
					$ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'file_current_number'}++;
				} (keys %{ $ref_DATA->{'DATA_CONTAINER'}->{'UPLOAD'}->{'FILES'} });
				# Calling function for saving status
				&{ $ref_DATA->{'FUNC_SAVE'} }($ref_DATA->{'DATA_CONTAINER'});
			}
		}
	}
}
# HOOKS :: manual hook implementation
sub CGI_hook_manual {
	my ($ref_DATA) = @_;
	$ref_DATA = {} if (!defined $ref_DATA);

	my $buffer_size = 81920; # reading buffer size
	my $file_name = $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'};

	if (-f $file_name) { return { 'ID' => 0, 'ERROR_MSG' => "Manual uploading HOOK file ".&NL::String::get_right($file_name, 40, 1)." already exists" }; }
	# Locking file
	if (!&NL::File::Lock::lock_write($file_name, { 'timeout' => 10, 'time_sleep' => 0.1 } )) {
		return { 'ID' => 0, 'ERROR_MSG' => "Can't lock uploading HOOK file ".&NL::String::get_right($file_name, 40, 1)." for reading" };
	}
	# Setting 'file_name' to 'DATA_CONTAINER'
	$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'} = $file_name;

	# Opening and saving file (needed for some OS)
	open(RAW_DATA, ">$file_name") or return { 'ID' => 0, 'ERROR_MSG' => "Can't open file ".&NL::String::get_right($file_name, 40, 1)." for WRITING: $!" };
	close RAW_DATA or return { 'ID' => 0, 'ERROR_MSG' => "Can't close file ".&NL::String::get_right($file_name, 40, 1).": $!" };

	# OK, re-opening file and reading STDIN
	open(RAW_DATA, "+<$file_name") or return { 'ID' => 0, 'ERROR_MSG' => "Can't open file ".&NL::String::get_right($file_name, 40, 1)." for READING/WRITING: $!" };
	binmode RAW_DATA;
	my $raw_FILEHANDLE = \*RAW_DATA; # Perl don't accept "open(my $fh)"
	flock($raw_FILEHANDLE, 2);
	seek($raw_FILEHANDLE, 0, 0);
	select((select($raw_FILEHANDLE), $| = 1)[0]);
	my $DO_READ = 1;
	my $bytes_total = $ENV{'CONTENT_LENGTH'};
	my $bytes_done = 0;
	my $buffer;

	while($DO_READ && $bytes_done < $bytes_total) {
		my $bytes_read += read(STDIN, $buffer, $buffer_size);
		if (!defined $bytes_read || $bytes_read <= 0) { $DO_READ = 0; }
		else {
			$bytes_done += $bytes_read;
			select(undef, undef, undef, 0.05);  # see "perldoc -f select"
			# Writing
			print $raw_FILEHANDLE $buffer;
		}
	}
	truncate($raw_FILEHANDLE, tell $raw_FILEHANDLE);
	close $raw_FILEHANDLE or return { 'ID' => 0, 'ERROR_MSG' => "Can't write POST DATA to file ".&NL::String::get_right($file_name, 40, 1).": $!" };
	if ($bytes_done < $bytes_total) {
		# NOT OK
		unlink($file_name);
		&NL::File::Lock::unlock($file_name);
		return { 'ID' => 0, 'ERROR_MSG' => "We have read lesser then 'CONTENT_LENGTH' (client cancelled uploading?)" };
	}
	else {
		# OK
		&NL::File::Lock::unlock($file_name);
		return { 'ID' => 1, 'FILE_NAME' => $file_name };
	}
}

# STATUS PROCESSING
# STATUS PROCESSING :: FILENAMES
sub status_filename_make { return 'up_stat_'.$_[0].'.txt'; }
sub status_filename_make_RAW { return 'up_raw_'.$_[0].'_L_'.$_[1].'_T_'.$_[2].'.txt'; }
# STATUS PROCESSING :: PARAMETERS PREPARING
sub status_parameters_decode { return &NL::String::re_replace($_[0], [{qr/&#124;/ => '\|'}, {qr/&amp;/ => '&'}]); }
sub status_parameters_encode { return &NL::String::re_replace($_[0], [{qr/&/ => '&amp;'}, {qr/\|/ => '&#124;'}]); }
sub status_line_make {
	my ($ref_HASH) = @_;
	return join('|', map { $_.':'.( &status_parameters_encode( $ref_HASH->{$_} ) ); } sort keys %{ $ref_HASH });
}
sub status_line_parse {
	my ($str) = @_;
	my %hash_result = map { $1 => &status_parameters_decode($2) if ($_ =~ /^([^\:]+):(.*)$/); } split(/\|/, $str);
	return \%hash_result;
}
# STATUS PROCESSING :: SAVING
sub status_save {
	my ($ref_DATA, $in_IS_FINISHED) = @_;
	$ref_DATA = {} if (!defined $ref_DATA);
	$in_IS_FINISHED = 0 if (!defined $in_IS_FINISHED);

	if (!$in_IS_FINISHED) {
		# Checking if we need to save status
		if (defined $ref_DATA->{'UPLOAD'}->{'TEMP'}->{'SAVED_SIZE_CURRENT'} && $ref_DATA->{'UPLOAD'}->{'TEMP'}->{'SAVED_SIZE_CURRENT'} > 0) {
			my $size_diff = $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'} - $ref_DATA->{'UPLOAD'}->{'TEMP'}->{'SAVED_SIZE_CURRENT'};
			if ($size_diff < $ref_DATA->{'UPLOAD'}->{'TEMP'}->{'STATUS_UPDATE_SIZE_INTERVAL'}) {
				# OK, size is too short
				if (time() - $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked_time'} < 5) {
					return { 'ID' => 1, 'ERROR_MSG' => 'No saving needed' };
				}
			}
		}
	}
	else {
		$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'status'} = 'FINISHED';
		$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'} = $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_total'};
		$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'file_current_name'} = '';
	}

	# Generating status line now, before file is locked
	my $LINE_STATUS = &status_line_make($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'});

	my $file_name = $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'};
	my $file_ready_state = 0; # not opened
	if (!$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'}) {
		# We need open status file
		if (-f $file_name) { return { 'ID' => 0, 'ERROR_MSG' => "'CGI.pm' uploading HOOK file ".&NL::String::get_right($file_name, 40, 1)." already exists" }; }
		if (&NL::File::Lock::lock_write($file_name, { 'timeout' => 20, 'time_sleep' => 0.1 } )) {
			if (open(STATUS_FH, ">$file_name")) {
				# OK, opened and locked
				if (close(STATUS_FH)) {
					if(open(STATUS_FH, "+<$file_name")) {
						# OK, locked and opened for READING/WRITING
						# Perl will flush the buffer every time we print to STATUS_FH, so messages will appear in the log file as soon as we print them
						my $fh = \*STATUS_FH;
						select((select($fh), $| = 1)[0]);
						$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'} = $fh;
						$file_ready_state = 2; # Opened, and locked
					}
					else {
						# hm... we unable to open saved file
						&NL::File::Lock::unlock($file_name);
						return { 'ID' => 0, 'ERROR_MSG' => "Unable to open file ".&NL::String::get_right($file_name, 40, 1)." for READING/WRITING: $!" };
					}
				}
				else {
					&NL::File::Lock::unlock($file_name);
					return { 'ID' => 0, 'ERROR_MSG' => "Unable to close (write) file ".&NL::String::get_right($file_name, 40, 1).": $!" };
				}
			}
			else {
				# hm... we unable to open file
				&NL::File::Lock::unlock($file_name);
				return { 'ID' => 0, 'ERROR_MSG' => "Unable to open (create) file ".&NL::String::get_right($file_name, 40, 1).": $!" };
			}
		}
		else {
			return { 'ID' => 0, 'ERROR_MSG' => "Unable to lock file ".&NL::String::get_right($file_name, 40, 1)." for WRITING: $!" };
		}
	}
	else {
		$file_ready_state = 1; # Opened, but not locked
	}

	if ($file_ready_state <= 0) { return { 'ID' => 0, 'ERROR_MSG' => "Unknown error, 'file_ready_state' = $file_ready_state" }; }
	else {
		if ($file_ready_state <= 1 && !$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked'}) {
			if (!&NL::File::Lock::lock_write($file_name, { 'timeout' => 10, 'time_sleep' => 0.05 } )) {
				return { 'ID' => 0, 'ERROR_MSG' => "Unable to lock file ".&NL::String::get_right($file_name, 40, 1)." for WRITING (file was opened before): $!" };
			}
 		}
		# OK, now we have opened file and we can write data to it
		my $STATUS_FH = $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'};
		seek($STATUS_FH, 0, 0); # seeking to the begining
		print $STATUS_FH $LINE_STATUS;
		truncate($STATUS_FH, tell $STATUS_FH);
		$ref_DATA->{'UPLOAD'}->{'TEMP'}->{'SAVED_SIZE_CURRENT'} = $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_current'};

		# Checking if wee need to unlock file
#		my $sec_to_unlock = 1;
#		my $now = time();
#		if ($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked_time'} <= 0 || $now - $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked_time'} >= $sec_to_unlock) {
			# Unlock is needed
#			$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked_time'} = $now;
#			&NL::File::Lock::unlock($file_name);
#			$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked'} = 0;
#		}
#		else {
#			$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked'} = 1;
#		}

		if ($in_IS_FINISHED) {
			close($STATUS_FH);
			$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'} = undef;
		}
		$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked_time'} = time();
		&NL::File::Lock::unlock($file_name);
		#$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked'} = 0;

		# OK, STATUS saved
		return { 'ID' => 1, 'ERROR_MSG' => '' };
	}
}
# STATUS PROCESSING :: CLOSING HOOK STATUS FILE
sub status_close {
	my ($ref_DATA) = @_;
	$ref_DATA = {} if (!defined $ref_DATA);

	if ($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'}) {
		my $STATUS_FH = $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'};
		if ($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_locked'}) {
			close($STATUS_FH);
			unlink($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});
			&NL::File::Lock::unlock($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});
		}
		else {
			# &NL::File::Lock::lock_write($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'}, { 'timeout' => 15, 'time_sleep' => 0.1 } );
			close($STATUS_FH);
			unlink($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});
			# &NL::File::Lock::unlock($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});
		}
		$ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_handle'} = undef;
	}
	elsif (defined $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'} && $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'} ne '') {
		unlink($ref_DATA->{'UPLOAD'}->{'STATUS'}->{'file_name'});
	}
}
# STATUS PROCESSING :: READING
sub status_read {
	my ($file_name) = @_;

	my $result = { 'ID' => 0, 'HASH' => {} };
	my @arr_status_file = ();
	if (defined $file_name && -f $file_name) {
		if (&NL::File::Lock::lock_read($file_name, { 'timeout' => 3, 'time_sleep' => 0.05 })) {
			if (open(STATUS_FH, "<$file_name")) {
				@arr_status_file = <STATUS_FH>;
				close(STATUS_FH);
				&NL::File::Lock::unlock($file_name);
			}
			else {
				&NL::File::Lock::unlock($file_name);
				return { 'ID' => 0, 'ERROR_MSG' => "Unable to open file ".&NL::String::get_right($file_name, 40, 1)." for READING: $!" };
			}
		}
		else {
			return { 'ID' => 0, 'ERROR_MSG' => "Unable to lock file ".&NL::String::get_right($file_name, 40, 1)." for READING: $!" };
		}
	}
	else {
		my $err_msg = '';
		if (!defined $file_name) { $err_msg = "No file specified"; }
		else { $err_msg = "File ".&NL::String::get_right($file_name, 40, 1)." does not exists"; }
		return { 'ID' => 0, 'ERROR_MSG' => $err_msg };
	}
	# OK, file opened, data loaded
	my $data_is_EXISTS = 0;
	my $data_HASH = {};
	if (scalar @arr_status_file > 0) {
		foreach (@arr_status_file) {
			$_ =~ s/^[\n\r]+//;
			$_ =~ s/[\n\r]+$//;
			# at file should be only one line
			if ($_ ne '') {
				$data_is_EXISTS = 1;
				$data_HASH = &status_line_parse($_);
				last;
			}
		}

	}
	if (!$data_is_EXISTS) {
		# hm... no text inside file
		return { 'ID' => 0, 'ERROR_MSG' => "File ".&NL::String::get_right($file_name, 40, 1)." does not contain TEXT DATA" };
	}
	else {
		# OK
		return { 'ID' => 1, 'STATUS' => $data_HASH, 'ERROR_MSG' => '' };
	}
}
# STATUS PROCESSING :: GETTING
sub status_get {
	my ($in_SID, $in_SETTINGS) = @_;
	$in_SID = '' if (!defined $in_SID);
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'METHOD'} = '' if (!defined $in_SETTINGS->{'METHOD'});

	my $RESULT = { 'ID' => 0, 'ERROR_MSG' => '', 'STATUS' => '', 'METHOD' => '' };
	if ($in_SID eq '') { $RESULT->{'ERROR_MSG'} = "No 'SID' specified"; return $RESULT; }
	# Defining method
	if ($in_SETTINGS->{'METHOD'} !~ /^(STATUS_FILE|POST_FILE)$/) {
		if ($NL::AJAX::Upload::CGI_PM_LOADED && $NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK) { $in_SETTINGS->{'METHOD'} = 'STATUS_FILE'; }
		else { $in_SETTINGS->{'METHOD'} = 'POST_FILE'; }
	}
	$RESULT->{'METHOD'} = $in_SETTINGS->{'METHOD'};
	# Getting needed values
	my $DIR_TEMP = $NL::Upload::DATA->{'DYNAMIC'}->{'DIR_TEMP'};
	if (defined $in_SETTINGS->{'DIR_TEMP'} && $in_SETTINGS->{'DIR_TEMP'} ne '') { $DIR_TEMP = $in_SETTINGS->{'DIR_TEMP'}; }
	# Making 'DIR_TEMP' good, adding tailing splitter
	if ($DIR_TEMP ne '') {
		my $dir_splitter = &NL::Dir::get_dir_splitter();
		$DIR_TEMP .= $dir_splitter if ($DIR_TEMP !~ /${dir_splitter}$/);
	}

	# Getting DATA
	my $hash_STATUS = {};
	if ($in_SETTINGS->{'METHOD'} eq 'STATUS_FILE') {
		# STATUS_FILE
		my $filename = $DIR_TEMP.&status_filename_make($in_SID);
		my $status_read_RESULT = &status_read($filename);
		if ($status_read_RESULT->{'ID'}) { $hash_STATUS = $status_read_RESULT->{'STATUS'}; }
		else { $RESULT->{'ERROR_MSG'} = $status_read_RESULT->{'ERROR_MSG'}; return $RESULT; }
	}
	else {
		# POST_FILE
		# Getting listing
		my $DIR_OPEN = $DIR_TEMP ne '' ? $DIR_TEMP : '.';
		if (opendir(DIR, $DIR_OPEN)) {
			my $is_OK = 0;
			my $SIDQM = quotemeta($in_SID);
			my @arr_listing = grep(/^up_raw_$SIDQM.*\.txt$/, readdir(DIR));
			closedir (DIR);
			if (scalar @arr_listing == 1) {
				my $file_name = $DIR_TEMP.$arr_listing[0];
				if (-f $file_name) {
					my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size, $atime, $mtime, $ctime, $blksize, $blocks) = stat($file_name);
					if (defined $size && $size >= 0) {
						if ($arr_listing[0] =~ /L_(.*)_T_(.*)\.txt$/) {
							$is_OK = 1;
							$hash_STATUS->{'size_current'} = $size;
							$hash_STATUS->{'size_total'} = $1;
							$hash_STATUS->{'time_start'} = $2;
						}
					}
				}
			}
			if (!$is_OK) {
				$RESULT->{'ERROR_MSG'} = "No status file (or file is incorrect) for SID = '$in_SID' (METHOD = '".$in_SETTINGS->{'METHOD'}."')";
				return $RESULT;
			}
		}
		else {
			$RESULT->{'ERROR_MSG'} = "Unable to open directory '".&NL::String::get_right($DIR_OPEN, 40, 1)."' (SID = '$in_SID')";
			return $RESULT;
		}
	}
	# Processing DATA (OK, we have data from file)
	my $error_message = '';
	# for all methods
	if (!defined $hash_STATUS->{'size_total'} || $hash_STATUS->{'size_total'} !~ /^\d+$/) { $error_message = "'size_total' is incorrect"; }
	elsif (!defined $hash_STATUS->{'size_current'} || $hash_STATUS->{'size_current'} !~ /^\d+$/) { $error_message = "'size_current' is incorrect"; }
	elsif (!defined $hash_STATUS->{'time_start'} || $hash_STATUS->{'time_start'} !~ /^\d+$/) { $error_message = "'time_start' is incorrect"; }
	else {
		$hash_STATUS->{'time_spent'} = time() - $hash_STATUS->{'time_start'};
		# for 'CGI.pm' hook method
		if (defined $hash_STATUS->{'file_current_number'} && $hash_STATUS->{'file_current_number'} !~ /^\d+$/) { $error_message = "'file_current_number' is incorrect"; }
		#elsif (defined $hash_STATUS->{'file_current_name'} && $hash_STATUS->{'file_current_name'} =~ /^[\r\n]{0,}$/) { $error_message = "'file_current_name' is incorrect"; }
	}
	# OK, checking results
	if ($error_message ne '') {
		$RESULT->{'ERROR_MSG'} = "Incorrect STATUS parameters ($error_message)";
		return $RESULT;
	}
	else {
		$hash_STATUS->{'status'} = 'UPLOADING' if (!defined $hash_STATUS->{'status'});
		$RESULT->{'ID'} = 1;
		$RESULT->{'STATUS'} = $hash_STATUS;
		return $RESULT;
	}
}
# UPLOADS PROCESSING
# Proccessing data from 'CGI.pm'
sub CGI_process_uploads {
	my ($CGI_QUERY, $in_SETTINGS) = @_;
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'FILES_PERMISSIONS'} = '' if (!defined $in_SETTINGS->{'FILES_PERMISSIONS'});
	$in_SETTINGS->{'BINMODE'} = 1 if (!defined $in_SETTINGS->{'BINMODE'});

	# Finding needed data
	my @CGI_FILES;
	#my $CGI_PARAMS = { 'file_permissions' => '', 'NO_BINMODE' => 0 };
	foreach ($CGI_QUERY->param) {
		if ($_ =~ /^file_\d+$/) { push @CGI_FILES, $_; }
		# elsif (defined $CGI_PARAMS->{$_}) { $CGI_PARAMS->{$_} = $CGI_QUERY->param($_); }
	}
	# Proccessing uploaded files
	my $CGI_FILES_INFO = [];
	my $file_permissions = oct($in_SETTINGS->{'FILES_PERMISSIONS'});
	foreach (@CGI_FILES) {
		my $file_name = &CGI_process_uploads_GET_FILE_NAME(''.$CGI_QUERY->param($_));
		my $file_handle = &CGI::upload($_);
		my $temp_FILE = $CGI_QUERY->tmpFileName($file_handle);
		# Trying to rename/copy file
		my $is_copyed = 0;
		if (!defined $temp_FILE || $temp_FILE eq '' || !(-f $temp_FILE) || !rename($temp_FILE, $file_name)) {
			if (open(UPLOADFILE, ">$file_name")) {
				binmode UPLOADFILE if ($in_SETTINGS->{'BINMODE'});
				while (<$file_handle>) { print UPLOADFILE; }
				close (UPLOADFILE);
				$is_copyed = 1;
			}
			else {
				push @{ $CGI_FILES_INFO }, { 'file' => $file_name, 'status' => 0, 'ERROR_MSG' => "Unable to create file '$file_name': $!" };
			}
		}
		else { $is_copyed = 1; }
		# File is copyed
		if ($is_copyed) {
			my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $file_size, $atime, $mtime, $ctime, $blksize, $blocks) = stat($file_name);
			my $error_msg = '';
			# Setting file permissions
			if ($in_SETTINGS->{'FILES_PERMISSIONS'} ne '') {
				if(!chmod $file_permissions, $file_name) {
					$error_msg = "Unable to chmod '".$in_SETTINGS->{'file_permissions'}."' file '$file_name': $!";
				}
			}
			push @{ $CGI_FILES_INFO }, { 'file' => $file_name, 'status' => 1, 'size' => $file_size, 'ERROR_MSG' => $error_msg };
		}

	}
	# OK, now all data is uploaded
	return $CGI_FILES_INFO;
}
sub CGI_process_uploads_GET_FILE_NAME {
	my ($in_value) = @_;

	my @arr_splitters = ('\/', '\\', '\:');
	&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$in_value);
	foreach my $splitter (@arr_splitters) {
		$splitter =~ s/\\/\\\\/g;
		$splitter =~ s/\:/\\\:/g;
		$in_value =~ s/^.*$splitter([^$splitter]{0,})$/$1/;
	}
	return $in_value;
}
# Final info generation
sub make_upload_info {
	my ($ref_DATA, $in_SETTINGS) = @_;
	$ref_DATA = {} if (!defined $ref_DATA);
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'FILES_PERMISSIONS'} = '' if (!defined $in_SETTINGS->{'FILES_PERMISSIONS'});

	# Getting current directory
	&WC::Dir::update_current_dir();
	my $dir_current = &WC::Dir::get_current_dir();
	my $result = {};
	$result->{'js_ID'} = $ref_DATA->{'UPLOAD'}->{'SID'};
	$result->{'dir_current'} = $dir_current;
	$result->{'size_total'} = $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'size_total'};
	$result->{'time_spent'} = time() - $ref_DATA->{'UPLOAD'}->{'STATUS'}->{'INFO'}->{'time_start'};
	$result->{'files_chmod'} = '';
	if (defined $in_SETTINGS->{'FILES_PERMISSIONS'} && $in_SETTINGS->{'FILES_PERMISSIONS'} ne '') {
		$result->{'files_chmod'} = $in_SETTINGS->{'FILES_PERMISSIONS'};
	}
	# $result->{'files_total'} = 10;
	return $result;
}
# Removing all if we were KILLED
END {
	if (defined $NL::Upload::DATA->{'ACTIVE_OBJECT'} && defined $NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'} &&
	    defined $NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'METHOD'} && $NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'METHOD'} ne '' &&
	    defined $NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'} && defined $NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'} &&
	    $NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'} ne '') {
		if ($NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'METHOD'} eq 'STATUS_FILE') {
			# 'CGI.pm' hook supported
			&status_close($NL::Upload::DATA->{'ACTIVE_OBJECT'});
		}
		else {
			# 'CGI.pm' hook unsupported
			unlink($NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'}) if (-f $NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'});
			&NL::File::Lock::unlock($NL::Upload::DATA->{'ACTIVE_OBJECT'}->{'UPLOAD'}->{'STATUS'}->{'file_name'});
		}
	}
}
