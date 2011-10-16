/*
* NL :: Debug - Simple strings manipulations
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof NL == "undefined") { alert("NL.String: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('String'); }

// Making replacing of REGEX'es
// EXAMPLE: var text = NL.String.RE_REPLACE(some_var, [new RegExp('^[\\s\\n\\r]+', 'g'), ''])
NL.String.RE_REPLACE = function(in_value, in_ARR_REPLACE) {
	if (in_value) {
		var len = in_ARR_REPLACE.length;
		if ( len > 0 && (len % 2 == 0) ) {
			for (var i = 0; i < len; i += 2) {
				in_value = in_value.replace(in_ARR_REPLACE[i], in_ARR_REPLACE[i+1]);
			}
		}
		return in_value;
	}
	return '';
};
// StrTrim implementation
NL.String.trim = function(in_value) {
	in_value = ''+in_value;
	in_value = in_value.replace(/^[\s\n\r]+/, '');
	in_value = in_value.replace(/[\s\n\r]+$/, '');
	return in_value;
};
// StrTrim implementation
NL.String.toLINE_escape = function(in_value) {
	in_value = ''+in_value;
	in_value = in_value.replace(/\\/g, '\\\\');
	in_value = in_value.replace(/"/g, '\\"');
	in_value = in_value.replace(/\n/g, '\\n');
	in_value = in_value.replace(/\r/g, '\\r');
	in_value = in_value.replace(/\t/g, '\\t');
	return in_value;
};
// Converting string to HTML analog
NL.String.toHTML = function(in_value, in_FULL) {
	in_value = ''+in_value;
	in_value = in_value.replace(/&/g, '&amp;');
	in_value = in_value.replace(/ /g, '&nbsp;');
	in_value = in_value.replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
	in_value = in_value.replace(/</g, '&lt;');
	in_value = in_value.replace(/>/g, '&gt;');
	if (in_FULL) in_value = in_value.replace(/"/g, '&quot;');
	return in_value;
};
// Converting string from HTML analog
NL.String.fromHTML = function(in_value) {
	in_value = ''+in_value;
	in_value = in_value.replace(/[\xA0]/g, ' '); // Opera FIX
	in_value = in_value.replace(/&nbsp;/g, ' ');
	in_value = in_value.replace(/&lt;/g, '<');
	in_value = in_value.replace(/&gt;/g, '>');
	in_value = in_value.replace(/&quot;/g, "'");
	in_value = in_value.replace(/&amp;/g, '&');
	return in_value;
};
// Converting text to line
NL.String.toLINE = function(in_value) { in_value = ''+in_value; return in_value.replace(/[\n\r]+/, ' '); };
// Getting right part of string
NL.String.get_str_right = function(in_str, in_len, in_add_dottes) {
	var len_needed = in_len;
	if (in_str.length > len_needed) {
		var add_dottes = 0;
		if (in_add_dottes && in_len >= 3) {
			len_needed = in_len - 3;
			add_dottes = 1;
		}
		in_str = (add_dottes ? '...' : '') + in_str.substr(in_str.length - len_needed);
	}
	return in_str;
};
// Getting right part of string and adding dottes to beginig of the string
NL.String.get_str_right_dottes = function(in_str, in_len) { return NL.String.get_str_right(in_str, in_len, 1); };
// Converting number of bytes to the readable value of size
NL.String.get_str_of_bytes = function(in_bytes) {
	var arr_SIZE = ['Kb', 'MB', 'GB'];

	var size = in_bytes;
	var size_i = -1;
	for (var i=0; i < arr_SIZE.length; i++) {
		var new_size = size/1024;
		if (new_size >= 1) { size = new_size; size_i = i; }
		else { break; }
	}

	var size_INTEGER = Math.floor(size);
	var size_MANTISSA = Math.floor( (size - size_INTEGER)*100 );
	var size_result = '' + size_INTEGER + ( (size_MANTISSA > 0) ? ('.' + size_MANTISSA) : '');
	return size_result + ' ' + (size_i >= 0 ? arr_SIZE[size_i] : 'bytes');
};
