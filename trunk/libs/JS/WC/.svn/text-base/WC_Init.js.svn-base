/*
* Web Console JS :: For 'MAIN PAGE' (CONSOLE)
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_DEV
*/
// Adding 'onLoad' event
xAddEventListener(window, 'load', WC_ONLOAD_EVENT, false);
// 'ONLOAD' event processing
function WC_ONLOAD_EVENT() {
	// Initalizing Web Console and starting it
	WC.Console.init_and_start('input-query', 'area-output', 'area-command-prefix');
	// Opera TAB FIX (when we press TAB Opera will scroll to the next INPUT):
	if (NL.Browser.Detect.isOPERA) {
		var obj_grid = xGetElementById('area-bottom-tr');
		if (obj_grid) {
			var obj_td  = document.createElement('td');
			var obj_input = document.createElement('input');
			// Adding attributes to TD
			obj_input.setAttribute("id", "input-opera-TAB-FIX");
			obj_input.setAttribute("name", "_input-opera-TAB-FIX");
			obj_input.setAttribute("type", "text");
			obj_input.setAttribute("style", "width: 0; height: 0; border: 0;");
			obj_input.setAttribute("autocomplete", "off");
			obj_input.setAttribute("onfocus", "WC.Console.Prompt.activate()");
			// Appending
			obj_td.appendChild(obj_input);
			obj_grid.appendChild(obj_td);
		}
	}
	// Testing 'FLOATING-BAR'
	// NL.UI2.floating_bar_register('block-FLOATING-BAR', '_block-FLOATING-BAR');
}
