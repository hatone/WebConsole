/*
* NL :: UI - Advanced user interface
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
// 'NL.Browser.Detect' is required for 'NL.UI'
if (typeof NL == "undefined") { alert("NL.UI: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('UI'); }

// Removing object
NL.UI.object_remove = function(in_obj) {
	if (in_obj) {
		var obj = xGetElementById(in_obj);
		if (obj && obj.parentNode) obj.parentNode.removeChild(obj);
	}
};
// Making object UNSELECTABLE
NL.UI.object_make_unselectable = function(in_obj) {
	if (in_obj) {
		var obj = xGetElementById(in_obj);
		if (obj) {
			if (NL.Browser.Detect.isFF) { if (obj.style) obj.style.MozUserSelect = 'none'; }
			else if (NL.Browser.Detect.isSAFARI) { if (obj.style) obj.style.KhtmlUserSelect = 'none'; }
			else if (NL.Browser.Detect.isIE || NL.Browser.Detect.isOPERA) { in_obj.unselectable = 'on'; }
		}
	}
};
// Adding scroll EVENT processing to object
NL.UI.object_event_SCROLL = function(in_ID, in_FUNC) {
	if (in_ID && in_FUNC) {
		var obj = xGetElementById(in_ID);
		if (obj) {
			if (NL.Browser.Detect.isIE) obj.attachEvent('onmousewheel', in_FUNC);
			else if (NL.Browser.Detect.isFF) obj.addEventListener('DOMMouseScroll', in_FUNC, false);
			else obj.onmousewheel = in_FUNC;
		}
	}
};
// Processing scroll event and getting DELTA
NL.UI.object_event_SCROLL_get_delta = function(event, in_PASS) {
	var delta = 0;
	if (!event) event = window.event;
	if (event.wheelDelta) {
		delta = event.wheelDelta/120;
		//if (window.opera) delta = -delta;
		if (!in_PASS) event.returnValue = false;
	}
	else if (event.detail) {
		delta = -event.detail/3;
		if (!in_PASS) event.preventDefault();
	}
	return delta;
};
// Element: SWITCHER: Registration
NL.UI.switcher_register = function(in_STR_PREFIX_CLASS, in_ID, in_ON) {
	var obj = xGetElementById(in_ID);
	if (obj) {
		if (in_ON) { obj.checked = 1; }
		// Registering EVENTS
		xAddEventListener(in_ID, 'click', function() { NL.UI.switcher_pressed(in_STR_PREFIX_CLASS, in_ID); return true; }, false);
		// Making LABEL unselectable
		var obj_LABEL = xGetElementById(in_ID + '-LABEL');
		if (obj_LABEL) NL.UI.object_make_unselectable(obj_LABEL);
		// Calling switcher update
		NL.UI.switcher_pressed(in_STR_PREFIX_CLASS, in_ID);
	}
};
// Element: SWITCHER: Pressed
NL.UI.switcher_pressed = function(in_STR_PREFIX_CLASS, in_ID) {
	var class_ON = in_STR_PREFIX_CLASS + '-pressed';
	var class_OFF = in_STR_PREFIX_CLASS + '-unpressed';

	var obj = xGetElementById(in_ID);
	if (obj) {
		var obj_AREA = xGetElementById(in_ID + '-AREA');
		if (obj_AREA) {
			if (obj.checked) {
				if (xHasClass(obj_AREA, class_OFF)) {
					xRemoveClass(obj_AREA, class_OFF);
					xAddClass(obj_AREA, class_ON);
				}
			}
			else {
				if (xHasClass(obj_AREA, class_ON)) {
					xRemoveClass(obj_AREA, class_ON);
					xAddClass(obj_AREA, class_OFF);
				}
			}
			// Removing focus from SWITCHER CHECKBOX
			obj.blur();
		}
	}
};
// Element: DIV_BUTTON: Registration
NL.UI.div_button_register = function(in_STR_PREFIX_CLASS, in_ID, in_CALLBACK_FUNCTION, in_STASH) {
	var obj = xGetElementById(in_ID);
	if (obj) {
		// Making BUTTON unselectable
		NL.UI.object_make_unselectable(obj);
		// Registering EVENTS
		xAddEventListener(in_ID, 'mousedown', function() { NL.UI.div_button_pressed(in_STR_PREFIX_CLASS, in_ID, 1, in_CALLBACK_FUNCTION, in_STASH); }, false);
		xAddEventListener(in_ID, 'mouseup', function() { NL.UI.div_button_pressed(in_STR_PREFIX_CLASS, in_ID, 0, in_CALLBACK_FUNCTION, in_STASH); }, false);
		xAddEventListener(in_ID, 'mouseout', function() { NL.UI.div_button_pressed(in_STR_PREFIX_CLASS, in_ID, 0, in_CALLBACK_FUNCTION, in_STASH); }, false);
		// IE FIX
		if (NL.Browser.Detect.isIE) xAddEventListener(in_ID, 'dblclick', function() { NL.UI.div_button_pressed(in_STR_PREFIX_CLASS, in_ID, 2, in_CALLBACK_FUNCTION, in_STASH); }, false);
	}
};
// Element: DIV_BUTTON: Pressed
NL.UI.div_button_pressed = function(in_STR_PREFIX_CLASS, in_ID, in_IS_PRESSED_DOWN, in_CALLBACK_FUNCTION, in_STASH) {
	var obj = xGetElementById(in_ID);
	if (obj) {
		var class_PRESSED = in_STR_PREFIX_CLASS + '-pressed';
		// Pressed down
		if (in_IS_PRESSED_DOWN == 1) {
			if (!xHasClass(obj, class_PRESSED)) {
				xAddClass(obj, class_PRESSED);
				return true;
			}
		}
		// IE 'dblclick'
		else if (in_IS_PRESSED_DOWN == 2) {
			in_CALLBACK_FUNCTION(in_STASH);
			return true;
		}
		// Pressed up
		else {
			if (xHasClass(obj, class_PRESSED)) {
				xRemoveClass(obj, class_PRESSED);
				in_CALLBACK_FUNCTION(in_STASH);
				return true;
			}
		}
	}
	return false;
};

// Element: DIV_BUTTON: Pressed (not used now) - REMOVE IT
NL.UI.div_button_pressed_OLD = function(in_STR_PREFIX_CLASS, in_ID, in_IS_PRESSED_DOWN, in_CALLBACK_FUNCTION, in_STASH) {
		var class_UP = in_STR_PREFIX_CLASS + '-unpressed';
		var class_DOWN = in_STR_PREFIX_CLASS + '-pressed';

		var obj = xGetElementById(in_ID);
		if (!obj) return false;

		// DOWN
		if (in_IS_PRESSED_DOWN == 1) {
			if (xHasClass(obj, class_UP)) {
				xRemoveClass(obj, class_UP);
				xAddClass(obj, class_DOWN);
			}
		}
		// IE 'dblclick'
		else if (in_IS_PRESSED_DOWN == 2) in_CALLBACK_FUNCTION(in_STASH);
		// UP
		else {
			if (xHasClass(obj, class_DOWN)) {
				xRemoveClass(obj, class_DOWN);
				xAddClass(obj, class_UP);
				in_CALLBACK_FUNCTION(in_STASH);
			}
		}
		return false;
};

// Allowing TAB button at INPUT
NL.UI.input_allow_tab_OBJ_FOCUS = null;
NL.UI.input_allow_tab_REMOVE_TAB = function(in_value) { return in_value.replace(/(^|\n)\t/g, "$1"); }
NL.UI.input_allow_tab_ADD_TAB = function (in_value) { return in_value.replace(/(^|\n)([\t\S])/g, "$1\t$2" ); }
NL.UI.input_allow_tab = function(in_obj) {
	if (in_obj) {
		var obj = xGetElementById(in_obj);
		if (obj && !obj.is_TAB_ALLOWED) {
			obj.is_TAB_ALLOWED = true;
			obj.is_TAB_PRESSED = false;
			// IE
			if (NL.Browser.Detect.isIE) {
				xAddEventListener(obj, 'keydown', function(e) {
					if(window.event.keyCode == 9) {
						var obj_range = document.selection.createRange();
						if (obj_range.text.length > 0) {
							if(window.event.shiftKey) {
								var new_text = NL.UI.input_allow_tab_REMOVE_TAB(obj_range.text);
								obj_range.text = new_text;
								// If selected text has been removed
								if (new_text.length <= 0) {
									if (obj.createTextRange) {
										var position = 0;
										// Getting cursor posisiton
										var r = document.selection.createRange().duplicate();
										r.moveEnd('character', obj.value.length);
										if (r.text == '') position = obj.value.length;
										else position = obj.value.lastIndexOf(r.text);
										// Setting cursor posisiton
										if (obj.createTextRange) {
											var range = obj.createTextRange();
											range.move('character', position);
											range.select();
										}
									}
								}
							}
							else obj_range.text = NL.UI.input_allow_tab_ADD_TAB(obj_range.text);
						}
						else obj_range.text = "\t";
						return false;
					}
				}, false);
			}
			// Not IE
			else {
				xAddEventListener(obj, 'keypress', function(e) {
					if (e.keyCode == 9) {
						this.is_TAB_PRESSED = true;
						var was_scroll_top = this.scrollTop;
						var selection_start = this.selectionStart;
						var selection_end = this.selectionEnd;
						var text_LEFT = this.value.substring(0, selection_start);
						var text_MIDDLE = this.value.substring(selection_start, selection_end);
						var text_RIGHT = this.value.substring(selection_end, this.value.length);
						var is_middle_exists = false;
						if (text_MIDDLE.length > 0) {
							is_middle_exists = true;
							if (e.shiftKey) text_MIDDLE = NL.UI.input_allow_tab_REMOVE_TAB(text_MIDDLE);
							else text_MIDDLE = NL.UI.input_allow_tab_ADD_TAB(text_MIDDLE);
						}
						else text_MIDDLE = "\t";

						this.value = text_LEFT + text_MIDDLE + text_RIGHT;
						this.focus();
						if (is_middle_exists) {
							// Fix to Opera and empty selection at beginig of the string value
							if (NL.Browser.Detect.isOPERA && text_MIDDLE.length <= 0 && this.createTextRange) {
								var range = this.createTextRange();
								range.move('character', selection_start);
								range.select();
							}
							else {
								this.selectionStart = selection_start;
								this.selectionEnd = selection_start + text_MIDDLE.length;
							}
						}
						else {
							selection_start++;
							this.selectionStart = selection_start;
							this.selectionEnd = selection_start;
						}
						this.scrollTop = was_scroll_top;
						if (e.cancelable) {
							e.preventDefault();
							e.stopPropagation();
						}
					}
				}, false);
				// Next part is not needed for FireFox
				if (!NL.Browser.Detect.isFF) {
					xAddEventListener(obj, 'blur', function(e) {
						if (this.is_TAB_PRESSED) {
							this.is_TAB_PRESSED = false;
							NL.UI.inpu_allow_tab_OBJ_FOCUS = obj;
							setTimeout('NL.UI.inpu_allow_tab_OBJ_FOCUS.focus()', 1);
						}
					}, false);
				}
			}
		}
	}
}
