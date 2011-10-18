/*
* WC :: Console :: Hooks - Browser hooks
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.Hooks: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.Hooks'); }

// Internal storage
WC.Console.Hooks._DATA = {
	'LAST_FOCUSED_OBJ': null,
	'LAST_FOCUSED_ID': '',
	'OPERA_CLIPBOARD': '',
	'OPERA_PROMPT_LAST_KEY': null
};
// Initialization of hooks (setting all needed hooks)
WC.Console.Hooks.init = function() {
	if (WC.Console.IS_INITIALIZED) {
		// Events for 'PROMPT PREFIX', if it is defined
		if (WC.Console.OBJ_PROMPT_PREFIX) {
			// Mouse click at 'PROMPT PREFIX'
			xAddEventListener(WC.Console.OBJ_PROMPT_PREFIX, 'click', function() { WC.Console.Prompt.activate(); return false; }, false);
		}
		// Events for 'PROMPT', if it is defined
		if (WC.Console.OBJ_PROMPT) {
			// 'PROMPT' focus/blur
			xAddEventListener(WC.Console.OBJ_PROMPT, 'focus', function () {
				WC.Console.DATA['PROMPT_is_fosuced'] = 1;
				return true;
			}, false);
			xAddEventListener(WC.Console.OBJ_PROMPT, 'blur', function () {
				WC.Console.DATA['PROMPT_is_fosuced'] = 0;
				return true;
			}, false);

			// Saving cursor at PROMPT when it is changed
			xAddEventListener(WC.Console.OBJ_PROMPT, 'click', WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE, false);
			xAddEventListener(WC.Console.OBJ_PROMPT, 'keyup', WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE, false);
			xAddEventListener(WC.Console.OBJ_PROMPT, 'keypress', WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE, false);
			xAddEventListener(WC.Console.OBJ_PROMPT, 'mouseup', WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE, false);
			xAddEventListener(WC.Console.OBJ_PROMPT, 'mousedown', WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE, false);
				//xAddEventListener(WC.Console.OBJ_PROMPT, 'keydown', WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE, false);

			// Addition to 'KEYPRESS' hook for FireFox (needed to support UP/DOWN keys)
			if (NL.Browser.Detect.isFF) {
				// We don't use 'xAddEventListener' because that is don't allow to 'return false' and stop event processing
				WC.Console.OBJ_PROMPT.onkeydown = WC.Console.Hooks.prompt_KEYPRESS_FF_UP_DOWN;
			}
		}
		// GLOBAL 'KEYPRESS' HOOK
		if (NL.Browser.Detect.isIE || NL.Browser.Detect.isSAFARI) {
			// We don't use 'xAddEventListener' because that is don't allow to 'return false' and stop event processing
			document.onkeydown = WC.Console.Hooks.global_KEYPRESS;
		}
		else if (NL.Browser.Detect.isOPERA) {
			// Opera TAB workaround
			xAddEventListener(WC.Console.OBJ_PROMPT, 'focus', function() { WC.Console.Hooks._DATA['OPERA_PROMPT_LAST_KEY'] = null; }, false);
			xAddEventListener(WC.Console.OBJ_PROMPT, 'blur', function() { if (WC.Console.Hooks._DATA['OPERA_PROMPT_LAST_KEY'] == 9) { this.focus(); return false; } return true; }, false);
			xAddEventListener(WC.Console.OBJ_PROMPT, 'keydown', function(e) { if (e.keyCode && e.keyCode == 9) WC.Console.Hooks._DATA['OPERA_PROMPT_LAST_KEY'] = e.keyCode; }, false);
			document.onkeypress = WC.Console.Hooks.global_KEYPRESS;
		}
		else {
			// We don't use 'xAddEventListener' because that is don't allow to 'return false' and stop event processing
			document.onkeypress = WC.Console.Hooks.global_KEYPRESS;
		}
		// COPY/PASTE feature by right mouse button
		if (NL.Browser.Detect.isIE || NL.Browser.Detect.isFF || NL.Browser.Detect.isSAFARI) document.oncontextmenu = WC.Console.Hooks.global_ONCONTEXTMENU;
		else if (NL.Browser.Detect.isOPERA) {
			// Workaroud for OPERA - 'CTRL + RIGHT MOUSE BUTTON'
			// Making selection copy by 'CTRL'
			xAddEventListener(document, 'keydown', function(e) {
				if (e.ctrlKey) WC.Console.Hooks._DATA['OPERA_CLIPBOARD'] = WC.Console.Clipboard.selection_get() || (WC.Console.OBJ_PROMPT ? WC.Console.Clipboard.selection_get_OBJ(WC.Console.OBJ_PROMPT): '');
				else WC.Console.Hooks._DATA['OPERA_CLIPBOARD'] = '';

			}, false);
			// Mouse click (for pasting)
			document.onclick = function(e) {
				if (e.ctrlKey) { WC.Console.Hooks.global_ONCONTEXTMENU(null, WC.Console.Hooks._DATA['OPERA_CLIPBOARD']); return false; }
			};
		}
	}
};
// Turning global keys grab OFF
WC.Console.Hooks.GRAB_OFF = function(in_OBJ) {
	WC.Console.Hooks._DATA['LAST_FOCUSED_OBJ'] = in_OBJ;
	WC.Console.Hooks._DATA['LAST_FOCUSED_ID'] = in_OBJ.id ? in_OBJ.id : '';
	WC.Console.DATA['GLOBAL_is_grab_input'] = 0;
};
// Turning global keys grab ON
WC.Console.Hooks.GRAB_ON = function(in_OBJ) {
	WC.Console.Hooks._DATA['LAST_FOCUSED_OBJ'] = null;
	WC.Console.Hooks._DATA['LAST_FOCUSED_ID'] = '';
	WC.Console.DATA['GLOBAL_is_grab_input'] = 1;
};
// Checking is focused element exists, if not - setting GRAB ON
WC.Console.Hooks.chech_focused_FIX_GRAB = function() {
	if (WC.Console.Hooks._DATA['LAST_FOCUSED_ID']) {
		if (!xGetElementById(WC.Console.Hooks._DATA['LAST_FOCUSED_ID'])) {
			WC.Console.Hooks._DATA['LAST_FOCUSED_ID'] = '';
			WC.Console.Hooks._DATA['LAST_FOCUSED_OBJ'] = null;
			WC.Console.DATA['GLOBAL_is_grab_input'] = 1;
		}
	}
};
// Hook for СOPY/PASTE feature by right mouse button
WC.Console.Hooks.global_ONCONTEXTMENU = function(e, in_OPERA_CLIPBOARD) {
	// Getting current selection at WINDOW or DOCUMENT
	var str_selection = (in_OPERA_CLIPBOARD) ? in_OPERA_CLIPBOARD : WC.Console.Clipboard.selection_get();
	if (str_selection == '') {
		if (WC.Console.OBJ_PROMPT) {
			// Getting selection at PROMPT
			str_selection = WC.Console.Clipboard.selection_get_OBJ(WC.Console.OBJ_PROMPT);
			// Making selection empty
			WC.Console.Clipboard.selection_empty(WC.Console.OBJ_PROMPT);
		}
	}
	else WC.Console.Clipboard.selection_empty();
	// If we have selection - COPY
	if (str_selection != '') WC.Console.Clipboard.set(str_selection);
	// If we haven't selection - PASTE
	else {
		var str_clipboard = WC.Console.Clipboard.get();
		if (str_clipboard != '') WC.Console.Prompt.paste(str_clipboard);
		else WC.Console.Prompt.activate();
	}
	return false;
};
// Hook for FireFox ONLY - addition to 'KEYPRESS' hook (needed to support UP/DOWN keys)
WC.Console.Hooks.prompt_KEYPRESS_FF_UP_DOWN = function(e) {
	if (WC.Console.DATA['PROMPT_is_fosuced']) {
		if (e) {
			if (e.keyCode==38) { WC.Console.ACTION('UP'); return false; }
			else if (e.keyCode==40) { WC.Console.ACTION('DOWN'); return false; }
		}
	}
	return true;
};
// Global 'KEYPRESS' hook
WC.Console.Hooks.global_KEYPRESS = function(e) {
	// If GRAB is off - exitting
	if (!WC.Console.DATA['GLOBAL_is_grab_input'] && !(NL.Browser.Detect.isOPERA && WC.Console.DATA['PROMPT_is_fosuced'])) return; // true; // - don't returning 'true', because it will send proccessing 'KEYPRESS' at next level
	var ACTION = '';
	var ALLOW_NORMAL_KEYPRESS = 0;

	// Finding needed event
	var is_EVENT_IN = 0;
	var obj_event = null;
	if (window.event) obj_event = window.event;
	else if (parent && parent.event) obj_event = parent.event;
	else if (e) { obj_event = e; is_EVENT_IN = 1; }
	if (obj_event) {
		// GLOBAL bindings
		if ( (obj_event.keyCode==68 && obj_event.ctrlKey) ||
		     (is_EVENT_IN && obj_event.keyCode==0 && obj_event.charCode==100 && obj_event.ctrlKey) ) ACTION = 'CTRL-D';
		else if (obj_event.keyCode==116) ALLOW_NORMAL_KEYPRESS = 1; // 'F5' + anything is allowed
		else if (obj_event.ctrlKey) ALLOW_NORMAL_KEYPRESS = 1; // 'CTRL' + anything is allowed
		// PROMPT only bindings
		else if (WC.Console.DATA['PROMPT_is_fosuced']) {
			if (obj_event.keyCode==13) ACTION = 'ENTER';
			else if (obj_event.keyCode==38) ACTION = 'UP';
			else if (obj_event.keyCode==40) ACTION = 'DOWN';
			else if (obj_event.keyCode==9) ACTION = 'TAB';
			// Scrolling by HOME/END buttons fix
			// (if window has a scrollbar - by HOME button it will be scrolled to the cursor position, by END - not scrolled to end)
			if (window.scrollBy) {
				if (obj_event.keyCode==36) {
					var s_left = xScrollLeft();
					if (s_left) window.scrollBy(-s_left, 0);
					return true;
				}
				else if (obj_event.keyCode==35) {
					var size = xDocSize();
					if (size.w > 0) window.scrollBy(size.w , 0);
					return true;
				}
			}
		}
	}
	// Processing ACTION
	if (ACTION == '') {
		if (!WC.Console.DATA['PROMPT_is_fosuced'] && !ALLOW_NORMAL_KEYPRESS) {
			WC.Console.Prompt.activate();
			return false;
		}
	}
	else {
		// For FireFox 'UP'/'DOWN' at this event is not good, we have special event for FireFox 'UP'/'DOWN'
		if ( !(NL.Browser.Detect.isFF && (ACTION == 'UP' || ACTION == 'DOWN')) ) {
			WC.Console.ACTION(ACTION);
		}
		return false;
	}
	// If we are here - keypress is allowed
	return true;
};
// Hook for saving cursor position at PROMPT
WC.Console.Hooks.prompt_CURSOR_POSITION_SAVE = function() {
	WC.Console.DATA['PROMPT_is_fosuced'] = 1;
	WC.Console.DATA['GLOBAL_is_grab_input'] = 1;
	var position = WC.Console.Prompt.cursor_position_get();
	if (position >= 0) WC.Console.DATA['PROMPT_cursor_position'] = position;
	return true;
};
