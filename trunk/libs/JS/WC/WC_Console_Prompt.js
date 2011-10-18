/*
* WC :: Console :: Prompt - Prompt manipulation methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.Prompt: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.Prompt'); }

// Internal storage
WC.Console.Prompt._DATA = {
	'PROMPT_PREFIX_VALUE': ''
};
// Initializing PROMPT (getting default value of PROMPT prefix)
WC.Console.Prompt.init = function() {
	if (WC.Console.OBJ_PROMPT_PREFIX) {
		if (WC.Console.OBJ_PROMPT_PREFIX.innerHTML && WC.Console.OBJ_PROMPT_PREFIX.innerHTML != '') {
			WC.Console.Prompt._DATA['PROMPT_PREFIX_VALUE'] = WC.Console.OBJ_PROMPT_PREFIX.innerHTML;
		}
		if (WC.Console.State.DIR_CURRENT != '') WC.Console.Prompt.prefix_value_set_dir(WC.Console.State.DIR_CURRENT);
	}
};
// Scrolling to PROMPT
WC.Console.Prompt.scroll_to = function() {
	// Scrolling to PROMPT
	if (WC.Console.OBJ_PROMPT_PREFIX.scrollIntoView) {
		WC.Console.OBJ_PROMPT_PREFIX.scrollIntoView(true);
		if (NL.Browser.Detect.isOPERA) window.scrollBy(-xDocSize().w, 0);
	}
	else if (window.scrollBy) {
		// Getting MAX width, height and scrolling
		var size = xDocSize();
		// Windows Safari rendering fix (probalply that it only Windows Safari bug)
		// if (NL.Browser.Detect.isSAFARI) { /* WC.Console.OBJ_OUTPUT.scrollIntoView(false); */ window.scrollBy(-size.w, -100); }
		window.scrollBy(-size.w, size.h);
	}
};
// Maing PROMPT active
WC.Console.Prompt.activate = function() {
	// Scrolling to PROMPT
	WC.Console.Prompt.scroll_to();
	// Setting focus to the needed position
	WC.Console.Prompt.cursor_position_set( (WC.Console.DATA['PROMPT_cursor_position'] >= 0) ? WC.Console.DATA['PROMPT_cursor_position'] : -1);
};
// Setting value
WC.Console.Prompt.value_set = function(in_VALUE, in_FROM, in_LEN) {
	if (WC.Console.OBJ_PROMPT && typeof in_VALUE != 'undefined') {
		if (typeof in_FROM != 'undefined' && in_FROM >= 0) {
			var value_WAS = WC.Console.OBJ_PROMPT.value;
			if (value_WAS.length >= in_FROM) {
				var value_LEFT = value_WAS.substr(0, in_FROM);
				if (typeof in_LEN != 'undefined' && in_LEN > 0) {
					var value_RIGHT = (value_WAS.length > in_FROM + in_LEN) ? value_WAS.substr(in_FROM + in_LEN) : '';
					WC.Console.OBJ_PROMPT.value = value_LEFT + in_VALUE + value_RIGHT;
				}
				else {
					WC.Console.OBJ_PROMPT.value = value_LEFT + in_VALUE + value_WAS.substr(in_FROM);
				}
				var position_NEW = value_LEFT.length + in_VALUE.length;
				WC.Console.Prompt.cursor_position_set(position_NEW);
			}
		}
		else {
			WC.Console.OBJ_PROMPT.value = in_VALUE;
			WC.Console.Prompt.cursor_position_set(-1);
		}
	}
};
// Getting value
WC.Console.Prompt.value_get = function() { return WC.Console.OBJ_PROMPT ? WC.Console.OBJ_PROMPT.value : ''; };
// Getting left part of value at cursor
WC.Console.Prompt.value_get_left_part = function() {
	if (WC.Console.OBJ_PROMPT) {
		var cursor_pos = WC.Console.Prompt.cursor_position_get();
		if (cursor_pos >= 0 && WC.Console.OBJ_PROMPT.value.length >= cursor_pos) {
			return WC.Console.OBJ_PROMPT.value.substr(0, cursor_pos);
		}
	}
	return '';
};
// Setting selection
WC.Console.Prompt.selection_set = function(in_FROM, in_TO) {
	if (WC.Console.OBJ_PROMPT) {
		if (WC.Console.OBJ_PROMPT.selectionStart) {
			WC.Console.OBJ_PROMPT.focus();
			WC.Console.OBJ_PROMPT.setSelectionRange(in_FROM, in_TO);
			//if (in_FROM == 0 && in_FROM == in_TO) WC.Console.OBJ_PROMPT.focus();
			return true;
		}
	}
	return 0;
};
// Setting cursor posisiton
WC.Console.Prompt.cursor_position_set = function(in_POS) {
	if (WC.Console.OBJ_PROMPT) {
		// If needed position id not defined - setting it to the end
		if (typeof in_POS == 'undefined' || in_POS < 0) {
			in_POS = (WC.Console.OBJ_PROMPT.value && WC.Console.OBJ_PROMPT.value.length) ? WC.Console.OBJ_PROMPT.value.length : 0;
		}
		// Setting cursor posisiton
		if (WC.Console.OBJ_PROMPT.createTextRange) {
			var range = WC.Console.OBJ_PROMPT.createTextRange();
			range.move('character', in_POS);
			range.select();
			return 1;
		}
		else if (WC.Console.OBJ_PROMPT.selectionStart) {
			WC.Console.OBJ_PROMPT.focus();
			WC.Console.OBJ_PROMPT.setSelectionRange(in_POS, in_POS);
			if (in_POS == 0) WC.Console.OBJ_PROMPT.focus();
			// var new_event = document.createEvent('KeyboardEvent');
			// new_event.initKeyEvent('keydown', true, true, null, false, false, false, false, 39, 0);
			// WC.Console.OBJ_PROMPT.dispatchEvent(new_event);
			return 1;
		}
		else WC.Console.OBJ_PROMPT.focus();
	}
	return 0;
};
// Getting cursor posisiton
WC.Console.Prompt.cursor_position_get = function() {
	if (WC.Console.OBJ_PROMPT) {
		var obj = WC.Console.OBJ_PROMPT;
		if (obj.createTextRange) {
			var r = document.selection.createRange().duplicate();
			r.moveEnd('character', obj.value.length);
			if (r.text == '') return obj.value.length;
			else return obj.value.lastIndexOf(r.text);
		}
		else return obj.selectionStart || 0;
	}
	return 0;
};
// Pasting text at current cursor position
WC.Console.Prompt.paste = function(in_TEXT, is_NO_FIX) {
	if (WC.Console.OBJ_PROMPT && in_TEXT && in_TEXT != '') {
		// Making FIX of TEXT if needed
		if(!is_NO_FIX) in_TEXT = NL.String.trim( NL.String.toLINE(in_TEXT) );
 		// Calculating position of insertion and making insertion
 		var insert_pos = WC.Console.Prompt.cursor_position_get();
		if (insert_pos < 0) insert_pos = WC.Console.DATA['PROMPT_cursor_position']
		if (insert_pos > WC.Console.OBJ_PROMPT.value.length) {
			insert_pos = WC.Console.OBJ_PROMPT.value.length;
			WC.Console.OBJ_PROMPT.value += in_TEXT;
		}
		else if (insert_pos <= 0) {
			insert_pos = 0;
			WC.Console.OBJ_PROMPT.value = in_TEXT + WC.Console.OBJ_PROMPT.value;
		}
		else {
			var str_left = WC.Console.OBJ_PROMPT.value.substr(0, insert_pos);
			var str_right = WC.Console.OBJ_PROMPT.value.substr(insert_pos);
			WC.Console.OBJ_PROMPT.value = str_left + in_TEXT + str_right;
		}
		WC.Console.DATA['PROMPT_cursor_position'] = insert_pos + in_TEXT.length;
		WC.Console.Prompt.activate();
		return true;
	}
	return false;
};
// Setting PROMPT prefix value
WC.Console.Prompt.prefix_value_set = function(in_VALUE) {
	if (WC.Console.OBJ_PROMPT_PREFIX && typeof(in_VALUE) != 'undefined') {
		WC.Console.OBJ_PROMPT_PREFIX.innerHTML = in_VALUE;
	}
};
// Getting PROMPT default prefix value
WC.Console.Prompt.prefix_value_get_default = function() {
	return WC.Console.Prompt._DATA['PROMPT_PREFIX_VALUE'];
};
// Setting PROMPT prefix value to default
WC.Console.Prompt.prefix_value_reset = function() {
	if (WC.Console.Prompt._DATA['PROMPT_PREFIX_VALUE'] != '') {
		WC.Console.Prompt.prefix_value_set(WC.Console.Prompt._DATA['PROMPT_PREFIX_VALUE']);
	}
};
// Setting PROMPT prefix value to directory
WC.Console.Prompt.prefix_value_set_dir = function(in_VALUE) {
	if (typeof(in_VALUE) != 'undefined' && in_VALUE != '') {
		WC.Console.Prompt.prefix_value_set(NL.String.toHTML(NL.String.get_str_right_dottes(in_VALUE, 30)) + WC.Console.Prompt._DATA['PROMPT_PREFIX_VALUE']);
	}
};
