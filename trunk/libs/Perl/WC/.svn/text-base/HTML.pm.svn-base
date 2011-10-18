#!/usr/bin/perl
# WC::HTML - Web Console HTML manipulations
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::HTML;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Pages content initialization (internal), called before setting page content
# IN: NOTHING
# RETURN: NOTHING
sub _init_pages {
	# Data for all pages
	$WC::HTML::PAGES_DATA = {
		'html_error' => {
			'PAGE_TYPE' => 'error',
			'page_title' => ':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Error',
			'main_title' => '<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: <span class="t-MARK-ERROR">Error</span></a>',
			'main_info' => ''
		},
		'html_warning' => {
			'PAGE_TYPE' => 'warning',
			'page_title' => ':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Warning',
			'main_title' => '<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: <span class="t-MARK-WARNING">Warning</span></a>',
			'main_info' => ''
		},
		'html_info' => {
			'PAGE_TYPE' => 'info',
			'page_title' => ':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Informational message',
			'main_title' => '<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: <span class="t-MARK-INFO">Informational message</span></a>',
			'main_info' => ''
		},
		'html_install' => {
			'PAGE_TYPE' => 'install',
			'PAGE_ACTION' => '',
			'page_title' => ':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Installation',
			'main_title' => '<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">* '.$WC::c->{'APP_SETTINGS'}->{'name'}.' Installation *</a>',
			'main_info' => '<div class="install-ALL-CHECKED-OK">All required permissions are checked - all is OK.</div>'.
				       '<div class="install-DETAIL">You can read detailed installation instructions <a href="http://www.web-console.org/installation/#WEB_PHASE" title="Read detailed '.$WC::c->{'APP_SETTINGS'}->{'name'}.' installation instructions (with screenshots)" target="_blank">here</a>.</div>'.
				       '<div class="install-TODO">Please enter login, password and e-mail for the '.$WC::c->{'APP_SETTINGS'}->{'name'}.' administrator:</div>',
			# User information
			'user_login' => '',
			'user_password' => '',
			'user_email' => '',
			# Encodings information
			'encoding_SERVER_CONSOLE' => '',
			'encoding_SERVER_SYSTEM' => '',
			'encoding_EDITOR_TEXT' => '',
			# Other
			'ENCODE_ON' => 1,
			'ENCODE_ERROR' => '',
			'ENCODE_ENCODING' => '',
			'ENCODE_AREA_SHOW' => 0
		},
		'html_installed' => {
			'PAGE_TYPE' => 'installed',
			'PAGE_ACTION' => '',
			'page_title' => ':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Installation',
			'main_title' => '<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">* '.$WC::c->{'APP_SETTINGS'}->{'name'}.' Installation *</a>',
			'main_info' => '<div class="installed-TITLE">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' has been successfully installed.</div>'.
				       '<div class="installed-MAIN"><table><tr><td>'.
						'<div class="installed-LOGON">You can now <a href="'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'?logon_rand='.( time() ).'" title="Login to '.$WC::c->{'APP_SETTINGS'}->{'name'}.'">LOGIN</a> using administrator\'s login and password.</div>'.
						'<div class="installed-USAGE">Most common '.$WC::c->{'APP_SETTINGS'}->{'name'}.' usage you can find here:<br />'.
						'&nbsp;&nbsp;&nbsp;&nbsp;<span class="installed-DASH">&mdash;</span> <a href="http://www.web-console.org/category/usage/" title="Visit to '.$WC::c->{'APP_SETTINGS'}->{'name'}.' Usage" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' Usage</a><br />'.
						'&nbsp;&nbsp;&nbsp;&nbsp;<span class="installed-DASH">&mdash;</span> <a href="http://www.web-console.org/faq/" title="Visit to '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FAQ" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' FAQ</a><br />'.
						'&nbsp;&nbsp;&nbsp;&nbsp;<span class="installed-DASH">&mdash;</span> <a href="http://forum.web-console.org" title="Visit to '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FORUM" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' FORUM</a>'.
						'</div>'.
						'<div class="installed-SERVICES">'.
						'<a class="installed-SERVICES-LINK" href="http://www.web-console.org/about_us/" title="Read more information about Web Console Group" target="_blank">Web Console Group</a> also provides web application development, server<br />'.
						'configuration, technical support, security analysis, consulting and other services.<br />'.
						'To get more information about it please visit to <a href="http://services.web-console.org" title="Read more information about Web Console Group services" target="_blank">Web Console Group services</a> page.'.
						'</div>'.
						'<div class="installed-area-LOGIN">'.
						'<div id="_installed-LOGIN-button" class="installed-LOGIN-button">LOGIN TO WEB CONSOLE</div>'.
						'</div>'.
				       '</td></tr></table></div>'.
				       '<div class="installed-FOOTER">'.
				       # 'Thank you for <a href="http://www.web-console.org/donate/" title="Support '.$WC::c->{'APP_SETTINGS'}->{'name'}.' project" target="_blank">your support</a>!<br />'.
				       'Thank you for choosing <a href="http://www.web-console.org" target="_blank" title="Visit to '.$WC::c->{'APP_SETTINGS'}->{'name'}.' project official website">'.$WC::c->{'APP_SETTINGS'}->{'name'}.'</a>!'.
				       '</div>'.
				       '<script type="text/JavaScript"><!--'."\n".
					"NL.UI.div_button_register('installed-LOGIN-button', '_installed-LOGIN-button', function() { document.location = '".$WC::c->{'APP_SETTINGS'}->{'file_name'}."?logon_rand=".( time() )."'; }, {});"."\n".
					'//--></script>'
		},
		'html_MOD_PERL' => {
			'PAGE_TYPE' => 'warning',
			'PAGE_ACTION' => '',
			'page_title' => ':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: MOD_PERL detected',
			'main_title' => '<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: <span class="t-MARK-WARNING">MOD_PERL detected</span></a>',
			'main_info' => ''
		},
		'html_logon' => {
			'PAGE_TYPE' => 'logon',
			'page_title' => ':: '.$WC::c->{'APP_SETTINGS'}->{'name'}.' :: Logon',
			'main_title' => '<a href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' Logon</a>',
			'main_info' => '<div class="logon-TODO">Please enter login/password</div>',
			# User information
			'user_login' => '',
			'user_password' => ''
		},
		'html_console' => {
			'PAGE_TYPE' => 'console',
			'page_title' => ':: '.$WC::c->{'APP_SETTINGS'}->{'name'},
			'show_wellcome' => 1,
			# User information
			'user_login' => '',
			'user_password_encrypted' => '',
			'dir_current' => ''
		}
	};
}

# Showing HTML page
# IN: STRING - id of page, HASH_REF to hash with page information
# RETURN: NOTHING
sub show_page {
	my ($in_PAGE_ID, $in_STASH) = @_;
	$in_PAGE_ID = '' if (!defined $in_PAGE_ID);
	$in_STASH = {} if (!defined $in_STASH);

	my $WC_PAGE = '';
	# Making object with data to HTML
	my $WC_HTML = {};
	&_init_pages() if (!defined $WC::HTML::PAGES_DATA);
	$WC_HTML = $WC::HTML::PAGES_DATA->{ $in_PAGE_ID } if (defined $WC::HTML::PAGES_DATA->{ $in_PAGE_ID });
	$WC_HTML->{'APP_file'} = $WC::c->{'APP_SETTINGS'}->{'file_name'};

	if ($in_PAGE_ID eq 'html_logon') {
		$WC_PAGE = 'page_all_others';
		$WC_HTML->{'main_info'} .= '<div class="logon-DEMO">DEMO ACCESS: demo/demo</div>' if ($WC::DEMO); # NL_CODE: RM_LINE [DEMO_MODE]
	}
	elsif ($in_PAGE_ID eq 'html_console') {
		&WC::Dir::update_current_dir();
		$WC_HTML->{'dir_current'} = &NL::String::str_escape_JSON( &WC::Dir::get_current_dir() );
		$WC_HTML->{'dir_current'} = &NL::String::str_escape_JSON('/root/demo') if ($WC::DEMO); # NL_CODE: RM_LINE [DEMO_MODE]
		$WC_PAGE = 'page_console';
		$WC_HTML->{'ADDITIONAL_JAVASCRIPT'} = '';
		$WC_HTML->{'flag_show_warnings'} = 1;
		$WC_HTML->{'flag_show_welcome'} = 1;

		$WC_HTML->{'IS_DEMO'} = 0;
		$WC_HTML->{'IS_DEMO'} = $WC::DEMO; # NL_CODE: RM_LINE [DEMO_MODE]
		$WC_HTML->{'js_APP_SETTINGS_FILE_NAME'} = &NL::String::str_JS_value($WC::c->{'APP_SETTINGS'}->{'file_name'});
		$WC_HTML->{'STYLE_CONSOLE_FONT_FAMILY'} = $WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'family'};
		$WC_HTML->{'STYLE_CONSOLE_FONT_SIZE'} = $WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'size'};
		$WC_HTML->{'STYLE_CONSOLE_FONT_COLOR'} = $WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'color'};
		# Global settings
		if (defined $WC::c->{'config'} && defined $WC::c->{'config'}->{'logon'}) {
			$WC_HTML->{'flag_show_warnings'} = 0 if (defined $WC::c->{'config'}->{'logon'}->{'show_warnings'} && !$WC::c->{'config'}->{'logon'}->{'show_warnings'});
			$WC_HTML->{'flag_show_welcome'} = 0 if (defined $WC::c->{'config'}->{'logon'}->{'show_welcome'} && !$WC::c->{'config'}->{'logon'}->{'show_welcome'});
			if (defined $WC::c->{'config'}->{'logon'}->{'javascript'} && $WC::c->{'config'}->{'logon'}->{'javascript'} !~ /^[\r\n\t]{0,}$/) {
				$WC_HTML->{'ADDITIONAL_JAVASCRIPT'} .= "// Additional JavaScript :: Global JavaScript\n";
				$WC_HTML->{'ADDITIONAL_JAVASCRIPT'} .= $WC::c->{'config'}->{'logon'}->{'javascript'};
			}
		}
		# User settings
		if (defined $WC::c->{'user'} && defined $WC::c->{'user'}->{'additional'}) {
			if (defined $WC::c->{'user'}->{'additional'}->{'logon'}) {
				$WC_HTML->{'flag_show_warnings'} = $WC::c->{'user'}->{'additional'}->{'logon'}->{'show_warnings'} if (defined $WC::c->{'user'}->{'additional'}->{'logon'}->{'show_warnings'});
				$WC_HTML->{'flag_show_welcome'} = $WC::c->{'user'}->{'additional'}->{'logon'}->{'show_welcome'} if (defined $WC::c->{'user'}->{'additional'}->{'logon'}->{'show_welcome'});
				if (defined $WC::c->{'user'}->{'additional'}->{'logon'}->{'javascript'} && $WC::c->{'user'}->{'additional'}->{'logon'}->{'javascript'} !~ /^[\r\n\t]{0,}$/) {
					$WC_HTML->{'ADDITIONAL_JAVASCRIPT'} .= "\n" if ($WC_HTML->{'ADDITIONAL_JAVASCRIPT'} ne '');
					$WC_HTML->{'ADDITIONAL_JAVASCRIPT'} .= "// Additional JavaScript :: User JavaScript\n";
					$WC_HTML->{'ADDITIONAL_JAVASCRIPT'} .= $WC::c->{'user'}->{'additional'}->{'logon'}->{'javascript'};
				}
			}
		}
	}
	elsif ($in_PAGE_ID eq 'html_MOD_PERL') {
		$WC_PAGE = 'page_all_others';
		my $report = &WC::HTML::Report::make_REPORT_MOD_PERL([{
			'TYPE' => 'WARNING',
			'id' => 'MOD_PERL_DETECTED',
			'message' => $WC::c->{'APP_SETTINGS'}->{'name'}.' has detected <a class="m-bold" title="Read more information about mod_perl" target="_blank" href="http://perl.apache.org">mod_perl</a>, '.
				     'script &quot;<b>'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'</b>&quot; should be executed by web server without <b>mod_perl</b>.',
			'info' => 'Simple Apache configuration to run '.$WC::c->{'APP_SETTINGS'}->{'name'}.' without <b>mod_perl</b> will looks like that:'.
				  '<div class="report-block-MOD_PERL-code"><pre>AddHandler cgi-script .cgi .pl'."\n".
				  '&lt;Directory /var/www/web-console/&gt;'."\n".
				  '	AllowOverride All'."\n".
				  '	Options +FollowSymLinks +ExecCGI'."\n".
				  '&lt;/Directory&gt;</pre></div>'
		}]);
		$WC_HTML->{'main_info'} = $report->{'TEXT'};
	}
	elsif ($in_PAGE_ID eq 'html_install') {
		$WC_PAGE = 'page_all_others';
		$WC_HTML->{'ENCODE_ON'} = (&WC::Encode::IS_ENCODE_ON()) ? 1 : 0;
	}
	elsif ($in_PAGE_ID eq 'html_installed') { $WC_PAGE = 'page_all_others'; }
	elsif ($in_PAGE_ID eq 'html_error') { $WC_PAGE = 'page_all_others'; }
	elsif ($in_PAGE_ID eq 'html_warning') { $WC_PAGE = 'page_all_others'; }
	elsif ($in_PAGE_ID eq 'html_info') { $WC_PAGE = 'page_all_others'; }
	else {
		&show_error('Incorrect call of \'WC::HTML::show_page\'', 'That is very strange, looks like some plugin has made incorrect call', 'ERROR_WC_HTML_SHOW_PAGE_INCORRECT_CALL');
	}

	if ($WC_PAGE ne '') { &_print_HTML($WC_PAGE, $WC_HTML, $in_STASH); }
}

sub show_info { &_show_REPORT('html_info', \@_); }
sub show_warning { &_show_REPORT('html_warning', \@_); }
sub show_error {  &_show_REPORT('html_error', \@_); }
# Showing REPORT with ERROR, WARNING or INFORMATION (internal)
# IN: (ID, ARRAY_REF to ARRAY with report elements) | (ELEMENT_MESSAGE, ELEMENT_INFO, ELEMENT_ID)
# RETURN: NOTHING
sub _show_REPORT {
	my ($in_TYPE, $in_PARAMS) = @_;

	# Making ELEMENTS for report
	my $ref_ELEMENTS = [];
	if (defined $in_PARAMS && scalar @{ $in_PARAMS } > 0) {
		if (ref $in_PARAMS->[0] eq 'ARRAY') { $ref_ELEMENTS = $in_PARAMS->[0]; }
		else {
			my $element_type = 'INFORMATION';
			if ($in_TYPE eq 'html_warning') { $element_type = 'WARNING'; }
			elsif ($in_TYPE eq 'html_error') { $element_type = 'ERROR'; }

			my ($in_msg, $in_info, $in_id) = @{ $in_PARAMS };
			$ref_ELEMENTS = [{'TYPE' => $element_type, 'id' => (defined $in_id) ? $in_id : '', 'message' => (defined $in_msg) ? $in_msg : '', 'info' => (defined $in_info) ? $in_info : ''}];
		}
	}

	# Generating report
	my $report = {};
	if (scalar @{ $ref_ELEMENTS } > 0) { $report = &WC::HTML::Report::make_REPORT_MAIN($ref_ELEMENTS); }
	# Showing HTML page
	&show_page($in_TYPE, { 'main_info' => (defined $report->{'TEXT'}) ? $report->{'TEXT'} : '' });
}

# Getting HTML message 'Incorrect input parameters'
# IN: STRING - Message
# RETURN: STRING - HTML
sub get_message_INCORRECT_PARAMETERS {
	my ($in_message) = @_;
	if (!defined $in_message) { $in_message = ['__UNKNOWN_MESSAGE__']; }
	else { if (!ref $in_message) { $in_message = [$in_message]; } }

	# Preparing result
	my $result = '';
	foreach (@{ $in_message }) { $result .= '&nbsp;&nbsp;-&nbsp;'.(&NL::String::str_HTML_full($_));	}
	return &get_message('INCORRECT INPUT PARAMETERS', $result);
}
# Getting HTML message
# IN: STRING - Title, STRING - Message
# RETURN: STRING - HTML
sub get_message_GOOD {
	my ($in_message) = @_;
	if (!defined $in_message) { $in_message = '__UNKNOWN_MESSAGE__'; }
	return '<div class="t-lime">&nbsp;&nbsp;&nbsp;<span class="t-blue">***</span>&nbsp;'.(&NL::String::str_HTML_full($in_message)).'</div>';
}
# Getting HTML message
# IN: STRING - Title, STRING - Message, HASH_REF - HASH with settings
# RETURN: STRING - HTML
sub get_message {
	my ($in_title, $in_message, $in_settings) = @_;
	if (!defined $in_title) { $in_title = '__NO_TITLE__'; }
	if (!defined $in_message) { $in_message = '__UNKNOWN_MESSAGE__'; }
	if (!defined $in_settings) { $in_settings = {}; }

	# Making HTML and returning it
	if (defined $in_settings->{'AUTO_BR'} && $in_settings->{'AUTO_BR'}) {
		&NL::String::str_trim(\$in_message);
		$in_message =~ s/^/  - /;
		$in_message =~ s/\n/\n    /g;
	}
	if (!defined $in_settings->{'ENCODE_TO_HTML'} || $in_settings->{'ENCODE_TO_HTML'}) { $in_message = &NL::String::str_HTML_full($in_message); }
	return '<div class="t-lime">'.$in_title.':</div><div class="t-blue">'.$in_message.'</div>';
}
# Getting short HTML value message with full message at title
# IN: STRING - message, NUMBER - max length
# RETURN: STRING - HTML
sub get_short_value {
	my ($in_message, $in_SETTINGS) = @_;
	if (!defined $in_message) { $in_message = '__NO_DATA__'; }
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'MAX_LENGTH'} = 40 if (!defined $in_SETTINGS->{'MAX_LENGTH'});

	my $str = '<span class="s-link" style="cursor: help; font-style: normal" title="'.( &NL::String::str_HTML_value($in_message) ).'">'.( &NL::String::str_HTML_value(&NL::String::get_right($in_message, $in_SETTINGS->{'MAX_LENGTH'}, 1)) ).'</span>';
	if (!defined $in_SETTINGS->{'NO_QUOT'} && !$in_SETTINGS->{'NO_QUOT'}) { $str = '&quot;'.$str.'&quot;'; }
	return $str;
}

# Getting CSS for HTML page (internal)
# IN: PAGE_ID - id of page
# RETURN: STRING
sub _get_CSS {
	my ($in_ID) = @_;

	if ($in_ID eq 'page_all_others') {
		# NL_CODE: CSS_PAGE_OTHER
		return '';
		# NL_CODE: / CSS_PAGE_OTHER
	}
	elsif ($in_ID eq 'page_console') {
		# NL_CODE: CSS_PAGE_CONSOLE
		return '';
		# NL_CODE: / CSS_PAGE_CONSOLE
	}
	return '';
}
# Prining HTML page (internal)
# IN: PAGE_ID - id of page, HASH_REF to hash with default page information, HASH_REF to hash with new page information
# RETURN: NOTHING
sub _print_HTML {
	my ($in_ID, $in_ref_WC_HTML, $in_ref_STASH) = @_;
	my %WC_HTML =  %{ $in_ref_WC_HTML };
	foreach (keys %WC_HTML) { $WC_HTML{$_} = $in_ref_STASH->{$_} if (defined $in_ref_STASH->{$_}); }

	if ($in_ID eq 'page_all_others') {
		$WC_HTML{'__CSS__'} = &_get_CSS($in_ID);
		# NL_CODE: INCLUDE_HTML 'page_all_others.html'
		&WC::Debug::incude_html($WC::c->{'config'}->{'directorys'}->{'home'}.$WC::c->{'config'}->{'directorys_splitter'}.'page_all_others.html', \%WC_HTML);
		# NL_CODE: / INCLUDE_HTML
	}
	elsif ($in_ID eq 'page_console') {
		$WC_HTML{'__CSS__'} = &_get_CSS($in_ID);
		# NL_CODE: INCLUDE_HTML 'page_console.html'
		&WC::Debug::incude_html($WC::c->{'config'}->{'directorys'}->{'home'}.$WC::c->{'config'}->{'directorys_splitter'}.'page_console.html', \%WC_HTML);
		# NL_CODE: / INCLUDE_HTML
	}
}

1; #EOF
