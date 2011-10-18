/*
* WC :: Console :: DOM - DOM methods
* (C) 2008 Nickolay Kovalev, http://resume.nickola.ru
* E-mail: nickola_code@nickola.ru
* @FILE_STATUS: READY_OK
*/
if (typeof WC == "undefined") { alert("WC.DOM: Error - object WC is not defiend, maybe 'WC CORE' is not loaded"); }
else { WC.namespace('DOM'); }

// Registering 'insertAdjacentElement' method
WC.DOM.REGISTER_insertAdjacentElement = function() {
	// Adding 'insertAdjacentElement' function for browsers that haven't it
	if(typeof HTMLElement!="undefined") {
		if (!HTMLElement.prototype.insertAdjacentElement) {
			HTMLElement.prototype.insertAdjacentElement = function(where, parsedNode) {
				switch (where) {
					case 'beforeBegin':
						this.parentNode.insertBefore(parsedNode, this);
						break;
					case 'afterBegin':
						this.insertBefore(parsedNode, this.firstChild);
						break;
					case 'beforeEnd':
						this.appendChild(parsedNode);
						break;
					case 'afterEnd':
						if (this.nextSibling) this.parentNode.insertBefore(parsedNode, this.nextSibling);
						else this.parentNode.appendChild(parsedNode);
						break;
				};
			};
		}
		if (!HTMLElement.prototype.insertAdjacentHTML) {
			HTMLElement.prototype.insertAdjacentHTML = function(where, htmlStr) {
				var r = this.ownerDocument.createRange();
				r.setStartBefore(this);
				var parsedHTML = r.createContextualFragment(htmlStr);
				this.insertAdjacentElement(where, parsedHTML);
			};
		}
		if (!HTMLElement.prototype.insertAdjacentText) {
			HTMLElement.prototype.insertAdjacentText = function(where, txtStr) {
				var parsedText = document.createTextNode(txtStr);
				this.insertAdjacentElement(where, parsedText);
			};
		}
	}
};
