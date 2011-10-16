/*
* NL :: Crypt - Cryptographic functions implementation
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof NL == "undefined") { alert("NL.Crypt: Error - object NL is not defiend, maybe 'NL CORE' is not loaded"); }
else { NL.namespace('Crypt', 'Crypt.REDISTR'); }

// Functions from REDISTR
NL.Crypt.base64_encode = function() { return NL.REDISTR_CALL(NL.Crypt.REDISTR.Base64, 'Base64.encode', arguments); };
NL.Crypt.base64_decode = function() { return NL.REDISTR_CALL(NL.Crypt.REDISTR.Base64, 'Base64.decode', arguments); };
NL.Crypt.sha1_vm_test = function() { return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1, 'sha1_vm_test', arguments); };
NL.Crypt.sha1 = NL.Crypt.sha1_hex = function() { return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1, 'hex_sha1', arguments); };
NL.Crypt.sha1_b64 = function() { return NL.REDISTR_CALL(NL.Crypt.REDISTR.SHA1, 'b64_sha1', arguments); };
// Generation of random text
NL.Crypt.get_random_text = function() {
	var str_rand = (navigator.userAgent) ? navigator.userAgent : '';
	str_rand += ('mr1:' + Math.random() || 0) + ('mr2:' + Math.random() || 0) + ('mr3:' + Math.random() || 0);
	str_rand += 'sw:' + screen.width || 0;
	str_rand += 'sh:' + screen.height || 0;
	str_rand += 'cw:' + NL.REDISTR_call(NL.Crypt.REDISTR.X, 'xClientHeight', arguments) || 0;
	str_rand += 'ch:' + NL.REDISTR_call(NL.Crypt.REDISTR.X, 'xClientWidth', arguments) || 0;
	var date_now = new Date();
	str_rand += 't_ms:' + date_now.getTime() || 0;
	str_rand += 'tz_ms:' + date_now.getTimezoneOffset() || 0;
	return str_rand;
};
NL.Crypt.get_random_sha1 = NL.Crypt.get_random_sha1_hex = function() { return NL.Crypt.sha1_hex(NL.Crypt.get_random_text()); };

/** ------- **/
/** REDISTR **/
NL.Crypt.REDISTR.X = function() {
	// xDef r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
	// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL
	function xDef()
	{
	  for(var i=0; i<arguments.length; ++i){if(typeof(arguments[i])=='undefined') return false;}
	  return true;
	}
	// xClientHeight r5, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
	// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL
	function xClientHeight()
	{
	  var v=0,d=document,w=window;
	  if((!d.compatMode || d.compatMode == 'CSS1Compat') && !w.opera && d.documentElement && d.documentElement.clientHeight)
	    {v=d.documentElement.clientHeight;}
	  else if(d.body && d.body.clientHeight)
	    {v=d.body.clientHeight;}
	  else if(xDef(w.innerWidth,w.innerHeight,d.width)) {
	    v=w.innerHeight;
	    if(d.width>w.innerWidth) v-=16;
	  }
	  return v;
	}
	// xClientWidth r5, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
	// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL
	function xClientWidth()
	{
	  var v=0,d=document,w=window;
	  if((!d.compatMode || d.compatMode == 'CSS1Compat') && !w.opera && d.documentElement && d.documentElement.clientWidth)
	    {v=d.documentElement.clientWidth;}
	  else if(d.body && d.body.clientWidth)
	    {v=d.body.clientWidth;}
	  else if(xDef(w.innerWidth,w.innerHeight,d.height)) {
	    v=w.innerWidth;
	    if(d.height>w.innerHeight) v-=16;
	  }
	  return v;
	}

	//*** NL: EXECUTION OF REDISTR FUNCTION ***/
	if (arguments.length == 2 && arguments[0] != '' && arguments[1]) {
		var NL_TMP_FUNC = null;
		try { eval('NL_TMP_FUNC='+arguments[0]+';'); } catch (e) { NL_TMP_FUNC = null; }
		if (NL_TMP_FUNC) return [1, NL_TMP_FUNC.apply(this, arguments[1])];
	}
	return [0, null];
	//*** / NL: EXECUTION OF REDISTR FUNCTION ***/
};
NL.Crypt.REDISTR.SHA1 = function() {
	/*
	 * A JavaScript implementation of the Secure Hash Algorithm, SHA-1, as defined
	 * in FIPS 180-1
	 * Version 2.2-alpha Copyright Paul Johnston 2000 - 2002.
	 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
	 * Distributed under the BSD License
	 * See http://pajhome.org.uk/crypt/md5 for details.
	 */

	/*
	 * Configurable variables. You may need to tweak these to be compatible with
	 * the server-side, but the defaults work in most cases.
	 */
	var hexcase = 0;  /* hex output format. 0 - lowercase; 1 - uppercase        */
	var b64pad  = ""; /* base-64 pad character. "=" for strict RFC compliance   */

	/*
	 * These are the functions you'll usually want to call
	 * They take string arguments and return either hex or base-64 encoded strings
	 */
	function hex_sha1(s)    { return rstr2hex(rstr_sha1(str2rstr_utf8(s))); }
	function b64_sha1(s)    { return rstr2b64(rstr_sha1(str2rstr_utf8(s))); }
	function any_sha1(s, e) { return rstr2any(rstr_sha1(str2rstr_utf8(s)), e); }
	function hex_hmac_sha1(k, d)
	  { return rstr2hex(rstr_hmac_sha1(str2rstr_utf8(k), str2rstr_utf8(d))); }
	function b64_hmac_sha1(k, d)
	  { return rstr2b64(rstr_hmac_sha1(str2rstr_utf8(k), str2rstr_utf8(d))); }
	function any_hmac_sha1(k, d, e)
	  { return rstr2any(rstr_hmac_sha1(str2rstr_utf8(k), str2rstr_utf8(d)), e); }

	/*
	 * Perform a simple self-test to see if the VM is working
	 */
	function sha1_vm_test()
	{
	  return hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d";
	}

	/*
	 * Calculate the SHA1 of a raw string
	 */
	function rstr_sha1(s)
	{
	  return binb2rstr(binb_sha1(rstr2binb(s), s.length * 8));
	}

	/*
	 * Calculate the HMAC-SHA1 of a key and some data (raw strings)
	 */
	function rstr_hmac_sha1(key, data)
	{
	  var bkey = rstr2binb(key);
	  if(bkey.length > 16) bkey = binb_sha1(bkey, key.length * 8);

	  var ipad = Array(16), opad = Array(16);
	  for(var i = 0; i < 16; i++)
	  {
	    ipad[i] = bkey[i] ^ 0x36363636;
	    opad[i] = bkey[i] ^ 0x5C5C5C5C;
	  }

	  var hash = binb_sha1(ipad.concat(rstr2binb(data)), 512 + data.length * 8);
	  return binb2rstr(binb_sha1(opad.concat(hash), 512 + 160));
	}

	/*
	 * Convert a raw string to a hex string
	 */
	function rstr2hex(input)
	{
	  var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
	  var output = "";
	  var x;
	  for(var i = 0; i < input.length; i++)
	  {
	    x = input.charCodeAt(i);
	    output += hex_tab.charAt((x >>> 4) & 0x0F)
		   +  hex_tab.charAt( x        & 0x0F);
	  }
	  return output;
	}

	/*
	 * Convert a raw string to a base-64 string
	 */
	function rstr2b64(input)
	{
	  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	  var output = "";
	  var len = input.length;
	  for(var i = 0; i < len; i += 3)
	  {
	    var triplet = (input.charCodeAt(i) << 16)
			| (i + 1 < len ? input.charCodeAt(i+1) << 8 : 0)
			| (i + 2 < len ? input.charCodeAt(i+2)      : 0);
	    for(var j = 0; j < 4; j++)
	    {
	      if(i * 8 + j * 6 > input.length * 8) output += b64pad;
	      else output += tab.charAt((triplet >>> 6*(3-j)) & 0x3F);
	    }
	  }
	  return output;
	}

	/*
	 * Convert a raw string to an arbitrary string encoding
	 */
	function rstr2any(input, encoding)
	{
	  var divisor = encoding.length;
	  var remainders = Array();
	  var i, q, x, quotient;

	  /* Convert to an array of 16-bit big-endian values, forming the dividend */
	  var dividend = Array(Math.ceil(input.length / 2));
	  for(i = 0; i < dividend.length; i++)
	  {
	    dividend[i] = (input.charCodeAt(i * 2) << 8) | input.charCodeAt(i * 2 + 1);
	  }

	  /*
	   * Repeatedly perform a long division. The binary array forms the dividend,
	   * the length of the encoding is the divisor. Once computed, the quotient
	   * forms the dividend for the next step. We stop when the dividend is zero.
	   * All remainders are stored for later use.
	   */
	  while(dividend.length > 0)
	  {
	    quotient = Array();
	    x = 0;
	    for(i = 0; i < dividend.length; i++)
	    {
	      x = (x << 16) + dividend[i];
	      q = Math.floor(x / divisor);
	      x -= q * divisor;
	      if(quotient.length > 0 || q > 0)
		quotient[quotient.length] = q;
	    }
	    remainders[remainders.length] = x;
	    dividend = quotient;
	  }

	  /* Convert the remainders to the output string */
	  var output = "";
	  for(i = remainders.length - 1; i >= 0; i--)
	    output += encoding.charAt(remainders[i]);

	  /* Append leading zero equivalents */
	  var full_length = Math.ceil(input.length * 8 /
					    (Math.log(encoding.length) / Math.log(2)))
	  for(i = output.length; i < full_length; i++)
	    output = encoding[0] + output;

	  return output;
	}

	/*
	 * Encode a string as utf-8.
	 * For efficiency, this assumes the input is valid utf-16.
	 */
	function str2rstr_utf8(input)
	{
	  var output = "";
	  var i = -1;
	  var x, y;

	  while(++i < input.length)
	  {
	    /* Decode utf-16 surrogate pairs */
	    x = input.charCodeAt(i);
	    y = i + 1 < input.length ? input.charCodeAt(i + 1) : 0;
	    if(0xD800 <= x && x <= 0xDBFF && 0xDC00 <= y && y <= 0xDFFF)
	    {
	      x = 0x10000 + ((x & 0x03FF) << 10) + (y & 0x03FF);
	      i++;
	    }

	    /* Encode output as utf-8 */
	    if(x <= 0x7F)
	      output += String.fromCharCode(x);
	    else if(x <= 0x7FF)
	      output += String.fromCharCode(0xC0 | ((x >>> 6 ) & 0x1F),
					    0x80 | ( x         & 0x3F));
	    else if(x <= 0xFFFF)
	      output += String.fromCharCode(0xE0 | ((x >>> 12) & 0x0F),
					    0x80 | ((x >>> 6 ) & 0x3F),
					    0x80 | ( x         & 0x3F));
	    else if(x <= 0x1FFFFF)
	      output += String.fromCharCode(0xF0 | ((x >>> 18) & 0x07),
					    0x80 | ((x >>> 12) & 0x3F),
					    0x80 | ((x >>> 6 ) & 0x3F),
					    0x80 | ( x         & 0x3F));
	  }
	  return output;
	}

	/*
	 * Encode a string as utf-16
	 */
	function str2rstr_utf16le(input)
	{
	  var output = "";
	  for(var i = 0; i < input.length; i++)
	    output += String.fromCharCode( input.charCodeAt(i)        & 0xFF,
					  (input.charCodeAt(i) >>> 8) & 0xFF);
	  return output;
	}

	function str2rstr_utf16be(input)
	{
	  var output = "";
	  for(var i = 0; i < input.length; i++)
	    output += String.fromCharCode((input.charCodeAt(i) >>> 8) & 0xFF,
					   input.charCodeAt(i)        & 0xFF);
	  return output;
	}

	/*
	 * Convert a raw string to an array of big-endian words
	 * Characters >255 have their high-byte silently ignored.
	 */
	function rstr2binb(input)
	{
	  var output = Array(input.length >> 2);
	  for(var i = 0; i < output.length; i++)
	    output[i] = 0;
	  for(var i = 0; i < input.length * 8; i += 8)
	    output[i>>5] |= (input.charCodeAt(i / 8) & 0xFF) << (24 - i % 32);
	  return output;
	}

	/*
	 * Convert an array of little-endian words to a string
	 */
	function binb2rstr(input)
	{
	  var output = "";
	  for(var i = 0; i < input.length * 32; i += 8)
	    output += String.fromCharCode((input[i>>5] >>> (24 - i % 32)) & 0xFF);
	  return output;
	}

	/*
	 * Calculate the SHA-1 of an array of big-endian words, and a bit length
	 */
	function binb_sha1(x, len)
	{
	  /* append padding */
	  x[len >> 5] |= 0x80 << (24 - len % 32);
	  x[((len + 64 >> 9) << 4) + 15] = len;

	  var w = Array(80);
	  var a =  1732584193;
	  var b = -271733879;
	  var c = -1732584194;
	  var d =  271733878;
	  var e = -1009589776;

	  for(var i = 0; i < x.length; i += 16)
	  {
	    var olda = a;
	    var oldb = b;
	    var oldc = c;
	    var oldd = d;
	    var olde = e;

	    for(var j = 0; j < 80; j++)
	    {
	      if(j < 16) w[j] = x[i + j];
	      else w[j] = bit_rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
	      var t = safe_add(safe_add(bit_rol(a, 5), sha1_ft(j, b, c, d)),
			       safe_add(safe_add(e, w[j]), sha1_kt(j)));
	      e = d;
	      d = c;
	      c = bit_rol(b, 30);
	      b = a;
	      a = t;
	    }

	    a = safe_add(a, olda);
	    b = safe_add(b, oldb);
	    c = safe_add(c, oldc);
	    d = safe_add(d, oldd);
	    e = safe_add(e, olde);
	  }
	  return Array(a, b, c, d, e);

	}

	/*
	 * Perform the appropriate triplet combination function for the current
	 * iteration
	 */
	function sha1_ft(t, b, c, d)
	{
	  if(t < 20) return (b & c) | ((~b) & d);
	  if(t < 40) return b ^ c ^ d;
	  if(t < 60) return (b & c) | (b & d) | (c & d);
	  return b ^ c ^ d;
	}

	/*
	 * Determine the appropriate additive constant for the current iteration
	 */
	function sha1_kt(t)
	{
	  return (t < 20) ?  1518500249 : (t < 40) ?  1859775393 :
		 (t < 60) ? -1894007588 : -899497514;
	}

	/*
	 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
	 * to work around bugs in some JS interpreters.
	 */
	function safe_add(x, y)
	{
	  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
	  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
	  return (msw << 16) | (lsw & 0xFFFF);
	}

	/*
	 * Bitwise rotate a 32-bit number to the left.
	 */
	function bit_rol(num, cnt)
	{
	  return (num << cnt) | (num >>> (32 - cnt));
	}

	//*** NL: EXECUTION OF REDISTR FUNCTION ***/
	if (arguments.length == 2 && arguments[0] != '' && arguments[1]) {
		var NL_TMP_FUNC = null;
		try { eval('NL_TMP_FUNC='+arguments[0]+';'); } catch (e) { NL_TMP_FUNC = null; }
		if (NL_TMP_FUNC) return [1, NL_TMP_FUNC.apply(this, arguments[1])];
	}
	return [0, null];
	//*** / NL: EXECUTION OF REDISTR FUNCTION ***/
};
NL.Crypt.REDISTR.Base64  = function() {
	// Base64 encode/decode (http://www.webtoolkit.info)
	var Base64 = {
	    // private property
	    _keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

	    // public method for encoding
	    encode : function (input) {
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;

		input = Base64._utf8_encode(input);

		while (i < input.length) {

		    chr1 = input.charCodeAt(i++);
		    chr2 = input.charCodeAt(i++);
		    chr3 = input.charCodeAt(i++);

		    enc1 = chr1 >> 2;
		    enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
		    enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
		    enc4 = chr3 & 63;

		    if (isNaN(chr2)) {
			enc3 = enc4 = 64;
		    } else if (isNaN(chr3)) {
			enc4 = 64;
		    }

		    output = output +
		    Base64._keyStr.charAt(enc1) + Base64._keyStr.charAt(enc2) +
		    Base64._keyStr.charAt(enc3) + Base64._keyStr.charAt(enc4);

		}

		return output;
	    },

	    // public method for decoding
	    decode : function (input) {
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;

		input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

		while (i < input.length) {

		    enc1 = Base64._keyStr.indexOf(input.charAt(i++));
		    enc2 = Base64._keyStr.indexOf(input.charAt(i++));
		    enc3 = Base64._keyStr.indexOf(input.charAt(i++));
		    enc4 = Base64._keyStr.indexOf(input.charAt(i++));

		    chr1 = (enc1 << 2) | (enc2 >> 4);
		    chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
		    chr3 = ((enc3 & 3) << 6) | enc4;

		    output = output + String.fromCharCode(chr1);

		    if (enc3 != 64) {
			output = output + String.fromCharCode(chr2);
		    }
		    if (enc4 != 64) {
			output = output + String.fromCharCode(chr3);
		    }

		}

		output = Base64._utf8_decode(output);

		return output;

	    },

	    // private method for UTF-8 encoding
	    _utf8_encode : function (string) {
		string = string.replace(/\r\n/g,"\n");
		var utftext = "";

		for (var n = 0; n < string.length; n++) {

		    var c = string.charCodeAt(n);

		    if (c < 128) {
			utftext += String.fromCharCode(c);
		    }
		    else if((c > 127) && (c < 2048)) {
			utftext += String.fromCharCode((c >> 6) | 192);
			utftext += String.fromCharCode((c & 63) | 128);
		    }
		    else {
			utftext += String.fromCharCode((c >> 12) | 224);
			utftext += String.fromCharCode(((c >> 6) & 63) | 128);
			utftext += String.fromCharCode((c & 63) | 128);
		    }

		}

		return utftext;
	    },

	    // private method for UTF-8 decoding
	    _utf8_decode : function (utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;

		while ( i < utftext.length ) {

		    c = utftext.charCodeAt(i);

		    if (c < 128) {
			string += String.fromCharCode(c);
			i++;
		    }
		    else if((c > 191) && (c < 224)) {
			c2 = utftext.charCodeAt(i+1);
			string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
			i += 2;
		    }
		    else {
			c2 = utftext.charCodeAt(i+1);
			c3 = utftext.charCodeAt(i+2);
			string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
			i += 3;
		    }

		}

		return string;
	    }

	};

	//*** NL: EXECUTION OF REDISTR FUNCTION ***/
	if (arguments.length == 2 && arguments[0] != '' && arguments[1]) {
		var NL_TMP_FUNC = null;
		try { eval('NL_TMP_FUNC='+arguments[0]+';'); } catch (e) { NL_TMP_FUNC = null; }
		if (NL_TMP_FUNC) return [1, NL_TMP_FUNC.apply(this, arguments[1])];
	}
	return [0, null];
	//*** / NL: EXECUTION OF REDISTR FUNCTION ***/
};
