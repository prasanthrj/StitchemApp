// Pop-up

$.widget("ui.customPopUp", {
	_create : function() {
		if (this.element) {
			this.element.hide();

			// Draggable
			if (this.options.draggable) {
				this.element.draggable({
					containment : 'window',
					cursor : 'move',
					handle : '.pu-header',
					snapMode : 'outer'
				});
			}

			// AutoOpen clause
			if (this.options.autoOpen) {
				this.open();
			}

			return this.element;
		}
	},
	options : {
		modal : true,
		autoOpen : false,
		draggable : true
	},
	_prepareOverlay : function() {
		var overlayDiv = $('div#overlay-cont');
		if (!overlayDiv || overlayDiv.length == 0) {
			overlayDiv = $('<div id="overlay-cont"></div>');
			overlayDiv.appendTo(document.body);
		}
		overlayDiv.css({
			width : this._width(),
			height : this._height()
		});

		return overlayDiv.hide();
	},

	_removeOverlay : function() {
		var overlayDiv = $('div#overlay-cont');
		if (overlayDiv && overlayDiv.length != 0) {
			overlayDiv.remove();
		}
	},

	open : function() {
		// Modal true clause
		if (this.options.modal) {
			var overlayDiv = this._prepareOverlay();
			overlayDiv.show();
		}
		this.element.show();
	},

	close : function() {
		this._removeOverlay();
		this.element.hide();
	},

	_height : function() {
		var scrollHeight, offsetHeight;
		// handle IE 6
		if ($.browser.msie && $.browser.version < 7) {
			scrollHeight = Math.max(document.documentElement.scrollHeight,
					document.body.scrollHeight);
			offsetHeight = Math.max(document.documentElement.offsetHeight,
					document.body.offsetHeight);

			if (scrollHeight < offsetHeight) {
				return $(window).height() + 'px';
			} else {
				return scrollHeight + 'px';
			}
			// handle "good" browsers
		} else {
			return $(document).height() + 'px';
		}
	},

	_width : function() {
		var scrollWidth, offsetWidth;
		// handle IE 6
		if ($.browser.msie && $.browser.version < 7) {
			scrollWidth = Math.max(document.documentElement.scrollWidth,
					document.body.scrollWidth);
			offsetWidth = Math.max(document.documentElement.offsetWidth,
					document.body.offsetWidth);

			if (scrollWidth < offsetWidth) {
				return $(window).width() + 'px';
			} else {
				return scrollWidth + 'px';
			}
			// handle "good" browsers
		} else {
			return $(document).width() + 'px';
		}
	}

});




/**
 * Its a Tab Structure
 * @usage tabs are divs with Ids and corresponding tab blocks are divs with id as the corresponding tab Id with a suffix "-tab"
 * Can used directly on the Block-Object in which tabs are written 
 */
$.fn.customTabs = function() {
	return this.each( function () {
		
		var tabExt = '-opt';
		var tabs = $(this).find('.tab');
		
		// Selecting Default tab
		tabs.each( function() {
			var i = $(this).attr('id');
			$('#' + i + tabExt).hide();
		});
		var defau = $(this).find('.tab.sel').attr('id') + tabExt; 
		$('#' + defau).show();
		
		// tab click function
		tabs.live('click', function (){
			
			var currentTab = $(this);
			var id = currentTab.attr('id');
			var tabId = id + tabExt;
			
			// onClick - de-selecting all other tabs
			var remainTabs = tabs.not(currentTab);
			remainTabs.each( function() {
				var rTab = $(this);
				var rid = rTab.attr('id');
				var rTabId = rid + tabExt;
				
				rTab.removeClass('sel');
				$('#' + rTabId).hide();
			});
			
			// onClick - selecting a tab
			currentTab.addClass('sel');
			$('#' + tabId).show();

		});
	});
};
