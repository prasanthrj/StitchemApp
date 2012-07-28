


function prepareCanvasToolsForPage( currPagePkey ){
	
	var canvas = document.getElementById( canVasElementId );
	var canvasElem = $(canvas);
	
	var paint = false;
	
	redraw();
	
	canvasElem.mousedown(function(e) {
		clickX = new Array();
		clickY = new Array();
		clickDrag = new Array();
					
		var mouseX = e.pageX - getAbsoluteCoordinates(this).x;
		var mouseY = e.pageY - getAbsoluteCoordinates(this).y;
		
		paint = true;
		addClick(mouseX, mouseY);
		
		redraw();
	});
	
	canvasElem.mousemove(function(e) {
		if (paint) {
			var mouseX = e.pageX - getAbsoluteCoordinates(this).x;
			var mouseY = e.pageY - getAbsoluteCoordinates(this).y;
			
			addClick(mouseX, mouseY, true);
			
			redraw();
		}
	});
	
	canvasElem.mouseleave(function(e) {
		paint = false;
	});
	
	canvasElem.mouseup(function(e) {
		paint = false;
		
		if(clickDrag && clickDrag[1]) {
			resetHotSpotCreateForm();
			
			var hotSpot = {};
			
			var fromX = clickX[0];
			var fromY = clickY[0];
			var toX = clickX[1];
			var toY = clickY[1];
			
			if(toX < fromX) {
				fromX = clickX[1];
				toX = clickX[0];
			}
			
			if(toY < fromY) {
				fromY = clickY[1];
				toY = clickY[0];
			}
			
			hotSpot.fromX = fromX / scaledWidth;
			hotSpot.fromY = fromY / scaledHeight;
			hotSpot.toX = toX / scaledWidth;
			hotSpot.toY = toY / scaledHeight;
			
			setHotSpotCoordinates( hotSpot );
			
			clearCanvas();
			drawDivHotSpot( hotSpot, true );
			
			prepareHotSpotForEditing();
			prepareNewHotSpotCreation(hotSpot);
			
		}
	});

	function addClick(x, y, dragging) {
		var index = 0;
		
		if (dragging) 
			index = 1;
		
//		 TODO fix this 20 
		clickX[index] = x - 20;
		clickY[index] = y - 20;
//		clickX[index] = x - 10;
//		clickY[index] = y - 10;
		clickDrag[index] = dragging;
		
	};
	
	function redraw() {
		clearCanvas();	// Clears the canvas 
		for ( var i = 0; i < clickX.length; i++) {

			// do it only when its a drag 
			if (clickDrag[i] && i) {
				
				var hotSpot = {};
				hotSpot.fromX = clickX[0] / scaledWidth;
				hotSpot.fromY = clickY[0] / scaledHeight;
				hotSpot.toX = clickX[i] / scaledWidth;
				hotSpot.toY = clickY[i] / scaledHeight;
				
				drawCanvasHotSpot(hotSpot , defFillStyle);
				
			} 
		}
	};

	drawAllHotSpots(currentHotSpots);
	
};


function clearCanvasMarker(){
	
	var	canvas = document.getElementById(canVasElementId);
	var canvasElem = $(canvas);
	
	canvasElem.unbind('mousedown mousemove mouseup mouseleave');	
	
	canvasElem.unbind('mouseover mouseout'); 
	canvasElem.unbind('mouseenter mouseleave');  // For i.e.
	
	clearCanvas();
	
};

function clearCanvas(){
	var	canvas = document.getElementById(canVasElementId);
	canvas.width = canvas.width; // Clears the canvas 
};

function clearAreaInCanvas( x1, y1, x2, y2 ){
	
	var	canvas = document.getElementById(canVasElementId);
	var context = canvas.getContext("2d");
	
	this.x1 = parseInt(x1);
	this.y1 = parseInt(y1);
	this.x2 = parseInt(x2);
	this.y2 = parseInt(y2);
	
	context.clearRect(this.x1, this.y1, this.x2 - this.x1, this.y2 - this.y1);
	
};

function setHotSpotCoordinates( hotSpot, hotSpotDiv ) {

	if( !hotSpot ) {
		var hsDiv = $(hotSpotDiv);
		
		hotSpot = {};
		hotSpot.fromX = hsDiv.position().left / scaledWidth;
		hotSpot.fromY = hsDiv.position().top / scaledHeight;
		hotSpot.toX = hotSpot.fromX + hsDiv.width() / scaledWidth;
		hotSpot.toY = hotSpot.fromY + hsDiv.height() / scaledHeight;
	}
	
	var hotSpotCreateEditForm = $('#hotSpotCreateEditForm');
	
	hotSpotCreateEditForm.find('input[name$="fromX"]').attr('value', hotSpot.fromX );
	hotSpotCreateEditForm.find('input[name$="fromY"]').attr('value', hotSpot.fromY );
	hotSpotCreateEditForm.find('input[name$="toX"]').attr('value', hotSpot.toX );
	hotSpotCreateEditForm.find('input[name$="toY"]').attr('value', hotSpot.toY );
	
	
	// Hot Spots Coordinates 
	
	var hotSpotCoordinatesForm = $('#hotSpotCoordinatesForm');
	
	hotSpotCoordinatesForm.find('input[name$="fromX"]').attr('value', hotSpot.fromX );
	hotSpotCoordinatesForm.find('input[name$="fromY"]').attr('value', hotSpot.fromY );
	hotSpotCoordinatesForm.find('input[name$="toX"]').attr('value', hotSpot.toX );
	hotSpotCoordinatesForm.find('input[name$="toY"]').attr('value', hotSpot.toY );
	
};

function drawCanvasHotSpot(hotSpot, fillStyle) {
	if(hotSpot){
		
		var	canvas = document.getElementById(canVasElementId);
		var context = canvas.getContext("2d");
		
		context.strokeStyle = "#000000";
		context.lineWidth = 2;
		
		if(!fillStyle)
			fillStyle = defFillStyle;
		
		var x1 = hotSpot.fromX * scaledWidth;
		var y1 = hotSpot.fromY * scaledHeight;
		var x2 = hotSpot.toX * scaledWidth;
		var y2 = hotSpot.toY * scaledHeight;
		
		context.dashedRectangleWithFillColor(  x1, y1, x2, y2, null, fillStyle );
	}
};

function drawDivHotSpot( hotSpot, isEditable ){
	if(hotSpot){
		
		var x1 = hotSpot.fromX * scaledWidth;
		var y1 = hotSpot.fromY * scaledHeight;
		var x2 = hotSpot.toX * scaledWidth;
		var y2 = hotSpot.toY * scaledHeight;
		
		var divWidth = x2-x1;
		var divHeight = y2-y1;
		
		var hotSpotDivId = hsDivPrefix + hotSpot.pkey;
		var hotSpotDiv = $('#' + hotSpotDivId );
		
		if( hotSpotDiv.length == 0 ) {
			var hotSpotDivHtml = '<div id="' + hotSpotDivId + '" class="div-hotspot hotspot-element" hs-pkey="' + hotSpot.pkey + '">';
			hotSpotDivHtml += '<input type="hidden" name="hotSpotPkey" value="' + hotSpot.pkey + '">';
			
			hotSpotDivHtml += '<div class="tooltip-content" style="display: none;">';
			hotSpotDivHtml += '<div class="pos-rel hs-tt-content">';
			hotSpotDivHtml += '<a class="bin-icon hs-delete-btn" hot-spot-pkey="' + hotSpot.pkey + '"></a>';
			if(hotSpot.uiEvents){
				var uiEvents = hotSpot.uiEvents;
				for ( var i = 0; i < uiEvents.length; i++) {
					hotSpotDivHtml += '<a class="hotspots-icon margin-5px hs-link-btn" to-page-pkey="' + uiEvents[i].toPage.pkey + '" ></a>';
				}
			}
			hotSpotDivHtml += '</div>';
			hotSpotDivHtml += '</div>';
			
			hotSpotDivHtml += '</div>';
			
			$('#' + hotSpotsHolderId ).append(hotSpotDivHtml);
			hotSpotDiv = $('#' + hotSpotDivId );
		}
		
		var fillStyle = defFillStyle;
	
		hotSpotDiv.resizable({
			disabled: false,
			handles: 'n, e, s, w, ne, se, sw, nw',
			create: function(event, ui) { event.stopImmediatePropagation(); event.preventDefault(); return false; },
			start: function(event, ui) { event.stopImmediatePropagation(); event.preventDefault(); return false; },
			resize: function(event, ui) { event.stopImmediatePropagation(); event.preventDefault(); return false; },
			stop: function(event, ui) { 
				event.stopImmediatePropagation();
				event.preventDefault();
				
				setHotSpotCoordinates( null, this );
				prepareHotSpotForEditing();
				
				if(hotSpot && hotSpot.pkey)
					saveHotSpotCoordinates(hotSpot);
				
				return false;
			} 
		});
		
		hotSpotDiv.draggable({
			disabled: false,
			containment: 'parent',
			create: function(event, ui) { event.stopImmediatePropagation(); event.preventDefault(); return false; },
			start: function(event, ui) { event.stopImmediatePropagation(); event.preventDefault(); return false; },
			drag: function(event, ui) { event.stopImmediatePropagation(); event.preventDefault(); return false; },
			stop: function(event, ui) {
				event.stopImmediatePropagation();
				event.preventDefault();
				
				setHotSpotCoordinates( null, this );
				prepareHotSpotForEditing();
				
				if(hotSpot && hotSpot.pkey)
					saveHotSpotCoordinates(hotSpot);

				return false;
			} 
		});
		
		fillStyle = editFillStyle;
			
		hotSpotDiv.css({
			'left' : x1,
			'top' : y1,
			'width' : divWidth,
			'height' : divHeight,
			'background-color' : fillStyle,
		});

	}
};

function prepareNewHotSpotCreation(hotSpot) {
	
	
};


function drawAllHotSpots(hotSpots) {
	if(hotSpots && hotSpots.length > 0) {
		for(var i = 0; i < hotSpots.length; i++) {
			var hotSpot = hotSpots[i];
			drawDivHotSpot(hotSpot, false);
		}
	}
};

function loadDetailsOfHotSpot( hotSpotPkey, element ){
	if (hotSpotPkey && element) {
		
		$('.curr-hotspot-pkey').attr('value', hotSpotPkey);
		
		var hsCont = $('#' + hsContPrefix + hotSpotPkey );
		var hsDiv = $('#' + hsDivPrefix + hotSpotPkey );
		
		// Selecting the elements
		hsCont.siblings('li').each(function(){
			$(this).removeClass('selected').find('div.hotspot-events-cont').slideUp('slow');;
		}); 
		hsCont.addClass('selected').find('div.hotspot-events-cont').slideDown('slow');;
			
		hsDiv.parent('div').find('div').removeClass('selected');
		hsDiv.addClass('selected');
		
		
		// Drawin hot spots .. 
		var hotSpot = fetchHotSpotByPkey(hotSpotPkey);
		drawAllHotSpots(currentHotSpots);
		drawDivHotSpot( hotSpot, true );
		
		resetHotSpotCreateForm();
		prepareHotSpotCreateForm( hotSpotPkey );
		
		prepareHotSpotForEditing();
		
	}
};

function prepareHotSpotForEditing() {
	
	var hotSpotsEdit = $('#hotspots-edit');
	var hotSpotsInfo = $('#hotspots-info');
	
	hotSpotsInfo.slideUp('slow', function(){
		hotSpotsEdit.slideDown('slow');
	});
	
};


function resetHotSpotCreateForm(){
	
	var hotSpotCreateEditForm = $('#hotSpotCreateEditForm');
	
	$('.hot-spot-pkey').val('');
	
	hotSpotCreateEditForm.find('input[name$=fromX]').val('');
	hotSpotCreateEditForm.find('input[name$=fromY]').val('');
	hotSpotCreateEditForm.find('input[name$=toX]').val('');
	hotSpotCreateEditForm.find('input[name$=toY]').val('');
	
	hotSpotCreateEditForm.find('input[name$=title]').val('');
	hotSpotCreateEditForm.find('input[name$=description]').val('');
	hotSpotCreateEditForm.find('input[name$=hotSpotType]').val('');
	
	
	// reset the events list .. 
	var eventDivs = hotSpotCreateEditForm.find('.new-event-div');
	while( eventDivs.length > 1 ) {
		$(eventDivs[eventDivs.length - 1]).remove();
		eventDivs = hotSpotCreateEditForm.find('.new-event-div');
	};
	
	var eventDiv = $(eventDivs[0]);
	eventDiv.find('select[name*=toPage]').val('');
	eventDiv.find('select[name$=transitionType]').val('none');
	eventDiv.find('select[name$=eventType]').val('tap');
	
};

function prepareHotSpotCreateForm( hotSpotPkey ){
	if(hotSpotPkey) {
		
		var hotSpotCreateEditForm = $('#hotSpotCreateEditForm');
		var hotSpot = fetchHotSpotByPkey(hotSpotPkey);
		
		$('.hot-spot-pkey').val(hotSpot.pkey);
		
		hotSpotCreateEditForm.find('input[name$=fromX]').val(hotSpot.fromX);
		hotSpotCreateEditForm.find('input[name$=fromY]').val(hotSpot.fromY);
		hotSpotCreateEditForm.find('input[name$=toX]').val(hotSpot.toX);
		hotSpotCreateEditForm.find('input[name$=toY]').val(hotSpot.toY);
		
		hotSpotCreateEditForm.find('input[name$=title]').val(hotSpot.title);
		hotSpotCreateEditForm.find('input[name$=description]').val(hotSpot.description);
		hotSpotCreateEditForm.find('input[name$=hotSpotType]').val(hotSpot.hotSpotType);
		
		// UiEvents handling .... 
		var eventDivs = hotSpotCreateEditForm.find('.new-event-div');
		var uiEvents = hotSpot.uiEvents;
		for ( var i = 0; i < uiEvents.length; i++) {
			var uiEvent = uiEvents[i];
			var eventDiv = $(eventDivs[i]);
			if(!eventDiv || !( eventDiv.length > 0 ) ){
				$('.new-event-div:last').after($('.new-event-div:last').clone());
				eventDiv = $('.new-event-div:last');
			}
			
			var oldIndex = parseInt(eventDiv.attr('index'));

			eventDiv.attr('index', i);
			eventDiv.find('[name^=uiEvents]').each(function(){
				var name = $(this).attr('name');	
				name = name.replace('[' + oldIndex + ']', '[' + i + ']');
				$(this).attr('name', name);
			});
			 
			eventDiv.find('input.ui-event-pkey').val(uiEvent.pkey);
			eventDiv.find('select[name*=toPage]').val(uiEvent.toPage.pkey);
			eventDiv.find('select[name$=transitionType]').val(uiEvent.transitionType);
			eventDiv.find('select[name$=eventType]').val(uiEvent.eventType);						
			
		}
		
		if(uiEvents.length > 1){
			$('#new-events-li .bin-icon').show();
		}
		
	}
	
};

function fetchHotSpotByPkey (hotSpotPkey) {
	
	var hotSpotContId = hsContPrefix + hotSpotPkey;
	var hotSpot = currentHotSpotsMap[hotSpotContId];
	
	if(!hotSpot) {

		// get hotspot using its hotSpotPkey ... 
		var fetchHotSpotUrl = '<%= request.getContextPath() %>/project/build/edit_hot_spot?hotSpot.pkey=' + hotSpotPkey ;
		$.getJSON(fetchHotSpotUrl, function(data) {
			if(data)
				hotSpot = data.hotSpot;
		});
		
	}
	
	return hotSpot;
	
};


var areAllHotSpotsVisible = true;

function showHideAllHotSpots( element ){
	if( areAllHotSpotsVisible ) {
		$('.div-hotspot').hide('fade');
		areAllHotSpotsVisible = false;
	} else {
		$('.div-hotspot').show('fade');
		areAllHotSpotsVisible = true;
	}
};









/* Document ready functions   */

$(document).ready(function(){
	
	// Global Variables ...
	
	var hotSpotsEdit = $('#hotspots-edit');
	var hotSpotsInfo = $('#hotspots-info');
	
	
	// Hot spot ..
	
	var hsPkey = null;
	
	var hsLi = null;
	var hsDiv = null;
	
	function identifyHotSpotElements(element) {
		hsPkey = $(element).attr('hs-pkey');
		hsLi = $('.hot-spot-li[hs-pkey=' + hsPkey + ']'); 
		hsDiv = $('.div-hotspot[hs-pkey=' + hsPkey + ']'); 
	};
	
	
	var toolTipCont = $('#tooltip-cont');
	
	$('.hotspot-element').live({
		mouseenter : function(event){
			preventEventDefaults(event);
			
			identifyHotSpotElements(this);
			
			hsLi.addClass('selected');
			hsLi.find('.hotspot-events-cont').slideDown('slow');
			
			hsDiv.addClass('selected');
			toolTipCont.html(hsDiv.find('.tooltip-content').html());
			toolTipCont.css({
				'display' : 'block',
				'top' : hsDiv.offset().top,
				'left' : hsDiv.offset().left + 3 + hsDiv.width()
			});
			
		}, 
		mouseleave : function(event){
			preventEventDefaults(event);
			
			identifyHotSpotElements(this);

			hsLi.removeClass('selected');
			hsLi.find('.hotspot-events-cont').slideUp('slow');
			
			hsDiv.removeClass('selected');
			setTimeout(function() {
				toolTipCont.hide('fade');
			}, 2500);

		},
		click : function(event){
			preventEventDefaults(event);
			
			identifyHotSpotElements(this);
			
			$('.div-hotspot').removeClass('editable');
			hsDiv.addClass('editable');
			
			if (hsPkey && hsPkey != '' && parseInt(hsPkey)) {
				loadDetailsOfHotSpot(hsPkey, this );
				prepareHotSpotForEditing();
			}
		}
	});
	
	
	/* Cancelling HotSpot Editing ... */
	
	function cancelHotSpotEditing(){
		$('.div-hotspot').removeClass('editable');
		hotSpotsEdit.slideUp('slow', function(){
			$('#hs-div-undefined').remove();
			hotSpotsInfo.slideDown('slow');
		});
	};
	
	$('#cancel-hotspot-btn').live('click',function(){
		cancelHotSpotEditing();
    });
	
	$('#hs-div-undefined .bin-icon').live('click', function(event){
		preventEventDefaults(event);
		cancelHotSpotEditing();
	});
	
	/* Cancelling HotSpot Editing finished ...  */ 
	
	
	$('.hs-edit-btn').live('click', function(event){
		preventEventDefaults(event);
		
		prepareHotSpotForEditing();
		
	});
	
	$('.hs-delete-btn').live('click', function(event){
		preventEventDefaults(event);
		
//		var container = $(this).closest('.hot-spot-li');
//		if( !container || container.length == 0 ) {
//			container = $(this).closest('.div-hotspot');
//		}
			
//		var hotSpotPkey = container.find('input[name=hotSpotPkey]').val();
		var hotSpotPkey = $(this).attr('hot-spot-pkey');
		removeHotSpot( hotSpotPkey, this );
		
	});
	
	$('.hs-link-btn').live('click', function(event){
		preventEventDefaults(event);
		
//		var toPagePkey = $(this).closest('.hot-spot-li').find('input[name=toPagePkey]').val();
		var toPagePkey = $(this).attr('to-page-pkey');
		preparePageForEditing( toPagePkey, this );
		
	});
	
	
});







