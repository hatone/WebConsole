/*
* WC :: UI - User Interface methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_DEV
*/
if (typeof WC == "undefined") { alert("WC UI: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('UI'); }

// Internal storage
WC.UI._DATA = {
	'CONST': {
		'prefix_ID': 'wc-ui-',
		'prefix_CLASS': 'wc-ui-',
		'TAB_SUFFIX': 'tab-'
	},
	'DYNAMIC': {
		'id': 0
	}
};

// ID number generation
WC.UI._get_ID = function() {
	WC.UI._DATA['DYNAMIC']['id'] = WC.UI._DATA['DYNAMIC']['id']+1;
	return WC.UI._DATA['DYNAMIC']['id'];
};
// Getting DIV object by TAB element ID (internal)
WC.UI._tab_get_DIV_obj = function(in_VAL, in_id_PREFIX) {
	if (in_VAL && in_id_PREFIX && in_VAL.indexOf(in_id_PREFIX) == 0) {
		var id_DIV = in_VAL.substr(in_id_PREFIX.length);
		if (id_DIV) return xGetElementById(id_DIV);
	}
	return null;
};
// Activating TAB menu element
WC.UI.tab_activate = function(in_ID_TAB, in_NAME_ACTIVATE, is_MENU_DIV_SAME_SIZE) {
	if (in_ID_TAB && in_NAME_ACTIVATE) {
		if (typeof is_MENU_DIV_SAME_SIZE == 'undefined') is_MENU_DIV_SAME_SIZE = 1;
		var ID_MENU = in_ID_TAB + '-menu-TR';
		var obj_MENU = xGetElementById(ID_MENU);
		if (obj_MENU) {
			if (obj_MENU.hasChildNodes()) {
				var class_ACTIVE = WC.UI._DATA['CONST']['prefix_CLASS'] + 'tab-menu-element-ACTIVE';
				var ID_ELEMENT_PREFIX = in_ID_TAB + '-menu-element-';
				var obj_ACTIVE = null;
				var obj_NEEDED = null;
				var c = obj_MENU.childNodes;
				for (var i = c.length - 1; i >= 0; i--) {
					if (xHasClass(c[i], class_ACTIVE)) {
						obj_ACTIVE = c[i];
						if (obj_NEEDED) {
							if (obj_NEEDED == obj_ACTIVE) return true;
							else break;
						}
					}
					if (c[i].hasChildNodes()) {
						var obj_span = c[i].firstChild;
						if (obj_span && obj_span.innerHTML && obj_span.innerHTML == in_NAME_ACTIVATE) {
							obj_NEEDED = c[i];
							if (obj_ACTIVE) {
								if (obj_ACTIVE == obj_NEEDED) return true;
								else break;
							}
						}
					}
				}
				WC.UI._tab_activate(ID_MENU, obj_NEEDED.id, ID_ELEMENT_PREFIX, is_MENU_DIV_SAME_SIZE ? 1 : 0);
				return true;
			}
		}
	}
	return false;
};
// Activating TAB menu element (internal)
WC.UI._tab_activate = function(in_ID_MENU, in_ID_ACTIVATE, in_id_PREFIX, is_MENU_DIV_SAME_SIZE) {
	if (in_ID_ACTIVATE && in_ID_MENU && in_id_PREFIX) {
		if (typeof is_MENU_DIV_SAME_SIZE == 'undefined') is_MENU_DIV_SAME_SIZE = 1;
		var obj_NOW = xGetElementById(in_ID_ACTIVATE);
		var obj_MENU = xGetElementById(in_ID_MENU);
		if (obj_NOW && obj_MENU) {
			var class_ACTIVE = WC.UI._DATA['CONST']['prefix_CLASS'] + 'tab-menu-element-ACTIVE';
			if (!xHasClass(obj_NOW, class_ACTIVE)) {
				var obj_DIV;
				var size_X = 0, size_Y = 0;
				// Deactivating current active element
				if (obj_MENU.hasChildNodes()) {
					var c = obj_MENU.childNodes;
					for (var i = c.length - 1; i >= 0; i--) {
						if (xHasClass(c[i], class_ACTIVE)) {
							if (c[i].id) {
								obj_DIV = WC.UI._tab_get_DIV_obj(c[i].id, in_id_PREFIX);
								if (obj_DIV && obj_DIV.style) {
									if (is_MENU_DIV_SAME_SIZE) {
										size_X = xWidth(obj_DIV);
										size_Y = xHeight(obj_DIV);
									}
									obj_DIV.style.display = 'none';
								}
							}
							xRemoveClass(c[i], class_ACTIVE);
							break;
						}
					}
				}
				// Activating clicked element
				xAddClass(obj_NOW, class_ACTIVE);
				obj_DIV = WC.UI._tab_get_DIV_obj(in_ID_ACTIVATE, in_id_PREFIX);
				if (obj_DIV && obj_DIV.style) {
					if (size_X > 0 && size_Y > 0) {
						obj_DIV.style.width = size_X+'px';
						obj_DIV.style.height = size_Y+'px';
					}
					obj_DIV.style.display = 'block';
				}
				return true;
			}
		}
	}
	return false;
};
// Setting TAB
WC.UI.tab_set = function(in_OBJ, in_TITLE, in_CONTENT, in_SETTINGS) {
	if (in_OBJ) {
		var obj = xGetElementById(in_OBJ);
		if (obj) {
			if (!in_TITLE) in_TITLE = '';
			if (!in_CONTENT) in_CONTENT = '';
			if (!in_SETTINGS) in_SETTINGS = {};
			obj.innerHTML = WC.UI.tab(in_TITLE, in_CONTENT, in_SETTINGS);
		}
	}
}
// Writing TAB
WC.UI.tab_write = function() { document.write(WC.UI.tab(arguments)); }
// Creating TAB
WC.UI.tab = function(in_TITLE, in_CONTENT, in_SETTINGS) {
	if (!in_TITLE) in_TITLE = '';
	if (!in_CONTENT) in_CONTENT = '';
	if (!in_SETTINGS) in_SETTINGS = {};
	var ID_TAB = in_SETTINGS['ID'] ? in_SETTINGS['ID'] : WC.UI._DATA['CONST']['prefix_ID'] + 'tab-' + WC.UI._get_ID();
	var is_MENU_DIV_SAME_SIZE = (typeof in_SETTINGS['MENU_DIV_SIZE_SAME'] == 'undefined' || in_SETTINGS['MENU_DIV_SIZE_SAME']) ? 1 : 0;

	// Menu generation
	var class_TITLE_POSTFIX = '', str_MENU = '';
	if (in_SETTINGS['MENU']) {
		class_TITLE_POSTFIX = '-menu';
		var ID_ELEMENT_PREFIX = ID_TAB + '-menu-element-';
		var ID_MENU = ID_TAB + '-menu-TR';
		var menu_items = '', item_i = 0;
		for (var i in in_SETTINGS['MENU']) {
			if (in_SETTINGS['MENU'][i]['id']) {
				var ID_ELEMENT = ID_ELEMENT_PREFIX + in_SETTINGS['MENU'][i]['id'];
				var class_ELEMENT = '';
				if (in_SETTINGS['MENU'][i]['active']) class_ELEMENT = ' class="' + WC.UI._DATA['CONST']['prefix_CLASS'] + 'tab-menu-element-ACTIVE"';
				menu_items += '<td id="'+ID_ELEMENT+'"'+class_ELEMENT+'><span unselectable="on" onclick="WC.UI._tab_activate(\''+ID_MENU+'\', \''+ID_ELEMENT+'\', \''+ID_ELEMENT_PREFIX+'\', '+is_MENU_DIV_SAME_SIZE+'); return false">'+i+'</span></td>';
				item_i++;
			}
		}
		menu_items += '<td class="' + WC.UI._DATA['CONST']['prefix_CLASS'] + 'tab-menu-element-space">&nbsp</td>';
		str_MENU = '<tr><td class="' + WC.UI._DATA['CONST']['prefix_CLASS'] + 'tab-menu"><table class="grid"><tr id="' + ID_MENU + '">' + menu_items + '</tr></table></td></tr>';
	}
	// Bottom generation
	var str_BOTTOM = '';
	if (in_SETTINGS['BOTTOM']) {
		str_BOTTOM = '<tr><td class="' + WC.UI._DATA['CONST']['prefix_CLASS'] + 'tab-bottom">'+in_SETTINGS['BOTTOM']+'</td></tr>';
	}
	// Style settings
	var str_STYLE = '';
	if (typeof in_SETTINGS['WIDTH'] != 'undefined' && in_SETTINGS['WIDTH'] == 'FULL-AUTO') {
		str_STYLE = 'style="width: 100%" ';
	}
	// Returning table
	return '' +
	'<table class="'+WC.UI._DATA['CONST']['prefix_CLASS']+'tab" '+str_STYLE+'id="'+ID_TAB+'">' +
	'<tr><td class="'+WC.UI._DATA['CONST']['prefix_CLASS']+'tab-top">' +
		'<table class="grid"><tr>' +
			'<td class="'+WC.UI._DATA['CONST']['prefix_CLASS']+'tab-title'+class_TITLE_POSTFIX+'">'+in_TITLE+'</td>' +
			'<td class="'+WC.UI._DATA['CONST']['prefix_CLASS']+'tab-title-center">&nbsp;</td>' +
		'</tr></table>' +
	'</td></tr>' + str_MENU +
	'<tr><td class="'+WC.UI._DATA['CONST']['prefix_CLASS']+'tab-main">'+in_CONTENT+'</td></tr>' + str_BOTTOM +
	'</table>';
};
