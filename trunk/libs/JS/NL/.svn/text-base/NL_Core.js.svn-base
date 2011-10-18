/*
* NL :: NL library CORE
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
// Defining Namespace
if (typeof NL == "undefined") { var NL = {}; }
// New namespace registration
NL.namespace = function() {
	var a = arguments, o = null, i, j, d;
	for (i = 0; i < a.length; i = i + 1) {
		o = NL;
		d = a[i].split('.');
		for (j = (d[0] == 'NL') ? 1 : 0; j < d.length; j = j + 1) {
			o[ d[j] ] = o[ d[j] ] || {};
			o = o[ d[j] ];
		}
	}
	return o;
};
// Simple 'foreach' function
NL.fe = NL.foreach = function(in_obj, in_func) { for (var i in in_obj) { in_func(i, in_obj[i]); } };
// Call function from REDISTR
NL.REDISTR_CALL = function(in_OBJ_REDISTR, in_STR_FUNC, in_OBJ_ARGUMENTS) {
	var result = in_OBJ_REDISTR(in_STR_FUNC, in_OBJ_ARGUMENTS);
	if (result && result[0]) return result[1];
	else alert("NL: Error, unable to call function '"+str_func+"' from REDISTR");
	return 0;
};
