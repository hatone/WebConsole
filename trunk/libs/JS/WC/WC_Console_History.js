/*
* WC :: Console :: History - History methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.History: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.History'); }

// Internal storage
WC.Console.History._DATA = {
	'MAX_LENGHT': 30,
	'CURRENT_NUM': 0,
	'LIST': []
};
// Adding new command to history
WC.Console.History.add = function(in_value) {
	if (in_value) {
		if ( WC.Console.History._DATA['LIST'].length <= 0 ||
		     (WC.Console.History._DATA['LIST'][ WC.Console.History._DATA['LIST'].length - 1 ] != in_value) ) {
			WC.Console.History._DATA['LIST'].push(in_value);
			if (WC.Console.History._DATA['LIST'].length > WC.Console.History._DATA['MAX_LENGHT']) {
				// Removing last element at history
				WC.Console.History._DATA['LIST'].shift();
			}
		}
		// Making last history element active
		WC.Console.History._DATA['CURRENT_NUM'] = WC.Console.History._DATA['LIST'].length;
	}
};
// Resetting history
WC.Console.History.reset = WC.Console.History.empty = function() {
	WC.Console.History._DATA['LIST'] = [];
	WC.Console.History._DATA['CURRENT_NUM'] = 0;
};
// Moving UP at history
WC.Console.History.up = function() {
	if (WC.Console.History._DATA['LIST'].length > 0) {
		if (WC.Console.History._DATA['CURRENT_NUM'] > 0) {
			WC.Console.History._DATA['CURRENT_NUM']--;
			return WC.Console.History._DATA['LIST'][ WC.Console.History._DATA['CURRENT_NUM'] ];
		}
		else return WC.Console.History._DATA['LIST'][0];
	}
	WC.Console.History._DATA['CURRENT_NUM'] = 0;
	return '';
};
// Moving DOWN at history
WC.Console.History.down = function() {
	if (WC.Console.History._DATA['LIST'].length > 0) {
		if (WC.Console.History._DATA['CURRENT_NUM']+1 < WC.Console.History._DATA['LIST'].length)	{
			WC.Console.History._DATA['CURRENT_NUM']++;
			return WC.Console.History._DATA['LIST'][ WC.Console.History._DATA['CURRENT_NUM'] ];
		}
		else {
			WC.Console.History._DATA['CURRENT_NUM'] = WC.Console.History._DATA['LIST'].length;
			return '';
		}
	}
	WC.Console.History._DATA['CURRENT_NUM'] = 0;
	return '';
};
