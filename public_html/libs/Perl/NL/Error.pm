#!/usr/bin/perl
# NL::Error - mostNeeded Libs :: Error storage library
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY

package NL::Error;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$NL::Error::DATA = {
	'ERROR_OBJECTS' => {}
};

sub reset {
	my ($obj_id) = @_;

	if (defined $obj_id && $obj_id ne '' && defined $NL::Error::DATA->{'ERROR_OBJECTS'}->{ $obj_id }) {
		delete $NL::Error::DATA->{'ERROR_OBJECTS'}->{ $obj_id };
	}
}
sub set {
	my ($obj_id, $err_text, $err_info, $err_id) = @_;

	if (defined $obj_id && $obj_id ne '') {
		$NL::Error::DATA->{'ERROR_OBJECTS'}->{ $obj_id } = {
			'ERROR_ID' => (defined $err_id) ? $err_id : '',
			'ERROR_TEXT' => (defined $err_text) ? $err_text : '',
			'ERROR_INFO' => (defined $err_info) ? $err_info : ''
		};
	}
}
sub get {
	my ($obj_id) = @_;

	if (defined $obj_id && $obj_id ne '' && defined $NL::Error::DATA->{'ERROR_OBJECTS'}->{ $obj_id }) {
		return $NL::Error::DATA->{'ERROR_OBJECTS'}->{ $obj_id };
	}
	return {};
}
sub _get {
	my ($obj_id, $hash_element) = @_;

	my $ref_hash = &get($obj_id);
	if (defined $ref_hash->{ $hash_element }) { return $ref_hash->{ $hash_element }; }
	return '';
}
sub get_ARR {
	my ($obj_id) = @_;

	my $ref_hash = &get($obj_id);
	if (scalar keys %{ $ref_hash } > 0) {
		return ($ref_hash->{'ERROR_TEXT'}, $ref_hash->{'ERROR_INFO'}, $ref_hash->{'ERROR_ID'});
	}
	else { return ('', '', ''); }
}
sub get_id { return &_get($_[0], 'ERROR_ID'); }
sub get_text { return &_get($_[0], 'ERROR_TEXT'); }
sub get_info { return &_get($_[0], 'ERROR_INFO'); }

1; #EOF
