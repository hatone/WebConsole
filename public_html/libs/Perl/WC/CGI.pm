#!/usr/bin/perl
# WC::CGI - Web Console 'CGI' module, contains methods for CGI input parameters processing
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::CGI;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::CGI::DATA = {
	'DYNAMIC' => { 'POST_processed' => 0 }
};

# Initialization of 'WC::CGI', called always first
# IN: NOTHING
# RETURN: NOTHING
sub init {
	&NL::CGI::init(\&_func_ENCODE, 0); # 0 - disable multi-values feature
}
# Encode parameter from input (internal)
# IN: STRING_REF
# RETURN: NOTHING
sub _func_ENCODE {
	my ($in_ref_val) = @_;
	return &WC::Encode::encode_from_CGI($in_ref_val);
}
# Check is POST data has been processed
# IN: NOTHING
# RETURN: 1 -yes | 0 -no
sub is_POST_processed { return ($WC::CGI::DATA->{'DYNAMIC'}->{'POST_processed'}) ? 1 : 0; }
# Getting input wrappers
sub get_input { return &NL::CGI::get_input(@_); }
sub get_input_from_GET { return &NL::CGI::get_input_from_GET(@_); }
sub get_input_from_POST { return &NL::CGI::get_input_from_POST(@_); }
sub get_input_from_POST_FILE { return &NL::CGI::get_input_from_POST_FILE(@_); }
# Setting '$WC::c->{'req'}->{'params'}' = parameters from GET
# IN: NOTHING
# RETURN: NOTHING - GET parameters will be at '$WC::c->{'req'}->{'params'}'
sub get_input_from_GET_SET { $WC::c->{'req'}->{'params'} = &get_input_from_GET(@_); }
# Update '$WC::c->{'req'}->{'params'}' from POST
# IN: NOTHING
# RETURN: NOTHING - new POST parameters will be at '$WC::c->{'req'}->{'params'}'
sub get_input_from_POST_UPDATE {
	# We don't want to update from POST more that once
	return if ($WC::CGI::DATA->{'DYNAMIC'}->{'POST_processed'});

	my $ref_HASH_POST = &get_input_from_POST();
	foreach (keys %{ $ref_HASH_POST }) {
		$WC::c->{'req'}->{'params'}->{ $_ } = $ref_HASH_POST->{ $_ } if (!defined $WC::c->{'req'}->{'params'}->{ $_ });
	}
	$WC::CGI::DATA->{'DYNAMIC'}->{'POST_processed'} = 1;
}

1; #EOF
