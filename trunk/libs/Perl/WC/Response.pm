#!/usr/bin/perl
# WC::Response - Web Console 'Response' module, contains methods for sending Response to client browser
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Response;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Printing HTTP header
# IN: STRING - header 1, STRING - header 2, STRING - header 3...
# RETURN: NOTHING
sub print_HTTP_HEADER {
	foreach (@{ $WC::CONST->{'HTTP_EXTRA_HEADERS'} }) { print $_."\r\n" if ($_ !~ /^\s{0,}$/); }
	print "Content-type: text/html; charset=utf-8\r\n";
	foreach (@_) { print $_."\r\n" if ($_ !~ /^\s{0,}$/); }
	print "\r\n";
}
# Printing HTTP PAGE
# IN: STRING - page ID, HASH_REF - additional page parameters
# RETURN: NOTHING
sub show_HTML_PAGE {
	my ($in_PAGE_ID, $in_STASH) = @_;
	$in_PAGE_ID = '' if (!defined $in_PAGE_ID);
	$in_STASH = {} if (!defined $in_STASH);

	&print_HTTP_HEADER();
	&WC::HTML::show_page($in_PAGE_ID, $in_STASH);
}
# Printing AJAX response
# IN: STRING - action, STRING - text, HASH_REF - action parameters, HASH_REF - stash
# RETURN: NOTHING
sub show_AJAX_RESPONSE { return &WC::AJAX::show_response(@_); }
# Printing AJAX response and do not converting encoding of '$in_TEXT'
# IN: STRING - action, STRING - text, HASH_REF - action parameters, HASH_REF - stash
# RETURN: NOTHING
sub show_AJAX_RESPONSE_NO_TEXT_ENCODE { return &WC::AJAX::show_response_NO_TEXT_ENCODE(@_); }

# Printing ERROR wrappers (with headers)
# IN: STRING - message, STRING - info, STRING - id
# RETURN: NOTHING
sub show_error() {
	if ($WC::c->{'res'}->{'type'} eq 'HTML') { &show_error_HTML(@_); }
	elsif ($WC::c->{'res'}->{'type'} eq 'AJAX') { &show_error_AJAX(@_); }
	else { &show_error_TEXT(@_); }
}
sub show_error_HTML() { &_print_MESSAGE('HTML', 'ERROR', 1, @_); }
sub show_error_AJAX() { &_print_MESSAGE('AJAX', 'ERROR', 1, @_); }
sub show_error_TEXT() { &_print_MESSAGE('TEXT', 'ERROR', 1, @_); }
# Printing ERROR wrappers (without headers)
# IN: STRING - message, STRING - info, STRING - id
# RETURN: NOTHING
sub show_error_no_header() {
	if ($WC::c->{'res'}->{'type'} eq 'HTML') { &show_error_HTML_no_header(@_); }
	elsif ($WC::c->{'res'}->{'type'} eq 'AJAX') { &show_error_AJAX_no_header(@_); }
	else { &show_error_TEXT_no_header(@_); }
}
sub show_error_HTML_no_header() { &_print_MESSAGE('HTML', 'ERROR', 0, @_); }
sub show_error_AJAX_no_header() { &_print_MESSAGE('AJAX', 'ERROR', 0, @_); }
sub show_error_TEXT_no_header() { &_print_MESSAGE('TEXT', 'ERROR', 0, @_); }

# Printing INFO wrappers (with headers)
# IN: STRING - message, STRING - info, STRING - id
# RETURN: NOTHING
sub show_info() {
	if ($WC::c->{'res'}->{'type'} eq 'HTML') { &show_info_HTML(@_); }
	elsif ($WC::c->{'res'}->{'type'} eq 'AJAX') { &show_info_AJAX(@_); }
	else { &show_info_TEXT(@_); }
}
sub show_info_HTML() { &_print_MESSAGE('HTML', 'INFO', 1, @_); }
sub show_info_AJAX() { &_print_MESSAGE('AJAX', 'INFO', 1, @_); }
sub show_info_TEXT() { &_print_MESSAGE('TEXT', 'INFO', 1, @_); }
# Printing INFO wrappers (without headers)
# IN: STRING - message, STRING - info, STRING - id
# RETURN: NOTHING
sub show_info_no_header() {
	if ($WC::c->{'res'}->{'type'} eq 'HTML') { &show_info_HTML_no_header(@_); }
	elsif ($WC::c->{'res'}->{'type'} eq 'AJAX') { &show_info_AJAX_no_header(@_); }
	else { &show_info_TEXT_no_header(@_); }
}
sub show_info_HTML_no_header() { &_print_MESSAGE('HTML', 'INFO', 0, @_); }
sub show_info_AJAX_no_header() { &_print_MESSAGE('AJAX', 'INFO', 0, @_); }
sub show_info_TEXT_no_header() { &_print_MESSAGE('TEXT', 'INFO', 0, @_); }

# Printing WARNING wrappers (with headers)
# IN: STRING - message, STRING - info, STRING - id
# RETURN: NOTHING
sub show_warning() {
	if ($WC::c->{'res'}->{'type'} eq 'HTML') { &show_warning_HTML(@_); }
	elsif ($WC::c->{'res'}->{'type'} eq 'AJAX') { &show_warning_AJAX(@_); }
	else { &show_warning_TEXT(@_); }
}
sub show_warning_HTML() { &_print_MESSAGE('HTML', 'WARNING', 1, @_); }
sub show_warning_AJAX() { &_print_MESSAGE('AJAX', 'WARNING', 1, @_); }
sub show_warning_TEXT() { &_print_MESSAGE('TEXT', 'WARNING', 1, @_); }
# Printing WARNING wrappers (without headers)
# IN: STRING - message, STRING - info, STRING - id
# RETURN: NOTHING
sub show_warning_no_header() {
	if ($WC::c->{'res'}->{'type'} eq 'HTML') { &show_warning_HTML_no_header(@_); }
	elsif ($WC::c->{'res'}->{'type'} eq 'AJAX') { &show_warning_AJAX_no_header(@_); }
	else { &show_warning_TEXT_no_header(@_); }
}
sub show_warning_HTML_no_header() { &_print_MESSAGE('HTML', 'WARNING', 0, @_); }
sub show_warning_AJAX_no_header() { &_print_MESSAGE('AJAX', 'WARNING', 0, @_); }
sub show_warning_TEXT_no_header() { &_print_MESSAGE('TEXT', 'WARNING', 0, @_); }

# Printing MESSAGE
# IN: STRING - message format, STRING - message type, NUMBER - 1 - show headers | 0 - don't show headers, STRING - message, STRING - info, STRING - id
# RETURN: NOTHING
sub _print_MESSAGE {
	my ($in_format, $in_type, $in_show_header, $in_message, $in_info, $in_id) = @_;
	$in_format = 'TEXT' if (!defined $in_format || $in_format eq '');
	$in_type = 'INFO' if (!defined $in_type || $in_type eq '');
	$in_show_header = 1 if (!defined $in_show_header);
	$in_message = '' if (!defined $in_message);
	$in_info = '' if (!defined $in_info);
	$in_id = '' if (!defined $in_id);


	if ($in_format eq 'AJAX') {
		# AJAX uses itself HTTP header
		if ($in_type eq 'ERROR') { &WC::AJAX::show_error($in_message, $in_info, $in_id); }
		elsif ($in_type eq 'WARNING') { &WC::AJAX::show_warning($in_message, $in_info, $in_id); }
		elsif ($in_type eq 'INFO') { &WC::AJAX::show_info($in_message, $in_info, $in_id); }
	}
	elsif ($in_format eq 'HTML') {
		&print_HTTP_HEADER() if ($in_show_header);
		if ($in_type eq 'ERROR') { &WC::HTML::show_error($in_message, $in_info, $in_id); }
		elsif ($in_type eq 'WARNING') { &WC::HTML::show_warning($in_message, $in_info, $in_id); }
		elsif ($in_type eq 'INFO') { &WC::HTML::show_info($in_message, $in_info, $in_id); }
	}
	else {
		my $text = $WC::c->{'APP_SETTINGS'}->{'name'};
		&print_HTTP_HEADER() if ($in_show_header);
		if ($in_type eq 'ERROR') { $text .= ' ERROR:' }
		elsif ($in_type eq 'WARNING') { $text .= ' WARNING:' }
		else { $text .= ' INFO:' }
		$text .= " $in_message\n";
		$text .= "$in_info\n" if ($in_info ne '');
		if ($in_id ne '') {
			$text .= 'Solution for that problem at '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FAQ: '.$WC::CONST->{'URLS'}->{'FAQ_ID'}.$in_id;
		}
		else {
			$text .= 'You can try to find solution for that problem at '.$WC::c->{'APP_SETTINGS'}->{'name'}.' FAQ: '.$WC::CONST->{'URLS'}->{'FAQ'};
		}
		$text =~ s/\n/<br \/>\n/g;
		print $text;
	}
}

1; #EOF
