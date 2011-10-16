#!/usr/bin/perl
# WC::Response::MimeTypes - Web Console file MIMETYPES
# (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
# E-mail: nickola_code@nickola.ru
# @FILE_STATUS: READY_DEV

package WC::Response::MimeTypes;
use strict;
use warnings; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For debugging only, will be removed at compact release | NL_CODE: RM_LINE

# MIME types
$WC::Response::MimeTypes::ALL = { '' => 'application/octet-stream' }; # Default
# Making HASH of types
foreach (split (/\n/, <<END
video/mpeg			mpeg mpg mpe
application/msword		doc
application/ogg			ogg
application/pdf			pdf
application/postscript		ai eps ps
application/vnd.ms-excel	xls
application/vnd.ms-powerpoint	ppt
application/x-cpio		cpio
application/x-dvi		dvi
application/x-gtar		gtar
application/x-javascript	js
application/x-latex		latex
application/x-netcdf		nc cdf
application/x-sh		sh
application/x-shockwave-flash	swf
application/x-tar		tar
application/x-tcl		tcl
application/x-tex		tex
application/x-troff-man		man
application/xhtml+xml		xhtml xht
application/xslt+xml		xslt
application/xml			xml xsl
application/xml-dtd		dtd
application/zip			zip
audio/basic			au snd
audio/midi			mid midi kar
audio/mpeg			mpga mp2 mp3
audio/x-aiff			aif aiff aifc
audio/x-mpegurl			m3u
audio/x-pn-realaudio		ram ra
application/vnd.rn-realmedia	rm
audio/x-wav			wav
image/bmp			bmp
image/cgm			cgm
image/gif			gif
image/ief			ief
image/jpeg			jpeg jpg jpe
image/png			png
image/svg+xml			svg
image/tiff			tiff tif
image/vnd.djvu			djvu djv
image/x-icon			ico
image/x-rgb			rgb
image/x-xbitmap			xbm
image/x-xpixmap			xpm
image/x-xwindowdump		xwd
model/vrml			wrl vrml
text/css			css
text/html			html htm
text/plain			asc txt
text/richtext			rtx
text/rtf			rtf
text/sgml			sgml sgm
text/vnd.wap.wml		wml
text/vnd.wap.wmlscript		wmls
video/mpeg			mpeg mpg mpe
video/quicktime			qt mov
video/vnd.mpegurl		mxu m4u
video/x-msvideo			avi
video/x-sgi-movie		movie
END
)) {
	# If format valid - making adding to HASH
	if ($_ =~ /^[ \s\t]{0,}([^ \s\t]+)[ \s\t]{1,}(.+)$/) {
		my $type = $1;
		my @arr_ext = split(/ /, &NL::String::str_trim($2));
		foreach (@arr_ext) { $WC::Response::MimeTypes::ALL->{ $_ } = $type if (!defined $WC::Response::MimeTypes::ALL->{ $_ }); }
	}
}

1; #EOF
