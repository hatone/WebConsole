/*
* NL :: Timer - Advanced timers management
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof NL == "undefined") { var NL = { 'Timer': {} }; }
else { NL.namespace('Timer'); }

NL.Timer._OBJ_TIMER = { 'LOCKS': {} }; // Main timer object
// Getting current time
// IN: NOTHING
// RETURN: NUMBER - current time
NL.Timer.get_current_time = function() { return (new Date()).getTime(); };
// Generation of time text
// Getting current time
// IN: NUMBER - time difference, NUMBER - is it seconds (1 - yes | 0 - no)
// RETURN: STRING - time text
NL.Timer.get_str_time = function(in_time_difference, in_is_seconds) {
	var s = 0;
	if (in_is_seconds) { s = in_time_difference; }
	// converting miliseconds to seconds
	else { s = Math.ceil(in_time_difference/1000); }

	var h = Math.floor(s/3600);
	s -= h*3600;
	var m = Math.floor(s/60);
	s -= m*60;

	if (String(h).length < 2) h = String('0'+h);
	if (String(m).length < 2) m = String('0'+m);
	if (String(s).length < 2) s = String('0'+s);

	return h+':'+m+':'+s;
};
// Getting id of element at array (internal)
// IN: ARRAY - where we finding, OBJECT - function what we finding
// RETURN: NUMBER >= 0 - element id | -1 - not found
NL.Timer._get_item_id = function(in_ARR, in_VALUE, in_VALUE_NAME) {
	if (typeof in_VALUE_NAME == 'undefined') in_VALUE_NAME = '';
	if (typeof in_ARR != 'undefined' && typeof in_VALUE != 'undefined' && in_ARR.length > 0) {
		for (var i in in_ARR) {
			if (in_VALUE_NAME != '') {
				if (typeof in_ARR[i][in_VALUE_NAME] != 'undefined' && in_ARR[i][in_VALUE_NAME] == in_VALUE) return i;
			}
			else {
				if (in_ARR[i] == in_VALUE) return i;
			}
		}
	}
	return -1;
};
// Adding new timer
// IN: NUMBER - interval at ms, OBJECT - callback function, OBJECT - stash that will be sent to callback function
// RETURN: 1 - added | 0 - not added
NL.Timer.timer_add = function(in_INTERVAL, in_CALLBACK_FUNCTION, in_STASH) {
	if (typeof in_STASH == 'undefined') { in_STASH = null; }

	if (typeof in_INTERVAL != 'undefined' && typeof in_CALLBACK_FUNCTION != 'undefined' && in_INTERVAL > 0 && NL.Timer._OBJ_TIMER) {
		if (NL.Timer._OBJ_TIMER[in_INTERVAL]) {
			// Interval exists
			if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions']) {
				var function_id = NL.Timer._get_item_id(NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'], in_CALLBACK_FUNCTION, 'function');
				if (function_id >= 0) {
					// That function is defined
					if (typeof NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][function_id]['DATA'] != 'undefined') {
						// DATA is defined
						if (NL.Timer._get_item_id(NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][function_id]['DATA'], in_STASH, 'stash') < 0) {
							// No our STASH defined
							NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][function_id]['DATA'].push({'time': 0, 'stash': in_STASH});
						}
					}
					else {
						// No DATA is defined
						NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][function_id]['DATA'] = [{'time': 0, 'stash': in_STASH}];
					}
				}
				else {
					// No that function defined
					NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].push({
						'function': in_CALLBACK_FUNCTION,
						'DATA': [{'time': 0, 'stash': in_STASH}]
					});
				}
			}
			else {
				// No functions at interval - making new
				NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'] = [{
					'function': in_CALLBACK_FUNCTION,
					'DATA': [{'time': 0, 'stash': in_STASH}]
				}];
			}
		}
		else {
			// New interval
			NL.Timer._OBJ_TIMER[in_INTERVAL] = {
				'functions': [{
					'function': in_CALLBACK_FUNCTION,
					'DATA': [{'time': 0, 'stash': in_STASH}]
				}]
			};
		}
		return 1;
	}
	return 0;
};
// Timer for '1 second'
NL.Timer.timer_add_SECOND = function(in_CALLBACK_FUNCTION, in_STASH) { return NL.Timer.timer_add(1000, in_CALLBACK_FUNCTION, in_STASH); };
// Adding new timer and starting it
// IN: NUMBER - interval at ms, OBJECT - callback function, OBJECT - stash that will be sent to callback function
// RETURN: 1 - started | 0 - not started
NL.Timer.timer_add_and_on = function(in_INTERVAL, in_CALLBACK_FUNCTION, in_STASH) {
	if ( NL.Timer.timer_add(in_INTERVAL, in_CALLBACK_FUNCTION, in_STASH) ) return NL.Timer.timer_on(in_INTERVAL);
	return 0;
};
// Executing 'CALLBACK_FUNCTION', adding new timer and starting it
// IN: NUMBER - interval at ms, OBJECT - callback function, OBJECT - stash that will be sent to callback function
// RETURN: 1 - started | 0 - not started
NL.Timer.timer_add_exec_and_on = function(in_INTERVAL, in_CALLBACK_FUNCTION, in_STASH, in_SETTINGS) {
	if (in_SETTINGS && in_SETTINGS['SLEEP_MS']) NL.Timer.sleep(in_SETTINGS['SLEEP_MS']);
	in_CALLBACK_FUNCTION(in_STASH, 0);
	return NL.Timer.timer_add_and_on(in_INTERVAL, in_CALLBACK_FUNCTION, in_STASH);
};
// Sleeping
// IN: NUMBER - interval at ms
// RETURN: NOTHING
NL.Timer.sleep = function (in_MS) {
	var time_now = new Date();
	var time_stop = time_now.getTime() + in_MS;
	while (true) {
		time_now = new Date();
		if (time_now.getTime() > time_stop) return;
	}
};
// Timer for '1 second'
NL.Timer.timer_add_and_on_SECOND = function(in_CALLBACK_FUNCTION, in_STASH) { return NL.Timer.timer_add_and_on(1000, in_CALLBACK_FUNCTION, in_STASH); };
// Checking is timer ON for interval
// IN: NUMBER - interval at ms
// RETURN: 1 - ON | 0 - OFF
NL.Timer.timer_is_on = function(in_INTERVAL) {
	if (typeof in_INTERVAL != 'undefined' && in_INTERVAL > 0 && NL.Timer._OBJ_TIMER) {
		if (NL.Timer._OBJ_TIMER[in_INTERVAL] && NL.Timer._OBJ_TIMER[in_INTERVAL]['TIMER_OBJECT']) return 1;
	}
	return 0;
};
// Starting timer for interval
// IN: NUMBER - interval at ms
// RETURN: 1 - started | 0 - not started
NL.Timer.timer_on = function(in_INTERVAL) {
	if (typeof in_INTERVAL != 'undefined' && in_INTERVAL > 0 && NL.Timer._OBJ_TIMER) {
		if (NL.Timer._OBJ_TIMER[in_INTERVAL]) {
			if (!NL.Timer._OBJ_TIMER[in_INTERVAL]['TIMER_OBJECT']) {
				if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'] && NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].length > 0) {
					NL.Timer._OBJ_TIMER[in_INTERVAL]['TIMER_OBJECT'] = setInterval('NL.Timer._timer_update('+in_INTERVAL+')', in_INTERVAL);
				}
			}
			return 1;
		}
	}
	return 0;
};
// Stopping timer for interval
// IN: NUMBER - interval at ms
// RETURN: 1 - started | 0 - not started
NL.Timer.timer_off = function(in_INTERVAL) {
	if (typeof in_INTERVAL != 'undefined' && in_INTERVAL > 0 && NL.Timer._OBJ_TIMER) {
		if (NL.Timer._OBJ_TIMER[in_INTERVAL]) {
			if (NL.Timer._OBJ_TIMER[in_INTERVAL]['TIMER_OBJECT']) {
				clearInterval(NL.Timer._OBJ_TIMER[in_INTERVAL]['TIMER_OBJECT']);
				delete NL.Timer._OBJ_TIMER[in_INTERVAL]['TIMER_OBJECT'];
			}
			return 1;
		}
	}
	return 0;
};
// Removing timer (THAT IS NOT RECOMMENDED)
// RECOMMENDED WAY OF TIMERS REMOVING - RETURN '0' AT TIMER CALLBACK FUNCTIONS
// IN: NUMBER - interval at ms [, OBJECT - callback function [, OBJECT - stash that will be sent to callback function]]
// RETURN: 1 - removed | 0 - not removed
NL.Timer.timer_remove = function(in_INTERVAL, in_CALLBACK_FUNCTION, in_STASH) {
	var delete_TYPE = 'STASH';
	if (typeof in_STASH == 'undefined') { delete_TYPE = 'FUNCTION'; }
	if (typeof in_CALLBACK_FUNCTION == 'undefined') { delete_TYPE = 'INTERVAL'; }

	if (typeof in_INTERVAL != 'undefined' && in_INTERVAL > 0 && NL.Timer._OBJ_TIMER) {
		if (NL.Timer._OBJ_TIMER[in_INTERVAL]) {
			// Removing interval
			if (delete_TYPE == 'INTERVAL') {
				NL.Timer.timer_off(in_INTERVAL);
				delete NL.Timer._OBJ_TIMER[in_INTERVAL];
				return 1;
			}
			else if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'] && NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].length > 0) {
				for (var i in NL.Timer._OBJ_TIMER[in_INTERVAL]['functions']) {
					if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['function'] == in_CALLBACK_FUNCTION) {
						// Removing function
						if (delete_TYPE == 'FUNCTION') {
							NL.Timer.timer_off(in_INTERVAL);
							NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].splice(i,1);
							if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].length <= 0) delete NL.Timer._OBJ_TIMER[in_INTERVAL];
							else NL.Timer.timer_on(in_INTERVAL);
							return 1;
						}
						// Removing STASH
						else if (delete_TYPE == 'STASH') {
							var id_STASH = NL.Timer._get_item_id(NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'], in_STASH, 'stash');
							if (id_STASH >= 0) {
								NL.Timer.timer_off(in_INTERVAL);
								NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'].splice(id_STASH,1);
								if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'].length <= 0) {
									delete NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i];
									if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].length <= 0) delete NL.Timer._OBJ_TIMER[in_INTERVAL];
									else NL.Timer.timer_on(in_INTERVAL);
								}
								else NL.Timer.timer_on(in_INTERVAL);
								return 1;
							}
						}
						break;
					}
				}
			}
		}
	}
	return 0;
};
NL.Timer._is_browser_FF = function() {  return (navigator.userAgent && (navigator.userAgent.toLowerCase()).indexOf('firefox') != -1) ? true : false; }();
// Updating timer - function that called every interval time (interval)
// IN: NUMBER - interval at ms
// RETURN: NOTHING
NL.Timer._timer_update = function(in_INTERVAL) {
	// FireFox 'setInterval' bugfix:
	if (NL.Timer._is_browser_FF) NL.Timer.timer_off(in_INTERVAL);
	var remove_INTERVAL = 0;
	var remove_FUNCTIONS_IDs = [];
	var remove_STAHES_IDs = [];

	if (typeof in_INTERVAL != 'undefined' && in_INTERVAL > 0 && NL.Timer._OBJ_TIMER && NL.Timer._OBJ_TIMER[in_INTERVAL]) {
		if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'] && NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].length > 0) {
			for (var i in NL.Timer._OBJ_TIMER[in_INTERVAL]['functions']) {
				if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'] && NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'].length > 0) {
					for (var s in NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA']) {
						NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'][s].time += in_INTERVAL;
						if ( !NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['function']( NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'][s].stash, NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'][s].time) ) {
							remove_STAHES_IDs.push(s);
						}
					}
					// Removing STAHES
					if (remove_STAHES_IDs.length > 0) {
						if (NL.Timer.timer_is_on(in_INTERVAL)) NL.Timer.timer_off(in_INTERVAL);
						var rm_addon = 0;
						for (var r in remove_STAHES_IDs) {
							NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'].splice(remove_STAHES_IDs[r] - rm_addon, 1);
							rm_addon++;
						}
						if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'][i]['DATA'].length <= 0) remove_FUNCTIONS_IDs.push(i);
					}

				}
				else remove_FUNCTIONS_IDs.push(i);
			}
			// Removing FUNCTIONS
			if (remove_FUNCTIONS_IDs.length > 0) {
				if (NL.Timer.timer_is_on(in_INTERVAL)) NL.Timer.timer_off(in_INTERVAL);
				var rm_addon = 0;
				for (var f in remove_FUNCTIONS_IDs) {
					NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].splice(remove_FUNCTIONS_IDs[f] - rm_addon, 1);
					rm_addon++;
				}
				if (NL.Timer._OBJ_TIMER[in_INTERVAL]['functions'].length <= 0) remove_INTERVAL = 1;
			}
		}
		else remove_INTERVAL = 1;
		// Removing INTERVAL
		if (remove_INTERVAL) {
			if (NL.Timer.timer_is_on(in_INTERVAL)) NL.Timer.timer_off(in_INTERVAL);
			delete NL.Timer._OBJ_TIMER[in_INTERVAL];
			return;
		}
	}
	// Turnig timer ON if it is OFF
	if (!NL.Timer.timer_is_on(in_INTERVAL)) NL.Timer.timer_on(in_INTERVAL);
};
