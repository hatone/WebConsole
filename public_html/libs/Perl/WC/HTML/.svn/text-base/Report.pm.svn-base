#!/usr/bin/perl
# WC::HTML::Report - Web Console HTML Report manipulations
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::HTML::Report;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
$WC::HTML::Report::DATA = {
	'DYNAMIC' => {
		'IS_DATA_LOADED' => 0,
		'DATA' => {}
	}
};
# Initialization of DATA for reports, called and cached when we need report (internal)
# IN: NOTHING
# RETURN: NOTHING
sub _init_DATA {
	$WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'} = {
		# REPORTS SETTINGS
		'SETTINGS_MAIN' => {
			'VALUES_TO_HTML' => 1,
			'TYPES' => ['ERROR', 'WARNING', 'INFORMATION'],
			'REQUIRED_IN' => ['TYPE', 'message'],
			'TEMPLATES' => {
				'_ELEMENTS_SPLITTER_' => '<div class="report-SPLITTER"></div>',
				'_REPORT_TYPES_' => {
					'ERROR' => '<table class="report-LAYOUT"><tr><td>[_BEFORE]<div class="report-title-ERROR">[_TITLE]</div><div class="report-MAIN">[_REPORT_ELEMENTS_]</div>[<div class="report-FOOTER">[_FOOTER]</div>][_AFTER]</td></tr></table>',
					'WARNING' => '<table class="report-LAYOUT"><tr><td>[_BEFORE]<div class="report-title-WARNING">[_TITLE]</div><div class="report-MAIN">[_REPORT_ELEMENTS_]</div>[<div class="report-FOOTER">[_FOOTER]</div>][_AFTER]</td></tr></table>',
					'INFORMATION' => '<table class="report-LAYOUT"><tr><td>[_BEFORE]<div class="report-title-INFORMATION">[_TITLE]</div><div class="report-MAIN">[_REPORT_ELEMENTS_]</div>[<div class="report-FOOTER">[_FOOTER]</div>][_AFTER]</td></tr></table>',
					'_REPORT_ELEMENTS_' => {
						'ERROR' => '<span class="report-t-ERROR">ERROR:</span>&nbsp;[message][_INFO_][_FAQ_ID_ || _FAQ_LINK_]',
						'WARNING' => '<span class="report-t-WARNING">WARNING:</span>&nbsp;[message][_INFO_][_FAQ_ID_ || _FAQ_LINK_]',
						'INFORMATION' => '<span class="report-t-INFORMATION">INFORMATION:</span>&nbsp;[message][_INFO_][_FAQ_ID_ || _FAQ_LINK_]',
						'_ELEMENT_PARTS_' => {
							'_INFO_' => '[<div class="report-b-INFO">[info]</div>]',
							'_FAQ_ID_' => '[<div class="report-b-FAQ">&#187; read solution for that problem at '.
								    '<a href="'.$WC::CONST->{'URLS'}->{'FAQ_ID'}.'[id]" target="_blank" '.
								    'title="Read detailed solution for that problem">Web Console FAQ</a></div>]',
							'_FAQ_LINK_' => '<div class="report-b-FAQ">&#187; you can try to find solution for that problem at '.
									'<a href="'.$WC::CONST->{'URLS'}->{'FAQ'}.'" target="_blank" '.
									'title="Read Web Console FAQ">Web Console FAQ</a></div>'
						}
					}
				}
			}
		},
		'SETTINGS_PARAMETERS' => {
			'VALUES_TO_HTML' => 0,
			'TYPES' => ['ERROR'],
			'REQUIRED_IN' => ['TYPE', 'variable', 'message'],
			'TEMPLATES' => {
				'_ELEMENTS_SPLITTER_' => '<br />',
				'_REPORT_TYPES_' => {
					'ERROR' => '<table class="report-LAYOUT"><tr><td>[_BEFORE]<div class="report-title-WARNING">[_TITLE]</div><div class="report-MAIN">[_REPORT_ELEMENTS_]</div>[<div class="report-FOOTER">[_FOOTER]</div>][_AFTER]</td></tr></table>',
					'_REPORT_ELEMENTS_' => {
						'ERROR' => '&nbsp;&nbsp;<span class="report-dash">&mdash;</span>&nbsp;\'<span class="report-variable-name"><a href="#" onclick="WC.Other.set_focus(\'[html_element]\'); return false" title="Click to activate that element" onmouseover="if (window) { window.status=\'Click to activate that element\'; } return true" onmouseout="if (window) { window.status=\'\'; } return true">[variable]</a></span>\' [message]',
						'_ELEMENT_PARTS_' => {
						}
					}
				}
			}
		},
		# REPORT PARAMETERS
		'REPORT_MAIN' => {
			'ALL_title' => 'Details:',
			'ALL_footer' => 'If you need some help, you can visit <a href="http://forum.web-console.org" title="Visit '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FORUM" target="_blank">'.$WC::c->{'APP_SETTINGS'}->{'name'}.' FORUM</a>'
		},
		'REPORT_INSTALL' => {
			'ERROR_title' => 'Permissions problems:',
			'ERROR_footer' => 'Please resolve that problems, after that you can install '.$WC::c->{'APP_SETTINGS'}->{'name'}.'.<br />'.
					  'You can read detailed installation instructions <a href="http://www.web-console.org/installation/" title="Read detailed '.$WC::c->{'APP_SETTINGS'}->{'name'}.' installation instruction (with screenshots)" target="_blank">here</a>.',
			'WARNING_title' => 'Installation warnings:',
			'WARNING_footer' => 'You can install '.$WC::c->{'APP_SETTINGS'}->{'name'}.' but we recomend fix that warnings before.<br />'.
					    'You can read detailed installation instructions <a href="http://www.web-console.org/installation/" title="Read detailed '.$WC::c->{'APP_SETTINGS'}->{'name'}.' installation instructions (with screenshots)" target="_blank">here</a>.',
			'WARNING_AFTER' => '<div class="install-TODO">Please enter login, password and e-mail for the new '.$WC::c->{'APP_SETTINGS'}->{'name'}.' administrator:</div>',
		},
		'REPORT_PARAMETERS' => {
			'ALL_title' => 'Incorrect parameters:',
			'ALL_footer' => 'Please fix that parameters.<br />'.
					'You can read detailed installation instructions <a href="http://www.web-console.org/installation/" title="Read detailed '.$WC::c->{'APP_SETTINGS'}->{'name'}.' installation instruction (with screenshots)" target="_blank">here</a>.',
			'ALL_AFTER' => '<div class="install-TODO">Please enter login, password and e-mail for the new '.$WC::c->{'APP_SETTINGS'}->{'name'}.' administrator:</div>',
		},
		'REPORT_MOD_PERL' => {
			'ALL_title' => 'MOD_PERL detected:',
			'ALL_footer' => 'Please configure your web server to run &quot;<b>'.$WC::c->{'APP_SETTINGS'}->{'file_name'}.'</b>&quot; script without <b>mod_perl</b>.'
		}
	};
	$WC::HTML::Report::IS_DATA_LOADED = 1;
}
# Report generation wrappers
# IN:
#     [
#         { 'TYPE' => STRING, '<name>' => '<value>'[, '<nameN>' => '<valueN>'] },
#         ...
#     ]
# OUT: { 'TYPE' => STRING, 'TEXT' => STRING }
sub make_REPORT_MAIN {
	&_init_DATA() if (!$WC::HTML::Report::IS_DATA_LOADED);
	return &NL::Report::make_REPORT_EXT($WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'SETTINGS_MAIN'}, $_[0], $WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'REPORT_MAIN'});
}
sub make_REPORT_INSTALL {
	&_init_DATA() if (!$WC::HTML::Report::IS_DATA_LOADED);
	return &NL::Report::make_REPORT_EXT($WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'SETTINGS_MAIN'}, $_[0], $WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'REPORT_INSTALL'});
}
sub make_REPORT_MOD_PERL {
	&_init_DATA(); # For MOD_PERL we always need to reinit DATA
		       # if (!$WC::HTML::Report::IS_DATA_LOADED);
	return &NL::Report::make_REPORT_EXT($WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'SETTINGS_MAIN'}, $_[0], $WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'REPORT_MOD_PERL'});
}
sub make_REPORT_PARAMETERS {
	&_init_DATA() if (!$WC::HTML::Report::IS_DATA_LOADED);
	return &NL::Report::make_REPORT_EXT($WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'SETTINGS_PARAMETERS'}, $_[0], $WC::HTML::Report::DATA->{'DYNAMIC'}->{'DATA'}->{'REPORT_PARAMETERS'});
}

1; #EOF
