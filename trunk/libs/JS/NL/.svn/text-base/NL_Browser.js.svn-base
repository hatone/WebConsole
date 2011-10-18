/*
* NL :: Browser.Detect - Browser detection
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof NL == "undefined") { alert("NL.Browser: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('Browser.Detect'); }

// Setting all to FALSE
NL.Browser.Detect.isIE7 = NL.Browser.Detect.isIE = NL.Browser.Detect.isFF = NL.Browser.Detect.isFF3 = NL.Browser.Detect.isOPERA = NL.Browser.Detect.isSAFARI = NL.Browser.Detect.isSAFARI_MOB = false;
// Getting 'navigator.useragent' value at lowercase
NL.Browser.Detect.UA = function() { return (navigator.userAgent) ? navigator.userAgent.toLowerCase() : ''; }();
// Initialization and detection (internal)
NL.Browser.Detect._init = function() {
	var nv = (navigator.vendor) ? navigator.vendor.toLowerCase() : '';
	// OPERA
	if (window.opera) NL.Browser.Detect.isOPERA = true;
	// SAFARI
	else if (nv.indexOf('apple') != -1) {
		NL.Browser.Detect.isSAFARI = true;
		if (NL.Browser.Detect.UA.match(/iphone.*mobile.*safari/)) NL.Browser.Detect.isSAFARI_MOB = true;
	}
	// IE
	else if (nv != 'kde' && document.all && NL.Browser.Detect.UA.indexOf('msie') != -1) {
		NL.Browser.Detect.isIE = true;
		if (window.XMLHttpRequest) NL.Browser.Detect.isIE7 = true;
	}
	// FIREFOX
	else if (NL.Browser.Detect.UA.indexOf('firefox') != -1 || NL.Browser.Detect.UA.indexOf('iceweasel') != -1) {
		NL.Browser.Detect.isFF = true;
		if (NL.Browser.Detect.UA.match(/(firefox|iceweasel)\/3/)) NL.Browser.Detect.isFF3 = true;
	}
}();
