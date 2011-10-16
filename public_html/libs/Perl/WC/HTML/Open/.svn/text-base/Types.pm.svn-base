#!/usr/bin/perl
# WC::HTML::Open::Types - Web Console file OPEN TYPES
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::HTML::Open::Types;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Getting file paths
sub get_file_paths {
	my ($file) = @_;

	my $path_URL = &NL::String::str_HTTP_REQUEST_value($file);
	# Getting current directory
	&WC::Dir::update_current_dir();
	my $dir_current_ENC_INTERNAL = &WC::Dir::get_current_dir();
	&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$dir_current_ENC_INTERNAL);
	my $dir_current_URL = &NL::String::str_HTTP_REQUEST_value($dir_current_ENC_INTERNAL);
	# Getting login/password
	my $user_login_URL =  &NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_login'});
	my $user_password_URL =  &NL::String::str_HTTP_REQUEST_value($WC::c->{'req'}->{'params'}->{'user_password'});

	return {
		'open' => $WC::c->{'APP_SETTINGS'}->{'file_name'}.
				'?q_action=download'.
				'&method=open'.
				'&user_login='.$user_login_URL.
				'&user_password='.$user_password_URL.
				'&dir='.$dir_current_URL.
				'&file='.$path_URL,
		'download' => $WC::c->{'APP_SETTINGS'}->{'file_name'}.
				'?q_action=download'.
				'&user_login='.$user_login_URL.
				'&user_password='.$user_password_URL.
				'&dir='.$dir_current_URL.
				'&file='.$path_URL
	};
}

# MIME types
$WC::HTML::Open::Types::ALL = {
	'' => sub { # Nothing
		my ($file) = @_;
		# Converting encoding
		my $file_ENC = $file;
		my $file_SHORT = &WC::HTML::get_short_value($file_ENC);
		&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_ENC);
		&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_SHORT);
		# Getting pathes
		my $path = &WC::HTML::Open::Types::get_file_paths($file_ENC);
		return '<div class="t-blue">&nbsp;&nbsp;-&nbsp;File '.$file_SHORT.' can\'t be opened, unknown file type - <a href="'.$path->{'download'}.'" class="a-brown" target="_blank">click to download</a></div>';

	},
	'txt' => sub {
		my ($file) = @_;
		return $WC::Internal::DATA::ALL->{'#file'}->{'edit'}->{'__func__'}->('', {}, { 'IS_OPEN' => 1, 'ARR_FILES' => [$file] });
	},
#	*** MP3 TEMPORARY REMOVED ***
#	'mp3' => sub {
#		my ($file) = @_;
#
#		# Converting encoding
#		my $file_ENC = $file;
#		&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_ENC);
#		# Getting pathes
#		my $path = &WC::HTML::Open::Types::get_file_paths($file_ENC);
#
#		my $result = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="96" height="20">';
#		$result .= '<param name="allowScriptAccess" value="sameDomain" />';
#		$result .= '<param name="movie" value="audio_player.swf?file='.$path->{'open'}.'" />';
#		$result .= '<param name="quality" value="high" />';
#		$result .= '<param name="bgcolor" value="#ffffff" />';
#		$result .= '<embed src="audio_player.swf?file='.$path->{'open'}.'" quality="high" bgcolor="#ffffff" width="96" height="20" name="audio_flashplayer" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />';
#		$result .= '</object>';
#		#$result = '';
#		#$result .= $path->{'open'};
#
#		# Making and returning result
#		return &WC::HTML::UI::open_container($file_ENC,
#			$result,
#			{ 'DOWNLOAD' => $path->{'download'} }
#		);
#	},
	'png' => sub {
		my ($file) = @_;

		# Converting encoding
		my $file_ENC = $file;
		&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$file_ENC);
		# Getting pathes
		my $path = &WC::HTML::Open::Types::get_file_paths($file_ENC);

		# Making and returning result
		return &WC::HTML::UI::open_container($file_ENC,
			'<img src="'.$path->{'open'}.'" />'.
			#$path->{'open'}.
			'',
			{ 'DOWNLOAD' => $path->{'download'} }
		);
	}
};

# Aliases
foreach (split (/\n/, <<END
txt		html htm text cgi pl py php php4 php5 ini cfg conf inc cpp c h
png		jpg jpeg jpe gif bmp tiff ico
END
)) {
	# If format valid - making adding to HASH
	if ($_ =~ /^[ \s\t]{0,}([^ \s\t]+)[ \s\t]{1,}(.+)$/) {
		my $type = $1;
		my @arr_ext = split(/ /, &NL::String::str_trim($2));
		foreach (@arr_ext) {
			$WC::HTML::Open::Types::ALL->{ $_ } = $WC::HTML::Open::Types::ALL->{ $type } if (defined $WC::HTML::Open::Types::ALL->{ $type });
		}
	}
}

1; #EOF
