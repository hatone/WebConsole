/*
* NL :: Cache - Objects caching
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_DEV
*/
if (typeof NL == "undefined") { alert("NL.Cache: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('Cache'); }

NL.Cache._OBJ_CACHE = { }; // Main CACHE object

// Adding DATA to cache
NL.Cache.add = function(in_ID, in_OBJ) {
	if (in_ID && in_OBJ) {
		NL.Cache._OBJ_CACHE[in_ID] = in_OBJ;
		return true;
	}
	return false;
};
// Getting DATA from cache
NL.Cache.get = function(in_ID) {
	if (in_ID && NL.Cache._OBJ_CACHE[in_ID]) return NL.Cache._OBJ_CACHE[in_ID];
	return null;
};
// Removing DATA from cache
NL.Cache.remove = function(in_ID) {
	if (in_ID && NL.Cache._OBJ_CACHE[in_ID]) {
		delete NL.Cache._OBJ_CACHE[in_ID];
		return true;
	}
	return false;
};
