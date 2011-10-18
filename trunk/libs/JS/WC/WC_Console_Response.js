/*
* WC :: Console :: Response - Responses processing
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.Response: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('WC.Console.Response'); }

// Internal storage
WC.Console.Response._DATA = {
	'LAST_DIR_CHANGE_ID': 0
};

// Function that called when we have response from AJAX
WC.Console.Response.AJAX_CALLBACK = function(in_JS_DATA, in_STASH) {
	if (in_JS_DATA) {
		// Getting and executing action
		var is_HIDDEN = (in_STASH['type'] && in_STASH['type'] == 'hidden');
		if (in_STASH && ( (in_STASH['hash_IDs'] && in_STASH['hash_IDs']['id_result']) || is_HIDDEN)) {
			var obj = (is_HIDDEN) ? null : xGetElementById(in_STASH['hash_IDs']['id_result']);
			if (obj || is_HIDDEN) {
				// OK, object for that action is waining action result
				var is_CRITICAL = 0;
				var SET_result = '';
				var EXEC_JS = '';
				var INPUTS_EDITABLE = 0;
				var AJAX_text = (typeof in_JS_DATA['text'] != 'undefined') ? in_JS_DATA['text'] : '';
				if (in_JS_DATA['action'] && in_JS_DATA['action'] != '') {
					if (in_JS_DATA['action'] == 'INFO' || in_JS_DATA['action'] == 'ERROR' || in_JS_DATA['action'] == 'WARNING') {
						SET_result = WC.Console.HTML.get_MESSAGE_TITLE(  in_JS_DATA['action'].toLowerCase() ) + AJAX_text;
						is_CRITICAL = 1;
					}
					else if (in_JS_DATA['action'] == 'CMD_RESULT') {
						SET_result = AJAX_text;
						if (in_JS_DATA['action_params']) {
							if (in_JS_DATA['action_params']['JS_CODE']) {
								EXEC_JS = in_JS_DATA['action_params']['JS_CODE'];
							}
							if (in_JS_DATA['action_params']['INPUTS_EDITABLE']) { INPUTS_EDITABLE = 1; }
						}
					}
					else if (in_JS_DATA['action'] == 'DIR_CHANGE') {
						if (in_JS_DATA['action_params'] && in_JS_DATA['action_params']['dir_now']) {
							var update_dir = 1;
							if (in_JS_DATA['action_params']['JS_REQUEST_ID']) {
								update_dir = 0;
								if (WC.Console.Response._DATA['LAST_DIR_CHANGE_ID'] <= 0 || WC.Console.Response._DATA['LAST_DIR_CHANGE_ID'] < in_JS_DATA['action_params']['JS_REQUEST_ID']) {
									WC.Console.Response._DATA['LAST_DIR_CHANGE_ID'] = in_JS_DATA['action_params']['JS_REQUEST_ID'];
									update_dir = 1;
								}
							}
							if (update_dir) {
								// Updating internal state directory
								WC.Console.State.change_dir(in_JS_DATA['action_params']['dir_now']);
								// Printing message
								SET_result = '<div class="t-lime">Current Web Console directory is: "' + WC.Console.HTML.message_str_right(in_JS_DATA['action_params']['dir_now']) + '"</div>';
							}
						}
					}
					else if (in_JS_DATA['action'] == 'TAB_RESULT') {
						if (in_JS_DATA['action_params']) {
							if (typeof in_JS_DATA['action_params']['str_IN'] != 'undefined' && ( (typeof in_JS_DATA['action_params']['ALWAYS_SHOW'] != 'undefined' && in_JS_DATA['action_params']['ALWAYS_SHOW']) || WC.Console.Prompt.value_get_left_part() == in_JS_DATA['action_params']['str_IN']) ) {
								if (typeof in_JS_DATA['action_params']['TITLE'] != 'undefined' && in_JS_DATA['action_params']['TITLE'] != '') {
									SET_result += '<div class="t-lime">'+in_JS_DATA['action_params']['TITLE']+'</div>';
								}
								if (typeof in_JS_DATA['action_params']['INFO'] != 'undefined' && in_JS_DATA['action_params']['INFO'] != '') {
									SET_result += '<div class="t-green-light">'+in_JS_DATA['action_params']['INFO']+'</div>';
								}
								if (typeof in_JS_DATA['action_params']['SUBTITLE'] != 'undefined' && in_JS_DATA['action_params']['SUBTITLE'] != '') {
									SET_result += '<div class="t-blue">'+in_JS_DATA['action_params']['SUBTITLE']+'</div>';
								}
								if (typeof in_JS_DATA['action_params']['TEXT'] != 'undefined' && in_JS_DATA['action_params']['TEXT'] != '') {
									SET_result += '<div>'+in_JS_DATA['action_params']['TEXT']+'</div>';
								}
								if (in_JS_DATA['action_params']['JS_CODE']) { EXEC_JS = in_JS_DATA['action_params']['JS_CODE']; }
								if (in_JS_DATA['action_params']['INPUTS_EDITABLE']) { INPUTS_EDITABLE = 1; }
	 							if (typeof in_JS_DATA['action_params']['cmd_left_update'] != 'undefined' && in_JS_DATA['action_params']['cmd_left_update'] != '') {
									WC.Console.Prompt.value_set(in_JS_DATA['action_params']['cmd_left_update'], 0, String(in_JS_DATA['action_params']['str_IN']).length);
								}
								else if (typeof in_JS_DATA['action_params']['cmd_add'] != 'undefined' && in_JS_DATA['action_params']['cmd_add'] != '') {
									WC.Console.Prompt.paste(in_JS_DATA['action_params']['cmd_add'], 1);
								}
							}
							// If we have array of variants
							if (typeof in_JS_DATA['action_params']['values'] == 'object') {
								var str_variants = '';
								for (var i in in_JS_DATA['action_params']['values']) {
									if (str_variants != '') str_variants += '<br />';
									str_variants += in_JS_DATA['action_params']['values'][i];
								}
								SET_result += str_variants;
							}
						}
					}
				}
				if (!is_HIDDEN || is_CRITICAL) {
					if (obj) {
						if (SET_result != '') obj.innerHTML = SET_result;
						else if (AJAX_text != '') obj.innerHTML = AJAX_text;
						else {
							obj.innerHTML = '';
							obj.parentNode.removeChild(obj);
						}
					}
					else WC.Console.HTML.add_cmd_message('<span class="t-red"><span class="t-blue">***</span> CRITICAL MESSAGE</span>', SET_result || AJAX_text);
				}
				if (EXEC_JS != '') eval(EXEC_JS);
				if (!is_HIDDEN) {
					if (INPUTS_EDITABLE) WC.Console.Response.set_input_editable(obj);
					WC.Console.Prompt.scroll_to();
				}
				// If settings defined
				if (in_STASH['hash_SETTINGS']) {
					if (in_STASH['hash_SETTINGS']['func_callback']) {
						in_STASH['hash_SETTINGS']['func_callback'](in_JS_DATA, in_STASH);
					}
				}
			}
		}
	}
};
// Setting all inputs inside object editable
WC.Console.Response.set_input_editable = function(in_obj) {
	if (in_obj) {
		var is_finded = 0;
		if (in_obj.tagName) {
			var tag_name = (in_obj.tagName) ? in_obj.tagName.toLowerCase() : '';
			if (tag_name == 'input') {
				var type = (in_obj.type) ? in_obj.type.toLowerCase() : '';
				if (type == 'text' || type == 'password' || type == 'checkbox' || type == 'radio') { is_finded = 1; }
			}
			else if (tag_name == 'select') { is_finded = 1; }
			else if (tag_name == 'textarea') {
				is_finded = 1;
				NL.UI.input_allow_tab(in_obj);
			}
		}
		if (is_finded) {
			xAddEventListener(in_obj, 'focus', function(e) { WC.Console.Hooks.GRAB_OFF(in_obj); }, false);
			xAddEventListener(in_obj, 'blur', function(e) { WC.Console.Hooks.GRAB_ON(in_obj); }, false);
		}
		else (in_obj.hasChildNodes())
		{
			var c = in_obj.childNodes;
			for (var i = 0; i < c.length; i++) {
				WC.Console.Response.set_input_editable(c[i]);
			}
		}
	}
};
// Printing NL.AJAX error
WC.Console.Response.AJAX_ERROR = function(in_TEXT, in_STASH) {
	var IS_PRINTED = 0;
	if (typeof in_STASH != 'undefined' && in_STASH) {
		if (in_STASH['hash_IDs'] && in_STASH['hash_IDs']['id_result']) {
			var obj = xGetElementById(in_STASH['hash_IDs']['id_result']);
			if (obj) {
				IS_PRINTED = 1;
				var str_info = '';
				if (in_TEXT.match(/^JavaScript code generated by backend is invalid![ \s\t\r\n]{0,}$/)) str_info = '* Looks like too slow connection or connection has been closed by server.';
				obj.innerHTML = WC.Console.HTML.get_AJAX_error(in_TEXT, str_info);
				WC.Console.Prompt.scroll_to();
			}
		}
	}
	if (!IS_PRINTED && WC.Console.State.FLAG_SHOW_WARNINGS) alert("AJAX ERROR:\n" + in_TEXT);
};
