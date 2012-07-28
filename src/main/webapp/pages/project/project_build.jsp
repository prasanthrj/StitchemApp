
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

	<script type="text/javascript">
	
	var contextPath = '<%= request.getContextPath() %>';
	var loggedInUserName = '<s:property value="loggedInUser.username"/>'
	
	/* Global variables */

	var projectPkey = parseInt('<s:property value="project.pkey" />');
	var projectWidth = parseInt('<s:property value="project.layout.width" />');
	var projectHeight = parseInt('<s:property value="project.layout.height" />');
	
	var scaledWidth = projectWidth;
	var scaledHeight = projectHeight;

	var currNoOfPages = parseInt('<s:property value="pages.size()" />');
	
	var currPagePkey = parseInt('<s:property value="page.pkey" />');
	var currPageObj = {};
	
	var currLandingPagePkey = parseInt('<s:property value="project.layout.landingPage.pkey" />');

	var currentHotSpots = null;
// 	var currentHotSpotsMap = {};
	
	var hsDivPrefix = 'hs-div-';
	var hsContPrefix = 'hs-cont-';

	var hotSpotsHolderId = 'canvas-cont';
	var canVasElementId = "canvasElem";

	var clickX = new Array();
	var clickY = new Array();
	var clickDrag = new Array();

	var editFillStyle = "rgba(255, 255, 51, 0.5)";
	var defFillStyle = "rgba(255, 255, 51, 0.5)";
	var greenFillStyle = "rgba(8, 130, 11, 0.5)";

	</script>
	
	<!-- Canvas Builder Tools ...  -->
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/builder-tools.js"></script>
	
	<script type="text/javascript">
	
	$(document).ready( function() {
		
// 		$('.collapse-icon').trigger('click');
		
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
		if(currNoOfPages != 0) {
			mainCont.show();
		}
		
		
		/* Window resize related ... */
		
		var buildCont = $('#build-cont'); 
		buildCont.css({
			'width' : projectWidth + 'px',
			'height' : projectHeight + 'px'
		});
		
		adjustToWindowDimentions();
		$(window).resize(function() {
			adjustToWindowDimentions();
		});
		
		
		/* Drag-Drop file Upload ... */
		prepareFileDropUpload("carousel-cont");
		
		/* Set Landing Page */
		if(currLandingPagePkey && currLandingPagePkey != '') {
			$('#landing-page-radio-' + currLandingPagePkey ).check();
		}
		
		/* Load the first page for editing .. */
		if(currPagePkey && currPagePkey != '')
			preparePageForEditing( currPagePkey );
		
		/* Prepare Hotspots Editing */
		prepareCanvasToolsForPage( currPagePkey );
		
		
		/* attach page editing and tool tip */
		var toolTipCont = $('#tooltip-cont');
		$('#pages-list li .page-thumb-image-cont').live('click', function(event){
			var pagePkey = $(this).find('input.page-pkey').val();
			preparePageForEditing( pagePkey, this );
		});
		
		attachCustomToolTipToCarouselItems();
		
		$('#pages-list li input[type=radio]').customInput();
		
		/* Page title */
		
		$('#managePageTitleForm').ajaxForm({
			success: function (data){
				if(data && data.page) {
					
// 					$('a.page-' + data.page.pkey + '-title').html(data.page.title);
// 					$('option.page-' + data.page.pkey + '-title').html(data.page.title);
					
					$('.page-' + data.page.pkey + '-title').html(data.page.title);
					
					if(currPagePkey == data.page.pkey ) {
						$('input.curr-page-title').attr('value', data.page.title);
						$('a.curr-page-title').html(data.page.title);
					}
					
					$.fancybox.close();
					showNotificationMsg( 'success', "Page title has been successfully updated to " +  data.page.title);
				}
			},
			complete: function(){
				$.fancybox.close(); 
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
					
					console.log(data);
					
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
		
		$('.tooltip-content .close-tt').live('click', function(){
			$(this).parents('.tooltip-content').hide('fade');
		}); 

		$('.delete-support-image-btn').live('click', function(){
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
		
		
		/* Supporting Images select boxes */
		
		$('.supporting-images-list input[type=radio]').live('click', function(){
			var radio = $(this);
			var imagePkey = radio.val();
			var imageType = radio.parents('.supporting-images-list:first').attr('imageType');
			
			var imgURL = '';
			if(imagePkey != -1)
				imgURL = '<%= request.getContextPath() %>/image/view?project.pkey=' + projectPkey + '&imageFile.pkey=' + imagePkey ;
			
			var form = $('#update-supp-img-form'); 
			form.find('.img-pkey').attr('value', imagePkey);
			form.find('input[name$=imageType]').attr('value', imageType);
			
			form.ajaxForm({
				beforeSubmit: function (data){},
				success: function (data){
					if(data) {
						
						// Setting up the image ... 
						switch (imageType) {
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
		
		var bodyCont = $('#body-cont');
		
		var buildCont = $('#build-cont'); 
		var buildLeftCont = $('#build-left-cont');
		var buildRightCont = $('#build-right-cont');
		
		var availWidth = parseInt(bodyCont.width() - buildCont.outerWidth(true));
		var widthForCont = Math.floor((availWidth - 50)/2);
		
		buildLeftCont.css({
			'width' : widthForCont + 'px',
			'height' : projectHeight + 'px'
		});
		
		buildRightCont.css({
			'width' : widthForCont + 'px',
			'height' : projectHeight + 'px'
		});
		
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
		
		$('#main-cont').show();
		
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
		
		// ScreenImgURL ..
		var pageScreenImagePkey = page.screenImage.pkey ;
		
		var pageHeaderImagePkey = -1;
		if(page.headerImage && page.headerImage.pkey) 
			pageHeaderImagePkey = page.headerImage.pkey;
		$('#page-header-cont').find('input[value=' + pageHeaderImagePkey + ']').check();
		
		var pageFooterImagePkey = -1;
		if(page.footerImage && page.footerImage.pkey) 
			pageFooterImagePkey = page.footerImage.pkey;
		$('#page-footer-cont').find('input[value=' + pageFooterImagePkey + ']').check();
		
		var pageLeftNavImagePkey = -1;
		if(page.leftNavImage && page.leftNavImage.pkey) 
			pageLeftNavImagePkey = page.leftNavImage.pkey;
		$('#page-leftnav-cont').find('input[value=' + pageLeftNavImagePkey + ']').check();
		
		var pageRightNavImagePkey = -1;
		if(page.rightNavImage && page.rightNavImage.pkey) 
			pageRightNavImagePkey = page.rightNavImage.pkey;
		$('#page-rightnav-cont').find('input[value=' + pageRightNavImagePkey + ']').check();
		
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
		
		currentHotSpots = hotSpots;
		
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
				if (!fromX || !toX) return false;
			},
			success: function (data){
				// TODO fix hack 
// 				updatePageHotSpots();
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
						
					}
				}
			}).trigger('submit');
			
		}
	};
	
	/* edit Page title.. */
	
	function preparePageTitleEditPopUp(pagePkey, pageTitle) {
		if(pagePkey == null || pagePkey == '')
			pagePkey = $('#curr-page-pkey').val();
		
		if(pageTitle == null || pageTitle == '')
			pageTitle = $('#curr-page-title').val();
		
		// popup 
		var titleForm = $('#managePageTitleForm');
		titleForm.find('.curr-page-pkey').attr('value', pagePkey);
		titleForm.find('.curr-page-title').attr('value', pageTitle);
		
		$('#page-title-change-popup-btn').trigger('click');
	};
	
	
	
	
	/* Page Comments */
	
	function loadPageComments(comments) {
		if(comments){
			
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
	
	function openSupportingImageSelector( inElement, inCss ) {
		if(inElement){
			var element = $(inElement);
			var suppImgCont = element.parents('.supp-img-cont');
			var suppImgs = suppImgCont.find('.tooltip-content');
			
			suppImgs.css({
				'position' : 'absolute', 
				'z-index' : 100,
			}).css(inCss);
			
			$('.tooltip-content').hide('fade');
			suppImgs.show('fade');
		}
	};
	
	function attachCustomToolTipToCarouselItems() {
		$('#pages-list li .page-thumb-image-cont').customToolTip({
			maxWidth : '160px',
			minWidth : '120px',
			top : 110,
			left : 70
		});
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
				<li>
					<a href="javascript:void(0)" class="btn">
						<img alt="" src="<%= request.getContextPath() %>/themes/images/icon_settings.png">
					</a>
				</li>
				<!-- 
				<li>
	               	<a href="javascript:void(0)" class="btn" > save </a>
	            </li>
				 -->
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
						<li id="car-page-<s:property value="%{#page.pkey}" />" >
							
							<div class="page-thumb-details-cont">
								<input type="radio" name="landingPagePkey" value="<s:property value="%{#page.pkey}" />" 
										id="landing-page-radio-<s:property value="%{#page.pkey}" />" onclick="updateProjectLandingPage(this);" />
								<label for="landing-page-radio-<s:property value="%{#page.pkey}" />" class="landing-page-radio">&nbsp;</label>
								
								<a class="page-<s:property value="%{#page.pkey}" />-title auto-ellipses" href="javascript:void(0)" onclick="preparePageTitleEditPopUp(<s:property value="%{#page.pkey}" />, '<s:property value="%{#page.title}" />')"><s:property value="%{#page.title}" /></a>
							</div>
													
							<div class="page-thumb-image-cont">

								<input type="hidden" class="page-pkey" value="<s:property value="%{#page.pkey}" />" />
								<img alt="<s:property value="%{#page.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#page.screenImage.pkey}" />">
							
								<div class="tooltip-content" style="display: none;">
									<div class="tt-outer left-top">
										<div class="tt-inner page-tt-content">
											<ul>
												<li class="float-fix">
													<label class="key"> W &nbsp;: &nbsp;</label>
													<label class=""> <s:property value="%{#page.screenImage.width}" /> px </label>
												</li>
												<li class="float-fix">
													<label class="key"> H &nbsp; : &nbsp;</label>
													<label class=""> <s:property value="%{#page.screenImage.height}" /> px </label>
												</li>
											</ul>
										</div>
									</div>
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
			<div id="page-title-cont" class="float-left">
<!-- 				<a class="curr-page-title fancy-box-link float-left margin-5px " title="Click to rename" href="#page-title-change-popup"> Page Title </a> -->
				<a class="curr-page-title float-left margin-5px " title="Click to rename" href="javascript:void(0)" onclick="preparePageTitleEditPopUp()"> Page Title </a>
			</div>
			<div id="page-options-cont" class="float-right">
				<ul id="page-options-list" class="inline-list">
					<li id="" class="">
						<a href="javascript:void(0)" class="screen-icon" id="page-screen-btn">&nbsp;</a>
					</li>
					<li id="" class="">
						<a href="#page-delete-popup" class="delete-icon fancy-box-link" id="page-delete-btn">&nbsp;</a>
					</li>
					<li class="">
						<a href="javascript:void(0)" class="hotspots-icon screen-hotspots-count" onclick="showHideAllHotSpots( this );">&nbsp;</a>
					</li>
					
					<li class="" style="border-left: 1px dotted #000000;">
						<a class="collapse-icon">&nbsp;</a>
					</li>
				</ul>
			</div>
		</div>
	
	</div>
	
	<div id="main-cont" style="display: none;">
	
		<div id="notification-cont" style="display: none;">
			<div id="notification-box" class="error">
				<a href="javascript:void" class="float-left skull-icon-white" id="noification-icon"></a>
				<span class="msg-text"> Something Went Wrong !!! </span>
				<a href="javascript:void(0);" class="float-right close-icon-white" id="noification-close"></a>
			</div>
		</div>
		
		<section id="build-left-cont" >
			
			<div id="page-header-cont" class="supp-img-cont">
				<div class="pos-rel">
				
					<a class="float-right bold tooltip-header" href="javascript:void(0)"  
						onclick="openSupportingImageSelector(this, {'top' : '25px', 'right' : '0px'})"> + add header </a>
					
					<div class="tooltip-content" style="display: none;">
						<div class="tt-outer left-top">
							<div class="tt-inner supp-img-tt-content">
						
								<div class="float-fix"> <a href="javascript:void(0)" class="float-right close-tt">X</a> </div>
								<ul class="supporting-images-list" imageType="Header">
									<li>
										<input type="radio" name="Header-image-radio" value="-1" id="supp-img-header-none" >
										<label for="supp-img-header-none"> None </label>
									</li>
									<s:iterator value="headerImages" var="image">
										<li>
											<input type="radio" name="Header-image-radio" value="<s:property value="%{#image.pkey}" />" id="supp-img-<s:property value="%{#image.pkey}" />" >
											<label for="supp-img-<s:property value="%{#image.pkey}" />"><s:property value="%{#image.fileObjFileName}" /></label>
											
											<form class="delete-support-image-form" action="<%= request.getContextPath() %>/image/remove" method="post">
												<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
												<input type="hidden" name="imageFile.imageType" value="Header" class="">
												<input type="hidden" name="imageFile.pkey" class="support-img-pkey" value="<s:property value="%{#image.pkey}" />">
												
												<a class="float-right delete-support-image-btn close-icon" href="javascript:void(0);">&nbsp;</a>
											</form>
										</li>
									</s:iterator>
								</ul>
								<a class="plus-icon float-left clear margin-5px bold" href="javascript:void(0);" 
									onclick="openFileSelector({'imageFileType':'Header'});"> upload more images </a>
							
							</div>
						</div>
					</div>
				
				</div>
			</div>
			
			<div id="page-footer-cont" class="supp-img-cont">
				<div class="pos-rel">
			
					<a href="javascript:void(0)" class="float-right bold tooltip-header"
						onclick="openSupportingImageSelector(this, {'bottom' : '10px', 'right' : '0px'})"> + add footer </a>
					
					<div class="tooltip-content" style="display: none;">
						<div class="tt-outer left-top">
							<div class="tt-inner supp-img-tt-content">
					
								<div class="float-fix"> <a href="javascript:void(0)" class="float-right close-tt">X</a> </div>
								<ul class="supporting-images-list" imageType="Footer">
									<li>
										<input type="radio" name="Footer-image-radio" value="-1" id="supp-img-footer-none" >
										<label for="supp-img-footer-none"> None </label>
									</li>
									<s:iterator value="footerImages" var="image">
										<li>
											<input type="radio" name="Footer-image-radio" value="<s:property value="%{#image.pkey}" />" id="supp-img-<s:property value="%{#image.pkey}" />" >
											<label for="supp-img-<s:property value="%{#image.pkey}" />"><s:property value="%{#image.fileObjFileName}" /></label>
											
											<form class="delete-support-image-form" action="<%= request.getContextPath() %>/image/remove" method="post">
												<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
												<input type="hidden" name="imageFile.imageType" value="Footer" class="">
												<input type="hidden" name="imageFile.pkey" class="support-img-pkey" value="<s:property value="%{#image.pkey}" />">
												
												<a class="float-right delete-support-image-btn close-icon" href="javascript:void(0);">&nbsp;</a>
											</form>
										</li>
									</s:iterator>
								</ul>
								<a class="plus-icon float-left clear margin-5px bold" href="javascript:void(0);" 
									onclick="openFileSelector({'imageFileType':'Footer'});"> upload more images </a>
							
							</div>
						</div>
					</div>
			
				</div>
			</div>
			
			<s:if test="%{#projType != null && #projType != '' }">
				<s:if test="%{#projType != 'AndroidMobile' && #projType != 'Iphone3' && #projType == 'Iphone4'}">
					
					<div id="page-leftnav-cont" class="supp-img-cont">
						<div class="pos-rel">
							
							<!-- Yet to Come -->
						
						</div>
					</div>
					
					<div id="page-rightnav-cont" class="supp-img-cont">
						<div class="pos-rel">
							
							<!-- Yet to Come -->
						
						</div>
					</div>
					
				</s:if>
			</s:if>
			
		</section>
	
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
		
		<section id="build-right-cont" >
		
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
				<input type="hidden" name="imageFile.imageType" value="Header" class="">
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
					<input type="text" name="page.title" class="curr-page-title float-left" value="" placeholder="Page title" />
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
				
				if (!layoutWidth) layoutWidth = $('#proj-width').val();
				if (!layoutHeight) layoutHeight = $('#proj-height').val();
				
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
	
	<section id="build-options-cont" class="float-right" style="display: none;">
			
		<form id="hotSpotCreateEditForm" action="<%= request.getContextPath() %>/project/build/save_hot_spot" method="post" >

			<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />" >
			<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
			
			<input type="hidden" name="hotSpot.pkey" value="" id="hot-spot-pkey" class="hot-spot-pkey">
			
			<input type="hidden" name="hotSpot.fromX" value="" >
			<input type="hidden" name="hotSpot.fromY" value="" >
			<input type="hidden" name="hotSpot.toX" value="" >
			<input type="hidden" name="hotSpot.toY" value="" >

			<ul id="events-list" class="float-fix">
				
				<li class="" id="events-li">
					
					<div class="new-event-div" index="0">
					
						<input type="hidden" name="uiEvents[0].pkey" value="" class="ui-event-pkey"> 
						<a href="javascript:void(0);" class="bin-icon margin-5px float-right" style="display: none;"></a>
						
						<ul class="new-event-list" >
							<li class="">
								<label class="">on </label>
								<select name="uiEvents[0].eventType" class="mandatory short">
									<option value="-1"> - event - </option>
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
									<option value="-1"> - page - </option>
									<s:iterator value="pages" var="page">
										<option value="<s:property value="%{#page.pkey}" />" class="page-<s:property value="%{#page.pkey}" />-title auto-ellipses"> <s:property value="%{#page.title}" /> </option>
								    </s:iterator> 
								</select>
							</li>
							<li class="">
								<label class="">with </label>
								<select name="uiEvents[0].transitionType" class="mandatory short">
									<option value="-1"> - transition - </option>
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
			
		<script type="text/javascript">
			$(document).ready( function() {
				
				$('.add-more-events-btn').live('click',function() {
					var eventsList = $(this).parents('.events-list:first');
					
					var lastEventDiv = eventsList.find('.new-event-div:last');
					var newIndex = parseInt(lastEventDiv.attr('index')) + 1;
					
					var eventHtml = prepareUiEventHtml(null, newIndex);
					eventsList.prepend('<li>' + eventHtml + '</li>');
					
					setBinIcons(eventsList);
				});
				
				$('.new-event-div .bin-icon').live('click', function() {
					var eventDiv = $(this).parents('.new-event-div:first');
					
					var eventPkey = eventDiv.find('.ui-event-pkey').val();
					if(eventPkey && eventPkey != ''){
						var deleteEventPkey = '<%= request.getContextPath() %>/project/build/remove_ui_event?page.pkey=' + currPagePkey + '&uiEvent.pkey=' + eventPkey ;   
						$.getJSON(deleteEventPkey, function(data) {
							if(data) {
								updatePageHotSpots();
								eventDiv.remove();
							}
						});
					} else {
						eventDiv.remove();
					}
					
					setBinIcons();
				});
				
				function setBinIcons(eventsList) {
					if(eventsList) {
						var binIcons = eventsList.find('.bin-icon');
						binIcons.hide();
						if(binIcons && binIcons.length > 1){
							binIcons.show();
						}
					}
				};
				
			});
		</script >
					
	</section>

</body>

</html>		