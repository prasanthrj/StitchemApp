
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE HTML>
<html>

<head>

	<title>Home</title>

	<script type="text/javascript">
		
		
		var isProjectsPageLoded = true;
		
		var currentPageNumber = 1;
	
		$(document).ready(function() {
			
			/* Tags */
			
			var tagsURL = '<%= request.getContextPath() %>/project/fetch_tags';
			$.getJSON( tagsURL, function(data){
				var tagsList = data.tagTitles;
				console.log(tagsList);
				
				var tags = data.tags;
				if(!tags || tags.length == 0)
					return;
				
				var tagsArray = [];
				for(var i in tags){
					var tag = tags[i];
					tagsArray.push(tag.title);
				}
				
				console.log(tagsArray);
				
				$( "#tags-autocomplete" ).autocomplete({
					source: tagsArray
				});
				
			});
			
			
			/* Carousel */

			var carouselCont = $('#carousel-cont');
			
			$('#home-carousel').jcarousel({
				wrap: 'circular', 
		        size:4,
		        scroll:1,
		        visible:1
			});

			/* Form Submission */

			$('#new-pattern-submit-btn').live('click', function(){
				
				var newPatternForm = $('#new-pattern-form');
				newPatternForm.validateForm({
					failureFunction : function(element){
						$(element).addClass('error');
					},
					successFunction : function(element){
						$(element).removeClass('error');
					},
					onValidForm : function(form){
						$(form).trigger('submit');
					}
				});
				
			});
			
			/* Projects Lazyload */
			$(window).scroll(function(){
				var scrollThreshold = $(document).height() - ( $(window).height() + 500 );
				if ( ( $(window).scrollTop() > scrollThreshold ) && isProjectsPageLoded ){
					isProjectsPageLoded = false;
// 					fetchProjectsByPage(currentPageNumber + 1);
				}
			});
			
			
			
			/* Window resize related ... */
			
			adjustToWindowDimentions(); 
			
			$(window).resize(function() {
				adjustToWindowDimentions(); 
				
			});
			
			
			
			/* fancy boxes .. */
			

			
			// project previews .. 
			$('#preview-btn').fancybox({
				'opacity'		: true,
				'scrolling'		: 'no',
				'titleShow'		: false,
				'onClosed'		: function() {
				    $(".msg-cont").hide();
				}
			});
			
			
		});
		
		
		var currLiHorMargin;
		
		/* Window resize */
		function adjustToWindowDimentions(){
			
			// body .. 
			adjustBodyToWindowDimensions();
			
			// rest .. 
			var intList = $('#interactions-list');
			
			var maxListWidth = parseInt(intList.width());
			var liWidth = parseInt(intList.find('li:first').width()) + 10;	// padding 10px 
			
			var rowLength = Math.floor( maxListWidth / liWidth );
			var availableMargin = maxListWidth - (liWidth * rowLength);
			
			var marginOnEachSide = Math.floor( availableMargin / (rowLength * 2));
			
			intList.find('li.interaction').css({
				'margin-left' : marginOnEachSide + 'px',
				'margin-right' : marginOnEachSide + 'px'
			});
			
			currLiHorMargin = marginOnEachSide;
			
			
		};
		
		
		/* Projects Lazyload */
		
		function fetchProjectsByPage(pageNumber) {
			
			var fetchProjectsURL = '<%= request.getContextPath() %>/project/fetch_projects?pageNumber=' + pageNumber ;
			$.getJSON(fetchProjectsURL, function(data) { 
				if(data && data.projects) {
					
					var projListHtml = '';
					
					for ( var i = 0; i < data.projects.length; i++) {
						var project = data.projects[i];
						
						projListHtml += '<li class="interaction" style="margin-left : ' + currLiHorMargin + 'px; margin-right : ' + currLiHorMargin + 'px; ">';
						projListHtml += '<a href="javascript:void(0);" onclick="loadProjectPreview(' + project.pkey + ')" class="thumb">';
						
						if(project.layout.landingPage) {
							projListHtml += '<img class="" alt="' + project.layout.landingPage.screenImage.fileObjFileName + '" src="<%= request.getContextPath() %>/image/view?project.pkey=' + project.pkey + '&imageFile.pkey=' + project.layout.landingPage.screenImage.pkey + '">';
						} else {
							projListHtml += '<img class="" alt="" src="">';
						}
							
						projListHtml += '</a>';
					
						projListHtml += '<div>';
						projListHtml += '<h2 class="auto-ellipses">' + project.title + '</h2>';
						projListHtml += '<label class="proj-desc" style="display: none;">' + project.description + '</label>';
						projListHtml += '</div>';
		  			
						projListHtml += '<input type="hidden" class="project-pkey" value="' + project.pkey + '">';
						projListHtml += '</li>';
						
					}
					
					$('#interactions-list').append(projListHtml);
					
					// Global Variables .. 
					if(data.projects.length > 0 ) {
						isProjectsPageLoded = true;
						currentPageNumber = currentPageNumber + 1;
					}

				}
				
			});
			
		};
		
		
		
		/* Project Preview .. */
		
		function loadProjectPreview( projPkey ){
			if(projPkey){
				
				var previewCont = $('#preview-cont');
				var infoCont = $('#info-cont');
				
				var projectPreviewURL = '<%= request.getContextPath() %>/publish/mobile?project.pkey=' + projPkey ;
				previewCont.find('iframe').attr('src', projectPreviewURL );
				
				var projectInfoURL = '<%= request.getContextPath() %>/project/info?project.pkey=' + projPkey ;
				$.getJSON( projectInfoURL, function(data) { 
					if(data && data.projectBean){
						var project = data.projectBean;
						
						// Info 
						infoCont.find('.pro-title').html( project.title );
						infoCont.find('.pro-desc').html( project.description );
						infoCont.find('.pro-type').html( project.projectType );
						
						var profileUrl = '<%= request.getContextPath() %>/user/profile?user.pkey=' + project.publisher.pkey ;
						
						$('#author').html('<a href="' + profileUrl + '">' + project.publisher.fullName + '</a>');
						$('#no-of-pages').html( project.pagesCount );
						$('#pro-height').html( project.height );
						$('#pro-width').html( project.width );
						
						$('#QRcode-img').attr('src', '<%= request.getContextPath() %>/publish/mobile_qrcode?project.pkey=' + project.pkey );
						
						
						// Comments 
						
						var commentsList = $('#project-comments-list');
// 						commentsList.html('');

						var commentsHtml = '';
						if(project.comments && project.comments.length > 0){
							for ( var i = 0; i < project.comments.length; i++) {
								var comment = project.comments[project.comments.length - (i + 1)];
					
								if(i == 0) {
									commentsHtml += '<li class="no-top-border">';
								} else {
									commentsHtml += '<li class="">';
								}
					
								commentsHtml += '<img alt="" src="<%= request.getContextPath() %>/themes/images/profile_photo.png" class="user-img-thumb">';
								commentsHtml += '<div class="comment-text">';
								commentsHtml += '<label class="gray-666-text">';
					
								var displayName = comment.appUser.name;
								if(!displayName)
									displayName = comment.appUser.emailId;
					
								commentsHtml += '<span class="bold gray-333-text"> ' + displayName +' : </span>' + comment.body;
								commentsHtml += '</label>';
								commentsHtml += '</div>';
								commentsHtml += '</li>';
				
							}
						}
						
						if(project.comments.length > 0)
							commentsList.html(commentsHtml);
						
					}
					
					$('#preview-btn').trigger('click');

					$('#project-preview-popup').parent('div').css({'overflow' : 'visible'});
					
				});

			}
		};
		
		
	</script>



</head>

<body>

	<!-- Body Content -->
	
	<div id="top-cont" class="" style="border-top: none;">
	
		<div id="carousel-cont" class="yellow-bg">
		
			<ul id="home-carousel" class="carousel-list">
				<li>
					<label>Stitch up screens and bring them to life on your mobile.</label>
				</li>
				<li>
					<img alt="" src="<%= request.getContextPath() %>/themes/images/homescreen_step01.png" class="float-right">
					<div class="float-left">
						<label class="float-left">Step 1 </label>
						<label class="float-left clear">Upload mockup Images.</label>
					</div> 
				</li>
				<li>
					<img alt="" src="<%= request.getContextPath() %>/themes/images/homescreen_step02.png" class="float-right">
					<div class="float-left">
						<label class="float-left">Step 2</label>
						<label class="float-left clear">Stitch Images into an App.</label>
					</div>
				</li>
				<li>
					<img alt="" src="<%= request.getContextPath() %>/themes/images/homescreen_step03.png" class="float-right">
					<div class="float-left">
						<label class="float-left">Step 3</label> 
						<label class="float-left clear">View the simulation in device.</label> 
					</div>
				</li>
			</ul>
			
		</div>
			
		<div id="search-cont">
			<div id="search-header" class="float-fix">
				<div class="float-left">
				    <input type="text" id="main-search-box" placeholder="Search pattern"> 
				</div>
				<div class="float-right">
					<ul class="inline-list">
						<li>
							<span class="patterns-count"> <s:property value="projectsCount" /> </span>
							<span> Patterns </span>
						</li>
						<li>
							<span class="patterns-count"> <s:property value="publicProjectsCount" /> </span>
							<span> Public Patterns </span>
						</li>
						<!-- 
						<li>
							<a class="take-a-tour-icon" href="#"> Take a Tour </a>
						</li>
						 -->
						<li>
							<a class="collapse-icon" href="#" style="padding: 4px 12px; margin-top: 8px; float: left;"> </a>
						</li>
					</ul>
				</div>
			</div>
			
			<div id="search-results-cont" style="display: none;">
			
				<ul id="search_suggestion">
					<li class=""> <a href="#">High Voltage</a></li>
					<li class=""> <a href="#">Volcano</a></li>
				</ul>
	
				<ul id="tags_suggestion">
					<li class=""><a href="#">revolt</a></li>
					<li class=""><a href="#"> revolver</a></li>
					<li class=""><a href="#">volt</a></li>
					<li class=""><a href="#">Volume</a></li>
					<li class=""><a href="#">Volume Control</a></li>
				</ul>
	
			</div>
		
		</div>
		
		
	</div>
		
	<div id="main-cont">
	
		<a href="#project-preview-popup" id="preview-btn" style="display: none;"> preview </a>
			
		<ul id="interactions-list" class="inline-list">
		
			<li id="get-started-box" class="interaction">
				<div>
					<label class="title"> Stitch a New Pattern </label>
					<p> Pattern should represent a complete navigation sequence from a Mobile Project, explained in maximum of 10 slides. </p>
					
					<form action="<%= request.getContextPath() %>/project/save" id="new-pattern-form" method="post">
						
						<section style="display: none;">
							<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
							
							<textarea class="mandatory" name="project.description" placeholder="Project description">
								<s:property value="project.description" />
							</textarea>
								
							<select name="project.projectType" class="inp-box inner-shadow" id="project-type-select" onchange="loadProjectRelatedDetails(this);">
								<option value="AndroidMobile"> Android Mobile </option>
								<option value="AndroidTab"> Android Tab </option>
								<option value="Iphone3" selected="selected"> Iphone 3 Mobile </option>
								<option value="Iphone4"> Iphone 4 Mobile </option>
								<option value="Ipad"> Ipad </option>
								<option value="Webapp"> Web Application </option>
								<option value="Custom"> Custom Application </option>
							</select>
								
							<input placeholder="in pixels" type="text" value="320" name="layout.width" class="" >					 				
							<input placeholder="in pixels" type="text" value="480" name="layout.height" class="" >
					
							<select class="inp-box inner-shadow" name="layout.orientation" id="orientation-select">
								<option value="none"> -- default --</option>
								<option value="vertical" selected="selected"> vertical </option>
								<option value="horizontal"> horizontal </option>
								<option value="both"> both </option>
							</select>
						
						</section>
				
						<ul>
							<li>
								<label> Task being stitched </label>
								<input type="text" placeholder="eg. Simple Sign up" class="mandatory" name="project.title" value="<s:property value="project.title" />" >
							</li>
							<li>
								<label> Pattern Category </label>
								<input type="text" placeholder="eg. SignUps" class="mandatory" name="project.tags[0].title" value="" id="tags-autocomplete">
							</li>
							<li>
								<label> Your email </label>
								<input type="email" placeholder="will be used for account creation" class="mandatory emailid" name="user.emailId" value="<s:property value="loggedInUser.emailId"/>">
							</li>
							<li>
<!-- 								<input type="submit" id="new-pattern-submit-btn" value="" class="" onsubmit=""> -->
								<input type="button" id="new-pattern-submit-btn" value="" class="">
							</li>
						</ul> 
					</form>
			
				</div>
				
				<h2> Create your artworks with a width of 320px and any height. </h2>
			
			</li>
		
			
			<s:iterator value="projects" var="project">
	  		
		  		<li class="interaction">
		  		
<%-- 		  			<a href="<%= request.getContextPath() %>/publish/mobile?project.pkey=<s:property value="%{#project.pkey}" />"> --%>
<%-- 		  			<a href="<%= request.getContextPath() %>/project/build/prepare?project.pkey=<s:property value="%{#project.pkey}" />"> --%>
					
					<a href="javascript:void(0);" onclick="loadProjectPreview(<s:property value="%{#project.pkey}" />);" class="thumb">	
						<s:if test="%{#project.layout.landingPage.screenImage.pkey != null}">
	 						<img class="" alt="<s:property value="%{#project.layout.landingPage.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#project.layout.landingPage.screenImage.pkey}" />">
	 					</s:if>
					</a>
					<div>
						<h2 class="auto-ellipses"><s:property value="%{#project.title}" /></h2>
						<label class="proj-desc" style="display: none;">
							<s:property value="%{#project.description}" />
						</label>
					</div>
		  			
					<input type="hidden" class="project-pkey" value="<s:property value="%{#project.pkey}" />">
		  			
		  		</li>
	 		
			</s:iterator>
			    				
		</ul>
		
	</div>
	
	<section class="pop-ups-cont" style="display: none;">
		
		
		<!-- Project Preview Container -->
		
		<div id="project-preview-popup" class="pop-up">
			
			<div id="preview-cont">
				<iframe src="" id="preview-iframe"> 
					<p> Oooops ... , your browser currently doesn't support IFrames .. !!!</p>
					<p> Supported browsers: <a href="http://www.opera.com">Opera</a>, <a href="http://www.mozilla.com">Firefox</a>, <a href="http://www.apple.com/safari">Safari</a>, and <a href="http://www.konqueror.org">Konqueror</a>. </p>
				</iframe>
			</div>
			
			<div id="info-cont">
				<ul id="project-info-list" class="">
					<li class="no-top-border">
						<h1 class="pro-title"> Project Title </h1>
						<label class="margin-5px"> <span class="italic" > by</span> <span class="bold" id="author"> Author </span></label>
					</li>
					<li class="no-top-border">
						<p class="pro-desc"> Project description  </p>
					</li>
					
					<li>
						<label class="name"> No. Of Pages : </label>
						<label class="value" id="no-of-pages"> - </label>
					</li>
					
					<li>
						<label class="name"> height </label>
						<label class="value" id="pro-height"> - </label>
					</li>
					
					<li>
						<label class="name"> width </label>
						<label class="value" id="pro-width"> - </label>
					</li>
					
					<li>
						<label class="name"> Scan to view it on mobile </label>
						<img id="QRcode-img" alt="QR Code" src="">
					</li>
					
				</ul>
			</div>
			
			<div id="comments-cont">
				
				<h2 class="sub-title bold float-left"> Comments </h2>
				
				<ul id="project-comments-list" class="">
				
					<li>
						<label> No Comments yet !!! </label>
					</li>
				
					<%-- 
					<li class="no-top-border">
						<img alt="" src="<%= request.getContextPath() %>/themes/images/profile_photo.png" class="user-img-thumb">
						<div class="comment-text">
							<label class="gray-666-text">
								<span class="bold gray-333-text"> User 1 </span>
								Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor 
							</label>
						</div>
					</li>
					 --%>
					
				</ul>
			</div>
		</div>
		
	
	</section>
		    	
</body>

</html>
