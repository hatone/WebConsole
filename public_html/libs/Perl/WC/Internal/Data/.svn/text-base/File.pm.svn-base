#!/usr/bin/perl
# WC::Internal::DATA::File - Web Console 'Internal' FILE DATA module
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::Internal::Data::File;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Internal::Data::File::MESSAGES = {
	'TYPE_FILE_DIRECTORY_TAB' => 'Please type <file name(s)>/<directory name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}
};

$WC::Internal::DATA::ALL->{'#file'} = {
	'__doc__' => 'File operations (download, upload, edit, ...)',
	'__info__' => 'Common file operatons.',
	### EDIT ###
	'_edit_reload' => {
		'__doc__' => 'Internal method for file reloading (called when form button "Reload file" clicked)',
		'__info__' => 'Manual call is not recommended.',
		'__func__' => sub {
			my ($in_CMD, $in_BACK_STASH) = @_;
			$in_CMD = '' if (!defined $in_CMD);
			$in_BACK_STASH = {} if (!defined $in_BACK_STASH);

			# Parsing INPUT string into PARAMETERS
			my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD);
			# Checking PARAMETERS
			my $check_RESULT = &NL::Parameter::check($hash_PARAMS, {
				'js_id_DATA' => { 'name' => 'ID of TEXTAREA', 'needed' => 1 },
				'dir' => { 'name' => 'Directory path', 'needed' => 1, 'can_be_empty' => 1 },
				'file_name' => { 'name' => 'Filename', 'needed' => 1 },
				'js_ID' => { 'name' => 'Element ID', 'needed' => 1 }
			});

			my $result = '';
			if (!$check_RESULT->{'ID'}) {
				my $error = &NL::String::str_JS_value( &WC::HTML::get_message("FILE CAN'T BE RELOADED", '  - '.$check_RESULT->{'ERROR_MESSAGE'}) );
				my $file = (defined $hash_PARAMS->{'file_name'} && $hash_PARAMS->{'file_name'} ne '') ? &NL::String::str_JS_value( &WC::HTML::get_short_value($hash_PARAMS->{'file_name'}) ) : &NL::String::str_JS_value( &WC::HTML::get_short_value('_UNKNOWN_') );
				$result = ''.
				'<script type="text/JavaScript"><!--'."\n".
				( (defined $hash_PARAMS->{'js_ID'} && $hash_PARAMS->{'js_ID'} ne '') ? ' WC.UI.Filemanager.status_change(\'_wc_file_edit_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');' : '').
				'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> RELOADING FILE '.$file.'</span>\', \''.$error.'\');'."\n".
				'//--></script>';
			}
			else {
				my $is_OK = 0;
				my $message = '';
				my $dir = &WC::Dir::check_in($hash_PARAMS->{'dir'});
				if ($dir ne '' && !&WC::Dir::change_dir($dir)) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("FILE CAN'T BE RELOADED", '  - Incorrect TARGET DIRECTORY specified') ); }
				else {
					my $hash_READ = &edit_READ($hash_PARAMS->{'file_name'});
					if (!$hash_READ->{'ID'}) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("FILE CAN'T BE RELOADED", '&nbsp;&nbsp;-&nbsp;'.$hash_READ->{'ERROR'}, { 'ENCODE_TO_HTML' => 0 }) ); }
					else {
						$is_OK = 1;
						my $ID = &WC::Internal::get_unique_id();
						my $HTML_message_good = "FILE HAS BEEN SUCCESSFULLY RELOADED";
						my $HTML_message_bad = "FILE CAN'T BE RELOADED, TEXTAREA OBJECT IS NOT FOUND";
						# Converting strings to JS values
						foreach ($hash_READ->{'FILE_DATA'}, $HTML_message_good, $HTML_message_bad) { &NL::String::str_JS_value(\$_); }
						$in_BACK_STASH->{'JS_CODE'} = ''.
						'	var obj = xGetElementById(\''.$hash_PARAMS->{'js_id_DATA'}.'\'); '.
						'	var is_obj_found = 0; '.
						'	if (obj) { obj.value = "'.$hash_READ->{'FILE_DATA'}.'"; is_obj_found = 1; } '.
						'	var obj_RESULT = xGetElementById(\'wc-file-edit-RELOAD-RESULT-'.$ID.'\'); '.
						'	if (is_obj_found) WC.Console.HTML.add_time_message(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'['.$HTML_message_good.']\', { \'TIME\': 5 }); '.
						'	else WC.Console.HTML.add_time_message(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'['.$HTML_message_bad.']\', { \'TIME\': 5 }); ';
					}
				}
				my $file = &NL::String::str_JS_value( &WC::HTML::get_short_value($hash_PARAMS->{'file_name'}) );
				$result = '<script type="text/JavaScript"><!--'."\n".'WC.UI.Filemanager.status_change(\'_wc_file_edit_STATUS-'.$hash_PARAMS->{'js_ID'}.'\'); ';
				if ($is_OK) { $result .= $message; }
				else {
					$result .= 'var obj = xGetElementById(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\'); if (obj) obj.innerHTML = \'\'; ';
					$result .= 'WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> RELOADING FILE '.$file.'</span>\', \''.$message.'\');';
				}
				$result .= "\n".'//--></script>';
			}
			return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
		}
	},
	'edit' => {
		'__doc__' => 'Edit/View file',
		'__info__' => 'Please type: <file name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n".
				"  Examples:\n".
				"    - #file edit file.txt\n".
				"    - #file edit file1.txt file2.txt",
		'__func__' => sub {
			my ($in_CMD, $in_BACK_STASH, $in_SETTINGS) = @_;
			$in_CMD = '' if (!defined $in_CMD);
			$in_BACK_STASH = {} if (!defined $in_BACK_STASH);
			$in_SETTINGS = {} if (!defined $in_SETTINGS);
			$in_SETTINGS->{'IS_OPEN'} = 0 if (!defined $in_SETTINGS->{'IS_OPEN'});

			my $result = '';
			my $hash_PARAMS;
			my @arr_files;
			if ($in_SETTINGS->{'IS_OPEN'}) {
				@arr_files = @{ $in_SETTINGS->{'ARR_FILES'} };
				$hash_PARAMS = { 'ID' => 1, 'DATA' => [] };
			}
			else {
				# Parsing INPUT string into PARAMETERS
				$hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD, { 'RETURN_ID' => 1, 'AS_ARRAY' => 1, 'ESCAPE_OFF' => 0, 'DISALLOW_SPACES' => 1 });
			}

			if (!$hash_PARAMS->{'ID'}) { $result = &WC::HTML::get_message("FILE(S) CAN'T BE EDITED", '  - Incorect input, please specify file(s) correctly'); }
			else {
				my $dir = '';
				my $dir_found = 0;
				foreach my $line (@{ $hash_PARAMS->{'DATA'} }) {
					foreach (keys %{ $line }) {
						if ($_ ne '') {
							# Getting directory parameter
							if (!$dir_found && $_ =~ /^['"]{0,}-dir['"]{0,}$/i && defined $line->{$_}) {
								$dir_found = 1;
								$dir = $line->{$_};
							}
							else {
								my $path = $_;
								if (defined $line->{$_}) { $path .= '='.$line->{$_}; }
								push @arr_files, $path;
							}
						}
					}
				}
				# Changing directory
				my $is_OK = 1;
				if ($dir_found) {
					# Checking value
					$dir = &WC::Dir::check_in($dir);
					if ($dir eq '') {
						$result = &WC::HTML::get_message("FILE(S) CAN'T BE EDITED", '  - Incorrect TARGET DIRECTORY specified');
						$is_OK = 0;
					}
					# Changing directory
					elsif (!&WC::Dir::change_dir($dir)) {
						$result = &WC::HTML::get_message("FILE(S) CAN'T BE EDITED", '&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 });
						$is_OK = 0;
					}
				}
				if ($is_OK) {
					# Starting edit form(s)
					if (scalar @arr_files <= 0) { $result = &WC::HTML::get_message("FILE(S) CAN'T BE EDITED", '  - Incorect input, no file(s) specified'); }
					else {
						my $ID = &WC::Internal::get_unique_id();
						my $MAX_FILES = 5;
						my $num_ok = 0;
						my $num_total = 0;
						$result = '';
						my $result_BAD = '';
						my $result_GOOD_HTML_JS_VALUE = '';
						my $result_GOOD_JS = '';
						my @result_GOOD_ARR;
						my $hash_files_OPENED = {};
						foreach (@arr_files) {
							$num_total++;
							my $path = &WC::Dir::check_in($_);
							# Limit exceed
							if ($num_ok >= $MAX_FILES) {
								&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path);
								$result_BAD .= '<div class="t-blue">&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path).' does not opened: <span class="t-red-dark">maximum opened files at the same time is '.$MAX_FILES.'</span></div>';
							}
							else {
								if (defined $hash_files_OPENED->{ $path }) {
									&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path);
									$result_BAD .= '<div class="t-blue">&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path).' already opened</div>';
								}
								else {
									my $hash_FORM = &edit_FORM($path, { 'DIV_HIDDEN' => ($num_ok > 0) ? 1 : 0, 'ID' => $ID });
									if (!$hash_FORM->{'ID'}) { $result_BAD .= $hash_FORM->{'HTML'}; }
									else {
										$hash_files_OPENED->{ $path } = 1;
										$num_ok++;
										push @result_GOOD_ARR, { 'path' => $path, 'DIV_ID' => $hash_FORM->{'DIV_ID'} };
										# HTML JS VALUE
										$result_GOOD_HTML_JS_VALUE .= $hash_FORM->{'HTML_JS_VALUE'};
										# JS
										$result_GOOD_JS .= "\n" if ($result_GOOD_JS ne '');
										$result_GOOD_JS .= $hash_FORM->{'JS'};
									}
								}
							}
						}
						my $is_JS_needed = 0;
						if ($num_total > 1) {
							$result = "<div class=\"t-lime\">OPENED '$num_ok' OF '$num_total':</div>";
							if ($num_total > $num_ok) { $result .= "<div class=\"t-green\">&nbsp;&nbsp;Not opened:</div>".$result_BAD; }
							if ($num_ok > 0) { $result .= "<div class=\"t-green\">&nbsp;&nbsp;Below you can see file(s) that has been successfully opened:</div>\n"; $is_JS_needed = 1; }
						}
						else {
							if ($num_ok > 0) { $is_JS_needed = 1; }
							else { $result = "<div class=\"t-lime\">FILE CAN'T BE OPENED:</div>".$result_BAD; }
						}
						# If all is OK
						if ($is_JS_needed) {
							my $result_MENU = '';
							foreach (@result_GOOD_ARR) {
								if ($result_MENU eq '') { $result_MENU .= "'".&NL::String::str_HTML_value(&NL::String::get_right($_->{'path'}, 22, 1))."': { 'id': '".$_->{'DIV_ID'}."', 'active': 1 }"; }
								else { $result_MENU .= ", '".&NL::String::str_HTML_value(&NL::String::get_right($_->{'path'}, 22, 1))."': { 'id': '".$_->{'DIV_ID'}."' }"; }
							}
							$result .= <<HTML_EOF;
<div id="wc-file-edit-CONTAINER-${ID}"></div>
<script type="text/JavaScript"><!--
	// Getting width and height
	var t_h = xClientHeight(); t_h -= 210; if (t_h < 100) t_h = 100;
	var t_w = xClientWidth(); t_w -= 90;
	if (NL.Browser.Detect.isIE) { if (t_w < 870) t_w = 870; }
	else { if (t_w < 925) t_w = 925; }

	var font_style_small = '';
	if (t_w < 950) font_style_small = 'style="font-size: 12px" ';
	WC.UI.tab_set('wc-file-edit-CONTAINER-${ID}', 'Edit/View file(s)', '$result_GOOD_HTML_JS_VALUE', {
		'ID': 'wc-file-edit-tab-${ID}',
		'MENU': { $result_MENU },
		'MENU_DIV_SIZE_SAME': 1,
		'BOTTOM': ''
	});
//--></script>
$result_GOOD_JS
HTML_EOF
						}
					}
				}
			}
			return ( (!$in_SETTINGS->{'IS_OPEN'}) ? $WC::Internal::DATA::HEADERS->{'text/html'} : '').$result;
		}
	},

	### CHMOD ###
	'chmod' => {
		'__doc__' => 'CHMOD file(s)/directory(s)',
		'__info__' => 'Please type: <VALUE> <file name(s)>/<directory name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n".
				"  Examples:\n".
				"    - #file chmod 777 file.txt some_directory\n".
				"    - #file chmod 755 file1.pl file2.pl\n".
				"    - #file chmod 660 .htaccess",
		'__func__' => sub {
			my ($in_CMD) = @_;
			$in_CMD = '' if (!defined $in_CMD);

			# Parsing INPUT string into PARAMETERS
			my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD, { 'RETURN_ID' => 1, 'AS_ARRAY' => 1, 'ESCAPE_OFF' => 0, 'DISALLOW_SPACES' => 1 });
			my $result = '';
			if (!$hash_PARAMS->{'ID'}) { $result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed", '  - Incorect input, please specify chmod value and file(s)/directory(s) correctly'); }
			else {
				my $value = '';
				my $dir = '';
				my $dir_found = 0;
				my @arr_files;
				foreach my $line (@{ $hash_PARAMS->{'DATA'} }) {
					foreach (keys %{ $line }) {
						if ($_ ne '') {
							# Getting directory parameter
							if (!$dir_found && $_ =~ /^['"]{0,}-dir['"]{0,}$/i && defined $line->{$_}) {
								$dir_found = 1;
								$dir = $line->{$_};
							}
							elsif ($value eq '') {
								$value = $_;
								$value =~ s/^'//; $value =~ s/'$//;
								$value =~ s/^"//; $value =~ s/"$//;
							}
							else {
								my $path = $_;
								if (defined $line->{$_}) { $path .= '='.$line->{$_}; }
								push @arr_files, $path;
							}
						}
					}
				}
				# Changing directory
				my $is_OK = 1;
				if ($dir_found) {
					# Checking value
					$dir = &WC::Dir::check_in($dir);
					if ($dir eq '') {
						$result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed", '  - Incorrect TARGET DIRECTORY specified');
						$is_OK = 0;
					}
					# Changing directory
					elsif (!&WC::Dir::change_dir($dir)) {
						$result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed", '&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 });
						$is_OK = 0;
					}
				}
				if ($is_OK) {
					# CHMOD'ing
					if ($value !~ /^\d{3}$/) { $result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed", '&nbsp;&nbsp;- Incorect input, CHMOD value "<span class="t-link">'.&NL::String::str_HTML_value($value).'</span>" is incorrect (values examples: <span class="t-link">777</span>, <span class="t-link">755</span>, <span class="t-link">660</span>)<br />'.
						"&nbsp;&nbsp;&nbsp;&nbsp;Examples:<br />".
						"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #file chmod 777 file.txt<br />".
						"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #file chmod 755 file.pl file2.pl file3.php<br />".
						"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #file chmod 660 .htaccess",
						{ 'ENCODE_TO_HTML' => 0 });
					}
					elsif (scalar @arr_files <= 0) { $result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE CHMOD'ed", '  - Incorect input, no file(s)/directory(s) specified'); }
					else {
						my $html_chmodded = '';
						my $num_chmodded = 0;
						my $num_total = 0;
						foreach (@arr_files) {
							my $path = &WC::Dir::check_in($_);
							my $path_encoded = $path;
							&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_encoded);

							$num_total++;
							$html_chmodded .= '<br />' if ($html_chmodded ne '');
							my $type = '';
							if (!-e $path) { $html_chmodded .= '&nbsp;&nbsp;-&nbsp;No file/directory '.&WC::HTML::get_short_value($path_encoded).' found'; }
							elsif (-f $path) { $type = 'File'; }
							else { $type = 'Directory'; }
							if ($type ne '') {
								if (chmod(oct($value), $path) > 0) { $html_chmodded .= '&nbsp;&nbsp;-&nbsp;'.$type.' '.&WC::HTML::get_short_value($path_encoded).' has been successfully CHMOD\'ed'; $num_chmodded++; }
								else { $html_chmodded .= '&nbsp;&nbsp;-&nbsp;'.$type.' '.&WC::HTML::get_short_value($path_encoded).' can not be CHMOD\'ed'.( ($! ne '') ? '<br /><span class="t-green-light">&nbsp;&nbsp;&nbsp;&nbsp;'.$!.'</span>' :  '' ); }
							}
						}
						$result = &WC::HTML::get_message("CHMOD'ing '<span class=\"t-link\">$value</span>' RESULTS (CHMOD'ed '$num_chmodded' OF '$num_total')", $html_chmodded, { 'ENCODE_TO_HTML' => 0 });
					}
				}
			}
			return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
		}
	},

	### REMOVE ###
	'remove' => {
		'__doc__' => 'Remove file(s)/directory(s)',
		'__info__' => 'Please type: <file name(s)>/<directory name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n".
				"  Examples:\n".
				"    - #file remove file.txt some_directory\n".
				"    - #file remove file1.pl file.tar.gz",
		'__func__' => sub {
			my ($in_CMD) = @_;
			$in_CMD = '' if (!defined $in_CMD);

			# Parsing INPUT string into PARAMETERS
			my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD, { 'RETURN_ID' => 1, 'AS_ARRAY' => 1, 'ESCAPE_OFF' => 0, 'DISALLOW_SPACES' => 1 });
			my $result = '';
			if (!$hash_PARAMS->{'ID'}) { $result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE REMOVED", '  - Incorect input, please specify file(s)/directory(s) correctly'); }
			else {
				my $dir = '';
				my $dir_found = 0;
				my @arr_files;
				foreach my $line (@{ $hash_PARAMS->{'DATA'} }) {
					foreach (keys %{ $line }) {
						if ($_ ne '') {
							# Getting directory parameter
							if (!$dir_found && $_ =~ /^['"]{0,}-dir['"]{0,}$/i && defined $line->{$_}) {
								$dir_found = 1;
								$dir = $line->{$_};
							}
							else {
								my $path = $_;
								if (defined $line->{$_}) { $path .= '='.$line->{$_}; }
								push @arr_files, $path;
							}
						}
					}
				}
				# Changing directory
				my $is_OK = 1;
				if ($dir_found) {
					# Checking value
					$dir = &WC::Dir::check_in($dir);
					if ($dir eq '') {
						$result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE REMOVED", '  - Incorrect TARGET DIRECTORY specified');
						$is_OK = 0;
					}
					# Changing directory
					elsif (!&WC::Dir::change_dir($dir)) {
						$result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE REMOVED", '&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 });
						$is_OK = 0;
					}
				}
				if ($is_OK) {
					# REMOVING
					if (scalar @arr_files <= 0) { $result = &WC::HTML::get_message("FILE(S)/DIRECTORY(S) CAN'T BE REMOVED", '  - Incorect input, no file(s)/directory(s) specified'); }
					else {
						my $html_removed = '';
						my $num_removed = 0;
						my $num_total = 0;
						foreach (@arr_files) {
							my $path = &WC::Dir::check_in($_);
							my $path_encoded = $path;
							&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_encoded);

							$num_total++;
							$html_removed .= '<br />' if ($html_removed ne '');
							if (!-e $path) {
								$html_removed .= '&nbsp;&nbsp;-&nbsp;No file/directory '.&WC::HTML::get_short_value($path_encoded).' found';
							}
							elsif (-f $path) {
								if (unlink($path) > 0) { $html_removed .= '&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path_encoded).' has been successfully removed'; $num_removed++; }
								else { $html_removed .= '&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path_encoded).' can not be removed'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ); }
							}
							else {
								my $hash_REMOVE = &manager_DIR_remove($path);
								if ($hash_REMOVE->{'ID'}) { $html_removed .= '&nbsp;&nbsp;-&nbsp;Directory '.&WC::HTML::get_short_value($path_encoded).' has been successfully removed'; $num_removed++; }
								else { $html_removed .= '&nbsp;&nbsp;-&nbsp;File/directory '.&WC::HTML::get_short_value($path_encoded).' can not be removed:<br /><span class="t-green-light">&nbsp;&nbsp;&nbsp;&nbsp;'.$hash_REMOVE->{'ERROR'}.'</span>'; }
							}
						}
						$result = &WC::HTML::get_message("REMOVING RESULTS (REMOVED '$num_removed' OF '$num_total')", $html_removed, { 'ENCODE_TO_HTML' => 0 });
					}
				}
			}
			return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
		}
	},

	### MANAGER ###
	'manager' => {
		'__doc__' => 'File manager (files/directories manipulation)',
		'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'open Web Console File Manager.',
		'__func__' => sub {
			my ($in_CMD) = @_;
			$in_CMD = '' if (!defined $in_CMD);

			my $result = '';
			my $in_DIR = &WC::Dir::check_in($in_CMD);
			# Changing directory if it is defined
			if ($in_DIR ne '') {
				if (!&WC::Dir::change_dir($in_DIR)) {
					my $error = 'Directory '.&WC::HTML::get_short_value($in_DIR).' is not accessible'.( ($! ne '') ? ': '.$! :  '' );
					$error .= '<br />&nbsp;&nbsp;&nbsp;&nbsp;Please choose another directory';
					$result = &WC::HTML::get_message("FILE MANAGER CAN'T BE STARTED", '&nbsp;&nbsp;-&nbsp;'.$error, { 'ENCODE_TO_HTML' => 0 });
					return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
				}
			}
			# Getting current directory
			&WC::Dir::update_current_dir();
			my $dir_current = &WC::Dir::get_current_dir();
			# Getting directory listing
			my $ID = &WC::Internal::get_unique_id();
			my $hash_LIST = &manager_DIR_listing($dir_current, { 'MAKE_HTML_AS_JS_STRING' => 1, 'JS_ID' => $ID });
			if (!$hash_LIST->{'ID'}) { $result = &WC::HTML::get_message("FILE MANAGER CAN'T BE STARTED", '&nbsp;&nbsp;-&nbsp;'.$hash_LIST->{'ERROR'}, { 'ENCODE_TO_HTML' => 0 }); }
			else {
				# Preparing messages to OUTPUT, at JS HTML value format
				my $HTML_message_PATH = &NL::String::str_JS_value( &NL::String::str_HTML_value($dir_current) );
				my $HTML_message_PATH_TO_PROMPT = $HTML_message_PATH;
				# Preparing MAIN OUTPUT message
				my $HTML_message_MAIN = ''.
				'<form id="wc-file-manager-form-'.$ID.'" action="" onsubmit="return false" target="_blank">'.
				'<input type="hidden" id="_wc-file-manager-REGEX-'.$ID.'" name="wc-file-manager-REGEX-'.$ID.'" value="" />'.
				'<input type="hidden" id="_wc-file-manager-PATH-'.$ID.'" name="wc-file-manager-PATH-'.$ID.'" value="'.$HTML_message_PATH.'" />'.
				'<input type="hidden" id="_wc-file-manager-ID-'.$ID.'" name="wc-file-manager-ID-'.$ID.'" value="'.$ID.'" />'.
				'<table class="grid" style="width: 100%">'.
				'	<tr><td>'.
				'		<table class="grid" style="width: 100%"><tr>'.
				'			<td class="wc-ui-fm-path-text">Path:</td>'.
				'			<td class="wc-ui-fm-path-input"\'+ff_style+\'><input class="in-text" style="border: 1px solid #6a7070; \'+path_input_WIDTH+\'" type="text" id="_wc_file_manager_PATH_IN-'.$ID.'" name="wc_file_manager_PATH_IN-'.$ID.'" value="'.$HTML_message_PATH.'" onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /></td>'.
				'			<td class="wc-ui-fm-path-button-GO"><div id="wc-file-manager-button-GO-'.$ID.'" class="div-button" style="width: 20px" title="Go to path">GO</div></td>'.
				'			<td class="wc-ui-fm-path-button-UP"><div id="wc-file-manager-button-UP-'.$ID.'" class="div-button" style="width: 20px" title="Go upper">UP</div></td>'.
				'		</tr></table>'.
				'	</td></tr>'.
				'<tr><td>'.
				'	<table class="grid" style="width: 100%"><tr>'.
				'		<td class="wc-ui-fm-info-left">Files/directories total: <span id="_wc_file_manager_TOTAL-'.$ID.'">'.$hash_LIST->{'TOTAL'}.'</span>, selected: <span id="_wc_file_manager_SELECTED-'.$ID.'">0</span></td>'.
				'		<td class="wc-ui-fm-info-right"><span class="span-message" id="_wc_file_manager_STATUS-MESSAGE-'.$ID.'">&nbsp;</span>&nbsp;&nbsp;Status: <span id="_wc_file_manager_STATUS-'.$ID.'">Idle</span></td>'.
				'	</tr></table>'.
				'</td></tr>'.
				'<tr><td class="area-main"><div id="_wc_file_manager_FILES-'.$ID.'" class="wc-ui-fm-listing" style="width:\'+t_w+\'px">'.$hash_LIST->{'HTML'}.'</div></td></tr>'.
				'<tr><td>'.
				'	<table class="grid"><tr>'.
				'	<td class="area-button-left"><div id="wc-file-manager-button-CLOSE-'.$ID.'" class="div-button w-90" title="Close File Manger">Close</div></td>'.
				'	<td class="area-button-right"><div id="wc-file-manager-button-REFRESH-'.$ID.'" class="div-button w-90" title="Reload directory data">Refresh</div></td>'.
				'	<td class="area-button-right"><div id="wc-file-manager-button-SELECT-MASK-'.$ID.'" class="div-button w-120" title="Select by mask">Select (mask)</div></td>'.
				'	<td class="area-button-right"><div id="wc-file-manager-button-SELECT-ALL-'.$ID.'" class="div-button w-100" title="Select all">Select all</div></td>'.
				'	<td class="area-button-right"><div id="wc-file-manager-button-CLEAR-'.$ID.'" class="div-button w-130" title="Clear all selection">Clear selection</div></td>'.
				'	<td class="area-button-right"><div class="div-buttons-splitter">|</div></td>'.
				'	<td class="area-button-right"><div id="wc-file-manager-button-EDIT-'.$ID.'" class="div-button w-80" title="Edit file(s)">Edit</div></td>'.
				'	<td class="area-button-right"><div id="wc-file-manager-button-REMOVE-'.$ID.'" class="div-button w-80" title="Remove file(s)/directory(s)">Remove</div></td>'.
				'	<td class="area-button-right"><div id="wc-file-manager-button-OPEN-'.$ID.'" class="div-button w-150" title="Open/View/Play file(s)">Open/Run/View/Play</div></td>'.
				'</tr></table>'.
				'<table class="grid"><tr>'.
				'	<td class="area-button-left" style="padding-top: 4px"><div id="wc-file-manager-button-DOWNLOAD-'.$ID.'" class="div-button w-90" title="Download file(s)">Download</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-manager-button-UPLOAD-'.$ID.'" class="div-button w-90" title="Upload file(s)">Upload</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.
				'	<td class="area-button-right s-message" style="padding-top: 3px">CHMOD:</td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><input class="in-text" style="border: 1px solid #6a7070; width: 50px" type="text" id="_wc_file_manager_CHMOD-'.$ID.'" name="wc_file_manager_CHMOD-'.$ID.'" value="755"  onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-manager-button-CHMOD-'.$ID.'" class="div-button w-90" title="CHMOD file(s)/directory(s)">CHMOD</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-manager-button-RMBELOW-'.$ID.'" class="div-button w-270">Remove all messages below this box</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px">'.
				'		<input class="in-checkbox" style="margin-left: 3px" type="checkbox" id="_wc_file_manager_PATH-UPDATE-'.$ID.'" name="wc_file_manager_PATH-UPDATE-'.$ID.'" checked value="1"  onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /> <label class="s-message" title="If checked - global path will be synchronized with File Manager path" style="cursor: help" for="_wc_file_manager_PATH-UPDATE-'.$ID.'">Synchronize global path</label>'.
				'	</td>'.
				'</tr></table>'.
				'</td></tr>'.
				'</table></form>';
				# Converting MAIN HTML to JS value (don't escaping "'" - that is will be used to set width and height from JS)
				$HTML_message_MAIN =~ s/\n/\\n/g;
				$HTML_message_MAIN =~ s/\r/\\r/g;
				# And generating result
				$result = <<HTML_EOF;
<div id="wc-file-manager-CONTAINER-${ID}"></div>
<script type="text/JavaScript"><!--
	// Changing internal path
	WC.Console.State.change_dir('${HTML_message_PATH_TO_PROMPT}');
	// Getting width and height
	// var t_h = xClientHeight(); t_h -= 190; if (t_h < 100) t_h = 100;
	var t_w = xClientWidth(); t_w -= 90;
	if (NL.Browser.Detect.isIE) { if (t_w < 930) t_w = 930; }
	else { if (t_w < 1039) t_w = 1039; }
	var ff_style = (NL.Browser.Detect.isFF) ? ' style="padding-right: 12px"' : '';
	var path_input_WIDTH = (!NL.Browser.Detect.isIE7) ? 'width: 100%;' : 'width: 99%;';

	WC.UI.tab_set('wc-file-manager-CONTAINER-${ID}', 'File Manager', '${HTML_message_MAIN}', { 'ID': '_NO_ID_wc-file-manager-tab-${ID}', 'BOTTOM': '' });
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-CLOSE-$ID', function () { WC.Console.HTML.OUTPUT_remove_result('wc-file-manager-CONTAINER-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-RMBELOW-$ID', function () { WC.Console.HTML.OUTPUT_remove_below('wc-file-manager-CONTAINER-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-REFRESH-$ID', function () {
		var obj_DATA = xGetElementById('_wc_file_manager_FILES-${ID}');
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		var obj_SELECTED = xGetElementById('_wc_file_manager_SELECTED-${ID}');
		if (obj_DATA && obj_PATH && obj_SELECTED) {
			WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-${ID}', 'Refreshing', 1);
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("REFRESHING", '#file _manager_ACTION',
				{ 'ACTION': 'refresh', 'dir': obj_PATH.value, 'js_ID': '${ID}' },
				[],
				{ 'type': 'hidden', 'id_TIMER': id_timer }
			);
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-CLEAR-${ID}', function () {
		WC.UI.Filemanager.selection_clear('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-SELECT-ALL-${ID}', function () {
		WC.UI.Filemanager.selection_all('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-SELECT-MASK-${ID}', function () {
		var obj_REGEX = xGetElementById('_wc-file-manager-REGEX-${ID}');
		var in_regex = prompt(''+
				"Please enter REGEX (regular expression) at JavaScript format, examples:\\n"+
				"   '.*' - anything;\\n"+
				"   '^test.*' - begins from 'test' and after that - anything;\\n"+
				"   '.*test\$' - begins from anything and ends with 'test';\\n"+
				"   '^\\\\d+\$' - digits only."+
				'', (obj_REGEX && obj_REGEX.value) ? obj_REGEX.value : '.*');
		if (obj_REGEX) obj_REGEX.value = in_regex;
		WC.UI.Filemanager.selection_regex('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}', in_regex);
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-EDIT-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				var is_edit = 1;
				/*if (arr_selected.length > 1) {
					if (!confirm("There are selected more than 1 element,\\nare you shure want to edit all of them?")) is_edit = 0;
				}*/
				if (is_edit) {
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("STARTING FILE(S) EDITING", '#file edit', { '-dir': obj_PATH.value }, arr_selected);
				}
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-GO-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		var obj_PATH_IN = xGetElementById('_wc_file_manager_PATH_IN-${ID}');
		var obj_SYNC = xGetElementById('_wc_file_manager_PATH-UPDATE-${ID}');
		if (obj_PATH && obj_PATH_IN && obj_SYNC) {
			if (!obj_PATH_IN.value) alert("There is not PATH entered,\\nPlease enter it.");
			else {
				WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-${ID}', '');
				var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-${ID}', 'Changing path', 1);
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("CHANGING PATH", '#file _manager_ACTION',
					{ 'ACTION': 'go', 'dir': obj_PATH.value, 'js_ID': '${ID}', 'go_path': obj_PATH_IN.value, 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
					[],
					{ 'type': 'hidden', 'id_TIMER': id_timer }
				);
			}
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	xAddEventListener('_wc_file_manager_PATH_IN-${ID}', 'keypress',  function (event) {
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
			var obj_PATH_IN = xGetElementById('_wc_file_manager_PATH_IN-${ID}');
			var obj_SYNC = xGetElementById('_wc_file_manager_PATH-UPDATE-${ID}');
			if (obj_PATH && obj_PATH_IN && obj_SYNC) {
				if (!obj_PATH_IN.value) alert("There is not PATH entered,\\nPlease enter it.");
				else {
					WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-${ID}', '');
					var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-${ID}', 'Changing path', 1);
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("CHANGING PATH", '#file _manager_ACTION',
						{ 'ACTION': 'go', 'dir': obj_PATH.value, 'js_ID': '${ID}', 'go_path': obj_PATH_IN.value, 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
						[],
						{ 'type': 'hidden', 'id_TIMER': id_timer }
					);
				}
			}
			else alert("Unable to find File Manager objects (internal error)");
			return false;
		}
		return true;
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-UP-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		var obj_SYNC = xGetElementById('_wc_file_manager_PATH-UPDATE-${ID}');
		if (obj_PATH && obj_SYNC) {
			WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-${ID}', 'Changing path (going upper)', 1);
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("CHANGING PATH (GOING UPPER)", '#file _manager_ACTION',
				{ 'ACTION': 'go_up', 'dir': obj_PATH.value, 'js_ID': '${ID}', 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
				[],
				{ 'type': 'hidden', 'id_TIMER': id_timer }
			);
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-REMOVE-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("REMOVING FILE(S)/DIRECTORY(S)", '#file remove', { '-dir': obj_PATH.value }, arr_selected);
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-OPEN-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("OPENING FILE(S)", '#file open', { '-dir': obj_PATH.value }, arr_selected);
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-DOWNLOAD-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("DOWNLOADING FILE(S)", '#file download', { '-dir': obj_PATH.value }, arr_selected);
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-CHMOD-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		var obj_CHMOD = xGetElementById('_wc_file_manager_CHMOD-${ID}');
		if (obj_PATH && obj_CHMOD) {
			var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
			if (arr_selected.length > 0) {
				if (!obj_CHMOD.value) alert("There is no CHMOD value entered.\\nPlease enter something (755, 777, ...).");
				else {
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("CHMOD'ing FILE(S)/DIRECTORY(S)", '#file chmod '+obj_CHMOD.value, { '-dir': obj_PATH.value }, arr_selected);
				}
			}
			else alert("There are no elements selected.\\nPlease select something.");
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	xAddEventListener('_wc_file_manager_CHMOD-${ID}', 'keypress',  function (event) {
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
			var obj_CHMOD = xGetElementById('_wc_file_manager_CHMOD-${ID}');
			if (obj_PATH && obj_CHMOD) {
				var arr_selected = WC.UI.Filemanager.selection_get('_wc_file_manager_FILES-LIST-${ID}', '_wc_file_manager_SELECTED-${ID}');
				if (arr_selected.length > 0) {
					if (!obj_CHMOD.value) alert("There is no CHMOD value entered.\\nPlease enter something (755, 777, ...).");
					else {
						// OK, executing command
						WC.Console.Exec.CMD_INTERNAL("CHMOD'ing FILE(S)/DIRECTORY(S)", '#file chmod '+obj_CHMOD.value, { 'dir': obj_PATH.value }, arr_selected);
					}
				}
				else alert("There are no elements selected.\\nPlease select something.");
			}
			else alert("Unable to find File Manager objects (internal error)");
			return false;
		}
		return true;
	});
	NL.UI.div_button_register('div-button', 'wc-file-manager-button-UPLOAD-$ID', function () {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-${ID}');
		if (obj_PATH) {
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("STARTING FILE(S) UPLOADING FORM", '#file upload "'+obj_PATH.value+'"');
		}
		else alert("Unable to find File Manager objects (internal error)");
	});
	/*
	// Adding BACK event
	xAddEventListener('_wc_file_manager_FILES-${ID}', 'keypress',  function (event) {
		alert('BACK EVENT - TEST');
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			return false;
		}
		return true;
	});
	*/
	// Adding scrolling event if it is needed
	/*
	var obj = xGetElementById('_wc_file_manager_FILES-${ID}');
	if (obj && obj.scrollWidth > obj.clientWidth) {
	*/
		NL.UI.object_event_SCROLL('_wc_file_manager_FILES-${ID}', function (event) {
			var obj = xGetElementById('_wc_file_manager_FILES-${ID}');
			if (obj && obj.scrollWidth > obj.clientWidth) {
				var pixels = 80;
				var d = NL.UI.object_event_SCROLL_get_delta(event);
				if (d < 0) obj.scrollLeft += pixels;
				else if (d > 0) obj.scrollLeft -= pixels;
				return false;
			}
			else return true;

		});
	/*}*/
	WC.UI.Filemanager.make_unselectable('_wc_file_manager_FILES-LIST-${ID}');
//--></script>
HTML_EOF
			}
			return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
		},
		'__func_auto__' => sub {
			my $result = \%{ $WC::Internal::DATA::AC_RESULT };
			$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#file'}->{'manager'}->{'__func__'}->();
			return $result;
		}
	},
	'_manager_ACTION' => {
		'__doc__' => 'Internal method for File Manager actions (called when form internal action is needed)',
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
				# 'REFRESH' action
				if ($hash_PARAMS->{'ACTION'} eq 'refresh') {
					if (defined $hash_PARAMS->{'dir'} && $hash_PARAMS->{'dir'} ne '') {
						# Getting list of directory at HTML format prepared to be JS string
						my $hash_LIST = &manager_DIR_listing($hash_PARAMS->{'dir'}, { 'JS_ID' => $hash_PARAMS->{'js_ID'}, 'MAKE_HTML_AS_JS_STRING' => 1 } );
						if ($hash_LIST->{'ID'}) {
							$result = ''.
							'<script type="text/JavaScript"><!--'."\n".
							'	var obj_TOTAL = xGetElementById(\'_wc_file_manager_TOTAL-'.$hash_PARAMS->{'js_ID'}.'\');'.
							'	var obj_SELECTED = xGetElementById(\'_wc_file_manager_SELECTED-'.$hash_PARAMS->{'js_ID'}.'\');'.
							'	var obj_FILES = xGetElementById(\'_wc_file_manager_FILES-'.$hash_PARAMS->{'js_ID'}.'\');'.
							'	if (obj_TOTAL && obj_SELECTED && obj_FILES) {'.
							'		obj_TOTAL.innerHTML = '.$hash_LIST->{'TOTAL'}.';'.
							'		obj_SELECTED.innerHTML = 0;'.
							'		obj_FILES.innerHTML = \''.$hash_LIST->{'HTML'}.'\';'.
							'		WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
							'		WC.Console.HTML.add_time_message(\'_wc_file_manager_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'[DIRECTORY HAS BEEN REFRESHED SUCCESSFULLY]\', { \'TIME\': 5 });'.
							'		WC.UI.Filemanager.make_unselectable(\'_wc_file_manager_FILES-LIST-'.$hash_PARAMS->{'js_ID'}.'\');'.
							'	}'.
							'	else alert("Unable to find File Manager objects (internal error)");'."\n".
							'//--></script>';
						}
						else {
							my $error = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY DATA CAN'T BE REFRESHED", '&nbsp;&nbsp;-&nbsp;'.$hash_LIST->{'ERROR'}, { 'ENCODE_TO_HTML' => 0 }) );
							$result = ''.
							'<script type="text/JavaScript"><!--'."\n".
							'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
							'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> REFRESHING DIRECTORY DATA</span>\', \''.$error.'\');'."\n".
							'//--></script>';
						}
					}
					else {
						my $error = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY DATA CAN'T BE REFRESHED", '  - Incorrect call, directory is not specified') );
						$result = ''.
						'<script type="text/JavaScript"><!--'."\n".
						'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
						'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> REFRESHING DIRECTORY DATA</span>\', \''.$error.'\');'."\n".
						'//--></script>';
					}
				}
				# 'GO' action
				elsif ($hash_PARAMS->{'ACTION'} eq 'go') {
					if (defined $hash_PARAMS->{'dir'} && defined $hash_PARAMS->{'go_path'} && $hash_PARAMS->{'go_path'} ne '') {
						my $hash_PATH = {
							'GO_PATH' => $hash_PARAMS->{'go_path'},
							'hash_PARAMS' => $hash_PARAMS ,
							'UPDATE_PATH' => (defined $hash_PARAMS->{'update_path'} && $hash_PARAMS->{'update_path'}) ? 1 : 0
						};
						$result = &manager_DIR_change($hash_PARAMS->{'dir'}, $hash_PATH);
					}
					else {
						my $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '  - Incorrect call, directory is not specified') );
						$result = ''.
						'<script type="text/JavaScript"><!--'."\n".
						'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
						'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHANGING DIRECTORY</span>\', \''.$message.'\');'."\n".
						'//--></script>';
					}
				}
				# 'GO UP' action
				elsif ($hash_PARAMS->{'ACTION'} eq 'go_up') {
					if (defined $hash_PARAMS->{'dir'} && $hash_PARAMS->{'dir'} ne '') {
						my $hash_PATH = {
							'GO_PATH' => '..',
							'hash_PARAMS' => $hash_PARAMS ,
							'UPDATE_PATH' => 1
						};
						$result = &manager_DIR_change($hash_PARAMS->{'dir'}, $hash_PATH);
					}
					else {
						my $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '  - Incorrect call, directory is not specified') );
						$result = ''.
						'<script type="text/JavaScript"><!--'."\n".
						'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');'.
						'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHANGING DIRECTORY (GOING UPPER)</span>\', \''.$message.'\');'."\n".
						'//--></script>';
					}
				}
				else {
					my $error = &NL::String::str_JS_value( &WC::HTML::get_message("FILE MANAGER ACTION CAN'T BE EXECUTED", '  - Incorrect call, unable to find needed objects') );
					$result = ''.
					'<script type="text/JavaScript"><!--'."\n".
					( (defined $hash_PARAMS->{'js_ID'} && $hash_PARAMS->{'js_ID'} ne '') ? ' WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');' : '').
					'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> _UNKNOWN_ FILE MANAGER ACTION</span>\', \''.$error.'\');'."\n".
					'//--></script>';
				}
				# === END OF ACTIONS
			}
			else {
				my $error = &NL::String::str_JS_value( &WC::HTML::get_message("FILE MANAGER ACTION CAN'T BE EXECUTED", '  - Incorrect call, unable to find needed objects') );
				$result = ''.
				'<script type="text/JavaScript"><!--'."\n".
				( (defined $hash_PARAMS->{'js_ID'} && $hash_PARAMS->{'js_ID'} ne '') ? ' WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');' : '').
				'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> _UNKNOWN_ FILE MANAGER ACTION</span>\', \''.$error.'\');'."\n".
				'//--></script>';
			}
			# Returning result
			return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
		}
	},

	### OPEN/VIEW/PLAY ###
	'open' => {
		'__doc__' => 'Open/show file(s)',
		'__info__' => 'Please type: <file name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n".
				"  Examples:\n".
				"    - #file open file.txt\n".
				"    - #file open image.jpg\n".
				"    - #file open file1.txt image1.jpg",
		'__func__' => sub {
			my ($in_CMD) = @_;
			$in_CMD = '' if (!defined $in_CMD);

			# Parsing INPUT string into PARAMETERS
			my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD, { 'RETURN_ID' => 1, 'AS_ARRAY' => 1, 'ESCAPE_OFF' => 0, 'DISALLOW_SPACES' => 1 });
			my $result = '';
			if (!$hash_PARAMS->{'ID'}) { $result = &WC::HTML::get_message("FILE(S) CAN'T BE OPENED", '  - Incorect input, please specify file(s) correctly'); }
			else {
				my $dir = '';
				my $dir_found = 0;
				my @arr_files;
				foreach my $line (@{ $hash_PARAMS->{'DATA'} }) {
					foreach (keys %{ $line }) {
						if ($_ ne '') {
							# Getting directory parameter
							if (!$dir_found && $_ =~ /^['"]{0,}-dir['"]{0,}$/i && defined $line->{$_}) {
								$dir_found = 1;
								$dir = $line->{$_};
							}
							else {
								my $path = $_;
								if (defined $line->{$_}) { $path .= '='.$line->{$_}; }
								push @arr_files, $path;
							}
						}
					}
				}
				# Changing directory
				my $is_OK = 1;
				if ($dir_found) {
					# Checking value
					$dir = &WC::Dir::check_in($dir);
					if ($dir eq '') {
						$result = &WC::HTML::get_message("FILE(S) CAN'T BE OPENED", '  - Incorrect TARGET DIRECTORY specified');
						$is_OK = 0;
					}
					# Changing directory
					elsif (!&WC::Dir::change_dir($dir)) {
						$result = &WC::HTML::get_message("FILE(S) CAN'T BE OPENED", '&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 });
						$is_OK = 0;
					}
				}
				if ($is_OK) {
					# Starting edit form(s)
					if (scalar @arr_files <= 0) { $result = &WC::HTML::get_message("FILE(S) CAN'T BE OPENED", '  - Incorect input, no file(s) specified'); }
					else {
						my $MAX_FILES = 5;
						my $num_ok = 0;
						my $num_total = 0;
						$result = '';
						my $result_HTML = '';
						my $result_BAD = '';

						# Getting login/password
						my $user_login_URL =  &NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_login'});
						my $user_password_URL =  &NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_password'});
						# Getting current directory
						&WC::Dir::update_current_dir();
						my $dir_current = &WC::Dir::get_current_dir();
						my $dir_current_ENC_INTERNAL = $dir_current;
						&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$dir_current_ENC_INTERNAL);
						my $dir_current_URL = &NL::String::str_HTTP_REQUEST_value($dir_current_ENC_INTERNAL);

						my $result_GOOD_HTML_JS_VALUE = '';
						my $result_GOOD_JS = '';
						foreach (@arr_files) {
							$num_total++;
							my $path = &WC::Dir::check_in($_);
							my $path_ENC_INTERNAL = $path;
							# Converting encoding
							&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_ENC_INTERNAL);
							# Limit exceed
							if ($num_ok >= $MAX_FILES) { $result_BAD .= '<div class="t-blue">&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path_ENC_INTERNAL).' is not opened: <span class="t-red-dark">maximum opened files at the same time is '.$MAX_FILES.'</span></div>'; }
							else {
								if (!-e $path) { $result_BAD .= '<div class="t-blue">&nbsp;&nbsp;-&nbsp;No file '.&WC::HTML::get_short_value($path_ENC_INTERNAL).' found</div>'; }
								elsif (!-f $path) { $result_BAD .= '<div class="t-blue">&nbsp;&nbsp;-&nbsp;'.&WC::HTML::get_short_value($path_ENC_INTERNAL).' is not a file</div>'; }
								else {
									my $hash_OPEN = &WC::HTML::Open::start($path);

									if ($hash_OPEN->{'ID'}) {
										$num_ok++;
										$result_HTML .= $hash_OPEN->{'HTML'};
									}
									else {
										$result_BAD .= $hash_OPEN->{'HTML'};
									}
								}
							}
						}
						my $is_GOOD_needed = 0;
						if ($num_total > 1) {
							$result = "<div class=\"t-lime\">OPENING '$num_ok' OF '$num_total':</div>";
							if ($num_total > $num_ok) { $result .= "<div class=\"t-green\">&nbsp;&nbsp;Can't be opened:</div>".$result_BAD; }
							if ($num_ok > 0) { $result .= "<div class=\"t-green\">&nbsp;&nbsp;Opened:</div>\n"; $is_GOOD_needed = 1; }
						}
						else {
							if ($num_ok > 0) { $is_GOOD_needed = 1; }
							else { $result = "<div class=\"t-lime\">FILE(S) CAN'T BE OPENDED:</div>".$result_BAD; }
						}
						# If all is OK
						if ($is_GOOD_needed) {
							my $ID = &WC::Internal::get_unique_id();
							$result .= '<div id="wc-open-CONTAINER-'.$ID.'">'.$result_HTML.'</div>';
							if ($num_ok > 1) {
								$result .= "\n".'<script type="text/JavaScript"><!--'."\n".
									   "WC.Console.HTML.OUTPUT_set_mark('wc-open-CONTAINER-$ID', 'DO_NOT_CLOSE_ALL');".
									   "\n//--></script>\n";
							}
						}
					}
				}
			}
			return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
		}
	},
	'show' => '$$#file|open$$',

	### DOWNLOAD ###
	'download' => {
		'__doc__' => 'Download file(s)',
		'__info__' => 'Please type: <file name(s)>'."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'}.".\n".
				"  Examples:\n".
				"    - #file download file.txt\n".
				"    - #file download file1.pl pack.tar.gz",
		'__func__' => sub {
			my ($in_CMD) = @_;
			$in_CMD = '' if (!defined $in_CMD);

			# Parsing INPUT string into PARAMETERS
			my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD, { 'RETURN_ID' => 1, 'AS_ARRAY' => 1, 'ESCAPE_OFF' => 0, 'DISALLOW_SPACES' => 1 });
			my $result = '';
			if (!$hash_PARAMS->{'ID'}) { $result = &WC::HTML::get_message("FILE(S) CAN'T BE DOWNLOADED", '  - Incorect input, please specify file(s) correctly'); }
			else {
				my $dir = '';
				my $dir_found = 0;
				my @arr_files;
				foreach my $line (@{ $hash_PARAMS->{'DATA'} }) {
					foreach (keys %{ $line }) {
						if ($_ ne '') {
							# Getting directory parameter
							if (!$dir_found && $_ =~ /^['"]{0,}-dir['"]{0,}$/i && defined $line->{$_}) {
								$dir_found = 1;
								$dir = $line->{$_};
							}
							else {
								my $path = $_;
								if (defined $line->{$_}) { $path .= '='.$line->{$_}; }
								push @arr_files, $path;
							}
						}
					}
				}
				# Changing directory
				my $is_OK = 1;
				if ($dir_found) {
					# Checking value
					$dir = &WC::Dir::check_in($dir);
					if ($dir eq '') {
						$result = &WC::HTML::get_message("FILE(S) CAN'T BE DOWNLOADED", '  - Incorrect TARGET DIRECTORY specified');
						$is_OK = 0;
					}
					# Changing directory
					elsif (!&WC::Dir::change_dir($dir)) {
						$result = &WC::HTML::get_message("FILE(S) CAN'T BE DOWNLOADED", '&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 });
						$is_OK = 0;
					}
				}
				if ($is_OK) {
					# Starting edit form(s)
					if (scalar @arr_files <= 0) { $result = &WC::HTML::get_message("FILE(S) CAN'T BE DOWNLOADED", '  - Incorect input, no file(s) specified'); }
					else {
						my $MAX_FILES = 5;
						my $num_ok = 0;
						my $num_total = 0;
						$result = '';
						my $result_HTML = '';
						my $result_BAD = '';

						# Getting login/password
						my $user_login_URL =  &NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_login'});
						my $user_password_URL =  &NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_password'});
						# Getting current directory
						&WC::Dir::update_current_dir();
						my $dir_current = &WC::Dir::get_current_dir();
						my $dir_current_ENC_INTERNAL = $dir_current;
						&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$dir_current_ENC_INTERNAL);
						my $dir_current_URL = &NL::String::str_HTTP_REQUEST_value($dir_current_ENC_INTERNAL);

						my $result_GOOD_HTML_JS_VALUE = '';
						my $result_GOOD_JS = '';
						foreach (@arr_files) {
							$num_total++;
							my $path = &WC::Dir::check_in($_);
							my $path_ENC_INTERNAL = $path;
							# Converting encoding
							&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_ENC_INTERNAL);
							# Limit exceed
							if ($num_ok >= $MAX_FILES) { $result_BAD .= '<div class="t-blue">&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;File '.&WC::HTML::get_short_value($path_ENC_INTERNAL).' does not downloaded: <span class="t-red-dark">maximum downloaded files at the same time is '.$MAX_FILES.'</span></div>'; }
							else {
								if (!-e $path) { $result_BAD .= '&nbsp;&nbsp;-&nbsp;No file '.&WC::HTML::get_short_value($path_ENC_INTERNAL).' found<br />'; }
								elsif (!-f $path) { $result_BAD .= '&nbsp;&nbsp;-&nbsp;'.&WC::HTML::get_short_value($path_ENC_INTERNAL).' is not a file<br />'; }
								else {
									$num_ok++;
									# Converting path to URL value
									my $path_URL = &NL::String::str_HTTP_REQUEST_value($path_ENC_INTERNAL);
									my $url = $WC::c->{'APP_SETTINGS'}->{'file_name'};
									$url .= '?q_action=download';
									$url .= '&user_login='.$user_login_URL;
									$url .= '&user_password='.$user_password_URL;
									$url .= '&dir='.$dir_current_URL;
									$url .= '&file='.$path_URL;
									$result_HTML .= '<span class="t-blue">&nbsp;&nbsp;-&nbsp;Starting downloading of the file '.&WC::HTML::get_short_value($path_ENC_INTERNAL, { 'MAX_LENGTH' => 90 }).' - <a href="'.$url.'" class="a-brown" target="_blank">click to download</a></span>';
									$result_HTML .= '<iframe src="'.$url.'" class="iframe-download">Your browser does not support IFRAME, that is needed for downloading</iframe>';
									#$result_HTML .= '<div>'.$url.'</div>';
									$result_HTML .= '<br />';
								}
							}
						}
						my $is_GOOD_needed = 0;
						if ($num_total > 1) {
							$result = "<div class=\"t-lime\">STARTING DOWNLOADING FOR '$num_ok' OF '$num_total':</div>";
							if ($num_total > $num_ok) { $result .= "<div class=\"t-green\">&nbsp;&nbsp;Downloading can't be started for:</div>".'<div class="t-blue">'.$result_BAD.'</div>'; }
							if ($num_ok > 0) { $result .= "<div class=\"t-green\">&nbsp;&nbsp;Downloading started for:</div>\n"; $is_GOOD_needed = 1; }
						}
						else {
							if ($num_ok > 0) { $is_GOOD_needed = 1; }
							else { $result = "<div class=\"t-lime\">FILE(S) CAN'T BE DOWNLOADED:</div>".'<div class="t-blue">'.$result_BAD.'</div>'; }
						}
						# If all is OK
						if ($is_GOOD_needed) { $result .= '<div>'.$result_HTML.'</div>'; }
					}
				}
			}
			return $WC::Internal::DATA::HEADERS->{'text/html'}.$result;
		}
	},
	'get' => '$$#file|download$$',
};

# METHODS FOR INTERNAL COMMANDS
# file :: edit :: reading file content
sub edit_READ {
	my ($in_FILE, $in_SETTINGS) = @_;
	my $result = { 'ID' => 0, 'ERROR' => '' };
	if (!defined $in_FILE || $in_FILE eq '') { $result->{'ERROR'} = 'Incorrect call, file is not specified'; return $result; }
	$in_SETTINGS = {} if (!defined $in_SETTINGS);

	if (!-e $in_FILE) { $result->{'ERROR'} = 'File '.&WC::HTML::get_short_value($in_FILE).' does not exists'; }
	elsif (!-r $in_FILE) { $result->{'ERROR'} = 'File '.&WC::HTML::get_short_value($in_FILE).' is not readable by Web Console process'; }
	else {
		# Getting MAX file size
		my $max_edit_file_size = 1048576; # in bytes (1 MB = 1048576 bytes)
		$max_edit_file_size = $WC::CONST->{'INTERNAL'}->{'MAX_EDIT_FILE_SIZE'} if (defined $WC::CONST->{'INTERNAL'} && defined $WC::CONST->{'INTERNAL'}->{'MAX_EDIT_FILE_SIZE'});
		# Getting REAL file size
		my $file_size = &WC::File::get_size($in_FILE);
		# Checking size
		if ($file_size > $max_edit_file_size) { $result->{'ERROR'} = 'File '.&WC::HTML::get_short_value($in_FILE).' size is too big '."(file size is '".(&NL::String::get_str_of_bytes($file_size))."', maximum recommended size is '".(&NL::String::get_str_of_bytes($max_edit_file_size))."')"; }
		# OK locking file
		elsif( !&WC::File::lock_read($in_FILE, { 'timeout' => 10, 'time_sleep' => 0.1 }) ) { $result->{'ERROR'} = 'Unable to lock file '.&WC::HTML::get_short_value($in_FILE).' for reading'; }
		else {
			# OK, now file is locked
			if (!open(FH_EDIT_READ, '<'.$in_FILE)) { $result->{'ERROR'} = 'Unable to open file '.&WC::HTML::get_short_value($in_FILE).' for reading'.( ($! ne '') ? ': '.$! :  '' ); }
			else {
				# OK, reading
				$result->{'FILE_DATA'} = join('', <FH_EDIT_READ>);
				close (FH_EDIT_READ);
				&WC::File::unlock($in_FILE);
				&WC::Encode::encode_from_FILE_to_SYSTEM(\$result->{'FILE_DATA'});
				if (!-w $in_FILE) {
					$result->{'ID'} = 2;
					$result->{'ERROR'} = 'File '.&WC::HTML::get_short_value($in_FILE).' is not writable by Web Console process';
				}
				else { $result->{'ID'} = 1; }
			}
		}
	}
	return $result;
}
# file :: edit :: writing file content
sub edit_WRITE {
	my ($in_FILE, $in_TEXT, $in_SETTINGS) = @_;
	my $result = { 'ID' => 0, 'ERROR' => '' };
	if (!defined $in_FILE || $in_FILE eq '') { $result->{'ERROR'} = 'Incorrect call, file is not specified'; return $result; }
	if (!defined $in_TEXT) { $result->{'ERROR'} = 'Incorrect call, TEXT is not specified'; return $result; }
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'HARDSAVE'} = 0 if (!defined $in_SETTINGS->{'HARDSAVE'});

	if (!$in_SETTINGS->{'HARDSAVE'} && !-e $in_FILE) { $result->{'ERROR'} = 'File '.&WC::HTML::get_short_value($in_FILE).' does not exists'; }
	# elsif (!-r $in_FILE) { $result->{'ERROR'} = 'File '.&WC::HTML::get_short_value($in_FILE).' is not readable by Web Console process'; }
	elsif (!$in_SETTINGS->{'HARDSAVE'} && !-w $in_FILE) { $result->{'ERROR'} = 'File '.&WC::HTML::get_short_value($in_FILE).' is not writable by Web Console process'; }
	else {
		# OK, saving file using 'WC::File::save'
		&WC::Encode::encode_from_SYSTEM_to_FILE(\$in_TEXT);
		if( &WC::File::save($in_FILE, $in_TEXT, { 'BINMODE' => (defined $in_SETTINGS->{'USE_BINMODE'} && $in_SETTINGS->{'USE_BINMODE'}) ? 1 : 0 }) != 1 ) {
			$result->{'ERROR'} = &WC::File::get_last_error_TEXT();
			my $additional_info = &WC::File::get_last_error_INFO();
			$result->{'ERROR'} .= ': '.$additional_info if ($additional_info ne '');
		}
		else {
			# OK, now file is saved
			$result->{'ID'} = 1;
		}
	}
	return $result;
}
# file :: edit :: getting edit form element
sub edit_FORM {
	my ($in_FILE, $in_SETTINGS) = @_;
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'DIV_HIDDEN'} = 0 if (!defined $in_SETTINGS->{'DIV_HIDDEN'});

	my $result = { 'ID' => 0, 'HTML' => '', 'HTML_JS_VALUE' => '', 'JS' => '', 'DIV_ID' => '' };
	if (!defined $in_FILE || $in_FILE eq '') {
		$result->{'HTML'} = '<div class="t-blue">&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;Incorrect call of FORM creation, file is not specified';
		return $result;
	}

	my $path_encoded = $in_FILE;
	&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$path_encoded);
	if (!-e $in_FILE) {
		$result->{'HTML'} = '<div class="t-blue">&nbsp;&nbsp;-&nbsp;No file '.&WC::HTML::get_short_value($path_encoded).' found</div>';
		return $result;
	}
	elsif (-d $in_FILE) {
		$result->{'HTML'} = '<div class="t-blue">&nbsp;&nbsp;-&nbsp;Directory '.&WC::HTML::get_short_value($path_encoded).' can\'t be edited, please specify a file</div>';
		return $result;
	}

	# Form creation
	my $hash_READ = &edit_READ($in_FILE);
	if ($hash_READ->{'ID'} <= 0) {
		&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$hash_READ->{'ERROR'});
		$result->{'HTML'} = '<div class="t-blue">&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;'.$hash_READ->{'ERROR'};
	}
	else {
		my $ID = &WC::Internal::get_unique_id();
		$in_SETTINGS->{'ID'} = $ID if (!defined $in_SETTINGS->{'ID'});
		# Converting file DATA to JS HTML value
		&NL::String::str_HTML_value(\$hash_READ->{'FILE_DATA'});
		&NL::String::str_JS_value(\$hash_READ->{'FILE_DATA'});
		# Preparing messages to OUTPUT, at JS HTML value format
		my $HTML_message_FILE_NAME_SHORT = &NL::String::str_JS_value(&WC::HTML::get_short_value($in_FILE));
		my $HTML_message_FILE_NAME_VALUE = &NL::String::str_JS_value(&NL::String::str_HTML_value($in_FILE));
		&WC::Dir::update_current_dir();
		my $HTML_message_DIR = &NL::String::str_JS_value(&NL::String::str_HTML_value( &WC::Dir::get_current_dir() ));
		my $HTML_message_READONLY = ($hash_READ->{'ID'} == 2) ? " <span class=\"s-warning\">(FILE IS READONLY - IT CAN\\'T BE SAVED)</span>" : '';

		# Encoding information
		my $str_ENCODING = '';
		my $file_ENCODING = &WC::Encode::get_encoding('editor_text');
		if ($file_ENCODING ne '') {
			if ($WC::Encode::ENCODE_ON) {
				$file_ENCODING = &NL::String::get_right($file_ENCODING, 20, 1);
				$str_ENCODING = "WC.Console.HTML.add_time_message('_wc_file_edit_SPAN-FILE-MESSAGE-$ID', '  [opened with encoding: $file_ENCODING]', { 'TIME': 10 })";
			}
			else {
				$str_ENCODING = "WC.Console.HTML.add_time_message('_wc_file_edit_STATUS-MESSAGE-$ID', '[ENCODINGS CONVERSION DISABLED, CHECK &quot;<a class=\"t-cmd\" href=\"#\" onclick=\"WC.Console.Prompt.value_set(\\'#settings\\'); return false\" title=\"Click to paste at command input\">#settings</a>&quot;]', { 'TIME': 30, 'IS_HTML': 1 })";
			}

		}

		# Don't escaping "'" - that is will be used to set width and height from JS
		my $HTML_message_TEXTAREA = '<textarea wrap="off" style="width: \'+t_w+\'px; height: \'+t_h+\'px" id="_wc_file_edit_DATA-'.$ID.'" name="wc_file_edit_DATA-'.$ID.'">'."\n".$hash_READ->{'FILE_DATA'}.'</textarea>';
		# Preparing MAIN OUTPUT message
		my $HTML_message_MAIN = ''.
		'<div id="wc-file-edit-DIV-CONTAINER-'.$ID.'"'.( ($in_SETTINGS->{'DIV_HIDDEN'}) ? ' style="display: none"' : '' ).'>'.
		'<form id="wc-file-edit-form-'.$ID.'" action="" onsubmit="return false" target="_blank">'.
		'<input type="hidden" id="_wc-file-edit-FILENAME-'.$ID.'" name="wc-file-edit-FILENAME-'.$ID.'" value="'.$HTML_message_FILE_NAME_VALUE.'" />'.
		'<input type="hidden" id="_wc-file-edit-DIR-'.$ID.'" name="wc-file-edit-DIR-'.$ID.'" value="'.$HTML_message_DIR.'" />'.
		'<table class="grid" style="width: 100%">'.
			'	<tr><td>'.
			'		<table class="grid" style="width: 100%"><tr>'.
			'			<td class="area-info-left">Edit/view file '.$HTML_message_FILE_NAME_SHORT.$HTML_message_READONLY.':<span class="span-file-message" id="_wc_file_edit_SPAN-FILE-MESSAGE-'.$ID.'">&nbsp;</span></td>'.
			'			<td class="area-info-right"><span class="span-message" id="_wc_file_edit_STATUS-MESSAGE-'.$ID.'">&nbsp;</span>&nbsp;&nbsp;Status: <span id="_wc_file_edit_STATUS-'.$ID.'">Idle</span></td>'.
			'		</tr></table>'.
			'	</td></tr>'.
			'<tr><td class="area-main">'.$HTML_message_TEXTAREA.'</td></tr>'.
			'<tr><td>'.
				'<table class="grid"><tr>'.
					'<td class="area-button-left"><div id="wc-file-edit-button-CLOSE-'.$ID.'" class="div-button w-100" title="Close file(s) without saving">Close</div></td>'.
					'<td class="area-button-right"><div id="wc-file-edit-button-RELOAD-'.$ID.'" class="div-button w-100" title="Reload file content">Reload</div></td>';
		if ($hash_READ->{'ID'} == 1) {
			$HTML_message_MAIN .= ''.
					'<td class="area-button-right"><div class="div-buttons-splitter">|</div></td>'.
					'<td class="area-button-right"><div id="wc-file-edit-button-SAVE-'.$ID.'" class="div-button w-100" title="Save file without closing">Save</div></td>'.
					'<td class="area-button-right"><div id="wc-file-edit-button-SAVE_CLOSE-'.$ID.'" class="div-button w-120" title="Save file and close">Save and close</div></td>';
		}
		if ($hash_READ->{'ID'} == 1) {
			$HTML_message_MAIN .= ''.
					'<td class="area-button-right"><div class="div-buttons-splitter">|</div></td>'.
					'<td class="area-button-right" style="padding-left: 0"><input class="in-checkbox" style="margin-left: 9px" type="checkbox" id="_wc-file-edit-BINMODE-'.$ID.'" name="wc-file-edit-BINMODE-'.$ID.'" value="1" /> <label class="s-message" \'+font_style_small+\'title="By default file will be saved at TEXT mode" style="cursor: help" for="_wc-file-edit-BINMODE-'.$ID.'">Save at BINARY mode</label></td>'.
					'<td class="area-button-right"><div class="div-buttons-splitter">|</div></td>'.
					'<td class="area-button-right" style="padding-left: 0"><input class="in-checkbox" style="margin-left: 9px" type="checkbox" id="_wc-file-edit-HARDSAVE-'.$ID.'" name="wc-file-edit-HARDSAVE-'.$ID.'" value="1" /> <label class="s-message" \'+font_style_small+\'title="By default file will not be saved if it is does not exists" style="cursor: help" for="_wc-file-edit-HARDSAVE-'.$ID.'">Save, if file does not exists</label></td>';
		}
		$HTML_message_MAIN .= ''.
				'</tr></table>'.
				'<table class="grid"><tr>'.
				'	<td class="area-button-left" style="padding-top: 4px"><div id="wc-file-edit-button-RMBELOW-'.$ID.'" class="div-button w-270">Remove all messages below this box</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-edit-button-DOWNLOAD-'.$ID.'" class="div-button w-90" title="Download file(s)">Download</div></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div class="div-buttons-splitter">|</div></td>'.
				'	<td class="area-button-right s-message" style="padding-top: 3px">CHMOD:</td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><input class="in-text" style="border: 1px solid #6a7070; width: 50px" type="text" id="_wc_file_edit_CHMOD-'.$ID.'" name="wc_file_edit_CHMOD-'.$ID.'" value="755"  onfocus="WC.Console.Hooks.GRAB_OFF(this)" onblur="WC.Console.Hooks.GRAB_ON(this)" /></td>'.
				'	<td class="area-button-right" style="padding-top: 4px"><div id="wc-file-edit-button-CHMOD-'.$ID.'" class="div-button w-90" title="CHMOD file(s)/directory(s)">CHMOD</div></td>'.
				'</tr></table>'.
			'</td></tr>'.
		'</table></form></div>';
		# Converting MAIN HTML to JS value (don't escaping "'" - that is will be used to set width and height from JS)
		$HTML_message_MAIN =~ s/\n/\\n/g;
		$HTML_message_MAIN =~ s/\r/\\r/g;
		$result->{'HTML_JS_VALUE'} = $HTML_message_MAIN;
		# And generating result
		$result->{'DIV_ID'} = 'wc-file-edit-DIV-CONTAINER-'.$ID;
		$result->{'JS'} = <<HTML_EOF;
<script type="text/JavaScript"><!--
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-CLOSE-$ID', function () { WC.Console.HTML.OUTPUT_remove_result('wc-file-edit-CONTAINER-${$in_SETTINGS}{'ID'}'); });
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-RMBELOW-$ID', function () { WC.Console.HTML.OUTPUT_remove_below('wc-file-edit-DIV-CONTAINER-${ID}'); });
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-RELOAD-$ID', function () {
		var obj_DATA = xGetElementById('_wc_file_edit_DATA-${ID}');
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		if (obj_DATA && obj_FILENAME && obj_FILENAME.value && obj_DIR) {
			var HTML_name_short = NL.String.toHTML( NL.String.get_str_right_dottes(obj_FILENAME.value, 30) );
			WC.Console.HTML.set_INNER('_wc_file_edit_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_edit_STATUS-${ID}', 'Reloading', 1);
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("RELOADING FILE '"+HTML_name_short+"'", '#file _edit_reload', {
				'js_ID': '${ID}', 'js_id_DATA': '_wc_file_edit_DATA-${ID}', 'file_name': obj_FILENAME.value, 'dir': obj_DIR.value
			}, [], { 'type': 'hidden', 'id_TIMER': id_timer });
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
HTML_EOF
		if ($hash_READ->{'ID'} == 1) {
			$result->{'JS'} .= <<HTML_EOF;
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-SAVE-$ID', function () {
		var obj_DATA = xGetElementById('_wc_file_edit_DATA-${ID}');
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		if (obj_DATA && obj_FILENAME && obj_FILENAME.value && obj_DIR) {
			var HTML_name_short = NL.String.toHTML( NL.String.get_str_right_dottes(obj_FILENAME.value, 30) );
			var use_binmode = 0;
			var obj_BINMODE = xGetElementById('_wc-file-edit-BINMODE-${ID}');
			if (obj_BINMODE && obj_BINMODE.checked) use_binmode = 1;
			var enable_hardsave = 0;
			var obj_HARDSAVE = xGetElementById('_wc-file-edit-HARDSAVE-${ID}');
			if (obj_HARDSAVE && obj_HARDSAVE.checked) enable_hardsave = 1;
			WC.Console.HTML.set_INNER('_wc_file_edit_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_edit_STATUS-${ID}', 'Saving', 1);
			NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': id_timer});
			// OK, executing command
			WC.Console.AJAX.query({}, {
					'q_action': 'AJAX_FILE_SAVE',
					'js_ID': '${ID}',
					'use_binmode': use_binmode,
					'enable_hardsave': enable_hardsave,
					'file_name': obj_FILENAME.value,
					'file_data': obj_DATA.value,
					'dir': obj_DIR.value
				},
				function (in_JS_DATA, in_STASH) {
					if (in_JS_DATA && in_JS_DATA['STASH'] && in_JS_DATA['STASH']['JS_CODE']) eval(in_JS_DATA['STASH']['JS_CODE']);
				},
				{});
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-SAVE_CLOSE-$ID', function () {
		var obj_DATA = xGetElementById('_wc_file_edit_DATA-${ID}');
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		if (obj_DATA && obj_FILENAME && obj_FILENAME.value && obj_DIR) {
			var HTML_name_short = NL.String.toHTML( NL.String.get_str_right_dottes(obj_FILENAME.value, 30) );
			var use_binmode = 0;
			var obj_BINMODE = xGetElementById('_wc-file-edit-BINMODE-${ID}');
			if (obj_BINMODE && obj_BINMODE.checked) use_binmode = 1;
			var enable_hardsave = 0;
			var obj_HARDSAVE = xGetElementById('_wc-file-edit-HARDSAVE-${ID}');
			if (obj_HARDSAVE && obj_HARDSAVE.checked) enable_hardsave = 1;
			WC.Console.HTML.set_INNER('_wc_file_edit_STATUS-MESSAGE-${ID}', '');
			var id_timer = WC.UI.Filemanager.status_change('_wc_file_edit_STATUS-${ID}', 'Saving and closing', 1);
			NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': id_timer});
			// OK, executing command
			WC.Console.AJAX.query({}, {
					'q_action': 'AJAX_FILE_SAVE_CLOSE',
					'js_ID': '${ID}',
					'use_binmode': use_binmode,
					'enable_hardsave': enable_hardsave,
					'file_name': obj_FILENAME.value,
					'file_data': obj_DATA.value,
					'dir': obj_DIR.value
				},
				function (in_JS_DATA, in_STASH) {
					if (in_JS_DATA && in_JS_DATA['STASH'] && in_JS_DATA['STASH']['JS_CODE']) eval(in_JS_DATA['STASH']['JS_CODE']);
				},
				{});
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
HTML_EOF
		}
		$result->{'JS'} .= <<HTML_EOF;
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-CHMOD-$ID', function () {
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		var obj_CHMOD = xGetElementById('_wc_file_edit_CHMOD-${ID}');
		if (obj_FILENAME && obj_DIR && obj_CHMOD) {
			if (!obj_CHMOD.value) alert("There is no CHMOD value entered.\\nPlease enter something (755, 777, ...).");
			else {
				// OK, executing command
				WC.Console.Exec.CMD_INTERNAL("CHMOD'ing FILE", '#file chmod '+obj_CHMOD.value, { '-dir': obj_DIR.value }, [obj_FILENAME.value]);
			}
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
	xAddEventListener('_wc_file_edit_CHMOD-${ID}', 'keypress',  function (event) {
		if ((event.keyCode && event.keyCode==13) || (event.which && event.which==13)) {
			var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
			var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
			var obj_CHMOD = xGetElementById('_wc_file_edit_CHMOD-${ID}');
			if (obj_FILENAME && obj_DIR && obj_CHMOD) {
				if (!obj_CHMOD.value) alert("There is no CHMOD value entered.\\nPlease enter something (755, 777, ...).");
				else {
					// OK, executing command
					WC.Console.Exec.CMD_INTERNAL("CHMOD'ing FILE", '#file chmod '+obj_CHMOD.value, { '-dir': obj_DIR.value }, [obj_FILENAME.value]);
				}
			}
			else alert("Unable to find EDITOR objects (internal error)");
			return false;
		}
		return true;
	});
	NL.UI.div_button_register('div-button', 'wc-file-edit-button-DOWNLOAD-$ID', function () {
		var obj_FILENAME = xGetElementById('_wc-file-edit-FILENAME-${ID}');
		var obj_DIR = xGetElementById('_wc-file-edit-DIR-${ID}');
		if (obj_FILENAME && obj_DIR) {
			// OK, executing command
			WC.Console.Exec.CMD_INTERNAL("DOWNLOADING FILE", '#file download', { '-dir': obj_DIR.value }, [obj_FILENAME.value]);
		}
		else alert("Unable to find EDITOR objects (internal error)");
	});
	$str_ENCODING
HTML_EOF
		$result->{'JS'} .= "\n".'//--></script>'."\n";
		$result->{'ID'} = 1;
	}
	return $result;
}
# file :: manager :: getting listing of the directory
sub manager_DIR_listing {
	my ($in_DIR, $in_SETTINGS) = @_;
	my $result = { 'ID' => 0, 'TOTAL' => 0, 'ERROR' => '' };
	if (!defined $in_DIR || $in_DIR eq '') { $result->{'ERROR'} = 'Incorrect call, directory is not specified'; return $result; }
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'NO_BACK'} = 0 if (!defined $in_SETTINGS->{'NO_BACK'});

	# Getting directories splitter
	my $dir_SPLITTER = &WC::Dir::get_dir_splitter();
	if (!-d $in_DIR) { $result->{'ERROR'} = 'No directory '.( &WC::HTML::get_short_value($in_DIR) ).' found'; }
	else {
		# my $re_SKIP = ($in_SETTINGS->{'NO_BACK'}) ? qr/^\.{1,2}$/ : qr/^\.{1}$/;
		my $re_SKIP = qr/^\.{1,2}$/;
		# Getting listing
		if (opendir(DIR, $in_DIR)) {
			my @arr_listing_DIRS;
			my @arr_listing_FILES;
			my @arr_listing = grep(!/$re_SKIP/, readdir (DIR));
			closedir (DIR);
			foreach (@arr_listing) {
				if (-d $in_DIR.$dir_SPLITTER.$_) { push @arr_listing_DIRS, $_.$dir_SPLITTER; }
				else { push @arr_listing_FILES, $_; }
			};
			$result->{'ARR_LIST'} = [
				(map { { 'path' => $_, 'type' => 'dir' } } sort @arr_listing_DIRS),
				(map { { 'path' => $_, 'type' => 'file' } } sort @arr_listing_FILES)
			];
			$result->{'TOTAL'} = scalar @{ $result->{'ARR_LIST'} };
			if (!$in_SETTINGS->{'NO_BACK'}) { unshift @{ $result->{'ARR_LIST'} }, { 'path' => '..'.$dir_SPLITTER, 'type' => 'back' }; }
			$result->{'ID'} = 1;
		}
		else { $result->{'ERROR'} = 'Unable to get directory '.&WC::HTML::get_short_value($in_DIR).' listing'.( ($! ne '') ? ': '.$! :  '' ); }
	}
	# If defined 'MAKE_HTML_AS_JS_STRING' - making HTML as JS string
	if ($result->{'ID'} && defined $in_SETTINGS->{'MAKE_HTML_AS_JS_STRING'} && $in_SETTINGS->{'MAKE_HTML_AS_JS_STRING'}) {
		# Making HTML as JS string
		my $total = scalar @{ $result->{'ARR_LIST'} };
		my $js_ID = (defined $in_SETTINGS->{'JS_ID'}) ? $in_SETTINGS->{'JS_ID'} : '';
		$result->{'HTML'} = '';
		my $i = 0;
		my $MAX_AT_COLUMN = 20;
		foreach (@{ $result->{'ARR_LIST'} }) {
			my $class = $_->{'type'};
			my $value = &NL::String::str_HTML_value($_->{'path'});
			$value =~ s/ /&nbsp;/g;
			$result->{'HTML'} .= '</td><td class="wc-ui-fm-block">' if ($i % $MAX_AT_COLUMN == 0 && $i+1 < $total && $result->{'HTML'} ne '');
			$result->{'HTML'} .= '<div class="'.$class.'" onclick="WC.UI.Filemanager.activate(this, { \'id_files_selected\': \'_wc_file_manager_SELECTED-'.$js_ID.'\' }); return false;" ondblclick="WC.UI.Filemanager.double_click(this, \''.$js_ID.'\', \''.$class.'\'); return false;">'.$value.'</div>';
			$i++;
		}
		if ($i > ($in_SETTINGS->{'NO_BACK'} ? 0 : 1)) {
			# Adding empty strings
			if ($i < $MAX_AT_COLUMN) {
				my $j = $i;
				while ($j < $MAX_AT_COLUMN) { $result->{'HTML'} .= '<div class="free">&nbsp;</div>'; $j++; }
			}
		}
		else {
			$result->{'HTML'} .= '<div class="free empty">[directory is empty]</div>';
			$i++;
			# Adding empty strings
			while ($i < $MAX_AT_COLUMN) { $result->{'HTML'} .= '<div class="free">&nbsp;</div>'; $i++; }
		}
		$result->{'HTML'} = &NL::String::str_JS_value('<table class="grid" id="_wc_file_manager_FILES-LIST-'.$js_ID.'"><tr><td class="wc-ui-fm-block">'.$result->{'HTML'}.'</td></tr></table>');
	}
	return $result;
};
# file :: manager :: removing directory with all it content
sub manager_DIR_remove {
	my ($in_DIR) = @_;
	my $result = { 'ID' => 0, 'ERROR' => '' };
	if (!defined $in_DIR || $in_DIR eq '') { $result->{'ERROR'} = 'Incorrect call, directory is not specified'; return $result; }

	my $hash_DIR = &manager_DIR_listing($in_DIR, { 'NO_BACK' => 1 });
	if (!$hash_DIR->{'ID'}) { $result->{'ERROR'} = $hash_DIR->{'ERROR'}; return $result; }
	else {
		my $dir_SPLITTER = &WC::Dir::get_dir_splitter();
		my $dir_S = $in_DIR;
		$dir_S .= $dir_SPLITTER if ($dir_S !~ /$dir_SPLITTER$/);
		foreach (@{ $hash_DIR->{'ARR_LIST'} }) {
			my $rm_path = $dir_S.$_->{'path'};
			if (-d $rm_path) {
				my $hash_RM = &manager_DIR_remove($rm_path);
				if (!$hash_RM->{'ID'}) { $result->{'ERROR'} = $hash_RM->{'ERROR'}; return $result; }
			}
			else {
				if ((unlink $rm_path) <= 0) { $result->{'ERROR'} = 'Unable to remove file '.&WC::HTML::get_short_value($rm_path).( ($! ne '') ? ': '.$! :  '' ); return $result; }
			}
		}
		# If we are here - all was removed
		if (!rmdir $in_DIR) { $result->{'ERROR'} = 'Unable to remove directory '.&WC::HTML::get_short_value($in_DIR).( ($! ne '') ? ': '.$! :  '' ); return $result; }
		else { $result->{'ID'} = 1; return $result; }
	}
}
# file :: manager :: changing directory
sub manager_DIR_change {
	my ($in_DIR, $in_SETTING) = @_;
	$in_SETTING = {} if (!defined $in_SETTING);
	$in_SETTING->{'GO_PATH'} = '' if (!defined $in_SETTING->{'GO_PATH'});
	$in_SETTING->{'hash_PARAMS'} = {} if (!defined $in_SETTING->{'hash_PARAMS'});
	$in_SETTING->{'UPDATE_PATH'} = 0 if (!defined $in_SETTING->{'UPDATE_PATH'});
	#$in_SETTING->{'GO_UP'} = 0 if (!defined $in_SETTING->{'GO_UP'});

	my $is_OK = 0;
	my $result = '';
	my $message = '';
	if (!defined $in_DIR || $in_DIR eq '') { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '  - Incorrect call, directory is not specified') ); }
	else {
		my $dir = &WC::Dir::check_in($in_DIR);
		my $dir_path = &WC::Dir::check_in($in_SETTING->{'GO_PATH'});
		if ($dir eq '') { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '  - Incorrect call, directory is not specified') ); }
		elsif (!-d $dir) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '&nbsp;&nbsp;-&nbsp;No directory '.( &WC::HTML::get_short_value($dir) ).' found', { 'ENCODE_TO_HTML' => 0 }) ); }
		elsif (!&WC::Dir::change_dir($dir)) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '&nbsp;&nbsp;-&nbsp;Unable change directory to '.( &WC::HTML::get_short_value($dir) ).( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }) ); }
		elsif ($dir_path ne '' && !-d $dir_path) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '&nbsp;&nbsp;-&nbsp;No directory '.( &WC::HTML::get_short_value($dir_path) ).' found', { 'ENCODE_TO_HTML' => 0 }) ); }
		elsif ($dir_path ne '' && !&WC::Dir::change_dir($dir_path)) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '&nbsp;&nbsp;-&nbsp;Unable change directory to '.( &WC::HTML::get_short_value($dir_path) ).( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }) ); }
		# elsif ($in_SETTING->{'GO_UP'} && !&WC::Dir::change_dir('..')) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '  - Unable change directory to UPPER') ); }
		else {
			# Getting current directory
			&WC::Dir::update_current_dir();
			$dir = &WC::Dir::get_current_dir();
			my $dir_JS = &NL::String::str_JS_value($dir);
			# Getting list of directory at HTML format prepared to be JS string
			my $hash_LIST = &manager_DIR_listing($dir, { 'JS_ID' => $in_SETTING->{'hash_PARAMS'}->{'js_ID'}, 'MAKE_HTML_AS_JS_STRING' => 1 } );
			if ($hash_LIST->{'ID'}) {
				$is_OK = 1;
				$result = ''.
				'<script type="text/JavaScript"><!--'."\n".
				'	var obj_PATH = xGetElementById(\'_wc-file-manager-PATH-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.
				'	var obj_PATH_IN = xGetElementById(\'_wc_file_manager_PATH_IN-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.
				'	var obj_TOTAL = xGetElementById(\'_wc_file_manager_TOTAL-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.
				'	var obj_SELECTED = xGetElementById(\'_wc_file_manager_SELECTED-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.
				'	var obj_FILES = xGetElementById(\'_wc_file_manager_FILES-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.
				'	if (obj_PATH && obj_PATH_IN && obj_TOTAL && obj_SELECTED && obj_FILES) {'.
				'		obj_PATH.value = \''.$dir_JS.'\';'.
				'		obj_TOTAL.innerHTML = '.$hash_LIST->{'TOTAL'}.';'.
				'		obj_SELECTED.innerHTML = 0;'.
				'		obj_FILES.innerHTML = \''.$hash_LIST->{'HTML'}.'\';'.
				'		WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.
				'		WC.Console.HTML.add_time_message(\'_wc_file_manager_STATUS-MESSAGE-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\', \'[DIRECTORY HAS BEEN CHANGED SUCCESSFULLY]\', { \'TIME\': 5 });'.
				( ($in_SETTING->{'UPDATE_PATH'}) ? 'obj_PATH_IN.value = \''.$dir_JS.'\';' : '' ).
				( (defined $in_SETTING->{'hash_PARAMS'}->{'synchronize_global_path'} && $in_SETTING->{'hash_PARAMS'}->{'synchronize_global_path'}) ? 'WC.Console.State.change_dir(\''.$dir_JS.'\');' : '' ).
				'		WC.UI.Filemanager.make_unselectable(\'_wc_file_manager_FILES-LIST-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.
				'	}'.
				'	else alert("Unable to find File Manager objects (internal error)");'."\n".
				'//--></script>';
			}
			else { $message = &NL::String::str_JS_value( &WC::HTML::get_message("DIRECTORY CAN'T BE CHANGED", '&nbsp;&nbsp;-&nbsp;'.$hash_LIST->{'ERROR'}, { 'ENCODE_TO_HTML' => 0 }) ); }
		}
	}
	# If it's not OK
	if (!$is_OK) {
		$result = ''.
		'<script type="text/JavaScript"><!--'."\n".
		'	WC.UI.Filemanager.status_change(\'_wc_file_manager_STATUS-'.$in_SETTING->{'hash_PARAMS'}->{'js_ID'}.'\');'.
		'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> CHANGING DIRECTORY</span>\', \''.$message.'\');'."\n".
		'//--></script>';
	}
	return $result;
}

# FILE :: SAVE
sub AJAX_save {
	my ($in_PARAMS, $in_IS_CLOSE_AFTER_SAVING) = @_;
	$in_PARAMS = {} if (!defined $in_PARAMS);
	$in_IS_CLOSE_AFTER_SAVING = 0  if (!defined $in_IS_CLOSE_AFTER_SAVING);

	my $hash_PARAMS = $in_PARAMS;
	# Checking PARAMETERS
	my $check_RESULT = &NL::Parameter::check($hash_PARAMS, {
		'file_data' => { 'name' => 'File DATA', 'needed' => 1, 'can_be_empty' => 1 },
		'file_name' => { 'name' => 'Filename', 'needed' => 1 },
		'dir' => { 'name' => 'Directory path', 'needed' => 1, 'can_be_empty' => 1 },
		'use_binmode' => { 'name' => 'Use BINARY mode', 'needed' => 0 },
		'js_ID' => { 'name' => 'Element ID', 'needed' => 1 },
		'enable_hardsave' => { 'name' => 'Enable save, if file does not exists', 'needed' => 0 }
	});

	my $result = '';
	if (!$check_RESULT->{'ID'}) {
		my $error = &NL::String::str_JS_value( &WC::HTML::get_message("FILE CAN'T BE SAVED", '  - '.$check_RESULT->{'ERROR_MESSAGE'}) );
		my $file = (defined $hash_PARAMS->{'file_name'} && $hash_PARAMS->{'file_name'} ne '') ? &NL::String::str_JS_value( &WC::HTML::get_short_value($hash_PARAMS->{'file_name'}) ) : &NL::String::str_JS_value( &WC::HTML::get_short_value('_UNKNOWN_') );
		$result = ''.
		( (defined $hash_PARAMS->{'js_ID'} && $hash_PARAMS->{'js_ID'} ne '') ? ' WC.UI.Filemanager.status_change(\'_wc_file_edit_STATUS-'.$hash_PARAMS->{'js_ID'}.'\');' : '').
		'	WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> SAVING FILE '.$file.'</span>\', \''.$error.'\');'."\n";
	}
	else {
		my $is_OK = 0;
		my $message = '';
		my $dir = &WC::Dir::check_in($hash_PARAMS->{'dir'});
		if ($dir ne '' && !&WC::Dir::change_dir($dir)) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("FILE CAN'T BE SAVED", '  - Incorrect TARGET DIRECTORY specified') ); }
		else {
			my $hash_SAVE = &edit_WRITE($hash_PARAMS->{'file_name'}, $hash_PARAMS->{'file_data'}, {
				'USE_BINMODE' => (defined $hash_PARAMS->{'use_binmode'} && $hash_PARAMS->{'use_binmode'}) ? 1 : 0,
				'HARDSAVE' => (defined $hash_PARAMS->{'enable_hardsave'} && $hash_PARAMS->{'enable_hardsave'}) ? 1 : 0
			});
			if (!$hash_SAVE->{'ID'}) { $message = &NL::String::str_JS_value( &WC::HTML::get_message("FILE CAN'T BE SAVED", '&nbsp;&nbsp;- '.$hash_SAVE->{'ERROR'}, { 'ENCODE_TO_HTML' => 0 }) ); }
			else {
				$is_OK = 1;
				my $text_at_binmode = (defined $hash_PARAMS->{'use_binmode'} && $hash_PARAMS->{'use_binmode'}) ? ' (AT BINMODE)' : '';
				$message = &NL::String::str_JS_value("FILE HAS BEEN SUCCESSFULLY SAVED".$text_at_binmode);
			}
		}
		my $file = &NL::String::str_JS_value( &WC::HTML::get_short_value($hash_PARAMS->{'file_name'}) );
		$result = 'WC.UI.Filemanager.status_change(\'_wc_file_edit_STATUS-'.$hash_PARAMS->{'js_ID'}.'\'); ';
		if ($is_OK) {
			$result .= 'WC.Console.HTML.add_time_message(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\', \'['.$message.']\', { \'TIME\': 5 }); ';
			if ($in_IS_CLOSE_AFTER_SAVING) {
				$result .= 'WC.Console.HTML.OUTPUT_remove_result(\'wc-file-edit-DIV-CONTAINER-'.$hash_PARAMS->{'js_ID'}.'\');';
				$message = &NL::String::str_JS_value( &WC::HTML::get_message("FILE HAS BEEN SUCCESSFULLY SAVED", '  - File has been successfully saved, edit window has been closed') );
				$result .= 'WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> SAVING FILE '.$file.'</span>\', \''.$message.'\');';
			}
		}
		else {
			$result .= 'var obj = xGetElementById(\'_wc_file_edit_STATUS-MESSAGE-'.$hash_PARAMS->{'js_ID'}.'\'); if (obj) obj.innerHTML = \'\'; ';
			$result .= 'WC.Console.HTML.add_cmd_message(\'<span class="t-brown"><span class="t-blue">***</span> SAVING FILE '.$file.'</span>\', \''.$message.'\');';
		}
	}

	&WC::AJAX::show_response('', 'AJAX_FILE_SAVE', {}, { 'JS_CODE' => $result });
	return 1;
}

1; #EOF
