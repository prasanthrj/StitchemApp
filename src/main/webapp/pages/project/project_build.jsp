
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>
<head>
	<meta>
	
	<title> Project Builder  </title>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/themes/build.css" media="screen"/>
	
	<script type="text/javascript">
	
	var contextPath = '<%= request.getContextPath() %>';
	var loggedInUserName = '<s:property value="loggedInUser.username"/>'
	
	/* Global variables */

	var projectPkey = parseInt('<s:property value="project.pkey" />');
	var projectWidth = parseInt('<s:property value="project.layout.width" />');
	var projectHeight = parseInt('<s:property value="project.layout.height" />');
	var projectOrientation = '<s:property value="project.layout.orientation" />';
	
	var projectType = '<s:property value="project.projectType" />';
	
	var scaledWidth = projectWidth;
	var scaledHeight = projectHeight;
	
	var imageUrlPrefix = contextPath + '/image/view?project.pkey=' + projectPkey + '&imageFile.pkey=';

	var currNoOfPages = parseInt('<s:property value="pages.size()" />');
	
	var currLandingPagePkey = parseInt('<s:property value="project.layout.landingPage.pkey" />');
	
	var currPagePkey = parseInt('<s:property value="page.pkey" />');
	var currPageObj = {};
	var currentHotSpots = null;
	
	var canVasElementId = "canvasElem";
	var hotSpotsHolderId = 'canvas-cont';
	var hsDivPrefix = 'hs-div-';
	
	var clickX = new Array();
	var clickY = new Array();
	var clickDrag = new Array();

	var editFillStyle = "rgba(255, 255, 51, 0.5)";
	var defFillStyle = "rgba(255, 255, 51, 0.5)";
	var greenFillStyle = "rgba(8, 130, 11, 0.5)";

	</script>
	
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/canvas-prototype.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/builder-functions.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/builder-tools.js"></script>
	
	<script type="text/javascript">
	
	$(document).ready( function() {
		
		var scaledDims = calculateScaledDimentionsForBuild(projectType, projectWidth, projectHeight);
		
		$('.scaled-width').css({ 'width' : scaledWidth + 'px' });
		$('.scaled-height').css({ 'height' : scaledHeight + 'px' });
		
		$('#screen-imgs-cont').css({
			'width' : scaledWidth + 'px',
			'height' : scaledHeight + 'px',
			'overflow' : 'hidden'
		});
		
		/* Window resize related ... */
		var buildCont = $('#build-cont'); 
		buildCont.css({
			'width' : scaledWidth + 'px',
			'height' : scaledHeight + 'px'
		});
		
		adjustToWindowDimentions();
		$(window).resize(function() {
			adjustToWindowDimentions();
		});
		
		
		/* Setting initial Visible Items ... */
		var mainCont = $('#main-cont');
		if(currNoOfPages == 0) {
			toggleBuildOptionsVisibility(false);
		}
		
		
		/* Carousel ... */
		var carouselPagesList = $('#pages-list');
		if(carouselPagesList.find('li').length > 0) {
			carouselPagesList.jcarousel({
				initCallback : pagesListCarouselInitCallback,
	            reloadCallback : pagesListCarouselInitCallback
			});
		}
		
		/* Drag-Drop file Upload ... */
		prepareFileDropUpload("carousel-cont");
		
		/* Set Landing Page */
		if(currLandingPagePkey && currLandingPagePkey != '') {
// 			updateAndSelectLandingPage(currLandingPagePkey);
			$('#landing-page-radio-' + currLandingPagePkey ).check();
		}
		
		/* Load the first page for editing .. */
		if(currPagePkey && currPagePkey != '') {
			preparePageForEditing( currPagePkey );
		}
			
		/* Prepare Hotspots Editing */
		prepareCanvasToolsForPage();
		
		
		/* attach page editing and tool tip */
		var toolTipCont = $('#tooltip-cont');
		$('#pages-list li .page-thumb-image-cont').live({
			click : function(event){
				var pagePkey = $(this).find('input.page-pkey').val();
				preparePageForEditing( pagePkey, this );
			},
			mouseenter : function() {
				var thumb = $(this);
				var ttCont = thumb.find('.tooltip-content:first');
				ttCont.show();
			},
			mouseleave : function() {
				var thumb = $(this);
				var ttCont = thumb.find('.tooltip-content:first');
				ttCont.hide();
			}
		});
		
		$('#pages-list li input[type=radio]').customInput();
		
		
		
		/* Page title */
		
		var managePageTitleForm = $('#managePageTitleForm');
		managePageTitleForm.ajaxForm({
			success: function (data){
				if(data && data.page) {
					$('.page-' + data.page.pkey + '-title').html(data.page.title);
					if(currPagePkey == data.page.pkey ) {
						$('input.curr-page-title').attr('value', data.page.title);
						$('a.curr-page-title').html(data.page.title);
					}
					
					$.fancybox.close();
					showNotificationMsg( 'success', "Page title has been successfully updated to " +  data.page.title);
				}
			},
			beforeSubmit: function (data){
				var isFormValid = true;
				managePageTitleForm.validateForm({
					failureFunction : function(element){
						$(element).addClass('error');
						isFormValid = false;
					},
					successFunction : function(element){
						$(element).removeClass('error');
					},
					onValidForm : function(form){
						isFormValid = true;
					}
				});
				
				return isFormValid;
			},
			complete: function(){
				$.fancybox.close(); 
			} 
		});

		
		/* Page Screen */
		
		$('#page-screen-input').live('change', function(){
			
			var currentPagePkey = parseInt($('#curr-page-pkey').val()); 
			showNotificationMsg('status', "screen image uploading");
			
			$('#managePageScreenForm').ajaxForm({
				success: function (data) {
					showNotificationMsg('success', "screen image successfully updated");
					
					// TODO Handle this
					window.location.reload(true);
				},
				complete: function(){} 
			}).trigger('submit');
		});
		
		$('.delete-page-icon').live('click', function(event){
			preventEventDefaults(event);
		});
		
		$('.landing-page-radio').live('click', function(event){
			event.stopPropagation();
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

		$('.delete-support-image-btn').live('click', function() {
			var btn = $(this);
			
			var form = btn.parents('form:first');
			var formLi = form.parents('li:first');
			var imgPkey = form.find('.support-img-pkey').val();
			
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
							showNotificationMsg( msgBean.messageType , msgBean.message || "File Successfully deleted !!!" );
						}
					}
				}
			}).trigger('submit');
			
		});
		
	});
	
	
	/* Window resize */
	function adjustToWindowDimentions() {
		
		// body .. 
		adjustBodyToWindowDimensions();
		
		var bodyCont = $('#body-cont');
		
		var buildCont = $('#build-cont'); 
		var buildLeftCont = $('#build-left-cont');
		var buildRightCont = $('#build-right-cont');
		
		var availWidth = parseInt(bodyCont.width() - buildCont.outerWidth(true));
		var widthForCont = Math.floor((availWidth - 50)/2);
		
		buildLeftCont.css({
			'width' : widthForCont + 'px',
			'height' : scaledHeight + 'px'
		});
		
		buildRightCont.css({
			'width' : widthForCont + 'px',
			'height' : scaledHeight + 'px'
		});
		
	};
	
	
	
	/* Functions */
	
	function toggleBuildOptionsVisibility(showOptions) {
		var mainCont = $('#main-cont');
		var pageFunctions = $('.page-function');
		
		if(showOptions){
			mainCont.show();
			pageFunctions.show();
			
		} else {
			mainCont.hide();
			pageFunctions.hide();
			
		}
	};
	
	function resetBuildPage() {
		
		currPagePkey = null;
		$('.curr-page-pkey').attr("value", "");
		
		$('#pages-list').find('li.selected').removeClass('selected');
		
		$('.page-title').html('');
		$('input.page-title').attr('value', '');
		
		// Build info 
		$('.screen-hotspots-count').html(0); 
		
		// Build cont 
		$('.canvas-bg-img').attr('src', '');
		$('.div-hotspot').remove();
		
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
		
		toggleBuildOptionsVisibility(true);
		
		/* Screen info */
		
		// Screen Name  
		$('a.curr-page-title').html(page.title);
		$('input.curr-page-title').attr('value', page.title);
		
		// Image editable pkey 
		$('.curr-page-img-pkey').val(page.screenImage.pkey);
		
		$('#screen-dimensions').html(page.screenImage.width + 'px X ' + page.screenImage.height + 'px');
		
		// HotSpots count 
		$('.screen-hotspots-count').html( currentHotSpots.length || 0 );
		

		/* Build Container */
		
		// Canvas Cont and Images	
		$('.canvas-bg-img').attr('src', ' ');

		$('#canvas-screen').attr('src', imageUrlPrefix + page.screenImage.pkey );
		
		if( page.headerImage && page.headerImage.pkey ) {
			var pageHeaderImagePkey = page.headerImage.pkey;
			$('#canvas-header').attr('src', imageUrlPrefix + pageHeaderImagePkey);
			updateSupportingImage({ 'imageType' : 'header', 'imagePkey' : pageHeaderImagePkey });
		}
		
		if(page.footerImage && page.footerImage.pkey) {
			var pageFooterImagePkey = page.footerImage.pkey;
			$('#canvas-footer').attr('src', imageUrlPrefix + pageFooterImagePkey);
			updateSupportingImage({ 'imageType' : 'footer', 'imagePkey' : pageFooterImagePkey });
		}
		
		if(page.leftNavImage && page.leftNavImage.pkey) {
			var	pageLeftNavImagePkey = page.leftNavImage.pkey;
			$('#canvas-leftNav').attr('src', imageUrlPrefix + pageLeftNavImagePkey);
			updateSupportingImage({ 'imageType' : 'leftNav', 'imagePkey' : pageLeftNavImagePkey });
		}
		
		if(page.rightNavImage && page.rightNavImage.pkey) {
			var pageRightNavImagePkey = page.rightNavImage.pkey;
			$('#canvas-rightNav').attr('src', imageUrlPrefix + pageRightNavImagePkey);
			updateSupportingImage({ 'imageType' : 'rightNav', 'imagePkey' : pageRightNavImagePkey });
		}
		
	};
	
	function loadPageHotSpots(hotSpots) {
		if(hotSpots) {
			// update links			
			loadPageLinks(hotSpots);
			
			// Clean old hotSpots 
			var hotSpotsHolder = $('#' + hotSpotsHolderId);
			hotSpotsHolder.find('.div-hotspot').remove();
			
			drawAllHotSpots(hotSpots, defFillStyle);
		}
	};
	
	function loadPageLinks(hotSpots) {
		if(hotSpots) {
			
			var pageLinksList = $('#page-links-list');
			var pageLinksHtml = '';
			
			var pagePkeys = [];
			var uiEvents;
			for (var i = 0; i < hotSpots.length; i++) {
				uiEvents = hotSpots[i].uiEvents;
				
				var toPage;
				for ( var j = 0; j < uiEvents.length; j++) {
					var uiEvent = uiEvents[j];
					toPage = uiEvent.toPage;
					
					var index = $.inArray(toPage.pkey , pagePkeys);
					if(index == -1) {
						pageLinksHtml += '<li onclick="preparePageForEditing(' + toPage.pkey  + ')" pagePkey="' + toPage.pkey + '">';
						pageLinksHtml += '<label class="page-' + toPage.pkey + '-title">' + toPage.title  + '</label>';
						pageLinksHtml += '</li>';
						
						pagePkeys.push(toPage.pkey);
					}
				}
			}
			
			pageLinksList.html(pageLinksHtml);
		}
	};
	
	function removeHotSpot( hotSpotPkey, element ) {
		if( hotSpotPkey ){
			if(hotSpotPkey == 0) {
				$('#' + hsDivPrefix + hotSpotPkey ).remove();
				return false;
			}
			
			var currPagePkey = $('#curr-page-pkey').val();
			var deleteHotSpotUrl = '<%= request.getContextPath() %>/project/build/remove_hot_spot?hotSpot.pkey=' + hotSpotPkey + '&page.pkey=' + currPagePkey ;
			$.getJSON(deleteHotSpotUrl, function(data){
				if(data) {
// 					updatePageHotSpots(); 
					$('#' + hsDivPrefix + hotSpotPkey ).remove();
				}
			});
		}
		return false;
	};
	
	function updatePageHotSpots(){
		var fetchHotSpotsUrl = '<%= request.getContextPath() %>/project/build/fetch_all_hot_spots?page.pkey=' + currPagePkey ;
		$.getJSON(fetchHotSpotsUrl, function(data) {
			if(data) {
				loadPageHotSpots(data.hotSpots);
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
				if (!fromX || !toX) return false;
			},
			success: function (data){

			}
		}).trigger('submit');
	};
	
	
	/* update Landing Page .. */
	
	function updateProjectLandingPage( element ) {
		
		var isChecked = $(element).is(':checked');
		var landingPagePkey = $(element).val();
		
		if(landingPagePkey && landingPagePkey != '' && landingPagePkey != currLandingPagePkey) {
			var landingPageForm = $('#manageLandingPageForm');
			landingPageForm.find('.landing-page-pkey').attr('value', landingPagePkey);
			landingPageForm.find('input[name=isLandingPage]').attr('value', isChecked);	
			landingPageForm.ajaxForm({
				success : function(data){
					if(data && data.messageBean) {
						
						showNotificationMsg(data.messageBean.messageType, data.messageBean.message );
						
						// Update the landing page details 
						var landingPagePkeyInp = $('#landing-page-pkey');
						
						if(isChecked){
							landingPagePkeyInp.attr('value', landingPagePkey);
							currLandingPagePkey = landingPagePkey;
						} else {
							landingPagePkeyInp.attr('value', '');
						}
						
						// Update the landing page li 
						$('#pages-list li').removeClass('curr-landing-page');
						$('#car-page-' + landingPagePkey).addClass('curr-landing-page');
						
					}
				}
			}).trigger('submit');
			
		}
	};
	
	/* edit Page title.. */
	
	function preparePageTitleEditPopUp(element, pagePkey) {
		if(pagePkey == null || pagePkey == '')
			pagePkey = $('#curr-page-pkey').val();
		
		if(pagePkey && pagePkey != '') {
		
			var	pageTitle = $(element).text();
			if(pageTitle == null || pageTitle == '')
				pageTitle = $('#curr-page-title').val();
			
			// popup 
			var titleForm = $('#managePageTitleForm');
			titleForm.find('.curr-page-pkey').attr('value', pagePkey);
			titleForm.find('.curr-page-title').attr('value', pageTitle);
			
			$('#page-title-change-popup-btn').trigger('click');
			
		} else {
			showNotificationMsg('status', "No screen exists");
			alert('upload screens');
		}

	};
	
	
	/* replace Page */
	
	function preparePageReplace(pagePkey) {
		if(!pagePkey || pagePkey == '')
			pagePkey = parseInt($('#curr-page-pkey').val());
		
		if(pagePkey && pagePkey != '') {
			$('#page-screen-input').trigger('click');
		} else {
			showNotificationMsg('status', "No screen exists");
			alert('upload screens');
		}
	};
	
	
	/* delete Page */
	
	function preparePageDeletePopUp(pagePkey) {
		if(!pagePkey || pagePkey == '')
			pagePkey = $('#curr-page-pkey').val();
		
		if(pagePkey && pagePkey != '') {
			
			// popup 
			var titleForm = $('#deletePageForm');
			titleForm.find('.curr-page-pkey').attr('value', pagePkey);
			
			$('#page-delete-popup-btn').trigger('click');
			
		} else {
			showNotificationMsg('status', "No screen exists");
			alert('upload screens');
		}
	
	};
	
	
	
	/* Page Comments */
	
	function loadPageComments(comments) {
		if(comments){
			// TODO yet to be decided 
		}
	};	
	
	
	
	// File uploader .. 
	
	function openFileUploader( options ) {
		var imageFileType = options.imageFileType;
		if(!imageFileType || imageFileType == '')
			imageFileType == 'screen';
		
		var uploadForm = $('#upload-imgs-form');
		uploadForm.find('input.imageFileType').attr('value', imageFileType);
		
		var multiFileInput = $('#images-multiple-input');
		multiFileInput.attr('name', imageFileType + 's.fileObj').trigger('click');
		multiFileInput.die('change').live('change', function(event){
			if (imageFileType == 'screen') {
				screenImagesUploader(event, this);
			} else {
				regularfileUploader(event, this, imageFileType);
			}
		});		

	};
	
	// Supporting Images Manage 
	
	function openSupportingImageSelector( inElement, inCss ) {
		if(inElement){
			var element = $(inElement);
			var suppImgCont = element.parents('.supp-img-cont:first');
			var suppImgs = suppImgCont.find('.tooltip-content');
			
			suppImgs.css({
				'position' : 'absolute', 
				'z-index' : 100,
			}).css(inCss);
			
			$('.tooltip-content').not(suppImgs).hide('fade');
			suppImgs.show('fade');
			
			// Open file selector if no images are selected .. 
			var suppImgsCnt = suppImgCont.find('.supporting-images-list:first li').length;
			if(!suppImgsCnt || suppImgsCnt <= 1) {
				suppImgCont.find('a.upload-supp-imgs-btn:first').trigger('click');
			}
			
		}
	};
	
	function updateSupportingImage(options) {
		if(options && options.imagePkey && options.imageType) {
			
			var imgURL = '';
			if(options.imagePkey != 0)
				imgURL = imageUrlPrefix + options.imagePkey ;
			
			var form = $('#update-supp-img-form'); 
			form.find('.img-pkey').attr('value', options.imagePkey);
			form.find('input[name$=imageType]').attr('value', options.imageType);
			
			form.ajaxForm({
				success: function (data){
					if(data) {
						
						$('#canvas-' + options.imageType ).attr('src', imgURL);
						
						// highlight the li 
						var list = $('.supporting-images-list[imagetype=' + options.imageType + ']');
						list.find('li').removeClass('selected');
						
						var elem = $('#supp-' + options.imageType + '-' + options.imagePkey );
						elem.addClass('selected');

					}
				} 			
			}).trigger('submit');

		
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
		<input type="hidden" value="" id="curr-page-title" class="curr-page-title">
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
				<li >
					<a href="<%= request.getContextPath() %>/project/settings?project.pkey=<s:property value="project.pkey" />&user.emailId=<s:property value="user.emailId"/>" class="btn">
						<img alt="" src="<%= request.getContextPath() %>/themes/images/icon_settings.png">
					</a>
				</li>
				<li>
	              	<a href="javascript:void(0)" class="btn" id="preview-btn" title="preview the project output"
	              		onclick="showPreviewInModal(<s:property value="project.pkey"/>);" > preview </a>
				</li>
				<li>
					<a href="<%= request.getContextPath() %>/project/publish_opts?project.pkey=<s:property value="project.pkey" />&user.emailId=<s:property value="user.emailId"/>" class="btn btn-yellow" id="publish-btn"> publish </a>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="top-cont" class="<s:property value="project.projectType"/> <s:property value="layout.orientation"/>" style="border: none;">
		
		<div id="carousel-cont" class="yellow-bg">
			
			<div id="droppable-overlay" style="display: none;">
				<label class="" style="">Drop Files here</label>
			</div>
			
			<ul id="pages-list" class="carousel-list">
				<s:if test="%{pages != null && pages.size() > 0}">
					<s:iterator value="pages" var="page">
						<li id="car-page-<s:property value="%{#page.pkey}" />" title="click to edit screen" >
							
							<div class="page-thumb-image-cont">
								
								<div class="img-cont">
									<input type="hidden" class="page-pkey" value="<s:property value="%{#page.pkey}" />" />
									<img alt="<s:property value="%{#page.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#page.screenImage.pkey}" />">
								</div>
								
								<div class="tooltip-content page-tt-content" style="display: none;">
									<div class="tt-outer">
										<div class="tt-inner">
											<div class="float-left">
												<input type="radio" name="landingPagePkey" value="<s:property value="%{#page.pkey}" />" 
													id="landing-page-radio-<s:property value="%{#page.pkey}" />" onclick="updateProjectLandingPage(this);" />
												<label for="landing-page-radio-<s:property value="%{#page.pkey}" />" class="landing-page-radio" >&nbsp;</label>
											</div>
											<div class="float-right">
												<a href="javascript:void(0)" onclick="preparePageDeletePopUp(<s:property value="%{#page.pkey}" />)" class="delete-page-icon float-right" >&nbsp;</a>
											</div>
											<div class="pos-abs thumb-details-cont">
												<a class="page-<s:property value="%{#page.pkey}" />-title auto-ellipses" href="javascript:void(0)" onclick="preparePageTitleEditPopUp(this, <s:property value="%{#page.pkey}" />)"><s:property value="%{#page.title}" /></a>
											</div>
										</div>
									</div>
								</div>
								
							</div>
							
						</li>
					</s:iterator>
				</s:if>
			</ul>
			<s:else>
				<div id="no-items-cont">
					<a href="javascript:void(0);" class="plus-icon float-left" title="click to upload screen images" 
						onclick="openFileUploader({'imageFileType':'screen'});" > Upload Screens </a>
					<label class=""> or drop them here</label>
				</div>
			</s:else>
			
		</div>
			
		<div id="build-nav-cont" class="">
			<div id="page-title-cont" class="float-left page-function" style="padding: 1px 15px;">
				<a href="javascript:void(0)" class="curr-page-title float-left margin-5px " title="click to rename the screen" 
					onclick="preparePageTitleEditPopUp(this)"> Page Title </a>
			</div>
			
			<div id="notification-cont" style="display: none;">
				<div id="notification-box" class="error">
<!-- 					<a href="javascript:void" class="float-left skull-icon-white" id="noification-icon"></a> -->
					<span class="msg-text"> Something Went Wrong !!! </span>
<!-- 					<a href="javascript:void(0);" class="float-right close-icon-white" id="noification-close"></a> -->
				</div>
			</div>
			
			<div id="page-options-cont" class="float-right">
				<ul id="page-options-list" class="inline-list">
					
					<li id="" class="">
						<a href="javascript:void(0)" class="screen-icon page-function" title="replace the current screen image"
							id="page-screen-btn" onclick="preparePageReplace();"> replace </a>
					</li>
					<li id="" class="">
						<a href="javascript:void(0)" class="bin-icon page-function" title="delete the screen completely"
							id="page-delete-btn" onclick="preparePageDeletePopUp();"> delete </a>
					</li>
					
					<li class="separator">|</li>
					
					<li id="" class="">
						<a href="javascript:void(0);" class="upload-icon" title="upload more screen images" 
							onclick="openFileUploader({'imageFileType':'screen'});" > upload </a>
					</li>
					
					<li class="" >
						<a class="collapse-icon">&nbsp;</a>
					</li>
				</ul>
			</div>
		</div>
	
	</div>
	
	<div id="main-cont" class="<s:property value="project.projectType"/> <s:property value="layout.orientation"/>" style="display: none;">
	
		<section id="build-left-cont" >
			
			<div id="page-header-cont" class="supp-img-cont">
				<div class="pos-rel">
				
					<a class="float-right bold tooltip-header" href="javascript:void(0)"  
						onclick="openSupportingImageSelector(this, {'top' : '25px', 'right' : '0px'})"> + choose header </a>
					
					<div class="tooltip-content supp-img-tt-content" style="display: none;">
						<div class="tt-outer top-right">
							<div class="tt-inner">
								<ul class="supporting-images-list" imageType="header">
									<li id="supp-header-0" class="selected">
										<a href="javascript:void(0);" class="supp-img-label"
											onclick="updateSupportingImage({'imagePkey':'0', 'imageType':'header'});"> No Header </a>
										
									</li>
									<s:iterator value="headerImages" var="image">
										<li id="supp-header-<s:property value="%{#image.pkey}" />">
											<a href="javascript:void(0);" class="supp-img-label"
												onclick="updateSupportingImage({'imagePkey':'<s:property value="%{#image.pkey}" />', 'imageType':'header'});">
												<s:property value="%{#image.fileObjFileName}" />
											</a>
											
											<form class="delete-support-image-form" action="<%= request.getContextPath() %>/image/remove" method="post">
												<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
												<input type="hidden" name="imageFile.imageType" value="header" class="">
												<input type="hidden" name="imageFile.pkey" class="support-img-pkey" value="<s:property value="%{#image.pkey}" />">
												
												<a class="float-right delete-support-image-btn bin-icon" href="javascript:void(0);">&nbsp;</a>
											</form>
										</li>
									</s:iterator>
								</ul>
								<a class="plus-icon upload-supp-imgs-btn" href="javascript:void(0);" 
									onclick="openFileUploader({'imageFileType':'header'});"> upload headers </a>
							
							</div>
						</div>
					</div>

				</div>
			</div>
			
			<div id="page-footer-cont" class="supp-img-cont">
				<div class="pos-rel">
			
					<a href="javascript:void(0)" class="float-right bold tooltip-header"
						onclick="openSupportingImageSelector(this, {'bottom' : '10px', 'right' : '0px'})"> + choose footer </a>
					
					<div class="tooltip-content supp-img-tt-content" style="display: none;">
						<div class="tt-outer bottom-right">
							<div class="tt-inner">
								<ul class="supporting-images-list" imageType="footer">
									<li id="supp-footer-0" class="selected">
										<a href="javascript:void(0);" class="supp-img-label"
											onclick="updateSupportingImage({'imagePkey':'0', 'imageType':'footer'});"> No Footer </a>
									</li>
									<s:iterator value="footerImages" var="image">
										<li id="supp-footer-<s:property value="%{#image.pkey}" />">
											
											<a href="javascript:void(0);" class="supp-img-label"
												onclick="updateSupportingImage({'imagePkey':'<s:property value="%{#image.pkey}" />', 'imageType':'footer'});">
												<s:property value="%{#image.fileObjFileName}" />
											</a>
											 
											<form class="delete-support-image-form" action="<%= request.getContextPath() %>/image/remove" method="post">
												<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
												<input type="hidden" name="imageFile.imageType" value="footer" class="">
												<input type="hidden" name="imageFile.pkey" class="support-img-pkey" value="<s:property value="%{#image.pkey}" />">
												
												<a class="float-right delete-support-image-btn bin-icon" href="javascript:void(0);">&nbsp;</a>
											</form>
										</li>
									</s:iterator>
								</ul>
								<a class="plus-icon upload-supp-imgs-btn" href="javascript:void(0);" 
									onclick="openFileUploader({'imageFileType':'footer'});"> upload footers </a>
							
							</div>
						</div>
					</div>
			
				</div>
			</div>
			
			<s:if test="%{#projType != null && #projType != '' }">
				<s:if test="%{#projType != 'AndroidMobile' && #projType != 'Iphone3' && #projType == 'Iphone4'}">
					
					<div id="page-leftNav-cont" class="supp-img-cont">
						<div class="pos-rel">
							<!-- Yet to Come -->
						</div>
					</div>
					
					<div id="page-rightNav-cont" class="supp-img-cont">
						<div class="pos-rel">
							<!-- Yet to Come -->
						</div>
					</div>
					
				</s:if>
			</s:if>
			
		</section>
	
		<section id="build-cont" class="">
	
			<div id="screen-imgs-cont" class="">
				<img alt="" src="" id="canvas-screen" class="canvas-bg-img scaled-width">
				<img alt="" src="" id="canvas-header" class="canvas-bg-img scaled-width">
				<img alt="" src="" id="canvas-footer" class="canvas-bg-img scaled-width">
				<img alt="" src="" id="canvas-leftNav" class="canvas-bg-img scaled-height">
				<img alt="" src="" id="canvas-rightNav" class="canvas-bg-img scaled-height">
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
		
		<section id="build-right-cont" >
			
			<div id="" class="float-fix" style="margin: 50px 5px 20px 5px;">
				<a href="javascript:void(0)" class="hotspots-icon" title="toggle hot-spots visibility" 
					onclick="showHideAllHotSpots(this);"> HotSpots : <span class="screen-hotspots-count"> 0 </span> </a>
			</div>
			
			<div id="" class="float-fix margin-5px">
				<label class="bold" style="line-height: 20px; font-size: 14px; display: block;"> screens linked to </label>
				
				<!-- page links -->
				<ul id="page-links-list">
				
				</ul>
			</div>

		</section>
		
		<div class="clear-float"></div>
	</div>
	
	
	<section id="std-data-cont" class="" style="display: none;">
		
		<!-- Add More Images Form -->
		
		<form id="upload-imgs-form" action="<%=request.getContextPath()%>/project/build/upload_images" method="post" enctype="multipart/form-data">
			<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />"> 
			<input type="hidden" name="imageFileType" value="<s:property value="imageFileType" />">
			
			<input id="images-multiple-input"  type="file" multiple="multiple" name="screenImages.fileObj" value="">

		</form>

		
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
		
		
		<!-- Update Landing Page Form -->
		
		<form id="manageLandingPageForm" action="<%=request.getContextPath()%>/project/build/update_landing_page" method="post" >
     		<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
     		<input type="hidden" name="page.pkey" value="" class="landing-page-pkey">
     		<input type="hidden" name="isLandingPage" value="">
     	</form>
     	
     	
     	<!-- Page Screen Change pop-up -->

		<form id="managePageScreenForm" action="<%= request.getContextPath() %>/project/build/update_image" method="post" enctype="multipart/form-data">
			<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
			<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
			<input type="hidden" name="imageFile.pkey" value="<s:property value="imageFile.pkey" />" class="curr-page-img-pkey">
							
			<input type="file" name="imageFile.fileObj" id="page-screen-input">
			
		</form>
		
		<!-- Page Supporting image update -->

		<div>
			<form id="update-supp-img-form" action="<%= request.getContextPath() %>/project/build/save_page" method="post">
				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
				<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
				<input type="hidden" name="imageFile.imageType" value="header" class="">
				<input type="hidden" name="imageFile.pkey" class="img-pkey" value="">		
			</form>
		</div>
     	
	
	</section>
	
	
	<section class="pop-ups-cont" style="display: none;">
	
		<!-- Page Title Change pop-up -->
		
		<a class="fancy-box-link" href="#page-title-change-popup" id="page-title-change-popup-btn">&nbsp;</a>
		
		<div id="page-title-change-popup" class="pop-up">
			<form id="managePageTitleForm" action="<%= request.getContextPath() %>/project/build/save_page" method="post">
				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />" >
				<input type="hidden" value="" id="" class="curr-page-pkey" name="page.pkey" />
				
				<div class="pu-header">
					<label class="pu-title"> Rename Page </label>
				</div>
				<div class="margin-5px float-fix" style="padding: 5px 0;">
					<input type="text" name="page.title" class="curr-page-title float-left mandatory" value="" placeholder="Page title" />
				</div>
				<div class="pu-footer float-fix" style="padding-top: 25px">
					<div class="btn-cont float-right">
						<input type="button" value="cancel" id="" class="close-pop-up btn">
						<input type="submit" class="btn btn-yellow" value="save" />
					</div>
				</div>
			</form>
		</div>
	

		<!-- Page Delete pop-up -->

		<a class="fancy-box-link" href="#page-delete-popup" id="page-delete-popup-btn">&nbsp;</a>

		<div id="page-delete-popup" class="pop-up">
			<form id="deletePageForm" action="<%= request.getContextPath() %>/project/build/remove_page" method="post">
									
				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
				<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
								
				<div class="pu-header float-fix">
					<label class="pu-title float-left"> Are You Sure ? </label>
				</div>
				<div class="float-fix">
					<label class="bold"> Deleting a Page will delete all its Hotspots, Images and other settings </label>
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
		<%@ include file="include_preview_popup.jsp" %>
		
		<!-- Publish Pop Up -->
		<%@ include file="include_publish_popup.jsp" %>
		
	</section>
	
	<section id="build-options-cont" class="float-right" style="display: none;">
			
		<form id="hotSpotCreateEditForm" action="<%= request.getContextPath() %>/project/build/save_hot_spot" method="post" >

			<%-- 
			<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />" >
			<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
			
			<input type="hidden" name="hotSpot.pkey" value="" id="hot-spot-pkey" class="hot-spot-pkey">
			
			<input type="hidden" name="hotSpot.fromX" value="" >
			<input type="hidden" name="hotSpot.fromY" value="" >
			<input type="hidden" name="hotSpot.toX" value="" >
			<input type="hidden" name="hotSpot.toY" value="" >
			 --%>

			<ul id="events-list" class="float-fix">

				<li class="" id="events-li">
					<div class="new-event-div" index="0">
					
						<input type="hidden" name="uiEvents[0].pkey" value="" class="ui-event-pkey"> 
						<a href="javascript:void(0);" class="delete-uiEvent-btn bin-icon margin-5px float-right" style="display: none;"></a>
						
						<ul class="new-event-list" >
							<li class="">
								<label class="">on </label>
								<select name="uiEvents[0].eventType" class="mandatory short">
									<option value="0"> - event - </option>
									<option value="tap">Tap</option>
									<option value="taphold">Taphold</option>
									<option value="swipe">Swipe</option>
									<option value="swipeleft">Swipe Left</option>
									<option value="swiperight">Swipe Right</option>
								</select>
							</li>
							<li class="">
								<label class="">go to </label>
								<select name="uiEvents[0].toPage.pkey" class="mandatory short">
									<option value="0"> - page - </option>
									<s:iterator value="pages" var="page">
										<option value="<s:property value="%{#page.pkey}" />" class="page-<s:property value="%{#page.pkey}" />-title auto-ellipses"> <s:property value="%{#page.title}" /> </option>
								    </s:iterator> 
								</select>
							</li>
							<li class="">
								<label class="">with </label>
								<select name="uiEvents[0].transitionType" class="mandatory short">
									<option value="0"> - transition - </option>
									<option value="fade">Fade</option>
									<option value="pop">Pop</option>
									<option value="flip">Flip</option>
									<option value="turn">Turn</option>
									<option value="flow">Flow</option>
									<option value="slidefade">Slide-fade</option>
									<option value="slide">Slide</option>
									<option value="slideup">Slide-up</option>
									<option value="slidedown">Slidedown</option>
									<option value="none">None</option>
								</select>
							</li>
						</ul>
						
					</div>
				</li>

				<!-- 
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
				 -->

			</ul>

		</form>

	</section>

</body>

</html>		