#!/usr/bin/perl
# WC::Internal::DATA - Web Console 'Internal' DATA module
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::Internal::DATA;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Internal::DATA::MESSAGES = {
	'_' => ' ',
	'__' => '  ',
	'___' => '   ',
	'n_' => '&nbsp;',
	'n__' => '&nbsp;&nbsp;',
	'n___' => '&nbsp;&nbsp;&nbsp;',
	'_AND_PRESS_ENTER' => ' and press "ENTER"',
	'PRESS_ENTER_TO_' => 'Press "ENTER" to ',
	'PRESS_TAB_OR_ENTER_TO_' => 'Press "TAB" or "ENTER" to ',
	'PLEASE_TYPE_FILENAME' => 'Please type <file name>',
	'PLEASE_TYPE_FILENAMES' => 'Please type <file name(s)>',
	'TAB_TO_EASY_' => 'You can use "TAB" key to easy ',
	'TAB_FOR_FILENAME' => 'You can use "TAB" key to easy file name or path choosing'
};
$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAME_PRESS_ENTER'} = $WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAME'}.$WC::Internal::DATA::MESSAGES->{'_AND_PRESS_ENTER'};
$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAMES_PRESS_ENTER'} = $WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAMES'}.$WC::Internal::DATA::MESSAGES->{'_AND_PRESS_ENTER'};
$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAME_PRESS_ENTER_USE_TAB'} = $WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAME_PRESS_ENTER'}."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'};
$WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAMES_PRESS_ENTER_USE_TAB'} = $WC::Internal::DATA::MESSAGES->{'PLEASE_TYPE_FILENAMES_PRESS_ENTER'}."\n".$WC::Internal::DATA::MESSAGES->{'TAB_FOR_FILENAME'};

$WC::Internal::DATA::HEADERS = {
	'text/html' => $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n"
	#'text/html' => "Web-Console: Content-type: text/html; charset=utf-8\r\n\r\n"
};


$WC::Internal::DATA::AC_RESULT = { 'ID' => 1, 'TITLE' => '', 'INFO' => '', 'SUBTITLE' => '', 'TEXT' => '', 'values' => [], 'cmd_add' => '', 'cmd_left_update' => '' };
$WC::Internal::DATA::ALL = {
	'__doc__' => 'Web Console internal commands',
	'__info__' => "Type: #[<command>|<command part>] [<sub-command>|<sub-command part>]? [<parameters>]?\n".
		      'Press "TAB" key to commands autocompletion and to see help message about commands.'."\n".
		      'Type "?" after the command and press "TAB" key to see help message about command.'."\n".
		      'Examples:'."\n".
		      $WC::Internal::DATA::MESSAGES->{'__'}.'- Starting Web Console File Manger: #file manager<ENTER>'."\n".
		      $WC::Internal::DATA::MESSAGES->{'__'}.'- Editing file(s): #edit <file name(s)><ENTER> (choose file name(s) using "TAB")'."\n".
		      $WC::Internal::DATA::MESSAGES->{'__'}.'- Downloading file(s): #download <file name(s)><ENTER> (choose file name(s) using "TAB")'."\n".
		      $WC::Internal::DATA::MESSAGES->{'__'}.'- Uploading file(s): #upload<ENTER>'."\n".
		      $WC::Internal::DATA::MESSAGES->{'__'}.'- View/Edit Web Console settings: #settings<ENTER>'."\n".
		      $WC::Internal::DATA::MESSAGES->{'__'}.'- Manage Web Console users: #users<TAB>'."\n",
	'#about' => {
		'__doc__' => 'About Web Console',
		'__info__' => 'Information about Web Console.',
		'authors' => {
			'__doc__' => 'Web Console authors',
			'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console authors information.',
			'__func__' => sub {
				my $result = '<span class="t-lime">Web Console authors:</span><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Founder and developer:</span> <span class="t-author">Nickolay Kovalev</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- E-mail:</span> <a class="a-brown" href="mailto:Nickolay.Kovalev@nickola.ru">Nickolay.Kovalev@nickola.ru</a><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Resume:</span> <a class="a-brown" href="http://resume.nickola.ru" target="_blank">http://resume.nickola.ru</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Co-Founder:</span> <span class="t-author">Max Kovalev</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- E-mail:</span> <a class="a-brown" href="mailto:Max.Kovalev@maxkovalev.com">Max.Kovalev@maxkovalev.com</a><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Resume:</span> <a class="a-brown" href="http://resume.maxkovalev.com" target="_blank">http://resume.maxkovalev.com</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Your name here?</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- If you would like to develop Web Console, please visit<br/>'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 3).'to <a class="a-brown" href="http://forum.web-console.org/go/NEW_DEVELOPER" title="Visit Web Console DEVELOPMENT FORUM" target="_blank">Web Console DEVELOPMENT FORUM</a> for more information.</span>';
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
			},
			'__func_auto__' => sub {
				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#about'}->{'authors'}->{'__func__'}->();
				return $result;
			}
		},
		'version' => {
			'__doc__' => 'Web Console version',
			'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console version information.',
			'__func__' => sub {
				my $result = '<span class="t-lime">Web Console version information:</span><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console version: <span class="t-red-dark">\''.$WC::CONST->{'VERSION'}->{'NUMBER'}.'\'</span><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Build date: <span class="t-red-dark">\''.$WC::CONST->{'VERSION'}->{'DATE'}.'\'</span><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-green">New versions you can download here: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'" title="Visit to Web Console Download" target="_blank">'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'</a>';
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
			},
			'__func_auto__' => sub {
				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#about'}->{'version'}->{'__func__'}->();
				return $result;
			}
		},
		'url' => {
			'__doc__' => 'Web Console official website and other URLs',
			'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console official website and other URLs.',
			'__func__' => sub {
				my $result = '<span class="t-lime">Web Console official URLs:</span><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console official WEBSITE:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'SITE'}.'" title="Visit to Web Console official WEBSITE" target="_blank">'.$WC::CONST->{'URLS'}->{'SITE'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Usage:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'USAGE'}.'" title="Visit to Web Console Usage" target="_blank">'.$WC::CONST->{'URLS'}->{'USAGE'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console FAQ:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FAQ'}.'" title="Visit to Web Console FAQ" target="_blank">'.$WC::CONST->{'URLS'}->{'FAQ'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console official FORUM:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FORUM'}.'" title="Visit to Web Console official FORUM" target="_blank">http://forum.web-console.org</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Download:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'" title="Visit to Web Console Download" target="_blank">'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'</a><br />'.
					     # $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Plugins/Addons:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'ADDONS'}.'" title="Visit to Web Console Plugins/Addons" target="_blank">'.$WC::CONST->{'URLS'}->{'ADDONS'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Group services: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'SERVICES'}.'" title="Visit to Web Console Group services" target="_blank">'.$WC::CONST->{'URLS'}->{'SERVICES'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Bug Tracker:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'BUGS'}.'" title="Visit to Web Console Bug Tracker" target="_blank">'.$WC::CONST->{'URLS'}->{'BUGS'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- Web Console Feature Requests:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FEATURE_REQUESTS'}.'" title="Visit to Web Console Feature Requests" target="_blank">'.$WC::CONST->{'URLS'}->{'FEATURE_REQUESTS'}.'</a>';
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
			},
			'__func_auto__' => sub {
				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#about'}->{'url'}->{'__func__'}->();
				return $result;
			}
		},
		'site' => '$$#about|url$$',
		'support' => {
			'__doc__' => 'Web Console official support information',
			'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console official support information.',
			'__func__' => sub {
				my $result = '<span class="t-lime">Web Console support information:</span><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you need help with Web Console, please have a look:</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Web Console Usage:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'USAGE'}.'" title="Visit to Web Console Usage" target="_blank">'.$WC::CONST->{'URLS'}->{'USAGE'}.'</a><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Web Console FAQ:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FAQ'}.'" title="Visit to Web Console FAQ" target="_blank">'.$WC::CONST->{'URLS'}->{'FAQ'}.'</a><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Web Console official FORUM:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FORUM'}.'" title="Visit to Web Console official FORUM" target="_blank">http://forum.web-console.org</a><br />'.
					     # $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you need Web Console plugins/addons, please have a look:</span><br />'.
					     # ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Web Console Plugins/Addons:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'ADDONS'}.'" title="Visit to Web Console Plugins/Addons" target="_blank">'.$WC::CONST->{'URLS'}->{'ADDONS'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you need new Web Console version, please have a look:</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Web Console Download:</span> <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'" title="Visit to Web Console Download" target="_blank">'.$WC::CONST->{'URLS'}->{'DOWNLOAD'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you think you have found a Web Console bug or you have<br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'an idea about new interest feature, please have a look:</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Web Console Bug Tracker: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'BUGS'}.'" title="Visit to Web Console Bug Tracker" target="_blank">'.$WC::CONST->{'URLS'}->{'BUGS'}.'</a><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Web Console Feature Requests: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'FEATURE_REQUESTS'}.'" title="Visit to Web Console Feature Requests" target="_blank">'.$WC::CONST->{'URLS'}->{'FEATURE_REQUESTS'}.'</a><br />'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<span class="t-blue">- If you need help with your website/server or your have some<br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'interest job for us, please have a look:</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-green">- Web Console Group services: <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'SERVICES'}.'" title="Visit to Web Console Group services" target="_blank">'.$WC::CONST->{'URLS'}->{'SERVICES'}.'</a>';
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
			},
			'__func_auto__' => sub {
				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#about'}->{'support'}->{'__func__'}->();
				return $result;
			}
		},
		'services' => {
			'__doc__' => 'Web Console Group official services',
			'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see information about Web Console Group official services.',
			'__func__' => sub {
				my $result = '<span class="t-lime">Web Console Group official services information:</span><br /><span class="t-green">'.
					     $WC::Internal::DATA::MESSAGES->{'n__'}.'<a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'ABOUT_US'}.'" title="Read more information about Web Console Group" target="_blank">Web Console Group</a> provides following services:<br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-blue">- web application development;</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-blue">- server configuration;</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-blue">- technical support;</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-blue">- security analysis;</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-blue">- consulting;</span><br />'.
					     ($WC::Internal::DATA::MESSAGES->{'n__'} x 2).'<span class="t-blue">- other services.</span><br />'.
   					     $WC::Internal::DATA::MESSAGES->{'n__'}.'To get more information about it please visit to <a class="t-link-notUL" href="'.$WC::CONST->{'URLS'}->{'ABOUT_US'}.'" title="Read more information about Web Console Group" target="_blank">Web Console Group</a><br />'.
   					     $WC::Internal::DATA::MESSAGES->{'n__'}.'official services page: <a class="a-brown" href="'.$WC::CONST->{'URLS'}->{'SERVICES'}.'" title="Read more information about Web Console Group services" target="_blank">'.$WC::CONST->{'URLS'}->{'SERVICES'}.'</a></span>';
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
			},
			'__func_auto__' => sub {
				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#about'}->{'services'}->{'__func__'}->();
				return $result;
			}
		},
		'donate' => {
			'__doc__' => 'Donate to Web Console project',
			'__info__' => 'Web Console is available for free, and it is sustained by people like you.'."\n".
				      'Please donate today. '.$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console donation information.',
			'__func__' => sub {
				my $ID = &WC::Internal::get_unique_id();
				my $result = '<span class="t-lime">Web Console project donation information:</span><br />'.
					     '<div id="donate-CONTAINER-'.$ID.'"></div>'.
					     '<script type="text/JavaScript"><!--'."\n".
					     "var obj = xGetElementById('donate-CONTAINER-$ID');".
					     "if (obj) obj.innerHTML = WC.Console.HTML.get_DONATION_HTML(1);"."\n".
					     '//--></script>'."\n";
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
			},
			'__func_auto__' => sub {
				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#about'}->{'donate'}->{'__func__'}->();
				return $result;
			}
		}
	},
	'#services' => '$$#about|services$$',
	'#support' => '$$#about|support$$',
	'#help' => '$$#about|support$$',
	'#open' => '$$#file|open$$',
	'#o' => '$$#file|open$$',
	'#show' => '$$#file|open$$',
	'#edit' => '$$#file|edit$$',
	'#e' => '$$#file|edit$$',
	'#download' => '$$#file|download$$',
	'#d' => '$$#file|download$$',
	'#get' => '$$#file|download$$',
	# Upload defined at module 'WC::Internal::Data::Upload'
	'#upload' => '$$#file|upload$$',
	'#u' => '$$#file|upload$$',
	'#send' => '$$#file|upload$$',
	# File defined at module 'WC::Internal::Data::File'
	'#file' => {},
	# Setting defined at module 'WC::Internal::Data::Settings'
	'#settings' => {},
	'#config' => '$$#settings$$',
	'#users' => {
		'__doc__' => 'Web Console users management',
		'__info__' => 'Manage Web Console users.',
		'_create' => {
			'__doc__' => 'Internal method for user creation (called when form submitted)',
			'__info__' => 'Manual call is not recommended.',
			'__func__' => sub {
				my ($in_CMD) = @_;
				$in_CMD = '' if (!defined $in_CMD);

				my $result = '';
				my $prepare_RESULT = $WC::Internal::DATA::ALL->{'#users'}->{'__create_modify_PREPARE'}->($in_CMD);
				if (!$prepare_RESULT->{'ID'}) { $result = &WC::HTML::get_message("USER CAN'T BE CREATED", '  - '.$prepare_RESULT->{'ERROR'}); }
				else {
					my $login = defined $prepare_RESULT->{'PARAMETERS'}->{'login'} ? $prepare_RESULT->{'PARAMETERS'}->{'login'} : '';
					if(&WC::Users::create($prepare_RESULT->{'PARAMETERS'}) == 1) {
						$result = &WC::HTML::get_message_GOOD("USER '$login' HAS BEEN SUCCESSFULLY CREATED");
					}
					else { $result = &WC::HTML::get_message("USER '$login' CAN'T BE CREATED", '  - '.(&WC::Users::get_last_error_TEXT())); }
					return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
				}
			}
		},
		'_remove' => {
			'__doc__' => 'Internal method for user removing (called then button at form pressed)',
			'__info__' => 'Manual call is not recommended.',
			'__func__' => sub {
				my ($in_CMD) = @_;
				$in_CMD = '' if (!defined $in_CMD);

				my $result = '';
				# Parsing parameters and removing
				my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD);
				if (defined $hash_PARAMS->{'login'} && $hash_PARAMS->{'login'} ne '') {
					if(&WC::Users::remove($hash_PARAMS->{'login'}) == 1) {
						$result = &WC::HTML::get_message_GOOD("USER ('".$hash_PARAMS->{'login'}."') HAS BEEN SUCCESSFULLY REMOVED");
					}
					else { $result = &WC::HTML::get_message("USER (".$hash_PARAMS->{'login'}.") CAN'T BE REMOVED", '  - '.(&WC::Users::get_last_error_TEXT())); }
				}
				else { $result = &WC::HTML::get_message("USER CAN'T BE REMOVED", '  - Incorrect method call'); }
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
			}
		},
		'_modify' => {
			'__doc__' => 'Internal method for user modification (called when form submitted)',
			'__info__' => 'Manual call is not recommended.',
			'__func__' => sub {
				my ($in_CMD) = @_;
				$in_CMD = '' if (!defined $in_CMD);

				my $result = '';
				my $login = '';
				my $prepare_RESULT = $WC::Internal::DATA::ALL->{'#users'}->{'__create_modify_PREPARE'}->($in_CMD);
				if ($prepare_RESULT->{'ID'}) {
					if (defined $prepare_RESULT->{'PARAMETERS'}->{'real_login'}) {
						$login = $prepare_RESULT->{'PARAMETERS'}->{'real_login'};
						delete $prepare_RESULT->{'PARAMETERS'}->{'real_login'};
					}
					if ($login eq '') {
						$result->{'ERRORS'} = ['"real_login" (REAL USER LOGIN) can\'t be empty'];
						$prepare_RESULT->{'ID'} = 0;
					}
				}
				if (!$prepare_RESULT->{'ID'}) { $result = &WC::HTML::get_message("USER ('$login') INFORMATION CAN'T BE MODIFIED", '  - '.$prepare_RESULT->{'ERROR'}); }
				else {
					if(&WC::Users::modify($login, $prepare_RESULT->{'PARAMETERS'}) == 1) {
						$result = &WC::HTML::get_message_GOOD("USER ('$login') INFORMATION HAS BEEN SUCCESSFULLY MODIFIED");
					}
					else { $result = &WC::HTML::get_message("USER ('$login') INFORMATION CAN'T BE MODIFIED", '  - '.(&WC::Users::get_last_error_TEXT())); }
				}
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;
			}
		},
		'__create_modify_PREPARE' => sub {
				my ($in_CMD) = @_;
				$in_CMD = '' if (!defined $in_CMD);

				my $result = { 'ID' => 1, 'ERRORS' => [], 'PARAMETERS' => {} };
				my $hash_PARAMS = &WC::Internal::pasre_parameters($in_CMD);
				my $hash_ADDITIONAL = {};
				if (defined $hash_PARAMS->{'info_additional'} && $hash_PARAMS->{'info_additional'} !~ /^[ \t\r\n]{0,}$/) {
					my $pasre_JSON = &NL::String::JSON_to_HASH($hash_PARAMS->{'info_additional'});
					if ($pasre_JSON->{'ID'}) {
						$hash_ADDITIONAL = $pasre_JSON->{'HASH'};
						delete $hash_PARAMS->{'info_additional'};
						&NL::Utils::hash_merge($hash_PARAMS, $hash_ADDITIONAL);
					}
					else {
						$result->{'ID'} = 0;
						$result->{'ERROR'} = '"Additional options" JSON can\'t be parsed, please ensure that entered JSON is correct';
					}
				}
				# Setting parameters groups
				&NL::Parameter::make_groups($hash_PARAMS, {
					'additional_' => {
						'*' => 'additional',
						'logon_' => 'logon'
					}
				});

				$result->{'PARAMETERS'} = $hash_PARAMS;
				return $result;
		},
		'__new_edit_FORM' => sub {
				my ($in_user_LOGIN, $in_user_INFO) = @_;
				my %HTML_HASH = ( 'ACTION' => '', 'DATA_LOGIN' => '', 'DATA_ADDITIONAL' => '' );
				my %HTML_HASH_USER;
				my $arr_USER_KEYS_NEEDED = [ 'password', 'group', 'e-mail', 'comment', 'additional|logon|javascript' ];

				if (defined $in_user_LOGIN && defined $in_user_INFO) {
					%HTML_HASH = (
						'ACTION' => 'modify',
						'DATA_LOGIN' => '',
						'DATA_ADDITIONAL' => '',
						'TITLE' => 'View/Modify Web Console user information',
						'INFO' => 'Below you can view/edit user information.',
						'MAIN_DIV_ADDON' => '<tr><td colspan="2" class="area-main s-message">If you need to change user password - please enter it at "New password" and "Confirm new password" fields. '.
							     'If that fields are empty - password will not be changed.</td></tr>',
						'MESSAGE' => 'When you click "Save" button, user modification will be executed as new command. '.
							     'At bottom of the window you will see it, at that command result you will see result of user modification.<br />'.
							     'That View/Edit box will not be closed after modification and you can make new modifications for that user '.
							     '(that is usable when you testing your modification at another browser window).<br />'.
							     'If you don\'t want to modify user information just click "Close" button.',
						'LABEL_PASSWORD' => 'New password:',
						'LABEL_PASSWORD_CONFIRM' => 'Confirm new password:',
						'BUTTON_SUBMIT' => 'Save',
						'JS_CMD_NAME' => 'MODIFYING INFORMATION OF USER',
						'JS_CMD_PREFIX' => '#users _modify',
						'JS_IS_PASSWORD_NO_EMPTY' => 0
					);
					$HTML_HASH{'DATA_LOGIN'} = $in_user_LOGIN;
					my $hash_additional = \%{ $in_user_INFO };
					# Seeting needed user DATA
					%HTML_HASH_USER = %{ &NL::Parameter::grab($hash_additional, $arr_USER_KEYS_NEEDED,
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
					if (scalar keys %{ $hash_additional } > 0) {
						$HTML_HASH{'DATA_ADDITIONAL'} = &NL::String::str_HTML_value( &NL::String::VAR_to_JSON($hash_additional, { 'SPACES' => 1 }) );
					}
				}
				else {
					%HTML_HASH = (
						'ACTION' => 'new',
						'DATA_LOGIN' => '',
						'DATA_ADDITIONAL' => '',
						'TITLE' => 'Create new Web Console user',
						'INFO' => 'Please fill following fields to create new user.',
						'MAIN_DIV_ADDON' => '<br />',
						'MESSAGE' => 'When you click "Create" button, new user creation will be executed as new command. '.
							     'At bottom of the window you will see it, at that command result you will see result of user creation.<br />'.
							     'That creation box will not be closed after creation and you can create another new user.',
						'LABEL_PASSWORD' => 'Password:',
						'LABEL_PASSWORD_CONFIRM' => 'Confirm password:',
						'BUTTON_SUBMIT' => 'Create',
						'JS_CMD_NAME' => 'CREATING NEW USER',
						'JS_CMD_PREFIX' => '#users _create',
						'JS_IS_PASSWORD_NO_EMPTY' => 1
					);
					# Seeting needed user DATA
					%HTML_HASH_USER = %{ &NL::Parameter::grab({}, $arr_USER_KEYS_NEEDED, { 'SET_NOT_FOUND_EMPTY' => 1 }) };
				}
				# Getting groups
				my $hash_groups = { '' => ' - no group - ' };
				my $finded_groups = &WC::Users::get_groups_list();
				foreach (keys %{ $finded_groups }) { $hash_groups->{$_} = $_; }
				$finded_groups->{ $HTML_HASH_USER{'group'} } = $HTML_HASH_USER{'group'} if (!defined $finded_groups->{ $HTML_HASH_USER{'group'} });
				# Making groups SELECT OPTIONS
				my $groups_options = '';
				foreach (sort keys %{ $hash_groups }) {
					my $value = &NL::String::str_HTML_value($_);
					my $name = &NL::String::str_HTML_value($hash_groups->{$_});
					my $str_selected = ($HTML_HASH_USER{'group'} eq $_) ? ' selected' : '';
					$groups_options .= '<option value="'.$value.'"'.$str_selected.'>'.$name.'</option>';
				}
				my $ID = &WC::Internal::get_unique_id();


				# Buttons generation
				my $result_BUTTONS = '';
				if ($HTML_HASH{'ACTION'} eq 'new') {
					$result_BUTTONS .= <<HTML_EOF;
					<td class="area-button-left"><div id="user-create-button-submit-${ID}" class="div-button w-120">$HTML_HASH{'BUTTON_SUBMIT'}</div></td>
					<td class="area-button-right"><div id="user-create-button-close-${ID}" class="div-button w-120">Close</div></td>
					<td class="area-button-right" colspan="3"><div id="user-create-button-RMBELOW-${ID}" class="div-button w-270">Remove all messages below this box</div></td>
HTML_EOF
				}
				else {
					$result_BUTTONS .= <<HTML_EOF;
					<td class="area-button-left"><div id="user-create-button-close-${ID}" class="div-button w-120">Close</div></td>
					<td class="area-button-right"><div id="user-create-button-submit-${ID}" class="div-button w-120">$HTML_HASH{'BUTTON_SUBMIT'}</div></td>
					<td class="area-button-right"><div id="user-create-button-remove-${ID}" class="div-button w-150">Remove this user</div></td>
					<td class="area-button-right" colspan="3"><div id="user-create-button-RMBELOW-${ID}" class="div-button w-270">Remove all messages below this box</div></td>
HTML_EOF
				}
				# Bottom generation
				my $result_BOTTOM = '<table class="grid" id="wc-user-BUTTONS-'.$ID.'" style="width: 765px">';
				$result_BOTTOM .= '<tr><td class="s-comment">'.$HTML_HASH{'MESSAGE'}.'</td></tr>';
				$result_BOTTOM .= '<tr><td><table class="grid"><tr>';
				$result_BOTTOM .= $result_BUTTONS;
				$result_BOTTOM .= '</tr></table></td></tr></table>';

				my $result_DIVS = <<HTML_EOF;
	<div id="user-create-DIV-MAIN-${ID}">
		<form id="user-create-form-MAIN-${ID}" action="" onsubmit="return false" target="_blank">
		<input type="hidden" id="_h_user_login-${ID}" name="h_user_login-${ID}" value="$HTML_HASH{'DATA_LOGIN'}" />
		<table class="grid" style="width: 765px">
			<tr><td class="area-top s-info" colspan="2">$HTML_HASH{'INFO'}</td></tr>
			<tr>
				<td class="area-left-short">Login:</span></td>
				<td class="area-right-long"><input class="in-text w-270" type="text" id="_user_login-${ID}" name="user_login-${ID}" value="$HTML_HASH{'DATA_LOGIN'}" /></td></tr>
			<tr>
				<td class="area-left-short">E-mail:</span></td>
				<td class="area-right-long"><input class="in-text w-270" type="text" id="_user_e-mail-${ID}" name="user_e-mail-${ID}" value="$HTML_HASH_USER{'e-mail'}" /></td></tr>
			<tr>
				<td class="area-left-short"><span>$HTML_HASH{'LABEL_PASSWORD'}</span></td>
				<td class="area-right-long"><input class="in-text w-270" type="password" id="_user_password-${ID}" name="user_password-${ID}" /></td></tr>
			<tr>
				<td class="area-left-short"><span>$HTML_HASH{'LABEL_PASSWORD_CONFIRM'}</span></td>
				<td class="area-right-long"><input class="in-text w-270" type="password" id="_user_password-${ID}_c" name="user_password-${ID}_c" /></td></tr>
			<tr>
				<td class="area-left-short">Group:<br /><span class="s-note">(groups not used now)</span></td>
				<td class="area-right-long"><select class="w-200" id="_user_group-${ID}" name="user_group-${ID}">$groups_options</select></td></tr>
			<tr>
				<td class="area-left-short">Comment:</td>
				<td class="area-right-long"><textarea style="width: 400px; height: 60px" id="_user_comment-${ID}" name="user_comment-${ID}">$HTML_HASH_USER{'comment'}</textarea></td></tr>
			$HTML_HASH{'MAIN_DIV_ADDON'}
		</table></form>
	</div>
	<div id="user-create-DIV-STARTUPJS-${ID}" style="display: none">
		<form id="user-create-form-STARTUPJS-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr>
				<td class="area-top s-info">Startup JavaScript <span class="s-note s-info" style="cursor: help" title="When user logons to Web Console - that JavaScript will be executed">(will be executed after user logon)</span>:
				</td>
			</tr>
			<tr><td class="area-main"><textarea wrap="off" style="width: 760px; height: 180px" id="_user_info_startup_JAVASCRIPT-${ID}" name="user_info_startup_JAVASCRIPT-${ID}">$HTML_HASH_USER{'additional'}{'logon'}{'javascript'}</textarea></td></tr>
			<tr><td>
				<table class="grid"><tr>
					<td class="area-button-left"><div id="user-create-button-startup_JAVASCRIPT-EXEC-${ID}" class="div-button w-270">Execute this JavaScript now</div></td>
				</tr></table>
			</td></tr>
		</table></form>
	</div>
	<div id="user-create-DIV-ADDITIONAL-${ID}" style="display: none">
		<form id="user-create-form-ADDITIONAL-${ID}" action="" onsubmit="return false" target="_blank">
		<table class="grid" style="width: 765px">
			<tr>
				<td class="area-top s-info">Additional user options <span class="s-note s-info" style="cursor: help" title="JavaScript Object Notation">(at JSON format)</span>:
				</td>
			</tr>
			<tr><td class="area-main"><textarea wrap="off" style="width: 760px; height: 180px" id="_user_info_additional-${ID}" name="user_info_additional-${ID}">$HTML_HASH{'DATA_ADDITIONAL'}</textarea></td></tr>
			<tr><td>
				<table class="grid"><tr>
					<td class="area-button-left"><div id="user-create-button-additional-CHECK-${ID}" class="div-button w-270">Check validity of this JSON now</div></td>
				</tr></table>
			</td></tr>
		</table></form>
	</div>
HTML_EOF
				foreach ($result_DIVS, $result_BOTTOM) {
					$_ =~ s/([\\'])/\\$1/g;
					$_ =~ s/\n/\\n/g;
				}
				my $result_HTML = <<HTML_EOF;
	<div id="user-create-CONTAINER-${ID}"></div>
	<script type="text/JavaScript"><!--
		WC.UI.tab_set('user-create-CONTAINER-${ID}', '$HTML_HASH{'TITLE'}', '${result_DIVS}', {
			'ID': 'user-create-tab-${ID}',
			'MENU': {
				'User information': { 'id': 'user-create-DIV-MAIN-${ID}', 'active': 1 },
				'User startup JavaScript': { 'id': 'user-create-DIV-STARTUPJS-${ID}' },
				'Additional options': { 'id': 'user-create-DIV-ADDITIONAL-${ID}' }
			},
			'MENU_DIV_SIZE_SAME': 1,
			'BOTTOM': '${result_BOTTOM}'
		});
		NL.UI.div_button_register('div-button', 'user-create-button-submit-$ID', function () {
			var hash_DATA = NL.Form.check_fields({
				'_h_user_login-${ID}': { 'name_at_hash': 'real_login', 'name': 'ORIGINAL USER LOGIN (internal)', 'needed': 0 },
				'_user_login-${ID}': { 'name_at_hash': 'login', 'name': 'Login', 'needed': 1,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'User information'); }
				},
				'_user_e-mail-${ID}': { 'name_at_hash': 'e-mail', 'name': 'E-mail', 'needed': 1,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'User information'); },
					'func_CHECK': NL.Form.FUNC_CHECK_email
				},
				'_user_password-${ID}': { 'name_at_hash': 'password', 'name': '$HTML_HASH{'LABEL_PASSWORD'}', 'needed': $HTML_HASH{'JS_IS_PASSWORD_NO_EMPTY'}, 'confirm': 1,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'User information'); },
					'func_ENCODE': function(in_value) {
					if (NL.Crypt.sha1_vm_test()) return [1, NL.Crypt.sha1_hex(in_value)];
					else { alert('Java Virtual Machine works incorrectly'); return [0, '']; }
					}
				},
				'_user_group-${ID}': { 'name_at_hash': 'group', 'name': 'Group', 'needed': 0 },
				'_user_comment-${ID}': { 'name_at_hash': 'comment', 'name': 'Comment', 'needed': 0 },
				'_user_info_startup_JAVASCRIPT-${ID}': { 'name_at_hash': 'additional_logon_javascript', 'name': 'User startup JavaScript', 'needed': 0,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'Startup JavaScript'); },
					'func_ENCODE': function(in_value) { return [1, in_value]; }
				},
				'_user_info_additional-${ID}': { 'name_at_hash': 'info_additional', 'name': 'Additional options', 'needed': 0,
					'func_BEFORE_FOCUS': function() { return WC.UI.tab_activate('user-create-tab-${ID}', 'Additional options'); },
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
				WC.Console.Exec.CMD_INTERNAL("$HTML_HASH{'JS_CMD_NAME'} '"+hash_DATA['login']+"'", '$HTML_HASH{'JS_CMD_PREFIX'}', hash_DATA);
			}
		});
		NL.UI.div_button_register('div-button', 'user-create-button-close-$ID', function () { WC.Console.HTML.OUTPUT_remove_result('user-create-tab-$ID'); });
		NL.UI.div_button_register('div-button-270', 'user-create-button-RMBELOW-$ID', function () { WC.Console.HTML.OUTPUT_remove_below('user-create-tab-$ID'); });
		NL.UI.div_button_register('div-button-270', 'user-create-button-startup_JAVASCRIPT-EXEC-$ID', function () {
			var obj_JS = xGetElementById('_user_info_startup_JAVASCRIPT-${ID}');
			if (obj_JS && obj_JS.value && !obj_JS.value.match(/^[\\s\\t\\r\\n]{0,}\$/)) {
				try { eval (obj_JS.value); }
				catch (e) {
					alert("JavaScript code execution error:\\n--cut--\\n" + (e['name'] ? e['name'] : '__UNKNOWN_NAME__') + ': ' + (e['message'] ? e['message'] : '__UNKNOWN_MESSAGE__') + "\\n--cut--");
				}
			}
			else alert("JavaScript code is empty, please enter it or leave blank");
		});
		NL.UI.div_button_register('div-button-270', 'user-create-button-additional-CHECK-${ID}', function () {
			var obj = xGetElementById('_user_info_additional-${ID}');
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
HTML_EOF
	if ($HTML_HASH{'ACTION'} ne 'new') {
		$result_HTML .= <<HTML_EOF;
		NL.UI.div_button_register('div-button-180', 'user-create-button-remove-${ID}', function () {
			var obj = xGetElementById('_h_user_login-${ID}');
			if (obj && obj.value) {
				if (confirm('Are you sure, user "'+obj.value+'" will be removed?')) {
					// Removing user
					WC.Console.Exec.CMD_INTERNAL("REMOVING USER '"+obj.value+"'", '#users _remove', { 'login': obj.value });
				}
			}
			else alert("ORIGINAL USER LOGIN (internal) can't be found");
		});
HTML_EOF
	}

		$result_HTML .= <<HTML_EOF;
	//--></script>
HTML_EOF
			return $result_HTML;
		},
		'add' => {
			'__doc__' => 'Add/create new user',
			'__info__' => 'Create new Web Console user.'."\n".$WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'open Web Console user creation form.',
			'__func__' => sub {
				return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$WC::Internal::DATA::ALL->{'#users'}->{'__new_edit_FORM'}->();;
			},
			'__func_auto__' => sub {
				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#users'}->{'add'}->{'__func__'}->();
				return $result;
			}
		},
		'create' => '$$#users|add$$',
		'new' => '$$#users|add$$',
		'show' => {
			'__doc__' => 'Show registred users list / view or edit user information / remove user',
			'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'see Web Console registred users list.',
			'__func_auto__' => sub {
				my ($in_CMD, $in_BACK_STASH, $in_IS_EXECUTION) = @_;
				$in_CMD = '' if (!defined $in_CMD);
				$in_BACK_STASH = {} if (!defined $in_BACK_STASH);

				# Preparing data
				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				my $hash_USERS_AC = {
					'__doc__' => $WC::Internal::DATA::ALL->{'#users'}->{'show'}->{'__doc__'},
					'__info__' => 'Below you can see Web Console registred users list.'."\n".
						      'You can select user using autocomplete feature by "TAB" key.'."\n".
						      'To view/edit full user information please select user and press "ENTER".'."\n".
						      '  Examples:'."\n".
						      $WC::Internal::DATA::MESSAGES->{'__'}.'  - View registred users list which login begins from "a": #users ... a<TAB>'."\n".
						      $WC::Internal::DATA::MESSAGES->{'__'}.'  - View/edit full information of user "admin": #users ... admin<ENTER>'."\n"
				};
				# Getting users list
				my $hash_USERS = &WC::Users::get_users_list();
				my $user_info = '';
				foreach my $user (keys %{ $hash_USERS }) {
					$user_info = ''; #"User login: '$user'";
					my $arr_info = [{ 'group' => 'Group: ' }]; # , { 'e-mail' => 'e-mail: ' }
					foreach my $item (@{ $arr_info }) {
						foreach (keys %{ $item }) {
							$user_info .= ', ' if ($user_info ne '');
							$user_info .= '<span class="t-red-dark">'.$item->{$_}."</span>'";
							$user_info .= &NL::String::str_HTML_full($hash_USERS->{ $user }->{$_}) if (defined $hash_USERS->{ $user }->{$_});
							$user_info .= "'";
						}
					}
					if (defined $hash_USERS->{ $user }->{'comment'} && $hash_USERS->{ $user }->{'comment'} ne '') {
						$user_info .= ', ' if ($user_info ne '');
						$user_info .= '<span class="t-red-dark">comment:</span> \'';
						$user_info .= &NL::String::str_HTML_value( &NL::String::get_left( &NL::String::str_to_line( $hash_USERS->{ $user }->{'comment'} ), 30, 1) );
						$user_info .= "'";
					}

					$hash_USERS_AC->{ $user } = {
						'__doc__' => $user_info, '__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_TAB_OR_ENTER_TO_'}.'view/edit full user information.',
						'__func__' => sub {
							return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$WC::Internal::DATA::ALL->{'#users'}->{'__new_edit_FORM'}->($user, $hash_USERS->{ $user });
						},
						'__func_auto__' => sub {
							my $result = \%{ $WC::Internal::DATA::AC_RESULT };
							$result->{'TEXT'} = $hash_USERS_AC->{ $user }->{'__func__'}->();
							return $result;
						}
					};
				}
				# Executing autocompletion
				my $hash_SETTINGS = { 'LIST_TITLE' => 'Registred users list:' };
				if (defined $in_IS_EXECUTION && $in_IS_EXECUTION) {
					$hash_SETTINGS->{'EXECUTE'} = 1;
					$hash_SETTINGS->{'EXECUTE_HARD'} = 1;
				}
				if ($in_CMD eq '') {
					&NL::Utils::hash_update($result, &WC::Internal::get_list($hash_USERS_AC, '', $hash_SETTINGS));
					return $result;
				}
				else {
					my $hash_AC = &WC::Internal::autocomplete($in_CMD, $hash_SETTINGS, $hash_USERS_AC);
					if (!$hash_AC->{'ID'}) {
						$in_CMD =~ s/[ \n\t].*$//;
						$hash_AC->{'ID'} = 1;
						$hash_AC->{'TITLE'} = uc($WC::Internal::DATA::ALL->{'#users'}->{'show'}->{'__doc__'});
						$hash_AC->{'SUBTITLE'} = '  - No user "'.$in_CMD.'" found, please enter valid user login';
					}
					return $hash_AC;
				}
			},
			'__func__' => sub {
				my ($in_CMD) = @_;
				$in_CMD = '' if (!defined $in_CMD);

				my $result = \%{ $WC::Internal::DATA::AC_RESULT };
				&NL::Utils::hash_update($result, $WC::Internal::DATA::ALL->{'#users'}->{'show'}->{'__func_auto__'}->($in_CMD, {}, 1));
				$result->{'SHOW_AS_TAB_RESULT'} = 1;
				return $result;
			}
		},
		'view' => '$$#users|show$$',
		'edit' => '$$#users|show$$',
		'modify' => '$$#users|show$$',
		'list' => '$$#users|show$$',
		'delete' => '$$#users|show$$',
		'remove' => '$$#users|show$$'
	},
	'#logout' => {
		'__doc__' => 'Logout from Web Console',
		'__info__' => $WC::Internal::DATA::MESSAGES->{'PRESS_ENTER_TO_'}.'logout from Web Console.',
		'__func_auto__' => sub {
			my $result = \%{ $WC::Internal::DATA::AC_RESULT };
			$result->{'TITLE'} = uc($WC::Internal::DATA::ALL->{'#logout'}->{'__doc__'});
			$result->{'INFO'} = $WC::Internal::DATA::ALL->{'#logout'}->{'__info__'};
			return $result;
		},
		'__func__' => sub {
			my ($in_CMD) = @_;
			$in_CMD = '' if (!defined $in_CMD);

			my $REDIRECT_URL = $WC::c->{'APP_SETTINGS'}->{'file_name'}.'?logon_rand='.( time() );
			my $result = "<div class=\"t-lime\">LOGGING OUT FROM WEB CONSOLE... [<a href=\"$REDIRECT_URL\" class=\"a-brown\">CLICK TO LOGOUT</a>]</div>";
			$result .= <<HTML_EOF;
	<script type="text/JavaScript"><!--
		window.location='$REDIRECT_URL';
	//--></script>
HTML_EOF
			return $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result;

		}
	},
	'#exit' => '$$#logout$$',
	'#close' => '$$#logout$$',
	'#quit' => '$$#logout$$',
	# Other aliases
	'#chmod' => '$$#file|chmod$$',
	'#manager' => '$$#file|manager$$'
};

# $WC::Internal::DATA::ALL->{'#test'} = {
# 	'__doc__' => 'Testing...',
# 	'__info__' => 'Internal testing',
# 	'__func__' => sub {
# 		my $result = '';
# 		$result = Dumper($WC::c);
# 		return $result;
# 	},
# 	'__func_auto__' => sub {
# 		my $result = \%{ $WC::Internal::DATA::AC_RESULT };
# 		$result->{'TEXT'} = $WC::Internal::DATA::ALL->{'#test'}->{'__func__'}->();
# 		return $result;
# 	}
# };

1; #EOF
