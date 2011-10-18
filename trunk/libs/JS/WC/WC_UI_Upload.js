/*
* WC :: UI :: Upload - Web Console Upload interface methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_DEV
*/
if (typeof WC == "undefined") { alert("WC UI Upload: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('UI.Upload'); }

// Internal storage
WC.UI.Upload._DATA = {
	'CONST': {
		'prefix_ID': 'wc-ui-fm-',
		'prefix_CLASS': 'wc-ui-fm-'
	},
	'DYNAMIC': {
		'id': 0
	}
};
// Updating directorys list
WC.UI.Upload.update_dir_list = function(arr_list, STASH) {
	if (STASH && STASH['id']) {
		var MAX_LEN = 50;
		var obj = xGetElementById('wc-upload-dir-list-'+STASH['id']);
		if (obj) {
			if (document.createElement && (obj.options.add || obj.add)){
				obj.length = 1; // Removing all existing elements exept first
				// Adding new elements
				for (var i in arr_list) {
					var str_text = arr_list[i];
					var new_option = document.createElement('OPTION');
					new_option.value = arr_list[i];
					new_option.text = ' '+NL.String.get_str_right(str_text, MAX_LEN, 1)+' ';
					(obj.options.add) ? obj.options.add(new_option) : obj.add(new_option, null);
				}
				// Selecting first added element
				if (obj.length > 1) { /*obj.selectedIndex = 1;*/ }
				else { obj.selectedIndex = 0; }
			}
		}
	}
};
// Slots management
WC.UI.Upload.slots = function(action, STASH) {
	if (STASH && STASH['id'] && STASH['input_class']) {
		var obj_main = xGetElementById('wc-upload-files-area-'+STASH['id']);
		if(obj_main) {
			// OK, form exists
			var DEF_MAX_FILES = 5;
			var files_total = 1;
			var last_node = obj_main.lastChild;
			var slot_plus = 'wc-upload-button-slot-plus-'+STASH['id'];
			var slot_minus = 'wc-upload-button-slot-minus-'+STASH['id'];
			if(last_node && last_node.type == 'file') {
				var re_arr = /-(\d{0,})$/.exec(last_node.name);
				if (re_arr.length == 2) files_total = re_arr[1];
				// OK
				if (action == 'remove') {
					if (files_total > 1) {
						if (obj_main.removeChild(last_node)) {
							last_node = obj_main.lastChild;
							if (last_node && last_node.nodeName && last_node.nodeName.toLowerCase() == 'br') {
								// That is <BR />
								obj_main.removeChild(last_node);
							}
						}
						if (files_total == 2) {
							var obj_slotMinus = xGetElementById(slot_minus);
							if (!xHasClass(obj_slotMinus, 'wc-upload-div-button-unactive')) {
								xAddClass(obj_slotMinus, 'wc-upload-div-button-unactive');
							}
							/*if (obj_slotMinus && obj_slotMinus.style) {
								if (obj_slotMinus.style.display != 'none') obj_slotMinus.style.display = 'none';
							}*/
						}
						if (files_total == DEF_MAX_FILES) {
							var obj_slotPlus = xGetElementById(slot_plus);
							if (obj_slotPlus) obj_slotPlus.innerHTML='+1 upload slot';
 						}
					}
				}
				else {
					if (files_total < DEF_MAX_FILES) {
						files_total++;

						var new_file_slot = document.createElement('input');
						new_file_slot.type = 'file';
						new_file_slot.id = STASH['id']+'-wc-upload-file-'+files_total;
						new_file_slot.name = '_'+STASH['id']+'-wc-upload-file-'+files_total;
						if (NL.Browser.Detect.isFF && STASH['ff_size']) new_file_slot.size = STASH['ff_size'];
						xAddClass(new_file_slot, STASH['input_class']);

						obj_main.appendChild(document.createElement('br'));
						obj_main.appendChild(new_file_slot);

						if (files_total > 1) {
							var obj_slotMinus = xGetElementById(slot_minus);
							if (xHasClass(obj_slotMinus, 'wc-upload-div-button-unactive')) {
								xRemoveClass(obj_slotMinus, 'wc-upload-div-button-unactive');
							}
							/*if (obj_slotMinus && obj_slotMinus.style) {
								if (obj_slotMinus.style.display == 'none') obj_slotMinus.style.display = 'block';
							}*/
						}
						if (files_total == DEF_MAX_FILES) {
							var obj_slotPlus = xGetElementById(slot_plus);
							if (obj_slotPlus) obj_slotPlus.innerHTML='[ '+DEF_MAX_FILES+' is MAX ]';
						}
					}
				}
			}
		}
	}
};
// Starting uploading
WC.UI.Upload.start = function(in_URL, in_DATA) {
	if (in_URL && in_DATA) {
		// 'CGI.pm' HOOK:
		// in_DATA['CGI_PM_HOOK_ENABLED']

		var obj_UPLOAD = NL.Upload.upload(in_URL,
		// DATA
		{
			'params': {
				// MAIN
				'q_action': 'AJAX_UPLOAD',
				'user_login': in_DATA['user_login'],
				'user_password': in_DATA['user_password'],
				// OTHER
				'dir': in_DATA['dir'],
				'dir_sub': in_DATA['dir_sub'],
				'dir_create': in_DATA['dir_create'],
				'file_permissions': in_DATA['file_permissions'],
				'mode_ASCII': in_DATA['mode_ASCII'],
				'js_ID': in_DATA['js_ID']
			},
			'files': in_DATA['FILES'],
			'callbacks': {
				'uploaded': function(in_DATA, in_STASH) {
					if (in_DATA && in_DATA['CODE'] && in_DATA['CODE'] != 'OK') {
						WC.Console.HTML.add_cmd_message('<span class="t-brown"><span class="t-blue">***</span> UPLOADING FILE(S)</span>', in_DATA['MESSAGE'] ? in_DATA['MESSAGE'] : '');
						WC.UI.Upload.state_PROGRESS_CANCEL(in_STASH['js_ID']);
					}
					else {
						if (in_DATA['UPLOADS'] && in_DATA['INFO']) {
							WC.UI.Upload.state_FINAL(in_DATA['INFO'], in_DATA['UPLOADS']);
						}
					}
				},
				'timer': function() { /*alert('timer');*/ },
				'status': function() { /*alert('status');*/ }
			}
		},
		// STASH
		{
			'js_ID': in_DATA['js_ID']
		});
		return obj_UPLOAD;
	}
	return 0;
};
WC.UI.Upload.state_SHOW = function(in_OBJ) { if (in_OBJ && in_OBJ.style) in_OBJ.style.display = 'block'; };
WC.UI.Upload.state_HIDE = function(in_OBJ) { if (in_OBJ && in_OBJ.style) in_OBJ.style.display = 'none'; };
WC.UI.Upload.state_FIX_WIDTH = function(in_OBJ) {
	if (in_OBJ) {
		var div_width = xWidth(in_OBJ);
		if (div_width && div_width > 0) {
			if(in_OBJ.style) in_OBJ.style.width = div_width+'px';
		}
	}
};
WC.UI.Upload.state_FINAL = function(in_DATA, in_RESULT) {
	if (in_DATA && in_RESULT && in_DATA['js_ID']) {
		var obj_progress = xGetElementById('wc-upload-layout-div-PROGRESS-'+in_DATA['js_ID']);
		var obj_table = xGetElementById('wc-upload-layout-div-PROGRESS-TAB-'+in_DATA['js_ID']);
		var obj_final = xGetElementById('wc-upload-layout-div-FINISH-'+in_DATA['js_ID']);
		if(obj_progress && obj_table && obj_final) {
			var tab_width = xWidth(obj_table);
			var s_tab_width = tab_width > 0 ? ' style="width: '+tab_width+'px"' : '';
			var s_CHMOD = (in_DATA['files_chmod'] && in_DATA['files_chmod'] != 'undefined' && in_DATA['files_chmod'] != '') ? '<tr><td class="area-left-short"><span class="wc-upload-name">Files CHMOD\'ed:</span></td><td class="area-right-long"><span class="wc-upload-chmod">'+NL.String.toHTML(in_DATA['files_chmod'])+'</span></td></tr>' : '';

			// Making files list
			var MAX_LEN = 50;
			var files_num_total = 0;
			var files_num_good = 0;
			var files_good = '';
			var files_bad = '';
			for (var i in in_RESULT) {
				files_num_total++;
				if (in_RESULT[i]['status']) {
					files_num_good++;
					if (files_good != '') files_good += '<br />';
					files_good += '<span class="wc-upload-file-good-main">- '+WC.Console.HTML.message_str_right(in_RESULT[i]['file'], MAX_LEN, 'wc-upload-file-good')+' <span class="wc-upload-file-good-size">('+NL.String.get_str_of_bytes(in_RESULT[i]['size'])+')</span></span>';
					if (in_RESULT[i]['ERROR_MSG'] && in_RESULT[i]['ERROR_MSG'] != '') files_good += '<br /><span class="wc-upload-file-good-info">('+in_RESULT[i]['ERROR_MSG']+')</span>';
				}
				else {
					if (files_bad != '') files_bad += '<br />';
					files_bad += '<span class="wc-upload-file-bad-main">- '+WC.Console.HTML.message_str_right(in_RESULT[i]['file'], MAX_LEN, 'wc-upload-file-bad')+' <span class="wc-upload-file-bad-size">('+NL.String.get_str_of_bytes(in_RESULT[i]['size'])+')</span></span>';
					if (in_RESULT[i]['ERROR_MSG'] && in_RESULT[i]['ERROR_MSG'] != '') files_bad += '<br /><span class="wc-upload-file-bad-info">('+in_RESULT[i]['ERROR_MSG']+')</span>';
				}
			}
			var s_FILES_GOOD = (files_num_good > 0) ? '<tr><td class="area-left-short" style="vertical-align: top"><span class="wc-upload-name">Uploaded files:</span></td><td class="area-right-long">'+files_good+'</td></tr>' : '';
			var s_FILES_BAD = (files_num_total > files_num_good) ? '<tr><td class="area-left-short" style="vertical-align: top"><span class="wc-upload-name">Not uploaded files:</span></td><td class="area-right-long">'+files_bad+'</td></tr>' : '';

			WC.UI.Upload.state_FIX_WIDTH(obj_final);
			var s_HTML = ''+
				'<table id="wc-upload-layout-div-FINAL-TAB-'+in_DATA['js_ID']+'" class="grid"'+s_tab_width+'>'+
					'<tr><td colspan="2" style="padding-bottom: 3px">'+
						'<table class="grid" style="width: 100%"><tr>'+
							'<td class="wc-upload-info-left"><span style="color: #1196cb; font-weight: bold;">Uploading results:</span></td>'+
							'<td class="wc-upload-info-right">&nbsp;</td>'+
						'</tr></table>'+
					'</td></tr>'+
					'<tr><td class="area-left-short"><span class="wc-upload-name">Files uploaded into directory:</span></td><td class="area-right-long">'+WC.Console.HTML.message_str_right(in_DATA['dir_current'])+'</td></tr>'+
					'<tr><td class="area-left-short"><span class="wc-upload-name">Total files uploaded:</span></td><td class="area-right-long"><span class="wc-upload-total-files">'+files_num_good+' of '+files_num_total+'</span></td></tr>'+
					'<tr><td class="area-left-short"><span class="wc-upload-name">Uploaded files size:</span></td><td class="area-right-long"><span class="wc-upload-files-size">~'+NL.String.get_str_of_bytes(in_DATA['size_total'])+'</span></td></tr>'+
					'<tr><td class="area-left-short"><span class="wc-upload-name">Time spent:</span></td><td class="area-right-long"><span class="wc-upload-time">'+NL.Timer.get_str_time(in_DATA['time_spent'], 1)+'</span></td></tr>'+
					s_CHMOD+
					s_FILES_GOOD+
					s_FILES_BAD+
					'<tr><td class="wc-upload-td-buttons" colspan="2">'+
						'<table class="grid"><tr>'+
							'<td class="area-button-left"><div id="wc-upload-FINAL-button-close-'+in_DATA['js_ID']+'" class="div-button w-100">close</div></td>'+
							'<td class="area-button-right"><div id="wc-upload-FINAL-button-new-'+in_DATA['js_ID']+'" class="div-button w-120">new upload</div></td>'+
							'<td class="area-button-right"><div id="wc-upload-FINAL-button-RMBELOW-'+in_DATA['js_ID']+'" class="div-button w-270">Remove all messages below this box</div></td>'+
						'</tr></table>'+
					'</td></tr>'+
				'</table>'+
				'';
			obj_final.innerHTML = s_HTML;
			NL.UI.div_button_register('div-button', 'wc-upload-FINAL-button-close-'+in_DATA['js_ID'], function () { WC.Console.HTML.OUTPUT_remove_result('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']); });
			NL.UI.div_button_register('div-button', 'wc-upload-FINAL-button-RMBELOW-'+in_DATA['js_ID'], function () { WC.Console.HTML.OUTPUT_remove_below('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']); });
			NL.UI.div_button_register('div-button', 'wc-upload-FINAL-button-new-'+in_DATA['js_ID'], function () {
				WC.Console.HTML.OUTPUT_remove_result('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']);
				WC.Console.Exec.CMD_INTERNAL("STARTING NEW UPLOADING FORM", '#file upload');
			});
			WC.UI.Upload.state_HIDE(obj_progress);
			WC.UI.Upload.state_SHOW(obj_final);
		}
	}
};
WC.UI.Upload.state_FINAL_no_RESULT = function(in_DATA) {
	if (in_DATA && in_DATA['js_ID']) {
		var obj_progress = xGetElementById('wc-upload-layout-div-PROGRESS-'+in_DATA['js_ID']);
		var obj_table = xGetElementById('wc-upload-layout-div-PROGRESS-TAB-'+in_DATA['js_ID']);
		var obj_final = xGetElementById('wc-upload-layout-div-FINISH-'+in_DATA['js_ID']);
		if(obj_progress && obj_table && obj_final) {
			var tab_width = xWidth(obj_table);
			var s_tab_width = tab_width > 0 ? ' style="width: '+tab_width+'px"' : '';

			WC.UI.Upload.state_FIX_WIDTH(obj_final);
			var s_HTML = ''+
				'<table id="wc-upload-layout-div-FINAL-TAB-'+in_DATA['js_ID']+'" class="grid"'+s_tab_width+'>'+
					'<tr><td colspan="2" style="padding-bottom: 3px">'+
						'<table class="grid" style="width: 100%"><tr>'+
							'<td class="wc-upload-info-left"><span style="color: #1196cb; font-weight: bold;">Uploading results:</span></td>'+
							'<td class="wc-upload-info-right">&nbsp;</td>'+
						'</tr></table>'+
					'</td></tr>'+
					'<tr><td class="area-left-short" colspan="2"><span class="wc-upload-NO-RESULT">Looks like files has been successfully uploaded, but browser does not receive uploading results from server.<br />'+
					'If browser will receive uploading results, that message will be updated.<br />'+
					'Please check your browser version, and, if necessary, install the latest version.</span></td></td></tr>'+
					'<tr><td class="wc-upload-td-buttons" colspan="2">'+
						'<table class="grid"><tr>'+
							'<td class="area-button-left"><div id="wc-upload-FINAL-button-close-'+in_DATA['js_ID']+'" class="div-button w-100">close</div></td>'+
							'<td class="area-button-right"><div id="wc-upload-FINAL-button-new-'+in_DATA['js_ID']+'" class="div-button w-120">new upload</div></td>'+
							'<td class="area-button-right"><div id="wc-upload-FINAL-button-RMBELOW-'+in_DATA['js_ID']+'" class="div-button w-270">Remove all messages below this box</div></td>'+
						'</tr></table>'+
					'</td></tr>'+
				'</table>'+
				'';
			obj_final.innerHTML = s_HTML;
			NL.UI.div_button_register('div-button', 'wc-upload-FINAL-button-close-'+in_DATA['js_ID'], function () { WC.Console.HTML.OUTPUT_remove_result('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']); });
			NL.UI.div_button_register('div-button', 'wc-upload-FINAL-button-RMBELOW-'+in_DATA['js_ID'], function () { WC.Console.HTML.OUTPUT_remove_below('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']); });
			NL.UI.div_button_register('div-button', 'wc-upload-FINAL-button-new-'+in_DATA['js_ID'], function () {
				WC.Console.HTML.OUTPUT_remove_result('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']);
				WC.Console.Exec.CMD_INTERNAL("STARTING NEW UPLOADING FORM", '#file upload');
			});
			WC.UI.Upload.state_HIDE(obj_progress);
			WC.UI.Upload.state_SHOW(obj_final);
		}
	}
};
WC.UI.Upload.state_PROGRESS_IS_ACTIVE = function(in_JS_ID) {
	if (in_JS_ID) {
		var obj_progress = xGetElementById('wc-upload-layout-div-PROGRESS-'+in_JS_ID);
		if (obj_progress && obj_progress.style && obj_progress.style.display != 'none') return 1;
	};
	return 0;
};
WC.UI.Upload.state_PROGRESS_STOP = function(in_JS_ID) {
	if (in_JS_ID) {
		var obj_UPLOADING = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-'+in_JS_ID);
		if (obj_UPLOADING) {
			obj_UPLOADING.value = '0';
			return 1;
		}
	};
	return 0;
};
WC.UI.Upload.state_PROGRESS_CANCEL = function(in_JS_ID) {
	if (in_JS_ID) {
		var obj_progress = xGetElementById('wc-upload-layout-div-PROGRESS-'+in_JS_ID);
		if (obj_progress && obj_progress.style && obj_progress.style.display != 'none') {
			var obj_main = xGetElementById('wc-upload-layout-div-MAIN-'+in_JS_ID);
			if (obj_main) {
				WC.UI.Upload.state_HIDE(obj_progress);
				WC.UI.Upload.state_SHOW(obj_main);
				obj_progress.innerHTML = '';
				WC.Console.status_change('wc-upload-STATUS-'+in_JS_ID);
				WC.Console.Prompt.scroll_to();
			}
		}
	}
};
WC.UI.Upload.state_PROGRESS = function(in_DATA) {
	if (in_DATA && in_DATA['js_ID']) {
		var obj_main = xGetElementById('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']);
		var obj_table = xGetElementById('wc-upload-layout-div-MAIN-TAB-'+in_DATA['js_ID']);
		var obj_progress = xGetElementById('wc-upload-layout-div-PROGRESS-'+in_DATA['js_ID']);

		if(obj_main && obj_table && obj_progress) {
			var tab_width = xWidth(obj_table);
			var s_tab_width = tab_width > 0 ? ' style="width: '+tab_width+'px"' : '';
			WC.UI.Upload.state_FIX_WIDTH(obj_progress);

			var TEXT_LOADING = '<span class="wc-upload-loading">[loading]</span>';
			var SHOW_FULL_INFO = (in_DATA['UPLOAD_STATUS_METHOD'] && in_DATA['UPLOAD_STATUS_METHOD'] == 'STATUS_FILE');
			var s_HTML_FULL_INFO = '';
			if (SHOW_FULL_INFO) {
				s_HTML_FULL_INFO = '<tr><td class="progress-left">Uploading file:</td><td class="progress-main" id="wc-upload-progress-FILES-'+in_DATA['js_ID']+'">'+TEXT_LOADING+'</td></tr>'+
				'<tr><td class="progress-left">Current file name:&nbsp;</td><td class="progress-main" id="wc-upload-progress-FILE-'+in_DATA['js_ID']+'">'+TEXT_LOADING+'</td></tr>';
			}

			var s_HTML = ''+
			'<form id="wc-upload-PROGRESS-FORM-'+in_DATA['js_ID']+'" name="_wc-upload-PROGRESS-FORM-'+in_DATA['js_ID']+'" method="post" enctype="multipart/form-data" onsubmit="return false">'+
			'<input id="wc-upload-PROGRESS-FORM-STATUS_TIMER_OFF_TIME-'+in_DATA['js_ID']+'" type="hidden" name="_wc-upload-PROGRESS-FORM-STATUS_TIMER_OFF_TIME-'+in_DATA['js_ID']+'" value="0" />'+
			'<input id="wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-'+in_DATA['js_ID']+'" type="hidden" name="_wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-'+in_DATA['js_ID']+'" value="1" />'+
			'<input id="wc-upload-PROGRESS-FORM-STATUS_REQUESTED-'+in_DATA['js_ID']+'" type="hidden" name="_wc-upload-PROGRESS-FORM-STATUS_REQUESTED-'+in_DATA['js_ID']+'" value="0" />'+
			'<input id="wc-upload-PROGRESS-FORM-TIME_SPENT-'+in_DATA['js_ID']+'" type="hidden" name="_wc-upload-PROGRESS-FORM-TIME_SPENT-'+in_DATA['js_ID']+'" value="0" />'+
			'<input id="wc-upload-PROGRESS-FORM-SIZE_CURRENT-'+in_DATA['js_ID']+'" type="hidden" name="_wc-upload-PROGRESS-FORM-SIZE_CURRENT-'+in_DATA['js_ID']+'" value="0" />'+
			'<table id="wc-upload-layout-div-PROGRESS-TAB-'+in_DATA['js_ID']+'" class="grid"'+s_tab_width+'>'+
				'<tr><td colspan="2">'+
					'<table class="grid" style="width: 100%"><tr>'+
						'<td class="wc-upload-info-left"><span style="color: #1196cb; font-weight: bold;">Uploading progress:</span></td>'+
						'<td class="wc-upload-info-right">&nbsp;</td>'+
					'</tr></table>'+
				'</td></tr>'+
				'<tr><td colspan="2">'+
					// MAIN STATUS :: START
					'<table class="wc-upload-progress">'+
						'<tr><td class="wc-upload-progress-td-percents">Uploading progress: <span id="wc-upload-progress-PERCENTS-'+in_DATA['js_ID']+'">0</span>%</td></tr>'+
						'<tr><td class="wc-upload-progress-td-bar"><div class="wc-upload-progress-div-bar"><div class="wc-upload-progress-div-subbar" id="wc-upload-progress-BAR-'+in_DATA['js_ID']+'"></div></div></td></tr>'+
						'<tr><td class="wc-upload-progress-td-approx">Approx speed: <span id="wc-upload-progress-SPEED_APPROX-'+in_DATA['js_ID']+'">'+TEXT_LOADING+'</span></td></tr>'+
						'<tr><td class="wc-upload-td-info">'+
							'<table class="wc-upload-progress-info">'+
								s_HTML_FULL_INFO+
								'<tr><td class="progress-left">Current position:&nbsp;</td><td class="progress-main" id="wc-upload-progress-POSITION-'+in_DATA['js_ID']+'">'+TEXT_LOADING+'</td></tr>'+
								'<tr><td class="progress-left">Time spent:&nbsp;</td><td class="progress-main" id="wc-upload-progress-TIME_SPENT-'+in_DATA['js_ID']+'">00:00:00</td></tr>'+
								'<tr><td class="progress-left">Time left:&nbsp;</td><td class="progress-main" id="wc-upload-progress-TIME_LEFT-'+in_DATA['js_ID']+'">'+TEXT_LOADING+'</td></tr>'+
							'</table>'+
						'</td></tr>'+
					'</table>'+
					// MAIN STATUS :: END
				'</td></tr>'+
				'<tr><td class="wc-upload-td-buttons" colspan="2">'+
					'<table class="grid"><tr>'+
						'<td class="area-button-left" id="wc-upload-PROGRESS-button-stop-AREA-'+in_DATA['js_ID']+'"><div id="wc-upload-PROGRESS-button-stop-'+in_DATA['js_ID']+'" class="div-button w-120">stop</div></td>'+
						'<td class="area-button-right"><div id="wc-upload-PROGRESS-button-close-'+in_DATA['js_ID']+'" class="div-button w-120">close</div></td>'+
						'<td class="area-button-right"><div id="wc-upload-PROGRESS-button-RMBELOW-'+in_DATA['js_ID']+'" class="div-button w-270">Remove all messages below this box</div></td>'+
					'</tr></table>'+
				'</td></tr>'+
			'</table>'+
			'</form>';

			obj_progress.innerHTML = s_HTML;
			NL.UI.div_button_register('div-button', 'wc-upload-PROGRESS-button-RMBELOW-'+in_DATA['js_ID'], function () { WC.Console.HTML.OUTPUT_remove_below('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']); });
			NL.UI.div_button_register('div-button', 'wc-upload-PROGRESS-button-stop-'+in_DATA['js_ID'], function () { WC.UI.Upload.STOP(in_DATA['js_ID']); });
			NL.UI.div_button_register('div-button', 'wc-upload-PROGRESS-button-close-'+in_DATA['js_ID'], function () {
				WC.UI.Upload.STOP(in_DATA['js_ID']);
				WC.Console.HTML.OUTPUT_remove_result('wc-upload-layout-div-MAIN-'+in_DATA['js_ID']);
			});
			WC.UI.Upload.state_HIDE(obj_main);
			WC.UI.Upload.state_SHOW(obj_progress);
		}
	}
};
WC.UI.Upload.STOP = function(in_JS_ID) {
	if (in_JS_ID) {
		var obj = NL.Cache.get(in_JS_ID);
		if (obj) {
			obj.abort();
			NL.Cache.remove(in_JS_ID);
			WC.UI.Upload.state_PROGRESS_STOP(in_JS_ID);
			var obj_TIME_LEFT = xGetElementById('wc-upload-progress-TIME_LEFT-'+in_JS_ID);
			if (obj_TIME_LEFT) obj_TIME_LEFT.innerHTML = '<span class="wc-upload-STOPED">[uploading stopped]</span>';
			// Making 'NEW' button
			obj = xGetElementById('wc-upload-PROGRESS-button-stop-AREA-'+in_JS_ID);
			if (obj) {
				obj.innerHTML = '<div id="wc-upload-PROGRESS-button-new-'+in_JS_ID+'" class="div-button w-120">new upload</div>';
				NL.UI.div_button_register('div-button', 'wc-upload-PROGRESS-button-new-'+in_JS_ID, function () {
					WC.Console.HTML.OUTPUT_remove_result('wc-upload-layout-div-MAIN-'+in_JS_ID);
					WC.Console.Exec.CMD_INTERNAL("STARTING NEW UPLOADING FORM", '#file upload');
				});
			}
		}
	}
};
WC.UI.Upload.state_PROGRESS_update_TIME = function(in_DATA, in_TIME) {
	if (in_DATA && in_DATA['js_ID']) {
		// If we are waiting for RESULT
		var obj_STATUS_TIMER_OFF_TIME = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_TIMER_OFF_TIME-'+in_DATA['js_ID']);
		if (obj_STATUS_TIMER_OFF_TIME && obj_STATUS_TIMER_OFF_TIME.value && parseInt(obj_STATUS_TIMER_OFF_TIME.value)) {
			var max_WAIT_TIME = 30; // Maximum time (seconds) for waiting RESULT
			var in_time_SEC = in_TIME/1000;
			/** max_WAIT_TIME = 3; /* TESTING */
			if (in_time_SEC - parseInt(obj_STATUS_TIMER_OFF_TIME.value) > max_WAIT_TIME) {
				WC.UI.Upload.state_FINAL_no_RESULT(in_DATA);
				return 0;
			}
		}
		// Calculating - if we need to get STATUS
		var obj_STATUS_REQUESTED = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_REQUESTED-'+in_DATA['js_ID']);
		var obj_TIME = xGetElementById('wc-upload-PROGRESS-FORM-TIME_SPENT-'+in_DATA['js_ID']);
		var obj_TIME_SPENT = xGetElementById('wc-upload-progress-TIME_SPENT-'+in_DATA['js_ID']);
		if (obj_TIME && obj_TIME_SPENT) {
			obj_TIME.value = in_TIME;
			obj_TIME_SPENT.innerHTML = NL.Timer.get_str_time(in_TIME);
		}
		var TIME_AJAX_ASK_INTERVAL = 3000;
		if(obj_STATUS_REQUESTED && !parseInt(obj_STATUS_REQUESTED.value) && (in_TIME % TIME_AJAX_ASK_INTERVAL) == 0) {
			obj_STATUS_REQUESTED.value = 1;
			return 1;
		}
	}
	return 0;
};
WC.UI.Upload.state_PROGRESS_update = function(in_DATA, in_RESULT, in_STASH) {
	if (in_DATA && in_STASH && in_DATA['js_ID']) {
		var SHOW_FULL_INFO = (in_STASH['UPLOAD_STATUS_METHOD'] && in_STASH['UPLOAD_STATUS_METHOD'] == 'STATUS_FILE');
		// 'MAIN' DATA
		var obj_form_SIZE_CURRENT = xGetElementById('wc-upload-PROGRESS-FORM-SIZE_CURRENT-'+in_DATA['js_ID']);
		var obj_PERCENTS = xGetElementById('wc-upload-progress-PERCENTS-'+in_DATA['js_ID']);
		var obj_BAR = xGetElementById('wc-upload-progress-BAR-'+in_DATA['js_ID']);
		var obj_SPEED_APPROX = xGetElementById('wc-upload-progress-SPEED_APPROX-'+in_DATA['js_ID']);
		var obj_POSITION = xGetElementById('wc-upload-progress-POSITION-'+in_DATA['js_ID']);
		var obj_TIME_LEFT = xGetElementById('wc-upload-progress-TIME_LEFT-'+in_DATA['js_ID']);
		var obj_form_TIME_SPENT = xGetElementById('wc-upload-PROGRESS-FORM-TIME_SPENT-'+in_DATA['js_ID']);
		// 'FULL_INFO' DATA
		var obj_FILES = null;
		var obj_FILE = null;
		if (SHOW_FULL_INFO) {
			obj_FILES = xGetElementById('wc-upload-progress-FILES-'+in_DATA['js_ID']);
			obj_FILE = xGetElementById('wc-upload-progress-FILE-'+in_DATA['js_ID']);
		}

		if (obj_form_SIZE_CURRENT && obj_PERCENTS && obj_BAR && obj_SPEED_APPROX && obj_POSITION && obj_TIME_LEFT && obj_form_TIME_SPENT &&
		    (!SHOW_FULL_INFO || (obj_FILES && obj_FILE) ) ) {
		    		if (in_RESULT['size_current'] > parseInt(obj_form_SIZE_CURRENT.value)) {
					var str_FINISHED = '[FINISHED, PROCESSING FILE(S), PLEASE WAIT]';
					obj_form_SIZE_CURRENT.value = in_RESULT['size_current'];
					// 'MAIN' DATA
					var now_POSITION_now = in_RESULT['size_current'];
					var now_POSITION_total = in_RESULT['size_total'];
					var IS_FINISHED = (in_RESULT['status'] && in_RESULT['status'] == 'FINISHED');

					var time_SEC = obj_form_TIME_SPENT.value / 1000;
					var now_SPEED_APPROX = now_POSITION_now / time_SEC;
					var now_PERCENTS = Math.floor( (now_POSITION_now / now_POSITION_total) * 100 );
					var now_POSITION = NL.String.get_str_of_bytes(now_POSITION_now)+' of '+NL.String.get_str_of_bytes(now_POSITION_total);
					if (IS_FINISHED) obj_SPEED_APPROX.innerHTML = NL.String.toHTML(str_FINISHED, 1);
					else obj_SPEED_APPROX.innerHTML = NL.String.toHTML(NL.String.get_str_of_bytes(now_SPEED_APPROX)+'/s', 1);
					obj_PERCENTS.innerHTML = NL.String.toHTML(now_PERCENTS, 1);
					obj_BAR.style.width = NL.String.toHTML(''+now_PERCENTS+'%', 1);
					// 'FULL_INFO' DATA
					if (SHOW_FULL_INFO) {
						var MAX_LEN = 80;
						var now_FILES = in_RESULT['file_current_number']+' of '+in_STASH['FILES_TOTAL'];
						var now_FILE = in_RESULT['file_current_name'];

						if (IS_FINISHED) {
							obj_FILES.innerHTML = NL.String.toHTML(str_FINISHED, 1);
							obj_FILE.innerHTML = NL.String.toHTML(str_FINISHED, 1);
						}
						else {
							obj_FILES.innerHTML = NL.String.toHTML(now_FILES, 1);
							obj_FILE.innerHTML = WC.Console.HTML.message_str_right(now_FILE, MAX_LEN);
						}
					}
					if (IS_FINISHED) obj_TIME_LEFT.innerHTML = NL.String.toHTML(str_FINISHED, 1);
					else obj_TIME_LEFT.innerHTML = NL.Timer.get_str_time( Math.ceil( (now_POSITION_total - now_POSITION_now) / now_SPEED_APPROX), 1);
					obj_POSITION.innerHTML = NL.String.toHTML(now_POSITION, 1);

					// If we have 100% - setting 'Timer' stopping flag
					if (now_PERCENTS >= 100) {
						var obj_STATUS_TIMER_ON = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_TIMER_ON-'+in_DATA['js_ID']);
						if (obj_STATUS_TIMER_ON) {
							obj_STATUS_TIMER_ON.value = '0';
						}
						// Setting timer stop time
						var obj_STATUS_TIMER_OFF_TIME = xGetElementById('wc-upload-PROGRESS-FORM-STATUS_TIMER_OFF_TIME-'+in_DATA['js_ID']);
						if (obj_STATUS_TIMER_OFF_TIME) obj_STATUS_TIMER_OFF_TIME.value = time_SEC;
					}
				}
				return 1;
		}
	}
	return 0;
};
