/*
* WC :: Console :: State - Internal state of Web Console
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.State: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.State'); }

// Defining intenal variables
WC.Console.State.USER_LOGIN = '';
WC.Console.State.USER_PASSWORD_ENCRYPTED = '';
WC.Console.State.DIR_CURRENT = '';
WC.Console.State.FLAG_SHOW_WELCOME = 1;
WC.Console.State.FLAG_SHOW_WARNINGS = 1;
WC.Console.State.IS_DEMO = 0;
// Setting internal state variable
WC.Console.State.set = function(in_NAME, in_VALUE) {
	if (typeof(in_NAME) != 'undefined' && typeof(in_VALUE) != 'undefined') {
		if (typeof(WC.Console.State[in_NAME]) != 'undefined') {
			WC.Console.State[in_NAME] = in_VALUE;
		}
	}
};
// Getting state at JS hash
WC.Console.State.get_JS = function() {
	return {
		'dir_current': WC.Console.State.DIR_CURRENT
	};
};
// Changing directory
WC.Console.State.change_dir = function(in_dir) {
	if (typeof in_dir != 'undefined') {
		WC.Console.State.set('DIR_CURRENT', in_dir);
		WC.Console.Prompt.prefix_value_set_dir(in_dir);
	}
};
