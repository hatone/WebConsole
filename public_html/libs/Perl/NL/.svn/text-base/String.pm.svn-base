#!/usr/bin/perl
# NL::String - mostNeeded Libs :: Strings processing library
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY

package NL::String;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

sub re_replace {
	my ($in_val, $ref_arr_REPLACE) = @_;

	my $tmp_ref = ref $in_val;
	my $ref_to_value;
	if ($tmp_ref) {
		if ($tmp_ref eq 'SCALAR') { $ref_to_value = $in_val; }
		else { return 0; }
	}
	else { $ref_to_value = \$in_val; }

	# Array must be ordered list
	foreach my $arr_element (@{ $ref_arr_REPLACE }) {
		foreach (keys %{ $arr_element }) {
			${$ref_to_value} =~ s/$_/$arr_element->{$_}/g;
		}
	}

	if (!ref $ref_to_value) { return 1; }
	else { return ${$ref_to_value}; }
}
# Simple string 'trim' function implementation to strip whitespace from a start/end of the string
sub str_trim { return &re_replace($_[0], [{qr/^\s+/ => '', qr/\s+$/ => ''}]); }
# Converting TEXT to JS value analog
sub str_JS_value {
	my ($in_val) = @_;

	return &re_replace($in_val, [
		{ qr/\\/ => '\\\\' },
		{ qr/'/ => '\\\'', qr/"/ => '\\"' },
		{ qr/\t/ => '\\t', qr/\n/ => '\\n', qr/\r/ => '\\r' }
	]);
}
# Converting TEXT to HTTP REQUEST value
sub str_HTTP_REQUEST_value {
	my ($in_val) = @_;

	my $tmp_ref = ref $in_val;
	my $ref_to_value;
	if ($tmp_ref) {
		if ($tmp_ref eq 'SCALAR') { $ref_to_value = $in_val; }
		else { return 0; }
	}
	else { $ref_to_value = \$in_val; }

	# Converting
	${ $ref_to_value } =~ s/(.)/sprintf("%"."%"."%x", ord($1))/eg;

	if (!ref $ref_to_value) { return 1; }
	else { return ${$ref_to_value}; }
}
# Converting TEXT to simple HTML analog
sub str_HTML { return &str_HTML_full(@_); }
# Converting TEXT to FULL HTML
sub str_HTML_full {
	my ($in_val) = @_;

	return &re_replace($in_val, [
		{ qr/&/ => '&amp;' },
		{ qr/</ => '&lt;', qr/>/ => '&gt;' },
		{ qr/"/ => '&quot;' },
		{ qr/ / => '&nbsp;', qr/\t/ => '&nbsp;' x 4 },
		{ qr/\n/ => '<br />' }
	]);
}
# Converting TEXT to HTML input value analog
sub str_HTML_value {
	my ($in_val) = @_;

	return &re_replace($in_val, [
		{ qr/&/ => '&amp;' },
		{ qr/</ => '&lt;', qr/>/ => '&gt;' },
		{ qr/"/ => '&quot;' }
	]);
}
# Getting left part of string
sub get_left {
	my ($in_val, $in_len, $in_add_dottes) = @_;
	$in_add_dottes = 0 if (!defined $in_add_dottes);

	my $len_needed = $in_len;
	my $add_dottes = 0;
	if ($in_add_dottes && $in_len >= 3) {
		$len_needed = $in_len - 3;
		$add_dottes = 1;
	}
	my $str_len = length($in_val);
	if ($str_len > $len_needed) {
		$in_val = substr($in_val, 0, $len_needed).( ($add_dottes) ? '...' : '' );
	}
	return $in_val;
}
# Getting right part of string
sub get_right {
	my ($in_val, $in_len, $in_add_dottes) = @_;
	$in_add_dottes = 0 if (!defined $in_add_dottes);

	my $len_needed = $in_len;
	my $add_dottes = 0;
	my $str_len = length($in_val);
	if ($str_len > $len_needed) {
		if ($in_add_dottes && $in_len >= 3) {
			$len_needed = $in_len - 3;
			$add_dottes = 1;
		}
		$in_val = ( ($add_dottes) ? '...' : '' ).substr($in_val, $str_len - $len_needed);
	}
	return $in_val;
}
# Getting string of bytes at human readable format
sub get_str_of_bytes {
	my ($in_bytes) = @_;

	my @arr_SIZE = ('Kb', 'MB', 'GB');
	my $arr_SIZE_length = scalar @arr_SIZE;

	my $size = $in_bytes;
	my $size_i = -1;
	for (my $i = 0; $i < $arr_SIZE_length; $i++) {
		my $new_size = $size/1024;
		if ($new_size >= 1) { $size = $new_size; $size_i = $i; }
		else { last; }
	}
	$size = sprintf("%.2f", $size);
	$size =~ s/(\.[^0]{0,})0+$/$1/;
	$size =~ s/\.$//;
	return $size.' '.($size_i >= 0 ? $arr_SIZE[$size_i] : 'byte(s)');
}
# Parsing JSON string and converting it to HASH (very simple realization)
sub JSON_to_HASH {
	my ($in_value) = @_;

	if (defined $in_value && $in_value ne '') {
		$in_value =~ s/("(\\"|[^"])+"|([^ ,"\n\t])+)[ \n\t]{0,}:[ \n\t]{0,}("(\\"|[^"])+"|([^ ,\n\t])+)/$1 => $4/g;
		my $result_HASH = {};
		eval '$result_HASH = '.$in_value.';';
		if ($@) { return { 'ID' => 0, 'HASH' => {}, 'ERROR' => $@ }; }
		else { return { 'ID' => 1, 'HASH' => $result_HASH }; }
	}
	return { 'ID' => 1, 'HASH' => {} };
}
# Converting STRING to LINE
sub str_to_line {
	my ($in_val) = @_;
	return '' if (!defined $in_val);

 	my $ref_arr_RE = [
		{qr/\r/ => ''},
		{qr/\n+/ => ' '},
		{qr/\t+/ => ' '},
		{qr/ {2,}/ => ' '}
	];

	return &re_replace($in_val, $ref_arr_RE);
}
# Converting escaped characters like [\\n\\r\\t\\...] into [\n\r\t\...]
sub str_unescape {
	my ($in_val) = @_;
	return '' if (!defined $in_val);

	# Making REF
	my $tmp_ref = ref $in_val;
	my $ref_to_value;
	if ($tmp_ref) {
		if ($tmp_ref eq 'SCALAR') { $ref_to_value = $in_val; }
		else { return 0; }
	}
	else { $ref_to_value = \$in_val; }
	# Making UNESCAPE
	my $len = length(${$ref_to_value});
	for (my $i = 0; $i < $len; $i++) {
		if (substr(${$ref_to_value}, $i, 1) eq "\\") {
			if ($i + 1 < $len) {
				my $next = substr(${$ref_to_value}, $i + 1, 1);
				if ($next eq 'n') { substr(${$ref_to_value}, $i, 2) = "\n";  }
				elsif ($next eq 't') { substr(${$ref_to_value}, $i, 2) = "\t";  }
				elsif ($next eq 'r') { substr(${$ref_to_value}, $i, 2) = "\r";  }
				elsif ($next eq "\\") { substr(${$ref_to_value}, $i, 2) = "\\"; }
				else { substr(${$ref_to_value}, $i, 1) = ''; }
			}
			else { substr(${$ref_to_value}, $i, 1) = ''; }
			$len--;
		}
	}
	# Returning result
	if (!ref $ref_to_value) { return 1; }
	else { return ${$ref_to_value}; }
}
# Converting escape characters like [\n\r\t...] into [\\n\\r\\t...] for their definition as a text
sub str_escape {
	my ($in_val, $in_type) = @_;
	return '' if (!defined $in_val);
	$in_type = 'PERL' if (!defined $in_type || $in_type eq '');

 	my $ref_arr_RE = [
		{qr/\\/ => '\\\\'},
		# {qr/\b/ => '\\b'},
		{qr/"/ => '\\"'},
		{qr/\t/ => '\\t'},
		{qr/\n/ => '\\n'},
		{qr/\r/ => '\\r'}
	];
 	push @{ $ref_arr_RE }, {qr/\@/ => '\\@'}, {qr/\$/ => '\\$'} if ($in_type eq 'PERL');

	return &re_replace($in_val, $ref_arr_RE);
}
sub str_escape_JSON { return &str_escape($_[0], 'JSON'); }

# Converting VAR data into a text definition at PERL
sub VAR_to_PERL { return &_VAR_to_STRING($_[0], 'PERL', (defined $_[1]) ? $_[1] : {}); }
# Converting VAR data into a text definition at JSON
sub VAR_to_JSON { return &_VAR_to_STRING($_[0], 'JSON', (defined $_[1]) ? $_[1] : {}); }
# Converting VAR data into a text definition
sub _VAR_to_STRING {
	my ($in_DATA, $in_type, $in_SETTINGS, $in_recursion_level) = @_;
	$in_DATA = '' if (!defined $in_DATA);
	$in_type = 'PERL' if (!defined $in_type || $in_type eq '');
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_recursion_level = 0 if (!defined $in_recursion_level);

	my $use_spaces = (defined $in_SETTINGS->{'SPACES'} && $in_SETTINGS->{'SPACES'}) ? 1 : 0;
	my $tabs_string = '';
	$tabs_string .= "\t" x $in_recursion_level if ($use_spaces);

	my $elements = { 'hash_splitter' => '=>' };
	my $ref_SUB_escape = \&str_escape;
	if ($in_type eq 'JSON') {
		$elements->{'hash_splitter'} = ':';
		$ref_SUB_escape = \&str_escape_JSON;
	}

	my $str_RESULT = '';
	my $type = ref($in_DATA);
	if ($type) {
		if ($type eq 'HASH') {
			foreach ( (defined $in_SETTINGS->{'SORT'} && $in_SETTINGS->{'SORT'}) ? sort keys %{ $in_DATA } : keys %{ $in_DATA }) {
				$str_RESULT .= ','.( ($use_spaces) ? "\n" : '' ) if ($str_RESULT ne '');
				$str_RESULT .= ( ($use_spaces) ? $tabs_string."\t" : '' ).'"'.( &{ $ref_SUB_escape }($_) ).'"'.( ($use_spaces && $in_type ne 'JSON') ? ' ' : '' ).$elements->{'hash_splitter'}.( ($use_spaces) ? ' ' : '' ).( &_VAR_to_STRING($in_DATA->{$_}, $in_type, $in_SETTINGS, $in_recursion_level + 1) );
			}
			return '{'.( ($use_spaces) ? "\n" : '' ).$str_RESULT.( ($use_spaces) ? "\n".$tabs_string : '' ).'}';
		}
		elsif ($type eq 'ARRAY') {
			foreach (@{ $in_DATA }) {
				$str_RESULT .= ','.( ($use_spaces) ? "\n" : '' ) if ($str_RESULT ne '');
				$str_RESULT .= ( ($use_spaces) ? $tabs_string."\t" : '' ).&_VAR_to_STRING($_, $in_type, $in_SETTINGS, $in_recursion_level + 1);
			}
			return '['.( ($use_spaces) ? "\n" : '' ).$str_RESULT.( ($use_spaces) ? "\n".$tabs_string : '' ).']';
		}
	}
	else {
		if ($in_DATA =~ /^(\d+|\d+\.\d+)$/ && $in_DATA !~ /(^0\d|00$)/) { return $in_DATA; }
		else { return '"'.( &{ $ref_SUB_escape }($in_DATA) ).'"'; }
	}
}

sub fix_width {
	my ($in_DATA, $in_LEN) = @_;
	$in_LEN = 50 if (!defined $in_LEN || $in_LEN < 0);

	my $re_SPACES = ' \t\n';
	my $i = 0;

	$in_DATA =~ s/\r//g;
	my $LEN = length($in_DATA);
	while ($i < $LEN) {
		my $new_pos = $i + $in_LEN;
		if ($new_pos < $LEN) {
			my $char = substr($in_DATA, $new_pos, 1);
			if ($char =~ /^[${re_SPACES}]$/) {
				substr($in_DATA, $new_pos, 1, "\n");
				$new_pos++;
			}
			else {
				my $sub_str = substr($in_DATA, $i, $in_LEN);
				if ($sub_str =~ /[${re_SPACES}][^${re_SPACES}]{0,}$/) {
					my $pos = $-[ $#- ];
					substr($in_DATA, $i + $pos, 1, "\n");
					$new_pos = $i + $pos + 1;
				}
				else {
					substr($in_DATA, $new_pos, 0, "\n");
					$new_pos++;
				}
			}
		}
		$i = $new_pos;
	}
	return $in_DATA;
}

1; #EOF
