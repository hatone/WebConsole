/*
* NL :: AJAX - AJAX implementation
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof NL == "undefined") { alert("NL.AJAX: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('AJAX'); }

// Internal DATA container
NL.AJAX._DATA = {
	'ERROR_HANDLER': null
};

// ERROR THROW - called from JsHttpRequest in case of ERROR
NL.AJAX._JsHttpRequest_ERROR_THROW = function (in_TEXT, in_STASH) {
	if (NL.AJAX._DATA['ERROR_HANDLER']) NL.AJAX._DATA['ERROR_HANDLER'](typeof in_TEXT != 'undefined' ? in_TEXT : '', typeof in_STASH != 'undefined' ? in_STASH : null);
};
// Setting ERROR handler
NL.AJAX.set_ERROR_HANDLER = function (in_FUNCTION) {
	if (typeof in_FUNCTION != 'undefined' && in_FUNCTION) NL.AJAX._DATA['ERROR_HANDLER'] = in_FUNCTION;
};
// Making URL 'GET STRING' from 'PARAMS' (internal)
NL.AJAX._makeURL = function(in_url, in_PARAMS) {
	var str_url_params = '';
	for (var param in in_PARAMS) {
		if (param != '' && in_PARAMS[param] != '') {
			if (str_url_params != '') str_url_params += '&';
			str_url_params += param + '=' + in_PARAMS[param];
		}
	}
	if (str_url_params != '') {
		var splitter = (in_url.indexOf('?') == -1) ? '?' : '&';
		var last_char = (in_url.length > 0) ? in_url.charAt(in_url.length - 1) : '';
		return in_url + ( (last_char == '?' || last_char == '&') ? str_url_params : splitter + str_url_params );
	}
	else return in_url;
};
// Making AJAX request ('PARAMS_GET' will be always at URL 'GET STRING',
// 'PARAMS_POST' will be at POST or at URL 'GET STRING' if POST is unavailable)
NL.AJAX.query = function(in_url, in_PARAMS_GET, in_PARAMS_POST, in_FUNC_CALLBACK, in_ENABLE_CACHING, in_STASH) {
	return JsHttpRequest.query(NL.AJAX._makeURL(in_url, in_PARAMS_GET), in_PARAMS_POST, in_FUNC_CALLBACK, (in_ENABLE_CACHING) ? false : true, typeof in_STASH != 'undefined' ? in_STASH : null);
};
// Making AJAX upload ('PARAMS_GET' will be always at URL 'GET STRING',
// 'PARAMS_POST' will be at POST)
NL.AJAX.upload = function(in_url, in_PARAMS_GET, in_PARAMS_POST, in_FUNC_CALLBACK, in_ENABLE_CACHING) {
	//return JsHttpRequest.query(NL.AJAX._makeURL(in_url, in_PARAMS_GET), in_PARAMS_POST, in_FUNC_CALLBACK, (in_ENABLE_CACHING) ? false : true);
	var req = new JsHttpRequest();
	req.onreadystatechange = function() {
		if (req.readyState == 4) {
			//alert('OK');
			in_FUNC_CALLBACK(req.responseJS, req.responseText);
		}
	};
	req.caching = (in_ENABLE_CACHING) ? false : true;
	// Prepare request object (automatically choose GET or POST).
	req.open('post', NL.AJAX._makeURL(in_url, in_PARAMS_GET), false);
	// Send whole form data to backend.
	req.send( in_PARAMS_POST );
	return req;
};
