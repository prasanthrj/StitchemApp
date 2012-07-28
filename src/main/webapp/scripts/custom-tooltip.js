$.widget("ui.customToolTip",{
	
	_create : function(){
		if(this.element){
			
			$('.' + this.options.toolTipContentClass).hide();
			
			// Setting the Cont 
			var toolTipCont = $('#' + this.options.toolTipContId);
			if(!toolTipCont || toolTipCont.length == 0) {
				this._appendToolTipContToBody();
				toolTipCont = $('#' + this.options.toolTipContId);
			}
			this.options.toolTipCont = toolTipCont;
			
			// closing tooltip
//			toolTipCont.find('.close-tt').live('click',function(){
//				toolTipCont.hide('fade');
//			});
			
			toolTipCont.css({
				'position' : 'absolute',
				'z-index' : this.options.zIndex,
				'min-width' : this.options.minWidth,
				'max-width' : this.options.maxWidth
			});
			
			// pre-load function
			this.options.preLoadFunc(this.element);
			
			// Attaching the events
			if(this.options.onEvent == 'hover') {
				this._addMouseHoverEvents();
			} else if (this.options.onEvent == 'click') {
				this._addMouseClickEvents();
			}
			
			// post-load function
			this.options.postLoadFunc(this.element);
			
			return this.element;
		}
	},
	
	options : {
		// Event
		onEvent : 'hover',
		
		// classes to pick
		toolTipHeadClass : 'tooltip-header',
		toolTipContentClass : 'tooltip-content',
		
		// Position
		zIndex : 100,
		top : null,
		left : null,
		right : null,
		bottom : null,
		
		autoPosition : false,
		
		maxWidth : '250px',
		minWidth : '150px',
		
		// Callbacks
		preLoadFunc : function(element){},
		postLoadFunc : function(element){},
		
		// Container
		toolTipContId : 'tt-cont',
		toolTipCont : null,
		
	},
	
	_appendToolTipContToBody : function(){
		var ttContHtml = '<div id="' + this.options.toolTipContId + '" style="display: none;">';
//		ttContHtml += '<div id="tt-head"><a href="javascript:void(0)" class="close-tt">X</a></div>';
//		ttContHtml += '<div id="tt-body"></div>';
		ttContHtml += '</div>';
		$("body").append(ttContHtml);
	},
	
	_addMouseHoverEvents : function() {
		
		var toolTipCont = this.options.toolTipCont;
		var element = $(this.element);
		
		var head = element.find('.' + this.options.toolTipHeadClass);
		if(head == null || !(head.length > 0))
			head = element;

		head.hover(
			function(event) {
				element.customToolTip('show');
			},
			function(event) {
				setTimeout(function() {
					toolTipCont.hide('fade');
				}, 5000);
			}
		);
		
	},
	
	_addMouseClickEvents : function() {
		
		var toolTipCont = this.options.toolTipCont;
		var element = $(this.element);
		
		var head = element.find('.' + this.options.toolTipHeadClass);
		if(head == null || !(head.length > 0))
			head = element;

		head.click(function(event) {
			
			event.stopPropagation();
		    event.preventDefault();
			
			element.customToolTip('show');
			
//			setTimeout(function() {
//				toolTipCont.hide('fade');
//			}, 3000);
			
		});
		
	},
	
	_calculateContPosition : function(toolTipCont, currElement) {
		
		// Window dimensions 
		var windowW = window.innerWidth;
		var windowH = window.innerHeight;
		
		// ToolTipCont dimensions 
		var contW = toolTipCont.width();
		var contH = toolTipCont.height();
		
		// Current Element dimensions 
		var elemX = currElement.offset().left;
		var elemY = currElement.offset().top;
		
		var remX = eval(windowW - elemX);
		var remY = eval(windowH - elemY);
		
		if(remX < contW) {
			elemX = eval(elemX - currElement.outerWidth(true) - contW);
		} else {
			elemX = eval(elemX + currElement.outerWidth(true));
		}
		
		if(remY < contH) {
			elemY = eval(windowH - contH);
		} else {
			elemY = eval(elemY);
		}
		
		var position = {};
		position.top = elemY;
		position.left = elemX;
		
		return position;
	},
	
	show : function (){
		var toolTipCont = this.options.toolTipCont;
		var element = $(this.element);
		
		var	position = {};
		if(this.options.autoPosition) {
			position = this._calculateContPosition(toolTipCont, element);
		} else {
			if(this.options.top) position.top = eval(element.offset().top + this.options.top);
			if(this.options.left) position.left = eval(element.offset().left + this.options.left);
			if(this.options.right != null) 
				position.right = eval(window.innerWidth - element.offset().left - element.width() + this.options.right);
			if(this.options.bottom) 
				position.bottom = eval(window.innerHeight - element.offset().top - element.height() + this.options.bottom);
		}
		
		var content = element.find('.' + this.options.toolTipContentClass).html();
		
		var onEvent = this.options.onEvent;
		toolTipCont.html(content);
		toolTipCont.css(position);
		toolTipCont.show('fade');
	},
	
	hide : function (){
		var toolTipCont = this.optio09ns.toolTipCont;
		toolTipCont.hide();
	},
	
	destroy : function (){
		this.element.unbind('mouseover mouseout');
		this.element.unbind('mouseenter mouseleave');  // For i.e.
		this.element.unbind('focus');
		
		this.element.data('customToolTip', null);
		return this.element;
	}
	
});
