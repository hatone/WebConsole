#!/usr/bin/perl
# WC::Autocomplete - Web Console 'Autocomplete' module, contains methods for autocomplete feature
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Autocomplete;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Autocomplete::IS_OS_WIN32 = ($^O eq 'MSWin32') ? 1 : 0;

# Getting the same left part of all values at array
# IN: ARRAY_REF
# RETURN: STRING - same part
sub get_same_part {
	my ($in_ARRAY) = @_;

	my $result = '';
	my $length_ARRAY = scalar @{ $in_ARRAY };
	if ($length_ARRAY > 0) {
		my $value_first = $in_ARRAY->[0];
		my $same_chars_MIN = length($value_first);
		if ($same_chars_MIN > 0) {
			for (my $v = 1; $v < $length_ARRAY; $v++) {
				my $length_v = length($in_ARRAY->[$v]);
				my $same_chars = 0;
				for (my $i = 0; ($i < $length_v && $i < $same_chars_MIN); $i++) {
					if (substr($value_first, $i, 1) eq substr($in_ARRAY->[$v], $i, 1)) { $same_chars++; }
					else { last; }
				}
				if ($same_chars <= 0) { $same_chars_MIN = 0; last; }
				elsif ($same_chars < $same_chars_MIN) { $same_chars_MIN = $same_chars; }
			}
			if ($same_chars_MIN > 0) {
				$result = substr($value_first, 0, $same_chars_MIN);
			}
		}
	}
	return $result;
}
# Starting autocomplete feature
# IN: STRING
# RETURN: HASH_REF
sub start {
	my ($in_value) = @_;
	$in_value = '' if (!defined $in_value);
	my $result = { 'ID' => 0, 'TITLE' => '', 'INFO' => '', 'SUBTITLE' => '', 'TEXT' => '', 'values' => [], 'cmd_add' => '', 'cmd_left_update' => '' };

	# Updating current directory from input and going to the needed directory
	if (!&WC::Dir::change_dir_TO_CURRENT()) { &WC::CORE::die_info_AJAX(&WC::Dir::get_last_error_ARR()); }
	else {
		my $hash_AC = {};
		# INTERNAL AUTOCOMPLETION
		$hash_AC = &WC::Internal::start_autocompletion($in_value);
		if ($hash_AC->{'ID'}) { return $hash_AC; }
		# DERECTORY AUTOCOMPLETION
		else {
			my $in_LEFT = '';
			# If we working at Windows
			if ($WC::Autocomplete::IS_OS_WIN32) {
				$in_LEFT = '';
				my $val_CMD = $in_value;
				if ($val_CMD ne '') {
					while ($val_CMD =~ /^([^"]{0,}"(\\[^"]|\\"|[^\\"])+"[ \t\r\n]+|[^"]{0,}[ \t\r\n]+)/) {
						$in_LEFT .= $1;
						$val_CMD = $';
					}
				}
				$hash_AC = &DO_AUTOCOMPLETE_DIR($val_CMD);
			}
			# If we working not at Windows
			else {
				if ($in_value =~ /(^|.*[^\\] )(((\\[ ])|[^ ]){0,})$/ || $in_value =~ /(^ )(((\\[ ])|[^ ]){0,})$/) {
					$in_LEFT = defined $1 ? $1 : '';
					$hash_AC = &DO_AUTOCOMPLETE_DIR(defined $2 ? $2 : '');
				}
			}
			# If we have 'ID' = 1 - it was autocompleted
			if ($hash_AC->{'ID'}) {
				$hash_AC->{'cmd_left_update'} = $in_LEFT.$hash_AC->{'cmd_left_update'} if($hash_AC->{'cmd_left_update'} ne '');
				return $hash_AC;
			}
		}
	}

	# Returning default result
	return $result;
}
# Getting autocompletion for directory (from current directory)
# IN: STRING [, NUMBER = 0 - no sort | -1 - reverse]
# RETURN: HASH_REF
sub DO_AUTOCOMPLETE_DIR {
	my ($in_value, $in_sort) = @_;
	$in_value = '' if (!defined $in_value);
	$in_sort = 1 if (!defined $in_sort);
	my $result = { 'ID' => 0, 'TITLE' => '', 'INFO' => '', 'SUBTITLE' => '', 'TEXT' => '', 'values' => [], 'cmd_add' => '', 'cmd_left_update' => '' };

	# Getting REGEX for splitters
	my $system_SPLITTER = '';
	my $default_SPLITTER = '';
	my $splitters_RE = '';
	foreach my $spl (&WC::Dir::get_dir_splitters()) {
		if (ref $spl eq 'ARRAY') { foreach (@{ $spl }) { $splitters_RE .= $_; } }
		else {
			$default_SPLITTER = $system_SPLITTER = $spl;
			$splitters_RE .= $spl;
		}
	}
	$splitters_RE = quotemeta($splitters_RE);

	# Fixing input directory path and parsing fixed
	my $IS_FULL_PATH_UPDATE_NEEDED = 0;
	my $input_FIXED = &WC::Dir::check_in($in_value);
	my $input_DIR = '';
	my $input_SPLITTER = '';
	my $input_VAL = '';
	if ($input_FIXED =~ /^(.*)([$splitters_RE])([^$splitters_RE]{0,})$/) {
		$input_DIR = (defined $1 ? $1 : '');
		$input_SPLITTER = $2;
		$input_VAL = (defined $3 ? $3 : '');
		# If request was '/' or '\' or '///' or '\\\' or 'c:\' or 'c:/' - root directory request
		if ($input_DIR eq '' || ($input_VAL eq '' && $input_DIR =~ /^[$splitters_RE]{1,}$/) || ($WC::Autocomplete::IS_OS_WIN32 && $input_DIR =~ /^[a-zA-Z]+:$/)) {
			$input_DIR .= $input_SPLITTER;
			$default_SPLITTER = $input_SPLITTER;
			$input_SPLITTER = '';
		}
		if ($input_VAL eq '..') {
			# If DIR = '' or '/' or '//' ... - making '<DIR>../', else - '<DIR>..'
			if ($input_DIR =~ /^[$splitters_RE]{0,}$/) { $input_DIR .= $input_SPLITTER.$input_VAL.($input_SPLITTER || $default_SPLITTER); }
			else { $input_DIR .= $input_SPLITTER.$input_VAL; }
			$input_VAL = '';
			$IS_FULL_PATH_UPDATE_NEEDED = 1;
		}
	}
	else {
		$input_VAL = $input_FIXED;
		if ($input_VAL eq '..' || $input_VAL eq '.') {
			$input_DIR = $input_VAL.$system_SPLITTER;
			$input_VAL = '';
			$IS_FULL_PATH_UPDATE_NEEDED = 1;
		}
		elsif ($WC::Autocomplete::IS_OS_WIN32 && $input_VAL =~ /^[a-zA-Z]+:$/) {
			$input_DIR = $input_VAL.$default_SPLITTER;
			$input_VAL = '';
			$IS_FULL_PATH_UPDATE_NEEDED = 1;
		}
	}

	# Getting directory listing
	my $input_VAL_QUOTEMETA = quotemeta($input_VAL);
	my $dir_read = $input_DIR ne '' ? $input_DIR : &WC::Dir::get_current_dir();
	opendir (DIR, $dir_read) or return $result; # Unable to read directory
	my @dir_listing = grep (/^$input_VAL_QUOTEMETA/, grep (!/^\.{1,2}$/, readdir (DIR)));
	closedir (DIR);

	# If we are here - directory founded
	$result->{'ID'} = 1;
	# Getting number of finded completions and preparing result
	my $result_VALUE = '';
	my $num_founded = scalar @dir_listing;
	if ($num_founded == 1) { $result_VALUE = shift @dir_listing; }
	elsif ($num_founded > 1) {
		if ($in_sort == 1) { @dir_listing = sort{ lc($a) cmp lc($b) } @dir_listing; }
		elsif ($in_sort == -1) { @dir_listing = sort{ lc($b) cmp lc($a) } @dir_listing; }
		# Adding slashes to directorys
		my $dir_path = $dir_read.(($dir_read !~ /([$splitters_RE]|^)$/) ? $system_SPLITTER : '');
		my $dir_splitter = $input_SPLITTER || $default_SPLITTER || $system_SPLITTER;
		foreach (@dir_listing) { $_ .= $dir_splitter if (-d $dir_path.$_); }
		# Preparing result values
		$result->{'values'} = \@dir_listing;
		$result_VALUE = &get_same_part($result->{'values'});
	}

	# Making full finded path
	my $full_path = $input_DIR.$input_SPLITTER.$result_VALUE;
	if ($num_founded <= 1 && -d $full_path && $full_path !~ /[$splitters_RE]$/) {
		if ($result_VALUE eq $input_VAL) {
			$full_path .= $input_SPLITTER || $default_SPLITTER;
			$IS_FULL_PATH_UPDATE_NEEDED = 1;
		}
	}
	my $full_path_fixed = &WC::Dir::check_out($full_path);
	# If we working at Windows - making fix for '"' if it was opened
	if ($WC::Autocomplete::IS_OS_WIN32 && $full_path_fixed ne '' && $full_path_fixed !~ /"/ && $in_value =~ /^"/) {
		$full_path_fixed = '"'.$full_path_fixed.'"';
		$IS_FULL_PATH_UPDATE_NEEDED = 1;
	}
	# Checking if is needed "FULL REPLACEMENT" of path, or just autocompletion part
	if (!$IS_FULL_PATH_UPDATE_NEEDED) {
		# Parsing real input directory path and comparing with new path
		if ($in_value =~ /^(.*[$splitters_RE])([^$splitters_RE]{0,})$/) {
			my $left_QM = quotemeta($1);
			my $value_QM = quotemeta($2);
			if ($full_path_fixed !~ /^${left_QM}/ || $result_VALUE !~ /^${value_QM}/) { $IS_FULL_PATH_UPDATE_NEEDED = 1; }
		}
		# Comparing fixed path and not fixed
		if (!$IS_FULL_PATH_UPDATE_NEEDED) {
			if($full_path_fixed ne $full_path) { $IS_FULL_PATH_UPDATE_NEEDED = 1; }
		}
	}
	# Making final fix
	if ($IS_FULL_PATH_UPDATE_NEEDED) {
		if ($num_founded > 0) { $result->{'cmd_left_update'} = $full_path_fixed; }
		elsif ($input_VAL eq '') { $result->{'cmd_left_update'} = $full_path_fixed; }
	}
	elsif ($result_VALUE ne '') {
		$result_VALUE =~ s/^$input_VAL_QUOTEMETA//;
		$result->{'cmd_add'} = $result_VALUE;
	}
	return $result;
}

1; #EOF
