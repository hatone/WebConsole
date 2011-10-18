#!/usr/bin/perl
# WC::Dir - Web Console 'Dir' module, contains methods for directorys manipulations
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Dir;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Dir::DATA = {
	'DYNAMIC' => {
		'dir_current' => '',
		'dir_splitter' => '',
		'dir_splitter_extra' => []
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

# Initialization of 'WC::File', called always first
# IN: NOTHING
# RETURN: NOTHING
sub init {
	&update_current_dir();
	&update_dir_splitters();
}
# Updating directory spliters at cache
# IN: NOTHING
# RETURN: NOTHING
sub update_dir_splitters {
	my @arr_splitters = &NL::Dir::get_dir_splitters();
	$WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'} = $arr_splitters[0];
	$WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter_extra'} = $arr_splitters[1];
}
# Updating current directory at cache
# IN: NOTHING
# RETURN: NOTHING
sub update_current_dir {
	$WC::Dir::DATA->{'DYNAMIC'}->{'dir_current'} = &NL::Dir::get_current_dir();
}
# Getting current directory (if cached - getting from cache)
# IN: NOTHING
# RETURN: STRING - current directory
sub get_current_dir {
	&update_current_dir() if ($WC::Dir::DATA->{'DYNAMIC'}->{'dir_current'} eq '');
	return $WC::Dir::DATA->{'DYNAMIC'}->{'dir_current'};
}
# Getting directorys splitter (if cached - getting from cache)
# IN: NOTHING
# RETURN: STRING - directory splitter
sub get_dir_splitter {
	&update_dir_splitters() if ($WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'} eq '');
	return $WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'};
}
# Getting directorys splitters (if cached - getting from cache)
# IN: NOTHING
# RETURN: (STRING - directory splitter, ARRAY_REF - extara directory splitters)
sub get_dir_splitters {
	&update_dir_splitters() if ($WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'} eq '');
 	return ($WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter'}, $WC::Dir::DATA->{'DYNAMIC'}->{'dir_splitter_extra'});
}
# Changing currect directory
# IN: STRING - directory where we need to go
# RETURN: NUMBER - 'chdir' result
sub change_dir {
	my $chdir_result = &NL::Dir::change_dir($_[0]);
	&update_current_dir() if ($chdir_result);
	return $chdir_result;
}
# Updating current directory from input and going to the needed directory
# IN: STRING - directory where we need to go
# RETURN: 1 - OK | 0 - NOT OK, see 'get_last_error()'
sub change_dir_TO_CURRENT {
	&_error_reset();
	# Updating current directory from input
	if (defined $WC::c->{'req'}->{'params'}->{'STATE_dir_current'} && $WC::c->{'req'}->{'params'}->{'STATE_dir_current'} ne '') {
		$WC::c->{'state'}->{'dir_current'} = $WC::c->{'req'}->{'params'}->{'STATE_dir_current'};
	}
	# Going to the needed directory
	if (!&WC::Dir::change_dir($WC::c->{'state'}->{'dir_current'})) {
		&_error_set("Unable change directory to '".( &NL::String::str_HTML_full($WC::c->{'state'}->{'dir_current'}) )."'", 'Please make sure that directory was not removed or renamed. <br />You can change current directory using &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'cd\'); return false" title="Click to paste at command input">cd</a>&quot; command.', 'WC_DIR_CD_CURRENT_UNABLE');
		return 0;
	}
	return 1;
}
# Checking input directory and fixing if needed
# IN: STRING - directory to check
# RETURN: STRING - fixed directory
sub check_in { return &NL::Dir::check_in(defined $_[0] ? $_[0] : ''); }
# Checking output directory and fixing if needed
# IN: STRING - directory to check
# RETURN: STRING - fixed directory
sub check_out { return &NL::Dir::check_out(defined $_[0] ? $_[0] : ''); }

1; #EOF
