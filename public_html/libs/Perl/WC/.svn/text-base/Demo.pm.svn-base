#!/usr/bin/perl
# WC::Dir - Web Console 'Demo' module, contains methods for DEMO
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::Demo;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Demo::DATA = {
	'CONST' => {
		'DEMO_LS' => ''.
			'drwxr-xr-x    3 root demousers     4096 Jan 01 10:41 .'."\n".
			'drwxr-xr-x    3 root demousers     4096 Jan 01 10:18 ..'."\n".
			'-rw-r--r--    1 root demousers     2173 Jan 01 10:41 .htaccess'."\n".
			'-rwxr-xr-x    1 root demousers   521605 Jan 01 12:40 demo.pl'."\n".
			'-rw-r--r--    1 root demousers    17145 Jan 01 12:41 page.html'."\n".
			'drwxr-xr-x    2 root demousers     4096 Jan 01 12:41 work_dir'
		# 'DEMO_DIR' => [
		#	{ 'type' => 'file', 'name' => 'file.txt', 'DATA' => "Simple text file\nThat is just example" },
		#	{ 'type' => 'dir', 'name' => 'dir' }
		# ]
	}
};

sub ACTION_process_AJAX {
	my ($in_ACTION) = @_;
	$in_ACTION = '' if (!defined $in_ACTION);
	my $result = { 'ALLOWED' => 0, 'AJAX_RESPONSE_ARRAY' => [] };


	my $re_SPACE = qr/[ \s\t]+/;
	my $re_SPACE_OR_EMPTY = qr/[ \s\t]{0,}/;
	my $is_AJAX_RESPONSE_ARRAY_SET = 0;
	if ($in_ACTION eq 'AJAX_CMD') {
		if(&WC::EXEC::init_INPUT_CMD()) {
			if ($WC::c->{'request'}->{'cmd'} =~ /^[ \s\t\r\n]{0,}(ls|dir)[ \s\t\r\n]{0}(.*)$/i) {
				my $message = $WC::Demo::DATA->{'CONST'}->{'DEMO_LS'};
				&NL::String::str_HTML_full(\$message);
				# $message = '<span class="t-grey">[that is DEMO listing]</span><br />'.$message;
				$result->{'AJAX_RESPONSE_ARRAY'} = ['CMD_RESULT', $message];
				$is_AJAX_RESPONSE_ARRAY_SET = 1;
			}
			elsif ($WC::c->{'request'}->{'cmd'} =~ /^[ \s\t\r\n]{0,}echo[ \s\t\r\n]{0}(.*)$/i) {
				my $ECHO_MAX_LENGTH = 100;
				my $MESSAGE_SHORTED = 0;
				my $message = $1;
				&NL::String::str_trim(\$message);
				if ($message =~ /^['"](.*)['"]$/) { $message = $1; }
				if (length($message) > $ECHO_MAX_LENGTH) {
					$message = &NL::String::get_left($message, $ECHO_MAX_LENGTH, 1);
					$MESSAGE_SHORTED = 1;
				}
				&NL::String::str_HTML_full(\$message);
				$message .= '<br /><span class="t-grey">[maximum ECHO length at DEMO MODE is \''.$ECHO_MAX_LENGTH.'\' characters]</span>' if ($MESSAGE_SHORTED);
				$result->{'AJAX_RESPONSE_ARRAY'} = ['CMD_RESULT', $message];
				$is_AJAX_RESPONSE_ARRAY_SET = 1;
			}
			# Internal commands execution
			elsif ($WC::c->{'request'}->{'cmd'} =~ /^#(.*)$/) {
				my $CMD = $1;
				if ($CMD =~ /^(a|ab|abo|abou|about)$re_SPACE(.*)$/i) {
					$CMD = $2;
					if ($CMD =~ /^$re_SPACE_OR_EMPTY(a|au|aut|auth|autho|author|authors)$re_SPACE_OR_EMPTY$/i) { $result->{'ALLOWED'} = 1; }
					elsif ($CMD =~ /^$re_SPACE_OR_EMPTY(d|do|don|dona|donat|donate)$re_SPACE_OR_EMPTY$/i) { $result->{'ALLOWED'} = 1; }
					elsif ($CMD =~ /^$re_SPACE_OR_EMPTY(s|se|ser|serv|servi|servic|service|services)$re_SPACE_OR_EMPTY$/i) { $result->{'ALLOWED'} = 1; }
					elsif ($CMD =~ /^$re_SPACE_OR_EMPTY(s|si|sit|site)$re_SPACE_OR_EMPTY$/i) { $result->{'ALLOWED'} = 1; }
					elsif ($CMD =~ /^$re_SPACE_OR_EMPTY(s|su|sup|supp|suppo|suppor|support)$re_SPACE_OR_EMPTY$/i) { $result->{'ALLOWED'} = 1; }
					elsif ($CMD =~ /^$re_SPACE_OR_EMPTY(u|ur|url)$re_SPACE_OR_EMPTY$/i) { $result->{'ALLOWED'} = 1; }
					elsif ($CMD =~ /^$re_SPACE_OR_EMPTY(v|ve|ver|vers|versi|versio|version)$re_SPACE_OR_EMPTY$/i) { $result->{'ALLOWED'} = 1; }
				}
			}
		}
	}
	elsif ($in_ACTION eq 'AJAX_TAB') {
		if (defined $WC::c->{'req'}->{'params'}->{'cmd_query'}) {
			my $CMD = $WC::c->{'req'}->{'params'}->{'cmd_query'};
			if ($CMD =~ /^#(.*)$/) {
				$CMD = $1;
				if ($CMD eq '') { $result->{'ALLOWED'} = 1; }
				elsif ($CMD =~ /^a/) { $result->{'ALLOWED'} = 1; }
				elsif ($CMD =~ /^(f|fi|fil|file)$re_SPACE_OR_EMPTY$/) { $result->{'ALLOWED'} = 1; }
			}
		}
	}

	$result->{'AJAX_RESPONSE_ARRAY'} = &show_NOT_ALLOWED() if (!$result->{'ALLOWED'} && !$is_AJAX_RESPONSE_ARRAY_SET);
	return $result;
}
sub show_NOT_ALLOWED {
	my $spaces = '&nbsp;&nbsp;&nbsp;&nbsp;';
	my $text = ''.
	$spaces.'<span class="t-dash">'.('*' x 85).'</span><br />'.
	$spaces.'<span class="t-dash">**</span> <span class="t-lime">THAT COMMAND IS NOT ALLOWED AT DEMO MODE</span>'.('&nbsp;' x 40).'<span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> <span class="t-blue">Following commands are allowed at DEMO mode:</span>'.('&nbsp;' x 35).' <span class="t-dash">**</span><br />'.
	'<div class="t-message">'.
	$spaces.'<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'ls\'); return false" title="Click to paste at command input">ls</a>&quot;/&quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'dir\'); return false" title="Click to paste at command input">dir</a>&quot; - list directory contents;'.('&nbsp;' x 39).' <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'echo\'); return false" title="Click to paste at command input">echo</a>&quot; - displays entered message;'.('&nbsp;' x 42).' <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'clear\'); return false" title="Click to paste at command input">clear</a>&quot;/&quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'cls\'); return false" title="Click to paste at command input">cls</a>&quot; - clears screen;'.('&nbsp;' x 46).' <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> <span class="t-dash">--</span> Type &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'#\'); return false" title="Click to paste at command input">#</a>&quot; and press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot; key on your keyboard to access Web Console internal <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> &nbsp;&nbsp; commands (at DEMO MODE limited access to that commands allowed);'.('&nbsp;' x 12).' <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> <span class="t-dash">--</span> To autocomplete feature press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot; key on your keyboard.'.('&nbsp;' x 19).' <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> '.('&nbsp;' x 79).' <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> <span class="t-blue">Fully featured Web Console version can be downloaded here:</span>'.('&nbsp;' x 21).' <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">**</span> <a class="a-brown" href="'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'" title="Visit to Web Console Download" target="_blank">'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'</a>'.('&nbsp;' x 43).' <span class="t-dash">**</span><br />'.
	$spaces.'<span class="t-dash">'.('*' x 85).'</span>'.
	'</div>';
	return ['CMD_RESULT', $text];
}
sub check_is_CMD_ALLOWED {
	my ($in_CMD) = @_;
	my $result = { 'ID' => 0, 'TEXT' => 'Sorry that command is not allowed at DEMO mode' };

	my $RE_spaces = qr/[ \s\t]+/;
	my $RE_spaces_OR_NO = qr/[ \s\t]{0,}/;
	if (defined $in_CMD && $in_CMD ne '') {
		if ($in_CMD =~ /^${RE_spaces_OR_NO}ls${RE_spaces}$/i) {}
	}
	return $result;
}

1; #EOF
