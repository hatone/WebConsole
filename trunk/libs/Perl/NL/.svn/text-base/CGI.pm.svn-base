#!/usr/bin/perl
# NL::CGI - mostNeeded Libs :: CGI input parameters processing
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY

package NL::CGI;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$NL::CGI::DATA = {
	'CONST' => {},
	'DYNAMIC' => {
		'ENABLE_MULTI_VALUES' => 0
	}
};
our $CRLF = '';
if ($^O =~ /^VMS/i) { $CRLF = "\n"; }
elsif ("\t" ne "\011") { $CRLF= "\r\n"; }
else { $CRLF = "\015\012"; }
our $CRLF_len = length($CRLF);

sub init {
	my ($in_SUB_decode_function, $in_ENABLE_MULTI_VALUES) = @_;
	&set_decode_function($in_SUB_decode_function) if (defined $in_SUB_decode_function);
	$NL::CGI::DATA->{'DYNAMIC'}->{'ENABLE_MULTI_VALUES'} = 1 if (defined $in_ENABLE_MULTI_VALUES && $in_ENABLE_MULTI_VALUES == 1);
}
sub set_decode_function {
	my ($in_SUB_decode_function) = @_;
	$NL::CGI::DATA->{'DYNAMIC'}->{'FUNC_decode'} = $in_SUB_decode_function if (defined $in_SUB_decode_function && ref $in_SUB_decode_function eq 'CODE');
}
sub _decode_data {
	my ($in_REF_SCALAR_data) = @_;
	if (defined $NL::CGI::DATA->{'DYNAMIC'}->{'FUNC_decode'} && defined $in_REF_SCALAR_data) {
		&{ $NL::CGI::DATA->{'DYNAMIC'}->{'FUNC_decode'} }($in_REF_SCALAR_data);
	}
}

sub get_input_from_GET { return &_get_input_GET( (defined $_[0] && $_[0] == 0) ? 0 : 1 ); }
sub get_input_from_POST { return &_get_input_POST( (defined $_[0] && $_[0] == 0) ? 0 : 1 ); }
sub get_input_from_POST_FILE { return {} if (!defined $_[0] || $_[0] eq ''); return &_get_input_POST(0, $_[0]); }
sub get_input {
	my $ref_HASH_GET = &_get_input_GET(1);
	my $ref_HASH_POST = &_get_input_POST(1);

	foreach (keys %{ $ref_HASH_GET }) {
		$ref_HASH_POST->{ $_ } = $ref_HASH_GET->{ $_ } if (!defined $ref_HASH_POST->{ $_ });
	}
	return $ref_HASH_POST;
}

sub _get_input_POST {
	my ($in_USE_CACHE, $in_READ_filename) = @_;
	$in_USE_CACHE = 0 if (!defined $in_USE_CACHE);
	$in_READ_filename = '' if (!defined $in_READ_filename);
	return $NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_POST'} if ($in_USE_CACHE && defined $NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_POST'});

	my $ref_hash_PARAMS = {};
	my $tmp_buffer = '';
	my $PARSE_BUFFER = 0;

	my $boundary = '';
	if ($in_READ_filename ne '') {
		if (-f $in_READ_filename) {
			my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size, $atime, $mtime, $ctime, $blksize, $blocks) = stat($in_READ_filename);
			if ($size > 0 && open(FILE_IN, "<$in_READ_filename")) {
				binmode FILE_IN;
				seek(FILE_IN, 0, 0);
				read(FILE_IN, $tmp_buffer, $size);
				close (FILE_IN);

				if ($tmp_buffer =~ /^(.*)$CRLF/) {
					if (length($1) <= 256) {
						$boundary = $1;
						$PARSE_BUFFER = 1;
					}
				}
			}
		}
	}
	elsif (defined $ENV{'REQUEST_METHOD'} && $ENV{'REQUEST_METHOD'} eq 'POST' && defined $ENV{'CONTENT_LENGTH'}) {
		# multipart/form-data (THAT IS VERY SIMPLE 'multipart/form-data' SUPPORT - NOT FULLY FEATURED)
		if (defined $ENV{'CONTENT_TYPE'} && $ENV{'CONTENT_TYPE'} =~ m/^multipart\/form-data/) {
			# Read STDIN to buffer
			binmode(STDIN);
			seek(STDIN, 0, 0);
			read(STDIN, $tmp_buffer, $ENV{'CONTENT_LENGTH'});
			($boundary) = $ENV{'CONTENT_TYPE'} =~ /boundary=\"?([^\";,]+)\"?/; # From CGI.pm
			$boundary = '--'.$boundary;
			$PARSE_BUFFER = 1;
		}
		else {
			read(STDIN, $tmp_buffer, $ENV{'CONTENT_LENGTH'});
			if ($tmp_buffer !~ /^[\s]{0,}$/) {
				$ref_hash_PARAMS = &_get_input_GET(0, \$tmp_buffer);
			}
		}
	}

	if ($PARSE_BUFFER) {
		if (defined $boundary && $boundary ne '') {
			$tmp_buffer = substr($tmp_buffer, length($boundary)+$CRLF_len, index($tmp_buffer, $boundary.'--'.$CRLF) - $CRLF_len - length($boundary));
			# Parse buffer
			for (split(/$boundary$CRLF/, $tmp_buffer)) {
				$_ = substr($_, 0, length($_) - $CRLF_len);
				my $pos = index($_, $CRLF.$CRLF);
				my $header = substr($_, 0, $pos);

				my $value  = substr($_, $pos + 2*$CRLF_len);
				my ($name) = $header =~ / name="([^;]*)"/; # From CGI.pm

				if (defined $name && $name ne '' && defined $value) {
					# Uploading file
					if ($header =~ /filename=/) {
						my ($fname) = $header =~ / filename="([^;]*)"/; # From CGI.pm
						if (defined $fname && $fname ne '') {
							my ($fCT) = $header =~ /Content-Type: (.*)($CRLF|$)/;
							&_add_param_file($ref_hash_PARAMS, \$name, \$fname, \$value, (defined $fCT && $fCT !~ /^[\s]{0,}$/) ? $fCT : '');
						}

					}
					# Usual variable
					else { &_add_param($ref_hash_PARAMS, \$name, \$value); }
				}
			}
		}
	}
	if ($in_USE_CACHE) {
		$NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_POST'} = $ref_hash_PARAMS;
		my %return_HASH = %{ $ref_hash_PARAMS };
		return \%return_HASH;
	}
	else { return $ref_hash_PARAMS; }
}
sub _get_input_GET {
	my ($in_USE_CACHE, $in_REF_val) = @_;
	$in_USE_CACHE = 0 if (!defined $in_USE_CACHE);
	$in_REF_val = 0 if (!defined $in_REF_val);
	return $NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_GET'} if ($in_USE_CACHE && defined $NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_GET'});

	my $ref_hash_PARAMS = {};
	my $tmp_buffer = '';
	if ($in_REF_val) { $tmp_buffer = ${ $in_REF_val }; }
	elsif (defined $ENV{'QUERY_STRING'} && $ENV{'QUERY_STRING'} ne '') { $tmp_buffer = $ENV{'QUERY_STRING'}; }

	if ($tmp_buffer ne '') {
		$tmp_buffer =~ s/&(?!amp;)/&amp;/g; # XHTML standard
		for ( split(/&amp;/, $tmp_buffer) ) {
			if ($_ =~ /^([^\=]+)\=(.*)$/) {
				my ($name, $value) = ($1, $2);
				if (defined $name && $name ne '' && defined $value) {
					for ($name, $value) {
						tr/+/ /;
						s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
					}
					&_add_param($ref_hash_PARAMS, \$name, \$value);
				}
			}
		}
	}
	if ($in_USE_CACHE) {
		$NL::CGI::DATA->{'DYNAMIC'}->{'CACHE_GET'} = $ref_hash_PARAMS;
		my %return_HASH = %{ $ref_hash_PARAMS };
		return \%return_HASH;
	}
	else { return $ref_hash_PARAMS; }
}

# Adding new parameter info into HASH
sub _add_param {
	my ($in_REF_HASH, $in_REF_name, $in_REF_value) = @_;

	if (defined $in_REF_name && ${ $in_REF_name } ne '' && defined $in_REF_value) {
		&_decode_data($in_REF_name);
		&_decode_data($in_REF_value);

		if (!defined $in_REF_HASH->{ ${ $in_REF_name } }) { $in_REF_HASH->{ ${ $in_REF_name } } = ${ $in_REF_value }; }
		else {
			if (!$NL::CGI::DATA->{'DYNAMIC'}->{'ENABLE_MULTI_VALUES'}) { return; }
			if (ref $in_REF_HASH->{ ${ $in_REF_name } }) { push(@{ $in_REF_HASH->{ ${ $in_REF_name } } }, ${ $in_REF_value }); }
			else { $in_REF_HASH->{ ${ $in_REF_name } } = [$in_REF_HASH->{ ${ $in_REF_name } }, ${ $in_REF_value }]; }
		}
	}
}
# Adding new file info into HASH
sub _add_param_file {
	my ($in_REF_HASH, $in_REF_name, $in_REF_fname, $in_REF_fvalue, $in_ContentType) = @_;
	$in_ContentType = '' if (!defined $in_ContentType);

	if (defined $in_REF_name && ${ $in_REF_name } ne '' && defined $in_REF_fname && ${ $in_REF_fname } ne '' && defined $in_REF_fvalue) {
		&_decode_data($in_REF_name);
		&_decode_data($in_REF_fname);
		my $file_container = { 'filename' => ${ $in_REF_fname }, 'data' => ${ $in_REF_fvalue } };
		$file_container->{'content-type'} = $in_ContentType if ($in_ContentType ne '');
		# $fname = substr($fname, rindex($fname, "\\") + 1) if $fname;

		if (!defined $in_REF_HASH->{ ${ $in_REF_name } }) { $in_REF_HASH->{ ${ $in_REF_name } } = $file_container; }
		else {
			if (!$NL::CGI::DATA->{'DYNAMIC'}->{'ENABLE_MULTI_VALUES'}) { return; }
			if (ref $in_REF_HASH->{ ${ $in_REF_name } } eq 'ARRAY') {
				push(@{ $in_REF_HASH->{ ${ $in_REF_name } } }, $file_container);
			}
			else {
				$in_REF_HASH->{ ${ $in_REF_name } } = [ $in_REF_HASH->{ ${ $in_REF_name } }, $file_container ];
			}
		}
	}
}

1; #EOF
