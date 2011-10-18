/*
* NL :: Debug - Simple JS debugging
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof NL == "undefined") { alert("NL.Debug: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('Debug'); }

// Buffer to store some data
NL.Debug._DATA = { 'BUFFER': [] };
// Getting DUMP of variable
NL.Debug.dump = function(in_obj, in_level) {
	var dumped_text = '';
	if(!in_level) in_level = 0;

	var level_padding = '';
	for(var j = 0; j < in_level+1; j++) level_padding += '    ';
	if(typeof(in_obj) == 'object') { // Arrays / Hashes / Objects
		for(var item in in_obj) {
			var value = in_obj[item];
			if(typeof(value) == 'object') { // If it is an object
				dumped_text += level_padding + "'" + item + "' => ";
				var dumped_text_new = ''; // dump(value, in_level + 1);
				if (!dumped_text_new) dumped_text += "[object]\n";
				else dumped_text += "\n" + dumped_text_new;
			}
			else {
				dumped_text += level_padding + "'" + item + "' => \"" + value + "\"\n";
			}
		}
	}
	else {
		dumped_text = "=>" + in_obj + "<= (" + typeof(in_obj) + ")";
	}
	return "DUMP:\n---\n" + dumped_text + "---";
};
// Getting DUMP of variable and showing 'alert' with it
NL.Debug.dump_alert = function(in_obj) { alert( NL.Debug.dump(in_obj) ); };
// Making buffer empty
NL.Debug.buffer_reset = function(in_value) { NL.Debug._DATA['BUFFER'] = []; };
// Adding data to buffer
NL.Debug.buffer_add = function(in_value) { NL.Debug._DATA['BUFFER'].push(in_value); };
// Getting data from buffer
NL.Debug.buffer_get = function() {
	var result = '';
	for(var i in NL.Debug._DATA['BUFFER']) {
		if (result != '') { result += "\n"; }
		result += NL.Debug._DATA['BUFFER'][i];
	}
	return result;
};
// Getting data from buffer and showing 'alert' with it
NL.Debug.buffer_alert = function() { alert( NL.Debug.buffer_get() ); };
