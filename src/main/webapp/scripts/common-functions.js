
/* JQuery Extensions */

/*
jQuery.fn.outerHTML = function() {
	return jQuery('<div />').append(this.eq(0).clone()).html();
};
*/

jQuery.fn.extend({
	
	outerHTML : function() {
		return jQuery('<div />').append(this.eq(0).clone()).html();
	},
	
	
	/* Div Slide */
	
	slideRightShow : function() {
		return this.each(function() {
			$(this).show('slide', { direction : 'right' }, 1000);
		});
	},
	
	slideLeftHide : function() {
		return this.each(function() {
			$(this).hide('slide', { direction : 'left' }, 1000);
		});
	},
	
	slideRightHide : function() {
		return this.each(function() {
			$(this).hide('slide', { direction : 'right' }, 1000);
		});
	},
	
	slideLeftShow : function() {
		return this.each(function() {
			$(this).show('slide', { direction : 'left' }, 1000);
		});
	},

	
	/* CheckBox */

	check : function() {
		return $(this).each(function(){
			var element = $(this);
			var type = element.attr('type');
			if(type == 'radio' || type == 'checkbox') {
				this.checked = true;
				$(this).trigger('updateState');
			}
		});
	},
	
	uncheck : function() {
		return $(this).each(function(value){
			var element = $(this);
			var type = element.attr('type');
			if(type == 'radio' || type == 'checkbox') {
				this.checked = false;
				$(this).trigger('updateState');
			}
		});
	}
	
	
});


jQuery.fn.customTabs = function() {
	return this.each( function () {
		var tabs = $(this).find('.tab');
		
		// Selecting Default tab
		tabs.each( function() {
			var i = $(this).attr('id');
			$('#' + i + '-tab').hide();
		});
		var defau = $(this).find('.tab.sel').attr('id') + '-tab'; 
		$('#' + defau).show();
		
		// tab click function
		tabs.bind('click', function (){
			var currentTab = $(this);
			var id = currentTab.attr('id');
			var tabId = id + '-tab';
			
			// onClick - selecting a tab
			if (!currentTab.hasClass('sel'))
				currentTab.toggleClass('sel');
			
			$('#' + tabId).show();
			
			// onClick - de-selecting all other tabs
			var remainTabs = tabs.not(currentTab);
			remainTabs.each( function() {
				var rTab = $(this);
				var rid = rTab.attr('id');
				var rTabId = rid + '-tab';
				
				if (rTab.hasClass('sel'))
					rTab.toggleClass('sel');
				
				$('#' + rTabId).hide();
			});

		});
	});
};




/* Window Resize .. */

function adjustBodyToWindowDimensions(){
	
	var bodyCont = $('#body-cont');
	
	var width = $(window).width();
	var height = $(window).height();
	
	if ( width > 1300 ) {
		bodyCont.css({ 'margin' : '0 auto' });
	} else {
		bodyCont.css({ 'margin' : '0 50px' });
	}
	
};

function preventEventDefaults(event) {
//	event.stopImmediatePropagation();
	event.stopPropagation();
    event.preventDefault();
    return false;
};


/* Notifications */

function showNotificationMsg( msgType, msgText, autoHide ) {
	switch (msgType) {
		case 'alert':
			
			break;
			
		case 'success':
			
			break;
			
		case 'error':
			
			break;

		case 'status':
			
			break;
			
		default:
			break;
	}
	
	var notifBox = $('#notification-box');
	notifBox.attr('class', msgType);
	
	var notifCont = $('#notification-cont');
	notifCont.find('.msg-text').html(msgText);
	
	notifCont.show('fade');
	
	if(autoHide || autoHide == null) {
		setTimeout(function() {
			notifCont.hide('fade');
		}, 2500);
	}
	
};

/* Supporting Methods */

function getAbsoluteCoordinates(element){
    
	var r = {
        x: element.offsetLeft,
        y: element.offsetTop
    };
    
    if (element.offsetParent) {
        var tmp = getAbsoluteCoordinates(element.offsetParent);
        r.x += tmp.x;
        r.y += tmp.y;
    }
    
    return r;
    
};



