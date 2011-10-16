#!/usr/bin/perl
# NL::Dir - mostNeeded Libs :: Directorys processing library
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: DEV

package NL::Dir;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Cwd ('getcwd', 'cwd');
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$NL::Dir::IS_OS_WIN32 = ($^O eq 'MSWin32') ? 1 : 0;

sub get_current_dir {
	my $dir = getcwd();
	$dir = cwd() if (!defined $dir);
	return $dir;
}
sub get_dir_splitters {
	my @arr_splitters = ('/', []);

	if ($^O eq 'MacOS') { $arr_splitters[0] = ':'; }
	elsif ($NL::Dir::IS_OS_WIN32) {
		$arr_splitters[0] = '/';
		$arr_splitters[1] = ['\\'];
	}
	return @arr_splitters;
}
sub get_dir_splitter { my @arr_splitters = &get_dir_splitters(); return $arr_splitters[0]; }
sub change_dir { return chdir($_[0]); }
# Directory listing
sub list {
	my ($in_dir, $in_sort) = @_;
	$in_dir = '' if (!defined $in_dir);
	$in_sort = 0 if (!defined $in_sort);

	my $ref_arr_dir_listing = [];
	return (-1, $ref_arr_dir_listing) if ($in_dir eq '');

	opendir (DIR, $in_dir) or return (0, $ref_arr_dir_listing); # Unable to read directory
	@{ $ref_arr_dir_listing } = grep (!/^\.+$/, readdir (DIR)); # or foreach my $cur_file (readdir(DIR)){..}
	closedir (DIR);
	if ($in_sort == 1) { @{ $ref_arr_dir_listing } = sort{ lc($a) cmp lc($b) } @{ $ref_arr_dir_listing }; }
	elsif ($in_sort == 2) { @{ $ref_arr_dir_listing } = sort{ lc($b) cmp lc($a) } @{ $ref_arr_dir_listing }; }

	return (1, $ref_arr_dir_listing);
}
sub check_in {
	my ($in_value) = @_;
	my $result = '';

	if (defined $in_value) {
		$result = $in_value;
		if ($NL::Dir::IS_OS_WIN32) {
			if ($result =~ /^"([^"]{0,})"?([^"]{0,})$/) { $result = (defined $1 ? $1 : '').(defined $2 ? $2 : ''); }
			elsif ($result =~ /^([^"]{0,})$/) { $result = (defined $1 ? $1 : ''); }
		}
		else {
			$result =~ s/\\([^\\]|$)/$1/g;
		}
	}
	return $result;
}
sub check_out {
	my ($in_value) = @_;
	my $result = '';

	if (defined $in_value) {
		$result = $in_value;
		if ($NL::Dir::IS_OS_WIN32) {
			if ($result =~ /^"/ && $result !~ /"$/) { $result .= '"'; }
			elsif ($result =~ /[ \/\t]/) { $result = '"'.$result.'"'; }
		}
		else {
			$result =~ s/([ \\])/\\$1/g;
		}
	}
	return $result;
}
sub remove_old_files {
	my ($in_DIR, $in_SETTINGS) = @_;
	$in_DIR = '' if (!defined $in_DIR);
	$in_SETTINGS = {} if (!$in_SETTINGS);
	$in_SETTINGS->{'SECONDS_OLD'} = 3600*24 if (!defined $in_SETTINGS->{'SECONDS_OLD'} || $in_SETTINGS->{'SECONDS_OLD'} <= 0); # 3600 = 1 hour
	$in_SETTINGS->{'SKIP_FILES'} = [] if (!defined $in_SETTINGS->{'SKIP_FILES'});

	if ($in_DIR ne '' && -d $in_DIR) {
		# Getting listing
		my @arr_listing;
		if (opendir(DIR, $in_DIR)) {
			@arr_listing = grep(!/^\.{1,2}$/, readdir (DIR));
			closedir (DIR);
		}
		if (scalar @arr_listing > 0) {
			my $dir_splitter = &get_dir_splitter();
			my $dir = ($in_DIR =~ /${dir_splitter}$/) ? $in_DIR : $in_DIR.$dir_splitter;
			my $time = time();
			foreach (@arr_listing) {
				my $val = $_;
				# Checking if we need skip a file
				foreach (@{ $in_SETTINGS->{'SKIP_FILES'} }) { if ($_ eq $val) { $val = ''; last; } }
				if ($val eq '') { next; }

				my $file = $dir.$val;
				if (-f $file) {
					my @arr_stat = stat($file);
					if (defined $arr_stat[9]) {
						if ($time - $arr_stat[9] >= $in_SETTINGS->{'SECONDS_OLD'}) {
							unlink $file;
						}
					}
				}
			}
			return 1;
		}
	}
	return 0;
}
1; #EOF
