/*
* WC :: Console :: Exec - Commands execution methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.Exec: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.Exec'); }

// INTERNAL COMMAND EXECUTION
WC.Console.Exec.CMD_INTERNAL = function(in_CMD_NAME, in_CMD_PREFIX, in_CMD_PARAMETERS, in_CMD_VALUES, in_SETTINGS) {
	if (!in_CMD_NAME) in_CMD_NAME = '';
	if (!in_CMD_PARAMETERS) in_CMD_PARAMETERS = {};
	if (!in_CMD_VALUES) in_CMD_VALUES = [];
	if (!in_SETTINGS) in_SETTINGS = {};

	if (in_CMD_PREFIX) {
		// Preparing parameters line
		var parameters_LINE = '';
		for (var id in in_CMD_PARAMETERS) {
			if (parameters_LINE != '') parameters_LINE += ' ';
			parameters_LINE += '"'+NL.String.toLINE_escape(id)+'"="'+NL.String.toLINE_escape(in_CMD_PARAMETERS[id])+'"';
		}
		// Adding values
		for (var i in in_CMD_VALUES) {
			if (parameters_LINE != '') parameters_LINE += ' ';
			parameters_LINE += '"'+NL.String.toLINE_escape(in_CMD_VALUES[i])+'"';
		}
		// Making full CMD with parameters
		if (parameters_LINE != '') {
			var last_char = (in_CMD_PREFIX.length > 0) ? in_CMD_PREFIX.charAt(in_CMD_PREFIX.length - 1) : '';
			if (last_char != ' ') in_CMD_PREFIX += ' ';
		}
		in_CMD_PREFIX += parameters_LINE;

		var is_HIDDEN = (in_SETTINGS['type'] && in_SETTINGS['type'] == 'hidden');
		var hash_IDs = {};
		if (!is_HIDDEN) {
			// Printing element to OUTPUT
			hash_IDs = WC.Console.HTML.add_command('<span class="t-brown"><span class="t-blue">***</span> '+in_CMD_NAME+'</span>');
			// Scrolling to prompt
			WC.Console.Prompt.scroll_to();
			// If timer object is defined - starting timer
			if (hash_IDs['id_timer'] != '') NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': hash_IDs['id_timer']});
		}
		// If SETTING timer object is defined - starting timer
		if (in_SETTINGS['id_TIMER']) NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': in_SETTINGS['id_TIMER']});
		// Executing command using AJAX (sending all parameters using POST)
		var hash_EXEC = {
			'hash_IDs': hash_IDs,
			'hash_SETTINGS': in_SETTINGS
		};
		if (is_HIDDEN) hash_EXEC['type'] = 'hidden';
		WC.Console.AJAX.query({}, {'q_action': 'AJAX_CMD', 'cmd_query': in_CMD_PREFIX}, WC.Console.Response.AJAX_CALLBACK, hash_EXEC);
	}
};
// MAIN COMMAND EXECUTION
WC.Console.Exec.CMD = function(in_CMD) {
	// Checking is it internal command
	if (!WC.Console.Exec.CMD_BROWSER(in_CMD)) {
		// Printing element to OUTPUT
		var hash_IDs = WC.Console.HTML.add_command(in_CMD);
		// Scrolling to prompt
		WC.Console.Prompt.scroll_to();
		// If timer object is defined - starting timer
		if (hash_IDs['id_timer'] != '') NL.Timer.timer_add_and_on_SECOND(WC.Console.Timer.ON_TIMER, {'id': hash_IDs['id_timer']});
		// Executing command using AJAX (sending all parameters using POST)
		WC.Console.AJAX.query({}, {'q_action': 'AJAX_CMD', 'cmd_query': in_CMD}, WC.Console.Response.AJAX_CALLBACK, {'hash_IDs': hash_IDs});
	}
};
// BROWSER COMMAND EXECUTION
// RETURN: 1 - that is was internal command | 0 - that is was not internal command
WC.Console.Exec.CMD_BROWSER = function(in_CMD) {
	var cmd_value = in_CMD; // NL.String.trim(in_CMD);

	// CHECKING COMMAND:
	// Clear screen
	if (cmd_value.match(/^(cls|clear)[ ]{0,}$/i)) WC.Console.Exec.action_CLEAR();
	// That is was not internal command
	else return 0;

	// If we are here - that is was internal command
	return 1;
};
// Action 'CLEAR'
WC.Console.Exec.action_CLEAR = function() {
	WC.Console.HTML.OUTPUT_reset();
	WC.Console.Prompt.activate();
	WC.Console.DATA['PROMPT_is_fosuced'] = 1;
	WC.Console.DATA['GLOBAL_is_grab_input'] = 1;
};
