#!/usr/bin/perl
# NL::Minify - mostNeeded Libs :: Perl, HTML, JavaScript, CSS minifyer
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: DEV

package NL::Minify;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Module::Util qw(:all);

$NL::Minify::DATA = {
	'ACTIONS' => {},
	'SETTINGS' => {}
};

sub read_file {
	my ($in_file) = @_;

	if (defined $NL::Minify::DATA->{'SETTINGS'}->{'DIR_HOME'}) { $in_file = $NL::Minify::DATA->{'SETTINGS'}->{'DIR_HOME'}.$in_file; }
	print "*** Reading file: '$in_file'...\n";
	open(FILE, "<$in_file") or die "Unable to open file '$in_file': $!";
	my @file_data = <FILE>;
	close(FILE);

	my $good_code = join '', @file_data;
	$good_code =~ s/^[\s\t\r\n]{1,}//;
	$good_code =~ s/[\s\t\r\n]{1,}$//;
	return $good_code;
}
sub minify_html {
	my ($in_file) = @_;

	if (defined $NL::Minify::DATA->{'SETTINGS'}->{'DIR_HOME'}) { $in_file = $NL::Minify::DATA->{'SETTINGS'}->{'DIR_HOME'}.$in_file; }
	print "*** Reading HTML file: '$in_file'...\n";
	open(FILE, "<$in_file") or die "Unable to open file '$in_file': $!";
	my @file_data = <FILE>;
	close(FILE);

	my $good_code = '';
	my $ref_ARR_GOOD_CODE = &minify_DATA(\@file_data, $in_file, 'HTML', 1);
	if (defined $NL::Minify::DATA->{'SETTINGS'}->{'HTML_PROCESS'}) { $good_code = $NL::Minify::DATA->{'SETTINGS'}->{'HTML_PROCESS'}->($ref_ARR_GOOD_CODE); }
	else { $good_code = join '', @{$ref_ARR_GOOD_CODE}; }
	$good_code =~ s/^[\s\t\r\n]{1,}//;
	$good_code =~ s/[\s\t\r\n]{1,}$//;

	return $good_code;
}
sub minify_perl {
	my ($in_file, $in_SETTINGS, $in_DONT_USE_HOME_DIR) = @_;
	$NL::Minify::DATA->{'SETTINGS'} = $in_SETTINGS if (defined $in_SETTINGS);

	if (defined $NL::Minify::DATA->{'SETTINGS'}->{'DIR_HOME'} && (!defined $in_DONT_USE_HOME_DIR || !$in_DONT_USE_HOME_DIR)) { $in_file = $NL::Minify::DATA->{'SETTINGS'}->{'DIR_HOME'}.$in_file; }
	#print "*** Reading Perl file: '$in_file'...\n";
	open(FILE, "<$in_file") or die "Unable to open file '$in_file': $!";
	my @file_data = <FILE>;
	close(FILE);

	my $good_code = &minify_DATA(\@file_data, $in_file, 'PERL');
	$good_code =~ s/^[\s\t\r\n]{1,}//;
	$good_code =~ s/[\s\t\r\n]{1,}$//;
	$good_code =~ s/#[\s\ta-zA-Z0-9]{0,}$//;
	$good_code =~ s/[\s\t\r\n]{1,}$//;
	$good_code =~ s/1;$//;
	$good_code =~ s/[\s\t\r\n]{1,}$//;
	if (defined $NL::Minify::DATA->{'SETTINGS'}->{'PERL_PROCESS'}) { $good_code = $NL::Minify::DATA->{'SETTINGS'}->{'PERL_PROCESS'}->($good_code); }
	return $good_code;
}
sub minify_DATA {
	my ($in_DATA, $in_file, $in_TYPE, $in_NO_JOIN) = @_;
	$in_TYPE = 'PERL' if (!defined $in_TYPE && $in_TYPE eq '');

	my $rm_all = 0;
	$NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = '';
	foreach (@{$in_DATA}) {
		my $DO_ALL = 1;
		if ($rm_all) { $_ = ''; }
		elsif ($_ =~ /^[\s\t\r\n]{1,}$/) { $_ = ''; }
		elsif ($in_TYPE eq 'PERL' && $_ =~ /^__END__/) { $_ = ''; $rm_all = 1; }
		elsif ($_ =~ /NL_CODE:\s{0,}(.*)$/) {
			if (&set_action($1, $in_file)) {
				$_ = '';
				$DO_ALL = 0;
			}
		}

		if ($DO_ALL) {
			if ($in_TYPE eq 'PERL' && $_ =~ /^[\s\t\r]{0,}#/) { $_ = ''; }
			elsif ($in_TYPE eq 'PERL' && $_ =~ /^[\s\t\r]{0,}#/) { $_ = ''; }
			else {
				if ($NL::Minify::DATA->{'ACTIONS'}->{ $in_file } eq 'RM') { $_ = ''; }
				if ($NL::Minify::DATA->{'ACTIONS'}->{ $in_file } eq 'RM_BLOCK') { $_ = ''; }
				elsif ($NL::Minify::DATA->{'ACTIONS'}->{ $in_file } eq 'INCLUDE_PERL') {
					if ($_ =~ /^\s{0,}require\s{0,}(.*);/) {
						my $path = find_installed($1);
						if (defined $path && $path ne '' && -f $path) {
							$_ = &minify_perl($path, undef, 1)."\n";
						}
						else { die "Unable to get file path for module '$1'"; }
					}
				}
				elsif ($NL::Minify::DATA->{'ACTIONS'}->{ $in_file } =~ /^INCLUDE_HTML '([^']+)'/) {
					$_ = &minify_html($1)."\n";
					$NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = 'RM';
				}
				elsif ($NL::Minify::DATA->{'ACTIONS'}->{ $in_file } =~ /^INCLUDE_CSS '([^']+)'/) {
					my $CSS_CODE = &read_file($1);
					if (defined $NL::Minify::DATA->{'SETTINGS'}->{'CSS_PROCESS'}) { $CSS_CODE = $NL::Minify::DATA->{'SETTINGS'}->{'CSS_PROCESS'}->($CSS_CODE); }

					$_ = '<style type="text/css" media="all">'."\n".$CSS_CODE."\n</style>\n";
					$NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = 'RM';
				}
				elsif ($NL::Minify::DATA->{'ACTIONS'}->{ $in_file } =~ /^INCLUDE_JS '([^']+)'/) {
					my $JS_CODE = &read_file($1);
					if (defined $NL::Minify::DATA->{'SETTINGS'}->{'JS_PROCESS'}) { $JS_CODE = $NL::Minify::DATA->{'SETTINGS'}->{'JS_PROCESS'}->($JS_CODE); }

					$_ = '<script type="text/javascript" language="JavaScript"><!--'."\n".$JS_CODE."\n//--></script>\n";
					$NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = 'RM';
				}
			}
		}
		#if ($in_TYPE eq 'PERL' && $_ =~ /\n\r$/) { $_ =~ s/\n\r$/\n/; }
	}
	delete $NL::Minify::DATA->{'ACTIONS'}->{ $in_file };

	if (defined $in_NO_JOIN && $in_NO_JOIN) { return $in_DATA; }
	return join '', @{$in_DATA};
}

sub set_action {
	my ($in_ACTION, $in_file) = @_;

	if ($in_ACTION =~ /^\s{0,}(\/?)\s{0,}(.*)$/) {
		my $is_close = (defined $1 && $1 eq '/') ? 1 : 0;
		my $action = $2;
		$action =~ s/\s+$//g;

		if ($is_close) {
			$NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = '';
			if ($action =~ /\[([^\[\]]+)\][ \s\t]{0,}$/) { return 0 if (defined $1 && &check_DO_NOT_REMOVE_MARK($1)); }
		}
		elsif ($action =~ /^INCLUDE_HTML '([^']+)'/) { $NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = $action; }
		elsif ($action eq 'INCLUDE_PERL') { $NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = $action; }
		elsif ($action =~ /^INCLUDE_CSS '([^']+)'/) { $NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = $action; }
		elsif ($action =~ /^INCLUDE_JS '([^']+)'/) { $NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = $action; }
		# Other actions
		elsif ($action =~ /^RM_BLOCK([ \s\t]{0,}|[ \s\t]+\[([^\[\]]+)\])$/) {
			if (defined $2 && &check_DO_NOT_REMOVE_MARK($2)) {
				# That mark no need to be removed
				return 0;
			}
			else { $NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = 'RM_BLOCK'; }
		}
		elsif ($action =~ /^RM_LINE([ \s\t]{0,}|[ \s\t]+\[([^\[\]]+)\])$/) {
			# $NL::Minify::DATA->{'ACTIONS'}->{ $in_file } = '';
			if (defined $2 && &check_DO_NOT_REMOVE_MARK($2)) {
				# That mark no need to be removed
				return 0;
			}
		}
		return 1;
 	}
	return 0;
}
sub check_DO_NOT_REMOVE_MARK {
	my ($in_TEXT) = @_;

	if (defined $NL::Minify::DATA->{'SETTINGS'}->{'DO_NOT_REMOVE_MARKS'} && scalar @{ $NL::Minify::DATA->{'SETTINGS'}->{'DO_NOT_REMOVE_MARKS'} } > 0) {
		foreach (@{ $NL::Minify::DATA->{'SETTINGS'}->{'DO_NOT_REMOVE_MARKS'} }) {
			if ($_ eq $in_TEXT) { return 1; }
		}
	}
	return 0;
}
1;
