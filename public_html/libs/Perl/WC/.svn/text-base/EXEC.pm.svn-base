#!/usr/bin/perl
# WC::EXEC - Web Console 'EXEC' module, contains methods for commands execution
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::EXEC;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Initialization of 'WC::EXEC', called always first
# IN: NOTHING
# RETURN: NOTHING
sub init {
	if ($WC::Encode::POSIX_ON) {
		# OK, POSIX loaded
		&POSIX::setlocale(&POSIX::LC_ALL, $WC::c->{'config'}->{'encodings'}->{'server_console'}) if ($WC::c->{'config'}->{'encodings'}->{'server_console'} ne '');
	}
}
# Initialization of '$WC::c->{'request'}->{'cmd'}', called whan we have all data from INPUT
# IN: NOTHING
# RETURN: 1 - 'cmd_query' defined | 0 - 'cmd_query' not defined
sub init_INPUT_CMD {
	if (defined $WC::c->{'request'}->{'params'}->{'cmd_query'} && $WC::c->{'request'}->{'params'}->{'cmd_query'} ne '') {
		$WC::c->{'request'}->{'cmd'} = $WC::c->{'request'}->{'params'}->{'cmd_query'};
		if ($WC::c->{'request'}->{'cmd'} =~ /^[ \t]{0,}([^ \t]+)[ \t]{0,1}(.*)$/) {
			$WC::c->{'request'}->{'cmd_'} = $1;
			$WC::c->{'request'}->{'cmd_params'} = $2;
			&NL::String::str_trim(\$WC::c->{'request'}->{'cmd_params'});
			@{ $WC::c->{'request'}->{'cmd_params_arr'} } = split(/[ \t]+/, $WC::c->{'request'}->{'cmd_params'});
		}
		return 1;
	}
	return 0;
}
# Command execution (converting encoding to SYSTEM): WRAPPER TO: '&_execute()'
sub execute { return &_execute(defined $_[0] ? $_[0] : '', defined $_[1] ? $_[1] : '', \&WC::Encode::encode_from_CONSOLE_to_SYSTEM); }
# Command execution (converting encoding to WC): WRAPPER TO: '&_execute()'
sub execute_encoding_WC { return &_execute(defined $_[0] ? $_[0] : '', defined $_[1] ? $_[1] : '', \&WC::Encode::encode_from_CONSOLE_to_INTERNAL); }
# Command execution, converting output using callback function (internal)
# IN: STRING - command, STRING - execution method if needed = BACKTICKS (default) | OPEN[, SUB_REF - callback function for encoding]
# RETURN: { 'ID' => NUMBER, 'error' => [STRING - message, STRING - info] | [], 'text' => STRING }
sub _execute {
	my ($in_CMD, $in_METHOD, $in_CALLBACK_CONVERT) = @_;
	$in_METHOD = 'BACKTICKS' if (!defined $in_METHOD || $in_METHOD eq '');

	my $result_HASH = { 'ID' => 1, 'text' => '', 'error' => ['', ''] };
	if (!defined $in_CMD || $in_CMD eq '') {
		$result_HASH->{'ID'} = 0;
		$result_HASH->{'error'} = ['Nothing to execute', 'Command for execution (ARG1) is empty'];
	}
	else {
		local $| = 1; # output autoflush
		if ($in_METHOD eq 'BACKTICKS') {
			$result_HASH->{'text'} = `$in_CMD 2>&1`;
		}
		elsif ($in_METHOD eq 'OPEN') {
			if (open(HANDLE_EXEC_CMD, $in_CMD.' 2>&1|')) {
				while (<HANDLE_EXEC_CMD>) { $result_HASH->{'text'} .= $_; }
				close (HANDLE_EXEC_CMD);
			}
			else {
				$result_HASH->{'ID'} = -1;
				$result_HASH->{'error'} = ["Unable to execute command '$in_CMD'", $!];
			}
		}
		&{ $in_CALLBACK_CONVERT }(\$result_HASH->{'text'}) if ($result_HASH->{'text'} ne '' && defined $in_CALLBACK_CONVERT);
	}
	return $result_HASH;
}

1; #EOF
