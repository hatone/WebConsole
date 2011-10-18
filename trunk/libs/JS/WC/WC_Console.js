/*
* WC :: Console - Main console methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console'); }

/* Internal variables (we need very fast access to it) */
WC.Console.IS_INITIALIZED = 0;
WC.Console.ID_PROMPT = '';
WC.Console.ID_PROMPT_PREFIX = '';
WC.Console.ID_OUTPUT = '';
WC.Console.OBJ_PROMPT = undefined;
WC.Console.OBJ_PROMPT_PREFIX = undefined;
WC.Console.OBJ_OUTPUT = undefined;
/* Internal DATA container */
WC.Console.DATA = {
	'PROMPT_is_fosuced': 0,
	'PROMPT_cursor_position': -1,
	'GLOBAL_is_grab_input': 1
};
// Customizable function that called after starting
WC.Console.additional_JAVASCRIPT = function() {};
// Initialization and starting
WC.Console.init_and_start = function(in_ID_PROMPT, in_ID_OUTPUT, in_ID_PROMPT_PREFIX) {
	if (in_ID_PROMPT && in_ID_OUTPUT && WC.Console.init(in_ID_PROMPT, in_ID_OUTPUT, in_ID_PROMPT_PREFIX ? in_ID_PROMPT_PREFIX : undefined)) {
		return WC.Console.start();
	}
	else return 0;
};
// Initialization
WC.Console.init = function(in_ID_PROMPT, in_ID_OUTPUT, in_ID_PROMPT_PREFIX) {
	var obj;
	if (in_ID_PROMPT_PREFIX) {
		obj = xGetElementById(in_ID_PROMPT_PREFIX);
		if (obj) {
			WC.Console.ID_PROMPT_PREFIX = in_ID_PROMPT_PREFIX;
			WC.Console.OBJ_PROMPT_PREFIX = obj;
		}
	}
	if (in_ID_PROMPT) {
		obj = xGetElementById(in_ID_PROMPT);
		if (obj) {
			WC.Console.ID_PROMPT = in_ID_PROMPT;
			WC.Console.OBJ_PROMPT = obj;
		}
	}
	if (in_ID_OUTPUT) {
		obj = xGetElementById(in_ID_OUTPUT);
		if (obj) {
			WC.Console.ID_OUTPUT = in_ID_OUTPUT;
			WC.Console.OBJ_OUTPUT = obj;
		}
	}
	// Registering 'insertAdjacentElement' method
	WC.DOM.REGISTER_insertAdjacentElement();
	if (WC.Console.OBJ_PROMPT && in_ID_OUTPUT) {
		WC.Console.IS_INITIALIZED = 1;
		// Initializing 'NL.AJAX'
		NL.AJAX.set_ERROR_HANDLER(WC.Console.Response.AJAX_ERROR);
		// Initializing PROMPT (getting default value of PROMPT prefix)
		WC.Console.Prompt.init();
		return 1;
	}
	else return 0;
};
// Starting
WC.Console.start = function() {
	if (WC.Console.IS_INITIALIZED) {
		// Showing 'Powered by' message
		WC.Console.HTML.add_powered_by();
		// Showing 'Welcome' message
		WC.Console.HTML.add_welcome(WC.Console.State.FLAG_SHOW_WELCOME, WC.Console.State.FLAG_SHOW_WARNINGS, WC.Console.State.IS_DEMO);
		// Initializing hooks
		WC.Console.Hooks.init();
		// Scrolling to and focusing command prompt
		WC.Console.Prompt.activate();
		// Executing customizable function
		WC.Console.additional_JAVASCRIPT();
		return 1;
	}
	else return 0;
};
// MAKING ACTION - THAT IS MAIN FUNCTION FOR ANY ACTION
WC.Console.ACTION = function(in_ACTION) {
	// Looking for ACTION
 	if (in_ACTION == 'ENTER') {
		var cmd_text = WC.Console.Prompt.value_get();
		if (typeof(cmd_text) != 'undefined' && cmd_text != '') {
			WC.Console.History.add(cmd_text);
			WC.Console.Prompt.value_set('');
			WC.Console.Exec.CMD(cmd_text);
		}
	}
	else if (in_ACTION == 'UP') {
		WC.Console.Prompt.value_set( WC.Console.History.up() );
		/* PROBLEM WAS FIXED BY ADDING 'autocomplete="off"' TO INPUT
		// Opera scrolling problem simple fix (input always bypass 'UP' key event to Opera)
		if (NL.Browser.Detect.isOPERA) {
			var arr_intervals = [10, 15, 20, 25, 50, 100];
			for (var i in arr_intervals) { setTimeout(function() { WC.Console.Prompt.scroll_to(); }, arr_intervals[i]); }
		}
		*/
	}
	else if (in_ACTION == 'DOWN') WC.Console.Prompt.value_set( WC.Console.History.down() );
	else if (in_ACTION == 'TAB') {
		// 'TAB' commands will not be added to the history
		// WC.Console.History.add(WC.Console.Prompt.value_get());
		// WC.Console.History.up();
		WC.Console.Autocomplete.CMD( WC.Console.Prompt.value_get_left_part() );
	}
	else if (in_ACTION == 'CTRL-D') {
		// Close window
		if (NL.Browser.Detect.isFF) {
			// FireFox 'window.close()' solution - in FireFox 2.0 this don't work out of the box. You also need to:
			//  - about:config
			//  - dom.allow_scripts_to_close_windows = true
			window.open('javascript:window.close();', '_self', '');
			window.close();
		}
		else {
			if (NL.Browser.Detect.isIE) window.opener = 'x';
			window.close();
		}
	}
	else {
		// Unknown ACTION
		// alert(in_ACTION);
	}
};
// Setting USER login/password
WC.Console.SET_USER = function(in_LOGIN, in_PASSWORD_ENCRYPTED) {
	WC.Console.State.set('USER_LOGIN', in_LOGIN ? in_LOGIN : '');
	WC.Console.State.set('USER_PASSWORD_ENCRYPTED', in_PASSWORD_ENCRYPTED ? in_PASSWORD_ENCRYPTED : '');
};
