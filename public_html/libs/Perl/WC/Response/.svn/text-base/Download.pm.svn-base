#!/usr/bin/perl
# WC::Response::Download - Web Console file downloading
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::Response::Download;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Response::Download::HEADERS = {
	'end' => "Cache-Control: public\n"."Pragma: public\n"."Expires: 0\n"
};
$WC::Response::Download::TEMP = {
	'file_name' => ''
};
# Starting file downloading
sub start {
	my ($in_HASH_DATA) = @_;

	my $BYTES_READ_BUFFER = 1024*10;
	my $is_OK = 0;
	if (!defined $in_HASH_DATA) { &WC::Response::show_info_HTML('Incorrect method call, are you hacker?'); }
	else {
		if (!defined $in_HASH_DATA->{'dir'} || !$in_HASH_DATA->{'file'}) { &WC::Response::show_info_HTML('Incorrect method call, are you hacker?'); }
		else {
			my $method = (defined $in_HASH_DATA->{'method'}) ? $in_HASH_DATA->{'method'} : '';
			# Getting directory from input
			my $dir = &WC::Dir::check_in($in_HASH_DATA->{'dir'});
			my $dir_ENC_INTERNAL = &WC::Dir::check_in($in_HASH_DATA->{'dir'});
			# Getting directory from config if there is no at input
			if ($dir eq '') { $dir = $WC::c->{'config'}->{'directorys'}->{'work'}; }
			else {
				# Converting encoding
				&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$dir);
			}
			# Chaning directory
			if (!&WC::Dir::change_dir($dir)) { &WC::Response::show_info_HTML( 'Unable change directory to "'.&NL::String::get_right($dir_ENC_INTERNAL, 60, 1).'"'.( ($! ne '') ? ': '.$! :  '' ) ); }
			else {
				# Getting filename from input
				my $file = &WC::Dir::check_in($in_HASH_DATA->{'file'});
				my $file_ENC_INTERNAL = $file;
				# Converting encoding
				&WC::Encode::encode_from_INTERNAL_to_SYSTEM(\$file);
				# Getting small filename
				my $file_ENC_INTERNAL_small = &NL::String::get_right($file, 60, 1);
				&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_ENC_INTERNAL_small);
				if (!-f $file) { &WC::Response::show_info_HTML( 'There is no file "'.$file_ENC_INTERNAL_small.'" found'.( ($! ne '') ? ': '.$! :  '' ) ); }
				else {
					my $size = &WC::File::get_size($file);
					if( !&WC::File::lock_read($file, { 'timeout' => 10, 'time_sleep' => 0.1 }) ) { &WC::Response::show_info_HTML( 'File "'.$file_ENC_INTERNAL_small.'" can\'t be locked for reading'.( ($! ne '') ? ': '.$! :  '' ) ); }
					else {
						$WC::Response::Download::TEMP->{'file_name'} = $file;
						if (!open(FH_DOWNLOAD, '<'.$file)) { &WC::Response::show_info_HTML( 'File "'.$file_ENC_INTERNAL_small.'" can\'t be opened'.( ($! ne '') ? ': '.$! :  '' ) ); }
						else {
							$is_OK = 1;
							# Getting file extension
							my $file_ext = ($file =~ /\.([^\.]{0,})$/) ? $1 : '';
							$file_ext =~ s/\.([^\.]{0,})$/$1/;
							# Getting content type
							my $http_content_type = (defined $WC::Response::MimeTypes::ALL->{$file_ext}) ? $WC::Response::MimeTypes::ALL->{$file_ext} : $WC::Response::MimeTypes::ALL->{''};
							# Setting BINMODE for ALL
							binmode FH_DOWNLOAD;
							binmode STDOUT;
							# Sending headers
							print "Content-Type: $http_content_type\n";
							print "Content-Length: $size\n";
								#print "Accept-Ranges: bytes\n";
							if ($method ne 'open') {
								my $file_NAME = $file_ENC_INTERNAL;
								$file_NAME = &WC::File::get_name($file_NAME);
 								&WC::Encode::encode_from_INTERNAL_to_FILE_DOWNLOAD(\$file_NAME);
								print "Content-Disposition: attachment; filename=\"$file_NAME\"\n";
							}
							print $WC::Response::Download::HEADERS->{'end'};
							print "\n";
							# Sending file DATA
							while (read FH_DOWNLOAD, $_, $BYTES_READ_BUFFER) { print; }
							close (FH_DOWNLOAD);
							&WC::File::unlock($file);
							$WC::Response::Download::TEMP->{'file_name'} = '';
						}
					}
				}
			}
		}
	}
}
#
END {
	if (defined $WC::Response::Download::TEMP->{'file_name'} && $WC::Response::Download::TEMP->{'file_name'} ne '') {
		&WC::File::unlock($WC::Response::Download::TEMP->{'file_name'});
	}
}
1; #EOF
