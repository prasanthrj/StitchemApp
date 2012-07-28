
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>
	
	<meta>
	<title> Project Builder  </title>

	<!-- Canvas Extended functions -->
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/canvas-prototype.js"></script>

	<!-- Canvas Builder Tools ...  -->
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/builder-tools.js"></script>
	
	<script type="text/javascript">
	
	/* Global variables */

	var projectPkey = parseInt('<s:property value="project.pkey" />');
	var projectWidth = parseInt('<s:property value="project.layout.width" />');
	var projectHeight = parseInt('<s:property value="project.layout.height" />');

	var noOfPages = parseInt('<s:property value="pages.size()" />');
	
	var currPagePkey = parseInt('<s:property value="page.pkey" />');
	var currPageObj = {};

	scaledWidth = projectWidth;
	scaledHeight = projectHeight;
	
	$(document).ready( function() {
		
// 		$('.collapse-icon').click();
		
		/* Prepare Canvas ... */
		var canvas = document.getElementById(canVasElementId);
		var context = canvas.getContext("2d");
		var canvasElement = $(canvas);
		
		/* Carousel ... */
		var carouselPagesList = $('#pages-list');
		if(carouselPagesList.find('li').length > 0) {
			carouselPagesList.jcarousel({
				initCallback : pagesListCarouselInitCallback,
	            reloadCallback : pagesListCarouselInitCallback
			});
		}
		
		
		/* Setting initial Visible Items ... */
		var mainCont = $('#main-cont');
		
		var buildOptionsCont = $('#build-options-cont');
		var buildCont = $('#build-cont');
		var buildInfoCont = $('#build-info-cont');
		
		if(noOfPages != 0) {
			mainCont.show();
		}
		
		
		/* Window resize related ... */
		adjustToWindowDimentions();
		
		$(window).resize(function() {
			adjustToWindowDimentions();
			
		});
		
		
		/* Drag-Drop file Upload ... */
		prepareFileDropUpload("carousel-cont");
		
		
		/* Tabs */
		
		var screenTab = $('#screen-tab');
		var screenOpts = $('#screen-opts');
		
		var hotspotsTab = $('#hotspots-tab');
		var hotspotsOpts = $('#hotspots-opts');
		
		screenTab.live('click',function(){
			hotspotsTab.removeClass('selected');
			screenTab.addClass('selected');
			hotspotsOpts.hide();
			screenOpts.show('fade');
			
			/* Turn OFF Hotspot editing */
			$('.div-hotspot').hide('fade');
			clearCanvasMarker();
			canvasElement.css({ 'cursor' : 'auto' });
			
		});
		
		hotspotsTab.live('click', function() {
			screenTab.removeClass('selected');
			hotspotsTab.addClass('selected');
			screenOpts.hide();
			hotspotsOpts.show('fade');
			
			/* Turn ON Hotspot editing */
			$('.div-hotspot').show('fade');
			prepareCanvasToolsForPage( currPagePkey );
			canvasElement.css({ 'cursor' : 'crosshair' });
			
		});

		
		/* Load the first page for editing .. */
		if(currPagePkey && currPagePkey != '')
			preparePageForEditing( currPagePkey );
		
		/* attach page editing and tool tip */
		
		var toolTipCont = $('#tooltip-cont');
		$('#pages-list li').live({
			mouseenter : function(event){
				var element = $(this);
				toolTipCont.html(element.find('.tooltip-content').html());
				toolTipCont.css({
					'display' : 'block',
					'top' : $(element).offset().top + 100,
					'left' : $(element).offset().left + 60
				});
			},
			mouseleave : function(event){
				setTimeout(function() {
					toolTipCont.hide('fade');
				}, 2000);
			},
			click : function(event){
				var pagePkey = $(this).find('input').val();
				preparePageForEditing( pagePkey, this );
			}
		});
		
		
		/* Page title */
		
		$('#edit-page-title-btn').live('click', function(){
			var link = $(this);
			link.hide();
			link.closest('div').find('div.form-cont').show();
		});
		
		$('#page-title-input').live('change', function(){
			
			var link = $('#edit-page-title-btn');
			
			$('#managePageTitleForm').ajaxForm({
				success: function (data){
					if(data && data.page) {
						$('input.page-title').attr('value', data.page.title);
						$('a.page-title').html(data.page.title);
						
						// Message 
						showNotificationMsg( 'success', "Page title has been successfully updated to " +  data.page.title);
					}
				},
				complete: function(){
// 					$('#page-title-popup').customPopUp('close'); 
// 					$.fancybox.close(); 

					link.closest('div').find('div.form-cont').hide();
					link.show();
				} 
			}).trigger('submit');
			
		});
		

		/* Page Screen Options */
		
		$('#screen-opts-list input[type=checkbox]').live('click', function(){
			var input = $(this);
			var li = input.parents('li');
			var selectDiv = li.find('div.select-cont');
			var formDiv = li.find('div.form-cont');
			
			if(input.is(':checked')){
				selectDiv.slideDown('slow');
			} else {
				selectDiv.find('select').val(-1).trigger('change');
				selectDiv.slideUp('slow');
				formDiv.slideUp('slow');
			}
			
		});

		
		/* Page Screen */
		
		$('#page-screen-btn').live('click', function(){
			
			var currentPagePkey = parseInt($('#curr-page-pkey').val()); 
			if(currentPagePkey && currentPagePkey != '') {
				$('#page-screen-input').trigger('click');
			} else {
				showNotificationMsg('status', "No screen exists");
				alert('upload screens');
			}
			
		});
		
		$('#page-screen-input').live('change', function(){
			
			var currentPagePkey = parseInt($('#curr-page-pkey').val()); 
			showNotificationMsg('status', "screen image uploading");
			
			$('#managePageScreenForm').ajaxForm({
				success: function (data){
// 					if( data && data.messageBean ){ 
// 						var msg = data.messageBean; 
						
// 						if(msg.messageType == 'error') { 
// 							showNotificationMsg('success', "screen image update Failed"); 
// 						} else { 
							showNotificationMsg('success', "screen image successfully updated");
// 							preparePageForEditing(currentPagePkey);
							
							// TODO Hack 
							window.location.reload(true);
// 						} 
// 					} 
				},
				complete: function(){} 
			}).trigger('submit');
		});
		
		$('#deletePageForm').ajaxForm({
			success: function (data){
				if( data && data.page ){
					
					var page = data.page;
					var msgBean = data.messageBean;
					
					// remove from the carousel 
					var pagesList = $('#pages-list');
					var carElement = pagesList.find('input.page-pkey[value=' + page.pkey + ']').closest('li');
					
					var carElementIndex = carElement.attr('jcarouselindex');
					removePageElementFromPageslListCarousel(carElementIndex);	
					
					showNotificationMsg( msgBean.messageType , msgBean.message || "Page Successfully deleted !!!" );
				
					// load the first page .. 
					var firstPagePkey = pagesList.find('li:first input.page-pkey').val();
					if(firstPagePkey) {
						preparePageForEditing(firstPagePkey);
					} else {
						// TODO Hack 
						window.location.reload(true);
					}
					
				}
				
			},
			complete: function(){
				$.fancybox.close();
			}
		});
		
		
		/* Supporting Images */
		
		$('.form-cont .close-icon').live('click', function(){
			$(this).closest('.form-cont').slideUp('slow');			
		});
		
		$('.delete-support-image-btn').live('click', function(){
			var btn = $(this);
			
			var form = btn.closest('form');
			var formLi = form.closest('li');
			
			var imgPkey = form.find('.support-img-pkey').val();
			
			var selectElem = formLi.parents('li:first').find('select');
			
			form.ajaxForm({
				url : '<%= request.getContextPath() %>/image/remove',
				beforeSubmit: function (data){},
				success: function (data) {
					if(data && data.messageBean){
						var msgBean = data.messageBean;
						if(msgBean.messageType == 'error') {
							showNotificationMsg( msgBean.messageType , msgBean.message || "File deletion failed !!!" );
						} else {
							formLi.remove();
							selectElem.find('option[value=' + imgPkey + ']').remove();
							showNotificationMsg( msgBean.messageType , msgBean.message || "File Successfully deleted !!!" );
						}
					}
				}
			}).trigger('submit');
			
		});
		
		
		/* Supporting Images select boxes */
		
		$('.support-imgs-select').live('change', function(){
			var select = $(this);
			var imagePkey = select.val();
			
			var imgURL = '';
			if(imagePkey != -1)
				imgURL = '<%= request.getContextPath() %>/image/view?project.pkey=' + projectPkey + '&imageFile.pkey=' + imagePkey ;
			
			var form = select.parents('form:first');
			var imgType = form.find('input[name$=imageType]').val();
			
			form.ajaxForm({
				beforeSubmit: function (data){},
				success: function (data){
					if(data) {
						
						// Setting up the image ... 
						switch (imgType) {
							case 'Header':
								$('#canvas-header').attr('src', imgURL);
								break;
							case 'Footer':
								$('#canvas-footer').attr('src', imgURL);
								break;
							case 'LeftNavBar':
								$('#canvas-left-nav').attr('src', imgURL);
								break;
							case 'RightNavBar':
								$('#canvas-right-nav').attr('src', imgURL);
								break;
	
							default:
								break;
						}
						
					}
				} 			
			}).trigger('submit');
			
		});
		
		

		// Form Submission .... 
		
		var hotSpotCreateEditForm = $('#hotSpotCreateEditForm');
		
		hotSpotCreateEditForm.ajaxForm({
			beforeSubmit: function (data){
				var fromX = hotSpotCreateEditForm.find('input[name$=fromX]').val();
				var toX = hotSpotCreateEditForm.find('input[name$=toX]').val();
				
				if (!fromX || !toX) 
					return false;
			},
			success: function (data){
				var currentHotSpotPkey = $('#hot-spot-pkey').val();
				$('#'+ hsContPrefix + currentHotSpotPkey).trigger('click');
				
				$('.div-hotspot').removeClass('editable');
				$('#hotspots-edit').slideUp('slow', function(){
					$('#hotspots-info').slideDown('slow');
				});
				
				// update page hotspots ... 
				updatePageHotSpots();
				
			}
		});
		
		
		// Publish Related ...

		$('.isPublic').live('click', function(){
			var publishContacts = $('#publish-contacts-cont');
			var publicNote = $('#publish-public-note');
			
			var isPublicRadio = $('input[name$=isPublic]');
			
			if(publishContacts.css('display') == 'block'){
				publishContacts.hide();
				publicNote.show('fade');
				
				isPublicRadio.attr('value', true);
				
			} else {
				publicNote.hide();
				publishContacts.show('fade');
				
				isPublicRadio.attr('value', false);
			}
		});
		
	});
	
	
	/* Window resize */
	function adjustToWindowDimentions() {
		
		// body .. 
		adjustBodyToWindowDimensions();
		
		
	};
	
	
	
	/* Functions */
	
	function resetBuildPage() {
		
		currPagePkey = null;
		$('.curr-page-pkey').attr("value", "");
		
		$('#pages-list').find('li.selected').removeClass('selected');
		
		$('.page-title').html('');
		$('input.page-title').attr('value', '');
		
		// Build info 
		$('.screen-hotspots-count').html(0); 
		
		$('#page-hotspots-list').html('');
		
		// Build cont 
		$('.canvas-bg-img').attr('src', '');
		$('.div-hotspot').remove();
		
		// Build Options 
		$('#screen-opts-list').find('input[type=checkbox]').each(function() {
			
			var chkbox = $(this);
			
			if(chkbox.attr('checked') && (chkbox.attr('checked') == true || chkbox.attr('checked') == 'checked')) {
				chkbox.removeAttr('checked').attr('class', '');
				chkbox.siblings('label').attr('class', '');
			}
			
			var li = chkbox.closest('li');
			li.find('select').attr('value', -1 );
			li.find('div.indent').hide();
			
		});
		
	};
	
		
	function preparePageForEditing( pagePkey, element ) {
		
		// Check is it the same page as the page under editing.. ??? !element is for default page load 
		if( ( currPagePkey != pagePkey && pagePkey.length != 0 ) || !element ){
			
			// Retrieve the page details 
			var getPageURL = '<%= request.getContextPath() %>/project/build/edit_page?project.pkey=' + projectPkey + '&page.pkey=' + pagePkey ;
			$.getJSON(getPageURL, function(data){
				if(data && data.page) {
					
					// reset 
					resetBuildPage();
					
					// Highlight the page Element 
					$('#pages-list li').each(function() {
						$(this).removeClass('selected');				
					});
					
					$('input.page-pkey[value=' + pagePkey + ']').parents('li').addClass('selected');
					
					// Setting/updating the objects with  new page details 
					currPagePkey = pagePkey;
					$('.curr-page-pkey').attr("value", pagePkey );
					
					currPageObj = data.page;
					currentHotSpots = data.hotSpots;
					
					// Page Details .. 
					loadPageScreenDetails(data.page);
					
					// Hot Spots .. 
					// currentHotSpotsMap is prepared in loadPageHotSpots ... 
					if(data.hotSpots)
						loadPageHotSpots(data.hotSpots);
					
					// Comments .. 
					if(data.page.comments)
						loadPageComments(data.page.comments);
					
				}
			});
					
		};
	};
 
	
	function loadPageScreenDetails( page ) {
		
		$('#main-cont').show();
		
		var isTabClicked = false;
		$('#page-tabs-list li').each(function(){
			if($(this).hasClass('selected'))
				isTabClicked = true;
		}); 
		
		if(!isTabClicked){
			$('#screen-tab').trigger('click');
		}
		
		var screenOptsCont = $('#screen-opts');
		
		/* Screen info */
		
		// Screen Name  
		$('.page-title').html(page.title);
		$('input.page-title').attr('value', page.title);
				
		// Image editable pkey 
		$('.curr-page-img-pkey').val(page.screenImage.pkey);
		
		$('#screen-dimensions').html(page.screenImage.width + 'px X ' + page.screenImage.height + 'px');
		
		// HotSpots count 
		$('.screen-hotspots-count').html( currentHotSpots.length || 0 );
		
		// Landing Page 
		var landingPagePkey = $('#landing-page-pkey').val();
		if( landingPagePkey == page.pkey )
			$('#landing-page-chkbox').check();
			
		
		/* Screen options */
		
		
		/* Build Container */
		
		// ScreenImgURL ..
		var pageScreenImagePkey = page.screenImage.pkey ;
		
		var pageHeaderImagePkey = -1;
		if(page.headerImage && page.headerImage.pkey) {
			pageHeaderImagePkey = page.headerImage.pkey;
			$('#set-header-chkbox').check();
			$('#screen-header-select').attr('value', pageHeaderImagePkey ).parents('div.select-cont').show();
		}
		
		var pageFooterImagePkey = -1;
		if(page.footerImage && page.footerImage.pkey) {
			pageFooterImagePkey = page.footerImage.pkey;
			$('#set-footer-chkbox').check();
			$('#screen-footer-select').attr('value', pageFooterImagePkey ).parents('div.select-cont').show();
		}
			
		
		var pageLeftNavImagePkey = -1;
		if(page.leftNavImage && page.leftNavImage.pkey) {
			pageLeftNavImagePkey = page.leftNavImage.pkey;
			$('#set-leftnav-chkbox').check();
			$('#screen-leftnav-select').attr('value', pageLeftNavImagePkey ).parents('div.select-cont').show();
		}
		
		var pageRightNavImagePkey = -1;
		if(page.rightNavImage && page.rightNavImage.pkey) {
			pageRightNavImagePkey = page.rightNavImage.pkey;
			$('#set-rightnav-chkbox').check();
			$('#screen-rightnav-select').attr('value', pageRightNavImagePkey ).parents('div.select-cont').show();
		}
			
		setCanvasBackGround( pageScreenImagePkey, pageHeaderImagePkey, pageFooterImagePkey, pageLeftNavImagePkey, pageRightNavImagePkey );
		
	};
	
	
	function setCanvasBackGround( pageScreenImagePkey, pageHeaderImagePkey, pageFooterImagePkey, pageLeftNavImagePkey, pageRightNavImagePkey ){
		
		var pageScreenURL = '<%= request.getContextPath() %>/image/view?project.pkey=' + projectPkey + '&imageFile.pkey=' + pageScreenImagePkey ;
		
		var pageHeaderURL = '';
		if(pageHeaderImagePkey && pageHeaderImagePkey != -1)
			pageHeaderURL = '<%= request.getContextPath() %>/image/view?project.pkey=' + projectPkey + '&imageFile.pkey=' + pageHeaderImagePkey ;
		
		var pageFooterURL = '';
		if(pageFooterImagePkey && pageFooterImagePkey != -1)
			pageFooterURL = '<%= request.getContextPath() %>/image/view?project.pkey=' + projectPkey + '&imageFile.pkey=' + pageFooterImagePkey ;
		
		var pageLeftNavURL = '';
		if(pageLeftNavImagePkey && pageLeftNavImagePkey != -1)
			pageLeftNavURL = '<%= request.getContextPath() %>/image/view?project.pkey=' + projectPkey + '&imageFile.pkey=' + pageLeftNavImagePkey ;
		
		var pageRightNavURL = '';
		if(pageRightNavImagePkey && pageRightNavImagePkey != -1)
			pageRightNavURL = '<%= request.getContextPath() %>/image/view?project.pkey=' + projectPkey + '&imageFile.pkey=' + pageRightNavImagePkey ;
		
		
		$('#canvas-screen').attr('src','').attr('src', pageScreenURL).css({'width': projectWidth});
 		$('#canvas-header').attr('src', pageHeaderURL).css({'width': projectWidth});
		$('#canvas-footer').attr('src', pageFooterURL).css({'width': projectWidth});
		$('#canvas-left-nav').attr('src', pageLeftNavURL).css({'height': projectHeight});
		$('#canvas-right-nav').attr('src', pageRightNavURL).css({'height': projectHeight});
		
	};
	
	
	function loadPageHotSpots(hotSpots) {
		
		var hotspotsInfoCont = $('#hotspots-info');
		var hotspotsOptsCont = $('#hotspots-opts');
		var hotspotsBuildCont = $('#hotspots-cont');
		
		/* HotSpots info */
		
		var title = hotSpots.length + 'Hotspots';
		if( hotSpots.length == 1 )
			title = hotSpots.length + 'HotSpot';
		
		hotspotsInfoCont.find('label.title').html(title);
		
		var hotSpotsList = $('#page-hotspots-list');
		
		currentHotSpots = hotSpots;
		currentHotSpotsMap = new Object();
		
		$('.screen-hotspots-count').html( hotSpots.length );
		
		var hotSpotsHtml = '';
		for ( var i = 0; i < hotSpots.length; i++) {
			var hotSpot = hotSpots[i];
			var hotSpotContId = hsContPrefix + hotSpot.pkey;
			
			// setting the currentHotSpotsMap ..
			currentHotSpotsMap[hotSpotContId] = hotSpot;
			
			var hotSpotTitle =  hotSpot.title || "HotSpot - " + hotSpot.pkey ;
			hotSpotsHtml += '<li id="' + hotSpotContId + '" class="hot-spot-li hotspot-element" hs-pkey="' + hotSpot.pkey + '">';
			
			hotSpotsHtml += '<label>' + hotSpotTitle + '</label>';
			hotSpotsHtml += '<a href="javascript:void(0);" class="bin-icon margin-5px float-right hs-delete-btn" hot-spot-pkey="' + hotSpot.pkey + '"></a>';
			hotSpotsHtml += '<a href="javascript:void(0);" class="edit-icon margin-5px float-right hs-edit-btn"></a>';
			
			/* hotSpot info */
			hotSpotsHtml += '<input type="hidden" value="' + hotSpot.pkey + '" name="hotSpotPkey" />';
			hotSpotsHtml += '<input type="hidden" value="' + hotSpot.fromX + '" name="fromX" />';
			hotSpotsHtml += '<input type="hidden" value="' + hotSpot.fromY + '" name="fromY" />';
			hotSpotsHtml += '<input type="hidden" value="' + hotSpot.toX + '" name="toX" />';
			hotSpotsHtml += '<input type="hidden" value="' + hotSpot.toY + '" name="toY" />';
			
			/* hotSpot events */
			var uiEvents = hotSpot.uiEvents;
			if (uiEvents && uiEvents.length > 0){
				
				hotSpotsHtml += '<div class="hotspot-events-cont" style="display: none;">';
				hotSpotsHtml += '<ul class="hotspot-events-list" >';
				
				for(var j = 0; j < uiEvents.length; j++) {
					var uiEvent = uiEvents[j];
					
					if(j == (uiEvents.length - 1)) {
						hotSpotsHtml += '<li title="Click to Edit" class="events-list-li no-border" >';
					} else {
						hotSpotsHtml += '<li title="Click to Edit" class="events-list-li" >';
					}
					
					hotSpotsHtml += '<input type="hidden" value="' + uiEvent.pkey + '" name="uiEventPkey" />';									
					hotSpotsHtml += '<input type="hidden" value="' + uiEvent.toPage.pkey + '" name="toPagePkey" />';
					
					hotSpotsHtml += '<input type="hidden" value="' + uiEvent.eventType + '" name="eventType" />';
					hotSpotsHtml += '<input type="hidden" value="' + uiEvent.transitionType + '" name="transitionType" />';
					
// 					hotSpotsHtml += '<label class=""> On <span class="bold">' + uiEvent.eventType + ' </span>, go to <span class="bold"> ' + uiEvent.toPage.title + ' </span> with <span class="bold"> ' + uiEvent.transitionType + ' </span> transition </label>';
					hotSpotsHtml += '<label class=""> On <span class="bold">' + uiEvent.eventType + ' </span>, <span class="bold"> ' + uiEvent.transitionType + ' </span> to <a class="bold hs-link-btn" to-page-pkey="' + uiEvent.toPage.pkey + '" > ' + uiEvent.toPage.title + ' </a> </label>';
					
					hotSpotsHtml += '</li>';
					
				}
				
				hotSpotsHtml += '</ul>';
				hotSpotsHtml += '</div>';
			}
			
			hotSpotsHtml += '</li>';
			
		}

		hotSpotsList.html(hotSpotsHtml);
		
		/* HotSpots options */
		
		
		/* Build Container */
		
		// Clean old hotSpots 
		var hotSpotsHolder = $('#' + hotSpotsHolderId);
		hotSpotsHolder.find('.div-hotspot').remove();
		
		drawAllHotSpots(currentHotSpots, defFillStyle);

	};
	
	
	function removeHotSpot( hotSpotPkey, element ) {
		if( hotSpotPkey ){
			var currPagePkey = $('#curr-page-pkey').val();
			var deleteHotSpotUrl = '<%= request.getContextPath() %>/project/build/remove_hot_spot?hotSpot.pkey=' + hotSpotPkey + '&page.pkey=' + currPagePkey ;
			$.getJSON(deleteHotSpotUrl, function(data){
				if(data) {
					
					$('#tooltip-cont').hide();
					
					// update page hotspots ... 
					updatePageHotSpots();
				
				}
			});
		}
		
		return false;
	};
	
	
	function updatePageHotSpots(){
		
		var fetchHotSpotsUrl = '<%= request.getContextPath() %>/project/build/fetch_all_hot_spots?page.pkey=' + currPagePkey ;
		$.getJSON(fetchHotSpotsUrl, function(data) {
			if(data) {
				currentHotSpots = data.hotSpots;
				loadPageHotSpots(currentHotSpots);
			}
		});
		
	};
	
	function saveHotSpotCoordinates(hotSpot) {
		
		var hotSpotCoordinatesForm = $('#hotSpotCoordinatesForm');
		
		hotSpotCoordinatesForm.find('input.hot-spot-pkey').attr('value', hotSpot.pkey);
		
		hotSpotCoordinatesForm.ajaxForm({
			beforeSubmit: function (data){
				var fromX = hotSpotCoordinatesForm.find('input[name$=fromX]').val();
				var toX = hotSpotCoordinatesForm.find('input[name$=toX]').val();
				
				if (!fromX || !toX) 
					return false;
			},
			success: function (data){
				// TODO fix hack 
				updatePageHotSpots();				
			}
		}).trigger('submit');
		
	};
	
	
	/* update Landing Page .. */
	
	function updateProjectLandingPage( element ) {
		
		var isChecked = $(element).is(':checked');
		
		var landingPageForm = $('#manageLandingPageForm');
		landingPageForm.find('input[name=isLandingPage]').attr('value', isChecked);	
		landingPageForm.ajaxForm({
			success : function(data){
				if(data && data.messageBean) {
					
					showNotificationMsg(data.messageBean.messageType, data.messageBean.message );
					
					// Update the landing page details 
					
					var landingPagePkey = $('#landing-page-pkey');
					
					if(isChecked){
						landingPagePkey.attr('value', $('#curr-page-pkey').val());
					} else {
						landingPagePkey.attr('value', '');
					}
					
				}
			}
		}).trigger('submit');

	};
	
	
	
	
	/* Page Comments */
	
	function loadPageComments(comments) {
		// Designs are yet to out ....
		
		if(comments){

			var commentsList = $('#page-comments-list');
			commentsList.slideUp(500, function(){

				var commentsHtml = '';
				if(comments && comments.length >0){
					for ( var i = 0; i < comments.length; i++) {
						var comment = comments[comments.length - (i + 1)];
			
						if(i == 0) {
							commentsHtml += '<li class="comment-li no-top-border float-left clear">';
						} else {
							commentsHtml += '<li class="comment-li float-left clear">';
						}
			
						commentsHtml += '<input type="hidden" value="' + comment.pkey + '" name="comment.pkey" />'
						commentsHtml += '<img alt="" src="<%= request.getContextPath() %>/themes/images/profile_photo.png" class="float-left user-img-thumb">';
						commentsHtml += '<div class="float-left">';
						commentsHtml += '<label class="float-left clear gray-666-text">';
			
						var displayName = comment.appUser.name;
						if(!displayName)
							displayName = comment.appUser.emailId;
			
						commentsHtml += '<span class="bold gray-333-text"> ' + displayName +' : </span>' + comment.body;
						commentsHtml += '</label>';
						commentsHtml += '</div>';
						commentsHtml += '</li>';
		
					}
				}
	
				commentsList.html(commentsHtml);
				commentsList.slideDown(1000);

			});
			
		}
		
	};	
	
	
	
	// File uploader .. 
	
	function openFileSelector( options ) {
		
		var uploadForm = $('#upload-imgs-form');
		var multiFileInput = $('#images-multiple-input');
		
		var imageFileType = options.imageFileType;
		
		uploadForm.find('input.imageFileType').attr('value', imageFileType);
		multiFileInput.attr('name', imageFileType + 's.fileObj').trigger('click');
		
		multiFileInput.live('change', function(event){
			
			if (imageFileType == "ScreenImage") {
				screenImagesUploader(event, this);
			} else {
				regularfileUploader(event, this, imageFileType);
			}
			
		});		
		
	};
	
	// Supporting Images Manage 
	
	function prepareSupportImagesManageSection( options, element ) {
		if( element ){
			var link = $(element);
			link.closest('li').find('div.form-cont').slideToggle('slow');
		}
	};
	
      
	</script>
	
</head>

<body>

	<!-- Body Content -->
	
	<section id="info-cont" style="display: none;">
	
		<input type="hidden" value="<s:property value="project.pkey" />" id="proj-pkey">
	
		<input type="hidden" value="<s:property value="project.layout.height" />" id="proj-height">
		<input type="hidden" value="<s:property value="project.layout.width" />" id="proj-width">
		
		<input type="hidden" value="<s:property value="layout.landingPage.pkey" />" id="landing-page-pkey">
		
		<input type="hidden" value="" id="curr-page-pkey" class="curr-page-pkey">
		<input type="hidden" value="" id="curr-page-img-pkey" class="curr-page-img-pkey">
		
		<input type="hidden" value="" id="curr-hotspot-pkey" class="curr-hotspot-pkey">

	</section>
	
	
	<div id="" class="float-fix">
	 	<div id="main-title-cont">
	 		<a class="home-icon float-left" href="<%= request.getContextPath() %>/home" style="margin: 7px 0 0 0;"></a>
			<div class="grt-than-small"></div>
			<label class="title"> <s:property value="project.title" /> </label>
		</div>
		<div id="top-nav-cont">
			<ul id="top-btn-list" class="inline-list">
				<li>
					<a href="javascript:void(0)" class="btn">
						<img alt="" src="<%= request.getContextPath() %>/themes/images/icon_settings.png">
					</a>
				</li>
				<li>
	               	<a href="javascript:void(0)" class="btn" > save </a>
	            </li>
				<li>
	              	<a href="javascript:void(0)" class="btn" id="preview-btn" onclick="showPreviewInModal(<s:property value="project.pkey"/>);" > preview </a>
				</li>
				<li>
	              	<a href="#project-publish-popup" class="btn btn-yellow fancy-box-link" id="publish-btn"> publish </a>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="top-cont" class="" style="border: none;">
		
		<div id="carousel-cont" class="yellow-bg">
			
			<div id="droppable-overlay" style="display: none;">
				<label class="" style="">Drop Files here</label>
			</div>
			
			<ul id="pages-list" class="carousel-list">
				<s:if test="%{pages != null && pages.size() > 0}">
					<s:iterator value="pages" var="page">
						<li id="car-page-<s:property value="%{#page.pkey}" />" title="<s:property value="%{#page.title}" />">
							<div class="page-thumb-image-cont">
								<img alt="<s:property value="%{#page.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#page.screenImage.pkey}" />">
							</div>
							<input type="hidden" class="page-pkey" value="<s:property value="%{#page.pkey}" />" />
							
							<div class="tooltip-content" style="display: none;">
								<div class="pos-rel page-tt-content">
									<ul>
										<li class="float-fix">
											<label class="title"> <s:property value="%{#page.title}" /> </label>
										</li>
										<li class="float-fix">
											<label class="key"> Width : </label>
											<label class=""> <s:property value="%{#page.screenImage.width}" /> px </label>
										</li>
										<li class="float-fix">
											<label class="key"> Height : </label>
											<label class=""> <s:property value="%{#page.screenImage.height}" /> px </label>
										</li>
									</ul>
								</div>
							</div>
							
						</li>
					</s:iterator>
				</s:if>
			</ul>
			<s:else>
				<div id="no-pages-cont">
					<a class="plus-icon" onclick="openFileSelector({'imageFileType':'ScreenImage'});" 
						href="javascript:void(0);" > Add Screens here </a>
					<label class="clear gray-999-text"> or </label>
					<label class="clear gray-666-text"> drop them here </label>
				</div>
			</s:else>
			
		</div>
			
		<div id="build-nav-cont" class="">
		
			<div id="page-options-cont" class="float-left">
				<ul id="page-options-list" class="inline-list">
					<li id="" class="">
						<a href="javascript:void(0)" class="screen-icon" id="page-screen-btn"> </a>
					</li>
					<li id="" class="">
						<a href="#page-delete-popup" class="delete-icon fancy-box-link" id="page-delete-btn"> </a>
					</li>
					<li class="">
						<a href="javascript:void(0)" class="hotspots-icon screen-hotspots-count" onclick="showHideAllHotSpots( this );"> </a>
					</li>
				</ul>
			</div>
			
			<div id="page-title-cont" class="float-left">
				<a class="page-title" title="Click to edit" href="javascript:void(0)" id="edit-page-title-btn"> Page Title </a>
				
				<div class="form-cont margin-5px" style="display: none;">
					<form id="managePageTitleForm" action="<%= request.getContextPath() %>/project/build/save_page" method="post">
						<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />" >
						<input type="hidden" value="" id="" class="curr-page-pkey" name="page.pkey" />
						
						<input type="text" id="page-title-input" name="page.title" class="page-title float-left" value="" placeholder="Page title" />
					</form>
				</div>
				
			</div>
			<div id="page-tabs-cont" class="float-right">
				<ul id="page-tabs-list" class="inline-list">
					<li id="screen-tab" class="">
						<a class="screen-arrow-icon"> Screen </a>
					</li>
					<li id="hotspots-tab" class="">
						<a class="hotspots-icon"> Hotspots </a>
					</li>
					<li class="">
						<a class="collapse-icon"> </a>
					</li>
				</ul>
			</div>
		</div>
	
	</div>
	
	<div id="main-cont" class="float-fix" style="display: none;">
	
		<section id="build-options-cont" class="float-right" style="width: 28%;">
			
			<div id="screen-opts" class="float-fix">
			
				<label class="title"> Screen Options </label>

				<ul id="screen-opts-list">

			        <li>
		            	<input id="landing-page-chkbox" type="checkbox" name="" value=""  onclick="updateProjectLandingPage(this);" />
		            	<label for="landing-page-chkbox"> Make it project's launch screen </label>
		            	
		            	<form action="<%=request.getContextPath()%>/project/build/update_landing_page" method="post" id="manageLandingPageForm">
		            		<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
		            		<input type="hidden" name="page.pkey" value="" class="curr-page-pkey">
		            		<input type="hidden" name="isLandingPage" value="">
		            	</form>
			        </li>
			        
			        <li>
		            	<div>
			            	<input id="set-header-chkbox" type="checkbox" name="" value="" />
			            	<label for="set-header-chkbox"> Set Header </label>
		            	</div>
		            	<div class="indent select-cont" style="display: none;">

		            		<form id="managePageHeaderForm" action="<%= request.getContextPath() %>/project/build/save_page" method="post">
								
								<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
								<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
 								<input type="hidden" name="imageFile.imageType" value="Header" class="">		
 								
 								<select id="screen-header-select" class="support-imgs-select margin-5px float-left clear" name="imageFile.pkey">
									<option value="-1"> -- Choose a header -- </option>
									<s:iterator value="headerImages" var="image">
										<option value="<s:property value="%{#image.pkey}" />"> <s:property value="%{#image.fileObjFileName}" /> </option>
									</s:iterator>
								</select>
	 							
							</form>
			            	
							<a class="plus-icon" href="javascript:void(0);" 
								onclick="openFileSelector({'imageFileType':'Header'});"> Add More headers </a>
								
							<a class="plus-icon" href="javascript:void(0);" 
								onclick="prepareSupportImagesManageSection({'imageFileType':'Header'}, this)"> Manage headers </a>
								
						</div>
						<div class="indent form-cont" style="display: none;">
							
							<label class="margin-5px italic"> Headers List </label>
							<a href="javascript:void(0);" class="float-right close-icon" style="clear: none;"> </a>
						
							<ul class="supporting-images-list">
								<s:iterator value="headerImages" var="image">
									<li>
										<form class="delete-support-image-form" action="<%= request.getContextPath() %>/image/remove" method="post">
											<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
											<input type="hidden" name="imageFile.imageType" value="Header" class="">
											
											<input type="hidden" name="imageFile.pkey" class="support-img-pkey" value="<s:property value="%{#image.pkey}" />">
											
											<label class="float-left"> <s:property value="%{#image.fileObjFileName}" /> </label>
											<a class="float-right delete-support-image-btn" href="javascript:void(0);"> delete </a>
										</form>
									</li>
								</s:iterator>
							</ul>
							
						</div>
			        </li>
			        <li>
		            	<div>
			            	<input id="set-footer-chkbox" type="checkbox" name="" value="" />
			            	<label for="set-footer-chkbox"> Set Footer </label>
		            	</div>
		            	<div class="indent select-cont" style="display: none;">
		            	
		            		<form id="managePageFooterForm" action="<%= request.getContextPath() %>/project/build/save_page" method="post">
								
								<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
								<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
 								<input type="hidden" name="imageFile.imageType" value="Footer" class="">		
 								
 								<select id="screen-footer-select" class="support-imgs-select margin-5px float-left clear" name="imageFile.pkey">
									<option value="-1"> -- Choose a footer -- </option>
									<s:iterator value="footerImages" var="image">
										<option value="<s:property value="%{#image.pkey}" />"> <s:property value="%{#image.fileObjFileName}" /> </option>
									</s:iterator>
								</select>
	 							
							</form>
			            	
							<a class="plus-icon" href="javascript:void(0);" 
								onclick="openFileSelector({'imageFileType':'Footer'});"> Add More footers </a>
								
							<a class="plus-icon" href="javascript:void(0);" 
								onclick="prepareSupportImagesManageSection({'imageFileType':'Header'}, this)"> Manage footers </a>
								
						</div>
						<div class="indent form-cont" style="display: none;">
							
							<label class="margin-5px italic"> Footers List </label>
							<a href="javascript:void(0);" class="float-right close-icon" style="clear: none;"> </a>
						
							<ul class="supporting-images-list">
								<s:iterator value="footerImages" var="image">
									<li>
										<form class="delete-support-image-form" action="<%= request.getContextPath() %>/image/remove" method="post">
											<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
											<input type="hidden" name="imageFile.imageType" value="Footer" class="">
											
											<input type="hidden" name="imageFile.pkey" class="support-img-pkey" value="<s:property value="%{#image.pkey}" />">
											
											<label class="float-left"> <s:property value="%{#image.fileObjFileName}" /> </label>
											<a class="float-right delete-support-image-btn" href="javascript:void(0);"> delete </a>
										</form>
									</li>
								</s:iterator>
							</ul>
							
						</div>
						
			        </li>
			        
			        <s:set name="projType" value="project.projectType"></s:set>
			        
			        <s:if test="%{#projType != null && #projType != '' }">
						<s:if test="%{#projType != 'AndroidMobile' && #projType != 'Iphone3' && #projType == 'Iphone4'}">
							<li>
				            	<div>
					            	<input id="set-leftnav-chkbox" type="checkbox" name="" value="" />
					            	<label for="set-leftnav-chkbox"> Set Left Navigation </label>
				            	</div>
				            	<div class="indent select-cont" style="display: none;">
					            	<form id="managePageLeftNavForm" action="<%= request.getContextPath() %>/project/build/save_page" method="post">
								
										<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
										<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
		 								<input type="hidden" name="imageFile.imageType" value="LeftNavBar" class="">		
		 								
										<select id="screen-leftnav-select" class="support-imgs-select margin-5px float-left clear" name="imageFile.pkey">
											<option value="-1"> -- Choose a left navigation -- </option>
											<s:iterator value="leftNavImages" var="image">
												<option value="<s:property value="%{#image.pkey}" />"> <s:property value="%{#image.fileObjFileName}" /> </option>
											</s:iterator>
										</select>
			 							
									</form>
					            	
									<a class="plus-icon" href="javascript:void(0);" 
										onclick="openFileSelector({'imageFileType':'LeftNavBar'})"> Add More left navigations </a>
										
									<a class="plus-icon" href="javascript:void(0);" 
										onclick="prepareSupportImagesManageSection({'imageFileType':'LeftNavBar'}, this)"> Manage footers </a>
								
								</div>
								<div class="indent form-cont" style="display: none;">
							
									<label class="margin-5px italic"> Left Navigations List </label>
									<a href="javascript:void(0);" class="float-right close-icon" style="clear: none;"> </a>
								
									<ul class="supporting-images-list">
										<s:iterator value="leftNavImages" var="image">
											<li>
												<form class="delete-support-image-form" action="<%= request.getContextPath() %>/image/remove" method="post">
													<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
													<input type="hidden" name="imageFile.imageType" value="Footer" class="">
													
													<input type="hidden" name="imageFile.pkey" class="support-img-pkey" value="<s:property value="%{#image.pkey}" />">
													
													<label class="float-left"> <s:property value="%{#image.fileObjFileName}" /> </label>
													<a class="float-right delete-support-image-btn" href="javascript:void(0);"> delete </a>
												</form>
											</li>
										</s:iterator>
									</ul>
									
								</div>
						
					        </li>
					        <li>
				            	<div>
					            	<input id="set-rightnav-chkbox" type="checkbox" name="" value="" />
					            	<label for="set-rightnav-chkbox"> Set Right Navigation </label>
				            	</div>
				            	<div class="indent select-cont" style="display: none;">
					            	
					            	<form id="managePageRightNavForm" action="<%= request.getContextPath() %>/project/build/save_page" method="post">
								
										<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
										<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
		 								<input type="hidden" name="imageFile.imageType" value="RightNavBar" class="">		
										
										<select id="screen-rightnav-select" class="support-imgs-select margin-5px float-left clear" name="imageFile.pkey">
											<option value="-1"> -- Choose a right navigation -- </option>
											<s:iterator value="rightNavImages" var="image">
												<option value="<s:property value="%{#image.pkey}" />"> <s:property value="%{#image.fileObjFileName}" /> </option>
											</s:iterator>
										</select>
			 							
									</form>
					            	
									<a class="plus-icon" href="javascript:void(0);" 
										onclick="openFileSelector({'imageFileType':'RightNavBar'})"> Add right navigations </a>
										
									<a class="plus-icon" href="javascript:void(0);" 
										onclick="prepareSupportImagesManageSection({'imageFileType':'RightNavBar'}, this)"> Manage footers </a>
										
								</div>
								<div class="indent form-cont" style="display: none;">
							
									<label class="margin-5px italic"> Right Navigations List </label>
									<a href="javascript:void(0);" class="float-right close-icon" style="clear: none;"> </a>
								
									<ul class="supporting-images-list">
										<s:iterator value="rightNavImages" var="image">
											<li>
												<form class="delete-support-image-form" action="<%= request.getContextPath() %>/image/remove" method="post">
													<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
													<input type="hidden" name="imageFile.imageType" value="Footer" class="">
													
													<input type="hidden" name="imageFile.pkey" class="support-img-pkey" value="<s:property value="%{#image.pkey}" />">
													
													<label class="float-left"> <s:property value="%{#image.fileObjFileName}" /> </label>
													<a class="float-right delete-support-image-btn" href="javascript:void(0);"> delete </a>
												</form>
											</li>
										</s:iterator>
									</ul>
									
								</div>
					        </li>
						</s:if>
					</s:if>

				</ul>
			
			</div>
			
			<div id="hotspots-opts" class="float-fix" style="display: none;">
				
				<div id="hotspots-info" class="float-fix">
					<label class="title"> HotSpots </label>
					
					<ul id="page-hotspots-list" class="float-fix">
						<!-- Dynamically inserted -->
						<li>
					        <label> No HotSpots are present </label>
				        </li>
					</ul>
					
					<div class="float-left margin-5px clear">
						<a href="javascript:void(0)" class="hotspots-icon" onclick="showHideAllHotSpots( this );"> Hide/Show All </a>
					</div>
					
				</div>
				
				<div id="hotspots-edit" style="display: none;">
			
					<label class="title"> Edit HotSpot </label>
					<label class="title sub-title"> Interactions </label>
					
			    	<div id="hotspot-create-form-cont" class="clear float-fix">
						<form id="hotSpotCreateEditForm" action="<%= request.getContextPath() %>/project/build/save_hot_spot" method="post" >
		
							<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />" >
							<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
							
							<input type="hidden" name="hotSpot.pkey" value="" id="hot-spot-pkey" class="hot-spot-pkey">
							
							<input type="hidden" name="hotSpot.fromX" value="" >
							<input type="hidden" name="hotSpot.fromY" value="" >
							<input type="hidden" name="hotSpot.toX" value="" >
							<input type="hidden" name="hotSpot.toY" value="" >
			
							<ul id="edit-events-list" class="float-fix">
								
								<li class="" id="new-events-li">
									
									<div class="new-event-div" index="0">
									
										<input type="hidden" name="uiEvents[0].pkey" value="" class="ui-event-pkey"> 
										<a href="javascript:void(0);" class="bin-icon margin-5px float-right" style="display: none;"></a>
										
										<ul class="new-event-list" >
											<li class="">
												<label class="">on event : </label>
												<select name="uiEvents[0].eventType" class="mandatory short">
													<option value="tap">tap</option>
													<option value="taphold">taphold</option>
													<option value="swipe">swipe</option>
													<option value="swipeleft">swipeleft</option>
													<option value="swiperight">swiperight</option>
												</select>
											</li>
											<li class="">
												<label class="">to screen : </label>
												<select name="uiEvents[0].toPage.pkey" class="mandatory short">
													<s:iterator value="pages" var="page">
														<option value="<s:property value="%{#page.pkey}" />"> <s:property value="%{#page.title}" /> </option>
												    </s:iterator> 
												</select>
											</li>
											<li class="">
												<label class="">transition : </label>
												<select name="uiEvents[0].transitionType" class="mandatory short">
													<option value="fade">fade</option>
													<option value="pop">pop</option>
													<option value="flip">flip</option>
													<option value="turn">turn</option>
													<option value="flow">flow</option>
													<option value="slidefade">slidefade</option>
													<option value="slide">slide</option>
													<option value="slideup">slideup</option>
													<option value="slidedown">slidedown</option>
													<option value="none">none</option>
												</select>
											</li>
										</ul>
										
									</div>
									
									<script type="text/javascript">
										$(document).ready( function() {
											
											// Creating ..... 
											
											$('#add-more-events-btn').live('click',function(){
												$('.new-event-div:last').after($('.new-event-div:last').clone());
												
												// update Index ..
												var newEventDiv = $('.new-event-div:last');
												var oldIndex = parseInt(newEventDiv.attr('index'));
												var newIndex = oldIndex + 1;
												newEventDiv.attr('index', newIndex);
												newEventDiv.find('[name^=uiEvents]').each(function(){
													var name = $(this).attr('name');	
													name = name.replace('[' + oldIndex + ']', '[' + newIndex + ']');
													$(this).attr('name', name).attr('value', '');
												});
																																																
												setBinIcons();
												
											});
											
											$('.new-event-div .bin-icon').live('click', function(){
												var eventDiv = $(this).parents('.new-event-div:first');
												
												var eventPkey = eventDiv.find('.ui-event-pkey').val();
												if(eventPkey && eventPkey != ''){
													var deleteEventPkey = '<%= request.getContextPath() %>/project/build/remove_ui_event?page.pkey=' + currPagePkey + '&uiEvent.pkey=' + eventPkey ;   
													$.getJSON(deleteEventPkey, function(data) {
														if(data) {
															
															// update page hotspots ... 
															updatePageHotSpots();
															
															// remove Event Div .. 
															eventDiv.remove();
														}
													});
												} else {
													eventDiv.remove();
												}
												
												setBinIcons();
											});
											
											function setBinIcons() {
												var binIcons = $('#new-events-li .bin-icon');
												binIcons.hide();
												if(binIcons && binIcons.length > 1){
													binIcons.show();
												}
											};
											
											// Editing ..... 
											
										});
										
									</script >
									
								</li>
								
								<li>
									<div class="margin-5px">
										<a href="javascript:void(0);" class="plus-icon bold margin-5px" id="add-more-events-btn" > Add new Interaction </a>
									</div>
								</li>
								
								<li class="no-border margin-5px" id="">
									<label class="bold"> Title </label>
									<input type="text" name="hotSpot.title" value="" placeholder="name it for easy recognition" class="">
								</li>
								
								<li class="no-border margin-5px" id="">
									<label class="bold"> Notes </label>
									<textarea name="hotSpot.description" placeholder="what is this?" class=""></textarea>
								</li>
								
								<li class="no-border margin-5px">
									<input type="submit" class="float-right btn" value="done" id="save-hotspot-btn" />
									<input type="button" class="float-right btn" value="cancel" id="cancel-hotspot-btn" />
								</li>
							</ul>
							
						</form>
						
					</div>
		    	
		    	</div>
				
			</div>
					
		</section>
		
		<section style="width: 68%; padding-top: 38px;" class="pos-rel" >
		
			<div id="notification-cont" style="display: none;">
				<div id="notification-box" class="error">
					<a href="javascript:void" class="float-left skull-icon-white" id="noification-icon"></a>
					<span class="msg-text"> Something Went Wrong !!! </span>
					<a href="javascript:void(0);" class="float-right close-icon-white" id="noification-close"></a>
				</div>
			</div>
			
			<section id="build-cont" class="">
		
				<div id="screen-imgs-cont" class="">
					<img alt="" src="" id="canvas-screen" class="canvas-bg-img">
					<img alt="" src="" id="canvas-header" class="canvas-bg-img">
					<img alt="" src="" id="canvas-footer" class="canvas-bg-img">
					<img alt="" src="" id="canvas-left-nav" class="canvas-bg-img">
					<img alt="" src="" id="canvas-right-nav" class="canvas-bg-img">
				</div>
				
				<div id="hotspots-cont" class="">
					
					<div id="canvas-cont" class="">
						<canvas id="canvasElem" height="<s:property value="project.layout.height" />" width="<s:property value="project.layout.width" />">
							<p> Unfortunately, your browser is currently unsupported by our web application. We are sorry for the inconvenience. Please use one of the supported browsers listed below. </p>
							<p> Supported browsers: <a href="http://www.opera.com">Opera</a>, <a href="http://www.mozilla.com">Firefox</a>, <a href="http://www.apple.com/safari">Safari</a>, and <a href="http://www.konqueror.org">Konqueror</a>. </p>
						</canvas>
					
					</div>
					
				</div>
	
			</section>
		
		
		</section>
		
	</div>
	
	
	<section id="std-data-cont" class="" style="display: none;">
		
		<!-- Add more images -->
		<div id="" class="">
		
			<form id="upload-imgs-form" action="<%=request.getContextPath()%>/project/build/upload_images" method="post" enctype="multipart/form-data">

				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />"> 
				<input type="hidden" name="imageFileType" value="<s:property value="imageFileType" />">
				
				<input id="images-multiple-input"  type="file" multiple="multiple" name="screenImages.fileObj" value="">
	
			</form>
										
		</div>
		
		<!-- HotSpot Coordinates Form -->
		<form id="hotSpotCoordinatesForm" action="<%= request.getContextPath() %>/project/build/save_hot_spot_coordinates" method="post" >
		
			<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />" >
			<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
			
			<input type="hidden" name="hotSpot.pkey" value="" class="hot-spot-pkey">
			
			<input type="hidden" name="hotSpot.fromX" value="" >
			<input type="hidden" name="hotSpot.fromY" value="" >
			<input type="hidden" name="hotSpot.toX" value="" >
			<input type="hidden" name="hotSpot.toY" value="" >
			
		</form>
	
	</section>
	
	
	<section class="pop-ups-cont" style="display: none;">
		
		<!-- Page Screen Change pop-up -->

		<div id="page-screen-change-popup" class="pop-up">
		
			<form id="managePageScreenForm" action="<%= request.getContextPath() %>/project/build/update_image" method="post" enctype="multipart/form-data">
									
				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
				<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
				<input type="hidden" name="imageFile.pkey" value="<s:property value="imageFile.pkey" />" class="curr-page-img-pkey">
								
				<input type="file" name="imageFile.fileObj" id="page-screen-input">
				
			</form>
		</div>
		

		<!-- Page Delete pop-up -->

		<div id="page-delete-popup" class="pop-up">
			<form id="deletePageForm" action="<%= request.getContextPath() %>/project/build/remove_page" method="post">
									
				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
				<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
								
				<div class="pu-header float-fix">
					<label class="pu-title float-left"> Are You Sure ? </label>
				</div>
				<div class="pu-body float-fix">
					<label class="pu-title float-left"> Deleting a Page will delete all its Hotspots, Images and other settings </label>
				</div>
				<div class="pu-footer float-fix" style="padding-top: 25px">
					<div class="btn-cont float-right">
						<input type="button" value="No" id="" class="close-pop-up btn">
						<input type="submit" class="btn btn-yellow" value="Yes" />
					</div>
				</div>
			</form>
		</div>
		
		
		<!-- Project Preview Container -->
		
		<a href="#project-preview-popup" id="preview-popup-link" class="fancy-box-link"> </a>
		
		<div id="project-preview-popup" class="pop-up">
			
			<div id="preview-cont">
				<iframe src="" id="preview-iframe"> 
					<p> Oooops ... , your browser currently doesn't support IFrames .. !!!</p>
					<p> Supported browsers: <a href="http://www.opera.com">Opera</a>, <a href="http://www.mozilla.com">Firefox</a>, <a href="http://www.apple.com/safari">Safari</a>, and <a href="http://www.konqueror.org">Konqueror</a>. </p>
				</iframe>
			</div>
			
			<script type="text/javascript">

			/* Project Preview */

			function showPreviewInModal(projectPkey, layoutWidth, layoutHeight){
				if (!layoutWidth)
					layoutWidth = $('#proj-width').val();
				
				if (!layoutHeight)
					layoutHeight = $('#proj-height').val();
				
				var previewUrl = '<%=request.getContextPath()%>/publish/preview?project.pkey=' + projectPkey ;
				
				var landingPagePkey = $('#landing-page-pkey').val();
				if(landingPagePkey && landingPagePkey != '')
					previewUrl += '#page-' + landingPagePkey ;
				
				
				// Fancybox ... 
				var previewCont = $('#preview-cont');
				previewCont.find('iframe').attr('src', previewUrl );
				
				$('#preview-popup-link').trigger('click');	
				
			};
			
			</script>
			
		</div>
		
		
		
		<!-- Project Publish pop-up -->
		
		<div id="project-publish-popup" class="pop-up">
				
			<div class="pu-header float-fix">
				<label class="pu-title"> <s:property value="project.title" /> </label>
			</div>
			
			<div class="pu-body float-fix">
				<div class="msg-cont">
				
				</div>
				<div class="pu-content float-fix">
				
					<form id="projectPublishForm" action="<%= request.getContextPath() %>/publish/manage_details" method="post">
				
						<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
						<input type="hidden" name="publishDetails.pkey" value="<s:property value="publishDetails.pkey" />">

						<div id="publish-msg-cont" class="float-left padding-5px">
							
							<label class="clear gray-999-text"> Project Name : </label>
							<label class="clear gray-333-text"> <s:property value="project.title" /> </label>
							
							<label class="clear gray-999-text" style="margin-top: 15px;"> Notes to the Users : </label>
							<textarea name="project.description" rows="" cols="" class="float-left clear inp-box inner-shadow" placeholder="Project description" > <s:property value="project.description"/> </textarea>
							
							<%-- 
							<label class="clear gray-999-text" style="margin-top: 15px;"> Pass key : </label>
							<input name="publishDetails.passKey" class="float-left clear inp-box inner-shadow" value="<s:property value="publishDetails.passKey" />" placeholder="optional" />
							 --%>
							
						</div>
						
						<div id="publish-users-cont" class="float-left padding-5px">
						
							<div id="publish-visibility" class="float-fix">
								<input type="radio" name="" value="true" id="visible-public" checked="checked" class="isPublic">
								<label for="visible-public">Public</label>
								<input type="radio" name="" value="false" id="visible-private" class="isPublic">
								<label for="visible-private">Private</label>
								
								<input type="hidden" name="project.isPublic" value="true">
							</div>
							
							<div id="publish-public-note">
								<label>Public</label>
							</div>
						
							<div id="publish-contacts-cont" style="display: none;">
							
								<label class="clear gray-999-text"> Add user email-ids : </label>
							 	
							 	<ul class="clear" id="app-users-list">
							 	
							 		<s:iterator value="appUsers" var="appUser" status="idx">
							 			
							 			<li>
							 			
	<%-- 						 				<s:if test="%{#appUser.pkey != null && #appUser.name != '' }"> --%>
	<%-- 						 					<label><s:property value="%{#appUser.name}" /></label> --%>
	<%-- 						 				</s:if> --%>
	<%-- 						 				<s:else> --%>
							 					<label><s:property value="%{#appUser.emailId}" /></label>
	<%-- 						 				</s:else> --%>
	
											<s:if test="%{#appUser.isPublisher != true }">
							 					<a href="javascript:void(0);" class="bin-icon float-right" ></a>
							 				</s:if>
							 				<s:else>
							 					<span class="float-right"> Yourself </span>
							 				</s:else>
							 				
							 				<input type="hidden" name="appUsers[<s:property value="%{#idx.index}" />].emailId" value="<s:property value="%{#appUser.emailId}" />">
							 				<input type="hidden" name="appUsers[<s:property value="%{#idx.index}" />].pkey" value="<s:property value="%{#appUser.pkey}" />">
							 			
							 			</li>
	
								    </s:iterator> 
	
							 	</ul>
							
								<div class="float-right float-fix">
									<input type="text" class="inp-box inner-shadow " placeholder="Enter user(s) email-id(s) to invite" id="add-app-user-input">
									<a id="add-app-user-btn" href="javascript:void(0);"> + Add </a>
								</div>
						
							</div>
							
						</div>
					</form>
					
				</div>
			</div>
			<div class="pu-footer float-fix">
				<div class="btn-cont float-right no-margin no-padding">
					<input type="button" value="Publish Project" id="publish-proj-btn" class="btn btn-yellow">
				</div>
			</div>
		
		</div>
		
		<script type="text/javascript">
		
			$(document).ready( function() {
				
				
				var projectPublishPopUp = $('#project-publish-popup');
				// Project Publishing ...
				
				$('#add-app-user-btn').live('click', function(){
					
					var appUserHtml = '';
					
					var appUserInput = $('#add-app-user-input');
					var appUserEmailId = appUserInput.val();

					if (appUserEmailId) {
						appUserHtml += '<li>';
						appUserHtml += '<label>' + appUserEmailId + '</label>';
						appUserHtml += '<a href="javascript:void(0);" class="bin-icon float-right" ></a>';
						appUserHtml += '<input type="hidden" name="appUsers.emailId" value="' + appUserEmailId + '">';
						appUserHtml += '</li>';
					}
					
					$('#app-users-list').append(appUserHtml);				
					appUserInput.val('');
					
				});
				
				$('#app-users-list .bin-icon').live('click', function(){
					$(this).parents('li').remove();	
				});
				
				$('#publish-proj-btn').live('click', function(){
					$('#projectPublishForm').ajaxForm({
						beforeSubmit: function (data){},
						success: function (data){
							// re load the publish details 
						},
						complete: function(){
							$.fancybox.close();
						}
					}).trigger('submit');
				});
				
			});
		
		</script>
		
		
	</section>

</body>

</html>		