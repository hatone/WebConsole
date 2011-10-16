/*
* WC :: Console :: HTML - HTML methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.HTML: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.HTML'); }

// Internal storage
WC.Console.HTML._DATA = {
	'OUTPUT_ELEMENTS_MAX': 40,
	'OUTPUT_ELEMENTS_NOW': [],
	'last_id': 0
};
// Getting id (internal)
WC.Console.HTML._get_id = function() {
	WC.Console.HTML._DATA['last_id']++;
	return 'wc_id_'+WC.Console.HTML._DATA['last_id'];
};
// Getting OBJECT with class = 'in_CLASS_NAME' by object ID inside that OBJECT with class = 'in_CLASS_NAME'
WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT = function(in_ID, in_CLASS_NAME) {
	if (!in_CLASS_NAME) in_CLASS_NAME = 'block-cmd-result';
	var obj = xGetElementById(in_ID);
	var obj_result = null;
	if (obj) {
		// Finding DIV with class = 'block-cmd-result' at upper levels
		var max_levels_to_up = 10;
		var level = 0;
		while (level < max_levels_to_up) {
			if (obj.tagName && obj.tagName.toLowerCase() == 'div') {
				if (xHasClass(obj, in_CLASS_NAME)) { obj_result = obj; break; }
			}
			if (obj.parentNode) { obj = obj.parentNode; level++; }
			else { break; }
		}
	}
	return obj_result;
};
// Removing result by object ID inside that result
WC.Console.HTML.OUTPUT_remove_result = function(in_ID) {
	var obj_remove = WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT(in_ID);
	if (!obj_remove || (obj_remove.wc_mark && obj_remove.wc_mark == 'DO_NOT_CLOSE_ALL')) obj_remove = xGetElementById(in_ID);
	// Removing
	if (obj_remove && obj_remove.parentNode) {
		obj_remove.parentNode.removeChild(obj_remove);
		// IE does not call 'blur()' for removed elements:
		WC.Console.Hooks.chech_focused_FIX_GRAB();
	}
};
// Removing all elements from OUTPUT below 'in_ID'
WC.Console.HTML.OUTPUT_remove_below = function(in_ID) {
	var obj_current = WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT(in_ID, 'block-cmd');
	if (obj_current && obj_current.id && WC.Console.OBJ_OUTPUT) {
		if (WC.Console.OBJ_OUTPUT.hasChildNodes())
		{
			var c = WC.Console.OBJ_OUTPUT.childNodes;
			for (var i = c.length - 1; i >= 0; i--)
			{
				if (c[i].id && c[i].id == obj_current.id) { break; }
				else {
					WC.Console.OBJ_OUTPUT.removeChild(c[i]);
					// IE does not call 'blur()' for removed elements:
					WC.Console.Hooks.chech_focused_FIX_GRAB();
				}
			}
		 }
	}
};
// Appending new data to output
WC.Console.HTML.OUTPUT_append = function(in_HTML, in_ID) {
	if (WC.Console.OBJ_OUTPUT) {
		WC.Console.OBJ_OUTPUT.insertAdjacentHTML('beforeEnd', in_HTML);
		if (in_ID) {
			WC.Console.HTML._DATA['OUTPUT_ELEMENTS_NOW'].push(in_ID);
			if (WC.Console.HTML._DATA['OUTPUT_ELEMENTS_NOW'].length > WC.Console.HTML._DATA['OUTPUT_ELEMENTS_MAX']) {
				var id_REMOVE = WC.Console.HTML._DATA['OUTPUT_ELEMENTS_NOW'].shift();
				if (id_REMOVE) WC.Console.HTML.OUTPUT_remove_top(id_REMOVE);
			}

		}
	}
};
// Removing all elements before 'in_ID' and 'in_ID'
WC.Console.HTML.OUTPUT_remove_top = function(in_ID) {
	if (WC.Console.OBJ_OUTPUT) {
		if (WC.Console.OBJ_OUTPUT.hasChildNodes())
		{
			var rm_ELEMENTS = [];
			var remove_THEM = 0;
			var c = WC.Console.OBJ_OUTPUT.childNodes;
			for (var i = 0; i < c.length; i++)
			{
				rm_ELEMENTS.push(c[i]);
				if (c[i].id && c[i].id == in_ID) { remove_THEM = 1; break; }
			}
			if (remove_THEM) {
				for (var r in rm_ELEMENTS) {
					WC.Console.OBJ_OUTPUT.removeChild(rm_ELEMENTS[r]);
					// IE does not call 'blur()' for removed elements:
					WC.Console.Hooks.chech_focused_FIX_GRAB();
				}
			}
		 }
	}
};
// Removing element 'in_ID' from OUTPUT
WC.Console.HTML.OUTPUT_remove = function(in_ID) {
	if (WC.Console.OBJ_OUTPUT) {
		if (WC.Console.OBJ_OUTPUT.hasChildNodes())
		{
			var c = WC.Console.OBJ_OUTPUT.childNodes;
			for (var i = 0; i < c.length; i++)
			{
				if (c[i].id && c[i].id == in_ID) {
					WC.Console.OBJ_OUTPUT.removeChild(c[i]);
					// IE does not call 'blur()' for removed elements:
					WC.Console.Hooks.chech_focused_FIX_GRAB();
					break;
				}
			}
		 }
	}
};
// Setting OUTPUT mark
WC.Console.HTML.OUTPUT_set_mark = function(in_ID, in_MARK_value) {
	if (in_ID && in_MARK_value) {
		var obj_current = WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT(in_ID);
		if (obj_current) {
			obj_current.wc_mark = in_MARK_value;
		}
	}
};
// Getting OUTPUT mark
WC.Console.HTML.OUTPUT_get_mark = function(in_ID) {
	if (in_ID) {
		var obj_current = WC.Console.HTML.OUTPUT_get_OBJ_by_RESULT(in_ID);
		if (obj_current && obj_current.wc_mark) return obj_current.wc_mark;
	}
	return '';
};
// Resetting OUTPUT
WC.Console.HTML.OUTPUT_reset = WC.Console.HTML.OUTPUT_empty = function() {
	if (WC.Console.OBJ_OUTPUT) {
		// Do not removing timer - it will be removed automatically itself
		WC.Console.OBJ_OUTPUT.innerHTML = '';
		WC.Console.HTML.add_powered_by();
		WC.Console.DATA['PROMPT_is_fosuced'] = 1;
	}
};
// Adding (printing) 'Powered by' message
WC.Console.HTML.add_powered_by = function() {
	var id = WC.Console.HTML._get_id();
	WC.Console.HTML.OUTPUT_append(
		'<div id="'+id+'" class="block-powered-by"><a href="http://www.web-console.org" target="_blank">Powered by Web Console</a><br />'+
		'<a href="http://www.web-console.org/donate/" target="_blank">&gt; Support us &lt;</a></div>',
		id
	);
};
// Adding (printing) 'WELCOME' message
WC.Console.HTML.add_welcome = function(in_SHOW_WELCOME, in_SHOW_WARNING, in_IS_DEMO) {
	if (typeof in_SHOW_WELCOME == 'undefined') in_SHOW_WELCOME = 1;
	if (typeof in_SHOW_WARNING == 'undefined') in_SHOW_WARNING = 1;
	if (typeof in_IS_DEMO == 'undefined') in_IS_DEMO = 0;
	var id = WC.Console.HTML._get_id();
	var str_TEXT = '<div id="'+id+'" class="block-message">';
	if (in_SHOW_WELCOME) {
		str_TEXT += ''+
			// Welcome
			'<span class="t-title">Welcome to Web Console</span><br />'+
			'&nbsp;&nbsp;&nbsp;Web Console is a web-based application that allow to execute<br />'+
			'&nbsp;&nbsp;&nbsp;shell commands on a web server directly from a browser.<br />'+
			'&nbsp;&nbsp;&nbsp;Please type command and press &quot;<span class="t-link">Enter</span>&quot; to execute it on the web server.<br />'+
			'<br />'+
			// Main features
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To clean screen use &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'clear\'); return false" title="Click to paste at command input">clear</a>&quot;/&quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'cls\'); return false" title="Click to paste at command input">cls</a>&quot; command.<br />'+
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To change current directory use &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'cd\'); return false" title="Click to paste at command input">cd</a>&quot; command.<br />'+
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To autocomplete feature press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot; key on your keyboard.<br />'+
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To access Web Console internal commands/settings, please type &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'#\'); return false" title="Click to paste at command input">#</a>&quot; and press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot;<br />'+
			'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; key on your keyboard.<br />'+
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To start file manager use &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'#file manager\'); return false" title="Click to paste at command input">#file manager</a>&quot; command.<br />'+
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To view/edit Web Console configuration use &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'#settings\'); return false" title="Click to paste at command input">#settings</a>&quot; command.<br />'+
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To use <span class="t-mark">copy/paste feature by right mouse button</span> - click right mouse button on selected<br />'+
			'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; text (text will be copied to clipboard), to paste copied text - click right mouse button<br />'+
			'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; anywhere again.<br />'+
			// Links
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> To get information about most common Web Console usage, please read <a href="http://www.web-console.org/usage/" target="_blank" title="Read Web Console Usage">Web Console Usage</a>.'+
			// '<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> You can easily develop your own Web Console plugins to extend existing functionality,<br />'+
			// '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to get more information about it please read <a href="http://www.web-console.org/plugin_howto/" target="_blank" title="Read Web Console Plugins HOWTO">Web Console Plugins HOWTO</a>'+
			'<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> If you have any questions, please visit to <a href="http://forum.web-console.org" target="_blank" title="Visit to Web Console FORUM">Web Console FORUM</a>.'+
			'<br />';
	}
	else str_TEXT += '<span class="t-title">Welcome to Web Console</span>';
	// Static
	if (!in_IS_DEMO) {
		str_TEXT += ''+
			// Web Console Group
			'<br />'+
			'&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span> <a class="t-link-notUL" href="http://www.web-console.org/about_us/" title="Read more information about Web Console Group" target="_blank">Web Console Group</a> provides web application development, server configuration,'+
			'<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span> technical support, security analysis, consulting and other services.'+
			'<br />&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span> To get more information about it please visit to <a href="http://services.web-console.org" title="Read more information about Web Console Group services" target="_blank">Web Console Group services</a> page.';
		// Donate
		str_TEXT += '<br /><br />'+WC.Console.HTML.get_DONATION_HTML();
	}
	// Warning
	if (in_SHOW_WARNING) {
		if (NL.Browser.Detect.isOPERA) {
			str_TEXT += ''+
				(!in_IS_DEMO ? '<br /><br />' : '<br />')+
				'<span class="t-alert">Warning to Opera browser users:</span><br />'+
				'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> Due to some Opera browser restrictions, to use <span class="t-mark">copy/paste feature by right mouse<br />'+
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  button</span> - hold &quot;<span class="t-cmd" title="Press and hold &lt;CTRL&gt; key on your keyboard">CTRL</span>&quot; key on your keyboard and press LEFT mouse button.';
				/* PROBLEM WAS FIXED BY ADDING 'autocomplete="off"' TO INPUT
				'&nbsp;&nbsp;&nbsp;<span class="t-dash">--</span> Opera have some problems with \'<span class="t-cmd">onKeyPress</span>\' JavaScript event - when you press<br />'+
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;<span class="t-cmd" title="Press &lt;UP&gt; button at your keyboard">UP</span>&quot; arrow key at command prompt to see previous command and window at this time<br />'+
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; have vertical scroll bar, Opera will quickly scroll UP/DOWN.<br />'+
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="t-dash">**</span> Solution for that Opera problem is at development state, if you can help with it,<br />'+
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="t-dash">**</span> please have a look &quot;<a class="t-link-notUL" href="http://forum.web-console.org/go/opera_onkeypress_problem" title="Visit Web Console DEVELOPMENT FORUM" target="_blank">Web Console DEVELOPMENT FORUM</a>&quot;: <a href="http://forum.web-console.org/go/opera_onkeypress_problem" title="Visit Web Console DEVELOPMENT FORUM" target="_blank">Opera \'onkeypress\' and scrolling problem</a><br />';
				*/
				if (in_IS_DEMO) str_TEXT += '<br />';
		}
	}
	if (in_IS_DEMO) str_TEXT += '<br />'+WC.Console.HTML.get_DEMO_HTML();
	str_TEXT += '</div>';
	WC.Console.HTML.OUTPUT_append(str_TEXT, id);
};
// Getting donation HTML
WC.Console.HTML.get_DONATION_HTML = function(in_IS_INTERNAL_CMD_CALL) {
	var result = '';
	var str_spaces = '&nbsp;&nbsp;&nbsp;';
	if (in_IS_INTERNAL_CMD_CALL) {
		str_spaces = '&nbsp;&nbsp;';
		result = '<div class="t-green">';
	}
	result += ''+
		str_spaces + '<span class="t-dash">*************************************************************************************</span><br />'+
		str_spaces + '<span class="t-dash">**</span> The Web Console team is working very hard to provide an easy, light and highly &nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> useful web-based remote console. Web Console is available for free, and will &nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> always be available for free. If you enjoy and use Web Console, please consider <span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <a class="a-brown" href="http://www.web-console.org/donate/" title="Donate to Web Console project" target="_blank">supporting the Web Console project financially</a>. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-red-dark">Any contributions are very important for us.</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">*************************************************************************************</span>';
	if (in_IS_INTERNAL_CMD_CALL) result += '</div>';
	return result;
};
// Getting demo HTML
WC.Console.HTML.get_DEMO_HTML = function() {
	var result = '';
	var str_spaces = '&nbsp;&nbsp;&nbsp;';

	result += ''+
		str_spaces + '<span class="t-dash">*************************************************************************************</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-lime">Web Console is working at DEMO MODE, not all features are enabled at this mode.</span> <span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-blue">Following commands are allowed at DEMO mode:</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'ls\'); return false" title="Click to paste at command input">ls</a>&quot;/&quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'dir\'); return false" title="Click to paste at command input">dir</a>&quot; - list directory contents; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'echo\'); return false" title="Click to paste at command input">echo</a>&quot; - displays entered message; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-dash">--</span> &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'clear\'); return false" title="Click to paste at command input">clear</a>&quot;/&quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'cls\'); return false" title="Click to paste at command input">cls</a>&quot; - clears screen; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-dash">--</span> Type &quot;<a class="t-cmd" href="#" onclick="WC.Console.Prompt.value_set(\'#\'); return false" title="Click to paste at command input">#</a>&quot; and press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot; key on your keyboard to access Web Console internal <span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> &nbsp;&nbsp; commands (at DEMO MODE limited access to that commands allowed); &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-dash">--</span> To autocomplete feature press &quot;<span class="t-cmd" title="Press &lt;TAB&gt; key on your keyboard">TAB</span>&quot; key on your keyboard. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <span class="t-blue">Fully featured Web Console version can be downloaded here:</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">**</span> <a class="t-link" href="http://www.web-console.org/download/" title="Visit to Web Console Download" target="_blank">http://www.web-console.org/download/</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="t-dash">**</span><br />'+
		str_spaces + '<span class="t-dash">*************************************************************************************</span>';
	return result;
};
// Setting innerHTML
WC.Console.HTML.set_INNER = function(in_ID, in_TEXT) {
	if (in_ID && typeof(in_TEXT) != 'undefined') {
		var obj = xGetElementById(in_ID);
		if (obj) obj.innerHTML = NL.String.toHTML(in_TEXT);
	}
};
// Adding message inside object for a time
WC.Console.HTML.add_time_message = function(in_ID, in_TEXT, in_SETTINGS) {
	if (in_ID && typeof(in_TEXT) != 'undefined') {
		if (!in_SETTINGS) in_SETTINGS = {};
		if (!in_SETTINGS['TIME']) in_SETTINGS['TIME'] = 5;
		if (typeof in_SETTINGS['IS_HTML'] == 'undefined') in_SETTINGS['IS_HTML'] = 0;

		var obj = xGetElementById(in_ID);
		if (obj) {
			var id_MARK = ''+(new Date()).getTime()+'-'+Math.random();
			obj['timer_MARK'] = id_MARK;
			obj.innerHTML = in_SETTINGS['IS_HTML'] ? in_TEXT : NL.String.toHTML(in_TEXT);
			setTimeout("var o = xGetElementById('"+in_ID+"'); if (o && o['timer_MARK']=='"+id_MARK+"') o.innerHTML = '&nbsp;';", in_SETTINGS['TIME'] * 1000);
		}
	}
};
// Adding (printing) message like command
WC.Console.HTML.add_cmd_message = function(in_message, in_text) {
	var str_message = in_message ? in_message : '';
	var str_text = in_text ? in_text : '';

	WC.Console.HTML.add_command(str_message, str_text);
	// Scrolling to prompt
	WC.Console.Prompt.scroll_to();
};
// Adding (printing) command
WC.Console.HTML.add_command = function(in_command, in_result) {
	var text_command = in_command ? in_command : '';
	var text_result = '';

	// Making new IDs
	var hash_ids = { 'id': WC.Console.HTML._get_id() };
	hash_ids['id_timer'] = '';
	hash_ids['id_command'] = hash_ids['id']+'_command';
	hash_ids['id_result'] = hash_ids['id']+'_result';

	// Generating result DATA
	if (in_result) text_result = in_result;
	else {
		hash_ids['id_timer'] = hash_ids['id']+'_timer';
		text_result = '<span class="t-wait">&nbsp;&nbsp;waiting...&nbsp;<span id="'+hash_ids['id_timer']+'" class="t-timer">00:00:00</span></span>';
	}
	// Printing to OUTPUT
	var cmd_prefix = (WC.Console.OBJ_PROMPT_PREFIX && WC.Console.OBJ_PROMPT_PREFIX.innerHTML) ? WC.Console.OBJ_PROMPT_PREFIX.innerHTML : WC.Console.Prompt.prefix_value_get_default();
	WC.Console.HTML.OUTPUT_append(
		'<div id="'+hash_ids['id']+'" class="block-cmd">'+
			'<div id="'+hash_ids['id_command']+'" class="block-cmd-command">'+cmd_prefix+text_command+'</div>'+
			'<div id="'+hash_ids['id_result']+'" class="block-cmd-result">'+text_result+'</div>'+
		'</div>',
		hash_ids['id']
	);
	// Returning all IDs
	return hash_ids;
};
// Adding (printing) TAB autocompletion
WC.Console.HTML.add_TAB = function(in_result) {
	return WC.Console.HTML.add_command('<span class="t-brown"><span class="t-blue">***</span> TAB <span class="t-blue">(AUTOCOMPLETION)</span></span>', in_result ? in_result : '');
};
// Returning HTML for 'MESSAGE TITLE'
WC.Console.HTML.get_MESSAGE_TITLE = function(in_msg_type) {
	var text_message = '';

	if (in_msg_type == 'info') text_message = 'INFORMATIONAL MESSAGE:';
	else if (in_msg_type == 'error') text_message = 'ERROR MESSAGE:';
	else if (in_msg_type == 'warning') text_message = 'WARNING MESSAGE:';
	else text_message = 'UNKNOWN MESSAGE:';

	return '<div class="custom-report-TITLE">'+text_message+'</div>';
};
// Returning HTML for 'ERROR'
WC.Console.HTML.get_ERROR = function(in_msg) {
	return '<div class="block-error">'+in_msg+'</div>';
};
WC.Console.HTML.message_str_right = function(in_msg, in_size, in_class) {
	var s_msg_short = NL.String.get_str_right_dottes(in_msg, (in_size && in_size > 0) ? in_size : 60)
	var s_span = '<span class="'+ ((in_class && in_class != '') ? in_class : 's-link') +'"';
	if (in_msg.length > s_msg_short.length) s_span += ' style="cursor: help; font-style: normal" title="'+NL.String.toHTML(in_msg, 1)+'">'
	else s_span += '>';
	return s_span+NL.String.toHTML(s_msg_short, 1)+'</span>';
};
WC.Console.HTML.get_AJAX_error = function(in_msg, in_info) {
	var result = '<div class="t-lime" style="margin-left: 16px">AJAX ERROR:</div>'+
		     '<div class="block-error" style="margin-left: 16px">'+ NL.String.toHTML(in_msg).replace(/\n/g, '<br />') +'</div>'
	if (typeof in_info != 'undefined' && in_info != '') result += '<div class="t-red-dark" style="margin-left: 16px">'+in_info+'</div>';
	return result;
};

// Changing status
WC.Console.status_change = function(in_ID, in_TEXT, in_ADD_TIMER) {
	if (!in_TEXT) in_TEXT = 'Idle';
	if (in_ID) {
		var obj = xGetElementById(in_ID);
		if (obj) {
			var str_html = in_TEXT;
			var id_timer = in_ID+'-TIMER';
			if (in_ADD_TIMER) {
				if (str_html != '') str_html += ' ';
				var str_color = '#b66640';
				str_html += '<span style="color:'+str_color+'">[<span id="'+id_timer+'" style="color:'+str_color+'">00:00:00</span>]</span>';
			}
			obj.innerHTML = str_html;
			if (in_ADD_TIMER) return id_timer;
		}
	}
};
