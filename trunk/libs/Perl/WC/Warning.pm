#!/usr/bin/perl
# WC::Dir - Web Console 'Warning' module, contains methods for warnings manipulations
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Warning;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::Warning::DATA = {
	'CONST' => {
		'MAX_MESSAGES' => 20
	},
	'DYNAMIC' => {
		'messages' => []
	}
};

# 'NL::Error' for error storage support
sub _error_reset { &NL::Error::reset(__PACKAGE__); }
sub _error_set { &NL::Error::set(__PACKAGE__, @_); }
sub get_last_error { &NL::Error::get(__PACKAGE__); }
sub get_last_error_ARR { &NL::Error::get_ARR(__PACKAGE__); }
sub get_last_error_ID { &NL::Error::get_id(__PACKAGE__); }
sub get_last_error_TEXT { &NL::Error::get_text(__PACKAGE__); }
sub get_last_error_INFO { &NL::Error::get_info(__PACKAGE__); }

# Adding new warning message
# IN: STRING - text, STRING - information, STRING - ID
# RETURN: NOTHING
sub add {
	my ($message, $info, $id) = @_;

	if (defined $message && $message ne '') {
		# Adding new message
		push @{ $WC::Warning::DATA->{'DYNAMIC'}->{'messages'} },
		{
			'message' => (defined $message) ? $message : '',
			'info' => (defined $info) ? $info : '',
			'id' => (defined $id) ? $id : ''
		};
		# Removing last messsage if it is needed
		if (scalar @{ $WC::Warning::DATA->{'DYNAMIC'}->{'messages'} } > $WC::Warning::DATA->{'CONST'}->{'MAX_MESSAGES'} ) {
			shift @{ $WC::Warning::DATA->{'DYNAMIC'}->{'messages'} };
		}
	}
}
# Resetting warnings
# IN: NOTHING
# RETURN: NOTHING
sub reset { $WC::Warning::DATA->{'DYNAMIC'}->{'messages'} = []; }
# Making HTML (warnings report)
# IN: NOTHING
# RETURN: STRING - HTML report
sub make_HTML {
	my $ref_ELEMENTS = [];

	foreach (@{ $WC::Warning::DATA->{'DYNAMIC'}->{'messages'} }) {
		push @{ $ref_ELEMENTS }, {
			'TYPE' => 'WARNING',
			'message' => (defined $_->{'message'}) ? $_->{'message'} : '',
			'info' => (defined $_->{'info'}) ? $_->{'info'} : '',
			'id' => (defined $_->{'id'}) ? $_->{'id'} : ''
		};
	}

	if (scalar @{ $ref_ELEMENTS } > 0) {
		my $report_HTML = &WC::HTML::Report::make_REPORT_MAIN($ref_ELEMENTS);
		return $report_HTML->{'TEXT'};
	}
	return '';
}

1; #EOF
