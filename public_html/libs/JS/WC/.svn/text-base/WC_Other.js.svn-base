/*
* Web Console JS :: For all pages, except 'MAIN PAGE'
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY
*/
// WEB CONSOLE: JS FOR OTHER PAGES
if (typeof WC == "undefined") { var WC = { 'Other': {} }; }
else { WC.namespace('Other'); }
WC.Other.DATA = { 'password_ENCODED': '', 'password_TMP': '_0_[PASS]_0_', 'last_ACTIVE': null };

// Internal error
WC.Other.DIE = function(in_msg) {
	WC.Other.ERROR_ALERT(in_msg);
	var obj_window = xGetElementById(window);
	throw((obj_window && obj_window.Error) ? new Error(message) : message);
};
WC.Other.ERROR_ALERT = function(in_msg) {
	var message = "Web Console JavaScript ERROR: '" + in_msg + "'";
	alert(message);
}
// Setting element focus
WC.Other.set_focus = function(in_element) {
	var obj = xGetElementById(in_element);
	if (obj) obj.focus();
};
// Set the position of cursor at INPUT
WC.Other.set_cursor_position = function (obj, pos) {
	if (obj) {
		if (typeof pos == 'undefined' || pos < 0) pos = (obj.value && obj.value.length) ? obj.value.length : 0;
		if (obj.createTextRange) {
			var range = obj.createTextRange();
			range.move('character', pos);
			range.select();
		}
		else if (obj.selectionStart) {
			obj.focus();
			obj.setSelectionRange(pos, pos);
			if (pos == 0) obj.focus();
		}
	}
};
// Pasting text into ENCODINGS elements
WC.Other.paste_at_active_INPUT = function(in_this, in_text) {
	var is_pasted = 0;
	if (WC.Other.DATA['last_ACTIVE'] != null) {
		var obj = xGetElementById(WC.Other.DATA['last_ACTIVE']);
		if (obj) {
			obj.value = in_text;
			obj.focus();
			is_pasted = 1;
		}
	}
	if (!is_pasted && in_this) in_this.blur();
};
// Marking element active
WC.Other.paste_at_active_INPUT_activate = function(in_obj) { if (in_obj) WC.Other.DATA['last_ACTIVE'] = in_obj; };
// Marking element unactive
WC.Other.paste_at_active_INPUT_deactivate = function() { WC.Other.DATA['last_ACTIVE'] = null; };
// Setting encoded password (if user already has entered it) - now it's not used
WC.Other.set_encoded_password = function(in_password) {
	if (in_password && in_password != '') {
		var obj_FORM_MAIN_password = xGetElementById('_user_password_MAIN');
		var obj_FORM_MAIN_password_confirm = xGetElementById('_user_password_MAIN_confirm');
		if (obj_FORM_MAIN_password && obj_FORM_MAIN_password_confirm) {
			obj_FORM_MAIN_password.value = obj_FORM_MAIN_password_confirm.value = WC.Other.DATA['password_TMP'];
			WC.Other.DATA['password_ENCODED'] = in_password;
		}
	}
};
// Event 'user change password field' - not used now
WC.Other.password_CHANGED = function() {
	if (WC.Other.DATA['password_ENCODED'] != '') WC.Other.DATA['password_ENCODED'] = '';
};
// Encode password before send it
WC.Other.password_ENCODE = function (in_password) {
	if (WC.Other.DATA['password_ENCODED'] != '' && in_password == WC.Other.DATA['password_TMP']) return WC.Other.DATA['password_ENCODED'];
	else {
		if (NL.Crypt.sha1_vm_test()) return NL.Crypt.sha1_hex(in_password);
		else {
			WC.Other.ERROR_ALERT('Java Virtual Machine works incorrectly');
			return '';
		}
	}
};
// Initialization (called first, after page loaded)
WC.Other.init = function(in_action) {
	var obj_CONTENT = xGetElementById('block-CONTENT');
	if(obj_CONTENT) {
		if (obj_CONTENT.style) {
			obj_CONTENT.style.display = 'block';
			if (in_action) {
				if (in_action == 'logon') WC.Other.logon_init();
				else if (in_action == 'install') {
					var obj_FORM_MAIN_login = xGetElementById('_user_login_MAIN');
					if (obj_FORM_MAIN_login) obj_FORM_MAIN_login.focus();
				}
			}
			return 1;
		}
	}
	return 0;
};
// Getting 'login' from cookies and setting it to form
WC.Other.logon_init = function () {
	var obj_FORM_MAIN_login = xGetElementById('_user_login_MAIN');
	if (obj_FORM_MAIN_login) {
		var obj_FORM_MAIN_password = xGetElementById('_user_password_MAIN');
		if (obj_FORM_MAIN_login.value == '') {
			var s_cookie_login = xGetCookie('WC_user_login');
			if(s_cookie_login && s_cookie_login != 'null' && s_cookie_login != '') {
				obj_FORM_MAIN_login.value = s_cookie_login;
				// If we have password field - make it focused
				if (obj_FORM_MAIN_password) obj_FORM_MAIN_password.focus();
				else {
					obj_FORM_MAIN_login.focus();
					WC.Other.set_cursor_position(obj_FORM_MAIN_login, obj_FORM_MAIN_login.value.length);
				}
			}
			// No login at cookies, making LOGIN focused
			else obj_FORM_MAIN_login.focus();
		}
		// 'Login' value is set already preset
		else {
			if (obj_FORM_MAIN_password) obj_FORM_MAIN_password.focus();
		}
	}
};
// Setting 'login' to cookies
WC.Other.cookie_SET_LOGIN = function (in_login) {
	if (in_login && in_login != '') {
		var date_obj = new Date();
		var time_now = date_obj.getTime();
		var time_cookie_period = 30*86400000; // '86400000' - miliseconds at 1 day

		date_obj.setTime(time_now + time_cookie_period);
		xSetCookie('WC_user_login', in_login, date_obj);
	}
};
// Function to check E-mail (very simple, without REGEX)
WC.Other.CHECK_email = function (in_email) {
	if (in_email && in_email != '') {
		if (in_email.indexOf('@') > 0 && in_email.indexOf('.') >= 0) return 1;
	}
	return 0;
};
// Submit action called
WC.Other.submit = function(in_action, in_SHOW_ENCODE) {
	if (in_action) {
		if (in_action == 'logon') {
			var hash_LOGON = {
				'user_login': { 'name': 'Login', 'needed': 1, 'func_HOOK': WC.Other.cookie_SET_LOGIN },
				'user_password': { 'name': 'Password', 'needed': 1, 'func_ENCODE': WC.Other.password_ENCODE }
			};
			var form_POST = WC.Other.submit_CHECK_FORM_and_SET(hash_LOGON);
			// OK, data is good
			if (form_POST) form_POST.submit();
		}
		else if (in_action == 'install') {
			var hash_LOGON = {
				'user_login': { 'name': 'Administrator login', 'needed': 1, 'func_HOOK': WC.Other.cookie_SET_LOGIN },
				'user_password': { 'name': 'Password', 'needed': 1, 'confirm': 1, 'func_ENCODE': WC.Other.password_ENCODE },
				'user_email': { 'name': 'E-Mail', 'needed': 1, 'confirm': 1, 'func_CHECK': WC.Other.CHECK_email }
			};
			var obj_ENCODINGS_SWITCHER = xGetElementById('_use_ENCODINGS_switcher');
			if (in_SHOW_ENCODE && obj_ENCODINGS_SWITCHER && obj_ENCODINGS_SWITCHER.checked) {
				hash_LOGON['encoding_SERVER_CONSOLE'] = { 'name': 'Server console encoding', 'needed': 0 };
				hash_LOGON['encoding_SERVER_SYSTEM'] = { 'name': 'Server system encoding', 'needed': 0 };
				hash_LOGON['encoding_EDITOR_TEXT'] = { 'name': 'Text editor encoding:', 'needed': 0 };
			}
			var form_POST = WC.Other.submit_CHECK_FORM_and_SET(hash_LOGON);
			// OK, data is good
			if (form_POST) form_POST.submit();
		}
	}
	return false;
};
// Checking FORM input, set hidden form data and if all is OK - return 'obj_FORM_HIDDEN'
WC.Other.submit_CHECK_FORM_and_SET  = function(in_HASH) {
	var obj_FORM_MAIN = xGetElementById('form-MAIN');
	var obj_FORM_HIDDEN = xGetElementById('form-HIDDEN');

	if (!obj_FORM_MAIN) { WC.Other.ERROR_ALERT("Unable to find 'form-MAIN' object"); return 0; }
	else if (!obj_FORM_HIDDEN) { WC.Other.ERROR_ALERT("Unable to find 'form-HIDDEN' object"); return 0; }
	else {
		for (var id in in_HASH) {
			var obj_i_MAIN = xGetElementById('_'+id+'_MAIN');
			var obj_i_HIDDEN = xGetElementById('_'+id);
			if (!obj_i_MAIN) { WC.Other.ERROR_ALERT('Unable to find "_'+id+'_MAIN" object'); return 0; }
			else if (!obj_i_HIDDEN) { WC.Other.ERROR_ALERT('Unable to find "_'+id+'" object'); return 0; }
			else {
				if (obj_i_MAIN.value && obj_i_MAIN.value != '') {
					// Checking value
					if (in_HASH[id]['func_CHECK']) {
						if (!in_HASH[id]['func_CHECK'](obj_i_MAIN.value)) {
							alert('"'+in_HASH[id]['name']+'" is incorrect, please fix it...');
							obj_i_MAIN.focus();
							return 0;
						}
					}
					// Checking for comfirmation
					if (in_HASH[id]['confirm']) {
						var obj_i_CONFIRM = xGetElementById('_'+id+'_MAIN_confirm');
						if (obj_i_CONFIRM) {
							if(obj_i_CONFIRM.value && obj_i_CONFIRM.value != '') {
								if (obj_i_CONFIRM.value != obj_i_MAIN.value) {
									alert('"'+in_HASH[id]['name']+'" and "Confirm '+in_HASH[id]['name'].toLowerCase()+'" are not the same, please fill that fields again...');
									obj_i_MAIN.focus();
									return 0;
								}
							}
							else {
								alert('"Confirm '+in_HASH[id]['name'].toLowerCase()+'" can\'t be empty, please fill that field...');
								obj_i_CONFIRM.focus();
								return 0;
							}
						}
						else {
							WC.Other.ERROR_ALERT('Unable to find "_'+id+'_MAIN_confirm" object');
							return 0;
						}
					}
					// Calling HOOK
					if (in_HASH[id]['func_HOOK']) in_HASH[id]['func_HOOK'](obj_i_MAIN.value);
					// Setting value
					if (in_HASH[id]['func_ENCODE']) {
						obj_i_HIDDEN.value = in_HASH[id]['func_ENCODE'](obj_i_MAIN.value);
						if (obj_i_HIDDEN.value == '') {
							// Error message will be shown at 'func_ENCODE', soo we just exiting
							return 0;
						}
					}
					else obj_i_HIDDEN.value = obj_i_MAIN.value;
				}
				else {
					if (in_HASH[id]['needed']) {
						alert('"'+in_HASH[id]['name']+'" can\'t be empty, please fill that field...');
						obj_i_MAIN.focus();
						return 0;
					}
				}
			}
		}
		// OK, FORM ready
		return obj_FORM_HIDDEN;
	}
	return 0;
};
