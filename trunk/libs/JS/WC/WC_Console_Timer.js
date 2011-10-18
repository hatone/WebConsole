/*
* WC :: Console :: Timer - Timer manipulation methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.Console.Timer: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('Console.Timer'); }

// Timer EVENT (called by timers) : update time
WC.Console.Timer.ON_TIMER = function(in_STASH, in_TIME) {
	if (in_STASH && in_STASH['id']) {
		var obj = xGetElementById(in_STASH['id']);
		if (obj) {
			// Timer element exists
			obj.innerHTML = NL.Timer.get_str_time(in_TIME);
			return 1;
		}
	}
	// No that timer element exists (timer for that element will be killed automatically)
	return 0;
};
