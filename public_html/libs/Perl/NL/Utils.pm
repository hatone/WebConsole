#!/usr/bin/perl
# NL::Utils - mostNeeded Libs :: Utilities library
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY

package NL::Utils;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Merging HASHES
sub hash_merge {
	my ($in_ref_hash_TO, $in_ref_hash_FROM, $in_UPDATE) = @_;
	$in_UPDATE = 0 if (!defined $in_UPDATE);

	foreach (keys %{ $in_ref_hash_FROM }) {
		if (!defined $in_ref_hash_TO->{$_}) { $in_ref_hash_TO->{$_} = $in_ref_hash_FROM->{$_}; }
		else {
			my $val_TO_REF = ref $in_ref_hash_TO->{$_};
			my $val_FROM_REF = ref $in_ref_hash_FROM->{$_};
			if (defined $val_TO_REF && $val_TO_REF eq 'HASH' && defined $val_FROM_REF && $val_FROM_REF eq 'HASH') {
				&hash_merge($in_ref_hash_TO->{$_}, $in_ref_hash_FROM->{$_}, $in_UPDATE);
			}
			elsif ($in_UPDATE) {
				$in_ref_hash_TO->{$_} = $in_ref_hash_FROM->{$_};
			}
		}
	}
}
# Updating HASHES
sub hash_update { return &hash_merge(defined $_[0] ? $_[0] : '', defined $_[1] ? $_[1] : '', 1); }
# Foreach ELEMENTS at HASH calling CALLBACK function with agrument = REF to ELEMENT value
sub hash_foreach_REF {
	my ($in_REF_HASH, $in_REF_SUB) = @_;

	foreach (keys %{ $in_REF_HASH }) {
		my $val_REF = ref $in_REF_HASH->{ $_ } || '';
		if ($val_REF eq 'HASH') { &hash_foreach_REF($in_REF_HASH->{ $_ }, $in_REF_SUB); }
		elsif ($val_REF eq 'ARRAY') {
			foreach my $val (@{ $in_REF_HASH->{ $_ } }) {
				my $val_REF_ARR = ref $val || '';
				if ($val_REF_ARR eq 'HASH') { &hash_foreach_REF($val, $in_REF_SUB); }
				else { &{ $in_REF_SUB }(\$val); }
			}
		}
		else { &{ $in_REF_SUB }(\$in_REF_HASH->{ $_ }); }
	}
}
# Removing empty values at HASH
sub hash_remove_empty_values {
	my ($in_REF_HASH) = @_;

	if (defined $in_REF_HASH && ref $in_REF_HASH) {
		foreach (keys %{ $in_REF_HASH }) {
			my $val_REF = $in_REF_HASH->{$_};
			if (defined $val_REF) {
				if ($val_REF eq 'HASH') {
					&hash_remove_empty_values($in_REF_HASH->{$_});
					if (scalar keys %{ $in_REF_HASH->{$_} } <= 0) { delete $in_REF_HASH->{$_} }
				}
			}
			else {
				if ($in_REF_HASH->{$_} eq '') { delete $in_REF_HASH->{$_} }
			}
		}
	}
}
# Cloning HASHES
sub hash_clone {
	my ($in_ref_hash_TO, $in_ref_hash_FROM) = @_;

	if (defined $in_ref_hash_TO && defined $in_ref_hash_FROM) {
		foreach (keys %{ $in_ref_hash_FROM }) {
			my $val_FROM_REF = ref $in_ref_hash_FROM->{$_};
			if (defined $val_FROM_REF && $val_FROM_REF eq 'HASH') {
				$in_ref_hash_TO->{$_} = {};
				&hash_clone($in_ref_hash_TO->{$_}, $in_ref_hash_FROM->{$_});
			}
			else { $in_ref_hash_TO->{$_} = $in_ref_hash_FROM->{$_}; }
		}
	}
}

1; #EOF
