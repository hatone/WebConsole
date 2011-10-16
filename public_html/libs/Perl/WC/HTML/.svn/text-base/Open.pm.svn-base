#!/usr/bin/perl
# WC::HTML::Open - Web Console file OPEN
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::HTML::Open;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# Opening file downloading
sub start {
	my ($file) = @_;
	my $result = { 'ID' => 0, 'HTML' => '' };

	my $file_ext = ($file =~ /\.([^\.]{0,})$/) ? $1 : '';
	$file_ext =~ s/\.([^\.]{0,})$/$1/;
	if (defined $WC::HTML::Open::Types::ALL->{ $file_ext }) {
		$result->{'HTML'} = $WC::HTML::Open::Types::ALL->{ $file_ext }->($file);
		$result->{'ID'} = 1;
	}
	else { $result->{'HTML'} = $WC::HTML::Open::Types::ALL->{''}->($file); }
	return $result;
}

1; #EOF
