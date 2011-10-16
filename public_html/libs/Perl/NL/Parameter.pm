#!/usr/bin/perl
# NL::Parameter - mostNeeded Libs :: Parameters processing library
# (C) 2007 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package NL::Parameter;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Function to check e-mail
# IN: STRING
# RETURN: 1 - OK | 0 - Incorrect
sub FUNC_CHECK_email {
	my ($in_value) = @_;
	if (defined $in_value && $in_value =~ /^[a-zA-Z0-9_\.\-]{1,}\@[a-zA-Z0-9_\.\-]{1,}\.[a-zA-Z]{2,}$/) {
		return {'ID' => 1, 'ERROR_MESSAGE' => ''};
	}
	return {'ID' => 0, 'ERROR_MESSAGE' => ''};
}
# Function to check directory
# IN: STRING
# RETURN: 1 - OK | 0 - Incorrect
sub FUNC_CHECK_directory {
	my ($in_value) = @_;
	if (defined $in_value && $in_value ne '') {
		if (-d $in_value) { return {'ID' => 1, 'ERROR_MESSAGE' => ''}; }
		else { return {'ID' => 0, 'ERROR_MESSAGE' => 'not found (directory should exists)'}; }
	}
	return {'ID' => 0, 'ERROR_MESSAGE' => ''};
}
# Checking parameters
# IN: HASH_REF, HASH_REF
# RETURN: HASH_REF
sub check {
	my ($in_PARAMETERS, $in_CHECK) = @_;
	my $result = { 'ID' => 1, 'ERROR_MESSAGE' => '' };

	if (defined $in_PARAMETERS && defined $in_CHECK) {
		foreach (keys %{ $in_CHECK }) {
			my ($is_undefined, $is_empty) = (0, 0);
			# Finding parameter
			my ($PARAM, $is_FOUND) = ($in_PARAMETERS, 0);
			if ($_ =~ /\|/) {
				$is_FOUND = 1;
				foreach my $part (split /\|/, $_) {
					if (ref $PARAM && defined $PARAM->{ $part }) { $PARAM = $PARAM->{ $part }; }
					else { $is_FOUND = 0; last; }
				}
			}
			else {
				if (defined $PARAM->{ $_ }) {
					$is_FOUND = 1;
					$PARAM = $PARAM->{ $_ };
				}
			}
			# If parameter is defined and not empty
			if ($is_FOUND) {
				if (!ref $PARAM) {
					if ($PARAM ne '') {
						# Function to checking is defined
						if (defined $in_CHECK->{$_}->{'func_CHECK'} && ref $in_CHECK->{$_}->{'func_CHECK'} eq 'CODE') {
							my $check_RESULT = &{ $in_CHECK->{$_}->{'func_CHECK'} }($PARAM);
							if (!$check_RESULT->{'ID'}) {
								$result = { 'ID' => 0, 'ERROR_MESSAGE' => '"'.$in_CHECK->{$_}->{'name'}.'" '.( $check_RESULT->{'ERROR_MESSAGE'} ne '' ? $check_RESULT->{'ERROR_MESSAGE'} : 'is incorrect' ).'...' };
								last;
							}
						}
						# Calling HOOK
						if (defined $in_CHECK->{$_}->{'func_HOOK'} && ref $in_CHECK->{$_}->{'func_HOOK'} eq 'CODE') {
							&{ $in_CHECK->{$_}->{'func_HOOK'} }($PARAM);
						}
						# Calling ENCODE
						if (defined $in_CHECK->{$_}->{'func_ENCODE'} && ref $in_CHECK->{$_}->{'func_ENCODE'} eq 'CODE') {
							my $encode_result = &{ $in_CHECK->{$_}->{'func_ENCODE'} }($PARAM);
							if ($encode_result->[0] == 1) { $PARAM = $encode_result->[1]; }
							else {
								$result = { 'ID' => 0, 'ERROR_MESSAGE' => '"'.$in_CHECK->{$_}->{'name'}.'" can\'t be encoded...' };
								last;
							}
						}
					}
					# If parameter is defined but empty
					else {
						if (defined $in_CHECK->{$_}->{'if_undefined_or_empty_set'}) {
							&set($in_PARAMETERS, {$_ => $in_CHECK->{$_}->{'if_undefined_or_empty_set'}});
						}
						else { $is_empty = 1; }
					}
				}
				else {
					# Parameter is not SCALAR, skipping it
				}
			}
			# If parameter is not defined
			else {
				if (defined $in_CHECK->{$_}->{'if_undefined_or_empty_set'}) {
					&set($in_PARAMETERS, {$_ => $in_CHECK->{$_}->{'if_undefined_or_empty_set'}});
				}
				else { $is_undefined = 1; }
			}

			if ($is_empty && (defined $in_CHECK->{$_}->{'can_be_empty'} && !$in_CHECK->{$_}->{'can_be_empty'})) {
				$result = { 'ID' => 0, 'ERROR_MESSAGE' => '"'.$in_CHECK->{$_}->{'name'}.'" can\'t be empty...' };
				last;
			}
			elsif ($is_undefined && (defined $in_CHECK->{$_}->{'needed'} && $in_CHECK->{$_}->{'needed'})) {
				$result = { 'ID' => 0, 'ERROR_MESSAGE' => '"'.$in_CHECK->{$_}->{'name'}.'" must be defined...' };
				last;
			}
		}
	}
	else { $result->{'ID'} = 0; }
	return $result;
}
# Making parameters groups
# IN: HASH_REF, HASH_REF
# RETURN: NOTHING
sub make_groups {
	my ($in_PARAMETERS, $in_GROUPS_CONFIG) = @_;

	my @keys_PARAMETERS = keys %{ $in_PARAMETERS };
	foreach my $key_code (keys %{ $in_GROUPS_CONFIG }) {
		my $new_HASH = {};
		foreach ( grep (/^$key_code/, @keys_PARAMETERS) ) {
			my $name = $_;
			$name =~ s/^$key_code//;
			$new_HASH->{ $name } = $in_PARAMETERS->{ $_ };
			delete $in_PARAMETERS->{ $_ };
		}
		if (scalar keys %{ $new_HASH } > 0) {
			if (ref $in_GROUPS_CONFIG->{ $key_code }) {
				if (defined $in_GROUPS_CONFIG->{ $key_code }->{'*'}) {
					my $name = $in_GROUPS_CONFIG->{ $key_code }->{'*'};
					delete $in_GROUPS_CONFIG->{ $key_code }->{'*'};
					&make_groups($new_HASH, $in_GROUPS_CONFIG->{ $key_code });
					if (defined $in_PARAMETERS->{ $name }) { &add($in_PARAMETERS->{ $name }, $new_HASH, { 'REPLACE' => 1 }); }
					else { $in_PARAMETERS->{ $name } = $new_HASH; }
				}
			}
			else {
				if (defined $in_PARAMETERS->{ $in_GROUPS_CONFIG->{ $key_code } }) {
					&add($in_PARAMETERS->{ $in_GROUPS_CONFIG->{ $key_code } }, $new_HASH, { 'REPLACE' => 1 });
				}
				else { $in_PARAMETERS->{ $in_GROUPS_CONFIG->{ $key_code } } = $new_HASH; }
			}
		}
	}
}
# Setting parameters values
# IN: HASH_REF, HASH_REF
# RETURN: NOTHING
sub set {
	my ($in_PARAMETERS, $in_VALUES) = @_;

	if (defined $in_PARAMETERS && defined $in_VALUES && ref $in_PARAMETERS && ref $in_VALUES) {
		foreach my $key (keys %{ $in_VALUES }) {
			# Finding parameter
			if ($key =~ /\|/) {
				my ($PARAM, $is_EXISTS) = ($in_PARAMETERS, 1);
				my ($last_PARAM, $last_part) = ('', '');
				foreach my $part (split /\|/, $key) {
					if (!$is_EXISTS || !defined $PARAM->{ $part } || !ref $PARAM->{ $part }) {
						$is_EXISTS = 0;
						$PARAM->{ $part } = {};
					}
					$last_part = $part;
					$last_PARAM = $PARAM;
					$PARAM = $PARAM->{ $part };
				}
				$last_PARAM->{ $last_part } = $in_VALUES->{ $key };
			}
			else { $in_PARAMETERS->{ $key } = $in_VALUES->{ $key }; }
		}
	}
}
# Removing parameters
# IN: HASH_REF, ARRAY_REF
# RETURN: NOTHING
sub remove {
	my ($in_PARAMETERS, $in_VALUES, $in_SETTINGS) = @_;
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	foreach ('REMOVE_NODES') { $in_SETTINGS->{ $_ } = 0 if (!defined $in_SETTINGS->{ $_ }); }

	if (defined $in_PARAMETERS && defined $in_VALUES && ref $in_PARAMETERS && ref $in_VALUES) {
		foreach my $key (@{ $in_VALUES }) {
			# Finding parameter
			if ($key =~ /\|/) {
				my ($PARAM, $last_PARAM, $pre_last_PARAM) = ($in_PARAMETERS, $in_PARAMETERS, $in_PARAMETERS);
				my ($is_EXISTS, $last_part, $pre_last_part) = (1, '', '');
				foreach my $part (split /\|/, $key) {
					if (!defined $PARAM->{ $part }) { $is_EXISTS = 0; last; }
					$pre_last_part = $last_part;
					$pre_last_PARAM = $last_PARAM;
					$last_part = $part;
					$last_PARAM = $PARAM;
					$PARAM = $PARAM->{ $part };
				}
				if ($is_EXISTS) {
					delete $last_PARAM->{ $last_part };
					if ($in_SETTINGS->{'REMOVE_NODES'} && $pre_last_part ne '' && scalar keys %{ $pre_last_PARAM->{ $pre_last_part } } <= 0) {
						$key =~ s/\|[^\|]{0,}$//;
						&remove($in_PARAMETERS, [$key], $in_SETTINGS);
					}
				}
			}
			elsif (defined $in_PARAMETERS->{ $key }) { delete $in_PARAMETERS->{ $key }; }
		}
	}
}
# Grabbing parameters
# IN: HASH_REF, ARRAY_REF
# RETURN: HASH_REF - with grabbed parameters
sub grab {
	my ($in_PARAMETERS, $in_VALUES, $in_SETTINGS) = @_;
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	foreach ('REMOVE_FROM_SOURCE', 'SET_NOT_FOUND_EMPTY', 'REMOVE_FROM_SOURCE_NODES') { $in_SETTINGS->{ $_ } = 0 if (!defined $in_SETTINGS->{ $_ }); }
	$in_SETTINGS->{'func_ENCODE'} = 0 if (!defined $in_SETTINGS->{'func_ENCODE'});

	my $result = {};
	if (defined $in_PARAMETERS && defined $in_VALUES && ref $in_PARAMETERS && ref $in_VALUES) {
		foreach my $key (@{ $in_VALUES }) {
			my $is_EXISTS = 0;
			# Finding parameter
			if ($key =~ /\|/) {
				$is_EXISTS = 1;
				my ($PARAM, $last_PARAM, $pre_last_PARAM) = ($in_PARAMETERS, $in_PARAMETERS, $in_PARAMETERS);
				my ($last_part, $pre_last_part) = ('', '');
				foreach my $part (split /\|/, $key) {
					if (!defined $PARAM->{ $part }) { $is_EXISTS = 0; last; }
					$pre_last_part = $last_part;
					$pre_last_PARAM = $last_PARAM;
					$last_part = $part;
					$last_PARAM = $PARAM;
					$PARAM = $PARAM->{ $part };
				}
				if ($is_EXISTS) {
					&set($result, {
						$key => ($in_SETTINGS->{'func_ENCODE'}) ? &{ $in_SETTINGS->{'func_ENCODE'} }($last_PARAM->{ $last_part }) : $last_PARAM->{ $last_part }
					});
					if ($in_SETTINGS->{'REMOVE_FROM_SOURCE'}) {
						&remove($in_PARAMETERS, [$key], { 'REMOVE_NODES' => $in_SETTINGS->{'REMOVE_FROM_SOURCE_NODES'} });
					}
				}
			}
			elsif (defined $in_PARAMETERS->{ $key }) {
				$is_EXISTS = 1;
				&set($result, {
					$key => ($in_SETTINGS->{'func_ENCODE'}) ? &{ $in_SETTINGS->{'func_ENCODE'} }($in_PARAMETERS->{ $key }) : $in_PARAMETERS->{ $key }
				});
				if ($in_SETTINGS->{'REMOVE_FROM_SOURCE'}) { delete $in_PARAMETERS->{ $key }; }
			}
			# Setting empty values to fields that is not found
			if (!$is_EXISTS && $in_SETTINGS->{'SET_NOT_FOUND_EMPTY'}) { &set($result, { $key => ''}); }
		}
	}
	return $result;
}
# Adding parameters
# IN: HASH_REF, HASH_REF, HASH_REF - settings
# RETURN: NOTHING
sub add {
	my ($in_ref_hash_TO, $in_ref_hash_FROM, $in_SETTINGS) = @_;
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	foreach ('REPLACE') { $in_SETTINGS->{ $_ } = 0 if (!defined $in_SETTINGS->{ $_ }); }

	foreach (keys %{ $in_ref_hash_FROM }) {
		if (!defined $in_ref_hash_TO->{$_}) { $in_ref_hash_TO->{$_} = $in_ref_hash_FROM->{$_}; }
		else {
			my $val_TO_REF = ref $in_ref_hash_TO->{$_};
			my $val_FROM_REF = ref $in_ref_hash_FROM->{$_};
			if (defined $val_TO_REF && $val_TO_REF eq 'HASH' && defined $val_FROM_REF && $val_FROM_REF eq 'HASH') {
				&add($in_ref_hash_TO->{$_}, $in_ref_hash_FROM->{$_}, $in_SETTINGS);
			}
			elsif ($in_SETTINGS->{'REPLACE'}) { $in_ref_hash_TO->{$_} = $in_ref_hash_FROM->{$_}; }
		}
	}
}
# Cloning parameters
# IN: HASH_REF, HASH_REF
# RETURN: NOTHING
sub clone {
	my ($in_ref_hash_TO, $in_ref_hash_FROM) = @_;

	if (defined $in_ref_hash_TO && defined $in_ref_hash_FROM) {
		foreach (keys %{ $in_ref_hash_FROM }) {
			my $val_FROM_REF = ref $in_ref_hash_FROM->{$_};
			if (defined $val_FROM_REF && $val_FROM_REF eq 'HASH') {
				$in_ref_hash_TO->{$_} = {};
				&clone($in_ref_hash_TO->{$_}, $in_ref_hash_FROM->{$_});
			}
			else { $in_ref_hash_TO->{$_} = $in_ref_hash_FROM->{$_}; }
		}
	}
}

1; #EOF
