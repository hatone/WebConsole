#!/usr/bin/perl
# WC::AJAX - Web Console AJAX manipulations
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::AJAX;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::AJAX::DATA = {
	'DYNAMIC' => {
		'AJAX_INITIALIZED' => 0
	}
};

# Initialization of 'WC::AJAX', called always first
# IN: NOTHING
# RETURN: 1 - OK, 0 - NOT OK
sub init {
	my $in_PARAMS = $WC::c->{'request'}->{'params'};
	if(&NL::AJAX::init($WC::c->{'request'}->{'params'})) {
		$WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_INITIALIZED'} = 1;
		if (defined $WC::c->{'request'}->{'params'}->{'AJAX_REQUEST_ID'}) {
			$WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_REQUEST_ID'} = $WC::c->{'request'}->{'params'}->{'AJAX_REQUEST_ID'};
		}
		return 1;
	}
	return 0;
}
# Showing AJAX response and do not converting encoding of '$in_TEXT'
# WRAPPER TO: '&show_response()'
# IN: STRING - action, STRING - text, HASH_REF - action parameters, HASH_REF - stash
# RETURN: NOTHING
sub show_response_NO_TEXT_ENCODE {
	return &show_response(defined $_[0] ? $_[0] : '', defined $_[1] ? $_[1] : '', defined $_[2] ? $_[2] : {}, defined $_[3] ? $_[3] : {}, 1);
}
# Showing AJAX response
# IN: STRING - action, STRING - text, HASH_REF - action parameters, HASH_REF - stash [, NUMBER = 0 - TEXT will be encoded | 1 - TEXT will be not encoded]
# RETURN: NOTHING
sub show_response {
	my ($in_ACTION, $in_TEXT, $in_ACTION_PARAMS, $in_STASH, $in_DONT_ENCODE_TEXT) = @_;
	$in_ACTION = '' if (!defined $in_ACTION);
	$in_TEXT = '' if (!defined $in_TEXT);
	$in_ACTION_PARAMS = {} if (!defined $in_ACTION_PARAMS);
	$in_STASH = {} if (!defined $in_STASH);

	if ($WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_INITIALIZED'}) {
		&WC::Encode::encode_from_SYSTEM_to_INTERNAL(\$in_TEXT) if ($in_TEXT ne '' && !defined $in_DONT_ENCODE_TEXT || !$in_DONT_ENCODE_TEXT);
		&NL::Utils::hash_foreach_REF($in_ACTION_PARAMS, \&WC::Encode::encode_from_SYSTEM_to_INTERNAL);
		&NL::Utils::hash_foreach_REF($in_STASH, \&WC::Encode::encode_from_SYSTEM_to_INTERNAL);
		my $hash_RESULT = {
			'text' => $in_TEXT,
			'action' => $in_ACTION,
			'action_params' => $in_ACTION_PARAMS,
			'STASH' => $in_STASH
		};
		if (defined $WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_REQUEST_ID'} && $WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_REQUEST_ID'} ne '') {
			$hash_RESULT->{'id'} = $WC::AJAX::DATA->{'DYNAMIC'}->{'AJAX_REQUEST_ID'};
		}

		if (!&NL::AJAX::show_response($hash_RESULT, '', $WC::CONST->{'HTTP_EXTRA_HEADERS'})) {
			&WC::Response::show_error_TEXT('Unable to make AJAX response (but AJAX is initialized)', 'Looks like it was bad AJAX request', 'WC_AJAX_UNABLE_MAKE_RESPONSE_AJAX_INITIALIZED');
		}
	}
	else {
		&WC::Response::show_error_TEXT('Unable to make AJAX response (AJAX is not initialized)', 'Looks like it was bad AJAX request', 'WC_AJAX_UNABLE_MAKE_RESPONSE_AJAX_NOT_INITIALIZED');
	}
}

sub show_info { &_show_REPORT('INFO', \@_); }
sub show_warning { &_show_REPORT('WARNING', \@_); }
sub show_error {  &_show_REPORT('ERROR', \@_); }
# Showing REPORT with ERROR, WARNING or INFORMATION (internal)
# IN: (ID, ARRAY_REF to ARRAY with report elements) | (ELEMENT_MESSAGE, ELEMENT_INFO, ELEMENT_ID)
# RETURN: NOTHING
sub _show_REPORT {
	my ($in_TYPE, $in_PARAMS) = @_;

	# Making ELEMENTS for report
	my $ref_ELEMENTS = [];
	if (defined $in_PARAMS && scalar @{ $in_PARAMS } > 0) {
		if (ref $in_PARAMS->[0] eq 'ARRAY') { $ref_ELEMENTS = $in_PARAMS->[0]; }
		else {
			my $element_type = 'INFORMATION';
			if ($in_TYPE eq 'WARNING') { $element_type = 'WARNING'; }
			elsif ($in_TYPE eq 'ERROR') { $element_type = 'ERROR'; }

			my ($in_msg, $in_info, $in_id) = @{ $in_PARAMS };
			$ref_ELEMENTS = [{'TYPE' => $element_type, 'id' => (defined $in_id) ? $in_id : '', 'message' => (defined $in_msg) ? $in_msg : '', 'info' => (defined $in_info) ? $in_info : ''}];
		}
	}

	# Generating report
	my $report = {};
	if (scalar @{ $ref_ELEMENTS } > 0) { $report = &WC::HTML::Report::make_REPORT_MAIN($ref_ELEMENTS); }
	# Showing AJAX response
	&show_response($in_TYPE, (defined $report->{'TEXT'}) ? $report->{'TEXT'} : '', {'content-type' => 'HTML'}, {});
}

1; #EOF
