WEB CONSOLE: WEB-BASED REMOTE CONSOLE
Copyright 2008 Nickolay Kovalev, http://resume.nickola.ru
Web Console URL: http://www.web-console.org
Web Console license: GNU GPLv3 (http://www.gnu.org/licenses/)
Web Console Group services: http://services.web-console.org

HOW TO USE WEB CONSOLE DEVELOPMENT VERSION:
  - "Check out" the latest Web Console codebase from SVN to some directory on you computer.
  - Set up that directory as new web directory on your local web server. Make sure that your
    web server is capable of running Perl CGI applications.
  - Change the permission settings for that directory so that it is writable by the web server.
    If your web server configured to execute Perl scripts under specific user account, please make
    sure that this user has write permissions for recently created directory.
    Usually, for Unix-like OS permissions should be set to "755" ("drwxr-xr-x"). To set permissions
    you can use CHMOD command - "chmod 755 directory_name".
  - For Unix-like OS, set "755" ("rwxr-xr-x") permissions for file "wc.pl", - this means that the owner
    has read, write, and execute permission, but group and others only have read and execute permission
    (to set permissions you can use CHMOD command - "chmod 755 wc.pl").
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
  - Use your browser to visit this directory on your web server and call "wc.pl" script to run the web-based
    installation process. The calling URL will looks like "http://www.domain.com/web-console/wc.pl"
    or "http://web-console.domain.com/wc.pl".
  - Install Web Console following the "Web Console Installation Guide / Web-based phase of installation":
    "http://www.web-console.org/installation/#WEB_PHASE".
  - After finishing the installation process, find ".htaccess" file in your web directory
    and rename it to ".htaccess_".
  - Use your browser to visit this web directory again and call "wc.pl",
    you should see Web Console logon page (refresh page if you see installation page again).
  - Now, you are ready for Web Console development.
