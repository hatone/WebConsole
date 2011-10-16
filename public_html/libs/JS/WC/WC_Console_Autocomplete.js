/*
* WC :: Console :: Exec - Commands execution methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: DEV
*/
if (typeof WC == "undefined") { alert("WC.Console.Autocomplete: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.Autocomplete'); }

// MAIN COMMAND AUTOCOMPLETION
WC.Console.Autocomplete.CMD = function(in_CMD) {
	// Checking is it internal command
	if (!WC.Console.Autocomplete.CMD_INTERNAL(in_CMD)) {
		// Printing element to OUTPUT
		var hash_IDs = WC.Console.HTML.add_TAB();
		// Scrolling to prompt
		WC.Console.Prompt.scroll_to();
		// If timer object is defined - starting timer
		if (hash_IDs['id_timer'] != '') NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': hash_IDs['id_timer']});
		// Executing command using AJAX (sending all parameters using POST)
		WC.Console.AJAX.query({}, {'q_action': 'AJAX_TAB', 'cmd_query': in_CMD}, WC.Console.Response.AJAX_CALLBACK, {'hash_IDs': hash_IDs});
	}
};
// INTERNAL COMMAND AUTOCOMPLETION
// RETURN: 1 - that is was internal command | 0 - that is was not internal command
WC.Console.Autocomplete.CMD_INTERNAL = function(in_CMD) {
	var cmd_value = in_CMD; // NL.String.trim(in_CMD);

	return 0;
	// CHECKING COMMAND:
	// Clear screen
	//if (cmd_value.match(/^(cls|clear)[ ]{0,}$/i)) { WC.Console.HTML.OUTPUT_reset(); WC.Console.Prompt.activate(); }
	// That is was not internal command
	//else return 0;

	// If we are here - that is was internal command
	return 1;
};
