#!/usr/bin/perl
# WC::HTML::Report - Web Console HTML User Interface
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_OK

package WC::HTML::UI;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

$WC::HTML::UI::DATA = {
	'CONST' => {
		'PREFIX_CLASS' => 'wc-ui'
	}
};

# HTML Table with title
# IN: STRING - title, STRING - content [,STRING - id]
# RETURN: STRING - HTML
sub tab {
	my ($in_title, $in_text, $in_id) = @_;
	$in_title = '' if (!defined $in_title);
	$in_text = '' if (!defined $in_text);

	my $table_id = '';
	$table_id = ' id="'.$in_id.'"' if (defined $in_id);
	my $result = '<table class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab"'.$table_id.'>'.
		     '<tr><td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab-top">'.
			     '<table class="grid"><tr>'.
				     '<td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab-title">'.$in_title.'</td>'.
				     '<td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab-title-center">&nbsp;</td>'.
			     '</tr></table>'.
		     '</td></tr>'.
		     '<tr><td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-tab-main">'.$in_text.'</td></tr></table>';
	return $result;
}
# HTML Table for opened file
# IN: STRING - filename, STRING - content [,STRING - id]
# RETURN: STRING - HTML
sub open_container {
	my ($in_file, $in_text, $in_SETTINGS) = @_;
	$in_file = '' if (!defined $in_file);
	$in_text = '' if (!defined $in_text);
	$in_SETTINGS = {} if (!defined $in_SETTINGS);

	$in_SETTINGS->{'ID'} = &WC::Internal::get_unique_id() if (!defined $in_SETTINGS->{'ID'} || $in_SETTINGS->{'ID'} eq '');
	my $table_id = ' id="'.$in_SETTINGS->{'ID'}.'"';
	my $download = (defined $in_SETTINGS->{'DOWNLOAD'} && $in_SETTINGS->{'DOWNLOAD'} ne '') ? ' <span class="t-green">[<a href="'.$in_SETTINGS->{'DOWNLOAD'}.'" class="a-brown" target="_blank" title="Click to download this file">download</a>]</span>' : '';
	my $close = ' <span class="t-green">[<a href="#" onclick="WC.Console.HTML.OUTPUT_remove_result(\''.$in_SETTINGS->{'ID'}.'\'); return false" class="a-brown" target="_blank" title="Click to close">close</a>]</span>';
	my $result = '<table'.$table_id.' class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-open-container"'.$table_id.'>'.
		     '<tr><td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-open-container-title"><span class="t-blue">File '.&WC::HTML::get_short_value($in_file).$download.$close.'</span></td></tr>'.
		     '<tr><td class="'.$WC::HTML::UI::DATA->{'CONST'}->{'PREFIX_CLASS'}.'-open-container-main">'.$in_text.'</td></tr></table>';
	return $result;
}

1; #EOF
