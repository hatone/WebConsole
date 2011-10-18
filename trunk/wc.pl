#!/usr/bin/perl
#
# WEB CONSOLE: WEB-BASED REMOTE CONSOLE
# (C) 2008-2010 Nickolay Kovalev, http://resume.nickola.ru
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Web Console URL: http://www.web-console.org
# Web Console author: Nickolay Kovalev
# Web Console author's resume: http://resume.nickola.ru
#
# Latest version of Web Console can be downloaded here: http://www.web-console.org/download/
# @author Nickolay Kovalev

use strict;
use warnings; # For development only, will be removed at compact release | NL_CODE: RM_LINE
use lib './libs/Perl'; # For development only, will be removed at compact release | NL_CODE: RM_LINE
use Data::Dumper; # For development only, will be removed at compact release | NL_CODE: RM_LINE

# Demo mode
$WC::DEMO = $WC::DEMO = 0; # NL_CODE: RM_LINE [DEMO_MODE]

# Including Web Console packages, for development only, packages will be 'inlined' at compact release | NL_CODE: INCLUDE_PERL
# NL
require NL;
require NL::Error;
require NL::Utils;
require NL::Parameter;
require NL::CGI;
require NL::Dir;
require NL::String;
require NL::File;
require NL::File::Lock;
require NL::AJAX;
require NL::AJAX::Upload;
require NL::Report;
# WC
require WC::Demo; # For DEMO only, will be removed at compact release | NL_CODE: RM_LINE [DEMO_MODE]
require WC::Encode;
require WC::Debug; # For development only, will be removed at compact release | NL_CODE: RM_LINE
require WC::CORE;
require WC::EXEC;
require WC::CGI;
require WC::Dir;
require WC::File;
require WC::Config;
require WC::Config::Main;
require WC::Users;
require WC::Install;
require WC::Response;
require WC::Response::MimeTypes;
require WC::Response::Download;
require WC::AJAX;
require WC::HTML;
require WC::HTML::Report;
require WC::HTML::UI;
require WC::HTML::Open;
require WC::HTML::Open::Types;
require WC::Warning;
require WC::Autocomplete;
require WC::Internal;
require WC::Internal::Data;
require WC::Internal::Data::Settings;
require WC::Internal::Data::File;
require WC::Internal::Data::Upload;
require WC::Upload;
# End of including Web Console packages | NL_CODE: / INCLUDE_PERL

# Starting Web Console
&WC::CORE::start();
