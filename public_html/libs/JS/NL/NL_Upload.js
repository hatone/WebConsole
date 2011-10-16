/*
* NL :: Upload - AJAX files uploader
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof NL == "undefined") { alert("NL Upload: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('Upload'); }

// Adding 'params' to the URL 'query string'
NL.Upload._makeURL = function(in_url, in_PARAMS) {
	var str_url_params = '';
	for (var param in in_PARAMS) {
		if (param != '' && in_PARAMS[param] != '') {
			if (str_url_params != '') { str_url_params += '&'; }
			str_url_params += param + '=' + in_PARAMS[param];
		}
	}
	var splitter = (in_url.indexOf('?') == -1) ? '?' : '&';
	var last_char = (in_url.length > 0) ? in_url.charAt(in_url.length - 1) : '';
	return in_url + ( (last_char == '?' || last_char == '&') ? str_url_params : splitter + str_url_params );
};
// Callback for Timer (called until download not complete)
NL.Upload._func_callback_timer = function(in_STASH, in_time_ms) {
	if (in_STASH['func_Timer'](in_STASH['STASH'], in_time_ms)) {
		if (in_STASH['STASH']['IS_DONE'] != 1) {
			var req_DATA = { 'params': {}, 'callbacks': { 'status': in_STASH['func_Status'] } };
			NL.Upload.get_status(in_STASH['url_status'], req_DATA, in_STASH['STASH']);
		}
		else {
			// OK, files uploaded, not they are processed
		}
	}
};
// Main 'UPLOAD' (EXTERNAL function for uploading)
NL.Upload.upload = function(in_url, in_DATA, in_STASH) {
	if (!in_url || !in_DATA || !in_DATA['params'] || !in_DATA['files'] || !in_DATA['callbacks'] ||
	    typeof(in_DATA['callbacks']['uploaded']) == 'undefined' || typeof(in_DATA['callbacks']['timer']) == 'undefined' ||
	    typeof(in_DATA['callbacks']['status']) == 'undefined') { return 0; }

	// Generating files array
	var ajax_FILES = {};
	for (var i = 0; i < in_DATA['files'].length; i++) { ajax_FILES['file_'+i] = in_DATA['files'][i]; }
	if (i <= 0) { return 0; }

	// Setting Timer interval
	var timer_interval = (in_DATA['settings'] && in_DATA['settings']['timer_interval'] && in_DATA['settings']['timer_interval'] > 0) ? in_DATA['settings']['timer_interval'] : 1000;

	// Adding 'params' to the URL 'query string'
	var url_CLEAN = NL.Upload._makeURL(in_url, in_DATA['params']);
	var url_upload = NL.Upload._makeURL(url_CLEAN, { 'NL_Upload_action': 'upload' });
	var url_status = NL.Upload._makeURL(url_CLEAN, { 'NL_Upload_action': 'get_status' });

	// Calling AJAX Upload
	var func_callback_upload = function(respJS, respTEXT) {
		// Upload complete, stopping timer
		//NL.Timer.timer_delete(timer_interval, NL.Upload._func_callback_timer);
		// Calling 'callback'
		in_DATA['callbacks']['uploaded']( (respJS && respJS.STASH) ? respJS.STASH : {}, in_STASH );
	}
	//NL.AJAX.upload(url_upload, ajax_FILES, func_callback_upload);
	return NL.AJAX.upload(url_upload, {}, ajax_FILES, func_callback_upload);
/*
	// Starting Timer
	var func_callback_status = function(status_DATA, status_STASH) {
		// Files uploaded, now they are processed, stopping timer
		if (status_DATA && status_DATA['result_code'] == 'DONE') {
			status_STASH['IS_DONE'] = 1;
			NL.Timer.timer_update(timer_interval, NL.Upload._func_callback_timer, status_STASH);
		}
		// Calling 'callback'
		in_DATA['callbacks']['status'](status_DATA, status_STASH);
	}
	var timer_DATA = { 'url_status': url_status, 'func_Timer': in_DATA['callbacks']['timer'], 'func_Status': func_callback_status, 'STASH': in_STASH };
	NL.Timer.timer_add_and_on(timer_interval, NL.Upload._func_callback_timer, timer_DATA);
*/
	return 1;
};
// Getting status (usually that is internal function called by Timer)
NL.Upload.get_status = function(in_url, in_DATA, in_STASH) {
	if (!in_url || !in_DATA || !in_DATA['params'] || !in_DATA['callbacks']) return 0;

	// Adding 'params' to the URL 'query string'
	var url = NL.Upload._makeURL(in_url, in_DATA['params']);

	// Calling AJAX Query
	var func_callback = function(respJS, respTEXT) {
		in_DATA['callbacks']['status']( (respJS.STASH) ? respJS.STASH : {}, in_STASH );
	}
	NL.AJAX.query(url, {}, func_callback);
	return 1;
};
// Getting info
NL.Upload.get_info = function(in_url, in_DATA, in_STASH) {
	if (!in_url || !in_DATA || !in_DATA['params'] || !in_DATA['callbacks']) return 0;

	// Adding 'params' to the URL 'query string'
	var url = NL.Upload._makeURL(in_url, in_DATA['params']);

	// Calling AJAX Query
	var func_callback = function(respJS, respTEXT) {
		in_DATA['callbacks']['update_list']( (respJS.STASH) ? respJS.STASH : {}, in_STASH );
	}
	NL.AJAX.query(url, in_DATA['params_POST'] ? in_DATA['params_POST'] : {}, func_callback);
	return 1;
};
