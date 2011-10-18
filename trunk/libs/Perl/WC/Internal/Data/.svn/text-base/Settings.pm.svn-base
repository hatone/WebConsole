#!/usr/bin/perl
# WC::Internal::DATA::Settings - Web Console 'Internal' SETTINGS DATA module
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::Internal::Data::Settings;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Internal::Data::Settings::ENCODINGS_LIST = [
	'UTF-8', 'af_ZA.ISO8859-1', 'af_ZA.ISO8859-15', 'af_ZA.UTF-8', 'am_ET.UTF-8', 'be_BY.CP1131', 'be_BY.CP1251', 'be_BY.ISO8859-5',
	'be_BY.UTF-8', 'bg_BG.CP1251', 'bg_BG.UTF-8', 'ca_ES.ISO8859-1', 'ca_ES.ISO8859-15', 'ca_ES.UTF-8', 'cs_CZ.ISO8859-2',
	'cs_CZ.UTF-8', 'da_DK.ISO8859-1', 'da_DK.ISO8859-15', 'da_DK.UTF-8', 'de_AT.ISO8859-1', 'de_AT.ISO8859-15', 'de_AT.UTF-8',
	'de_CH.ISO8859-1', 'de_CH.ISO8859-15', 'de_CH.UTF-8', 'de_DE.ISO8859-1', 'de_DE.ISO8859-15', 'de_DE.UTF-8', 'el_GR.ISO8859-7',
	'el_GR.UTF-8', 'en_AU.ISO8859-1', 'en_AU.ISO8859-15', 'en_AU.US-ASCII', 'en_AU.UTF-8', 'en_CA.ISO8859-1', 'en_CA.ISO8859-15',
	'en_CA.US-ASCII', 'en_CA.UTF-8', 'en_GB.ISO8859-1', 'en_GB.ISO8859-15', 'en_GB.US-ASCII', 'en_GB.UTF-8', 'en_IE.UTF-8',
	'en_NZ.ISO8859-1', 'en_NZ.ISO8859-15', 'en_NZ.US-ASCII', 'en_NZ.UTF-8', 'en_US.ISO8859-1', 'en_US.ISO8859-15', 'en_US.US-ASCII',
	'en_US.UTF-8', 'es_ES.ISO8859-1', 'es_ES.ISO8859-15', 'es_ES.UTF-8', 'et_EE.ISO8859-15', 'et_EE.UTF-8', 'fi_FI.ISO8859-1',
	'fi_FI.ISO8859-15', 'fi_FI.UTF-8', 'fr_BE.ISO8859-1', 'fr_BE.ISO8859-15', 'fr_BE.UTF-8', 'fr_CA.ISO8859-1', 'fr_CA.ISO8859-15',
	'fr_CA.UTF-8', 'fr_CH.ISO8859-1', 'fr_CH.ISO8859-15', 'fr_CH.UTF-8', 'fr_FR.ISO8859-1', 'fr_FR.ISO8859-15', 'fr_FR.UTF-8',
	'he_IL.UTF-8', 'hi_IN.ISCII-DEV', 'hr_HR.ISO8859-2', 'hr_HR.UTF-8', 'hu_HU.ISO8859-2', 'hu_HU.UTF-8', 'hy_AM.ARMSCII-8',
	'hy_AM.UTF-8', 'is_IS.ISO8859-1', 'is_IS.ISO8859-15', 'is_IS.UTF-8', 'it_CH.ISO8859-1', 'it_CH.ISO8859-15', 'it_CH.UTF-8',
	'it_IT.ISO8859-1', 'it_IT.ISO8859-15', 'it_IT.UTF-8', 'ja_JP.SJIS', 'ja_JP.UTF-8', 'ja_JP.eucJP', 'kk_KZ.PT154', 'kk_KZ.UTF-8',
	'ko_KR.CP949', 'ko_KR.UTF-8', 'ko_KR.eucKR', 'la_LN.ISO8859-1', 'la_LN.ISO8859-15', 'la_LN.ISO8859-2', 'la_LN.ISO8859-4',
	'la_LN.US-ASCII', 'lt_LT.ISO8859-13', 'lt_LT.ISO8859-4', 'lt_LT.UTF-8', 'nl_BE.ISO8859-1', 'nl_BE.ISO8859-15', 'nl_BE.UTF-8',
	'nl_NL.ISO8859-1', 'nl_NL.ISO8859-15', 'nl_NL.UTF-8', 'no_NO.ISO8859-1', 'no_NO.ISO8859-15', 'no_NO.UTF-8', 'pl_PL.ISO8859-2',
	'pl_PL.UTF-8', 'pt_BR.ISO8859-1', 'pt_BR.UTF-8', 'pt_PT.ISO8859-1', 'pt_PT.ISO8859-15', 'pt_PT.UTF-8', 'ro_RO.ISO8859-2',
	'ro_RO.UTF-8', 'ru_RU.CP1251', 'ru_RU.CP866', 'ru_RU.ISO8859-5', 'ru_RU.KOI8-R', 'ru_RU.UTF-8', 'sk_SK.ISO8859-2', 'sk_SK.UTF-8',
	'sl_SI.ISO8859-2', 'sl_SI.UTF-8', 'sr_YU.ISO8859-2', 'sr_YU.ISO8859-5', 'sr_YU.UTF-8', 'sv_SE.ISO8859-1', 'sv_SE.ISO8859-15',
	'sv_SE.UTF-8', 'tr_TR.ISO8859-9', 'tr_TR.UTF-8', 'uk_UA.ISO8859-5', 'uk_UA.KOI8-U', 'uk_UA.UTF-8', 'zh_CN.GB18030', 'zh_CN.GB2312',
	'zh_CN.GBK', 'zh_CN.UTF-8', 'zh_CN.eucCN', 'zh_HK.Big5HKSCS', 'zh_HK.UTF-8', 'zh_TW.Big5', 'zh_TW.UTF-8'
];

$WC::Internal::Data::MESSAGES->{'PARAMETER_GET_SET'} = 'To get current value - just press "ENTER", to set parameter - type value and press "ENTER".';
$WC::Internal::Data::MESSAGES->{'PARAMETER_EXAMPLE_'} = 'Example:'."\n";
$WC::Internal::Data::MESSAGES->{'PARAMETER_GET_SET_EXAMPLE_'} = $WC::Internal::Data::MESSAGES->{'PARAMETER_GET_SET'}."\n".$WC::Internal::Data::MESSAGES->{'PARAMETER_EXAMPLE_'};

$WC::Internal::DATA::ALL->{'#settings'} = {
	'__doc__' => 'View/edit Web Console configuration',
	'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'view/edit Web Console configuration.',
	'_save_form' => sub {
		my ($in_CMD) = @_;
		$in_CMD = '' if (!defined $in_CMD);
		my $result = '';

		# Parsing parameters
		my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD);
		# Getting additional parameters
		my $hash_ADDITIONAL = {};
		if (defined $hash_PARAMS->{'info_additional'} && $hash_PARAMS->{'info_additional'} !~ /^[ \t\r\n]{0,}$/) {
			my $pasre_JSON = &NL::String::JSON_to_HASH($hash_PARAMS->{'info_additional'});
			if ($pasre_JSON->{'ID'}) {
				$hash_ADDITIONAL = $pasre_JSON->{'HASH'};
				delete $hash_PARAMS->{'info_additional'};
				&NL::Utils::hash_merge($hash_PARAMS, $hash_ADDITIONAL);
			}
			else {
				$result = &WC::HTML::get_message("CONFIGURATION CAN'T BE SAVED", '  - "Additional options" JSON can\'t be parsed, please ensure that entered JSON is correct');
			}
		}
		if ($result eq '') {
			# Setting parameters groups
			&NL::Parameter::make_groups($hash_PARAMS, {
				'dir_' => 'directorys',
				'encoding_' => 'encodings',
				'logon_' => 'logon',
				'style_' => {
					'*' => 'styles',
					'console_' => {
						'*' => 'console',
						'font_' => 'font'
					}
				},
				'startup_' => 'startup',
				'uploading_' => 'uploading'
			});
			# Checking parameters
			my $check_RESULT = &NL::Parameter::check($hash_PARAMS, {
				# Directorys
				'directorys|temp' => { 'name' => 'Directory/Temp', 'needed' => 0, 'if_undefined_or_empty_set' => $WC::c->{'config'}->{'directorys'}->{'temp'}, 'func_CHECK' => \&NL::Parameter::FUNC_CHECK_directory },
				'directorys|work' => { 'name' => 'Directory/Work', 'needed' => 0, 'if_undefined_or_empty_set' => $WC::c->{'config'}->{'directorys'}->{'work'}, 'func_CHECK' => \&NL::Parameter::FUNC_CHECK_directory },
				# Encodings
				'encodings|server_console' => { 'name' => 'Encoding/Server console', 'needed' => 0, 'if_undefined_or_empty_set' => '' },
				'encodings|server_system' => { 'name' => 'Encoding/Server system', 'needed' => 0, 'if_undefined_or_empty_set' => '' },
				'encodings|editor_text' => { 'name' => 'Encoding/Text editor', 'needed' => 0, 'if_undefined_or_empty_set' => '' },
				'encodings|file_download' => { 'name' => 'Encoding/Downloading (file name)', 'needed' => 0, 'if_undefined_or_empty_set' => '' },
				# Logon
				'logon|show_welcome' => { 'name' => 'Logon/Show welcome message on logon', 'needed' => 0, 'if_undefined_or_empty_set' => 0 },
				'logon|show_warnings' => { 'name' => 'Logon/Show warnings', 'needed' => 0, 'if_undefined_or_empty_set' => 0 },
				'logon|javascript' => { 'name' => 'Global startup JavaScript', 'needed' => 0, 'if_undefined_or_empty_set' => '' },
				# Style
				'styles|console|font|color' => { 'name' => 'Console font styles/Color', 'needed' => 0, 'if_undefined_or_empty_set' => $WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'color'} },
				'styles|console|font|size' => { 'name' => 'Console font styles/Size', 'needed' => 0, 'if_undefined_or_empty_set' => $WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'size'} },
				'styles|console|font|family' => { 'name' => 'Console font styles/Family', 'needed' => 0, 'if_undefined_or_empty_set' => $WC::c->{'config'}->{'styles'}->{'console'}->{'font'}->{'family'} }
			});

			if (!$check_RESULT->{'ID'}) { $result = &WC::HTML::get_message("CONFIGURATION CAN'T BE SAVED", '  - '.$check_RESULT->{'ERROR_MESSAGE'}); }
			else {
				if (!&WC::Config::Main::save($hash_PARAMS)) { $result = &WC::HTML::get_message("CONFIGURATION CAN'T BE SAVED", '  - '.(&WC::Config::Main::get_last_error_TEXT())); }
				else { $result = &WC::HTML::get_message_GOOD("CONFIGURATION HAS BEEN SUCCESSFULLY SAVED"); }
			}
		}
		return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
	},
	'_settings_FORM' => sub {
			my $ID = &WC::Internal::get_unique_id();
			my %HTML_HASH = (
				'TITLE' => 'Web Console Configuration',
				'INFO' => 'Main Web Console parameters &mdash; directorys, files, flags...',
				'MESSAGE' => 'When you click "Save" button, configuration saving will be executed as new command. '.
					     'At bottom of the window you will see it, at that command result you will see result of configuration saving.<br />'.
					     'That configuration box will not be closed after configuration saving and you can change something again '.
					     '(that is usable when you testing your modifications at another browser window).<br />'.
					     'If you don\'t want to modify configuration just click "Close" button.',
				'DATA_ADDITIONAL' => ''
			);

			my $CONFIG_DATA = {};
			&NL::Parameter::clone($CONFIG_DATA, $WC::c->{'config'});

			my %HTML_HASH_CONFIG = %{ &NL::Parameter::grab($CONFIG_DATA, [
					# Directorys
					'directorys|work',
					'directorys|temp',
					'directorys|home',
					'directorys|data',
					'directorys|configs',
					'directorys|plugins',
					'directorys|plugins_configs',
					# Files
					'files|config',
					'files|users',
					'files|.HTACCESS',
					# Logon
					'logon|javascript',
					'logon|show_welcome',
					'logon|show_warnings',
					# Encodings
					'encodings|internal',
					'encodings|server_console',
					'encodings|server_system',
					'encodings|editor_text',
					'encodings|file_download',
					# Styles
					'styles|console|font|family',
					'styles|console|font|size',
					'styles|console|font|color',
					# Uploading
					'uploading|limit'
				],
				{
					'REMOVE_FROM_SOURCE' => 1,
					'REMOVE_FROM_SOURCE_NODES' => 1,
					'SET_NOT_FOUND_EMPTY' => 1,
					# 'func_ENCODE' => \&NL::String::str_HTML_value
					'func_ENCODE' => sub {
						my ($in_val) = @_;
						$in_val = &NL::String::str_HTML_value($in_val);
						$in_val =~ s/\r//g;
						return $in_val;
					}
				}
			) };
			$HTML_HASH{'MAIN_FLAG_SHOW_WELCOME'} = (defined $HTML_HASH_CONFIG{'logon'}{'show_welcome'} && $HTML_HASH_CONFIG{'logon'}{'show_welcome'}) ? ' checked="checked"' : '';
			$HTML_HASH{'MAIN_FLAG_SHOW_WARNINGS'} = (defined $HTML_HASH_CONFIG{'logon'}{'show_warnings'} && $HTML_HASH_CONFIG{'logon'}{'show_warnings'}) ? ' checked="checked"' : '';
			&NL::Parameter::remove($CONFIG_DATA, ['directorys_splitter']);

			# Additional DATA
			if (scalar keys %{ $CONFIG_DATA } > 0) {
				$HTML_HASH{'DATA_ADDITIONAL'} = &NL::String::str_HTML_value( &NL::String::VAR_to_JSON($CONFIG_DATA, { 'SPACES' => 1 }) );
			}

			my $result_ENCODINGS = '';
			foreach (@{ $WC::Internal::Data::Settings::ENCODINGS_LIST }) {
				$result_ENCODINGS .= ", " if ($result_ENCODINGS  ne '');
				$result_ENCODINGS .= '<a class="link" href="#" onclick="var v = NL.Form.value_get(\'_encodings_ACTIVE_INPUT-'.$ID.'\'); if (v) NL.Form.value_set(v, \''.$_.'\', 1); else this.blur(); return false" title="Click to paste at active (or last active) encodings input">'.$_.'</a>';
			}
			# Setting ERROR information for 'Encode.pm' if it's needed
			my $HTML_ENCODE_PM_MESSAGE = '';
			if (!$WC::Encode::ENCODE_ON) {
				my $error_HTML = $WC::Encode::ENCODE_ERROR;
				$error_HTML = &NL::String::fix_width($error_HTML, 70);
				&NL::String::str_HTML_value(\$error_HTML);
				$error_HTML =~ s/\n/<br \/>/g;
				$HTML_ENCODE_PM_MESSAGE = <<HTML_EOF;
			<tr><td class="area-main s-warning" style="padding-top: 9px; font-weight: bold;" colspan="2">*** WARNING:</td></tr>
			<tr>
				<td class="area-tabbed s-warning" colspan="2">
					ENCODINGS CONVERSION WILL BE DISABLED.<br />
					Unable to load 'Encode.pm' Perl module, that module is needed for encodings conversion.<br />
					You can download that Perl module from CPAN: <a class="link-warning" href="http://search.cpan.org/~dankogai/Encode/Encode.pm" target="_blank">http://search.cpan.org/~dankogai/Encode/Encode.pm</a>
					<br />
					<span class="s-warning" style="font-weight: bold;">Additional information:</span><br />
					<div class="s-warning" style="margin-top: 0; height: 32px; overflow: auto">$error_HTML</div>
				</td>
			</tr>
HTML_EOF
			}
			# Setting ERROR information for 'CGI.pm' if it's needed
			my $HTML_CGI_PM_MESSAGE = '';
			# Initializing 'NL::AJAX::Upload'
			&WC::Upload::_set_NL_INIT();
			my $init_UPLOAD = &NL::AJAX::Upload::init($WC::Upload::NL_INIT);
			if (!$init_UPLOAD->{'ID'}) {
				my $error_HTML = $init_UPLOAD->{'ERROR_MSG'};
				$error_HTML = &NL::String::fix_width($error_HTML, 70);
				&NL::String::str_HTML_value(\$error_HTML);
				$error_HTML =~ s/\n/<br \/>/g;
				$HTML_CGI_PM_MESSAGE = <<HTML_EOF;
			<tr><td class="area-main s-warning" style="padding-top: 9px; font-weight: bold;" colspan="2">*** WARNING:</td></tr>
			<tr>
				<td class="area-tabbed s-warning" colspan="2">
					UPLOADING WILL BE DISABLED.<br />
					Unable to load 'CGI.pm' Perl module, that module is needed for uploading.<br />
					You can download that Perl module from CPAN: <a class="link-warning" href="http://search.cpan.org/~lds/CGI.pm/CGI.pm" target="_blank">http://search.cpan.org/~lds/CGI.pm/CGI.pm</a>
					<br /><br />
					<span class="s-warning" style="font-weight: bold;">Additional information:</span><br />
					<div class="s-warning" style="margin-top: 3px; height: 100px; overflow: auto">$error_HTML</div>
				</td>
			</tr>
HTML_EOF
			}

			my $result_DIVS = <<HTML_EOF;
	<div id="wc-settings-DIV-MAIN-$ID">
		<form id="wc-settings-form-MAIN-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">$HTML_HASH{'INFO'}</td></tr>
			<tr><td class="area-main s-group-name" colspan="2"><span>Directorys:</span></td></tr>
			<tr>
				<td class="area-left-short"><span>Work:</span></td>
				<td class="area-right-long"><input class="in-text w-600" type="text" id="_main_dir_work-${ID}" name="main_dir_work-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'work'}" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span>Temp:</span></td>
				<td class="area-right-long"><input class="in-text w-600" type="text" id="_main_dir_temp-${ID}" name="main_dir_temp-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'temp'}" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Home:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_home-${ID}" name="main_dir_home-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'home'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Data:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_data-${ID}" name="main_dir_data-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'data'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Configs:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_configs-${ID}" name="main_dir_configs-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'configs'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Plugins:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_plugins-${ID}" name="main_dir_plugins-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'plugins'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Plugins configs:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_dir_plugins_configs-${ID}" name="main_dir_plugins_configs-${ID}" value="$HTML_HASH_CONFIG{'directorys'}{'plugins_configs'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr><td class="area-main s-group-name" colspan="2"><span>Files:</span></td></tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Config:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_file_config-${ID}" name="main_file_config-${ID}" value="$HTML_HASH_CONFIG{'files'}{'config'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">Users DB:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_file_users_db-${ID}" name="main_file_users_db-${ID}" value="$HTML_HASH_CONFIG{'files'}{'users'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="disabled" title="Element is readonly">.HTACCESS:</span></td>
				<td class="area-right-long"><input class="in-text w-600 disabled" type="text" id="_main_file_htaccess-${ID}" name="main_file_htaccess-${ID}" value="$HTML_HASH_CONFIG{'files'}{'.HTACCESS'}" title="Element is readonly" readonly /></td>
			</tr>
			<tr><td class="area-main s-group-name" colspan="2"><span>Logon flags:</span></td></tr>

			<tr><td class="area-tabbed" colspan="2">
				<table class="grid">
				<tr>
					<td class="area-left-short" style="vertical-align: top"><input class="in-checkbox" type="checkbox" id="_main_flag_logon_show_welcome-$ID" name="main_flag_logon_show_welcome-$ID"$HTML_HASH{'MAIN_FLAG_SHOW_WELCOME'} value="1" /></td>
					<td class="area-right-long"><label class="s-message" for="_main_flag_logon_show_welcome-$ID">Show welcome message on logon<br /><span class="s-note s-message" style="cursor: help" title="When any user logons to Web Console - informational message will be printed">(informational message about Web Console usage and useful commands)</span></label></td>
				</tr>
				<tr>
					<td class="area-left-short" style="vertical-align: top"><input class="in-checkbox" type="checkbox" id="_main_flag_logon_show_warnings-$ID" name="main_flag_logon_show_warnings-$ID"$HTML_HASH{'MAIN_FLAG_SHOW_WARNINGS'} value="1" /></td>
					<td class="area-right-long"><label class="s-message" for="_main_flag_logon_show_warnings-$ID">Show warnings<br /><span class="s-note s-message" style="cursor: help" title="When any user logons to Web Console - warnings message will be printed">(informational message about Web Console warnings)</span></label></td>
				</tr>
				</table>
			</td></tr>

		</table></form>
	</div>
	<div id="wc-settings-DIV-ENCODINGS-$ID" style="display: none">
		<form id="wc-settings-form-ENCODINGS-${ID}" action="" onsubmit="return false" target="_blank">
		<input type="hidden" id="_encodings_ACTIVE_INPUT-${ID}" name="encodings_ACTIVE_INPUT-${ID}" value="" />
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">Web Console encodings settings.</td></tr>
			<tr>
				<td style="width: 10%; padding-right: 20px;">
					<table class="grid" style="width: 100%;">
						<tr>
							<td class="area-left-short"><span>Server console:</span></td>
							<td class="area-right-long"><input class="in-text w-200" type="text" id="_encoding_server_console-${ID}" name="encoding_server_console-${ID}" onclick="NL.Form.value_set('_encodings_ACTIVE_INPUT-${ID}', '_encoding_server_console-${ID}')" value="$HTML_HASH_CONFIG{'encodings'}{'server_console'}" /></td>
						</tr>
						<tr>
							<td class="area-left-short"><span>Server system:</span></td>
							<td class="area-right-long"><input class="in-text w-200" type="text" id="_encoding_server_system-${ID}" name="encoding_server_system-${ID}" onclick="NL.Form.value_set('_encodings_ACTIVE_INPUT-${ID}', '_encoding_server_system-${ID}')" value="$HTML_HASH_CONFIG{'encodings'}{'server_system'}" /></td>
						</tr>
						<tr>
							<td class="area-left-short"><span class="disabled" title="Element is readonly">Web Console:<br /><span class="s-note disabled">(internal)</span></td>
							<td class="area-right-long"><input class="in-text w-200 disabled" type="text" id="_main_file_config-${ID}" name="main_file_config-${ID}" value="$HTML_HASH_CONFIG{'encodings'}{'internal'}" title="Element is readonly" readonly /></td>
						</tr>
					</table>
				</td>
				<td style="width: 90%; vertical-align: top; text-align: left;">
					<table class="grid" style="width: 100%">
						<tr>
							<td class="area-left-short"><span>Text editor:</span></td>
							<td class="area-right-long"><input class="in-text w-200" type="text" id="_encoding_editor_text-${ID}" name="encoding_editor_text-${ID}" onclick="NL.Form.value_set('_encodings_ACTIVE_INPUT-${ID}', '_encoding_editor_text-${ID}')" value="$HTML_HASH_CONFIG{'encodings'}{'editor_text'}" /></td>
						</tr>
						<tr>
							<td class="area-left-short"><span>Downloading:<br /><span class="s-note">(filename)</span></span></td>
							<td class="area-right-long"><input class="in-text w-200" type="text" id="_encoding_file_download-${ID}" name="encoding_file_download-${ID}" onclick="NL.Form.value_set('_encodings_ACTIVE_INPUT-${ID}', '_encoding_file_download-${ID}')" value="$HTML_HASH_CONFIG{'encodings'}{'file_download'}" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td class="area-main s-group-name" style="padding-top: 9px" colspan="2"><span>Short manual:</span></td></tr>
			<tr>
				<td class="area-tabbed s-message" colspan="2">
					<span class="s-name">"Server console encoding"</span> is a encoding of server shell commands execution output (like 'ls', 'dir', ...).<br />
					<span class="s-name">"Server system encoding"</span> is a encoding of server internal commands (programming commands) output<br />
					(like getting listing of the directory using internal Perl function).<br />
					<span class="s-name">"Text editor encoding"</span> is a encoding for text files editor ('<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set('#file edit'); return false" title="Click to paste at command input">#file edit</a>'), if that field empty, then for text<br />files editor the <span class="s-name">"Server system encoding"</span> will be used.<br />
					<span class="s-name">"Downloading (filename)"</span> is a encoding for downloaded file names.<br />
					<div style="padding: 0; margin: 12px 0;">
						<span class="s-warning">Detailed information about setting Web Console encodings you can read <a class="link-warning" href="http://www.web-console.org/faq/#ENCODINGS_HOWTO" title="Read detailed information about setting Web Console encodings" target="_blank">here</a>.</span>
					</div>
HTML_EOF
			if ($HTML_ENCODE_PM_MESSAGE eq '') {
$result_DIVS .= <<HTML_EOF;
					Common encodings list:<br />
					<span class="s-warning s-note">(click at encoding to paste it at active (or last active) encodings input)</span>
					<div class="s-link" style="margin-top: 3px; padding: 3px 4px; border: solid 1px #333300; height: 81px; overflow: auto">${result_ENCODINGS}</div>
HTML_EOF
			}
			$result_DIVS .= <<HTML_EOF;
				</td>
			</tr>
			$HTML_ENCODE_PM_MESSAGE
		</table></form>
	</div>
	<div id="wc-settings-DIV-STYLE-$ID" style="display: none">
		<form id="wc-settings-form-STYLE-${ID}" action="" onsubmit="return false" target="_blank">
		<input type="hidden" id="_style_ACTIVE_INPUT-${ID}" name="style_ACTIVE_INPUT-${ID}" value="" />
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">Web Console style settings.</td></tr>
			<tr><td class="area-main s-group-name" colspan="2"><span>Console font styles:</span></td></tr>
			<tr>
				<td class="area-left-short"><span>Family:</span></td>
				<td class="area-right-long"><input class="in-text w-600" type="text" id="_style_console_font_family-${ID}" name="style_console_font_family-${ID}" onclick="NL.Form.value_set('_style_ACTIVE_INPUT-${ID}', '_style_console_font_family-${ID}')" value="$HTML_HASH_CONFIG{'styles'}{'console'}{'font'}{'family'}" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span>Color:</span></td>
				<td class="area-right-long"><input class="in-text w-200" type="text" id="_style_console_font_color-${ID}" name="style_console_font_color-${ID}" onclick="NL.Form.value_set('_style_ACTIVE_INPUT-${ID}', '_style_console_font_color-${ID}')" value="$HTML_HASH_CONFIG{'styles'}{'console'}{'font'}{'color'}" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span>Size:</span></td>
				<td class="area-right-long"><input class="in-text w-200" type="text" id="_style_console_font_size-${ID}" name="style_console_font_size-${ID}" onclick="NL.Form.value_set('_style_ACTIVE_INPUT-${ID}', '_style_console_font_size-${ID}')" value="$HTML_HASH_CONFIG{'styles'}{'console'}{'font'}{'size'}" /></td>
			</tr>
			<tr><td class="area-main s-group-name" style="padding-top: 9px" colspan="2"><span>Short manual:</span></td></tr>
			<tr>
				<td class="area-tabbed s-message" colspan="2">
					At the field <span class="s-name">"Console font styles / Family"</span> you can set console font family at the CSS 'font-family' format.<br />
					At the field <span class="s-name">"Console font styles / Color"</span> you can set console font color at the CSS 'color' format.<br />
					At the field <span class="s-name">"Console font styles / Size"</span> you can set console font size at the CSS 'font-size' format.<br />
					<br /><span class="s-warning">Values at these fields should be set according the CSS font specification ('font-family', 'font-size', 'color', ...).<br />
					Detailed information about setting Web Console style you can read <a class="link-warning" href="http://www.web-console.org/faq/#STYLE_HOWTO" title="Read detailed information about setting Web Console style" target="_blank">here</a>.</span><br />
					<br />Examples:<br />
					<span class="s-warning s-note">(click at value to paste it at active (or last active) style input)</span><br />
					- To set only one font family: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, 'courier', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">courier</a>"</span><br />
					- To set first available font family: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, 'fixedsys, courier new, courier, verdana, helvetica, arial, sans-serif', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">fixedsys, courier new, courier, verdana, helvetica, arial, sans-serif</a>"</span><br />
					- To set white font color: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, 'white', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">white</a>"</span> or <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, '#ffffff', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">#ffffff</a>"</span><br />
					- To restore default font color: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, '#bbbbbb', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">#bbbbbb</a>"</span><br />
					- To set font size at points or pixels: <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, '10pt', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">10pt</a>"</span> or <span class="s-link">"<a class="link" href="#" onclick="var v = NL.Form.value_get('_style_ACTIVE_INPUT-${ID}'); if (v) NL.Form.value_set(v, '14px', 1); else this.blur(); return false" title="Click to paste at active (or last active) style input">14px</a>"</span>
				</td>
			</tr>
		</table></form>
	</div>
	<div id="wc-settings-DIV-STARTUPJS-${ID}" style="display: none">
		<form id="wc-settings-form-STARTUPJS-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr>
				<td class="area-top s-info">Web Console global startup JavaScript:<br />
				<span class="s-note s-info" style="cursor: help" title="When any user logons to Web Console - that JavaScript will be executed">(will be executed after any user logon and before user personal JavaScript execution if it's defined)</span>
				</td>
			</tr>
			<tr><td class="area-main"><textarea wrap="off" style="width: 760px; height: 290px" id="_logon_JAVASCRIPT-${ID}" name="logon_JAVASCRIPT-${ID}">$HTML_HASH_CONFIG{'logon'}{'javascript'}</textarea></td></tr>
			<tr><td>
				<table class="grid"><tr>
					<td class="area-button-left"><div id="startupjs_JAVASCRIPT-EXEC-${ID}" class="div-button w-270">Execute this JavaScript now</div></td>
				</tr></table>
			</td></tr>
		</table></form>
	</div>
	<div id="wc-settings-DIV-ADDITIONAL-${ID}" style="display: none">
		<form id="wc-settings-form-ADDITIONAL-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr>
				<td class="area-top s-info">Additional configuration options <span class="s-note s-info" style="cursor: help" title="JavaScript Object Notation">(at JSON format)</span>:
				</td>
			</tr>
			<tr><td class="area-main"><textarea wrap="off" style="width: 760px; height: 290px" id="_info_additional-${ID}" name="info_additional-${ID}">$HTML_HASH{'DATA_ADDITIONAL'}</textarea></td></tr>
			<tr><td>
				<table class="grid"><tr>
					<td class="area-button-left"><div id="wc-settings-button-additional-CHECK-${ID}" class="div-button w-270">Check validity of this JSON now</div></td>
				</tr></table>
			</td></tr>
		</table></form>
	</div>
	<div id="wc-settings-DIV-OTHER-${ID}" style="display: none">
		<form id="wc-settings-form-OTHER-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">Web Console uploading settings.</td></tr>
			<tr>
				<td class="area-left-short"><span>Uploading limit (in MB):</span></td>
				<td class="area-right-long"><input class="in-text w-100" type="text" id="_other_uploading_limit-${ID}" name="other_uploading_limit-${ID}" value="$HTML_HASH_CONFIG{'uploading'}{'limit'}" /></td>
			</tr>
			<tr><td class="area-main s-group-name" style="padding-top: 9px" colspan="2"><span>Short manual:</span></td></tr>
			<tr>
				<td class="area-tabbed s-message" colspan="2">
					At the field <span class="s-name">"Uploading limit"</span> you can set maximum size (in MB) for uploading file(s).<br />
					Uploading will not start if uploading size is greater than the specified maximum size.
				</td>
			</tr>
			$HTML_CGI_PM_MESSAGE
		</table></form>
	</div>
HTML_EOF


			my $result_BOTTOM = '<table class="grid" id="wc-settings-BUTTONS-'.$ID.'" style="width: 765px">';
			$result_BOTTOM .= '<tr><td class="s-comment">'.$HTML_HASH{'MESSAGE'}.'</td></tr>';
			$result_BOTTOM .= '<tr><td><table class="grid"><tr>';
			$result_BOTTOM .= <<HTML_EOF;
				<td class="area-button-left"><div id="wc-settings-button-submit-${ID}" class="div-button w-120">Save</div></td>
				<td class="area-button-right"><div id="wc-settings-button-close-${ID}" class="div-button w-120">Close</div></td>
				<td class="area-button-right" colspan="3"><div id="wc-settings-button-RMBELOW-${ID}" class="div-button w-270">Remove all messages below this box</div></td>
HTML_EOF
			$result_BOTTOM .= '</tr></table></td></tr></table>';

			foreach ($result_DIVS, $result_BOTTOM) {
				$_ =~ s/([\\'])/\\$1/g;
				$_ =~ s/\n/\\n/g;
			}
			my $result_HTML = <<HTML_EOF;
<div id="wc-settings-CONTAINER-${ID}"></div>
<script type="text/JavaScript"><!--
	WC.UI.tab_set('wc-settings-CONTAINER-${ID}', '$HTML_HASH{'TITLE'}', '${result_DIVS}', {
		'ID': 'wc-settings-tab-${ID}',
		'MENU': {
			'Main settings': { 'id': 'wc-settings-DIV-MAIN-${ID}', 'active': 1 },
			'Style': { 'id': 'wc-settings-DIV-STYLE-${ID}' },
			'Encodings': { 'id': 'wc-settings-DIV-ENCODINGS-${ID}' },
			'Uploading': { 'id': 'wc-settings-DIV-OTHER-${ID}' },
			'Global startup JavaScript': { 'id': 'wc-settings-DIV-STARTUPJS-${ID}' },
			'Additional options': { 'id': 'wc-settings-DIV-ADDITIONAL-${ID}' }
		},
		'MENU_DIV_SIZE_SAME': 1,
		'BOTTOM': '${result_BOTTOM}'
	});
	NL.UI.div_button_register('div-button', 'wc-settings-button-close-$ID', function () { WC.Console.HTML.OUTPUT_remove_result('wc-settings-tab-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-settings-button-RMBELOW-$ID', function () { WC.Console.HTML.OUTPUT_remove_below('wc-settings-tab-${ID}'); });
	NL.UI.div_button_register('div-button', 'startupjs_JAVASCRIPT-EXEC-$ID', function () {
		var obj_JS = xGetElementById('_logon_JAVASCRIPT-${ID}');
		if (obj_JS && obj_JS.value && !obj_JS.value.match(/^[\\s\\t\\r\\n]{0,}\$/)) {
			try { eval (obj_JS.value); }
			catch (e) {
				alert("JavaScript code execution error:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
			}
		}
		else alert("JavaScript code is empty, please enter it or leave blank");
	});
	NL.UI.div_button_register('div-button-270', 'wc-settings-button-additional-CHECK-${ID}', function () {
		var obj = xGetElementById('_info_additional-${ID}');
		if (obj && obj.value && !obj.value.match(/^[\\s\\t\\r\\n]{0,}\$/)) {
			var is_OK = 1;
			try { eval ('('+obj.value+')'); }
			catch (e) {
				is_OK = 0;
				alert("JSON is incorrect:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
			}
			if (is_OK) alert("JSON is valid");
		}
		else alert("JSON code is empty, please enter it or leave blank");
	});
	NL.UI.div_button_register('div-button', 'wc-settings-button-submit-${ID}', function () {
		var hash_DATA = NL.Form.check_fields({
			// Main settings
			'_main_dir_work-${ID}': { 'name_at_hash': 'dir_work', 'name': 'Directory/Work', 'needed': 0 },
			'_main_dir_temp-${ID}': { 'name_at_hash': 'dir_temp', 'name': 'Directory/Temp', 'needed': 0 },
			// Main settings :: flags
			'_main_flag_logon_show_welcome-$ID': { 'type': 'checkbox', 'name_at_hash': 'logon_show_welcome', 'name': 'Flag/Show welcome message on logon', 'needed': 0 },
			'_main_flag_logon_show_warnings-$ID': { 'type': 'checkbox', 'name_at_hash': 'logon_show_warnings', 'name': 'Flag/Show warnings', 'needed': 0 },
			// Encodings
			'_encoding_server_console-${ID}': { 'name_at_hash': 'encoding_server_console', 'name': 'Encoding/Server console', 'needed': 0 },
			'_encoding_server_system-${ID}': { 'name_at_hash': 'encoding_server_system', 'name': 'Encoding/Server system', 'needed': 0 },
			'_encoding_editor_text-${ID}': { 'name_at_hash': 'encoding_editor_text', 'name': 'Encoding/Text editor', 'needed': 0 },
			'_encoding_file_download-${ID}': { 'name_at_hash': 'encoding_file_download', 'name': 'Encoding/Downloading (file name)', 'needed': 0 },
			// Style
			'_style_console_font_family-${ID}': { 'name_at_hash': 'style_console_font_family', 'name': 'Console font styles/Family', 'needed': 0 },
			'_style_console_font_size-${ID}': { 'name_at_hash': 'style_console_font_size', 'name': 'Console font styles/Size', 'needed': 0 },
			'_style_console_font_color-${ID}': { 'name_at_hash': 'style_console_font_color', 'name': 'Console font styles/Color', 'needed': 0 },
			// Other
			'_other_uploading_limit-${ID}': { 'name_at_hash': 'uploading_limit', 'name': 'Uploading limit', 'needed': 0 },
			// Global startup JavaScript
			'_logon_JAVASCRIPT-${ID}': { 'name_at_hash': 'logon_javascript', 'name': 'Web Console startup JavaScript', 'needed': 0 },
			'_info_additional-${ID}': { 'name_at_hash': 'info_additional', 'name': 'Additional options', 'needed': 0,
				'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('wc-settings-tab-${ID}', 'Additional options'); },
				'func_ENCODE': function(in_value) {
					var is_OK = 1;
					if (in_value && !in_value.match(/^[ \\t\\r\\n]{0,}\$/)) {
						try { eval ('('+in_value+')'); }
						catch (e) {
							is_OK = 0;
							alert("JSON at field \\"Additional options\\" is incorrect, please fix it:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
						}
						if (is_OK) return [1, in_value];
						else return [-1, ''];
					}
					else return [1, ''];
				}
			}
		}, 1);
		if (hash_DATA) {
			// OK entered DATA is valid, executing command
			//NL.Debug.dump_alert(hash_DATA);
			WC.Console.Exec.CMD_INTERNAL("SAVING SETTINGS", '#settings _save_form', hash_DATA);
		}
	});


//--></script>
HTML_EOF
	return $result_HTML;
	},
	'__func__' => sub {
		my ($in_CMD) = @_;
		if (defined $in_CMD && $in_CMD =~ /^_save_form[ \t\n\r]+/i) { return $WC::Internal::DATA::ALL->{'#settings'}->{'_save_form'}->($'); }
		else {
			return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$WC::Internal::DATA::ALL->{'#settings'}->{'_settings_FORM'}->();
		}
	},
	'__func_auto__' => sub {
		my $result = \%{ $WC::Internal::DATA::AC_RESULT };
		$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#settings'}->{'__func__'}->();
		return $result;
	}
};

1; #EOF
