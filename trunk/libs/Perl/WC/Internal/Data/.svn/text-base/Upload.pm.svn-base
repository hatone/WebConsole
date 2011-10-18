#!/usr/bin/perl
# WC::Internal::Data::Upload - Web Console 'Internal' UPLOAD DATA module
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::Internal::Data::Upload;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Internal::DATA::ALL->{'#file'}->{'upload'} = {
	'__doc__' => 'Upload file(s)',
	'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'open file(s) uploading form.',
	'__func__' => sub {
		my ($in_CMD) = @_;
		$in_CMD = '' if (!defined $in_CMD);
		my $result = '';

		my $check = &WC::Internal::Data::Upload::upload_CHECK();
		if ($check->{'ID'}) {
			my $init_UPLOAD = &NL::AJAX::Upload::init();
			if ($init_UPLOAD->{'ID'}) {
				$result = &WC::Internal::Data::Upload::upload_FORM();
			}
			else {
				$result = &WC::Internal::Data::Upload::upload_NO_CGI_PM($init_UPLOAD->{'ERROR_MSG'});
			}
		}
		else {
			$result = $check->{'MESSAGE'};
		}
		return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
	},
	'__func_auto__' => sub {
		my $result = \%{ $WC::Internal::DATA::AC_RESULT };
		$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#file'}->{'upload'}->{'__func__'}->();
		return $result;
	}
};
$WC::Internal::DATA::ALL->{'#file'}->{'send'} = '$$#file|upload$$';

$WC::Internal::DATA::ALL->{'#file'}->{'_upload_action'} = {
	'__doc__' => 'Internal method for uploading ACTIONS',
	'__info__' => 'Manual call is not recommended.',
	'__func__' => sub {
		my ($in_CMD) = @_;
		$in_CMD = '' if (!defined $in_CMD);

		# Parsing INPUT string into PARAMETERS
		my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD);
		# Checking PARAMETERS
		my $result = '';
		if (defined $hash_PARAMS->{'ACTION'} && $hash_PARAMS->{'ACTION'} ne '' && defined $hash_PARAMS->{'js_ID'} && $hash_PARAMS->{'js_ID'} ne '') {
			# === START OF ACTIONS

			# 'CHECK_PATH' action
			if ($hash_PARAMS->{'ACTION'} eq 'check_path') {
				if (defined $hash_PARAMS->{'dir'} && defined $hash_PARAMS->{'dir'} ne '') {
					my $message = '';
					my $is_OK = 0;
					my $dir = &WC::Dir::check_in($hash_PARAMS->{'dir'});
					if ($dir eq '') { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CHECKING RESULT", '  - Incorrect input directory (incorrect parameter)') ); }
					elsif (!-d $dir) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CHECKING RESULT", '&nbsp;&nbsp;-&nbsp;No directory '.( &WC::HTML::get_short_value($dir) ).' found', { 'ENCODE_TO_HTML' => 0 }) ); }
					elsif (!&WC::Dir::change_dir($dir)) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CHECKING RESULT", '&nbsp;&nbsp;-&nbsp;Unable change directory to '.( &WC::HTML::get_short_value($dir) ).( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }) ); }
					else {
						my $JS_addon_PATH = '';
						if (defined $hash_PARAMS->{'synchronize_global_path'} && $hash_PARAMS->{'synchronize_global_path'}) {
							# Getting current directory
							&WC::Dir::update_current_dir();
							my $dir_current = &WC::Dir::get_current_dir();
							$JS_addon_PATH = 'WC.Console.State.change_dir(\''.&NL::String::str_JS_value($dir_current).'\');';
						}
						$is_OK = 1;
						$result = ''.
						'<script type="text/JavaScript"><!--'."\n".
						$JS_addon_PATH.
						'	WC.UI.Upload.update_dir_list([], { \'id\': \''.$hash_PARAMS->{'js_ID'}.'\' });'.
						'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
						'	WC.Console.HTML.add_time_message(\'wc-upload-STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[DIRECTORY IS VALID]\', { \'TIME\': 5 });'."\n".
						'//--></script>';
					}
					# If it's not OK
					if (!$is_OK) {
						$result = ''.
						'<script type="text/JavaScript"><!--'."\n".
						'	WC.UI.Upload.update_dir_list([], { \'id\': \''.$hash_PARAMS->{'js_ID'}.'\' });'.
						'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
						'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHECKING DIRECTORY</span>\', \''.$message.'\');'."\n".
						'//--></script>';
					}
				}
				else {
					my $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHECKED", '  - Incorrect call, directory is not specified') );
					$result = ''.
					'<script type="text/JavaScript"><!--'."\n".
					'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
					'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHECKING DIRECTORY</span>\', \''.$message.'\');'."\n".
					'//--></script>';
				}
			}
			# 'LOAD SUBDIRECTORYS' action
			elsif ($hash_PARAMS->{'ACTION'} eq 'load_sudirs') {
				if (defined $hash_PARAMS->{'dir'} && defined $hash_PARAMS->{'dir'} ne '') {
					my $message = '';
					my $is_OK = 0;
					my $dir = &WC::Dir::check_in($hash_PARAMS->{'dir'});
					if ($dir eq '') { $message = &NL::String::str_JS_value( &WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT", '  - Incorrect input directory (incorrect parameter)') ); }
					elsif (!-d $dir) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT", '&nbsp;&nbsp;-&nbsp;No directory '.( &WC::HTML::get_short_value($dir) ).' found', { 'ENCODE_TO_HTML' => 0 }) ); }
					elsif (!&WC::Dir::change_dir($dir)) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT", '&nbsp;&nbsp;-&nbsp;Unable change directory to '.( &WC::HTML::get_short_value($dir) ).( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }) ); }
					else {
						my $is_sub_OK = 1;
						my $sub_dir = (defined $hash_PARAMS->{'sub_dir'}) ? &WC::Dir::check_in($hash_PARAMS->{'sub_dir'}) : '';
						if ($sub_dir ne '') {
							$is_sub_OK = 0;
							if (!&WC::Dir::change_dir($sub_dir)) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT", '&nbsp;&nbsp;-&nbsp;Unable change directory to '.( &WC::HTML::get_short_value($sub_dir) ).( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }) ); }
							else {
								$is_sub_OK = 2;
							}
						}
						# Getting current directory
						&WC::Dir::update_current_dir();
						my $dir = &WC::Dir::get_current_dir();

						if ($is_sub_OK != 0) {
							# Getting directorys splitter
							my $dir_SPLITTER = &WC::Dir::get_dir_splitter();
							# Getting listing
							if (opendir(DIR, $dir)) {
								my @arr_listing = grep(!/^$/, map { (-d $dir.$dir_SPLITTER.$_) ? $_ : '' } grep(!/^\.{1,2}$/, readdir (DIR)));
								closedir (DIR);
								@arr_listing = sort @arr_listing;
								my $total = scalar @arr_listing;
								$is_OK = 1;

								my $JS_addon_PATH = '';
								if (defined $hash_PARAMS->{'synchronize_global_path'} && $hash_PARAMS->{'synchronize_global_path'}) {
									$JS_addon_PATH = 'WC.Console.State.change_dir(\''.&NL::String::str_JS_value($dir).'\');';
								}
								my $JS_PATH_UPDATE = '';
								if ($is_sub_OK == 2) {
									my $js_dir = &NL::String::str_JS_value($dir);
									$JS_PATH_UPDATE	= ''.
									'	var obj_PATH = xGetElementById(\'wc-upload-dir-'.$hash_PARAMS->{'js_ID'}.'\');'.
									'	if (obj_PATH) obj_PATH.value = \''.$js_dir.'\';'.
									'	WC.Console.HTML.add_time_message(\'wc-upload-STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[DIRECTORY IS EMPTY]\', { \'TIME\': 5 });'."\n".
									'';
								}
								if ($total <= 0 ) {
									$result = ''.
									'<script type="text/JavaScript"><!--'."\n".
									$JS_PATH_UPDATE.
									$JS_addon_PATH.
									'	WC.UI.Upload.update_dir_list([], { \'id\': \''.$hash_PARAMS->{'js_ID'}.'\' });'.
									'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
									'	WC.Console.HTML.add_time_message(\'wc-upload-STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[DIRECTORY IS EMPTY]\', { \'TIME\': 5 });'."\n".
									'//--></script>';
								}
								else {
									my $js_ARRAY = '';
									foreach (@arr_listing) {
										if ($_ ne '') {
											$js_ARRAY .= "," if ($js_ARRAY ne '');
											$js_ARRAY .= "'".&NL::String::str_JS_value($_)."'";
										}
									}
									$result = ''.
									'<script type="text/JavaScript"><!--'."\n".
									$JS_PATH_UPDATE.
									$JS_addon_PATH.
									'	WC.UI.Upload.update_dir_list(['.$js_ARRAY.'], { \'id\': \''.$hash_PARAMS->{'js_ID'}.'\' });'.
									'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
									'	WC.Console.HTML.add_time_message(\'wc-upload-STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[SUBDIRECTORYS LOADED]\', { \'TIME\': 5 });'."\n".
									'//--></script>';
								}
							}
							else {
								$message = &NL::String::str_JS_value( &WC::HTML::get_message("SUBDIRECTORYS LOADING RESULT", 'Unable to get directory '.&WC::HTML::get_short_value($dir).' listing'.( ($! ne '') ? ': '.$! :  '' ), { 'ENCODE_TO_HTML' => 0 }) );
							}
						}
					}
					# If it's not OK
					if (!$is_OK) {
						$result = ''.
						'<script type="text/JavaScript"><!--'."\n".
						'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
						'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> LOADING SUBDIRECTORYS</span>\', \''.$message.'\');'."\n".
						'//--></script>';
					}
				}
				else {
					my $message = &NL::String::str_JS_value( &WC::HTML::get_message("SUBDIRECTORYS CAN'T BE LOADED", '  - Incorrect call, directory is not specified') );
					$result = ''.
					'<script type="text/JavaScript"><!--'."\n".
					'	WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
					'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> LOADING SUBDIRECTORYS</span>\', \''.$message.'\');'."\n".
					'//--></script>';
				}
			}
			else {
				my $error = &NL::String::str_JS_value( &WC::HTML::get_message("UPLOADER ACTION CAN'T BE EXECUTED", '  - Incorrect call, unable to find needed objects') );
				$result = ''.
				'<script type="text/JavaScript"><!--'."\n".
				( (defined $hash_PARAMS->{'js_ID'} && $hash_PARAMS->{'js_ID'} ne '') ? ' WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');' : '').
				'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> _UNKNOWN_ UPLOADER ACTION</span>\', \''.$error.'\');'."\n".
				'//--></script>';
			}
			# === END OF ACTIONS
		}
		else {
			my $error = &NL::String::str_JS_value( &WC::HTML::get_message("UPLOADER ACTION CAN'T BE EXECUTED", '  - Incorrect call, unable to find needed objects') );
			$result = ''.
			'<script type="text/JavaScript"><!--'."\n".
			( (defined $hash_PARAMS->{'js_ID'} && $hash_PARAMS->{'js_ID'} ne '') ? ' WC.Console.status_change(\'wc-upload-STATUS-'.$hash_PARAMS->{'js_ID'}.'\');' : '').
			'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> _UNKNOWN_ UPLOADER ACTION</span>\', \''.$error.'\');'."\n".
			'//--></script>';
		}
		# Returning result
		return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
	}
};

# METHODS FOR INTERNAL COMMANDS

# file :: upload :: CHECK
sub upload_CHECK {
	my $result = { 'ID' => 1, 'MESSAGE' => '' };

	#result->{'ID'} = 0;
	#$result->{'MESSAGE'} = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '  - Incorrect TARGET DIRECTORY specified');
	return $result;
}
# file :: upload :: HTML
sub upload_FORM {
	# Getting current directory
	&WC::Dir::update_current_dir();
	my $dir_current_HTML = &NL::String::str_JS_value(&NL::String::str_HTML_value( &WC::Dir::get_current_dir() ));

	my $CGI_PM_WARNING = '';
	my $UPLOAD_STATUS_METHOD = $NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK ? 'STATUS_FILE' : 'POST_FILE';
	if (!$NL::AJAX::Upload::CGI_PM_SUPPORTS_UPLOAD_HOOK) {
		$CGI_PM_WARNING = '<tr><td class="wc-upload-td-buttons s-warning" style="padding-top: 6px" colspan="2">WARNING: Your \'CGI.pm\' Perl module '.
				  '(your version \''.$CGI::VERSION.'\') is too old, not fully featured uploading will be used. Recommended \'CGI.pm\' version is >= \'3.03\', please <a class="link-warning" href="http://search.cpan.org/~lds/CGI.pm/CGI.pm" target="_blank">update</a> your \'CGI.pm\' Perl module.</td></tr>';
		$CGI_PM_WARNING =~ s/'/\\'/g;
	}
	my $ID = &WC::Internal::get_unique_id();
	my $HTML_message_MAIN = <<HTML_EOF;
	<div id="wc-upload-layout-div-MAIN-${ID}">
		<form id="wc-upload-FORM-${ID}" name="_wc-upload-FORM-${ID}" method="post" enctype="multipart/form-data" onsubmit="return false">
	 	<input id="wc-upload-FORM-ID-${ID}" type="hidden" name="_wc-upload-FORM-ID-${ID}" value="$ID" />
	 	<input id="wc-upload-FORM-DIR-${ID}" type="hidden" name="_wc-upload-FORM-DIR-${ID}" value="$dir_current_HTML" />
		<table id="wc-upload-layout-div-MAIN-TAB-${ID}" class="grid">
			<tr><td colspan="2">
				<table class="grid" style="width: 100%"><tr>
					<td class="wc-upload-info-left"><span style="color: #1196cb; font-weight: bold;">Select file(s) for uploading:</span></td>
					<td class="wc-upload-info-right"><span class="span-message" id="wc-upload-STATUS-MESSAGE-${ID}">&nbsp;</span>&nbsp;&nbsp;Status: <span id="wc-upload-STATUS-${ID}">Idle</span></td>
				</tr></table>
			</td></tr>
			<tr>
				<td id="wc-upload-files-area-${ID}" class="wc-upload-files" colspan="2"><input type="file" class="'+wc_fu_class_input_file+'" id="${ID}-wc-upload-file-1" name="_${ID}-wc-upload-file-1"'+wc_fu_class_INPUT_FILE_fix+' /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Current directory:</span></td>
				<td class="area-right-long"><input class="wc-upload-input-dir" type="text" id="wc-upload-dir-${ID}" name="_wc-upload-dir-${ID}" value="$dir_current_HTML" /></td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Upload to:</span></td>
				<td class="area-right-long">
					<table class="grid"><tr>
						<td class="wc-upload-area-select-left">
							<select id="wc-upload-dir-list-${ID}" name="_wc-upload-dir-list-${ID}" class="wc-upload-input-select"'+wc_fu_class_UPLOAD_DIR_LIST_FIX+'>
								<option value="" selected>&nbsp;***CURRENT DIRECTORY***&nbsp;</option>
							</select>
						</td>
						<td class="wc-upload-area-select-left"><div id="wc-upload-button-dir-reload-${ID}" class="wc-upload-div-button-dir-reload">load subdirectorys</div></td>
						<td class="wc-upload-area-select-right"><div id="wc-upload-area-dir-reload-status-${ID}" class="wc-upload-dir-reload-status">&nbsp;</div></td>
					</tr></table>
				</td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Create subdirectory:</span></td>
				<td class="area-right-long">
					<table class="grid"><tr>
						<td class="wc-upload-area-select-left"><input class="wc-upload-input" id="wc-upload-form-dir-create-${ID}" name="_wc-upload-form-dir-create-${ID}" /></td>
						<td class="wc-upload-area-select-right"><span class="wc-upload-small-info">(file(s) will be created inside that directory)</span></td>
					</tr></table>
				</td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Set file(s) permissions:</span></td>
				<td class="area-right-long">
					<table class="grid"><tr>
						<td class="wc-upload-area-select-left"><input id="wc-upload-form-permissions-${ID}" class="wc-upload-input-permissions" name="_wc-upload-form-permissions-${ID}" /></td>
						<td class="wc-upload-area-select-right"><span class="wc-upload-small-info">(example - &quot;777&quot;, if permissions entered - it will be applied to all uploaded files)</span></td>
					</tr></table>
				</td>
			</tr>
			<tr>
				<td class="area-left-short"><span class="wc-upload-name">Use ASCII mode:</span></td>
				<td class="area-right-long">
					<table class="grid"><tr>
						<td class="wc-upload-area-select-left"><input id="wc-upload-form-ASCII-${ID}" class="wc-upload-checkbox-ASCII" type="checkbox" name="_wc-upload-form-ASCII-${ID}" value="0" /></td>
						<td class="wc-upload-area-select-right"><span class="wc-upload-small-info">useful for auto text files convertion between WINDOWS (&quot;\\\\r\\\\n&quot;) and UNIX (&quot;\\\\n&quot;)</span></td>
					</tr></table>
				</td>
			</tr>
			<tr><td class="wc-upload-td-buttons" colspan="2">
				<table class="grid"><tr>
					<td class="area-button-left"><div id="wc-upload-button-upload-${ID}" class="div-button w-100">upload</div></td>
					<td class="area-button-right"><div id="wc-upload-button-close-${ID}" class="div-button w-100">close</div></td>
					<td class="area-button-right"><div id="wc-upload-button-slot-plus-${ID}" class="div-button w-120">+1 upload slot</div></td>
					<td class="area-button-right"><div id="wc-upload-button-slot-minus-${ID}" class="div-button w-120 wc-upload-div-button-unactive">-1 upload slot</div></td>
				</tr></table>
				<table class="grid"><tr>
					<td class="area-button-left" style="padding-top: 4px"><div id="wc-upload-button-RMBELOW-${ID}" class="div-button w-270">Remove all messages below this box</div></td>
					<td class="area-button-right" style="padding-top: 4px">
						<input class="in-checkbox" style="margin-left: 3px" type="checkbox" id="wc-upload-PATH-UPDATE-${ID}" name="_wc-upload-PATH-UPDATE-${ID}" value="1" onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /> <label class="s-message" title="If checked - global path will be synchronized with Uploader path" style="cursor: help" for="wc-upload-PATH-UPDATE-${ID}">Synchronize global path</label>
					</td>
				</tr></table>
			</td></tr>
			$CGI_PM_WARNING
		</table>
	 </form></div>
	 <div id="wc-upload-layout-div-PROGRESS-${ID}" style="display: none"></div>
	 <div id="wc-upload-layout-div-FINISH-${ID}" style="display: none"></div>
HTML_EOF
	# Converting MAIN HTML to JS value (don't escaping "'" - that is will be used to set width and height from JS)
	$HTML_message_MAIN =~ s/\n/\\n/g;
	$HTML_message_MAIN =~ s/\r/\\r/g;

	# Getting login/password
	my $user_login_URL =  &NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_login'});
	my $user_password_URL =  &NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_password'});

	my $result = <<HTML_EOF;
<div id="wc-file-upload-CONTAINER-${ID}"></div>
<script type="text/JavaScript"><!--
	// Getting width and height
	// var t_h = xClientHeight(); t_h -= 190; if (t_h < 100) t_h = 100;
	var t_w = xClientWidth(); t_w -= 80; if (t_w < 100) t_w = 100;
	var ff_style = (NL.Browser.Detect.isFF) ? ' style="padding-right: 12px"' : '';
	var wc_fu_class_input_file = !NL.Browser.Detect.isOPERA ? 'wc-upload-input-file' : 'wc-upload-input-file-opera';
	if (NL.Browser.Detect.isFF3) wc_fu_class_input_file = 'wc-upload-input-file-ff3';

	var wc_fu_ff_INPUT_FILE_size = (NL.Browser.Detect.isFF3) ? 108 : 107;
	var wc_fu_class_INPUT_FILE_fix = (NL.Browser.Detect.isFF) ? ' size="'+wc_fu_ff_INPUT_FILE_size+'"' : '';
	var wc_fu_class_UPLOAD_DIR_LIST_FIX = '';
	// Don't setting fixed 'width' because width will be automatically changed
	// if (NL.Browser.Detect.isFF) wc_fu_class_UPLOAD_DIR_LIST_FIX = ' style="width: 228px"';
	// else if (NL.Browser.Detect.isOPERA) wc_fu_class_UPLOAD_DIR_LIST_FIX = ' style="width: 226px"';

	WC.UI.tab_set('wc-file-upload-CONTAINER-${ID}', 'Upload File(s)', '${HTML_message_MAIN}', { 'ID': '_NO_ID_wc-file-upload-tab-${ID}', 'BOTTOM': '' });
	NL.UI.div_button_register('div-button', 'wc-upload-button-RMBELOW-${ID}', function () { WC.Console.HTML.OUTPUT_remove_below('wc-upload-layout-div-MAIN-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-upload-button-close-${ID}', function () { WC.Console.HTML.OUTPUT_remove_result('wc-upload-layout-div-MAIN-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-upload-button-slot-plus-${ID}', function () { WC.UI.Upload.slots('add', { 'id': '${ID}', 'input_class': wc_fu_class_input_file, 'ff_size': wc_fu_ff_INPUT_FILE_size }); });
	NL.UI.div_button_register('div-button', 'wc-upload-button-slot-minus-${ID}', function () { WC.UI.Upload.slots('remove', { 'id': '${ID}', 'input_class': wc_fu_class_input_file, 'ff_size': wc_fu_ff_INPUT_FILE_size }); });

	xAddEventListener('wc-upload-dir-${ID}', 'keypress',  function (event) {
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			var obj_PATH = xGetElementById('wc-upload-dir-${ID}');
			var obj_SYNC = xGetElementById('wc-upload-PATH-UPDATE-${ID}');
			if (obj_PATH && obj_SYNC) {
				if (!obj_PATH.value) alert("There is not CURRENT DIRECTORY entered,\\nPlease enter it.");
				else {
					WC.Console.HTML.set_INNER('wc-upload-STATUS-MESSAGE-${ID}', '');
					var id_timer = WC.Console.status_change('wc-upload-STATUS-${ID}', 'Checking path', 1);
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("CHECKING PATH", '#file _upload_action',
						{ 'ACTION': 'check_path', 'dir': obj_PATH.value, 'js_ID': '${ID}', 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
						[],
						{ 'type': 'hidden', 'id_TIMER': id_timer }
					);
				}
			}
			else alert("Unable to find Uploader objects (internal error)");
			return false;
		}
		return true;
	});
	NL.UI.div_button_register('wc-upload-div-button-dir-reload', 'wc-upload-button-dir-reload-${ID}', function () {
		var obj_PATH = xGetElementById('wc-upload-dir-${ID}');
		var obj_LIST = xGetElementById('wc-upload-dir-list-${ID}');
		var obj_SYNC = xGetElementById('wc-upload-PATH-UPDATE-${ID}');
		if (obj_PATH && obj_LIST && obj_SYNC) {
			if (!obj_PATH.value) alert("There is not CURRENT DIRECTORY entered,\\nPlease enter it.");
			else {
				WC.Console.HTML.set_INNER('wc-upload-STATUS-MESSAGE-${ID}', '');
				var id_timer = WC.Console.status_change('wc-upload-STATUS-${ID}', 'Loading subdirectorys', 1);
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("LOADING SUBDIRECTORYS", '#file _upload_action',
					{ 'ACTION': 'load_sudirs', 'dir': obj_PATH.value, 'sub_dir': obj_LIST.value, 'js_ID': '${ID}', 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
					[],
					{ 'type': 'hidden', 'id_TIMER': id_timer }
				);
			}
		}
		else alert("Unable to find Uploader objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-upload-button-upload-${ID}', function () {
		var obj_PATH = xGetElementById('wc-upload-dir-${ID}');
		var obj_LIST = xGetElementById('wc-upload-dir-list-${ID}');
		var obj_CREATE = xGetElementById('wc-upload-form-dir-create-${ID}');
		var obj_PERMISSIONS = xGetElementById('wc-upload-form-permissions-${ID}');
		var obj_ASCII = xGetElementById('wc-upload-form-ASCII-${ID}');
		if (obj_PATH && obj_LIST && obj_CREATE && obj_PERMISSIONS && obj_ASCII) {
			if (!obj_PATH.value) alert("There is not CURRENT DIRECTORY entered,\\nPlease enter it.");
			else {
				// Generating files list
				var obj = xGetElementById('wc-upload-files-area-${ID}');
				var arr_Files = [];
				if (obj) {
					var sub_nodes = obj.childNodes;
					if (sub_nodes) {
						if (NL.Browser.Detect.isSAFARI) {
							var chld = [];
							for (var i = 0; i < sub_nodes.length; i++) chld[i] = sub_nodes[i];
							sub_nodes = chld;
						}
						var id_str = '${ID}';
						var id_len = id_str.length;
						NL.foreach(sub_nodes, function (i, val) {
							var is_OK = 1;
							if (NL.Browser.Detect.isOPERA) {
								if (i.substring(0, id_str.length) != id_str) is_OK = 0;
							}
							if (is_OK && val.type == 'file' && val.value != '') { arr_Files.push(val); }
						});
					}
				}
				if (arr_Files.length <= 0) { alert('There are no files selected,\\nplease select files to uploading.'); }
				else {
					var FILES_TOTAL = arr_Files.length;
					WC.Console.HTML.set_INNER('wc-upload-STATUS-MESSAGE-${ID}', '');
					var id_timer = WC.Console.status_change('wc-upload-STATUS-${ID}', 'Starting uploading', 1);
					NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': id_timer});
					// Uploading files
					var obj_UPLOAD_STARTED = WC.UI.Upload.start('${ ${ $WC::c }{'APP_SETTINGS'} }{'file_name'}', {
						'user_login': '$user_login_URL',
						'user_password': '$user_password_URL',
						'dir': obj_PATH.value,
						'dir_sub': obj_LIST.value,
						'dir_create': obj_CREATE.value,
						'file_permissions': obj_PERMISSIONS.value,
						'mode_ASCII': obj_ASCII.checked ? 1 : 0,
						'js_ID': '${ID}',
						'FILES': arr_Files
					});
					NL.Cache.add('${ID}', obj_UPLOAD_STARTED);
					if (obj_UPLOAD_STARTED) {
						var timer_interval = 1000;
						WC.UI.Upload.state_PROGRESS({ 'js_ID': '${ID}', 'UPLOAD_STATUS_METHOD': '$UPLOAD_STATUS_METHOD' });
						NL.Timer.timer_add_exec_and_on(timer_interval, function(in_STASH, in_TIME) {
							if (in_STASH && in_STASH['js_ID']) {
								if (WC.UI.Upload.state_PROGRESS_IS_ACTIVE(in_STASH['js_ID'])) {
									if (WC.UI.Upload.state_PROGRESS_update_TIME({ 'js_ID': in_STASH['js_ID'] }, in_TIME)) {
										var obj_UPLOADING = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-'+in_STASH['js_ID']);
										if (obj_UPLOADING && obj_UPLOADING.value && parseInt(obj_UPLOADING.value)) {
											NL.AJAX.query('${ ${ $WC::c }{'APP_SETTINGS'} }{'file_name'}', {
													'q_action': 'AJAX_UPLOAD_STATUS',
													'user_login': '$user_login_URL',
													'user_password': '$user_password_URL',
													'js_ID': '${ID}',
													'UPLOAD_STATUS_METHOD': '$UPLOAD_STATUS_METHOD'
												}, {},
												function(respJS, respTEXT) {
													if (respJS && respJS['STASH']) {
														if (respJS['STASH']['CODE']) {
															if (respJS['STASH']['CODE'] == 'OK') {
																WC.UI.Upload.state_PROGRESS_update({ 'js_ID': '${ID}' }, respJS['STASH']['STATUS'], { 'UPLOAD_STATUS_METHOD': '$UPLOAD_STATUS_METHOD', 'FILES_TOTAL': FILES_TOTAL });
															}
														}

													}
													var obj_STATUS_REQUESTED = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_REQUESTED-${ID}');
													if(obj_STATUS_REQUESTED) obj_STATUS_REQUESTED.value = 0;
												});
										}
									}
									return 1;
								}
							}
							// Timer for that element will be killed automatically
							return 0;
						}, {'js_ID': '${ID}'}, { 'SLEEP_MS': 3000 });

					}
					else alert("Unable to start uploading");
				}
			}
		}
		else alert("Unable to find Uploader objects (internal error)");
	});
//--></script>
HTML_EOF
	return $result;
}
# file :: upload :: No 'CGI.pm' found
sub upload_NO_CGI_PM {
	my ($in_ERROR) = @_;

	my $text = "&nbsp;&nbsp;No 'CGI.pm' module found, that Perl module is needed for uploading,<br />";
	$text .= '&nbsp;&nbsp;that module can be downloaded from CPAN: <a class="a-brown" href="http://search.cpan.org/~lds/CGI.pm/CGI.pm" target="_blank">http://search.cpan.org/~lds/CGI.pm/CGI.pm</a><br />';
	$text .= '<br />';
	$text .= '<div class="t-red-light">&nbsp;&nbsp;Additional information:</div>';

	my $in_message = $in_ERROR;
	&NL::String::str_trim(\$in_message);
	$in_message =~ s/^/  - /;
	$in_message =~ s/\n/\n    /g;
	&NL::String::str_HTML_full(\$in_message);

	return '<div class="t-lime">FILE(S) CAN\'T BE UPLOADED:</div><div class="t-blue">'.$text.$in_message.'</div>';
}

1; #EOF
