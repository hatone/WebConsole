#!/usr/bin/perl
# WC::Crypt::Base64 - Web Console 'Base64' module, contains methods for BASE64 encode/decode implementation
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Crypt::Base64;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Crypt::Base64::MIME_BASE64_ON = 1;
eval { require MIME::Base64; }; # If we can - we will use 'MIME::Base64', that is much more faster
$WC::Crypt::Base64::MIME_BASE64_ON = 0 if $@; # We can't use it

sub encode {
	if ($WC::Crypt::Base64::MIME_BASE64_ON) { return &MIME::Base64::encode(@_); }
	else { return &WC::Crypt::Base64::REDISTR::old_encode_base64(@_); }
}
sub decode {
	if ($WC::Crypt::Base64::MIME_BASE64_ON) { return &MIME::Base64::decode(@_); }
	else { return &WC::Crypt::Base64::REDISTR::old_decode_base64(@_); }
}

# REDISTRIBUTED OLD VERSION OF MODULE 'MIME::Base64'
# We include that modules here to be maximum modules independed
# If we can - we will use allready installed module 'MIME::Base64'
{
	# MIME::Base64 - copy from (perl-5.8.1)
	package WC::Crypt::Base64::REDISTR;
	use strict;
	use integer;

	sub old_encode_base64 ($;$)
	{
	    my $eol = $_[1];
	    $eol = "\n" unless defined $eol;

	    my $res = pack("u", $_[0]);
	    # Remove first character of each line, remove newlines
	    $res =~ s/^.//mg;
	    $res =~ s/\n//g;

	    $res =~ tr|` -_|AA-Za-z0-9+/|;               # `# help emacs
	    # fix padding at the end
	    my $padding = (3 - length($_[0]) % 3) % 3;
	    $res =~ s/.{$padding}$/'=' x $padding/e if $padding;
	    # break encoded string into lines of no more than 76 characters each
	    if (length $eol) {
		$res =~ s/(.{1,76})/$1$eol/g;
	    }
	    return $res;
	}
	sub old_decode_base64 ($)
	{
	    local($^W) = 0; # unpack("u",...) gives bogus warning in 5.00[123]

	    my $str = shift;
	    $str =~ tr|A-Za-z0-9+=/||cd;            # remove non-base64 chars
	    if (length($str) % 4) {
		require Carp;
		Carp::carp("Length of base64 data not a multiple of 4")
	    }
	    $str =~ s/=+$//;                        # remove padding
	    $str =~ tr|A-Za-z0-9+/| -_|;            # convert to uuencoded format
	    return "" unless length $str;

	    ## I guess this could be written as
	    #return unpack("u", join('', map( chr(32 + length($_)*3/4) . $_,
	    #			$str =~ /(.{1,60})/gs) ) );
	    ## but I do not like that...
	    my $uustr = '';
	    my ($i, $l);
	    $l = length($str) - 60;
	    for ($i = 0; $i <= $l; $i += 60) {
		$uustr .= "M" . substr($str, $i, 60);
	    }
	    $str = substr($str, $i);
	    # and any leftover chars
	    if ($str ne "") {
		$uustr .= chr(32 + length($str)*3/4) . $str;
	    }
	    return unpack ("u", $uustr);
	}
}

1; #EOF
