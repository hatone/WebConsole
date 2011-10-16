/*
* WC :: UI :: Filemanager - Web Console File Manager interface methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_DEV
*/
if (typeof WC == "undefined") { alert("WC UI Filemanager: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('UI.Filemanager'); }

// Internal storage
WC.UI.Filemanager._DATA = {
	'CONST': {
		'prefix_ID': 'wc-ui-fm-',
		'prefix_CLASS': 'wc-ui-fm-'
	},
	'DYNAMIC': {
		'id': 0
	}
};

// Activating element
WC.UI.Filemanager.activate = function(in_THIS, in_HASH) {
	if (in_THIS && in_HASH && in_HASH['id_files_selected']) {
	 	if (!xHasClass(in_THIS, 'back')) {
			var obj_FS = xGetElementById(in_HASH['id_files_selected']);
			var files_selected = parseInt(obj_FS.innerHTML);
			var class_ACTIVE = WC.UI.Filemanager._DATA['CONST']['prefix_CLASS'] + 'element-ACTIVE';
			if (!xHasClass(in_THIS, class_ACTIVE)) {
				xAddClass(in_THIS, class_ACTIVE);
				if (obj_FS) obj_FS.innerHTML = files_selected + 1;
			}
			else {
				xRemoveClass(in_THIS, class_ACTIVE);
				if (obj_FS && files_selected > 0) obj_FS.innerHTML = files_selected - 1;
			}
		}
	}
};
// Changing status
WC.UI.Filemanager.status_change = function(in_ID, in_TEXT, in_ADD_TIMER) {
	return WC.Console.status_change(in_ID ? in_ID : '', in_TEXT ? in_TEXT : '', in_ADD_TIMER ? in_ADD_TIMER : 0);
};
// Double click at element
WC.UI.Filemanager.double_click = function(in_OBJ, in_ID, in_CLASS) {
	if (in_OBJ && in_OBJ.innerHTML && in_ID) {
		var obj_PATH = xGetElementById('_wc-file-manager-PATH-'+in_ID);
		var obj_SYNC = xGetElementById('_wc_file_manager_PATH-UPDATE-'+in_ID);
		if (obj_PATH && obj_SYNC) {
				var value = NL.String.fromHTML(in_OBJ.innerHTML);
				WC.Console.HTML.set_INNER('_wc_file_manager_STATUS-MESSAGE-'+in_ID, '');
				// OK, executing command
				if (in_CLASS && in_CLASS == 'file') {
					WC.Console.Exec.CMD_INTERNAL('OPENING FILE &quot;'+NL.String.toHTML(NL.String.get_str_right(value, 40, 1))+'&quot;', '#file open', { '-dir': obj_PATH.value }, [value]);
				}
				else {
					var id_timer = WC.UI.Filemanager.status_change('_wc_file_manager_STATUS-'+in_ID, 'Changing path', 1)
					WC.Console.Exec.CMD_INTERNAL("CHANGING PATH", '#file _manager_ACTION',
						{
							'ACTION': 'go', 'dir': obj_PATH.value, 'js_ID': in_ID, 'update_path': 1,
							'go_path': value, 'synchronize_global_path': (obj_SYNC.checked) ? 1 : 0 },
						[],
						{ 'type': 'hidden', 'id_TIMER': id_timer }
					);
				}
		}
		else alert("Unable to find File Manager objects (internal error)");
	}
};
// Making all elements unselectable
WC.UI.Filemanager.make_unselectable = function(in_ID) {
	if (in_ID) {
		var obj = xGetElementById(in_ID);
		if (obj) WC.UI.Filemanager._selection_ACTION(obj, 'UNSELECTABLE');
	}
};
// Clearing selection
WC.UI.Filemanager.selection_clear = function(in_ID, in_ID_SELECTED) {
	if (in_ID && in_ID_SELECTED) {
		var obj = xGetElementById(in_ID);
		var obj_SELECTED = xGetElementById(in_ID_SELECTED);
		if (obj && obj_SELECTED) {
			var files_selected = parseInt(obj_SELECTED.innerHTML);
			if (files_selected > 0) {
				WC.UI.Filemanager._selection_ACTION(obj, 'CLEAR');
				obj_SELECTED.innerHTML = 0;
			}
		}
	}
};
// Selecting all
WC.UI.Filemanager.selection_all = function(in_ID, in_ID_SELECTED) {
	if (in_ID && in_ID_SELECTED) {
		var obj = xGetElementById(in_ID);
		var obj_SELECTED = xGetElementById(in_ID_SELECTED);
		if (obj && obj_SELECTED) {
			obj_SELECTED.innerHTML = WC.UI.Filemanager._selection_ACTION(obj, 'ALL');
		}
	}
};
// Selecting by REGEX
WC.UI.Filemanager.selection_regex = function(in_ID, in_ID_SELECTED, in_REGEX) {
	if (in_ID && in_ID_SELECTED && in_REGEX) {
		var obj = xGetElementById(in_ID);
		var obj_SELECTED = xGetElementById(in_ID_SELECTED);
		if (obj && obj_SELECTED) {
			obj_SELECTED.innerHTML = WC.UI.Filemanager._selection_ACTION(obj, 'REGEX', { 'regex': new RegExp(in_REGEX) });
		}
	}
};
// Getting selected names
WC.UI.Filemanager.selection_get = function(in_ID, in_ID_SELECTED) {
	if (in_ID && in_ID_SELECTED) {
		var obj = xGetElementById(in_ID);
		var obj_SELECTED = xGetElementById(in_ID_SELECTED);
		if (obj && obj_SELECTED) {
			var files_selected = parseInt(obj_SELECTED.innerHTML);
			if (files_selected > 0) return WC.UI.Filemanager._selection_ACTION(obj, 'GET');
		}
	}
	return [];
};
// Making ACTION with selection
WC.UI.Filemanager._selection_ACTION = function(in_OBJ, in_ACTION, in_PARAMETERS) {
	var action = typeof (in_ACTION) != 'undefined' ? in_ACTION : '';

	var selected = 0;
	var arr_values = [];
	if (in_OBJ && in_OBJ.hasChildNodes()) {
		var c = in_OBJ.childNodes;
		for (var i = 0; i < c.length; i++)
		{
			// Checking if it is DIV
			var is_DIV = 0;
			if (NL.Browser.Detect.isFF || NL.Browser.Detect.isOPERA) is_DIV = (c[i] instanceof HTMLDivElement);
			else is_DIV = (c[i].tagName.toLowerCase() == 'div');
			// Processing
			if (is_DIV) {
				if ( (!xHasClass(c[i], 'free') || action == 'UNSELECTABLE') && (!xHasClass(c[i], 'back') || action == 'UNSELECTABLE')) {
					if (action == 'UNSELECTABLE') NL.UI.object_make_unselectable(c[i]);
					else {
						var class_ACTIVE = WC.UI.Filemanager._DATA['CONST']['prefix_CLASS'] + 'element-ACTIVE';
						if (xHasClass(c[i], class_ACTIVE)) {
							if (action == 'CLEAR') xRemoveClass(c[i], class_ACTIVE);
							else if (action == 'GET') arr_values.push( NL.String.fromHTML(c[i].innerHTML) );
							else if (action == 'ALL') selected++;
							else if (action == 'REGEX') selected++;
						}
						else {
							if (action == 'ALL') { xAddClass(c[i], class_ACTIVE); selected++; }
							else if (action == 'REGEX') {
								if (in_PARAMETERS && in_PARAMETERS['regex'] && c[i].innerHTML.match(in_PARAMETERS['regex'])) {
									xAddClass(c[i], class_ACTIVE);
									selected++;
								}
							}
						}
					}
				}
			}
			else if (c[i].hasChildNodes()) {
				if (action == 'CLEAR' || action == 'UNSELECTABLE') WC.UI.Filemanager._selection_ACTION(c[i], action);
				else if (action == 'GET') arr_values = arr_values.concat(WC.UI.Filemanager._selection_ACTION(c[i], action));
				else if (action == 'ALL') selected += WC.UI.Filemanager._selection_ACTION(c[i], action);
				else if (action == 'REGEX') selected += WC.UI.Filemanager._selection_ACTION(c[i], action, (in_PARAMETERS) ? in_PARAMETERS : {});
			}
		}
	}
	if (action == 'GET') return arr_values;
	else if (action == 'ALL') return selected;
	else if (action == 'REGEX') return selected;
};
