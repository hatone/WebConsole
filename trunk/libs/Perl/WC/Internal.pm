#!/usr/bin/perl
# WC::Pligins - Web Console 'Internal' module
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Internal;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Parsing parameters
# IN: STRING, HASH_REF
# RETURN: HASH_REF
sub pasre_parameters {
	my ($in_value, $in_SETTINGS) = @_;
	my $result_HASH = {};
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'AS_ARRAY'} = (defined $in_SETTINGS->{'AS_ARRAY'} && $in_SETTINGS->{'AS_ARRAY'}) ? 1 : 0;
	$in_SETTINGS->{'RETURN_ID'} = (defined $in_SETTINGS->{'RETURN_ID'} && $in_SETTINGS->{'RETURN_ID'}) ? 1 : 0;
	$in_SETTINGS->{'ESCAPE_OFF'} = (defined $in_SETTINGS->{'ESCAPE_OFF'} && $in_SETTINGS->{'ESCAPE_OFF'}) ? 1 : 0;
	$in_SETTINGS->{'DISALLOW_SPACES'} = (defined $in_SETTINGS->{'DISALLOW_SPACES'} && $in_SETTINGS->{'DISALLOW_SPACES'}) ? 1 : 0;

	my @arr_all;
	my $re_SPACES = ($in_SETTINGS->{'DISALLOW_SPACES'}) ? '' : '[ \n\t]{0,}';
	while (
		# parameters: "..."="...", '...'='...', "..."=..., '...'=..., ...
		$in_value =~ /(^[ \n\t]{0,})("(\\[^"]|\\"|[^\\"])+"|'(\\[^']|\\'|[^\\'])+'|(\\.|[^ "'\n\t])+)$re_SPACES=$re_SPACES("(\\[^"]|\\"|[^\\"])+"|'(\\[^']|\\'|[^\\'])+'|(\\.|[^ \n\t])+)/ ||
		# options: test, -a, -b=12, ...
		$in_value =~ /(^[ \n\t]{0,})("(\\[^"]|\\"|[^\\"])+"|'(\\[^']|\\'|[^\\'])+'|(\\.|[^ "'\n\t])+)[ \n\t]{0,}/
	      ) {
		my $name = $2;
		my $value = $6;
		$in_value = $';
		# Preparing values and adding to HASH
		if (!$in_SETTINGS->{'ESCAPE_OFF'}) {
			foreach ($name, $value) {
				if (defined $_) {
					if ($_ =~ /^"(.*)"$/) { $_ = &NL::String::str_unescape($1); }
					elsif ($_ =~ /^'(.*)'$/) { $_ =~ s/^'//; $_ =~ s/'$//; $_ =~ s/\\'/'/g; }
				}
			}
		}
		if ($in_SETTINGS->{'AS_ARRAY'}) { push @arr_all, { $name => $value }; }
		else  { $result_HASH->{ $name } = $value; }
	}
	my $return_id = ($in_value =~ /^[ \t\r\n]{0,}$/) ? 1 : 0;
	if ($in_SETTINGS->{'AS_ARRAY'}) {
		if ($in_SETTINGS->{'RETURN_ID'}) { return { 'ID' => $return_id, 'DATA' => \@arr_all }; }
		else { return \@arr_all; }
	}
	else {
		if ($in_SETTINGS->{'RETURN_ID'}) { return { 'ID' => $return_id, 'DATA' => $result_HASH }; }
		else { return $result_HASH; }
	}
}
# Getting unique ID (based on ajax request ID (if it is defined), time and random)
# IN: NOTHING
# RETURN: STRING
sub get_unique_id {
	my $ID = rand;
	$ID =~ s/^.*\.//;
	# Getting time
	$ID .= '-'.time();
	# Getting ajax request ID (if it is defined)
	if (defined $NL::AJAX::DATA && defined $NL::AJAX::DATA->{'DYNAMIC'} && defined $NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}) {
		if (defined $NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'}) {
			$ID = $NL::AJAX::DATA->{'DYNAMIC'}->{'REQUEST'}->{'JsHttpRequest_id'}.'-'.$ID;
		}
	}
	return $ID;
}
# Checking Web Console headers at text, stripping it and returning
# IN: STRING
# RETURN: HASH_REF
sub check_headers {
	my ($in_value) = @_;
	my $result = {};

	my $header_length = 0;
	my $NL_length = length("\n");
	foreach my $line (split (/\n/, $in_value)) {
		if ($line =~ /^$WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}(.+)/) {
			$header_length += $NL_length + length($line);
			foreach (keys %{ $WC::CONST->{'INTERNAL'}->{'HEADERS'} }) {
				my $header_result = &{ $WC::CONST->{'INTERNAL'}->{'HEADERS'}->{$_}->{'sub'} }($1);
				if (defined $header_result->{'name'}) {
					my $name = $header_result->{'name'};
					delete $header_result->{'name'};
					$result->{ $name } = $header_result;
					last;
				}
			}
		}
		else {
			if ($line eq '') { $header_length += $NL_length; }
			$result->{'TEXT'} = substr($in_value, $header_length);
			last;
		}
	}
	return $result;
}
# Checking JS at text, stripping it and returning
# IN: STRING_REF
# RETURN: STRING
sub check_JS {
	my ($in_ref_value) = @_;

	my $result = '';
	if (defined $in_ref_value && ${ $in_ref_value } ne '') {
		# Finding JS
		my @JS_CODE;
		while (${ $in_ref_value } =~ /(<script[ \t\n]+type[ \t\n]{0,}=[ \t\n]{0,}(.*)[ \t\n]{0,}>)/i) {
			my $name = $1;
			my $lang = defined $2 ? lc($2) : '';
			my $is_BAD = 0;
			${ $in_ref_value } = $`;
			if (($lang eq '' || index($lang, 'javascript') >= 0) && $' =~ /<[ \t\n]{0,}\/[ \t\n]{0,}script>/i) { push @JS_CODE, $`; }
			else {
				${ $in_ref_value } .= $name;
				$is_BAD = 1;
			}
			${ $in_ref_value } .= $';
			if ($is_BAD) { last; }
		}
		# Preparing finded JS
		foreach (@JS_CODE) {
			$_ =~ s/^[ \t\n]{0,}<!--//;
			$_ =~ s/(\/\/[ \t]{0,}|)-->[ \t\n]{0,}$//;
			if ($_ ne '') {
				$result .= "\n" if ($result ne '' && $result !~ /\n[ \t]{0,}$/ && $_ !~ /^[ \t]{0,}\n/);
				$result .= $_;
			}
		}
	}
	return $result;
}
# Processing output text of something (pareparing it for HTML or, if headers defined - proccesiing headers)
# IN: STRING_REF
# RETURN: HASH_REF
sub process_output {
	my ($in_ref_value, $in_BACK_STASH) = @_;

	my $result = {};
	if (defined $in_ref_value && ${ $in_ref_value } ne '') {
		my $headers = &check_headers(${ $in_ref_value });
		if (defined $headers->{'content-type'} && $headers->{'content-type'}->{'type'} eq 'text/html') {
			${ $in_ref_value } = $headers->{'TEXT'};
			my $JS_code = &check_JS($in_ref_value);
			$result->{'JS_CODE'} = $JS_code if ($JS_code ne '');
			$result->{'INPUTS_EDITABLE'} = 1;
		}
		else { &NL::String::str_HTML_full($in_ref_value); }
	}
	if (defined $in_BACK_STASH && defined $in_BACK_STASH->{'JS_CODE'} && $in_BACK_STASH->{'JS_CODE'} ne '') {
		$result->{'JS_CODE'} .= "\n" if (defined $result->{'JS_CODE'} && $result->{'JS_CODE'} ne '');
		$result->{'JS_CODE'} .= $in_BACK_STASH->{'JS_CODE'};
	}
	return $result;
}
# Executing internal command
# IN: STRING
# RETURN: HASH_REF
sub exec_autocompletion {
	my ($in_VALUE) = @_;
	my $result = { 'ID' => 0,  'text' => '' };

	if (defined $in_VALUE && $in_VALUE ne '') {
		my $exec_AC = &autocomplete($in_VALUE, { 'EXECUTE' => 1 });
		if ($exec_AC->{'ID'}) {
			if (ref $exec_AC->{'TEXT'} && defined $exec_AC->{'TEXT'}->{'SHOW_AS_TAB_RESULT'} && $exec_AC->{'TEXT'}->{'SHOW_AS_TAB_RESULT'}) { $result = $exec_AC->{'TEXT'}; }
			else {
				$result->{'ID'} = 1;
				$result->{'text'} = $exec_AC->{'TEXT'};
				$result->{'BACK_STASH'} = $exec_AC->{'BACK_STASH'};
			}
		}
	}
	return $result;
}
# Starting autocompletion for internal methods
# IN: STRING
# RETURN: HASH_REF
sub start_autocompletion { return &autocomplete(defined $_[0] ? $_[0] : ''); }
# Resolving link
# IN: STRING
# RETURN: '' | HASH_REF
sub resolve_link {
	my ($in_LINK) = @_;

	my $recursion_level = 0;
	my $item = $in_LINK;
	while (!ref $item && $item =~ /^\$\$(.*)\$\$$/) {
		my $hash = $WC::Internal::DATA::ALL;
		$item = '';
		foreach (split /\|/, $1) {
			if (ref $hash && defined $hash->{$_}) { $hash = $hash->{$_}; }
			else { $hash = undef; last; }
		}
		$item = $hash if ($hash);
		$recursion_level++;
		$item = '' if ($recursion_level >= 10);
	}
	return $item;
}
# Getting list of functions
# IN: HASH_REF [, STRING]
# RETURN: '' | HASH_REF
sub get_list {
	my ($in_HASH, $in_STRING, $in_SETTINGS) = @_;
	$in_STRING = '' if (!defined $in_STRING);

	# Getting HASH keys
	my @arr_keys;
	if (defined $in_SETTINGS->{'GET_HARD'} && $in_SETTINGS->{'GET_HARD'} && $in_STRING ne '' && defined $in_HASH->{ $in_STRING }) {
		if (ref $in_HASH->{ $in_STRING }) {
			$in_HASH = $in_HASH->{ $in_STRING };
			$in_STRING = '';
		}
		else {
			my $resolved = &resolve_link($in_HASH->{ $in_STRING });
			if (ref $resolved) {
				$in_HASH = $resolved;
				$in_STRING = '';
			}
			else { return ''; }
		}
	}
	if ($in_STRING ne '') {
		my $in_STRING_QM = quotemeta($in_STRING);
		@arr_keys = sort grep (/^$in_STRING_QM/i, keys %{ $in_HASH });
	}
	else {
		@arr_keys = sort grep (!/^_/, keys %{ $in_HASH });
	}
	# Preparing result parts
	my $title = defined $in_HASH->{'__doc__'} ? $in_HASH->{'__doc__'} : '';
	# Removing HTML tags from TITLE (because we will convert all to uppercase)
	$title =~ s/<[^<>]+>//g;
	my $result = {
		'TITLE' => uc($title),
		'INFO' => defined $in_HASH->{'__info__'} ? $in_HASH->{'__info__'} : '',
		'SUBTITLE' => '', 'TEXT' => ''
	};
	my @arr_result;
	my $max_length = 0;

	foreach (@arr_keys) {
		if (ref $in_HASH->{$_}) {
			my $len = length($_);
			$max_length = $len if ($len > $max_length);
			push @arr_result, { 'name' => $_, 'doc' => defined $in_HASH->{$_}->{'__doc__'} ? $in_HASH->{$_}->{'__doc__'} : '' };
		}
		else {
			my $name = $_;
			my $name_alias = '';
			my $item = $in_HASH->{ $name };
			if ($item =~ /^\$\$(.*)\$\$$/) {
				$name_alias = $1;
				$name_alias =~ s/\|/ /g;
				$item = &resolve_link($item);
			}
			if (ref $item) {
				my $len = length($name);
				$max_length = $len if ($len > $max_length);
				push @arr_result, { 'name' => $name, 'doc' => "<span class=\"t-red-dark\">-&gt; alias to '$name_alias'</span> ".(defined $item->{'__doc__'} ? '('.$item->{'__doc__'}.')' : '') };
			}
		}
	}

	# Making result
	my $space = '&nbsp;';
	my $spaces_before = $space;
	my $spaces_between  = $space x 3;
	if (scalar @arr_result > 0) {
		foreach (@arr_result) {
			$result->{'TEXT'} .= "<br />" if ($result->{'TEXT'} ne '');
			$result->{'TEXT'} .= $spaces_before.'<span class="t-brown">'.$_->{'name'}.'</span>';
			if ($_->{'doc'} ne '') {
				my $len = length($_->{'name'});
				if ($len < $max_length) { $result->{'TEXT'} .= $space x ($max_length - $len); }
				$result->{'TEXT'} .= '<span class="t-brown-light">'.$spaces_between.$_->{'doc'}.'</span>';
			}
		}
		if ($result->{'TEXT'} ne '') {
			$result->{'TEXT'} = $WC::CONST->{'INTERNAL'}->{'HEADER_PREFIX'}.$WC::CONST->{'INTERNAL'}->{'HEADERS'}->{'content-type'}->{'default'}."\n\n".$result->{'TEXT'};
		}
		$result->{'SUBTITLE'} = "\n".((defined $in_SETTINGS->{'LIST_TITLE'} && $in_SETTINGS->{'LIST_TITLE'} ne '') ? $in_SETTINGS->{'LIST_TITLE'} : 'Please select command:');
	}
	return $result;
}
# Starting call processing
# IN: STRING [, HASH_REF][, STRING][, HASH_REF]
# RETURN: HASH_REF
sub autocomplete {
	my ($in_VALUE, $in_SETTINGS, $in_HASH) = @_;
	$in_SETTINGS = {} if (!defined $in_SETTINGS);
	$in_SETTINGS->{'LIST_TITLE'} = '' if (!defined $in_SETTINGS->{'LIST_TITLE'});
	$in_SETTINGS->{'EXECUTE'} = 0 if (!defined $in_SETTINGS->{'EXECUTE'});
	$in_SETTINGS->{'EXECUTE_HARD'} = 0 if (!defined $in_SETTINGS->{'EXECUTE_HARD'});


	# Initializing defaults
	my $PREFIX = '#';
	my $result = { 'ID' => 0, 'BACK_STASH' => {}, 'TITLE' => '', 'INFO' => '', 'SUBTITLE' => '', 'TEXT' => '', 'values' => [], 'cmd_add' => '', 'cmd_left_update' => '' };
	my $is_first_call = 0;
	if (!defined $in_HASH || !$in_HASH) { $in_HASH = $WC::Internal::DATA::ALL; $is_first_call = 1; }

	# Checking input
	if ($in_VALUE =~ /^([^ \t\n\r]+)([ \t\n\r]{0,})(.*)$/) {
		my $re_NO_VALID_CMD = qr/^(_|$)/;
		$re_NO_VALID_CMD = qr/^(__|$)/ if ($in_SETTINGS->{'EXECUTE'});
		my $CMD = defined $1 ? $1 : '';
		my $CMD_SPACE = defined $2 ? $2 : '';
		my $CMD_PARAMS = defined $3 ? $3 : '';
		# If it is first call and command is just 'PREFIX' character
		if ($is_first_call && $CMD eq $PREFIX) {
			# If no space and parameters - we need to show info
			if ($CMD_SPACE eq '' && $CMD_PARAMS eq '') {
				&NL::Utils::hash_update($result, &get_list($WC::Internal::DATA::ALL, '', { 'LIST_TITLE' => $in_SETTINGS->{'LIST_TITLE'} }));
				$result->{'ID'} = 1;
				if ($in_SETTINGS->{'EXECUTE'}) {
					my $hash_TMP = {};
					&NL::Utils::hash_clone($hash_TMP, $result);
					$result->{'TEXT'} = $hash_TMP;
					$result->{'TEXT'}->{'SHOW_AS_TAB_RESULT'} = 1;
				}
			}
			# Else - that is not our autocompletion (returning defaults - 'ID'=0)
		}
		# If command not empty and not contain /^_/
		elsif ($CMD !~ $re_NO_VALID_CMD) {
			my $KEY_cmd = '';
			my @KEYS_good;
			my $KEYS_good_TOTAL = 0;

			# Finding needed keys
			my $CMD_QM = quotemeta($CMD);
			@KEYS_good = sort grep (/^${CMD_QM}/i, keys %{ $in_HASH });
			$KEYS_good_TOTAL = scalar @KEYS_good;
			if ($KEYS_good_TOTAL == 1) { $KEY_cmd = $KEYS_good[0]; }
			# If that is execution and 'EXECUTE_HARD' enabled - checking for existing KEY and updating
			elsif ($in_SETTINGS->{'EXECUTE'} && $in_SETTINGS->{'EXECUTE_HARD'}) {
				if (defined $in_HASH->{$CMD}) {
					@KEYS_good = ($CMD);
					$KEY_cmd = $CMD;
					$KEYS_good_TOTAL = 1;
				}
			}

			# If it is call of only our command
			if ($CMD_PARAMS eq '') {
				# If we haven't spaces at and
				if ($CMD_SPACE eq '') {
					if ($KEYS_good_TOTAL == 1) {
						my $resolved = &resolve_link($in_HASH->{ lc($KEY_cmd) });
						if (ref $resolved) {
							# That is command execution
							if ($in_SETTINGS->{'EXECUTE'} && defined $resolved->{'__func__'}) {
								$result->{'TEXT'} = &{ $resolved->{'__func__'} }($CMD_PARAMS, $result->{'BACK_STASH'});
								$result->{'ID'} = 1;
							}
							else {
								my $list = &get_list($resolved, '', { 'LIST_TITLE' => $in_SETTINGS->{'LIST_TITLE'} });
								if (ref $list) {
									&NL::Utils::hash_update($result, $list);
									$result->{'cmd_add'} = $KEY_cmd.' ';
									$result->{'ID'} = 1;
									if ($in_SETTINGS->{'EXECUTE'}) {
										my $hash_TMP = {};
										&NL::Utils::hash_clone($hash_TMP, $result);
										$result->{'TEXT'} = $hash_TMP;
										$result->{'TEXT'}->{'SHOW_AS_TAB_RESULT'} = 1;
									}
								}
							}
						}
					}
					elsif ($KEYS_good_TOTAL > 1) {
						if ($in_SETTINGS->{'EXECUTE'} && defined $in_HASH->{ lc($CMD) }) {
							my $resolved = &resolve_link($in_HASH->{ lc($CMD) });
							if (ref $resolved) {
								if (defined $resolved->{'__func__'}) {
									$result->{'TEXT'} = &{ $resolved->{'__func__'} }('', $result->{'BACK_STASH'});
									$result->{'ID'} = 1;
								}
							}
						}
						else {
							my $list = &get_list($in_HASH, $CMD, { 'LIST_TITLE' => $in_SETTINGS->{'LIST_TITLE'} });
							if (ref $list) {
								&NL::Utils::hash_update($result, $list);
								$result->{'cmd_add'} = &WC::Autocomplete::get_same_part(\@KEYS_good);
								$result->{'ID'} = 1;
								if ($in_SETTINGS->{'EXECUTE'}) {
									my $hash_TMP = {};
									&NL::Utils::hash_clone($hash_TMP, $result);
									$result->{'TEXT'} = $hash_TMP;
									$result->{'TEXT'}->{'SHOW_AS_TAB_RESULT'} = 1;
								}
							}
						}
					}
					if ($result->{'cmd_add'} ne '') {
						$result->{'cmd_add'} =~ s/^$CMD_QM//i;
					}
				}
				# If we have spaces at and
				else {
					if ($KEYS_good_TOTAL == 1 || defined $in_HASH->{ lc($CMD) }) {
						$KEY_cmd = lc($CMD) if ($KEYS_good_TOTAL != 1);
						my $resolved = &resolve_link($in_HASH->{ $KEY_cmd });
						if (ref $resolved) {
							if (!defined $resolved->{'__func__'}) {
								my $list = &get_list($resolved, '', { 'LIST_TITLE' => $in_SETTINGS->{'LIST_TITLE'} });
								if (ref $list) {
									&NL::Utils::hash_update($result, $list);
									$result->{'ID'} = 1;
									if ($in_SETTINGS->{'EXECUTE'}) {
										my $hash_TMP = {};
										&NL::Utils::hash_clone($hash_TMP, $result);
										$result->{'TEXT'} = $hash_TMP;
										$result->{'TEXT'}->{'SHOW_AS_TAB_RESULT'} = 1;
									}
								}
							}
							else {
								# That is command execution
								if ($in_SETTINGS->{'EXECUTE'}) {
									$result->{'TEXT'} = &{ $resolved->{'__func__'} }($CMD_PARAMS, $result->{'BACK_STASH'});
									$result->{'ID'} = 1;
								}
								# Command have personal autocompletion
								elsif (defined $resolved->{'__func_auto__'}) {
									my $hash_AC = &{ $resolved->{'__func_auto__'} }();
									if ($hash_AC->{'ID'}) { $result = $hash_AC; }
								}
							}
						}
					}
				}
			}
			# If it is call with parameters - calling recursion
			else {
 				# Help about command
				if ($CMD_PARAMS eq '?' && ($KEY_cmd ne '' || defined $in_HASH->{ $CMD }) && !$in_SETTINGS->{'EXECUTE'}) {
					$KEY_cmd = $CMD if (defined $in_HASH->{ $CMD });
					my $list = &get_list($in_HASH, $KEY_cmd, { 'GET_HARD' => 1, 'LIST_TITLE' => $in_SETTINGS->{'LIST_TITLE'} });
					if (ref $list) {
						&NL::Utils::hash_update($result, $list);
						$result->{'ID'} = 1;
					}
				}
				# Command defined
				elsif ($KEY_cmd ne '' || defined $in_HASH->{ lc($CMD) }) {
					$KEY_cmd = lc($CMD) if (defined $in_HASH->{ lc($CMD) });
					my $resolved = &resolve_link($in_HASH->{ $KEY_cmd });
					if (ref $resolved) {
						# That is command execution
						if (defined $resolved->{'__func__'} && $in_SETTINGS->{'EXECUTE'}) {
							$result->{'TEXT'} = &{ $resolved->{'__func__'} }($CMD_PARAMS, $result->{'BACK_STASH'});
							$result->{'ID'} = 1;
						}
						# Command have personal autocompletion
						elsif (defined $resolved->{'__func_auto__'}) {
							my $hash_AC = &{ $resolved->{'__func_auto__'} }($CMD_PARAMS);
							if ($hash_AC->{'ID'}) { $result = $hash_AC; }
						}
						# Command haven't personal autocompletion
						else { return &autocomplete($CMD_PARAMS, $in_SETTINGS, $resolved); }
					}
				}
			}
		}
	}
	return $result;
}

1; #EOF
