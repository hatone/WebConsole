/*
* WC :: WC CORE
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
// Defining Namespace
if (typeof WC == "undefined") { var WC = {}; }
// New namespace registration
WC.namespace = function() {
	var a = arguments, o = null, i, j, d;
	for (i = 0; i < a.length; i = i + 1) {
		o = WC;
		d = a[i].split('.');
		for (j = (d[0] == 'WC') ? 1 : 0; j < d.length; j = j + 1) {
			o[ d[j] ] = o[ d[j] ] || {};
			o = o[ d[j] ];
		}
	}
	return o;
};
