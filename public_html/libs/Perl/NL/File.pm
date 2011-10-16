#!/usr/bin/perl
# NL::File - mostNeeded Libs :: Files processing library
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY

package NL::File;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Getting file size
# return: >=0 - file size
#	  -1 - error, filename (ARG1) is not defined
#	  -2 - error, file not found
#         -3 - error, information about file does not contain file size
sub get_size {
	my ($file) = @_;

	if (defined $file && $file ne '') {
		if (-f $file) {
			my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size, $atime, $mtime, $ctime, $blksize, $blocks) = stat($file);
			if (defined $size && $size >= 0) { return $size; }
			else { return -3; }
		}
		else { return -2; }
	}
	else { return -1; }
}
# Checking is file exists
# return: 1 - file exists | 0 - file is not exists or input is not defined
sub is_exists {
	my ($in_file) = @_;

	if (defined $in_file && $in_file ne '' && -f $in_file) { return 1; }
	return 0;
}

1; #EOF
