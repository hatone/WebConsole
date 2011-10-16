#!/usr/bin/perl
# WC::Encode - Web Console encodings manipulations
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Encode;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# LOADING NEEDED MODULES
# POSIX used in 'WC::EXEC::init()'
$WC::Encode::POSIX_ON = 1;
eval { require POSIX; }; # If we can - we will use 'POSIX' localization
if ($@) {
	# We can't use it
	$WC::Encode::POSIX_ON = 0;
	$WC::Encode::POSIX_ERROR = $@;
}

$WC::Encode::ENCODE_ON = 1;
eval { require Encode; }; # If we can - we will use 'Encode'
if ($@) {
	# We can't use it
	$WC::Encode::ENCODE_ON = 0;
	$WC::Encode::ENCODE_ERROR = $@;
}

# Initialization of 'WC::Encode', called always first
# IN: NOTHING
# RETURN: NOTHING
sub init {
	$WC::c->{'config'}->{'encodings'} = {} if (!defined $WC::c->{'config'}->{'encodings'});
	$WC::c->{'config'}->{'encodings'}->{'internal'} = 'utf8' if (!defined $WC::c->{'config'}->{'encodings'}->{'internal'});
	$WC::c->{'config'}->{'encodings'}->{'server_console'} = '' if (!defined $WC::c->{'config'}->{'encodings'}->{'server_console'});
	$WC::c->{'config'}->{'encodings'}->{'server_system'} = '' if (!defined $WC::c->{'config'}->{'encodings'}->{'server_system'});
	$WC::c->{'config'}->{'encodings'}->{'editor_text'} = '' if (!defined $WC::c->{'config'}->{'encodings'}->{'editor_text'});
	$WC::c->{'config'}->{'encodings'}->{'file_download'} = '' if (!defined $WC::c->{'config'}->{'encodings'}->{'file_download'});

	# Setting 'server_console' and 'server_system'
	if ($WC::c->{'config'}->{'encodings'}->{'server_console'} ne '') {
		if ($WC::c->{'config'}->{'encodings'}->{'server_system'} eq '') {
			$WC::c->{'config'}->{'encodings'}->{'server_system'} = $WC::c->{'config'}->{'encodings'}->{'server_console'}
		}
	}
	else {
		if ($WC::c->{'config'}->{'encodings'}->{'server_console'} eq '') {
			$WC::c->{'config'}->{'encodings'}->{'server_console'} = $WC::c->{'config'}->{'encodings'}->{'server_system'}
		}
	}
}
# Check is we can use 'Encode' module
# IN: NOTHING
# RETURN: 1 - yes | 0 - no
sub IS_ENCODE_ON { return $WC::Encode::ENCODE_ON; }
# Check is we can use 'POSIX' module
# IN: NOTHING
# RETURN: 1 - yes | 0 - no
sub IS_POSIX_ON { return $WC::Encode::POSIX_ON; }
# Check is we can use full featured 'WC::Encode' module
# IN: NOTHING
# RETURN: 1 - yes | 0 - no
sub IS_ON { return ($WC::Encode::ENCODE_ON && $WC::Encode::POSIX_ON) ? 1 : 0; }
# Getting encoding value of something
# IN: STRING
# RETURN: STRING
sub get_encoding {
	my ($in_NAME) = @_;
	if (defined $in_NAME && $in_NAME ne '' && defined $WC::c->{'config'}->{'encodings'}->{ $in_NAME }) {
		return $WC::c->{'config'}->{'encodings'}->{ $in_NAME };
	}
	return '';
}
# Encoding data FROM something TO something
# IN: STRING - what to encode, STRING - encoding from, STRING - encoding to
# RETURN: 0 - 'WC::Encode' module is OFF | RETURN_FROM 'Encode::from_to'
sub encode_FROM_TO {
	if ($WC::Encode::ENCODE_ON) { return &Encode::from_to(@_); }
	else { return 0; }
}
# Encoding data from CGI
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_CGI {
	my ($in_ref_val) = @_;

	if ($WC::Encode::ENCODE_ON) {
		# Decoding UCS-2BE from JsHttpRequest
		my $server_system_encoding = ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne '') ? $WC::c->{'config'}->{'encodings'}->{'server_system'} : 'utf8';
		if (index(${ $in_ref_val }, '%u') >= 0) { ${ $in_ref_val } =~ s/%u([0-9A-Fa-f]{1,4})/&_encode_from_CGI_UCS_2BE($1, $server_system_encoding)/eg; }
	}
}
# Encoding character from UCS-2BE (used by 'encode_from_CGI' only)
# IN: CHARACTER
# RETURN: CHARACTER
sub _encode_from_CGI_UCS_2BE {
	my ($in_char, $in_ENCODING) = @_;

	$in_char = pack('n', hex($in_char));
	&encode_FROM_TO($in_char, 'UCS-2BE', $in_ENCODING);
	return $in_char;
}
# Encoding data from CONSOLE to SYSTEM
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_CONSOLE_to_SYSTEM {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'server_console'} ne '' && $WC::c->{'config'}->{'encodings'}->{'server_system'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'server_console'} ne $WC::c->{'config'}->{'encodings'}->{'server_system'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'server_console'}, $WC::c->{'config'}->{'encodings'}->{'server_system'});
			}
		}
	}
}
# Encoding data from CONSOLE to INTERNAL
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_CONSOLE_to_INTERNAL {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'server_console'} ne '' && $WC::c->{'config'}->{'encodings'}->{'internal'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'server_console'} ne $WC::c->{'config'}->{'encodings'}->{'internal'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'server_console'}, $WC::c->{'config'}->{'encodings'}->{'internal'});
			}
		}
	}
}
# Encoding data from SYSTEM to INTERNAL
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_SYSTEM_to_INTERNAL {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne '' && $WC::c->{'config'}->{'encodings'}->{'internal'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne $WC::c->{'config'}->{'encodings'}->{'internal'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'server_system'}, $WC::c->{'config'}->{'encodings'}->{'internal'});
			}
		}
	}
}
# Encoding data from INTERNAL to CONSOLE
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_INTERNAL_to_CONSOLE {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'server_console'} ne '' && $WC::c->{'config'}->{'encodings'}->{'internal'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'server_console'} ne $WC::c->{'config'}->{'encodings'}->{'internal'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'internal'}, $WC::c->{'config'}->{'encodings'}->{'server_console'});
			}
		}
	}
}
# Encoding data from INTERNAL to SYSTEM
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_INTERNAL_to_SYSTEM {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne '' && $WC::c->{'config'}->{'encodings'}->{'internal'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne $WC::c->{'config'}->{'encodings'}->{'internal'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'internal'}, $WC::c->{'config'}->{'encodings'}->{'server_system'});
			}
		}
	}
}
# Encoding data from FILE to SYSTEM
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_FILE_to_SYSTEM {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne '' && $WC::c->{'config'}->{'encodings'}->{'editor_text'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne $WC::c->{'config'}->{'encodings'}->{'editor_text'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'editor_text'}, $WC::c->{'config'}->{'encodings'}->{'server_system'});
			}
		}
	}
}
# Encoding data from SYSTEM to FILE
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_SYSTEM_to_FILE {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne '' && $WC::c->{'config'}->{'encodings'}->{'editor_text'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne $WC::c->{'config'}->{'encodings'}->{'editor_text'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'server_system'}, $WC::c->{'config'}->{'encodings'}->{'editor_text'});
			}
		}
	}
}
# Encoding data from SYSTEM to DOWNLOADING FILE
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_SYSTEM_to_FILE_DOWNLOAD {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne '' && $WC::c->{'config'}->{'encodings'}->{'file_download'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'server_system'} ne $WC::c->{'config'}->{'encodings'}->{'file_download'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'server_system'}, $WC::c->{'config'}->{'encodings'}->{'file_download'});
			}
		}
	}
}
# Encoding data from INTERNAL to DOWNLOADING FILE
# IN: STRING_REF
# RETURN: NOTHING
sub encode_from_INTERNAL_to_FILE_DOWNLOAD {
	my ($in_ref_val) = @_;
	if ($WC::Encode::ENCODE_ON) {
		if ($WC::c->{'config'}->{'encodings'}->{'internal'} ne '' && $WC::c->{'config'}->{'encodings'}->{'file_download'} ne '') {
			if ($WC::c->{'config'}->{'encodings'}->{'internal'} ne $WC::c->{'config'}->{'encodings'}->{'file_download'}) {
				&encode_FROM_TO(${ $in_ref_val }, $WC::c->{'config'}->{'encodings'}->{'internal'}, $WC::c->{'config'}->{'encodings'}->{'file_download'});
			}
		}
	}
}

1; #EOF
