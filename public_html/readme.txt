WEB CONSOLE: WEB-BASED REMOTE CONSOLE
Copyright 2008-2010 Nickolay Kovalev, http://resume.nickola.ru
Web Console version: '0.2.6' (build date: '2010.11.12')
Web Console URL: http://www.web-console.org
Web Console license: GNU GPLv3 (http://www.gnu.org/licenses/)
Web Console Group services: http://services.web-console.org

ABOUT:
Web Console is a web-based application that allows remote users to execute UNIX/Windows shell commands
on a server, upload/download files to/from server, edit text files directly on a server and much more.
The application is represented as a web page that accepts user input such as a command, executes that
command on a remote web server, and shows command output in a browser. As well, simple and functional
file manager build-in into the application.
Web Console is open-source software written on Perl using AJAX technology. The application is very light,
does not require any database, and can be uploaded, configured and ready to use in about 10 minutes
(no need server administrator permissions for installation).
For easy access to Web Console from Windows platform you can use HTA APPLICATION. To get more information
about HTA APPLICATION please read description below.

** Web Console Group provides web application development, server configuration,
** technical support, security analysis, consulting and other services.
** To get more information, please visit to: http://services.web-console.org

INSTALLATION:
** Detailed installation instructions (with screenshots)
** you can read here: http://www.web-console.org/installation/

- Requirements
	Web Console can be installed on any web server that capable of running Perl CGI applications,
	on the client side you can use any web browser that supports AJAX technology.
	To run Web Console successfully, there are some requirements that must be met:
	Server:
		Operating System: Unix-like, Windows or any that capable of running Perl.
		Web server: any that capable of running Perl (Apache, Lighttpd, Nginx, IIS, etc.).
		Middleware: Perl.
	Client (user):
		Operating System: any OS (Windows, Unix-like, Mac, etc.).
		Web Browser: any browser that support AJAX technology (FireFox, Internet Explorer, Opera,
		Safari, etc.).

- Installation Guide
	- Download latest Web Console version from the Web Console official download
	  page (http://www.web-console.org/download/).
	- Unpack archive on your local computer in temporary directory.
	- Create new directory on the web server where Web Console will be installed.
	  It could be sub-directory of existing website (example - "www.domain.com/web-console/")
	  or root directory for new website or sub domain (example - "web-console.domain.com"),
	  depends on your preferences.
	- Change the permission settings for that directory so that it is writable by the web server.
	  If your web server configured to execute Perl scripts under specific user account, please make
	  sure that this user has write permissions for recently created directory.
	  Usually, for Unix-like OS, permissions should be set to "755" ("drwxr-xr-x") - to set permissions
	  you can use CHMOD command ("chmod 755 web-console", where "web-console" is a directory on the web
	  server where Web Console will be installed).
	- From temporary directory, where you unpacked archive with latest Web Console version,
	  copy "wc.pl" file to created directory at the web server. For Unix-like OS, set "755" ("rwxr-xr-x")
	  permissions for that file - this means that the owner has read, write, and execute permission,
	  but group and others only have read and execute permission (to set permissions you can use
	  CHMOD command - "chmod 755 wc.pl").
	- In case, if you are using Apache web server, make sure that "wc.pl" will be executed by web server
	  without mod_perl. Simple Apache configuration to run Web Console without mod_perl will looks
	  like that:
	  	-- cut --
	  	AddHandler cgi-script .cgi .pl
	  	<Directory /var/www/web-console/>
	  		AllowOverride All
	  		Options +FollowSymLinks +ExecCGI
	  	</Directory>
	  	-- cut --
	- Now you ready to start web-based phase of installation process, please continue with
	  "Web-based phase of installation" section below.

- Web-based phase of installation
	- Use your browser to visit the Web Console directory on your web server and call "wc.pl"
	  script to run the web-based phase of installation process. The calling URL will looks
	  like "http://www.domain.com/web-console/wc.pl" or "http://web-console.domain.com/wc.pl".
	- Enter administrator's login name in the "administrator login" field.
	- Enter administrator's password in the "administrator password" and "confirm administrator password"
	  fields.
	- Enter administrator's e-mail address in the "e-mail" and "confirm e-mail" fields.
	- If you are using only English characters encoding on the web server, then leave "specify encodings"
	  checkbox blank. For advanced encoding settings, check that checkbox and specify
	  "server console encoding", "server system encoding" and "Web Console text editor encoding"
	  (if it's needed) at POSIX format:
		* "server console encoding" - is a encoding of server shell commands execution output
		  (like 'ls', 'dir', ...).
		* "server system encoding" - is a encoding of server internal commands (programming commands)
		  output (like getting listing of directory using internal Perl function).
		* "Web Console text editor encoding" - is a encoding for Web Console text files editor
		  "#file edit" (internal command), if it's empty then for text files editor will be
		  used "server system encoding".
		** Detailed information about Web Console encodings you can
		** read here: http://www.web-console.org/faq/#ENCODINGS_HOWTO.
	- Press "install" button to continue installation process.
	- If you have entered something incorrectly, you will see detailed error description.
	  Please correct your typos and click "install" button again.
	- If you have done everything correctly - you have finished the installation and, as the page says,
	  you can immediately use Web Console clicking on the link labelled "logon". On the logon page
	  please enter administrator login name and password that you have specified before.
	  In future to use Web Console you need open at your browser URL similar
	  to - "http://www.domain.com/web-console/wc.pl" or "http://web-console.domain.com/wc.pl",
	  and you will see Web Console "logon" page.

- HTA APPLICATION
	At Windows platform you can run "web-console_shell.hta" to start Web Console.
	To prepare "web-console_shell.hta" file please perform following actions:
	  - Copy "web-console_shell.hta" file to you computer.
	  - Open "web-console_shell.hta" file using any text editor.
	  - Find line:
	    '<meta http-equiv="refresh" content="0; url=http://demo.web-console.org">'
	    and replace it to:
	    '<meta http-equiv="refresh" content="0; url=http://www.domain.com/web-console/wc.pl">'
	    (where "http://www.domain.com/web-console/wc.pl" is URL for your Web Console installation).
	  - Make shortcut for "web-console_shell.hta".
	Now you can execute shortcut for "web-console_shell.hta" to open Web Console.
