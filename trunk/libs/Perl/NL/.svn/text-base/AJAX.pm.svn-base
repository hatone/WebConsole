#!/usr/bin/perl
# NL::AJAX - mostNeeded Libs :: AJAX backend for 'JsHttpRequest' library
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: REVISION NEEDED

package NL::AJAX;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$NL::AJAX::DATA = {
	'DYNAMIC' => {} # here will be REQUEST info
};

sub init {
	my ($in_REF_HASH_params) = @_;
	return 0 if (!defined $in_REF_HASH_params || !$in_REF_HASH_params);

	if (defined $in_REF_HASH_params->{'JsHttpRequest'} && $in_REF_HASH_params->{'JsHttpRequest'} =~ /^(\d+)\-(.*)$/) {
		$NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'} = { 'JsHttpRequest_id' => $1, 'JsHttpRequest_loader' => $2 };
		return 1;
	}
	return 0;
}
sub get_request_id {
	return (defined $NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'} && defined $NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'}) ? $NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'} : 0;
}
sub show_response {
	my ($in_REF_HASH_response_params, $in_SCALAR_response_text, $in_REF_ARR_headers) = @_;
	return 0 if (!defined $in_REF_HASH_response_params || !$in_REF_HASH_response_params);
	$in_SCALAR_response_text = '' if (!defined $in_SCALAR_response_text);
	$in_REF_ARR_headers = [] if (!defined $in_SCALAR_response_text);

	my ($js_request_id, $js_request_loader) = (0, '');
	if (defined $NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}) {
		($js_request_id, $js_request_loader) = ($NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'}, $NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_loader'});
	}
	else {
		return 0;
	}

	# Generating response as JSON string
	my $resultHASH = {
		'id' => $js_request_id,
		'text' => $in_SCALAR_response_text,
		'js' => $in_REF_HASH_response_params
	};
	my $str_output = &NL::String::VAR_to_JSON($resultHASH);

	# Making response
        if ($js_request_loader ne 'xml') {
		# In non-XML mode we cannot use plain JSON. So - wrap with JS function call.
		# If top.JsHttpRequestGlobal is not defined, loading is aborted and
		# iframe is removed, so - do not call dataReady().
		$str_output = ($js_request_loader eq 'form' ? 'top && top.JsHttpRequestGlobal && top.JsHttpRequestGlobal' : 'JsHttpRequest').'.dataReady('.$str_output.");\n";
		if ($js_request_loader eq "form") {
			# &WC::Response::show_http_header(); # show_http_header('Transfer-Encoding: chunked'); # Hm... sometimes apache dont's sends response as 'chunked'
			# OR WITH: "try { /*...*/ } catch(err) { obj_WC_Core.html_print_error_ajax(err); }";
                	$str_output = '<script type="text/javascript" language="JavaScript"><!--'."\n$str_output".'//--></script>';
		}
        }

	foreach (@{ $in_REF_ARR_headers }) { print $_."\r\n" if ($_ !~ /^\s{0,}$/); }
	print "Content-type: text/html; charset=utf-8\r\n\r\n";
	print $str_output;
	return 1;
}

1; #EOF
