/*
* NL :: Form - Simple FORM manipulations
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof NL == "undefined") { alert("NL.Form: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('Form'); }

// Showing message with FORM completion ERROR
NL.Form.alert_error = function(in_message) {
	var message = "Form completion checking ERROR: '" + in_message + "'";
	alert(message);
};
// Function to check E-mail (very simple, without REGEX)
NL.Form.FUNC_CHECK_email = function (in_email) {
	if (in_email && in_email != '') {
		if (in_email.indexOf('@') > 0 && in_email.indexOf('.') >= 0) return 1;
	}
	return 0;
};
// Checking FORM fields
// EXAMPLE: var text = NL.String.RE_REPLACE(some_var, [new RegExp('^[\\s\\n\\r]+', 'g'), ''])
NL.Form.check_fields = function(in_HASH, in_get_as_hash) {
	var result_HASH = {};
	for (var id in in_HASH) {
		var obj_i = xGetElementById(id);
		if (!obj_i) { NL.Form.alert_error('Unable to find "'+id+'" object'); return 0; }
		else {
			var process_TYPE = '';
			if (in_HASH[id]['type'] && in_HASH[id]['type'] == 'checkbox') process_TYPE = 'CHECKBOX';
			else  if (obj_i.value && obj_i.value != '') process_TYPE = 'MAIN';

			if (process_TYPE == 'CHECKBOX') {
				if (in_get_as_hash) {
					if (obj_i.checked) {
						var name_at_hash = in_HASH[id]['name_at_hash'] ? in_HASH[id]['name_at_hash'] : id;
						result_HASH[name_at_hash] = 1;
					}
				}
			}
			else if (process_TYPE != '') {
				// Checking value
				if (in_HASH[id]['func_CHECK']) {
					if (!in_HASH[id]['func_CHECK'](obj_i.value)) {
						alert('"'+in_HASH[id]['name']+'" is incorrect, please fix it...');
						if (!in_HASH[id]['func_BEFORE_FOCUS'] || in_HASH[id]['func_BEFORE_FOCUS']()) obj_i.focus();
						return 0;
					}
				}
				// Checking for comfirmation
				if (in_HASH[id]['confirm']) {
					var confirm_obj_name = id+'_c';
					var obj_i_CONFIRM = xGetElementById(confirm_obj_name);
					if (obj_i_CONFIRM) {
						if(obj_i_CONFIRM.value && obj_i_CONFIRM.value != '') {
							if (obj_i_CONFIRM.value != obj_i.value) {
								alert('"'+in_HASH[id]['name']+'" and "Confirm '+in_HASH[id]['name'].toLowerCase()+'" are not the same, please fill that fields again...');
								if (!in_HASH[id]['func_BEFORE_FOCUS'] || in_HASH[id]['func_BEFORE_FOCUS']()) obj_i.focus();
								return 0;
							}
						}
						else {
							alert('"Confirm '+in_HASH[id]['name'].toLowerCase()+'" can\'t be empty, please fill that field...');
							if (!in_HASH[id]['func_BEFORE_FOCUS'] || in_HASH[id]['func_BEFORE_FOCUS']()) obj_i_CONFIRM.focus();
							return 0;
						}
					}
					else { NL.Form.alert_error('Unable to find "'+confirm_obj_name+'" object'); return 0; }
				}
				// Calling HOOK
				if (in_HASH[id]['func_HOOK']) in_HASH[id]['func_HOOK'](obj_i.value);
				// Setting value
				if (in_get_as_hash) {
					var name_at_hash = in_HASH[id]['name_at_hash'] ? in_HASH[id]['name_at_hash'] : id;
					if (in_HASH[id]['func_ENCODE']) {
						var encode_result = in_HASH[id]['func_ENCODE'](obj_i.value);
						if (encode_result[0] == 1) {
							if (encode_result[1]) result_HASH[name_at_hash] = encode_result[1];
						}
						// Error message will be shown at 'func_ENCODE', soo we just exiting
						else {
							if (encode_result[0] == -1) {
								if (!in_HASH[id]['func_BEFORE_FOCUS'] || in_HASH[id]['func_BEFORE_FOCUS']()) obj_i.focus();
							}
							return 0;
						}
					}
					else result_HASH[name_at_hash] = obj_i.value;
				}
			}
			else {
				if (in_HASH[id]['needed']) {
					alert('"'+in_HASH[id]['name']+'" can\'t be empty, please fill that field...');
					if (!in_HASH[id]['func_BEFORE_FOCUS'] || in_HASH[id]['func_BEFORE_FOCUS']()) obj_i.focus();
					return 0;
				}
			}
		}
	}
	if (in_get_as_hash) return result_HASH;
	else return 1;
};
// DON'T WOKS NOW: Allowing TAB button at field (INPUT) - internal HOOK
NL.Form._allow_TAB_KEY_PRESS_HOOK = function(e) {
	var obj_event = null;
	if (window.event) obj_event = window.event;
	else if (parent && parent.event) obj_event = parent.event;
	else if (e) obj_event = e;
	if (obj_event) {
		// TAB pressed
		if (this && obj_event.keyCode==9) {
			// Getting cursor position
			var c_pos = 0;
			if (this.createTextRange) {
				var r = document.selection.createRange().duplicate();
				r.moveEnd('character', this.value.length);
				if (r.text == '') c_pos = this.value.length;
				else c_pos = this.value.lastIndexOf(r.text);
			}
			else c_pos = this.selectionStart || 0;
			// Making insertion
			var insert_IT = "\t";
			if (c_pos >= 0) {
				if (c_pos == 0) this.value = insert_IT + this.value;
				else if (c_pos >= this.value.length) {
					c_pos = this.value.length;
					this.value = this.value + insert_IT;
				}
				else {
					var str_left = this.value.substr(0, c_pos);
					var str_right = this.value.substr(c_pos);
					this.value = str_left + insert_IT + str_right;
				}
			}
			// Setting cursor posisiton
			var new_pos = c_pos + insert_IT.length;
			if (this.createTextRange) {
				var range = this.createTextRange();
				range.move('character', new_pos);
				range.select();
			}
			else if (this.selectionStart) {
				this.focus();
				this.setSelectionRange(new_pos, new_pos);
				if (new_pos == 0) this.focus();
			}
			else this.focus();
			return false;
		}
	}
	return true;
};
// DON'T WOKS NOW: Allowing TAB button at field (INPUT)
NL.Form.allow_TAB = function(in_ID) {
	if (in_ID) {
		var obj = xGetElementById(in_ID);
		if (obj) {
			// 'KEYPRESS' HOOK
			// We don't use 'xAddEventListener' because that is don't allow to 'return false' and stop event processing
			if (NL.Browser.Detect.isIE) obj.onkeydown = NL.Form._allow_TAB_KEY_PRESS_HOOK;
			else obj.onkeypress = NL.Form._allow_TAB_KEY_PRESS_HOOK;
		}
	}
};
// Getting value of input
NL.Form.value_get = function(in_ID) {
	if (in_ID) {
		var obj = xGetElementById(in_ID);
		if (obj && obj.value) return obj.value;
	}
	return '';
};
// Setting value of input
NL.Form.value_set = function(in_ID, in_VALUE, in_SET_FOCUS) {
	if (in_ID && in_VALUE) {
		var obj = xGetElementById(in_ID);
		if (obj) {
			obj.value = in_VALUE;
			if (in_SET_FOCUS) obj.focus();
			return 1;
		}
	}
	return 0;
};
