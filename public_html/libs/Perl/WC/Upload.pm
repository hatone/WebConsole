#!/usr/bin/perl
# WC::Upload - Web Console module for multi-file AJAX uploading with progressbar
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru

package WC::Upload;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Upload::NL_INIT = {};

# Setting 'NL::AJAX::Upload' parameters
sub _set_NL_INIT {
	$WC::Upload::NL_INIT = {
		'DIR_TEMP' => $WC::c->{'config'}->{'directorys'}->{'temp'},
		'POST_MAX' => 50 * (1024 * 1024) # MAX UPLOAD SIZE: RECOMMENDED MAX SIZE ~50 MB
	};
	if (defined $WC::c->{'config'} && defined $WC::c->{'config'}->{'uploading'} && defined $WC::c->{'config'}->{'uploading'}->{'limit'}) {
		if ($WC::c->{'config'}->{'uploading'}->{'limit'} =~ /^\d+$/) {
			$WC::Upload::NL_INIT->{'POST_MAX'} = $WC::c->{'config'}->{'uploading'}->{'limit'} * (1024 * 1024);
		}
	}
	# $WC::Upload::NL_INIT->{'POST_MAX'} = 1 * (1024 * 1024); # For debugging
};
# Caller if 'q_module' == 'upload'
sub process {
	my $params = $WC::c->{'req'}->{'params'};

	my $result = { 'CODE' => 'ERROR', 'MESSAGE' => '' };
	my $message = '';
	if (!defined $params->{'dir'} || $params->{'dir'} eq '') { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '  - NO DIRECTORY specified'); }
	elsif (!defined $params->{'js_ID'} || $params->{'js_ID'} eq '') { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '  - NO SID specified'); }
	elsif (defined $params->{'file_permissions'} && $params->{'file_permissions'} ne '' && $params->{'file_permissions'} !~ /^\d+$/) { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", "  - File(s) permissions is incorrect, correct example: '755'"); }
	else {
		# Converting encoding
		my $dir = $params->{'dir'};
		&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$dir);
		$dir = &WC::Dir::check_in($dir);
		if ($dir eq '') { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '  - Incorrect NO DIRECTORY specified'); }
		elsif (!&WC::Dir::change_dir($dir)) { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '&nbsp;&nbsp;- Directory '.&WC::HTML::get_short_value($dir).' is not accessible'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }); }
		else {
			# Going to subdirrectory, if needed
			my $is_OK = 1;
			if (defined $params->{'dir_sub'} && $params->{'dir_sub'} ne '') {
				$is_OK = 0;
				# Checking value
				$dir = $params->{'dir_sub'};
				&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$dir);
				$dir = &WC::Dir::check_in($dir);
				if ($dir eq '') { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '  - Incorrect SUBDIRECTORY specified'); }
				elsif (!&WC::Dir::change_dir($dir)) { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '&nbsp;&nbsp;- Subdirectory '.&WC::HTML::get_short_value($dir).' is not accessible'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }); }
				else { $is_OK = 1; }
			}
			# Initializing 'NL::AJAX::Upload'
			&_set_NL_INIT();
			my $init_UPLOAD = &NL::AJAX::Upload::init($WC::Upload::NL_INIT);
			if ($init_UPLOAD->{'ID'}) {
				if ($is_OK) {
					# Creating directory, if needed
					if (defined $params->{'dir_create'} && $params->{'dir_create'} ne '') {
						$is_OK = 0;
						# Checking value
						$dir = $params->{'dir_create'};
						&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$dir);
						$dir = &WC::Dir::check_in($dir);
						if ($dir eq '') { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '  - Incorrect DIRECTORY FOR CREATION specified'); }
						elsif (!&WC::Dir::change_dir($dir)) {
							if (!mkdir($dir)) { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '&nbsp;&nbsp;- Subdirectory '.&WC::HTML::get_short_value($dir).' can\'t be created'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }); }
							else {
								if (!&WC::Dir::change_dir($dir)) { $message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", '&nbsp;&nbsp;- Created subdirectory '.&WC::HTML::get_short_value($dir).' is not accessible'.( ($! ne '') ? ': <span class="t-green-light">'.$!.'</span>' :  '' ), { 'ENCODE_TO_HTML' => 0 }); }
								else { $is_OK = 1; }
							}
						}
						else { $is_OK = 1; }
					}
				}
				# OK, now we ready
				if ($is_OK) {
					my $file_permissions = '';
					my $use_binmode = 1;
					if (defined $params->{'file_permissions'} && $params->{'file_permissions'} ne '') { $file_permissions = $params->{'file_permissions'}; }
					if (defined $params->{'mode_ASCII'} && $params->{'mode_ASCII'}) { $use_binmode = 0; }

					my $hash_UPLOAD = &NL::AJAX::Upload::start_upload({ 'SID' => $params->{'js_ID'} }, {
						'FILES_PERMISSIONS' => $file_permissions,
						'BINMODE' => $use_binmode
					});
					if ($hash_UPLOAD->{'ID'}) {
						$result->{'CODE'} = 'OK';
						$result->{'UPLOADS'} = $hash_UPLOAD->{'UPLOADS'};
						$result->{'INFO'} = $hash_UPLOAD->{'INFO'};
					}
					else {
						$message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", $hash_UPLOAD->{'ERROR_MSG'}, { 'AUTO_BR' => 1 });
					}
				}
			}
			else {
				$message = &WC::HTML::get_message("FILE(S) CAN'T BE UPLOADED", $init_UPLOAD->{'ERROR_MSG'}, { 'AUTO_BR' => 1 });
			}
		}
	}
	if ($result->{'CODE'} ne 'OK') { $result->{'MESSAGE'} = $message; }
	&WC::AJAX::show_response('', 'AJAX_UPLOAD_RESULT', {}, $result);
	return 1;
}

sub process_get_status {
	my $params = $WC::c->{'req'}->{'params'};

	my $result = { 'CODE' => 'ERROR', 'MESSAGE' => '', 'STATUS' => {}, 'METHOD' => '' };
	if (!defined $params->{'js_ID'} || $params->{'js_ID'} eq '') { $result->{'MESSAGE'} = &WC::HTML::get_message("CAN'T GET UPLOADING STATUS", '  - NO SID specified'); }
	else {
		my $IN_UPLOAD_STATUS_METHOD = '';
		if (defined $params->{'UPLOAD_STATUS_METHOD'}) { $IN_UPLOAD_STATUS_METHOD = $params->{'UPLOAD_STATUS_METHOD'}; }
		&_set_NL_INIT();
		my $init_UPLOAD = &NL::AJAX::Upload::init($WC::Upload::NL_INIT);
		if ($init_UPLOAD->{'ID'}) {
			my $hash_UPLOAD_STATUS = &NL::AJAX::Upload::status_get($params->{'js_ID'}, { 'METHOD' => $IN_UPLOAD_STATUS_METHOD });
			if ($hash_UPLOAD_STATUS->{'ID'}) {
				$result->{'STATUS'} = $hash_UPLOAD_STATUS->{'STATUS'};
				$result->{'METHOD'} = $hash_UPLOAD_STATUS->{'METHOD'};
				$result->{'CODE'} = 'OK';
				# warn 'OK: '.( Dumper( $result->{'STATUS'} ) );
			}
			else {
				$result->{'CODE'} = 'OK_NO_STATUS';
				$result->{'METHOD'} = $hash_UPLOAD_STATUS->{'METHOD'};
				$result->{'MESSAGE'} = $hash_UPLOAD_STATUS->{'ERROR_MSG'};
				# warn 'NO: '.$result->{'MESSAGE'};
			}
		}
		else {
			$result->{'MESSAGE'} = &WC::HTML::get_message("CAN'T GET UPLOADING STATUS", $init_UPLOAD->{'ERROR_MSG'}, { 'AUTO_BR' => 1 });
		}
	}

	&WC::AJAX::show_response('', 'AJAX_UPLOAD_STATUS', {}, $result);
	return 1;
}
sub get_dir_list {
	my ($in_ref_hash_FORM_PARAMS) = @_;

			my $req_params = $in_ref_hash_FORM_PARAMS;
			my $ref_arr_dir_list = [];

			my $cur_dir = $WC::c->{'config'}->{'dir_work'};
			if (defined $req_params->{'dir_from_list'} && $req_params->{'dir_from_list'} ne '') {
				$cur_dir = $req_params->{'dir_from_list'};
			}
			$cur_dir .= '/' if ($cur_dir !~ /[\\\/]$/);

			if ($cur_dir ne '') {
				push @{ $ref_arr_dir_list }, $cur_dir;
				chdir ($cur_dir);
			}

			foreach (@{ &WC::Utils::dir_list('./', 1) }) {
				if (-d $_) {
					push @{ $ref_arr_dir_list }, $cur_dir.$_;
				}
			}
			#if (scalar @{ $ref_arr_dir_list } <= 0) { push @{ $ref_arr_dir_list }, $cur_dir; }
			return $ref_arr_dir_list;
}
1; #EOF
