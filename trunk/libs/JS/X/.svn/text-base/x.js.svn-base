/* Compiled from X 4.17 by XC 1.06 on 29Aug07 */
// xAnimation r3, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAnimation(r)
{
  this.res = r||10;
}
xAnimation.prototype.init = function(e,t,or,ot,oe,a,b)
{
  var i = this;
  i.e = xGetElementById(e);
  i.t = t;
  i.or=or; i.ot=ot; i.oe=oe;
  i.a = a||0;
  i.v = xAnimation.vf[i.a];
  i.qc = 1 + (b||0);
  i.fq = 1/i.t;
  if (i.a) {
    i.fq *= i.qc * Math.PI;
    if (i.a == 1 || i.a == 2) { i.fq /= 2; }
  }
  else { i.qc = 1; }
  i.xd=i.x2-i.x1; i.yd=i.y2-i.y1; i.zd=i.z2-i.z1;
};
xAnimation.prototype.run = function(r)
{
  var i = this;
  if (!r) i.t1 = new Date().getTime();
  if (!i.tmr) i.tmr = setInterval(
    function() {
      i.et = new Date().getTime() - i.t1;
      if (i.et < i.t) {
        i.f = i.v(i.et*i.fq);
        i.x=i.xd*i.f+i.x1; i.y=i.yd*i.f+i.y1; i.z=i.zd*i.f+i.z1;
        i.or(i);
      }
      else {
        clearInterval(i.tmr); i.tmr = null;
        if (i.qc%2) {i.x=i.x2; i.y=i.y2; i.z=i.z2;}
        else {i.x=i.x1; i.y=i.y1; i.z=i.z1;}
        i.ot(i);
        var rep = false;
        if (typeof i.oe == 'function') rep = i.oe(i);
        else if (typeof i.oe == 'string') rep = eval(i.oe);
        if (rep) i.resume(1);
      }
    }, i.res
  );
};
xAnimation.vf = [
  function(r){return r;},
  function(r){return Math.abs(Math.sin(r));},
  function(r){return 1-Math.abs(Math.cos(r));},
  function(r){return (1-Math.cos(r))/2;}
];
xAnimation.prototype.pause = function()
{
  clearInterval(this.tmr);
  this.tmr = null;
};
xAnimation.prototype.resume = function(fs)
{
  if (typeof this.tmr != 'undefined' && !this.tmr) {
    this.t1 = new Date().getTime();
    if (!fs) {this.t1 -= this.et;}
    this.run(!fs);
  }
};
// xBar r1, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

// Bar-Graph Object

function xBar(dir,                // direction, 'ltr', 'rtl', 'ttb', or 'btt'
              conStyle, barStyle) // container and bar style class names
{
  //// Public Properties

  this.value = 0; // current value, read-only

  //// Public Methods

  // Update current value
  this.update = function(v)
  {
    if (v < 0) v = 0;
    else if (v > this.inMax) v = this.inMax;
    this.con.title = this.bar.title = this.value = v;
    switch(this.dir) {
      case 'ltr': // left to right
      v = this.scale(v, this.w);
      xLeft(this.bar, v - this.w);
      break;
      case 'rtl': // right to left
      v = this.scale(v, this.w);
      xLeft(this.bar, this.w - v);
      break;
      case 'btt': // bottom to top
      v = this.scale(v, this.h);
      xTop(this.bar, this.h - v);
      break;
      case 'ttb': // top to bottom
      v = this.scale(v, this.h);
      xTop(this.bar, v - this.h);
      break;
    }
  };

  // Change position and/or size
  this.paint = function(x, y, // container position
                        w, h) // container size
  {
    if (xNum(x)) this.x = x;
    if (xNum(y)) this.y = y;
    if (xNum(w)) this.w = w;
    if (xNum(h)) this.h = h;
    xResizeTo(this.con, this.w, this.h);
    xMoveTo(this.con, this.x, this.y);
    xResizeTo(this.bar, this.w, this.h);
    xMoveTo(this.bar, 0, 0);
  };

  // Change scale and/or start value
  this.reset = function(max, start) // non-scaled values
  {
    if (xNum(max)) this.inMax = max;
    if (xNum(start)) this.start = start;
    this.update(this.start);
  };

  //// Private Methods
  
  this.scale = function(v, outMax)
  {
    return Math.round(xLinearScale(v, 0, this.inMax, 0, outMax));
  };

  //// Private Properties

  this.dir = dir;
  this.x = 0;
  this.y = 0;
  this.w = 100;
  this.h = 100;
  this.inMax = 100;
  this.start = 0;
  this.conStyle = conStyle;
  this.barStyle = barStyle;

  //// Constructor

  // Create container
  this.con = document.createElement('DIV');
  this.con.className = this.conStyle;
  // Create bar
  this.bar = document.createElement('DIV');
  this.bar.className = this.barStyle;
  // Insert in object tree
  this.con.appendChild(this.bar);
  document.body.appendChild(this.con);

} // end xBar
// xCollapsible r3, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xCollapsible(outerEle, bShow) // object prototype
{
  // Constructor

  var container = xGetElementById(outerEle);
  if (!container) {return null;}
  var isUL = container.nodeName.toUpperCase() == 'UL';
  var i, trg, aTgt = xGetElementsByTagName(isUL ? 'UL':'DIV', container);
  for (i = 0; i < aTgt.length; ++i) {
    trg = xPrevSib(aTgt[i]);
    if (trg && (isUL || trg.nodeName.charAt(0).toUpperCase() == 'H')) {
      aTgt[i].xTrgPtr = trg;
      aTgt[i].style.display = bShow ? 'block' : 'none';
      trg.style.cursor = 'pointer';
      trg.xTgtPtr = aTgt[i];
      trg.onclick = trg_onClick;
    }  
  }
  
  // Private

  function trg_onClick()
  {
    var tgt = this.xTgtPtr.style;
    tgt.display = (tgt.display == 'none') ? "block" : "none";
  }

  // Public

  this.displayAll = function(bShow)
  {
    for (var i = 0; i < aTgt.length; ++i) {
      if (aTgt[i].xTrgPtr) {
        aTgt[i].style.display = bShow ? "block" : "none";
      }
    }
  };

  // The unload listener is for IE's circular reference memory leak bug.
  this.onUnload = function()
  {
    if (!container || !aTgt) {return;}
    for (i = 0; i < aTgt.length; ++i) {
      trg = aTgt[i].xTrgPtr;
      if (trg) {
        if (trg.xTgtPtr) {
          trg.xTgtPtr.TrgPtr = null;
          trg.xTgtPtr = null;
        }
        trg.onclick = null;
      }
    }
  };
}


// xDialog r2, Adapted from xPopup by Aaron Throckmorton
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xDialog(sPos1, sPos2, sPos3, sStyle, sId, sUrl, bHidden)
{
  if (document.getElementById && document.createElement &&
    document.body && document.body.appendChild) {
    // create popup element
    //var e = document.createElement('DIV');
    var e = document.createElement('IFRAME');
    this.ele = e;
    e.id = sId;
    e.name = sId;
    e.style.position = 'absolute';
    e.style.zIndex = '1000';
    e.className = sStyle;
    //e.innerHTML = sHtml;
    e.src = sUrl;
    document.body.appendChild(e);
    e.style.visibility = 'visible';
    this.open = false;
    this.margin = 10;
    this.pos1 = sPos1;
    this.pos2 = sPos2;
    this.pos3 = sPos3;
    this.slideTime = 400; // slide time in ms
    if (bHidden) xGetElementById(sId).style.visibility = 'hidden';
    else this.show();
  }
} // end xDialog

// methods
xDialog.prototype.show = function() {
  if (!this.open) {
    var e = this.ele;
    var pos = xCardinalPosition(e, this.pos1, this.margin, true);
    xMoveTo(e, pos.x, pos.y);
    e.style.visibility = 'visible';
    pos = xCardinalPosition(e, this.pos2, this.margin, false);
    xSlideTo(e, pos.x, pos.y, this.slideTime);
    this.open = true;
  }
};

xDialog.prototype.hide = function() {
  if (this.open) {
    var e = this.ele;
    var pos = xCardinalPosition(e, this.pos3, this.margin, true);
    xSlideTo(e, pos.x, pos.y, this.slideTime);
    setTimeout("xGetElementById('" + e.id + "').style.visibility = 'hidden'", this.slideTime);
    //setTimeout("xMoveTo('" + e.id + "', 1 , 1)", this.slideTime);
    this.open = false;
  }
};

/*
xDialog.prototype.destroy = function(sobj) {
  this.hide();
  //setTimeout("document.body.removeChild(getElementById('" + sobj + "'))", this.slideTime);
  setTimeout(sobj + " = ''", this.slideTime);
  //document.body.removeChild(this.ele);
  //delete this ;
};*/

xDialog.prototype.setUrl = function(sUrl) {
  this.ele.src = sUrl;
};

xDialog.prototype.resize = function(w, h) {
  xResizeTo(this.ele, w, h);
  if (this.open) {
    var pos = xCardinalPosition(this.ele, this.pos2, this.margin, true);
    xSlideTo(this.ele, pos.x, pos.y, this.slideTime);
  }
};
// xEvent r11, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xEvent(evt) // object prototype
{
  var e = evt || window.event;
  if (!e) return;
  this.type = e.type;
  this.target = e.target || e.srcElement;
  this.relatedTarget = e.relatedTarget;
  /*@cc_on if (e.type == 'mouseover') this.relatedTarget = e.fromElement;
  else if (e.type == 'mouseout') this.relatedTarget = e.toElement; @*/
  if (xDef(e.pageX)) { this.pageX = e.pageX; this.pageY = e.pageY; }
  else if (xDef(e.clientX)) { this.pageX = e.clientX + xScrollLeft(); this.pageY = e.clientY + xScrollTop(); }
  if (xDef(e.offsetX)) { this.offsetX = e.offsetX; this.offsetY = e.offsetY; }
  else if (xDef(e.layerX)) { this.offsetX = e.layerX; this.offsetY = e.layerY; }
  else { this.offsetX = this.pageX - xPageX(this.target); this.offsetY = this.pageY - xPageY(this.target); }
  this.keyCode = e.keyCode || e.which || 0;
  this.shiftKey = e.shiftKey; this.ctrlKey = e.ctrlKey; this.altKey = e.altKey;
  if (typeof e.type == 'string') {
    if (e.type.indexOf('click') != -1) {this.button = 0;}
    else if (e.type.indexOf('mouse') != -1) {
      this.button = e.button;
      /*@cc_on if (e.button & 1) this.button = 0;
      else if (e.button & 4) this.button = 1;
      else if (e.button & 2) this.button = 2; @*/
    }
  }
}
// xFenster r15, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xFenster(clientId, iniTitle, iniUrl, iniX, iniY, iniW, iniH, enMove, enResize, enMaxRes, enClose, fnMove, fnResize, fnMaxRes, fnClose, fnFocus)
{
  var me = this;

  // perhaps should be parameters, must correspond with css, M = conPadding, B = conBorder
  var M = 1, B = 1;
  var M2 = 2*M, B2 = 2*B;

  // Public Methods

  me.paint = function(dw, dh)
  {
    me.conW += dw;
    me.conH += dh;
    xResizeTo(me.con, me.conW, me.conH);
    /*@cc_on
    @if (@_jscript_version <= 5.7)
      xMoveTo(me.tbar, M, M);
      xWidth(me.tbar, me.conW - M2 - B2);
      xLeft(me.sbar, M);
      xWidth(me.sbar, me.conW - M2 - B2);
      xTop(me.sbar, me.conH - xHeight(me.sbar) - M - B2);
    @end @*/
    xMoveTo(me.client, M, M + me.tbar.offsetHeight);
    xResizeTo(me.client, me.conW - M2 - B2, me.conH - me.tbar.offsetHeight - me.sbar.offsetHeight - M2 - B2);
  };
  me.focus = function(e) // don't use 'this' here
  {
    if (!fnFocus || fnFocus(me)) {
      me.con.style.zIndex = xFenster.nextZ++;
      if (xFenster.focused) {
        xFenster.focused.tbar.className = 'xfTBar';
        xFenster.focused.sbar.className = 'xfSBar';
      }
      me.tbar.className = 'xfTBarF';
      me.sbar.className = 'xfSBarF';
      xFenster.focused = me;
    }
  };
  me.href = function(s)
  {
    var h = '';
    if (isIFrame) {
      if (me.client.contentWindow) {
        if (s) {me.client.contentWindow.location = s;}
        h = me.client.contentWindow.location.href;
      }
      // this needs more testing now that Safari/Win is available
      else if (typeof me.client.src == 'string') { // for Apollo when iframe exists in html
        if (s) {me.client.src = s;}
        h = me.client.src;
      }
    }
    return h;
  };
  me.hide = function(e) // don't use 'this' here
  {
    var i, o = xFenster.instances, z = 0, hz = 0, f = null;
    if (!fnClose || fnClose(me)) {
      me.con.style.display = 'none';
      xStopPropagation(e);
      if (me == xFenster.focused) {
        for (i in o) {
          if (o.hasOwnProperty(i) && o[i].con.style.display != 'none' && o[i] != me) {
            z = parseInt(o[i].con.style.zIndex);
            if (z > hz) {
              hz = z;
              f = o[i];
            }
          }
        }
        if (f) {f.focus();}
      }
    }
  };
  me.show = function()
  {
    me.con.style.display = 'block';
    me.focus();
  };
  me.status = function(s)
  {
    if (s) {me.sbar.firstChild.data = s;}
    return me.sbar.firstChild.data;
  };
  me.title = function(s)
  {
    if (s) {me.tbar.firstChild.data = s;}
    return me.tbar.firstChild.data;
  };

  // Private Event Listeners

  function dragStart()
  {
    var i, o = xFenster.instances;
    if (isIFrame) {
      for (i in o) {
        if (o.hasOwnProperty(i)) {
          o[i].client.style.visibility = 'hidden';
        }
      }
    }
    else { me.focus(); }
  }
  function dragEnd()
  {
    var i, o = xFenster.instances;
    if (isIFrame) {
      for (i in o) {
        if (o.hasOwnProperty(i)) {
          o[i].client.style.visibility = 'visible';
        }
      }
    }
  }
  function barDrag(e, mdx, mdy)
  {
    var x = xLeft(me.con) + mdx;
    var y = xTop(me.con) + mdy;
    if (!fnMove || fnMove(me, x, y)) {
      xMoveTo(me.con, x, y);
    }
  }
  function resDrag(e, mdx, mdy)
  {
    if (!fnResize || fnResize(me, me.client.offsetWidth + mdx, me.client.offsetHeight + mdy)) { 
      me.paint(mdx, mdy);
    }
  }
  function maxClick()
  {
    var w, h;
    if (me.maximized) {
      w = rW;
      h = rH;
    }
    else {
      w = xClientWidth() - 2;
      h = xClientHeight() - 2;
    }
    if (!fnMaxRes || fnMaxRes(me, w - M2 - B2, h - me.tbar.offsetHeight - me.sbar.offsetHeight - M2 - B2)) {
      if (me.maximized) { // restore
        xMoveTo(me.con, rX, rY);
      }
      else { // maximize
        rW = me.con.offsetWidth;
        rH = me.con.offsetHeight;
        rX = me.con.offsetLeft;
        rY = me.con.offsetTop;
        xMoveTo(me.con, xScrollLeft(), xScrollTop());
      }
      me.maximized = !me.maximized;
      me.conW = w;
      me.conH = h;
      me.paint(0, 0);
    }
  }

  // Constructor Code

  // public properties
  me.con = null;  // outermost container
  me.tbar = null; // title bar
  me.sbar = null; // status bar
  me.rbtn = null; // resize icon
  me.mbtn = null; // max/restore icon
  me.cbtn = null; // close icon
  me.maximized = false;
  me.client = xGetElementById(clientId);

  if (!me.client) {
    me.client = document.createElement(typeof iniUrl == 'string' ? 'iframe' : 'div');
    me.client.id = clientId;
  }
  me.client.className += ' xfClient';
  me.client.style.display = 'block';

  // private properties
  var rX, rY, rW, rH; // "restore" values
  var isIFrame = me.client.nodeName.toLowerCase() == 'iframe';

  xFenster.instances[clientId] = me;

  // create elements
  me.con = document.createElement('div');
  me.con.className = 'xfCon';
  if (enResize) {
    me.rbtn = document.createElement('div');
    me.rbtn.className = 'xfRIco';
    me.rbtn.title = 'Resize';
  }
  if (enMaxRes) {
    me.mbtn = document.createElement('div');
    me.mbtn.className = 'xfMIco';
    me.mbtn.title = 'Maximize/Restore';
  }
  if (enClose) {
    me.cbtn = document.createElement('div');
    me.cbtn.className = 'xfCIco';
    me.cbtn.title = 'Close';
  }
  me.tbar = document.createElement('div');
  me.tbar.className = 'xfTBar';
  if (enMove) {
    me.tbar.title = 'Drag to Move';
    if (enMaxRes) me.tbar.title += ', ';
  }
  if (enMaxRes) me.tbar.title += 'Double-Click to Maximize/Restore';
  me.tbar.appendChild(document.createTextNode(iniTitle));
  me.sbar = document.createElement('div');
  me.sbar.className = 'xfSBar';
  me.sbar.innerHTML = '&nbsp;'; // me.sbar.appendChild(document.createTextNode(' '));
  // append elements
  me.con.appendChild(me.tbar);
  if (enMaxRes) me.tbar.appendChild(me.mbtn);
  if (enClose) me.tbar.appendChild(me.cbtn);
  me.con.appendChild(me.client);
  me.con.appendChild(me.sbar);
  if (enResize) me.sbar.appendChild(me.rbtn);
  document.body.appendChild(me.con);
  // final initializations
  me.conW = iniW;
  me.conH = iniH;
  if (isIFrame) { me.href(iniUrl); }
  xMoveTo(me.con, iniX, iniY);
  me.paint(0, 0);
  if (enMove) xEnableDrag(me.tbar, dragStart, barDrag, dragEnd);
  if (enResize) xEnableDrag(me.rbtn, dragStart, resDrag, dragEnd);
  if (isIFrame) {
    me.con.onmousedown = me.focus;
    me.client.name = clientId;
  }
  else { me.con.onclick = me.focus; }// don't like this but can't use onmousedown here - it prevents dragging thumbnail on native scrollbar!
  if (enMaxRes) me.mbtn.onclick = me.tbar.ondblclick = maxClick;
  if (enClose) {
    me.cbtn.onclick = me.hide;
    me.cbtn.onmousedown = xStopPropagation;
  }
  me.con.style.visibility = 'visible';
  me.focus();
  xAddEventListener(window, 'unload',
    function () {
      me.con.onmousedown = me.con.onclick = null;
      if (me.mbtn) me.mbtn.onclick = me.tbar.ondblclick = null;
      if (me.cbtn) me.cbtn.onclick = me.cbtn.onmousedown = null;
      xFenster.instances[clientId] = null;
      me = null;
    }, false
  );
  xAddEventListener(window, 'resize',
    function () {
      if (me.maximized) {
        xResizeTo(me.con, 100, 100); // ensure fenster isn't causing scrollbars
        xMoveTo(me.con, xScrollLeft(), xScrollTop());
        me.conW = xClientWidth() - 2;
        me.conH = xClientHeight() - 2;
        me.paint(0, 0);
      }
    }, false
  ); 
} // end xFenster object prototype

// xFenster static properties
xFenster.nextZ = 100;
xFenster.focused = null;
xFenster.instances = {};
// xHttpRequest r4, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xHttpRequest() // object prototype
{
  // Private Properties
  var _i = this; // instance object
  var _r = null; // XMLHttpRequest object
  var _t = null; // timer
  var _f = null; // callback function
  var _x = false; // XML response pending
  var _o = null; // user data object passed to _f
  // Public Properties
  _i.OK = 0;
  _i.NOXMLOBJ = 1;
  _i.REQERR = 2;
  _i.TIMEOUT = 4;
  _i.RSPERR = 8;
  _i.NOXMLCT = 16;
  _i.status = _i.OK;
  _i.busy = false;
  // Private Event Listeners
  function _oc() // onReadyStateChange
  {
    if (_r.readyState == 4) {
      if (_t) { clearTimeout(_t); }
      if (_r.status != 200) _i.status = _i.RSPERR;
      if (_x) {
        var ct = _r.getResponseHeader('Content-Type');
        if (ct && ct.indexOf('xml') == -1) { _i.status |= _i.NOXMLCT; }
      }
      if (_f) _f(_r, _i.status, _o);
      _i.busy = false;
    }
  }
  function _ot() // onTimeout
  {
    _r.onreadystatechange = function(){};
    _r.abort();
    _i.status |= _i.TIMEOUT;
    if (_f) _f(_r, _i.status, _o);
    _i.busy = false;
  }
  // Public Method
  this.send = function(m, u, d, t, r, x, o, f)
  {
    if (!_r || _i.busy) { return false; }
    m = m.toUpperCase();
    if (m != 'POST') {
      if (d) {
        d = '?' + d;
        if (r) { d += '&' + r + '=' + Math.round(10000*Math.random()); }
      }
      else { d = ''; }
    }
    _x = x;
    _o = o;
    _f = f;
    _i.busy = true;
    _i.status = _i.OK;
    if (t) { _t = setTimeout(_ot, t); }
    try {
      if (m == 'GET') {
        _r.open(m, u + d, true);
        d = null;
        _r.setRequestHeader('Cache-Control', 'no-cache');
        var ct = 'text/' + (x ? 'xml':'plain');
        if (_r.overrideMimeType) {_r.overrideMimeType(ct);}
        _r.setRequestHeader('Content-Type', ct);
      }
      else if (m == 'POST') {
        _r.open(m, u, true);
        _r.setRequestHeader('Method', 'POST ' + u + ' HTTP/1.1');
        _r.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
      }
      else {
        _r.open(m, u + d, true);
        d = null;
      }
      _r.onreadystatechange = _oc;
      _r.send(d);
    }
    catch(e) {
      if (_t) { clearTimeout(_t); }
      _f = null;
      _i.busy = false;
      _i.status = _i.REQERR;
      _i.error = e;
      return false;
    }
    return true;
  };
  // Constructor Code
  try { _r = new XMLHttpRequest(); }
  catch (e) { try { _r = new ActiveXObject('Msxml2.XMLHTTP'); }
  catch (e) { try { _r = new ActiveXObject('Microsoft.XMLHTTP'); }
  catch (e) { _r = null; }}}
  if (!_r) { _i.status = _i.NOXMLOBJ; }
}
// xHttpRequest2 r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

/* I suggest you use xHttpRequest instead of this implementation.
   This one has not been updated since I did more testing and
   updating on the other. This one is interesting for its use of
   the XML island for IE - but that is all.
*/

function xHttpRequest2() // object prototype
{
  // Public Properties
  this.xmlDoc = null;
  this.busy = false;
  this.err = {};
  // Private Properties
  var _i = this; // instance object
  var _r = null; // XMLHttpRequest object
  var _t = null; // timer
  var _f = null; // callback function
  /*@cc_on var _x = null; @*/ // xml element for IE
  // Private Event Listeners
  function _oc() // onReadyStateChange
  {
    if (_r.readyState == 4) {
      if (_t) { clearTimeout(_t); }
      _i.busy = false;
      if (_f) {
        if (_i.xmlDoc == 1 && _r.status == 200) {
          /*@cc_on
          @if (@_jscript_version < 5.9) // IE (this is a guess - need a better check here)
          if (!_x) {
            _x = document.createElement('xml');
            document.body.appendChild(_x);
          }
          _x.XMLDocument.loadXML(_r.responseText);
          _i.xmlDoc = _x.XMLDocument;
          @else @*/
          _i.xmlDoc = _r.responseXML;
          /*@end @*/
        }
        _f(_i, _r);
      } // end if (_f)
    }
  }
  function _ot() // onTimeout
  {
    _i.err.name = 'Timeout';
    _r.abort();
    _i.busy = false;
    if (_f) _f(_i, null);
  }
  // Public Method
  this.send = function(m, u, d, t, r, x, f)
  {
    if (!_r) { return false; }
    if (_i.busy) {
      _i.err.name = 'Busy';
      return false;
    }
    m = m.toUpperCase();
    if (m != 'POST') {
      if (d) {
        d = '?' + d;
        if (r) { d += '&' + r + '=' + Math.round(10000*Math.random()); }
      }
      else { d = ''; }
    }
    _f = f;
    _i.xmlDoc = null;
    _i.err.name = _i.err.message = '';
    _i.busy = true;
    if (t) { _t = setTimeout(_ot, t); }
    try {
      if (m == 'GET') {
        _r.open(m, u + d, true);
        d = null;
        _r.setRequestHeader('Cache-Control', 'no-cache'); // this doesn't prevent caching in IE
        if (x) {
          if (_r.overrideMimeType) { _r.overrideMimeType('text/xml'); }
          _r.setRequestHeader('Content-Type', 'text/xml');
          _i.xmlDoc = 1; // indicate to _oc that xml is expected
        }
      }
      else if (m == 'POST') {
        _r.open(m, u, true);
        _r.setRequestHeader('Method', 'POST ' + u + ' HTTP/1.1');
        _r.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
      }
      else {
        _r.open(m, u + d, true);
        d = null;
      }
      _r.onreadystatechange = _oc;
      _r.send(d);
    }
    catch(e) {
      if (_t) { clearTimeout(_t); }
      _f = null;
      _i.busy = false;
      _i.err.name = e.name;
      _i.err.message = e.message;
      return false;
    }
    return true;
  };
  // Constructor Code
  try { _r = new XMLHttpRequest(); }
  catch (e) { try { _r = new ActiveXObject('Msxml2.XMLHTTP'); }
  catch (e) { try { _r = new ActiveXObject('Microsoft.XMLHTTP'); }
  catch (e) { _r = null; }}}
  if (!_r) { _i.err.name = 'Unsupported'; }
}
xLibrary={version:'4.17',license:'GNU LGPL',url:'http://cross-browser.com/'};
// xMenu1 r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xMenu1(triggerId, menuId, mouseMargin, openEvent)
{
  var isOpen = false;
  var trg = xGetElementById(triggerId);
  var mnu = xGetElementById(menuId);
  if (trg && mnu) {
    xAddEventListener(trg, openEvent, onOpen, false);
  }
  function onOpen()
  {
    if (!isOpen) {
      xMoveTo(mnu, xPageX(trg), xPageY(trg) + xHeight(trg));
      mnu.style.visibility = 'visible';
      xAddEventListener(document, 'mousemove', onMousemove, false);
      isOpen = true;
    }
  }
  function onMousemove(ev)
  {
    var e = new xEvent(ev);
    if (!xHasPoint(mnu, e.pageX, e.pageY, -mouseMargin) &&
        !xHasPoint(trg, e.pageX, e.pageY, -mouseMargin))
    {
      mnu.style.visibility = 'hidden';
      xRemoveEventListener(document, 'mousemove', onMousemove, false);
      isOpen = false;
    }
  }
} // end xMenu1
// xMenu1A r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xMenu1A(triggerId, menuId, mouseMargin, slideTime, openEvent)
{
  var isOpen = false;
  var trg = xGetElementById(triggerId);
  var mnu = xGetElementById(menuId);
  if (trg && mnu) {
    mnu.style.visibility = 'hidden';
    xAddEventListener(trg, openEvent, onOpen, false);
  }
  function onOpen()
  {
    if (!isOpen) {
      xMoveTo(mnu, xPageX(trg), xPageY(trg));
      mnu.style.visibility = 'visible';
      xSlideTo(mnu, xPageX(trg), xPageY(trg) + xHeight(trg), slideTime);
      xAddEventListener(document, 'mousemove', onMousemove, false);
      isOpen = true;
    }
  }
  function onMousemove(ev)
  {
    var e = new xEvent(ev);
    if (!xHasPoint(mnu, e.pageX, e.pageY, -mouseMargin) &&
        !xHasPoint(trg, e.pageX, e.pageY, -mouseMargin))
    {
      xRemoveEventListener(document, 'mousemove', onMousemove, false);
      xSlideTo(mnu, xPageX(trg), xPageY(trg), slideTime);
      setTimeout("xGetElementById('" + menuId + "').style.visibility='hidden'", slideTime);
      isOpen = false;
    }
  }
} // end xMenu1A
// xMenu1B r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xMenu1B(openTriggerId, closeTriggerId, menuId, slideTime, bOnClick)
{
  xMenu1B.instances[xMenu1B.instances.length] = this;
  var isOpen = false;
  var oTrg = xGetElementById(openTriggerId);
  var cTrg = xGetElementById(closeTriggerId);
  var mnu = xGetElementById(menuId);
  if (oTrg && cTrg && mnu) {
    mnu.style.visibility = 'hidden';
    if (bOnClick) oTrg.onclick = openOnEvent;
    else oTrg.onmouseover = openOnEvent;
    cTrg.onclick = closeOnClick;
  }
  function openOnEvent()
  {
    if (!isOpen) {
      for (var i = 0; i < xMenu1B.instances.length; ++i) {
        xMenu1B.instances[i].close();
      }
      xMoveTo(mnu, xPageX(oTrg), xPageY(oTrg));
      mnu.style.visibility = 'visible';
      xSlideTo(mnu, xPageX(oTrg), xPageY(oTrg) + xHeight(oTrg), slideTime);
      isOpen = true;
    }
  }
  function closeOnClick()
  {
    if (isOpen) {
      xSlideTo(mnu, xPageX(oTrg), xPageY(oTrg), slideTime);
      setTimeout("xGetElementById('" + menuId + "').style.visibility='hidden'", slideTime);
      isOpen = false;
    }
  }
  this.close = function()
  {
    closeOnClick();
  }
} // end xMenu1B

xMenu1B.instances = new Array(); // static member of xMenu1B
// xMenu5 r1, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xMenu5(idUL, btnClass, idAutoOpen) // object prototype
{
  // Constructor

  var i, ul, btns, mnu = xGetElementById(idUL);
  btns = xGetElementsByClassName(btnClass, mnu, 'DIV');
  for (i = 0; i < btns.length; ++i) {
    ul = xNextSib(btns[i], 'UL');
    btns[i].xClpsTgt = ul;
    btns[i].onclick = btn_onClick;
    set_display(btns[i], 0);
  }
  if (idAutoOpen) {
    var e = xGetElementById(idAutoOpen);
    while (e && e != mnu) {
      if (e.xClpsTgt) set_display(e, 1);
      while (e && e != mnu && e.nodeName != 'LI') e = e.parentNode;
      e = e.parentNode; // UL
      while (e && !e.xClpsTgt) e = xPrevSib(e);
    }
  }

  // Private
  
  function btn_onClick()
  {
    var thisLi, fc, pUl;
    if (this.xClpsTgt.style.display == 'none') {
      set_display(this, 1);
      // get this label's parent LI
      var li = this.parentNode;
      thisLi = li;
      pUl = li.parentNode; // get this LI's parent UL
      li = xFirstChild(pUl); // get the UL's first LI child
      // close all labels' ULs on this level except for thisLI's label
      while (li) {
        if (li != thisLi) {
          fc = xFirstChild(li);
          if (fc && fc.xClpsTgt) {
            set_display(fc, 0);
          }
        }
        li = xNextSib(li);
      }
    }  
    else {
      set_display(this, 0);
    }
  }

  function set_display(ele, bBlock)
  {
    if (bBlock) {
      ele.xClpsTgt.style.display = 'block';
      ele.innerHTML = '-';
    }
    else {
      ele.xClpsTgt.style.display = 'none';
      ele.innerHTML = '+';
    }
  }

  // Public

  this.onUnload = function()
  {
    for (i = 0; i < btns.length; ++i) {
      btns[i].xClpsTgt = null;
      btns[i].onclick = null;
    }
  }
} // end xMenu5 prototype


// xMenu6 r5, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xMenu6(sUlId, sMainUlClass, sSubUlClass, sLblLiClass, sItmLiClass, sLblAClass, sItmAClass, sPlusImg, sMinusImg, sImgClass, sItmPadLeft, bLblIsItm, sActiveItmId) // Object Prototype
{
  var me = this;
  xMenu6.instances[sUlId] = this;
  // Public Properties
  this.ul = xGetElementById(sUlId);
  this.pImg = sPlusImg;
  this.mImg = sMinusImg;
  // Private Event Listener
  function click(e)
  {
    if (this.xmChildUL) { // 'this' points to the A element clicked
      var s, uls = this.xmChildUL.style;
      if (uls.display != 'block') {
        s = sMinusImg;
        uls.display = 'block';
        xWalkUL(this.xmParentUL, this.xmChildUL,
          function(p,li,c,d) {
            if (c && c != d && c.style.display != 'none') {
              if (sPlusImg) {
                var a = xFirstChild(li,'a');
                xFirstChild(a,'img').src = sPlusImg;
              }
              c.style.display = 'none';
            }
            return true;
          }
        );
      }
      else {
        s = sPlusImg;
        uls.display = 'none';
      }
      if (sPlusImg) {
        xFirstChild(this,'img').src = s;
      }
      if (typeof this.blur() == 'function') {this.blur();}
      e = e || window.event;
      var t = e.target || e.srcElement;
      if (t.nodeName.toLowerCase() != 'img' && bLblIsItm) {
        return true; // click was on a label and bLblIsItm is true
      }
      return false; // click was on a label and bLblIsItm is false
    }
    return true; // click was on an item
  }
  // Constructor Code
  this.ul.className = sMainUlClass;
  xWalkUL(this.ul, null,
    function(p,li,c) {
      var liCls = sItmLiClass;
      var aCls = sItmAClass;
      var a = xFirstChild(li,'a');
      if (a) {
        var m = 'Click to toggle sub-menu';
        if (c) { // this LI is a label which precedes the submenu c
          if (sPlusImg) {
            // insert the image as the firstChild of the A element
            var i = document.createElement('img');
            i.title = m;
            a.insertBefore(i, a.firstChild);
            i.src = sPlusImg;
            i.className = sImgClass;
          }
          aCls = sLblAClass;
          liCls = sLblLiClass;
          c.className = sSubUlClass;
          c.style.display = 'none';
          a.title = bLblIsItm ? 'Click to follow link' : m;
          a.xmParentUL = p;
          a.xmChildUL = c;
          a.onclick = click;
        }
        else if (sPlusImg) { // this LI is not a label but is an item
          // if we are inserting images in label As then give A items some left padding
          a.style.paddingLeft = sItmPadLeft;
        }
        a.className = aCls;
      }
      li.className = liCls;
      return true;
    }
  );
  if (sActiveItmId) {
    this.open(sActiveItmId);
  }
  this.ul.style.visibility = 'visible';
  xAddEventListener(window, 'unload',
    function(){
      xWalkUL(me.ul, null,
        function(p,li,c) {
          var a = xFirstChild(li,'a');
          if (a && c) { a.xmParentUL = a.xmChildUL = a.onclick = null; }
          return true;
        }
      );
    }, false
  );
} // end xMenu6 prototype

// xMenu6 Public Methods
xMenu6.prototype.open = function (id)
{
  var img, ul, li, a = xGetElementById(id);
  while (a && ul != this.ul) {
    ul = a.xmChildUL;
    if (ul) {
      ul.style.display = 'block';
      if (this.pImg) {
        img = xFirstChild(a, 'img');
        if (img) {img.src = this.mImg;}
      }
    }
    li = a.parentNode; // LI
    ul = li.parentNode; // UL
    li = ul.parentNode; // LI
    a = xFirstChild(li, 'a');
  }
};

xMenu6.instances = {}; // static property
// xPopup r1, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xPopup(sTmrType, uTimeout, sPos1, sPos2, sPos3, sStyle, sId, sUrl)
{
  if (document.getElementById && document.createElement &&
      document.body && document.body.appendChild)
  { 
    // create popup element
    //var e = document.createElement('DIV');
    var e = document.createElement('IFRAME');
    this.ele = e;
    e.id = sId;
    e.style.position = 'absolute';
    e.className = sStyle;
    //e.innerHTML = sHtml;
    e.src = sUrl;
    document.body.appendChild(e);
    e.style.visibility = 'visible';
    this.tmr = xTimer.set(sTmrType, this, sTmrType, uTimeout);
    // init
    this.open = false;
    this.margin = 10;
    this.pos1 = sPos1;
    this.pos2 = sPos2;
    this.pos3 = sPos3;
    this.slideTime = 500; // slide time in ms
    this.interval();
  } 
} // end xPopup
// methods
xPopup.prototype.show = function()
{
  this.interval();
};
xPopup.prototype.hide = function()
{
  this.timeout();
};
// timer event listeners
xPopup.prototype.timeout = function() // hide popup
{
  if (this.open) {
    var e = this.ele;
    var pos = xCardinalPosition(e, this.pos3, this.margin, true);
    xSlideTo(e, pos.x, pos.y, this.slideTime);
    setTimeout("xGetElementById('" + e.id + "').style.visibility='hidden'", this.slideTime);
    this.open = false;
  }
};
xPopup.prototype.interval = function() // size, position and show popup
{
  if (!this.open) {
    var e = this.ele;
    var pos = xCardinalPosition(e, this.pos1, this.margin, true);
    xMoveTo(e, pos.x, pos.y);
    e.style.visibility = 'visible';
    pos = xCardinalPosition(e, this.pos2, this.margin, false);
    xSlideTo(e, pos.x, pos.y, this.slideTime);
    this.open = true;
  }
};
// xSelect r4, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSelect(sId, fnSubOnChange, sMainName, sSubName, bUnder, iMargin) // Object Prototype
{
  // Private Event Listener

  function s1OnChange()
  {
    var io, s2 = this.xSelSub; // 'this' points to s1
    // clear existing
    for (io=0; io<s2.options.length; ++io) {
      s2.options[io] = null;
    }
    // insert new
    var a = this.xSelData, ig = this.selectedIndex;
    for (io=1; io<a[ig].length; ++io) {
      op = new Option(a[ig][io]);
      s2.options[io-1] = op;
    }
  }

  // Constructor Code

  // Check for required browser objects
  var s0 = xGetElementById(sId);
  if (!s0 || !s0.firstChild || !s0.nodeName || !document.createElement || !s0.form || !s0.form.appendChild) {
    return null;
  }
  // Create main category SELECT element
  var s1 = document.createElement('SELECT');
  s1.id = s1.name = sMainName ? sMainName : sId + '_main';
  s1.display = 'block'; // for opera bug?
  s1.style.position = 'absolute';
  s1.xSelObj = this;
  s1.xSelData = new Array();
  // append s1 to s0's form
  s0.form.appendChild(s1);
  // Iterate thru s0 and fill array.
  // For each OPTGROUP, a[og][0] == OPTGROUP label, and...
  // a[og][n] = innerHTML of OPTION n.
  var ig=0, io, op, og, a = s1.xSelData;
  og = s0.firstChild;
  while (og) {
    if (og.nodeName.toLowerCase() == 'optgroup') {
      io = 0;
      a[ig] = new Array();
      a[ig][io] = og.label;
      op = og.firstChild;
      while (op) {
        if (op.nodeName.toLowerCase() == 'option') {
          io++;
          a[ig][io] = op.innerHTML;
        }
        op = op.nextSibling;
      }
      ig++;
    }
    og = og.nextSibling;
  }
  // In s1 insert a new OPTION for each OPTGROUP in s0
  for (ig=0; ig<a.length; ++ig) {
    op = new Option(a[ig][0]);
    s1.options[ig] = op;
  }
  // Create sub-category SELECT element
  var s2 = document.createElement('SELECT');
  s2.id = s2.name = sSubName ? sSubName : sId + '_sub';
  s2.display = 'block'; // for opera bug?
  s2.style.position = 'absolute';
  s2.xSelMain = s1;
  s1.xSelSub = s2;
  // Append s2 to s0's form
  s0.form.appendChild(s2);
  // Add event listeners
  s1.onchange = s1OnChange;
  s2.onchange = fnSubOnChange || null;
  // Hide s0. Position and show s1 where s0 was.
  s0.style.visibility = 'hidden';
  xMoveTo(s1, s0.offsetLeft, s0.offsetTop);
  s1.style.visibility = 'visible';
  iMargin = iMargin || 0;
  if (bUnder) { // Position s2 under s1.
    xMoveTo(s2, s0.offsetLeft, s0.offsetTop + xHeight(s1) + iMargin);
  }
  else { // Position s2 to the right of s1.
    xMoveTo(s2, s0.offsetLeft + xWidth(s1) + iMargin, s0.offsetTop);
  }
  s2.style.visibility = 'visible';
  // Initialize s2
  s1.onchange();
}
// xSequence r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL


function xSequence(seq) // object prototype
{
  // Private Properties
  var ai = 0; // current action index of seq
  var stop = true;
  var running = false;
  // Private Method
  function runSeq()
  {
    if (stop) {
      running = false;
      return;
    }
    if (this.onslideend) this.onslideend = null; // during a slideend callback
    if (ai >= seq.length) ai = 0;
    var i = ai;
    ++ai;
    if (seq[i][0] != -1) {
      setTimeout(runSeq, seq[i][0]);
    }
    else {
      if (seq[i][2] && seq[i][2][0]) seq[i][2][0].onslideend = runSeq;
    }
    if (seq[i][1]) {
      if (seq[i][2]) seq[i][1].apply(window, seq[i][2]);
      else seq[i][1]();
    }
  }
  // Public Methods
  this.run = function(si)
  {
    if (!running) {
      if (xDef(si) && si >=0 && si < seq.length) ai = si;
      stop = false;
      running = true;
      runSeq();
    }
  };
  this.stop = function()
  {
    stop = true;
  };
  this.onUnload = function() // is this needed? do I have circular refs?
  {                          // this should already have been done above, don't think it's needed
    if (!window.opera) {
      for (var i=0; i<seq.length; ++i) {
        if (seq[i][2] && seq[i][2][0] && seq[i][2][0].onslideend) seq[i][2][0].onslideend = runSeq;
      }
    }
  };
}
// xSplitter r3, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSplitter(sSplId, uSplX, uSplY, uSplW, uSplH, bHorizontal, uBarW, uBarPos, uBarLimit1, uBarLimit2, bBarEnabled, uSplBorderW, oSplChild1, oSplChild2)
{
  // Private

  var pane1, pane2, splW, splH;
  var splEle, barPos, barLim1, barLim2, barEle;

  function barOnDrag(ele, dx, dy)
  {
    var bp;
    if (bHorizontal)
    {
        bp = barPos + dx;
        if (bp < barLim1 || bp > splW - barLim2) { return; }
        xWidth(pane1, xWidth(pane1) + dx);
        xLeft(barEle, xLeft(barEle) + dx);
        xWidth(pane2, xWidth(pane2) - dx);
        xLeft(pane2, xLeft(pane2) + dx);
        barPos = bp;
    }
    else
    {
        bp = barPos + dy;
        if (bp < barLim1 || bp > splH - barLim2) { return; }
        xHeight(pane1, xHeight(pane1) + dy);
        xTop(barEle, xTop(barEle) + dy);
        xHeight(pane2, xHeight(pane2) - dy);
        xTop(pane2, xTop(pane2) + dy);
        barPos = bp;
    }
    if (oSplChild1) { oSplChild1.paint(xWidth(pane1), xHeight(pane1)); }
    if (oSplChild2) { oSplChild2.paint(xWidth(pane2), xHeight(pane2)); }
  }

  // Public

  this.paint = function(uNewW, uNewH, uNewBarPos, uNewBarLim1, uNewBarLim2) // uNewBarPos and uNewBarLim are optional
  {
    if (uNewW == 0) { return; }
    var w1, h1, w2, h2;
    splW = uNewW;
    splH = uNewH;
    barPos = uNewBarPos || barPos;
    barLim1 = uNewBarLim1 || barLim1;
    barLim2 = uNewBarLim2 || barLim2;
    xMoveTo(splEle, uSplX, uSplY);
    xResizeTo(splEle, uNewW, uNewH);
    if (bHorizontal)
    {
      w1 = barPos;
      h1 = uNewH - 2 * uSplBorderW;
      w2 = uNewW - w1 - uBarW - 2 * uSplBorderW;
      h2 = h1;
      xMoveTo(pane1, 0, 0);
      xResizeTo(pane1, w1, h1);
      xMoveTo(barEle, w1, 0);
      xResizeTo(barEle, uBarW, h1);
      xMoveTo(pane2, w1 + uBarW, 0);
      xResizeTo(pane2, w2, h2);
    }
    else
    {
      w1 = uNewW - 2 * uSplBorderW;;
      h1 = barPos;
      w2 = w1;
      h2 = uNewH - h1 - uBarW - 2 * uSplBorderW;
      xMoveTo(pane1, 0, 0);
      xResizeTo(pane1, w1, h1);
      xMoveTo(barEle, 0, h1);
      xResizeTo(barEle, w1, uBarW);
      xMoveTo(pane2, 0, h1 + uBarW);
      xResizeTo(pane2, w2, h2);
    }
    if (oSplChild1)
    {
      pane1.style.overflow = 'hidden';
      oSplChild1.paint(w1, h1);
    }
    if (oSplChild2)
    {
      pane2.style.overflow = 'hidden';
      oSplChild2.paint(w2, h2);
    }
  };

  // Constructor

  splEle = xGetElementById(sSplId); // we assume the splitter has 3 DIV children and in this order:
  pane1 = xFirstChild(splEle, 'DIV');
  pane2 = xNextSib(pane1, 'DIV');
  barEle = xNextSib(pane2, 'DIV');
  //  --- slightly dirty hack
  pane1.style.zIndex = 2;
  pane2.style.zIndex = 2;
  barEle.style.zIndex = 1;
  // ---
  barPos = uBarPos;
  barLim1 = uBarLimit1;
  barLim2 = uBarLimit2;
  this.paint(uSplW, uSplH);
  if (bBarEnabled)
  {
    xEnableDrag(barEle, null, barOnDrag, null);
    barEle.style.cursor = bHorizontal ? 'e-resize' : 'n-resize';
  }
  splEle.style.visibility = 'visible';

} // end xSplitter
// xTabPanelGroup r11, Copyright 2005-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTabPanelGroup(id, w, h, th, clsTP, clsTG, clsTD, clsTS) // object prototype
{
  // Private Methods

  function onClick() //r7
  {
    paint(this);
    return false;
  }
  function onFocus() //r7
  {
    paint(this);
  }
  function paint(tab)
  {
    tab.className = clsTS;
    tab.style.zIndex = highZ++;
    panels[tab.xTabIndex].style.display = 'block';
    if (selectedIndex != tab.xTabIndex) {
      panels[selectedIndex].style.display = 'none';
      tabs[selectedIndex].className = clsTD;
      selectedIndex = tab.xTabIndex;
    }
  }

  // Private Properties

  var panelGrp, tabGrp, panels, tabs, highZ, selectedIndex;
  
  // Public Methods

  this.select = function(n) //r7
  {
    if (n && n <= tabs.length) {
      var t = tabs[n-1];
      if (t.focus) t.focus();
      else t.onclick();
    }
  };
  this.onUnload = function()
  {
    if (!window.opera) for (var i = 0; i < tabs.length; ++i) {tabs[i].onfocus = tabs[i].onclick = null;}
  };
  this.onResize = function(newW, newH) //r9
  {
    var x = 0, i;
    // [r9
    if (newW) {
      w = newW;
      xWidth(panelGrp, w);
    }
    else w = xWidth(panelGrp);
    if (newH) {
      h = newH;
      xHeight(panelGrp, h);
    }
    else h = xHeight(panelGrp);
    // r9]
    xResizeTo(tabGrp[0], w, th);
    xMoveTo(tabGrp[0], 0, 0);
    w -= 2; // remove border widths
    var tw = w / tabs.length;
    for (i = 0; i < tabs.length; ++i) {
      xResizeTo(tabs[i], tw, th); 
      xMoveTo(tabs[i], x, 0);
      x += tw;
      tabs[i].xTabIndex = i;
      tabs[i].onclick = onClick;
      tabs[i].onfocus = onFocus; //r7
      panels[i].style.display = 'none';
      xResizeTo(panels[i], w, h - th - 2); // -2 removes border widths
      xMoveTo(panels[i], 0, th);
    }
    highZ = i;
    tabs[selectedIndex].onclick(); //r9
  };

  // Constructor Code

  panelGrp = xGetElementById(id);
  if (!panelGrp) { return null; }
  panels = xGetElementsByClassName(clsTP, panelGrp);
  tabs = xGetElementsByClassName(clsTD, panelGrp);
  tabGrp = xGetElementsByClassName(clsTG, panelGrp);
  if (!panels || !tabs || !tabGrp || panels.length != tabs.length || tabGrp.length != 1) { return null; }
  selectedIndex = 0;
  this.onResize(w, h); //r9
}
// xTable r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTable(sTableId, sRoot, sCC, sFR, sFRI, sRCell, sFC, sFCI, sCCell, sTC, sCellT)
{
  var i, ot, cc=null, fcw, frh, root, fr, fri, fc, fci, tc;
  var e, t, tr, a, alen, tmr=null;

  ot = xGetElementById(sTableId); // original table
  if (!ot || !document.createElement || !document.appendChild || !ot.deleteCaption || !ot.deleteTHead) {
    return null;
  }
  fcw = xWidth(ot.rows[1].cells[0]); // get first column width before altering ot
  frh = xHeight(ot.rows[0]); // get first row height before altering ot
  root = document.createElement('div'); // overall container
  root.className = sRoot;
  fr = document.createElement('div'); // frozen-row container
  fr.className = sFR;
  fri = document.createElement('div'); // frozen-row inner container, for column headings
  fri.className = sFRI;
  fr.appendChild(fri);
  root.appendChild(fr);
  fc = document.createElement('div'); // frozen-column container
  fc.className = sFC;
  fci = document.createElement('div'); // frozen-column inner container, for row headings
  fci.className = sFCI;
  fc.appendChild(fci);
  root.appendChild(fc);
  tc = document.createElement('div'); // table container, contains ot
  tc.className = sTC;
  root.appendChild(tc);
  if (ot.caption) {
    cc = document.createElement('div'); // caption container
    cc.className = sCC;
    cc.appendChild(ot.caption.firstChild); // only gets first child
    root.appendChild(cc);
    ot.deleteCaption();
  }
  // Create fr cells (column headings)
  a = ot.rows[0].cells;
  alen = a.length;
  for (i = 1; i < alen; ++i) {
    e = document.createElement('div');
    e.className = sRCell;
    t = document.createElement('table');
    t.className = sCellT;
    tr = t.insertRow(0);
    tr.appendChild(a[1]);
    e.appendChild(t);
    fri.appendChild(e);
  }
  if (ot.tHead) {
    ot.deleteTHead();
  }
  // Create fc cells (row headings)
  a = ot.rows;
  alen = a.length;
  for (i = 0; i < alen; ++i) {
    e = document.createElement('div');
    e.className = sCCell;
    t = document.createElement('table');
    t.className = sCellT;
    tr = t.insertRow(0);
    tr.appendChild(a[i].cells[0]);
    e.appendChild(t);
    fci.appendChild(e);
  }
  ot = ot.parentNode.replaceChild(root, ot);
  tc.appendChild(ot);

  resize();
  root.style.visibility = 'visible';
  xAddEventListener(tc, 'scroll', onScroll, false);
  xAddEventListener(window, 'resize', onResize, false);

  function onScroll()
  {
    xLeft(fri, -tc.scrollLeft);
    xTop(fci, -tc.scrollTop);
  }
  function onResize()
  {
    if (!tmr) {
      tmr = setTimeout(
        function() {
          resize();
          tmr=null;
        }, 500);
    }
  }
  function resize()
  {
    var sum = 0, cch = 0, w, h;
    // caption container
    if (cc) {
      cch = xHeight(cc);
      xMoveTo(cc, 0, 0);
      xWidth(cc, xWidth(root));
    }
    // frozen row
    xMoveTo(fr, fcw, cch);
    xResizeTo(fr, xWidth(root) - fcw, frh);
    xMoveTo(fri, 0, 0);
    xResizeTo(fri, xWidth(ot), frh);
    // frozen col
    xMoveTo(fc, 0, cch + frh);
    xResizeTo(fc, fcw, xHeight(root) - cch);
    xMoveTo(fci, 0, 0);
    xResizeTo(fci, fcw, xHeight(ot));
    // table container
    xMoveTo(tc, fcw, cch + frh);
    xWidth(tc, xWidth(root) - fcw - 1);
    xHeight(tc, xHeight(root) - cch - frh - 1);
    // size and position fr cells
    a = ot.rows[0].cells;
    e = xFirstChild(fri, 'div');
    for (i = 0; i < a.length; ++i) {
      xMoveTo(e, sum, 0);
      w = xWidth(e, xWidth(a[i]));
      h = xHeight(e, frh);
      sum += w;
      xResizeTo(xFirstChild(e, 'table'), w, h);//////////
      e = xNextSib(e, 'div');
    }
    // size and position fc cells
    sum = 0;
    a = ot.rows;
    e = xFirstChild(fci, 'div');
    for (i = 0; i < a.length; ++i) {
      xMoveTo(e, 0, sum);
      w = xWidth(e, fcw);
      h = xHeight(e, xHeight(a[i]));
      sum += h;
      xResizeTo(xFirstChild(e, 'table'), w, h);//////////
      e = xNextSib(e, 'div');
    }
    onScroll();
  } // end resize
} // end xTable
// xTableCursor r3, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTableCursor(tblId, rowStyle, cellStyle) // object prototype
{
  xTableIterate(tblId,
    function(obj, isRow) {
      if (!isRow) {
        obj.onmouseover = tdOver;
        obj.onmouseout = tdOut;
      }
    }
  );
  function tdOver(e) {
    xAddClass(this, cellStyle);
    var tr = this.parentNode;
    for (var i = 0; i < tr.cells.length; ++i) {
      if (this != tr.cells[i]) xAddClass(tr.cells[i], rowStyle);
    }
  }
  function tdOut(e) {
    xRemoveClass(this, cellStyle);
    var tr = this.parentNode;
    for (var i = 0; i < tr.cells.length; ++i) {
      xRemoveClass(tr.cells[i], rowStyle);
    }
  }
  this.unload = function() {
    xTableIterate(tblId, function(o) { o.onmouseover = o.onmouseout = null; });
  };
}
// xTableHeaderFixed r1, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTableHeaderFixed(fixedContainerId, fixedTableClass, fakeBodyId, tableBorder, thBorder)
{
  // Private Property
  var tables = [];
  // Private Event Listener
  function onEvent(e) // handles scroll and resize events
  {
    e = e || window.event;
    var r = e.type == 'resize' ? true : false;
    for (var i = 0; i < tables.length; ++i) {
      scroll(tables[i], r);
    }
  }
  // Private Methods
  function scroll(t, bResize)
  {
    if (!t) { return; }
    var fhc = xGetElementById(fixedContainerId); // for IE6
    var fh = xGetElementById(t.fixedHeaderId);
    var thead = t.tHead;
    var st, sl, thy = xPageY(thead);
    /*@cc_on
    @if (@_jscript_version == 5.6) // IE6
    st = xGetElementById(fakeBodyId).scrollTop;
    sl = xGetElementById(fakeBodyId).scrollLeft;
    @else @*/
    st = xScrollTop();
    sl = xScrollLeft();
    /*@end @*/
    var th = xHeight(t);
    var tw = xWidth(t);
    var ty = xPageY(t);
    var tx = xPageX(t);
    var fhh = xHeight(fh);
    if (bResize) {
      xWidth(fh, tw + 2*tableBorder);
      var th1 = xGetElementsByTagName('th', t);
      var th2 = xGetElementsByTagName('th', fh);
      for (var i = 0; i < th1.length; ++i) {
        xWidth(th2[i], xWidth(th1[i]) + thBorder);
      }
    }
    xLeft(fh, tx - sl);
    if (st <= thy || st > ty + th - fhh) {
      if (fh.style.visibility != 'hidden') {
        fh.style.visibility = 'hidden';
        fhc.style.visibility = 'hidden'; // for IE6
      }
    }
    else {
      if (fh.style.visibility != 'visible') {
        fh.style.visibility = 'visible';
        fhc.style.visibility = 'visible'; // for IE6
      }
    }
  }
  function init()
  {
    var i, tbl, h, t, con;
    if (null == (con = xGetElementById(fixedContainerId))) {
      con = document.createElement('div');
      con.id = fixedContainerId;
      document.body.appendChild(con);
    }
    for (i = 0; i < tables.length; ++i) {
      tbl = tables[i];
      h = tbl.tHead;
      if (h) {
        t = document.createElement('table');
        t.className = fixedTableClass;
        t.appendChild(h.cloneNode(true));
        t.id = tbl.fixedHeaderId = 'xtfh' + i;
        con.appendChild(t);
      }
      else {
        tables[i] = null; // ignore tables with no thead
      }
    }
    con.style.visibility = 'hidden'; // for IE6
  }
  // Public Method
  this.unload = function()
  {
    for (var i = 0; i < tables.length; ++i) {
      tables[i] = null;
    }
  };
  // Constructor Code
  var i, j, lst;
  if (arguments.length > 5) { // we've been passed a list of IDs and/or Element objects
    i = 5;
    lst = arguments;
  }
  else { // make a list of all tables
    i = 0;
    lst = xGetElementsByTagName('table');
  }
  for (j = 0; i < lst.length; ++i, ++j) {
    tables[j] = xGetElementById(lst[i]);
  }
  init();
  onEvent({type:'resize'});
  /*@cc_on
  @if (@_jscript_version == 5.6) // IE6
  xAddEventListener(fakeBodyId, 'scroll', onEvent, false);
  @else @*/
  xAddEventListener(window, 'scroll', onEvent, false);
  /*@end @*/
  xAddEventListener(window, 'resize', onEvent, false);
} // end xTableHeaderFixed
// xTimer r3, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

// There are better ways of doing this now.

function xTimerMgr()
{
  this.tmr = null;
  this.timers = new Array();
}
// xTimerMgr Methods
xTimerMgr.prototype.set = function(type, obj, sMethod, uTime, data) // type: 'interval' or 'timeout'
{
  return (this.timers[this.timers.length] = new xTimerObj(type, obj, sMethod, uTime, data));
};
xTimerMgr.prototype.run = function()
{
  var i, t, d = new Date(), now = d.getTime();
  for (i = 0; i < this.timers.length; ++i) {
    t = this.timers[i];
    if (t && t.running) {
      t.elapsed = now - t.time0;
      if (t.elapsed >= t.preset) { // timer event on t
        t.obj[t.mthd](t); // pass listener this xTimerObj
        if (t.type.charAt(0) == 'i') { t.time0 = now; }
        else { t.stop(); }
      }  
    }
  }
};
xTimerMgr.prototype.tick = function(t) // set the timers' resolution
{
  if (this.tmr) clearInterval(this.tmr);
  this.tmr = setInterval('xTimer.run()', t);
};
// Object Prototype used only by xTimerMgr
function xTimerObj(type, obj, mthd, preset, data)
{
  // Public Properties
  this.data = data;
  // Read-only Properties
  this.type = type; // 'interval' or 'timeout'
  this.obj = obj;
  this.mthd = mthd; // string
  this.preset = preset;
  this.reset();
} // end xTimerObj constructor
// xTimerObj Methods
xTimerObj.prototype.stop = function() { this.running = false; };
xTimerObj.prototype.start = function() { this.running = true; }; // continue after a stop
xTimerObj.prototype.reset = function()
{
  var d = new Date();
  this.time0 = d.getTime();
  this.elapsed = 0;
  this.running = true;
};
var xTimer = new xTimerMgr(); // applications assume global name is 'xTimer'
xTimer.tmr = setInterval('xTimer.run()', 25);
// xTooltipGroup r10, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTooltipGroup(grpClassOrIdList, tipClass, origin, xOffset, yOffset, hideDelay, sticky, textList)
{
  //// Properties

  this.c = tipClass;
  this.o = origin;
  this.x = xOffset;
  this.y = yOffset;
  this.s = sticky;
  this.hd = hideDelay || 0;

  //// Constructor Code

  var i, tips;
  if (xStr(grpClassOrIdList)) {
    tips = xGetElementsByClassName(grpClassOrIdList);
    for (i = 0; i < tips.length; ++i) {
      tips[i].xTooltip = this;
      tips[i].xTooltipText = tips[i].title; // r10
      tips[i].title = '';                   // r10
    }
  }
  else {
    tips = new Array();
    for (i = 0; i < grpClassOrIdList.length; ++i) {
      tips[i] = xGetElementById(grpClassOrIdList[i]);
      if (!tips[i]) {
        alert('Element not found for id = ' + grpClassOrIdList[i]);
      }  
      else {
        tips[i].xTooltip = this;
        tips[i].xTooltipText = textList[i];
      }
    }
  }
  if (!xTooltipGroup.tipEle) { // only execute once
    var te = document.createElement("div");
    if (te) {
      te.id = 'xTooltipElement';
      xTooltipGroup.tipEle = te = document.body.appendChild(te);
      xAddEventListener(document, 'mousemove', xTooltipGroup.docOnMousemove, false);
    }
  }
} // end xTooltipGroup ctor

//// Static Properties

xTooltipGroup.tmr = null; // timer
xTooltipGroup.trgEle = null; // currently active trigger
xTooltipGroup.tipEle = null; // the tooltip element (all groups use the same element)

//// Static Methods

xTooltipGroup.docOnMousemove = function(oEvent)
{
  var t = null, e = new xEvent(oEvent);
  if (e.target) {
    t = e.target;
    while (t && !t.xTooltip) {
      t = t.offsetParent;
    }
    if (t) {
      t.xTooltip.show(t, e.pageX, e.pageY);
    }
    else if (xTooltipGroup.trgEle) {
      t = xTooltipGroup.trgEle.xTooltip;
      if (t && !t.s && !xTooltipGroup.tmr) {
        xTooltipGroup.tHide();
      }
    }
  }
};

xTooltipGroup.teOnClick = function()
{
  xTooltipGroup.hide();
};

xTooltipGroup.tHide = function()
{
  xTooltipGroup.tmr = setTimeout("xTooltipGroup.hide()", xTooltipGroup.trgEle.xTooltip.hd);
};

xTooltipGroup.hide = function()
{
  xMoveTo(xTooltipGroup.tipEle, -1000, -1000);
  xTooltipGroup.trgEle = null;
};

//// xTooltipGroup Public Method

xTooltipGroup.prototype.show = function(trigEle, mx, my)
{
  if (xTooltipGroup.tmr) {
    clearTimeout(xTooltipGroup.tmr);
    xTooltipGroup.tmr = null;
  }
  if (xTooltipGroup.trgEle != trigEle) { // if not active or moved to an adjacent trigger
    xTooltipGroup.tipEle.className = trigEle.xTooltip.c;
    xTooltipGroup.tipEle.innerHTML = trigEle.xTooltipText; // r10
//r9:    xTooltipGroup.tipEle.innerHTML = trigEle.xTooltipText ? trigEle.xTooltipText : trigEle.title;
    xTooltipGroup.trgEle = trigEle;
  }  
  if (this.s) {
    xTooltipGroup.tipEle.title = 'Click To Close';
    xTooltipGroup.tipEle.onclick = xTooltipGroup.teOnClick;
  }
  var x, y, tipW, trgW, trgX;
  tipW = xWidth(xTooltipGroup.tipEle);
  trgW = xWidth(trigEle);
  trgX = xPageX(trigEle);
  switch(this.o) {
    case 'right':
      if (trgX + this.x + trgW + tipW < xClientWidth()) { x = trgX + this.x + trgW; }
      else { x = trgX - tipW - this.x; }
      y = xPageY(trigEle) + this.y;
      break;
    case 'top':
      x = trgX + this.x;
      y = xPageY(trigEle) - xHeight(trigEle) + this.y;
      break;
    case 'mouse':
      if (mx + this.x + tipW < xClientWidth()) { x = mx + this.x; }
      else { x = mx - tipW - this.x; }
      y = my + this.y;
      break;
  }
  xMoveTo(xTooltipGroup.tipEle, x, y);
  xTooltipGroup.tipEle.style.visibility = 'visible';
};
// xTriStateImage r4, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTriStateImage(idOut, urlOver, urlDown, fnUp) // Object Prototype
{
  var img;
  // Downgrade Detection
  if (typeof Image != 'undefined' && document.getElementById) {
    img = document.getElementById(idOut);
    if (img) {
      // Constructor Code
      var urlOut = img.src;
      var i = new Image();
      i.src = urlOver;
      i = new Image();
      i.src = urlDown;
      // Event Listeners (closure)
      img.onmouseover = function() { this.src = urlOver; };
      img.onmouseout = function() { this.src = urlOut; };
      img.onmousedown = function() { this.src = urlDown; };
      img.onmouseup = function()
      {
        this.src = urlOver;
        if (fnUp) {
          fnUp();
        }
      };
    }
  }
  // Destructor Method
  this.onunload = function()
  {
    if (!window.opera && img) { // Remove any circular references for IE
      img.onmouseover = img.onmouseout = img.onmousedown = null;
      img = null;
    }
  };    
}
// xWinClass r1, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

// xWinClass Object Prototype

function xWinClass(clsName, winName, w, h, x, y, loc, men, res, scr, sta, too)
{
  var thisObj = this;
  var e='',c=',',xf='left=',yf='top='; this.n = name;
  if (document.layers) {xf='screenX='; yf='screenY=';}
  this.f = (w?'width='+w+c:e)+(h?'height='+h+c:e)+(x>=0?xf+x+c:e)+
    (y>=0?yf+y+c:e)+'location='+loc+',menubar='+men+',resizable='+res+
    ',scrollbars='+scr+',status='+sta+',toolbar='+too;
  this.opened = function() {return this.w && !this.w.closed;};
  this.close = function() {if(this.opened()) this.w.close();};
  this.focus = function() {if(this.opened()) this.w.focus();};
  this.load = function(sUrl) {
    if (this.opened()) this.w.location.href = sUrl;
    else this.w = window.open(sUrl,this.n,this.f);
    this.focus();
    return false;
  };
  // Closures
  // this == <A> element reference, thisObj == xWinClass object reference
  function onClick() {return thisObj.load(this.href);}
  // '*' works with any element, not just A
  xGetElementsByClassName(clsName, document, '*', bindOnClick);
  function bindOnClick(e) {e.onclick = onClick;}
}
// xWindow r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xWindow(name, w, h, x, y, loc, men, res, scr, sta, too)
{
  var e='',c=',',xf='left=',yf='top='; this.n = name;
  if (document.layers) {xf='screenX='; yf='screenY=';}
  this.f = (w?'width='+w+c:e)+(h?'height='+h+c:e)+(x>=0?xf+x+c:e)+
    (y>=0?yf+y+c:e)+'location='+loc+',menubar='+men+',resizable='+res+
    ',scrollbars='+scr+',status='+sta+',toolbar='+too;
  this.opened = function() {return this.w && !this.w.closed;};
  this.close = function() {if(this.opened()) this.w.close();};
  this.focus = function() {if(this.opened()) this.w.focus();};
  this.load = function(sUrl) {
    if (this.opened()) this.w.location.href = sUrl;
    else this.w = window.open(sUrl,this.n,this.f);
    this.focus();
    return false;
  };
}

// Previous implementation:
// function xWindow(name, w, h, x, y, loc, men, res, scr, sta, too)
// {
//   var f = '';
//   if (w && h) {
//     if (document.layers) f = 'screenX=' + x + ',screenY=' + y;
//     else f = 'left=' + x + ',top=' + y;
//     f += ',width=' + w + ',height=' + h + ',';
//   }
//   f += ('location='+loc+',menubar='+men+',resizable='+res
//     +',scrollbars='+scr+',status='+sta+',toolbar='+too);
//   this.features = f;
//   this.name = name;
//   this.load = function(sUrl) {
//     if (this.wnd && !this.wnd.closed) this.wnd.location.href = sUrl;
//     else this.wnd = window.open(sUrl, this.name, this.features);
//     this.wnd.focus();
//     return false;
//   }
// }
// xAnimation.arc r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.arc = function(e,xr,yr,a1,a2,t,a,b,oe)
{
  var i = this;
  i.x1 = a1 * (Math.PI / 180); i.x2 = a2 * (Math.PI / 180); // start and end angles
  var x0 = xLeft(e) + (xWidth(e) / 2); var y0 = xTop(e) + (xHeight(e) / 2); // start point
  i.xc = x0 - (xr * Math.cos(i.x1)); i.yc = y0 - (yr * Math.sin(i.x1)); // arc center point
  i.xr = xr; i.yr = yr; // ellipse radii
  i.init(e,t,h,h,oe,a,b);
  i.run();
  function h(i) { // onRun and onTarget
    i.e.style.left = (Math.round(i.xr * Math.cos(i.x) + i.xc - (xWidth(i.e) / 2))) + 'px';
    i.e.style.top = (Math.round(i.yr * Math.sin(i.x) + i.yc - (xHeight(i.e) / 2))) + 'px';
  }
};
// xAnimation.corner r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.corner = function(e,c,x,y,t,a,b,oe) // needs more testing!
{
  var i = this;
  i.x2 = x; i.y2 = y; // end point
  // start point
  var ex = xLeft(e), ey = xTop(e);
  var ew = xWidth(e), eh = xHeight(e);
  i.cornerStr = c.toLowerCase();
  switch (i.cornerStr) {
    case 'nw': i.x1=ex; i.y1=ey; break;
    case 'sw': i.x1=ex; i.y1=ey+eh; break;
    case 'ne': i.x1=ex+ew; i.y1=ey; break;
    case 'se': i.x1=ex+ew; i.y1=ey+eh; break;
    default: /*alert('invalid cornerStr');*/ return;
  }
  i.init(e,t,h,h,oe,a,b);
  i.run();
  function h(i) { // onRun and onTarget
    var e = i.e, x = Math.round(i.x), y = Math.round(i.y);
    var nwx = xLeft(e), nwy = xTop(e); // nw point
    var sex = nwx + xWidth(e), sey = nwy + xHeight(e); // se point
    switch (i.cornerStr) {
      case 'nw': e.style.left=x+'px'; e.style.top=y+'px'; xResizeTo(e, sex-x, sey-y); break;
      case 'sw': e.style.left=x+'px'; xWidth(e,sex-x); xHeight(e,y-nwy); break;
      case 'ne': xWidth(e,x-nwx); e.style.top=y+'px'; xHeight(e,sey-y); break;
      case 'se': xWidth(e,x-nwx); xHeight(e,y-nwy); break;
    }
  }
};
// xAnimation.css r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.css = function(e,p,v,t,a,b,oe)
{
  var i = this;
  i.x1 = xGetComputedStyle(e,p,true); // start value
  i.x2 = v; // target value
  i.prop = xCamelize(p);
  i.init(e,t,h,h,oe,a,b);
  i.run();
  function h(i) {i.e.style[i.prop] = Math.round(i.x) + 'px';}
};
// xAnimation.line r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.line = function(e,x,y,t,a,b,oe)
{
  var i = this;
  i.x1 = xLeft(e); i.y1 = xTop(e); // start position
  i.x2 = Math.round(x); i.y2 = Math.round(y); // target position
  i.init(e,t,h,h,oe,a,b);
  i.run();
  function h(i) { // onRun and onTarget
    i.e.style.left = Math.round(i.x) + 'px';
    i.e.style.top = Math.round(i.y) + 'px';
  }
};
// xAnimation.opacity r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.opacity = function(e,o,t,a,b,oe)
{
  var i = this;
  i.x1 = xOpacity(e); i.x2 = o; // start and target opacity
  i.init(e,t,h,h,oe,a,b);
  i.run();
  function h(i) {xOpacity(i.e, i.x);} // onRun and onTarget
};
// xAnimation.para r3, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.para = function(e,xe,ye,inc,t,oe) // still experimental!
{
  var i = this;
  i.tt = t;
  if (!t) t = 1000;
  i.xe = xe; i.ye = ye; // x and y expression strings
  i.par = 0; i.inc = inc || .005;
  i.init(e,t,h,h,oe,0,0);
  i.run();
  function h(i) { // onRun and onTarget
    var p = i.e.offsetParent, xc, yc;
    xc = (xWidth(p)/2)-(xWidth(e)/2); yc = (xHeight(p)/2)-(xHeight(e)/2); // center of parent
    i.e.style.left = (Math.round((eval(i.xe) * xc) + xc) + xScrollLeft(p)) + 'px';
    i.e.style.top = (Math.round((eval(i.ye) * yc) + yc) + xScrollTop(p)) + 'px';
    i.par += i.inc;
    if (!i.tt) i.t += 1000; // yuck!
  }
};
// xAnimation.rgb r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.rgb = function(e,p,v,t,a,b,oe)
{
  var i = this;
  var co = xParseColor(xGetComputedStyle(e,p));
  i.x1 = co.r; i.y1 = co.g; i.z1 = co.b; // start colors
  co = xParseColor(v);
  i.x2 = co.r; i.y2 = co.g; i.z2 = co.b; // target colors
  i.prop = xCamelize(p);
  i.init(e,t,h,h,oe,a,b);
  i.run();
  function h(i) { // onRun and onTarget
    i.e.style[i.prop] = xRgbToHex(Math.round(i.x),Math.round(i.y),Math.round(i.z));
  }
};
// xAnimation.scroll r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.scroll = function(e,x,y,t,a,b,oe)
{
  var i = this;
  i.init(e);
  i.win = i.e.nodeType==1 ? false:true;
  i.x1 = xScrollLeft(i.e, i.win); i.y1 = xScrollTop(i.e, i.win); // start position
  i.x2 = Math.round(x); i.y2 = Math.round(y); // target position
  i.init(e,t,h,h,oe,a,b);
  i.run();
  function h(i) { // onRun and onTarget
    var x = Math.round(i.x), y = Math.round(i.y);
    if (i.win) i.e.scrollTo(x, y);
    else { i.e.scrollLeft = x; i.e.scrollTop = y; }
  }
};
// xAnimation.size r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

xAnimation.prototype.size = function(e,w,h,t,a,b,oe)
{
  var i = this;
  i.x1 = xWidth(e); i.y1 = xHeight(e); // start size
  i.x2 = Math.round(w); i.y2 = Math.round(h); // target size
  i.init(e,t,o,o,oe,a,b);
  i.run();
  function o(i) { xWidth(i.e, Math.round(i.x)); xHeight(i.e, Math.round(i.y)); } // onRun and onTarget
};
// xAddClass r3, Copyright 2005-2007 Daniel Frechette - modified by Mike Foster
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAddClass(e, c)
{
  if ((e=xGetElementById(e))!=null) {
    var s = '';
    if (e.className.length && e.className.charAt(e.className.length - 1) != ' ') {
      s = ' ';
    }
    if (!xHasClass(e, c)) {
      e.className += s + c;
      return true;
    }
  }
  return false;
}
// xAddEventListener r8, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAddEventListener(e,eT,eL,cap)
{
  if(!(e=xGetElementById(e)))return;
  eT=eT.toLowerCase();
  if(e.addEventListener)e.addEventListener(eT,eL,cap||false);
  else if(e.attachEvent)e.attachEvent('on'+eT,eL);
  else {
    var o=e['on'+eT];
    e['on'+eT]=typeof o=='function' ? function(v){o(v);eL(v);} : eL;
  }
}
// xAddEventListener2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAddEventListener2(e,eT,eL,cap) // original implementation
{
  if(!(e=xGetElementById(e))) return;
  eT=eT.toLowerCase();
  if (e==window && !e.opera && !document.all) { // simulate resize and scroll events for all except Opera and IE
    if(eT=='resize') { e.xPCW=xClientWidth(); e.xPCH=xClientHeight(); e.xREL=eL; xResizeEvent(); return; }
    if(eT=='scroll') { e.xPSL=xScrollLeft(); e.xPST=xScrollTop(); e.xSEL=eL; xScrollEvent(); return; }
  }
  if(e.addEventListener) e.addEventListener(eT,eL,cap||false);
  else if(e.attachEvent) e.attachEvent('on'+eT,eL);
  else e['on'+eT]=eL;
}
// called only from the above
function xResizeEvent()
{
  if (window.xREL) setTimeout('xResizeEvent()', 250);
  var w=window, cw=xClientWidth(), ch=xClientHeight();
  if (w.xPCW != cw || w.xPCH != ch) { w.xPCW = cw; w.xPCH = ch; if (w.xREL) w.xREL(); }
}
function xScrollEvent()
{
  if (window.xSEL) setTimeout('xScrollEvent()', 250);
  var w=window, sl=xScrollLeft(), st=xScrollTop();
  if (w.xPSL != sl || w.xPST != st) { w.xPSL = sl; w.xPST = st; if (w.xSEL) w.xSEL(); }
}
// xAddEventListener3, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Modified by Ivan Pepelnjak, 11Nov06
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAddEventListener3(e,eT,eL,cap)
{
  if(!(e=xGetElementById(e))) return;
  eT=eT.toLowerCase();
  if (e==window && !e.opera && !document.all) { // simulate resize and scroll events for all except Opera and IE
    if(eT=='resize') {
      e.xPCW=xClientWidth(); e.xPCH=xClientHeight();
      var pREL = e.xREL ;
      e.xREL= pREL ? function() { eL(); pREL(); } : eL;
      xResizeEvent(); return;
    }
    if(eT=='scroll') {
      e.xPSL=xScrollLeft(); e.xPST=xScrollTop();
      var pSEL = e.xSEL ;
      e.xSEL=pSEL ? function() { eL(); pSEL(); } : eL;
      xScrollEvent(); return; }
  }
  if(e.addEventListener) e.addEventListener(eT,eL,cap);
  else if(e.attachEvent) e.attachEvent('on'+eT,eL);
  else {
    var pev = e['on'+eT] ;
    e['on'+eT]= pev ? function() { eL(); typeof(pev) == 'string' ? eval(pev) : pev(); } : eL ;
  }
}
// called only from the above
function xResizeEvent()
{
  if (window.xREL) setTimeout('xResizeEvent()', 250);
  var w=window, cw=xClientWidth(), ch=xClientHeight();
  if (w.xPCW != cw || w.xPCH != ch) { w.xPCW = cw; w.xPCH = ch; if (w.xREL) w.xREL(); }
}
function xScrollEvent()
{
  if (window.xSEL) setTimeout('xScrollEvent()', 250);
  var w=window, sl=xScrollLeft(), st=xScrollTop();
  if (w.xPSL != sl || w.xPST != st) { w.xPSL = sl; w.xPST = st; if (w.xSEL) w.xSEL(); }
}
// xAniLine r1, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAniLine(e, x, y, t, a, oe)
{
  if (!(e=xGetElementById(e))) return;
  var x0 = xLeft(e), y0 = xTop(e); // start positions
  x = Math.round(x); y = Math.round(y);
  var dx = x - x0, dy = y - y0; // displacements
  var fq = 1 / t; // frequency
  if (a) fq *= (Math.PI / 2);
  var t0 = new Date().getTime(); // start time
  var tmr = setInterval(
    function() {
      var et = new Date().getTime() - t0; // elapsed time
      if (et < t) {
        var f = et * fq; // constant velocity
        if (a == 1) f = Math.sin(f); // sine acceleration
        else if (a == 2) f = 1 - Math.cos(f); // cosine acceleration
        f = Math.abs(f);
        e.style.left = Math.round(f * dx + x0) + 'px'; // instantaneous positions
        e.style.top = Math.round(f * dy + y0) + 'px';
      }
      else {
        clearInterval(tmr);
        e.style.left = x + 'px'; // target positions
        e.style.top = y + 'px';
        if (typeof oe == 'function') oe(); // 'onEnd' handler
        else if (typeof oe == 'string') eval(oe);
      }
    }, 10 // timer resolution
  );
}
// xAniOpacity r1, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAniOpacity(e, o, t, a, oe)
{
  if (!(e=xGetElementById(e))) return;
  var o0 = xOpacity(e); // start value
  var dx = o - o0; // displacement
  var fq = 1 / t; // frequency
  if (a) fq *= (Math.PI / 2);
  var t0 = new Date().getTime(); // start time
  var tmr = setInterval(
    function() {
      var et = new Date().getTime() - t0; // elapsed time
      if (et < t) {
        var f = et * fq; // constant velocity
        if (a == 1) f = Math.sin(f); // sine acceleration
        else if (a == 2) f = 1 - Math.cos(f); // cosine acceleration
        f = Math.abs(f);
        xOpacity(e, f * dx + o0); // instantaneous value
      }
      else {
        clearInterval(tmr);
        xOpacity(e, o); // target value
        if (typeof oe == 'function') oe(); // 'onEnd' handler
        else if (typeof oe == 'string') eval(oe);
      }
    }, 10 // timer resolution
  );
}
// xAniRgb r1, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAniRgb(e, p, c, t, a, oe)
{
  if (!(e=xGetElementById(e))) return;
  var c0 = xParseColor(xGetComputedStyle(e, p)); // start colors
  p = xCamelize(p);
  c = xParseColor(c); // target colors
  var d = { r: c.r - c0.r, g: c.g - c0.g, b: c.b - c0.b }; // color displacements
  var fq = 1 / t; // frequency
  if (a) fq *= (Math.PI / 2);
  var t0 = new Date().getTime(); // start time
  var tmr = setInterval(
    function() {
      var et = new Date().getTime() - t0; // elapsed time
      if (et < t) {
        var f = et * fq; // constant velocity
        if (a == 1) f = Math.sin(f); // sine acceleration
        else if (a == 2) f = 1 - Math.cos(f); // cosine acceleration
        f = Math.abs(f);
        e.style[p] = xRgbToHex( // instantaneous colors
          Math.round(f * d.r + c0.r),
          Math.round(f * d.g + c0.g),
          Math.round(f * d.b + c0.b));
      }
      else {
        clearInterval(tmr); // stop iterations
        e.style[p] = c.s; // target color
        if (typeof oe == 'function') oe(); // 'onEnd' handler
        else if (typeof oe == 'string') eval(oe);
      }
    }, 10 // timer interval
  );
}
// xAniXY r1, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAniXY(e, x, y, t)
{
  if (!(e=xGetElementById(e))) return;
  var x0 = xLeft(e), y0 = xTop(e); // start positions
  var dx = x - x0, dy = y - y0; // displacements
  var fq = 1 / t; // frequency
  var t0 = new Date().getTime(); // start time
  var tmr = setInterval(
    function() {
      var xi = x, yi = y;
      var et = new Date().getTime() - t0; // elapsed time
      if (et < t) {
        var f = et * fq; // constant velocity
        xi = f * dx + x0; // instantaneous positions
        yi = f * dy + y0;
      }
      else { clearInterval(tmr); }
      e.style.left = Math.round(xi) + 'px';
      e.style.top = Math.round(yi) + 'px';
    }, 10 // timer resolution
  );
}
// xAppendChild r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xAppendChild(oParent, oChild)
{
  if (oParent.appendChild) return oParent.appendChild(oChild);
  else return null;
}
// xBackground r4, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xBackground(e,c,i)
{
  if(!(e=xGetElementById(e))) return '';
  var bg='';
  if(e.style) {
    if(xStr(c)) {e.style.backgroundColor=c;}
    if(xStr(i)) {e.style.backgroundImage=(i!='')? 'url('+i+')' : null;}
    bg=e.style.backgroundColor;
  }
  return bg;
}
// xCamelize r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xCamelize(cssPropStr)
{
  var i, c, a = cssPropStr.split('-');
  var s = a[0];
  for (i=1; i<a.length; ++i) {
    c = a[i].charAt(0);
    s += a[i].replace(c, c.toUpperCase());
  }
  return s;
}
// xCapitalize r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

// Capitalize the first letter of every word in str.

function xCapitalize(str)
{
  var i, c, wd, s='', cap = true;
  
  for (i = 0; i < str.length; ++i) {
    c = str.charAt(i);
    wd = isWordDelim(c);
    if (wd) {
      cap = true;
    }  
    if (cap && !wd) {
      c = c.toUpperCase();
      cap = false;
    }
    s += c;
  }
  return s;

  function isWordDelim(c)
  {
    // add other word delimiters as needed
    // (for example '-' and other punctuation)
    return c == ' ' || c == '\n' || c == '\t';
  }
}
// xCardinalPosition r3, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xCardinalPosition(e, cp, margin, outside)
{
  if(!(e=xGetElementById(e))) return;
  if (typeof(cp)!='string'){window.status='xCardinalPosition error: cp=' + cp + ', id=' + e.id; return;}
  var x=xLeft(e), y=xTop(e), w=xWidth(e), h=xHeight(e);
  var pw,ph,p = e.offsetParent;
  if (p == document || p.nodeName.toLowerCase() == 'html') {pw = xClientWidth(); ph = xClientHeight();}
  else {pw=xWidth(p); ph=xHeight(p);}
  var sx=xScrollLeft(p), sy=xScrollTop(p);
  var right=sx + pw, bottom=sy + ph;
  var cenLeft=sx + Math.floor((pw-w)/2), cenTop=sy + Math.floor((ph-h)/2);
  if (!margin) margin=0;
  else{
    if (outside) margin=-margin;
    sx +=margin; sy +=margin; right -=margin; bottom -=margin;
  }
  switch (cp.toLowerCase()){
    case 'n': x=cenLeft; if (outside) y=sy - h; else y=sy; break;
    case 'ne': if (outside){x=right; y=sy - h;}else{x=right - w; y=sy;}break;
    case 'e': y=cenTop; if (outside) x=right; else x=right - w; break;
    case 'se': if (outside){x=right; y=bottom;}else{x=right - w; y=bottom - h}break;
    case 's': x=cenLeft; if (outside) y=sy - h; else y=bottom - h; break;
    case 'sw': if (outside){x=sx - w; y=bottom;}else{x=sx; y=bottom - h;}break;
    case 'w': y=cenTop; if (outside) x=sx - w; else x=sx; break;
    case 'nw': if (outside){x=sx - w; y=sy - h;}else{x=sx; y=sy;}break;
    case 'cen': x=cenLeft; y=cenTop; break;
    case 'cenh': x=cenLeft; break;
    case 'cenv': y=cenTop; break;
  }
  var o = new Object();
  o.x = x; o.y = y;
  return o;
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
// xClip r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xClip(e,t,r,b,l)
{
  if(!(e=xGetElementById(e))) return;
  if(e.style) {
    if (xNum(l)) e.style.clip='rect('+t+'px '+r+'px '+b+'px '+l+'px)';
    else e.style.clip='rect(0 '+parseInt(e.style.width)+'px '+parseInt(e.style.height)+'px 0)';
  }
}
// xColEqualizer r1, Original by moi. Modified by Mike Foster.
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xColEqualizer()
{
  var i, j, h = [];
  // get heights of columns' child elements
  for (i = 1, j = 0; i < arguments.length; i += 2, ++j)
  {
    h[j] = xHeight(arguments[i]);
  }
  h.sort(d);
  // set heights of column elements
  for (i = 0; i < arguments.length; i += 2)
  {
    xHeight(arguments[i], h[0]);
  }
  return h[0];
  // for a descending sort
  function d(a,b)
  {
    return b-a;
  }
}
// xColor r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xColor(e,s)
{
  if(!(e=xGetElementById(e))) return '';
  var c='';
  if(e.style && xDef(e.style.color)) {
    if(xStr(s)) e.style.color=s;
    c=e.style.color;
  }
  return c;
}
// xCreateElement r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xCreateElement(sTag)
{
  if (document.createElement) return document.createElement(sTag);
  else return null;
}
// xDef r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xDef()
{
  for(var i=0; i<arguments.length; ++i){if(typeof(arguments[i])=='undefined') return false;}
  return true;
}
// xDeg r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xDeg(rad)
{
  return rad * (180 / Math.PI);
}
// xDeleteCookie r4, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xDeleteCookie(name, path)
{
  if (xGetCookie(name)) {
    document.cookie = name + "=" +
                    "; path=" + ((!path) ? "/" : path) +
                    "; expires=" + new Date(0).toGMTString();
  }
}
// xDisableDrag r3, Copyright 2005-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xDisableDrag(id)
{
  xGetElementById(id).xDragEnabled = false;
}
// xDisableDrop r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xDisableDrop(id)
{
  xGetElementById(id).xDropEnabled = false;
}
// xDisplay r3, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

// This was alternative 1:

function xDisplay(e,s)
{
  if ((e=xGetElementById(e)) && e.style && xDef(e.style.display)) {
    if (xStr(s)) {
      try { e.style.display = s; }
      catch (ex) { e.style.display = ''; } // Will this make IE use a default value
    }                                      // appropriate for the element?
    return e.style.display;
  }
  return null;
}
// xDocSize r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xDocSize()
{
  var b=document.body, e=document.documentElement;
  var esw=0, eow=0, bsw=0, bow=0, esh=0, eoh=0, bsh=0, boh=0;
  if (e) {
    esw = e.scrollWidth;
    eow = e.offsetWidth;
    esh = e.scrollHeight;
    eoh = e.offsetHeight;
  }
  if (b) {
    bsw = b.scrollWidth;
    bow = b.offsetWidth;
    bsh = b.scrollHeight;
    boh = b.offsetHeight;
  }
//  alert('compatMode: ' + document.compatMode + '\n\ndocumentElement.scrollHeight: ' + esh + '\ndocumentElement.offsetHeight: ' + eoh + '\nbody.scrollHeight: ' + bsh + '\nbody.offsetHeight: ' + boh + '\n\ndocumentElement.scrollWidth: ' + esw + '\ndocumentElement.offsetWidth: ' + eow + '\nbody.scrollWidth: ' + bsw + '\nbody.offsetWidth: ' + bow);
  return {w:Math.max(esw,eow,bsw,bow),h:Math.max(esh,eoh,bsh,boh)};
}
// xEach r1, Copyright 2006-2007 Daniel Frechette
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

/**
 * Access each element of a collection sequentially (by its numeric index)
 * and do something with it.
 * @param c - Array/Obj - A collection of elements
 * @param f - Func      - Function to execute for each element.
 *                        Arguments: item, index, number of items
 * @param s - Int       - Start index. A number between 0 and collection size - 1. (optional)
 * @return Nothing
 */
function xEach(c, f, s) {
  var l = c.length;
  for (var i=(s || 0); i < l; i++) {
    f(c[i], i, l);
  }
};
// xEachUntilReturn r1, Copyright 2006-2007 Daniel Frechette
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

/**
 * Access each element of a collection sequentially (by its numeric index)
 * and do something with it. Stop when the called function returns a value.
 * @param c - Array/Obj - A collection of elements
 * @param f - Func      - Function to execute for each element
 *                        Arguments: item, index, number of items
 * @param s - Int       - Start index. A number between 0 and collection size - 1. (optional)
 * @return Any
 */

function xEachUntilReturn(c, f, s) {
  var r, l = c.length;
  for (var i=(s || 0); i < l; i++) {
    r = f(c[i], i, l);
    if (r !== undefined)
      break;
  }
  return r;
};
// xEditable r3, Copyright 2005-2007 Jerod Venema
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xEditable(container,trigger){

var editElement = null;
var container = xGetElementById(container);
var trigger = xGetElementById(trigger);
var newID = container.id + "_edit";
xAddEventListener(container, 'click', BeginEdit);

function BeginEdit(){
  if(!editElement){
    // create the input box
    editElement = document.createElement('input');
    editElement.setAttribute('id', newID);
    editElement.setAttribute('name', newID);
    // prep the inputbox with the current value
    editElement.setAttribute('value', container.innerHTML);
    // kills small gecko bug
    editElement.setAttribute('autocomplete','OFF');
    // setup events that occur when editing is done
    xAddEventListener(editElement, 'blur', EndEditClick);
    xAddEventListener(editElement, 'keypress', EndEditKey);
    // make room for the inputbox, then add it
    container.innerHTML = '';
    container.appendChild(editElement);
    editElement.select();
    editElement.focus();
  }else{
    editElement.select();
    editElement.focus();
  }
}
function EndEditClick(){
  // save the entered value, and kill the input field
  container.innerHTML = editElement.value;
  editElement = null;
}
function EndEditKey(evt){
  // save the entered value, and kill the input field, but ONLY on an enter
  var e = new xEvent(evt);
  if(e.keyCode == 13){
    container.innerHTML = editElement.value;
    editElement = null;
  }
}
}
// xEllipse r2, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xEllipse(e, xRadius, yRadius, radiusInc, totalTime, startAngle, stopAngle)
{
  if (!(e=xGetElementById(e))) return;
  if (!e.timeout) e.timeout = 25;
  e.xA = xRadius;
  e.yA = yRadius;
  e.radiusInc = radiusInc;
  e.slideTime = totalTime;
  startAngle *= (Math.PI / 180);
  stopAngle *= (Math.PI / 180);
  var startTime = (startAngle * e.slideTime) / (stopAngle - startAngle);
  e.stopTime = e.slideTime + startTime;
  e.B = (stopAngle - startAngle) / e.slideTime;
  e.xD = xLeft(e) - Math.round(e.xA * Math.cos(e.B * startTime)); // center point
  e.yD = xTop(e) - Math.round(e.yA * Math.sin(e.B * startTime)); 
  e.xTarget = Math.round(e.xA * Math.cos(e.B * e.stopTime) + e.xD); // end point
  e.yTarget = Math.round(e.yA * Math.sin(e.B * e.stopTime) + e.yD); 
  var d = new Date();
  e.C = d.getTime() - startTime;
  if (!e.moving) {e.stop=false; _xEllipse(e);}
}
function _xEllipse(e)
{
  if (!(e=xGetElementById(e))) return;
  var now, t, newY, newX;
  now = new Date();
  t = now.getTime() - e.C;
  if (e.stop) { e.moving = false; }
  else if (t < e.stopTime) {
    setTimeout("_xEllipse('"+e.id+"')", e.timeout);
    if (e.radiusInc) {
      e.xA += e.radiusInc;
      e.yA += e.radiusInc;
    }
    newX = Math.round(e.xA * Math.cos(e.B * t) + e.xD);
    newY = Math.round(e.yA * Math.sin(e.B * t) + e.yD);
    xMoveTo(e, newX, newY);
    e.moving = true;
  }  
  else {
    if (e.radiusInc) {
      e.xTarget = Math.round(e.xA * Math.cos(e.B * e.slideTime) + e.xD);
      e.yTarget = Math.round(e.yA * Math.sin(e.B * e.slideTime) + e.yD); 
    }
    xMoveTo(e, e.xTarget, e.yTarget);
    e.moving = false;
    if (e.onslideend) e.onslideend();
  }  
}
// xEnableDrag r7, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xEnableDrag(id,fS,fD,fE)
{
  var mx = 0, my = 0, el = xGetElementById(id);
  if (el) {
    el.xDragEnabled = true;
    xAddEventListener(el, 'mousedown', dragStart, false);
  }
  // Private Functions
  function dragStart(e)
  {
    if (el.xDragEnabled) {
      var ev = new xEvent(e);
      xPreventDefault(e);
      mx = ev.pageX;
      my = ev.pageY;
      xAddEventListener(document, 'mousemove', drag, false);
      xAddEventListener(document, 'mouseup', dragEnd, false);
      if (fS) {
        fS(el, ev.pageX, ev.pageY, ev);
      }
    }
  }
  function drag(e)
  {
    var ev, dx, dy;
    xPreventDefault(e);
    ev = new xEvent(e);
    dx = ev.pageX - mx;
    dy = ev.pageY - my;
    mx = ev.pageX;
    my = ev.pageY;
    if (fD) {
      fD(el, dx, dy, ev);
    }
    else {
      xMoveTo(el, el.offsetLeft + dx, el.offsetTop + dy);
    }
  }
  function dragEnd(e)
  {
    var ev = new xEvent(e);
    xPreventDefault(e);
    xRemoveEventListener(document, 'mouseup', dragEnd, false);
    xRemoveEventListener(document, 'mousemove', drag, false);
    if (fE) {
      fE(el, ev.pageX, ev.pageY, ev);
    }
    if (xEnableDrag.drop) {
      xEnableDrag.drop(el, ev);
    }
  }
}

xEnableDrag.drops = []; // static property
// xEnableDrag2 r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xEnableDrag2(id,fS,fD,fE,x1,y1,x2,y2)
{
  var b = null; // boundary element
  if (typeof x1 != 'undefined' && !x2) {
    b = xGetElementById(x1);
  }
  xEnableDrag(id,
    function (el, x, y, ev) { // dragStart
      if (b) { // get rect from current size of ele
        x1 = xPageX(b);
        y1 = xPageY(b);
        x2 = x1 + b.offsetWidth;
        y2 = y1 + b.offsetHeight;
      }
      if (fS) fS(el, x, y, ev);
    },
    function (el, dx, dy, ev) { // drag
      var x = xPageX(el) + dx; // absolute coords of target
      var y = xPageY(el) + dy;
      var mx = ev.pageX; // absolute coords of mouse
      var my = ev.pageY;
      if  (!(x < x1 || x + el.offsetWidth > x2) && !(mx < x1 || mx > x2)) {
        el.style.left = (el.offsetLeft + dx) + 'px';
      }
      if (!(y < y1 || y + el.offsetHeight > y2) && !(my < y1 || my > y2)) {
        el.style.top = (el.offsetTop + dy) + 'px';
      }
      if (fD) fD(el, dx, dy, ev);
    },
    function (el, x, y, ev) { // dragEnd
      if (fE) fE(el, x, y, ev);
    }
  );
}
// xEnableDrop r3, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xEnableDrop(id, f)
{
  var e = xGetElementById(id);
  if (e) {
    e.xDropEnabled = true;
    xEnableDrag.drops[xEnableDrag.drops.length] = {e:e, f:f};
  }
}

xEnableDrag.drop = function (el, ev) // static method
{
  var i, z, hz = 0, d = null, da = xEnableDrag.drops;
  for (i = 0; i < da.length; ++i) {
    if (da[i] && da[i].e.xDropEnabled && xHasPoint(da[i].e, ev.pageX, ev.pageY)) {
      z = parseInt(da[i].e.style.zIndex) || 0;
      if (z >= hz) {
        hz = z;
        d = da[i];
      } 
    }
  }
  if (d) {
    d.f(d.e, el, ev.pageX, ev.pageY); // drop event
  }
}
// xEvalTextarea r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xEvalTextarea()
{
  var f = document.createElement('FORM');
  f.onsubmit = 'return false';
  var t = document.createElement('TEXTAREA');
  t.id='xDebugTA';
  t.name='xDebugTA';
  t.rows='20';
  t.cols='60';
  var b = document.createElement('INPUT');
  b.type = 'button';
  b.value = 'Evaluate';
  b.onclick = function() {eval(this.form.xDebugTA.value);};
  f.appendChild(t);
  f.appendChild(b);
  document.body.appendChild(f);
}
// xFindAfterByClassName r1, Copyright 2005-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xFindAfterByClassName( ele, clsName )
{
  var re = new RegExp('\\b'+clsName+'\\b', 'i');
  return xWalkToLast( ele, function(n){if(n.className.search(re) != -1)return n;} );
}
// xFindBeforeByClassName r1, Copyright 2005-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xFindBeforeByClassName( ele, clsName )
{
  var re = new RegExp('\\b'+clsName+'\\b', 'i');
  return xWalkToFirst( ele, function(n){if(n.className.search(re) != -1)return n;} );
}
// xFirstChild r4, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xFirstChild(e,t)
{
  e = xGetElementById(e);
  var c = e ? e.firstChild : null;
  while (c) {
    if (c.nodeType == 1 && (!t || c.nodeName.toLowerCase() == t.toLowerCase())){break;}
    c = c.nextSibling;
  }
  return c;
}
// xGetCSSRules r1, Copyright 2006-2007 Ivan Pepelnjak (www.zaplana.net)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

//
// xGetCSSRules - extracts CSS rules from the style sheet object (IE vs. DOM CSS level 2)
//
function xGetCSSRules(ss) { return ss.rules ? ss.rules : ss.cssRules; }
// xGetComputedStyle r7, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetComputedStyle(e, p, i)
{
  if(!(e=xGetElementById(e))) return null;
  var s, v = 'undefined', dv = document.defaultView;
  if(dv && dv.getComputedStyle){
    s = dv.getComputedStyle(e,'');
    if (s) v = s.getPropertyValue(p);
  }
  else if(e.currentStyle) {
    v = e.currentStyle[xCamelize(p)];
  }
  else return null;
  return i ? (parseInt(v) || 0) : v;
}

// xGetCookie r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetCookie(name)
{
  var value=null, search=name+"=";
  if (document.cookie.length > 0) {
    var offset = document.cookie.indexOf(search);
    if (offset != -1) {
      offset += search.length;
      var end = document.cookie.indexOf(";", offset);
      if (end == -1) end = document.cookie.length;
      value = unescape(document.cookie.substring(offset, end));
    }
  }
  return value;
}
// xGetEleAtPoint r2, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetEleAtPoint(x, y)
{
  var he = null, z, hz = 0;
  var i, list = xGetElementsByTagName('*');
  for (i = 0; i < list.length; ++i) {
    if (xHasPoint(list[i], x, y)) {
      z = parseInt(list[i].style.zIndex);
      z = z || 0;
      if (z >= hz) {
        hz = z;
        he = list[i];
      } 
    }
  }
  return he;
}
// xGetElePropsArray r1, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetElePropsArray(ele, eleName)
{
  var u = 'undefined';
  var i = 0, a = new Array();
  
  nv('Element', eleName);
  nv('id', (xDef(ele.id) ? ele.id : u));
  nv('tagName', (xDef(ele.tagName) ? ele.tagName : u));

  nv('xWidth()', xWidth(ele));
  nv('style.width', (xDef(ele.style) && xDef(ele.style.width) ? ele.style.width : u));
  nv('offsetWidth', (xDef(ele.offsetWidth) ? ele.offsetWidth : u));
  nv('scrollWidth', (xDef(ele.offsetWidth) ? ele.offsetWidth : u));
  nv('clientWidth', (xDef(ele.clientWidth) ? ele.clientWidth : u));

  nv('xHeight()', xHeight(ele));
  nv('style.height', (xDef(ele.style) && xDef(ele.style.height) ? ele.style.height : u));
  nv('offsetHeight', (xDef(ele.offsetHeight) ? ele.offsetHeight : u));
  nv('scrollHeight', (xDef(ele.offsetHeight) ? ele.offsetHeight : u));
  nv('clientHeight', (xDef(ele.clientHeight) ? ele.clientHeight : u));

  nv('xLeft()', xLeft(ele));
  nv('style.left', (xDef(ele.style) && xDef(ele.style.left) ? ele.style.left : u));
  nv('offsetLeft', (xDef(ele.offsetLeft) ? ele.offsetLeft : u));
  nv('style.pixelLeft', (xDef(ele.style) && xDef(ele.style.pixelLeft) ? ele.style.pixelLeft : u));

  nv('xTop()', xTop(ele));
  nv('style.top', (xDef(ele.style) && xDef(ele.style.top) ? ele.style.top : u));
  nv('offsetTop', (xDef(ele.offsetTop) ? ele.offsetTop : u));
  nv('style.pixelTop', (xDef(ele.style) && xDef(ele.style.pixelTop) ? ele.style.pixelTop : u));

  nv('', '');
  nv('xGetComputedStyle()', '');

  nv('top');
  nv('right');
  nv('bottom');
  nv('left');

  nv('width');
  nv('height');

  nv('color');
  nv('background-color');
  nv('font-family');
  nv('font-size');
  nv('text-align');
  nv('line-height');
  nv('content');
  
  nv('float');
  nv('clear');

  nv('margin');
  nv('padding');
  nv('padding-top');
  nv('padding-right');
  nv('padding-bottom');
  nv('padding-left');

  nv('border-top-width');
  nv('border-right-width');
  nv('border-bottom-width');
  nv('border-left-width');

  nv('position');
  nv('overflow');
  nv('visibility');
  nv('display');
  nv('z-index');
  nv('clip');
  nv('cursor');

  return a;

  function nv(name, value)
  {
    a[i] = new Object();
    a[i].name = name;
    a[i].value = typeof(value)=='undefined' ? xGetComputedStyle(ele, name) : value;
    ++i;
  }
}
// xGetElePropsString r1, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetElePropsString(ele, eleName, newLine)
{
  var s = '', a = xGetElePropsArray(ele, eleName);
  for (var i = 0; i < a.length; ++i) {
    s += a[i].name + ' = ' + a[i].value + (newLine || '\n');
  }
  return s;
}
// xGetElementById r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetElementById(e)
{
  if(typeof(e)=='string') {
    if(document.getElementById) e=document.getElementById(e);
    else if(document.all) e=document.all[e];
    else e=null;
  }
  return e;
}
// xGetElementsByAttribute r2, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetElementsByAttribute(sTag, sAtt, sRE, fn)
{
  var a, list, found = new Array(), re = new RegExp(sRE, 'i');
  list = xGetElementsByTagName(sTag);
  for (var i = 0; i < list.length; ++i) {
    a = list[i].getAttribute(sAtt);
    if (!a) {a = list[i][sAtt];}
    if (typeof(a)=='string' && a.search(re) != -1) {
      found[found.length] = list[i];
      if (fn) fn(list[i]);
    }
  }
  return found;
}
// xGetElementsByClassName r5, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetElementsByClassName(c,p,t,f)
{
  var r = new Array();
  var re = new RegExp("(^|\\s)"+c+"(\\s|$)");
//  var e = p.getElementsByTagName(t);
  var e = xGetElementsByTagName(t,p); // See xml comments.
  for (var i = 0; i < e.length; ++i) {
    if (re.test(e[i].className)) {
      r[r.length] = e[i];
      if (f) f(e[i]);
    }
  }
  return r;
}
// xGetElementsByTagName r4, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetElementsByTagName(t,p)
{
  var list = null;
  t = t || '*';
  p = p || document;
  if (typeof p.getElementsByTagName != 'undefined') { // DOM1
    list = p.getElementsByTagName(t);
    if (t=='*' && (!list || !list.length)) list = p.all; // IE5 '*' bug
  }
  else { // IE4 object model
    if (t=='*') list = p.all;
    else if (p.all && p.all.tags) list = p.all.tags(t);
  }
  return list || new Array();
}
// xGetStyleSheetFromLink r1, Copyright 2006-2007 Ivan Pepelnjak (www.zaplana.net)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

//
// xGetStyleSheetFromLink - extracts style sheet object from the HTML LINK object (IE vs. DOM CSS level 2)
//
function xGetStyleSheetFromLink(cl) { return cl.styleSheet ? cl.styleSheet : cl.sheet; }

// xGetURLArguments r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xGetURLArguments()
{
  var idx = location.href.indexOf('?');
  var params = new Array();
  if (idx != -1) {
    var pairs = location.href.substring(idx+1, location.href.length).split('&');
    for (var i=0; i<pairs.length; i++) {
      nameVal = pairs[i].split('=');
      params[i] = nameVal[1];
      params[nameVal[0]] = nameVal[1];
    }
  }
  return params;
}
// xHasClass r3, Copyright 2005-2007 Daniel Frechette - modified by Mike Foster
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xHasClass(e, c)
{
  e = xGetElementById(e);
  if (!e || e.className=='') return false;
  var re = new RegExp("(^|\\s)"+c+"(\\s|$)");
  return re.test(e.className);
}
// xHasPoint r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xHasPoint(e,x,y,t,r,b,l)
{
  if (!xNum(t)){t=r=b=l=0;}
  else if (!xNum(r)){r=b=l=t;}
  else if (!xNum(b)){l=r; b=t;}
  var eX = xPageX(e), eY = xPageY(e);
  return (x >= eX + l && x <= eX + xWidth(e) - r &&
          y >= eY + t && y <= eY + xHeight(e) - b );
}
// xHasStyleSelector r1, Copyright 2006-2007 Ivan Pepelnjak (www.zaplana.net)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

//
// xHasStyleSelector(styleSelectorString)
//   checks whether any of the stylesheets attached to the document contain the definition of the specified
//   style selector (simple string matching at the moment)
//
// returns:
//   undefined  - style sheet scripting not supported by the browser
//   true/false - found/not found
//
function xHasStyleSelector(ss) {
  if (! xHasStyleSheets()) return undefined ;

  function testSelector(cr) {
    return cr.selectorText.indexOf(ss) >= 0;
  }
  return xTraverseDocumentStyleSheets(testSelector);
}
// xHasStyleSheets r1, Copyright 2006-2007 Ivan Pepelnjak (www.zaplana.net)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

//
// xHasStyleSheets - checks browser support for stylesheet related objects (IE or DOM compliant)
//
function xHasStyleSheets() {
  return document.styleSheets ? true : false ;
}
// xHeight r6, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xHeight(e,h)
{
  if(!(e=xGetElementById(e))) return 0;
  if (xNum(h)) {
    if (h<0) h = 0;
    else h=Math.round(h);
  }
  else h=-1;
  var css=xDef(e.style);
  if (e == document || e.tagName.toLowerCase() == 'html' || e.tagName.toLowerCase() == 'body') {
    h = xClientHeight();
  }
  else if(css && xDef(e.offsetHeight) && xStr(e.style.height)) {
    if(h>=0) {
      var pt=0,pb=0,bt=0,bb=0;
      if (document.compatMode=='CSS1Compat') {
        var gcs = xGetComputedStyle;
        pt=gcs(e,'padding-top',1);
        if (pt !== null) {
          pb=gcs(e,'padding-bottom',1);
          bt=gcs(e,'border-top-width',1);
          bb=gcs(e,'border-bottom-width',1);
        }
        // Should we try this as a last resort?
        // At this point getComputedStyle and currentStyle do not exist.
        else if(xDef(e.offsetHeight,e.style.height)){
          e.style.height=h+'px';
          pt=e.offsetHeight-h;
        }
      }
      h-=(pt+pb+bt+bb);
      if(isNaN(h)||h<0) return;
      else e.style.height=h+'px';
    }
    h=e.offsetHeight;
  }
  else if(css && xDef(e.style.pixelHeight)) {
    if(h>=0) e.style.pixelHeight=h;
    h=e.style.pixelHeight;
  }
  return h;
}
// xHex r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xHex(n, digits, prefix)
{
  var p = '', n = Math.ceil(n);
  if (prefix) p = prefix;
  n = n.toString(16);
  for (var i=0; i < digits - n.length; ++i) {
    p += '0';
  }
  return p + n;
}
// xHide r3, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xHide(e){return xVisibility(e,0);}
// xImgAsyncWait r2, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xImgAsyncWait(fnStatus, fnInit, fnError, sErrorImg, sAbortImg, imgArray)
{
  var i, imgs = imgArray || document.images;
  
  for (i = 0; i < imgs.length; ++i) {
    imgs[i].onload = imgOnLoad;
    imgs[i].onerror = imgOnError;
    imgs[i].onabort = imgOnAbort;
  }
  
  xIAW.fnStatus = fnStatus;
  xIAW.fnInit = fnInit;
  xIAW.fnError = fnError;
  xIAW.imgArray = imgArray;

  xIAW();

  function imgOnLoad()
  {
    this.wasLoaded = true;
  }
  function imgOnError()
  {
    if (sErrorImg && !this.wasError) {
      this.src = sErrorImg;
    }
    this.wasError = true;
  }
  function imgOnAbort()
  {
    if (sAbortImg && !this.wasAborted) {
      this.src = sAbortImg;
    }
    this.wasAborted = true;
  }
}
// end xImgAsyncWait()

// Don't call xIAW() directly. It is only called from xImgAsyncWait().

function xIAW()
{
  var me = arguments.callee;
  if (!me) {
    return; // I could have used a global object instead of callee
  }
  var i, imgs = me.imgArray ? me.imgArray : document.images;
  var c = 0, e = 0, a = 0, n = imgs.length;
  for (i = 0; i < n; ++i) {
    if (imgs[i].wasError) {
      ++e;
    }
    else if (imgs[i].wasAborted) {
      ++a;
    }
    else if (imgs[i].complete || imgs[i].wasLoaded) {
      ++c;
    }
  }
  if (me.fnStatus) {
    me.fnStatus(n, c, e, a);
  }
  if (c + e + a == n) {
    if ((e || a) && me.fnError) {
      me.fnError(n, c, e, a);
    }
    else if (me.fnInit) {
      me.fnInit();
    }
  }
  else setTimeout('xIAW()', 250);
}
// end xIAW()
// xImgRollSetup r3, Copyright 2002-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xImgRollSetup(p,s,x)
{
  var ele, id;
  for (var i=3; i<arguments.length; ++i) {
    id = arguments[i];
    if (ele = xGetElementById(id)) {
      ele.xIOU = p + id + x;
      ele.xIOO = new Image();
      ele.xIOO.src = p + id + s + x;
      ele.onmouseout = imgOnMouseout;
      ele.onmouseover = imgOnMouseover;
    }
  }
  function imgOnMouseout(e)
  {
    if (this.xIOU) {
      this.src = this.xIOU;
    }
  }
  function imgOnMouseover(e)
  {
    if (this.xIOO && this.xIOO.complete) {
      this.src = this.xIOO.src;
    }
  }
}
// xInnerHtml r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xInnerHtml(e,h)
{
  if(!(e=xGetElementById(e)) || !xStr(e.innerHTML)) return null;
  var s = e.innerHTML;
  if (xStr(h)) {e.innerHTML = h;}
  return s;
}
// xInsertRule r2, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xInsertRule(ss, sel, rule, idx)
{
  if (!(ss=xGetElementById(ss))) return false;
  if (ss.insertRule) { ss.insertRule(sel + "{" + rule + "}", (idx>=0?idx:ss.cssRules.length)); } // DOM
  else if (ss.addRule) { ss.addRule(sel, rule, idx); } // IE
  else return false;
  return true;
}
// xIntersection r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xIntersection(e1, e2, o)
{
  var ix1, iy2, iw, ih, intersect = true;
  var e1x1 = xPageX(e1);
  var e1x2 = e1x1 + xWidth(e1);
  var e1y1 = xPageY(e1);
  var e1y2 = e1y1 + xHeight(e1);
  var e2x1 = xPageX(e2);
  var e2x2 = e2x1 + xWidth(e2);
  var e2y1 = xPageY(e2);
  var e2y2 = e2y1 + xHeight(e2);
  // horizontal
  if (e1x1 <= e2x1) {
    ix1 = e2x1;
    if (e1x2 < e2x1) intersect = false;
    else iw = Math.min(e1x2, e2x2) - e2x1;
  }
  else {
    ix1 = e1x1;
    if (e2x2 < e1x1) intersect = false;
    else iw = Math.min(e1x2, e2x2) - e1x1;
  }
  // vertical
  if (e1y2 >= e2y2) {
    iy2 = e2y2;
    if (e1y1 > e2y2) intersect = false;
    else ih = e2y2 - Math.max(e1y1, e2y1);
  }
  else {
    iy2 = e1y2;
    if (e2y1 > e1y2) intersect = false;
    else ih = e1y2 - Math.max(e1y1, e2y1);
  }
  // intersected rectangle
  if (intersect && typeof(o)=='object') {
    o.x = ix1;
    o.y = iy2 - ih;
    o.w = iw;
    o.h = ih;
  }
  return intersect;
}
// xLeft r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xLeft(e, iX)
{
  if(!(e=xGetElementById(e))) return 0;
  var css=xDef(e.style);
  if (css && xStr(e.style.left)) {
    if(xNum(iX)) e.style.left=iX+'px';
    else {
      iX=parseInt(e.style.left);
      if(isNaN(iX)) iX=xGetComputedStyle(e,'left',1);
      if(isNaN(iX)) iX=0;
    }
  }
  else if(css && xDef(e.style.pixelLeft)) {
    if(xNum(iX)) e.style.pixelLeft=iX;
    else iX=e.style.pixelLeft;
  }
  return iX;
}
// xLinearScale r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xLinearScale(val,iL,iH,oL,oH)
{
  var m=(oH-oL)/(iH-iL);
  var b=oL-(iL*m);
  return m*val+b;
}
// xLoadScript r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xLoadScript(url)
{
  if (document.createElement && document.getElementsByTagName) {
    var s = document.createElement('script');
    var h = document.getElementsByTagName('head');
    if (s && h.length) {
      s.src = url;
      h[0].appendChild(s);
    }
  }
}
// xMoveTo r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xMoveTo(e,x,y)
{
  xLeft(e,x);
  xTop(e,y);
}
// xName r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xName(e)
{
  try {
    if (!e) return e;
    else if (e.id && e.id != "") return e.id;
    else if (e.name && e.name != "") return e.name;
    else if (e.nodeName && e.nodeName != "") return e.nodeName;
    else if (e.tagName && e.tagName != "") return e.tagName;
    else return e;
  }
  catch (err) {
    return e;
  }
}
// xNextSib r4, Copyright 2005-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xNextSib(e,t)
{
  e = xGetElementById(e);
  var s = e ? e.nextSibling : null;
  while (s) {
    if (s.nodeType == 1 && (!t || s.nodeName.toLowerCase() == t.toLowerCase())){break;}
    s = s.nextSibling;
  }
  return s;
}
// xNum r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xNum()
{
  for(var i=0; i<arguments.length; ++i){if(isNaN(arguments[i]) || typeof(arguments[i])!='number') return false;}
  return true;
}
// xOffsetLeft r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xOffsetLeft(e)
{
  if (!(e=xGetElementById(e))) return 0;
  if (xDef(e.offsetLeft)) return e.offsetLeft;
  else return 0;
}
// xOffsetTop r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xOffsetTop(e)
{
  if (!(e=xGetElementById(e))) return 0;
  if (xDef(e.offsetTop)) return e.offsetTop;
  else return 0;
}
// xOpacity r1, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xOpacity(e, o)
{
  var set = xDef(o);
  //  if (set && o == 1) o = .9999; // FF1.0.2 but not needed in 1.5
  if(!(e=xGetElementById(e))) return 2; // error
  if (xStr(e.style.opacity)) { // CSS3
    if (set) e.style.opacity = o + '';
    else o = parseFloat(e.style.opacity);
  }
  else if (xStr(e.style.filter)) { // IE5.5+
    if (set) e.style.filter = 'alpha(opacity=' + (100 * o) + ')';
    else if (e.filters && e.filters.alpha) { o = e.filters.alpha.opacity / 100; }
  }
  else if (xStr(e.style.MozOpacity)) { // Gecko before CSS3 support
    if (set) e.style.MozOpacity = o + '';
    else o = parseFloat(e.style.MozOpacity);
  }
  else if (xStr(e.style.KhtmlOpacity)) { // Konquerer and Safari
    if (set) e.style.KhtmlOpacity = o + '';
    else o = parseFloat(e.style.KhtmlOpacity);
  }
  return isNaN(o) ? 1 : o; // if NaN, should this return an error instead of 1?
}
// xPad r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xPad(s,len,c,left)
{
  if(typeof s != 'string') s=s+'';
  if(left) {for(var i=s.length; i<len; ++i) s=c+s;}
  else {for (var i=s.length; i<len; ++i) s+=c;}
  return s;
}
// xPageX r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xPageX(e)
{
  var x = 0;
  e = xGetElementById(e);
  while (e) {
    if (xDef(e.offsetLeft)) x += e.offsetLeft;
    e = xDef(e.offsetParent) ? e.offsetParent : null;
  }
  return x;
}
// xPageY r4, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xPageY(e)
{
  var y = 0;
  e = xGetElementById(e);
  while (e) {
    if (xDef(e.offsetTop)) y += e.offsetTop;
    e = xDef(e.offsetParent) ? e.offsetParent : null;
  }
  return y;
}
// xParaEq r4, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

// Animation with Parametric Equations

function xParaEq(e, xExpr, yExpr, totalTime)
{
  if (!(e=xGetElementById(e))) return;
  e.t = 0;
  e.tStep = .008;
  if (!e.timeout) e.timeout = 25;
  e.xExpr = xExpr;
  e.yExpr = yExpr;
  e.slideTime = totalTime;
  var d = new Date();
  e.C = d.getTime();
  if (!e.moving) {e.stop=false; _xParaEq(e);}
}
function _xParaEq(e)
{
  if (!(e=xGetElementById(e))) return;
  var now = new Date();
  var et = now.getTime() - e.C;
  e.t += e.tStep;
  t = e.t;
  if (e.stop) { e.moving = false; }
  else if (!e.slideTime || et < e.slideTime) {
    setTimeout("_xParaEq('"+e.id+"')", e.timeout);
    var p = e.offsetParent, centerX, centerY;
    centerX = (xWidth(p)/2)-(xWidth(e)/2);
    centerY = (xHeight(p)/2)-(xHeight(e)/2);
    e.xTarget = Math.round((eval(e.xExpr) * centerX) + centerX) + xScrollLeft(p);
    e.yTarget = Math.round((eval(e.yExpr) * centerY) + centerY) + xScrollTop(p);
    xMoveTo(e, e.xTarget, e.yTarget);
    e.moving = true;
  }  
  else {
    e.moving = false;
    if (e.onslideend) e.onslideend();
  }  
}
// xParent r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xParent(e, bNode)
{
  if (!(e=xGetElementById(e))) return null;
  var p=null;
  if (!bNode && xDef(e.offsetParent)) p=e.offsetParent;
  else if (xDef(e.parentNode)) p=e.parentNode;
  else if (xDef(e.parentElement)) p=e.parentElement;
  return p;
}
// xParentChain r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xParentChain(e,delim,bNode)
{
  if (!(e=xGetElementById(e))) return;
  var lim=100, s = "", d = delim || "\n";
  while(e) {
    s += xName(e) + ', ofsL:'+e.offsetLeft + ', ofsT:'+e.offsetTop + d;
    e = e.parentNode;
    if (!lim--) break;
  }
  return s;
}
// xParentNode 1, Copyright 2005-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xParentNode( ele, n )
{
  while(ele&&n--){ele=ele.parentNode;}
  return ele;
}
// xParseColor r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xParseColor(c)
{
  var o = {};
  if (xStr(c)) {
    if (c.indexOf('rgb')!=-1) {
      var a = c.match(/(\d*)\s*,\s*(\d*)\s*,\s*(\d*)/);
      o.r = parseInt(a[1]) || 0;
      o.g = parseInt(a[2]) || 0;
      o.b = parseInt(a[3]) || 0;
      o.n = (o.r << 16) | (o.g << 8) | o.b;
    }
    else {
      pn(parseInt(c.substr(1), 16));
    }
  }
  else {
    pn(c);
  }
  o.s = xHex(o.n, 6, '#');
  return o;
  function pn(n) { // parse num
    o.n = n || 0;
    o.r = (o.n & 0xFF0000) >> 16;
    o.g = (o.n & 0xFF00) >> 8;
    o.b = o.n & 0xFF;
  }
}
// xPrevSib r4, Copyright 2005-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xPrevSib(e,t)
{
  e = xGetElementById(e);
  var s = e ? e.previousSibling : null;
  while (s) {
    if (s.nodeType == 1 && (!t || s.nodeName.toLowerCase() == t.toLowerCase())){break;}
    s = s.previousSibling;
  }
  return s;
}
// xPreventDefault r1, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xPreventDefault(e)
{
  if (e && e.preventDefault) e.preventDefault();
  else if (window.event) window.event.returnValue = false;
}
// xRad r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xRad(deg)
{
  return deg*(Math.PI/180);
}
// xRemoveClass r3, Copyright 2005-2007 Daniel Frechette - modified by Mike Foster
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xRemoveClass(e, c)
{
  if(!(e=xGetElementById(e))) return false;
  e.className = e.className.replace(new RegExp("(^|\\s)"+c+"(\\s|$)",'g'),
    function(str, p1, p2) { return (p1 == ' ' && p2 == ' ') ? ' ' : ''; }
  );
  return true;
}
// xRemoveEventListener r6, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xRemoveEventListener(e,eT,eL,cap)
{
  if(!(e=xGetElementById(e)))return;
  eT=eT.toLowerCase();
  if(e.removeEventListener)e.removeEventListener(eT,eL,cap||false);
  else if(e.detachEvent)e.detachEvent('on'+eT,eL);
  else e['on'+eT]=null;
}
// xRemoveEventListener2 r4, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xRemoveEventListener2(e,eT,eL,cap)
{
  if(!(e=xGetElementById(e))) return;
  eT=eT.toLowerCase();
  if(e==window) {
    if(eT=='resize' && e.xREL) {e.xREL=null; return;}
    if(eT=='scroll' && e.xSEL) {e.xSEL=null; return;}
  }
  if(e.removeEventListener) e.removeEventListener(eT,eL,cap||false);
  else if(e.detachEvent) e.detachEvent('on'+eT,eL);
  else e['on'+eT]=null;
}
// xResizeTo r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xResizeTo(e,w,h)
{
  xWidth(e,w);
  xHeight(e,h);
}
// xRgbToHex r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xRgbToHex(r, g, b)
{
  return xHex((r << 16) | (g << 8) | b, 6, '#');
}
// xScrollLeft r3, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xScrollLeft(e, bWin)
{
  var offset=0;
  if (!xDef(e) || bWin || e == document || e.tagName.toLowerCase() == 'html' || e.tagName.toLowerCase() == 'body') {
    var w = window;
    if (bWin && e) w = e;
    if(w.document.documentElement && w.document.documentElement.scrollLeft) offset=w.document.documentElement.scrollLeft;
    else if(w.document.body && xDef(w.document.body.scrollLeft)) offset=w.document.body.scrollLeft;
  }
  else {
    e = xGetElementById(e);
    if (e && xNum(e.scrollLeft)) offset = e.scrollLeft;
  }
  return offset;
}
// xScrollTop r3, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xScrollTop(e, bWin)
{
  var offset=0;
  if (!xDef(e) || bWin || e == document || e.tagName.toLowerCase() == 'html' || e.tagName.toLowerCase() == 'body') {
    var w = window;
    if (bWin && e) w = e;
    if(w.document.documentElement && w.document.documentElement.scrollTop) offset=w.document.documentElement.scrollTop;
    else if(w.document.body && xDef(w.document.body.scrollTop)) offset=w.document.body.scrollTop;
  }
  else {
    e = xGetElementById(e);
    if (e && xNum(e.scrollTop)) offset = e.scrollTop;
  }
  return offset;
}
// xSetCookie r3, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSetCookie(name, value, expire, path)
{
  document.cookie = name + "=" + escape(value) +
                    ((!expire) ? "" : ("; expires=" + expire.toGMTString())) +
                    "; path=" + ((!path) ? "/" : path);
}
// xSetIETitle r3, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSetIETitle()
{
  var ua = navigator.userAgent.toLowerCase();
  if (!window.opera && navigator.vendor!='KDE' && document.all && ua.indexOf('msie')!=-1 && !document.layers) {
    var i = ua.indexOf('msie') + 1;
    var v = ua.substr(i + 4, 3);
    document.title = 'IE ' + v + ' - ' + document.title;
  }
}
// xShow r3, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xShow(e) {return xVisibility(e,1);}
// xSlideCornerTo r3, Copyright 2005-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSlideCornerTo(e, corner, targetX, targetY, totalTime)
{
  if (!(e=xGetElementById(e))) return;
  if (!e.timeout) e.timeout = 25;
  e.xT = targetX;
  e.yT = targetY;
  e.slideTime = totalTime;
  e.corner = corner.toLowerCase();
  e.stop = false;
  switch(e.corner) { // A = distance, D = initial position
    case 'nw': e.xA = e.xT - xLeft(e); e.yA = e.yT - xTop(e); e.xD = xLeft(e); e.yD = xTop(e); break;
    case 'sw': e.xA = e.xT - xLeft(e); e.yA = e.yT - (xTop(e) + xHeight(e)); e.xD = xLeft(e); e.yD = xTop(e) + xHeight(e); break;
    case 'ne': e.xA = e.xT - (xLeft(e) + xWidth(e)); e.yA = e.yT - xTop(e); e.xD = xLeft(e) + xWidth(e); e.yD = xTop(e); break;
    case 'se': e.xA = e.xT - (xLeft(e) + xWidth(e)); e.yA = e.yT - (xTop(e) + xHeight(e)); e.xD = xLeft(e) + xWidth(e); e.yD = xTop(e) + xHeight(e); break;
    default: alert("xSlideCornerTo: Invalid corner"); return;
  }
  if (e.slideLinear) e.B = 1/e.slideTime;
  else e.B = Math.PI / (2 * e.slideTime); // B = period
  var d = new Date();
  e.C = d.getTime();
  if (!e.moving) _xSlideCornerTo(e);
}

function _xSlideCornerTo(e)
{
  if (!(e=xGetElementById(e))) return;
  var now, seX, seY;
  now = new Date();
  t = now.getTime() - e.C;
  if (e.stop) { e.moving = false; e.stop = false; return; }
  else if (t < e.slideTime) {
    setTimeout("_xSlideCornerTo('"+e.id+"')", e.timeout);

    s = e.B * t;
    if (!e.slideLinear) s = Math.sin(s);
//    if (e.slideLinear) s = e.B * t;
//    else s = Math.sin(e.B * t);

    newX = Math.round(e.xA * s + e.xD);
    newY = Math.round(e.yA * s + e.yD);
  }
  else { newX = e.xT; newY = e.yT; }  
  seX = xLeft(e) + xWidth(e);
  seY = xTop(e) + xHeight(e);
  switch(e.corner) {
    case 'nw': xMoveTo(e, newX, newY); xResizeTo(e, seX - xLeft(e), seY - xTop(e)); break;
    case 'sw': if (e.xT != xLeft(e)) { xLeft(e, newX); xWidth(e, seX - xLeft(e)); } xHeight(e, newY - xTop(e)); break;
    case 'ne': xWidth(e, newX - xLeft(e)); if (e.yT != xTop(e)) { xTop(e, newY); xHeight(e, seY - xTop(e)); } break;
    case 'se': xWidth(e, newX - xLeft(e)); xHeight(e, newY - xTop(e)); break;
    default: e.stop = true;
  }
  e.moving = true;
  if (t >= e.slideTime) {
    e.moving = false;
    if (e.onslideend) e.onslideend();
  }
}
// xSlideTo r3, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSlideTo(e, x, y, uTime)
{
  if (!(e=xGetElementById(e))) return;
  if (!e.timeout) e.timeout = 25;
  e.xTarget = x; e.yTarget = y; e.slideTime = uTime; e.stop = false;
  e.yA = e.yTarget - xTop(e); e.xA = e.xTarget - xLeft(e); // A = distance
  if (e.slideLinear) e.B = 1/e.slideTime;
  else e.B = Math.PI / (2 * e.slideTime); // B = period
  e.yD = xTop(e); e.xD = xLeft(e); // D = initial position
  var d = new Date(); e.C = d.getTime();
  if (!e.moving) _xSlideTo(e);
}
function _xSlideTo(e)
{
  if (!(e=xGetElementById(e))) return;
  var now, s, t, newY, newX;
  now = new Date();
  t = now.getTime() - e.C;
  if (e.stop) { e.moving = false; }
  else if (t < e.slideTime) {
    setTimeout("_xSlideTo('"+e.id+"')", e.timeout);

    s = e.B * t;
    if (!e.slideLinear) s = Math.sin(s);
//    if (e.slideLinear) s = e.B * t;
//    else s = Math.sin(e.B * t);

    newX = Math.round(e.xA * s + e.xD);
    newY = Math.round(e.yA * s + e.yD);
    xMoveTo(e, newX, newY);
    e.moving = true;
  }  
  else {
    xMoveTo(e, e.xTarget, e.yTarget);
    e.moving = false;
    if (e.onslideend) e.onslideend();
  }  
}

// xSmartLoad r1, Copyright 2007 Chris Nelson, based on xSmartLoadScript by Brendan Richards
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSmartLoad(what, url)
{
  var loadedBefore = false;
  var s;

  for (var i=0; i<xSmartLoad.list.length; i++) {
    if (xSmartLoad.list[i].url == url) {
      loadedBefore = true;
      s = xSmartLoad.list[i].node;
      break;
    }
  }
  if (document.createElement && document.getElementsByTagName && !loadedBefore) {
    s = document.createElement(what);
    var h = document.getElementsByTagName('head');
    if (s && h.length) {
      switch (what.toUpperCase()) {
      case 'SCRIPT':
        s.src = url;
        break;
      case 'LINK':
        s.rel = 'stylesheet';
        s.type = 'text/css';
        s.href = url;
        break;
      default:
        s = null;
        break;
      }
      h[0].appendChild(s);
      xSmartLoad.list[xSmartLoad.list.length] = {url:url, node:s};
    }
  }
  return s;
}

xSmartLoad.list = []; // static property of xSmartLoad
// xSmartLoad2 r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSmartLoad2(what, url1, url2, url3, etc)
{
  var u, i, j, s, h, loaded, c = 0, e = what.toLowerCase();
  if (document.createElement && document.getElementsByTagName) {
    h = document.getElementsByTagName('head');
    if (h.length && h[0].appendChild) {
      for (i = 1; i < arguments.length; ++i) {
        loaded = false;
        u = arguments[i];
        for (j = 0; j < xSmartLoad2.list.length; j++) {
          if (xSmartLoad2.list[j] == u) {
            loaded = true;
            break; // for (j
          }
        }
        if (!loaded) {
          s = document.createElement(e);
          if (s) {
            switch (e) {
            case 'script':
              s.type = 'text/javascript';
              s.src = u;
              break;
            case 'link':
              s.rel = 'stylesheet';
              s.type = 'text/css';
              s.href = u;
              break;
            default:
              continue; // for (i
            }
            h[0].appendChild(s);
            xSmartLoad2.list[xSmartLoad2.list.length] = u;
            ++c;
          }
        }
      }
    }
  }
  return c;
}

xSmartLoad2.list = []; // static property of xSmartLoad2
// xSmartLoadScript r2, Copyright 2005-2007 Brendan Richards
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xSmartLoadScript(url)
{
  xSmartLoad('script', url);
}
// xStopPropagation r1, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xStopPropagation(evt)
{
  if (evt && evt.stopPropagation) evt.stopPropagation();
  else if (window.event) window.event.cancelBubble = true;
}
// xStr r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xStr(s)
{
  for(var i=0; i<arguments.length; ++i){if(typeof(arguments[i])!='string') return false;}
  return true;
}
// xStrEndsWith r1, Copyright 2004-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xStrEndsWith( s, end )
{
  if( !xStr(s,end) ) return false;
  var l = s.length;
  var r = l - end.length;
  if( r > 0 ) return s.substring( r, l ) == end;
  return s == end;
}
// xStrReplaceEnd r1, Copyright 2004-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xStrReplaceEnd( s, newEnd )
{
  if( !xStr(s,newEnd) ) return s;
  var l = s.length;
  var r = l - newEnd.length;
  if( r > 0 ) return s.substring( 0, r )+newEnd;
  return newEnd;
}
// xStrStartsWith r2, Copyright 2004-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xStrStartsWith( s, beg )
{
  if( !xStr(s,beg) ) return false;
  var l = s.length;
  var r = beg.length;
  if( r > l ) return false;
  if( r < l ) return s.substring( 0, r ) == beg;
  return s == beg;
}
// xStyle r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xStyle(sProp, sVal)
{
  var i, e;
  for (i = 2; i < arguments.length; ++i) {
    e = xGetElementById(arguments[i]);
    if (e.style) {
      try { e.style[sProp] = sVal; }
      catch (err) { e.style[sProp] = ''; } // ???
    }
  }
}
// xTableCellVisibility r1, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTableCellVisibility(bShow, sec, nRow, nCol)
{
  sec = xGetElementById(sec);
  if (sec && nRow < sec.rows.length && nCol < sec.rows[nRow].cells.length) {
    sec.rows[nRow].cells[nCol].style.visibility = bShow ? 'visible' : 'hidden';
  }
}
// xTableColDisplay r3, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTableColDisplay(bShow, sec, nCol)
{
  var r;
  sec = xGetElementById(sec);
  if (sec && nCol < sec.rows[0].cells.length) {
    for (r = 0; r < sec.rows.length; ++r) {
      sec.rows[r].cells[nCol].style.display = bShow ? '' : 'none';
    }
  }
}
// xTableIterate r1, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTableIterate(sec, fnCallback, data)
{
  var r, c;
  sec = xGetElementById(sec);
  if (!sec || !fnCallback) { return; }
  for (r = 0; r < sec.rows.length; ++r) {
    if (false == fnCallback(sec.rows[r], true, r, c, data)) { return; }
    for (c = 0; c < sec.rows[r].cells.length; ++c) {
      if (false == fnCallback(sec.rows[r].cells[c], false, r, c, data)) { return; }
    }
  }
}

// xTableRowDisplay r1, Copyright 2004-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTableRowDisplay(bShow, sec, nRow)
{
  sec = xGetElementById(sec);
  if (sec && nRow < sec.rows.length) {
    sec.rows[nRow].style.display = bShow ? '' : 'none';
  }
}
// xTableSync r2, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTableSync(sT1Id, sT2Id, sEvent, fn)
{
  var t1 = xGetElementById(sT1Id);
  var t2 = xGetElementById(sT2Id);
  sEvent = 'on' + sEvent.toLowerCase();
  t1[sEvent] = t2[sEvent] = function(e)
  {
    e = e || window.event;
    var t = e.target || e.srcElement;
    while (t && t.nodeName.toLowerCase() != 'td') {
      t = t.parentNode;
    }
    if (t) {
      var r = t.parentNode.sectionRowIndex, c = t.cellIndex; // this may not be very cross-browser
      var tbl = xGetElementById(this.id == sT1Id ? sT2Id : sT1Id); // 'this' points to a table
      fn(t, tbl.rows[r].cells[c]);
    }
  };
  // r2
  t1 = t2 = null; // Does this remove the circular refs even tho the closure remains?
  /*
  xAddEventListener(window, 'unload',
    function() {
      t1[sEvent] = t2[sEvent] = null;
      t1 = t2 = null;
    }, false
  );
  */
}
// xTimes r2, Copyright 2006-2007 Daniel Frechette
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

/**
 * Call a function n times.
 * @param n - Int  - Number of times f is called
 * @param f - Func - Function to execute (can accept an index value from 0 to n-1)
 * @param s - Int  - Start index (0 if null or not present)
 * @return Nothing
 */
function xTimes(n, f, s) {
  s = s || 0;
  n = n + s;
  for (var i=s; i < n; i++)
    f(i);
};
// xToggleClass r2, Copyright 2005-2007 Daniel Frechette
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

/* Added by DF, 2005-10-11
 * Toggles a class name on or off for an element
 */
function xToggleClass(e, c) {
  if (!(e = xGetElementById(e)))
    return null;
  if (!xRemoveClass(e, c) && !xAddClass(e, c))
    return false;
  return true;
}
// xTop r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTop(e, iY)
{
  if(!(e=xGetElementById(e))) return 0;
  var css=xDef(e.style);
  if(css && xStr(e.style.top)) {
    if(xNum(iY)) e.style.top=iY+'px';
    else {
      iY=parseInt(e.style.top);
      if(isNaN(iY)) iY=xGetComputedStyle(e,'top',1);
      if(isNaN(iY)) iY=0;
    }
  }
  else if(css && xDef(e.style.pixelTop)) {
    if(xNum(iY)) e.style.pixelTop=iY;
    else iY=e.style.pixelTop;
  }
  return iY;
}
// xTraverseDocumentStyleSheets r1, Copyright 2006-2007 Ivan Pepelnjak (www.zaplana.net)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

//
// xTraverseDocumentStyleSheets(callback)
//   traverses all stylesheets attached to a document (linked as well as internal)
//
function xTraverseDocumentStyleSheets(cb) {
  var ssList = document.styleSheets; if (!ssList) return undefined;

  for (i = 0; i < ssList.length; i++) {
    var ss = ssList[i] ; if (! ss) continue;
    if (xTraverseStyleSheet(ss,cb)) return true;
  }
  return false;
}
// xTraverseStyleSheet r1, Copyright 2006-2007 Ivan Pepelnjak (www.zaplana.net)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

//
// xTraverseStyleSheet (stylesheet, callback)
//   traverses all rules in the stylesheet, calling callback function on each rule.
//   recursively handles stylesheets imported with @import CSS directive
//   stops when the callback function returns true (it has found what it's been looking for)
//
// returns:
//   undefined - problems with CSS-related objects
//   true      - callback function returned true at least once
//   false     - callback function always returned false
//
function xTraverseStyleSheet(ss,cb) {
  if (!ss) return false;
  var rls = xGetCSSRules(ss) ; if (!rls) return undefined ;
  var result;

  for (var j = 0; j < rls.length; j++) {
    var cr = rls[j];
    if (cr.selectorText) { result = cb(cr); if (result) return true; }
    if (cr.type && cr.type == 3 && cr.styleSheet) xTraverseStyleSheet(cr.styleSheet,cb);
  }
  if (ss.imports) {
    for (var j = 0 ; j < ss.imports.length; j++) {
      if (xTraverseStyleSheet(ss.imports[j],cb)) return true;
    }
  }
  return false;
}
// xTrim r1, Copyright 2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xTrim(s) {
  return s.replace(/^\s+|\s+$/g, '');
}
// xVisibility r1, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xVisibility(e, bShow)
{
  if(!(e=xGetElementById(e))) return null;
  if(e.style && xDef(e.style.visibility)) {
    if (xDef(bShow)) e.style.visibility = bShow ? 'visible' : 'hidden';
    return e.style.visibility;
  }
  return null;
}

//function xVisibility(e,s)
//{
//  if(!(e=xGetElementById(e))) return null;
//  var v = 'visible', h = 'hidden';
//  if(e.style && xDef(e.style.visibility)) {
//    if (xDef(s)) {
//      // try to maintain backwards compatibility (???)
//      if (xStr(s)) e.style.visibility = s;
//      else e.style.visibility = s ? v : h;
//    }
//    return e.style.visibility;
//    // or...
//    // if (e.style.visibility.length) return e.style.visibility;
//    // else return xGetComputedStyle(e, 'visibility');
//  }
//  else if (xDef(e.visibility)) { // NN4
//    if (xDef(s)) {
//      // try to maintain backwards compatibility
//      if (xStr(s)) e.visibility = (s == v) ? 'show' : 'hide';
//      else e.visibility = s ? v : h;
//    }
//    return (e.visibility == 'show') ? v : h;
//  }
//  return null;
//}
// xWalkToFirst r1, Copyright 2005-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xWalkToFirst( oNode, fnVisit, skip, data )
{
  var r = null;
  while(oNode)
  {
    if(oNode.nodeType==1&&oNode!=skip){r=fnVisit(oNode,data);if(r)return r;}
    var n=oNode;
    while(n=n.previousSibling){if(n!=skip){r=xWalkTreeRev(n,fnVisit,skip,data);if(r)return r;}}
    oNode=oNode.parentNode;
  }
  return r;
}
// xWalkToLast r1, Copyright 2005-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xWalkToLast( oNode, fnVisit, skip, data )
{
  var r = null;
  if( oNode )
  {
    r=xWalkTree2(oNode,fnVisit,skip,data);if(r)return r;
    while(oNode)
    {
      var n=oNode;
      while(n=n.nextSibling){if(n!=skip){r=xWalkTree2(n,fnVisit,skip,data);if(r)return r;}}
      oNode=oNode.parentNode;
    }
  }
  return r;
}
// xWalkTree r2, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xWalkTree(n, f)
{
  f(n);
  for (var c = n.firstChild; c; c = c.nextSibling) {
    if (c.nodeType == 1) xWalkTree(c, f);
  }
}
// xWalkTree2 r1, Copyright 2005-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

// My humble contribution to the great cross-browser xLibrary file x_dom.js
//
// This function is compatible with Mike's but adds:
// - 'fnVisit' can return a non null object to stop the walk. This result will be returned to caller.
// See function xFindAfterByClassName below: it uses it.
// - 'fnVisit' accept one optional 'data' parameter
// - 'skip' is an optional element that will be ignored during traversal. It is often useful to skip
// the starting node: when skip == oNode, 'fnVisit' is not called but, of course, child are processed.
//
function xWalkTree2( oNode, fnVisit, skip, data )
{
  var r=null;
  if(oNode){if(oNode.nodeType==1&&oNode!=skip){r=fnVisit(oNode,data);if(r)return r;}
  for(var c=oNode.firstChild;c;c=c.nextSibling){if(c!=skip)r  =xWalkTree2(c,fnVisit,skip,data);if(r)return r;}}
  return r;
}
// xWalkTree3 r3, Copyright 2005-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xWalkTree3(n,f,d,l,b)
{
  if (typeof l == 'undefined') l = 0;
  if (typeof b == 'undefined') b = 0;
  var v = f(n,l,b,d);
  if (!v) return 0;
  if (v == 1) {
    for (var c = n.firstChild; c; c = c.nextSibling) {
      if (c.nodeType == 1) {
        if (!l) ++b;
        if (!xWalkTree3(c,f,d,l+1,b)) return 0;
      }
    }
  }
  return 1;
}
// xWalkTreeRev r2, Copyright 2005-2007 Olivier Spinelli
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

//
// Same as xWalkTree2 except that traversal is reversed (last to first child).
//
function xWalkTreeRev( oNode, fnVisit, skip, data )
{
  var r=null;
  if(oNode){if(oNode.nodeType==1&&oNode!=skip){r=fnVisit(oNode,data);if(r)return r;}
  for(var c=oNode.lastChild;c;c=c.previousSibling){if(c!=skip)r=xWalkTreeRev(c,fnVisit,skip,data);if(r)return r;}}
  return r;
}
// xWalkUL r3, Copyright 2006-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xWalkUL(pu,d,f,lv)
{
  var r,cu,li=xFirstChild(pu);
  if (!lv){lv=0;}
  while(li){
    cu=xFirstChild(li,'ul');
    r=f(pu,li,cu,d,lv);
    if(cu){if(!r||!xWalkUL(cu,d,f,lv+1)){return 0;};}
    li=xNextSib(li);
  }
  return 1;
}
// xWidth r6, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xWidth(e,w)
{
  if(!(e=xGetElementById(e))) return 0;
  if (xNum(w)) {
    if (w<0) w = 0;
    else w=Math.round(w);
  }
  else w=-1;
  var css=xDef(e.style);
  if (e == document || e.tagName.toLowerCase() == 'html' || e.tagName.toLowerCase() == 'body') {
    w = xClientWidth();
  }
  else if(css && xDef(e.offsetWidth) && xStr(e.style.width)) {
    if(w>=0) {
      var pl=0,pr=0,bl=0,br=0;
      if (document.compatMode=='CSS1Compat') {
        var gcs = xGetComputedStyle;
        pl=gcs(e,'padding-left',1);
        if (pl !== null) {
          pr=gcs(e,'padding-right',1);
          bl=gcs(e,'border-left-width',1);
          br=gcs(e,'border-right-width',1);
        }
        // Should we try this as a last resort?
        // At this point getComputedStyle and currentStyle do not exist.
        else if(xDef(e.offsetWidth,e.style.width)){
          e.style.width=w+'px';
          pl=e.offsetWidth-w;
        }
      }
      w-=(pl+pr+bl+br);
      if(isNaN(w)||w<0) return;
      else e.style.width=w+'px';
    }
    w=e.offsetWidth;
  }
  else if(css && xDef(e.style.pixelWidth)) {
    if(w>=0) e.style.pixelWidth=w;
    w=e.style.pixelWidth;
  }
  return w;
}
// xWinOpen r1, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

// A simple alternative to xWindow.

var xChildWindow = null;
function xWinOpen(sUrl)
{
  var features = "left=0,top=0,width=600,height=500,location=0,menubar=0," +
    "resizable=1,scrollbars=1,status=0,toolbar=0";
  if (xChildWindow && !xChildWindow.closed) {xChildWindow.location.href  = sUrl;}
  else {xChildWindow = window.open(sUrl, "myWinName", features);}
  xChildWindow.focus();
  return false;
}
// xWinScrollTo r3, Copyright 2003-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

var xWinScrollWin = null;
function xWinScrollTo(win,x,y,uTime) {
  var e = win;
  if (!e.timeout) e.timeout = 25;
  var st = xScrollTop(e, 1);
  var sl = xScrollLeft(e, 1);
  e.xTarget = x; e.yTarget = y; e.slideTime = uTime; e.stop = false;
  e.yA = e.yTarget - st;
  e.xA = e.xTarget - sl; // A = distance
  if (e.slideLinear) e.B = 1/e.slideTime;
  else e.B = Math.PI / (2 * e.slideTime); // B = period
  e.yD = st;
  e.xD = sl; // D = initial position
  var d = new Date(); e.C = d.getTime();
  if (!e.moving) {
    xWinScrollWin = e;
    _xWinScrollTo();
  }
}
function _xWinScrollTo() {
  var e = xWinScrollWin || window;
  var now, s, t, newY, newX;
  now = new Date();
  t = now.getTime() - e.C;
  if (e.stop) { e.moving = false; }
  else if (t < e.slideTime) {
    setTimeout("_xWinScrollTo()", e.timeout);

    s = e.B * t;
    if (!e.slideLinear) s = Math.sin(s);
//    if (e.slideLinear) s = e.B * t;
//    else s = Math.sin(e.B * t);

    newX = Math.round(e.xA * s + e.xD);
    newY = Math.round(e.yA * s + e.yD);
    e.scrollTo(newX, newY);
    e.moving = true;
  }  
  else {
    e.scrollTo(e.xTarget, e.yTarget);
    xWinScrollWin = null;
    e.moving = false;
    if (e.onslideend) e.onslideend();
  }  
}
// xZIndex r1, Copyright 2001-2007 Michael Foster (Cross-Browser.com)
// Part of X, a Cross-Browser Javascript Library, Distributed under the terms of the GNU LGPL

function xZIndex(e,uZ)
{
  if(!(e=xGetElementById(e))) return 0;
  if(e.style && xDef(e.style.zIndex)) {
    if(xNum(uZ)) e.style.zIndex=uZ;
    uZ=parseInt(e.style.zIndex);
  }
  return uZ;
}
