/*
* WC :: Console :: Clipboard - Virtual clipboard manipulation methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.Clipboard: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.Clipboard'); }

// Internal storage
WC.Console.Clipboard._DATA = { 'CLIPBOARD': '' };
// Setting value at clipboard
WC.Console.Clipboard.set = function(in_VALUE) {
	if (in_VALUE) {
		WC.Console.Clipboard._DATA['CLIPBOARD'] = in_VALUE;
		WC.Console.Clipboard.set_REAL(in_VALUE);
	}
}
// Getting value from clipboard
WC.Console.Clipboard.get = function() { return WC.Console.Clipboard.get_REAL() || WC.Console.Clipboard._DATA['CLIPBOARD']; }
// Setting value at REAL clipboard (for IE)
WC.Console.Clipboard.set_REAL = function(in_VALUE) {
	// Only IE allows to do it
	if (in_VALUE && window.clipboardData) { window.clipboardData.setData("Text", in_VALUE); return true; }
	return false;
};
// Getting value from REAL clipboard (for IE)
WC.Console.Clipboard.get_REAL = function() {
	// Only IE allows to do it
	if (window.clipboardData) return window.clipboardData.getData('Text') || '';
	return '';
};
// Making selection empty
WC.Console.Clipboard.selection_empty = function(in_OBJ) {
	// Not for OPERA
	if (!NL.Browser.Detect.isOPERA) {
		if (in_OBJ) {
			if (in_OBJ.selection) in_OBJ.selection.empty();
			else if (in_OBJ.getSelection) in_OBJ.getSelection().removeAllRanges();
			else if (NL.Browser.Detect.isFF) in_OBJ.setSelectionRange(in_OBJ.selectionStart, in_OBJ.selectionStart);
		}
		else {
			if (document.selection) document.selection.empty();
			else if (window.getSelection) window.getSelection().removeAllRanges();
			else if (document.getSelection) document.getSelection().removeAllRanges();
		}
	}
};
// Getting current selection at WINDOW or DOCUMENT
WC.Console.Clipboard.selection_get = function() {
	var obj_window = window;
	var obj_document = document;

	var text = '', range;
	if (obj_window.getSelection) text = obj_window.getSelection();
	else if (obj_document.getSelection) text = obj_document.getSelection();
	else if (obj_document.selection && obj_document.selection.createRange) {
		range = obj_document.selection.createRange();
		text = range.text;
	}
	else {
		alert('NO');
	}

	text = "" + text; // THAT IS NEEDED FIX (ELSE 'variable = text' WILL WORKS BAD)
	return text;
};
// Getting selection at OBJECT
WC.Console.Clipboard.selection_get_OBJ = function(in_OBJ) {
	var text = '';
	if (in_OBJ) {
		var obj = xGetElementById(in_OBJ);
		if (obj) {
			if (obj.createTextRange) {
				var r = document.selection.createRange().duplicate();
				text = r.text;
			}
			else {
				var i_start = obj.selectionStart;
				var i_end = obj.selectionEnd;
				if (i_end > i_start) text = obj.value.substring(i_start, i_end);
			}
		}
	}
	return text;
};
