#!/usr/bin/perl
# NL::Report - mostNeeded Libs :: Text Report creation library
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: DEV

package NL::Report;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$NL::Report::DATA = {
	'CONST' => {
		'REQUIRED_ALWAYS' => ['TYPE'],
	},
	'SETTINGS' => {
		'VALUES_TO_HTML' => 1,
		'TYPES' => ['ERROR', 'WARNING', 'INFORMATION'],
		'REQUIRED_IN' => ['message'],
		'TEMPLATES' => {
			'_ELEMENTS_SPLITTER_' => "\n---\n",
			'_REPORT_TYPES_' => {
				'ERROR' => "[_BEFORE]TITLE: [_TITLE]\n[\nHeader: [_HEADER]\n\n][_REPORT_ELEMENTS_][\n\nfooter: [_FOOTER]][_AFTER]",
				'WARNING' => "[_BEFORE][_TITLE]\n[\nHeader: [_HEADER]\n\n][_REPORT_ELEMENTS_][\n\nfooter: [_FOOTER]][_AFTER]",
				'_REPORT_ELEMENTS_' => {
					'ERROR' => "ERROR: [message][_INFO_][_FAQ_ID_]",
					'WARNING' => "WARNING: [message][_INFO_][_FAQ_ID_]",
					'_ELEMENT_PARTS_' => {
						'_INFO_' => "[\nINFO: [info]]",
						'_FAQ_ID_' => "[\nFAQ_ID: [id]]"
					}
				}
			}
		}
	}
};

sub init {
	my ($in_SETTINGS) = @_;
	if ($in_SETTINGS) { $NL::Report::DATA->{'SETTINGS'} = $in_SETTINGS; }
}
# Making Report
# IN:
#     [
#         { 'TYPE' => TEXT, '<name>' => '<value>'[, '<nameN>' => '<valueN>'] },
#         ...
#     ]
# OUT:
#     {
#        'TYPE' => TYPE, 'TEXT' => TEXT
#     }
sub make_REPORT {
	return &make_REPORT_EXT($NL::Report::DATA->{'SETTINGS'}, @_);
}
sub make_REPORT_EXT {
	my ($report_SETTINGS, $in_HASH, $in_PARAMETERS) = @_;
	$in_PARAMETERS = {} if (!defined $in_PARAMETERS);

	my $report_CONST = $NL::Report::DATA->{'CONST'};
	my ($report_TYPE_id, $report_TYPE_name) = (-1, '');
	my ($result_TEXT, $result_ELEMENTS) = ('', '');
	foreach my $hash_ITEM ( @{ $in_HASH } ) {
		# Checking that we have all needed input for element, if not - skip that element
		my $skip_ITEM = 0;
		foreach (@{ $report_CONST->{'REQUIRED_ALWAYS'} }, @{ $report_SETTINGS->{'REQUIRED_IN'} }) {
			if (!defined $hash_ITEM->{$_} || $hash_ITEM->{$_} eq '') {
				$skip_ITEM = 1;
				last;
			}
		}
		next if ($skip_ITEM);

		# Setting lowest TYPE of messages at report (that will be REPORT type)
		my $type_index = 0;
		foreach (@{ $report_SETTINGS->{'TYPES'} }) {
			if ($_ eq $hash_ITEM->{'TYPE'}) {
				if ($report_TYPE_id < 0 || $report_TYPE_id > $type_index) {
					$report_TYPE_id = $type_index;
					$report_TYPE_name = $_;
				}
				last;
			}
			$type_index++;
		}

		# Making ELEMENT
		my $element_TEXT = &make_ELEMENT($report_SETTINGS, $hash_ITEM->{'TYPE'}, $hash_ITEM);
		if ($element_TEXT ne '') {
			$result_ELEMENTS .= $report_SETTINGS->{'TEMPLATES'}->{'_ELEMENTS_SPLITTER_'} if ($result_ELEMENTS ne '' && defined $report_SETTINGS->{'TEMPLATES'}->{'_ELEMENTS_SPLITTER_'});
			$result_ELEMENTS .= $element_TEXT;
		}
	}
	# OK, we have all elements, making full report
	if ($report_TYPE_name ne '' && $result_ELEMENTS ne '' && defined $report_SETTINGS->{'TEMPLATES'}->{'_REPORT_TYPES_'}->{ $report_TYPE_name }) {
		my $report_VARS = {
			'_BEFORE' => [ 'ALL_BEFORE', '[TYPE]_BEFORE' ],
			'_AFTER' => [ 'ALL_AFTER', '[TYPE]_AFTER' ],
			'_TITLE' => [ 'ALL_title', '[TYPE]_title' ],
			'_HEADER' => [ 'ALL_header', '[TYPE]_header' ],
			'_FOOTER' => [ 'ALL_footer', '[TYPE]_footer' ]
		};
		foreach ( keys %{ $report_VARS }) {
			my $value = '';
			foreach my $name (@{ $report_VARS->{ $_ } }) {
				$name =~ s/\[TYPE\]/$report_TYPE_name/;
				if (defined $in_PARAMETERS->{ $name }) {
					$value = $in_PARAMETERS->{ $name };
					last;
				}
			}
			$report_VARS->{ $_ } = $value;
		}
		if ($report_VARS->{'_TITLE'} eq '') { $report_VARS->{'_TITLE'} = "Report ($report_TYPE_name):"; }
		$report_VARS->{'_REPORT_ELEMENTS_'} = $result_ELEMENTS;
		# Making replace
		$result_TEXT = &make_REPLACE($report_SETTINGS->{'TEMPLATES'}->{'_REPORT_TYPES_'}->{ $report_TYPE_name }, $report_VARS, { 'REGEX' => qr/[A-Z_\-]+/ });
	}
	# print $result_MESSAGE; exit;
	return { 'TYPE' => $report_TYPE_name, 'TEXT' => $result_TEXT };
}
sub make_ELEMENT {
	my ($report_SETTINGS, $in_ELEMENT_ID, $in_HASH) = @_;

	my $result = '';
	if ($in_ELEMENT_ID !~ /^_(.*)_$/) {
		my $report_ELEMENTS = $report_SETTINGS->{'TEMPLATES'}->{'_REPORT_TYPES_'}->{'_REPORT_ELEMENTS_'};
		if (defined $report_ELEMENTS->{ $in_ELEMENT_ID }) {
			# Replacing
			$result = &make_REPLACE($report_ELEMENTS->{ $in_ELEMENT_ID }, $in_HASH, {
				'REGEX' => qr/[a-z][a-z_\-]{0,}[a-z]{0,}/,
				'to_HTML' => (defined $report_SETTINGS->{'VALUES_TO_HTML'}) ? $report_SETTINGS->{'VALUES_TO_HTML'} : 0
			});
			$result = &make_REPLACE_PART($report_SETTINGS, $result, $in_HASH);
		}
	}
	return $result;
}
sub make_REPLACE_PART {
	my ($report_SETTINGS, $in_VAL, $in_HASH) = @_;

	my $report_PARTS = $report_SETTINGS->{'TEMPLATES'}->{'_REPORT_TYPES_'}->{'_REPORT_ELEMENTS_'}->{'_ELEMENT_PARTS_'};
	my $toREPLACE = {};
	while ($in_VAL =~ /\[(_[A-Z |_\-]+_)\]/g) {
		my $id = $1;
		my @arr_elements = split(/[ ]{0,}\|\|[ ]{0,}/, $id);
		$id =~ s/\|/\\\|/g;

		my $value = '';
		foreach (@arr_elements) {
			if (defined $report_PARTS->{ $_ }) {
				$value = &make_REPLACE($report_PARTS->{ $_ }, $in_HASH, {
					'REGEX' => qr/[a-z][a-z_\-]{0,}[a-z]{0,}/,
					'to_HTML' => (defined $report_SETTINGS->{'VALUES_TO_HTML'}) ? $report_SETTINGS->{'VALUES_TO_HTML'} : 0
				});
				last if ($value ne '');
			}
		}
		$toREPLACE->{ $id } = $value;
	}
	foreach (keys %{ $toREPLACE }) { $in_VAL =~ s/\[$_\]/$toREPLACE->{$_}/g; }
	return $in_VAL;
}
sub make_REPLACE {
	my ($in_VAL, $in_HASH, $in_PARAMETERS) = @_;
	$in_PARAMETERS = {} if (!defined $in_PARAMETERS);
	return '' if (!defined $in_VAL || $in_VAL eq '');

	my $regex = qr/[A-Za-z_\-]+/;
	$regex = $in_PARAMETERS->{'REGEX'} if (defined $in_PARAMETERS->{'REGEX'});
	my $toREPLACE = {};
	while ($in_VAL =~ /\[($regex)\]/g) {
		if (!defined $toREPLACE->{ $1 }) {
			$toREPLACE->{ $1 } = (defined $in_HASH->{ $1 }) ? $in_HASH->{ $1 } : '';
		}
	}
	foreach (keys %{ $toREPLACE }) {
		my $from = "[$_]";
		my $to = $toREPLACE->{$_};
		if (defined $in_PARAMETERS->{'to_HTML'} && $in_PARAMETERS->{'to_HTML'}) {
			# Simple HTML fix
			$to =~ s/\n/<br \/>/g;
		}
		if ($in_VAL =~ /(\[([^\[\]]{0,})\[$_\]([^\[\]]{0,})\])/) {
			$from = $1;
			$to = $2.$to.$3 if ($to ne '');
		}
		# Fix '$from' to REGEX
		$from =~ s/\[/\\\[/g; $from =~ s/\]/\\\]/g;
		$in_VAL =~ s/$from/$to/;
	}
	return $in_VAL;
}

1; #EOF
