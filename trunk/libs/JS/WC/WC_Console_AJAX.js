/*
* WC :: AJAX - AJAX implementation
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.AJAX: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.AJAX'); }

// Settings of AJAX
WC.Console.AJAX._DATA = {
	'url':'wc.pl'
};
// Parsing parameters and making single values from HASHES
WC.Console.AJAX._params_parse = function(in_PARAMS) {
	for (var i in in_PARAMS) {
		if (typeof in_PARAMS[i] == 'object') {
			for (var j in in_PARAMS[i]) {
				if (typeof in_PARAMS[i+'_'+j] == 'undefined') in_PARAMS[i+'_'+j] = in_PARAMS[i][j];
			}
			delete in_PARAMS[i];
		}
	}
	return in_PARAMS;
};
// AJAX request
WC.Console.AJAX.query = function(in_PARAMS_GET, in_PARAMS_POST, in_FUNC_CALLBACK, in_STASH, in_ENABLE_CACHING) {
	if (!in_PARAMS_GET) in_PARAMS_GET = {};
	if (!in_PARAMS_POST) in_PARAMS_POST = {};
	if (typeof in_PARAMS_POST['user_login'] == 'undefined' && typeof WC.Console.State.USER_LOGIN != 'undefined') in_PARAMS_POST['user_login'] = WC.Console.State.USER_LOGIN;
	if (typeof in_PARAMS_POST['user_password'] == 'undefined' && typeof WC.Console.State.USER_PASSWORD_ENCRYPTED != 'undefined') in_PARAMS_POST['user_password'] = WC.Console.State.USER_PASSWORD_ENCRYPTED;
	if (typeof in_PARAMS_POST['STATE'] != 'object')	in_PARAMS_POST['STATE'] = WC.Console.State.get_JS();
	in_PARAMS_GET = WC.Console.AJAX._params_parse(in_PARAMS_GET);
	in_PARAMS_POST = WC.Console.AJAX._params_parse(in_PARAMS_POST);
	NL.AJAX.query(WC.Console.AJAX._DATA['url'], in_PARAMS_GET, in_PARAMS_POST, function(in_JS) { in_FUNC_CALLBACK(in_JS, in_STASH ? in_STASH : {}); }, (in_ENABLE_CACHING) ? true : false, in_STASH ? in_STASH : null);
};
