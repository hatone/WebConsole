#!/usr/bin/perl
# WC::Debug - Web Console 'Debug' module, contains methods for DEBUG manipulations
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::Debug;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Initialization of 'WC::Debug', called always first
# IN: NOTHING
# RETURN: NOTHING
sub init {
	#&_preset_DEBUG_data();
}
# Setting some debugging DATA (internal)
# IN: NOTHING
# RETURN: NOTHING
sub _preset_DEBUG_data {
	$WC::c->{'users'} = {
		'debug' => {
			'password' => 'debug',
			'email' => 'debug@localhost',
		}
	};
}
# Printing into STDERR (using warn)
# IN: ANY OBJECT
# RETURN: NOTHING
sub _print {
	my ($in_val) = @_;
	$in_val = Dumper($in_val) if (ref $in_val);
	warn "\n-- DEBUG: --\n$in_val\n-- END DEBUG --\n";
}
# Getting HTML
# IN: ARRAY_REF - ARRAY with HTML
# RETURN: STRING
sub get_html {
	my ($in_ARR) = @_;

	my $str_FILE = '';
	foreach (@{ $in_ARR }) {
		my $line_RESULT = $_;
		if ($line_RESULT !~ /^[\s\n\r]{0,}$/) {
			if ($line_RESULT =~ /#WC_CODE:[ \t]{0,}(IF|ELSE IF)[ \t]{0,}\('(.*)' (.*)\)/) {
				$line_RESULT = "_HTML_CODE_EOF\n";
				$line_RESULT .= ($1 eq 'ELSE IF') ? "}\nelsif" : 'if';
				$line_RESULT .= " (\$WC_HTML{'$2'} $3) {\n";
				$line_RESULT .= "print <<_HTML_CODE_EOF;\n";
			}
			elsif ($line_RESULT =~ /#WC_CODE:[ \t]{0,}ELSE/) {
				$line_RESULT = "_HTML_CODE_EOF\n";
				$line_RESULT .= "}\nelse {\n";
				$line_RESULT .= "print <<_HTML_CODE_EOF;\n";
			}
			elsif ($line_RESULT =~ /#WC_CODE:[ \t]{0,}\/IF/) {
				$line_RESULT = "_HTML_CODE_EOF\n";
				$line_RESULT .= "}\n";
				$line_RESULT .= "print <<_HTML_CODE_EOF;\n";
			}
			elsif ($line_RESULT =~ /#WC_CODE:[ \t]{0,}PERL/) {
				$line_RESULT = "_HTML_CODE_EOF\n";
			}
			elsif ($line_RESULT =~ /#WC_CODE:[ \t]{0,}\/PERL/) {
				$line_RESULT = "print <<_HTML_CODE_EOF;\n";
			}
			else {
				$line_RESULT =~ s/\\/\\\\/g;
				$line_RESULT =~ s/\$([^W])/\\\$$1/g;
			}
			$str_FILE .= $line_RESULT;
		}
	}
	# File loaded and all needed data is replaced
	$str_FILE = "print <<_HTML_CODE_EOF;\n$str_FILE\n_HTML_CODE_EOF\n";
	return $str_FILE;
}
# Including HTML and prining it into STDOUT
# IN: STRING - file name, HASH_REF - parameters to HTML template
# RETURN: NOTHING
sub incude_html {
	my ($in_file, $in_HTML_HASH) = @_;

	if (!defined $in_file) { &WC::CORE::die_error("WC::Debug::incude_html(): HTML file for include (ARG1) is not defined"); }
	elsif ($in_file eq '' || !-f $in_file) { &WC::CORE::die_error("WC::Debug::incude_html(): HTML file for include '$in_file' not found"); }

	if (!open(FH, "<$in_file")) { &WC::CORE::die_error("WC::Debug::incude_html(): Unable to open HTML file '$in_file'", $!); }
	else {
		my @arr_FILE = <FH>;
		close(FH);
		my $str_FILE = &get_html(\@arr_FILE);
		my %WC_HTML = %{ $in_HTML_HASH };
		# Calling EVAL
		eval $str_FILE;
		if ($@) {
			#print $@; exit;
			&WC::Response::show_error_TEXT_no_header('WC::Debug::incude_html(): EVAL ERROR', $@);
		}
	}
}

1; #EOF
