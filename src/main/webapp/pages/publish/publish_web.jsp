
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE HTML>
<html>

<head>

	<title> Published for Mobile </title>
	
	<!-- Default Includes .. -->	
		
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/lib/jquery-1.5.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/lib/jquery-ui-1.8.13.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/lib/jquery.form.js"></script>
	
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/themes/custom-widgets-style.css" media="screen"/>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/themes/style.css" media="screen"/>
		
	
	<script type="text/javascript">
	
	var contextPath = '<%= request.getContextPath() %>';
	
	$(document).ready( function() {
		
		
		var layoutWidth = '<s:property value="project.layout.width" />' ;
		var layoutHeight = '<s:property value="project.layout.height" />';
		
		
		
		
		$('#postPageCommentForm').ajaxForm({
			beforeSubmit: function (data){},
			success: function (data){
				if(data && data.comments)
					loadPageComments(data.comments);
			}
		});

	});
	
	
	function fetchPageComments (pagePkey) {
		
		
	};
	
	
	function loadPageComments(comments){
		if(comments){
			
			var commentsList = $('#page-comments-list');
			commentsList.slideUp(500, function(){
				
				var commentsHtml = '';
				if(comments && comments.length >0){
					for ( var i = 0; i < comments.length; i++) {
						var comment = comments[comments.length - (i + 1)];
						
						commentsHtml += '<li class="comment-li float-left clear">';
						commentsHtml += '<input type="hidden" value="' + comment.pkey + '" name="comment.pkey" />'
						commentsHtml += '<img alt="" src="<%= request.getContextPath() %>/themes/images/profile_photo.png" class="float-left user-img-thumb">';
						commentsHtml += '<div class="float-left">';
						commentsHtml += '<label class="float-left clear gray-666-text">';
						
						var displayName = comment.appUser.name;
						if(!displayName)
							displayName = comment.appUser.emailId;
						
						commentsHtml += '<span class="bold gray-333-text"> ' + displayName +' :  </span>' + comment.body;
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
			
	</script>
	
<%-- 	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/custom-analytics.js"></script> --%>
	
</head>

<body lang="en">
	
	<header id="header" class="full-width">
		<div class="in">
			
			<div class="float-left" style="font-size: 30px; margin: 5px 0;">
				<a class="valign-middle gray-333-text" href="<%= request.getContextPath() %>/home" style="margin: 5px 0; text-decoration: none !important;">
					<img alt="" src="<%= request.getContextPath() %>/themes/images/stitch-em-app-logo.png" class="float-left">
				</a>
			</div>
			
			<div id="top-profile-cont" class="float-right">
			
				<auth:authorize ifNotGranted="ROLE_ANONYMOUS">
					
					<div id="after-signin-cont" class="float-right">
						<ul>
							<li class="float-right gray-666-text" >
								Welcome &nbsp;
								<a class="bold" href="javascript:void(0);">  <s:property value="appUser.name"/> </a>
								<span class="separator">|</span>
								<a class="bold" href="<%= request.getContextPath() %>/help"> Help </a>
							</li>
						</ul>
					</div>
					
				</auth:authorize>
				
			</div>
	
		</div>
	</header>



	<!-- Body Content -->
	
	<section class="full-width" id="body-content" >
		<div class="in" >
		 	
		 	<table class="float-left clear" id="body-table">
		 		
		 		<thead>
		 			<tr>
		 				<th></th>
		 				<th></th>
		 			</tr>
		 		</thead>
		 		
		 		<tbody>
			 		<tr>
			 			<td id="" width="*">
			 				
							<section id="app-preview-cont">
	
								<div id="device-frame-cont" class="<s:property value="project.projectType" />" style="display: block;">
									<iframe src="<%= request.getContextPath() %>/publish/mobile?project.pkey=<s:property value="project.pkey" />&appUser.pkey=<s:property value="appUser.pkey" />&isIframe=true#page-<s:property value="page.pkey" />" >
										<p> Oooops ... , your browser currently doesn't support IFrames .. !!!</p>
										<p> Supported browsers: <a href="http://www.opera.com">Opera</a>, <a href="http://www.mozilla.com">Firefox</a>, <a href="http://www.apple.com/safari">Safari</a>, and <a href="http://www.konqueror.org">Konqueror</a>. </p>
									</iframe>
								</div>
									
							</section>
							
			 			</td>
			 			
			 			<td id="" width="360px" class="bg-yellow">
							<section id="comments-cont" class="float-left bg-yellow">
								<div class="build-opt-title float-left clear" >
									<label class="float-left clear title"> Comment </label>
									<label class="float-left clear"> Discuss the page here </label>
								</div>
								<div class="build-opt-details float-left clear">
									<form id="postPageCommentForm" action="<%= request.getContextPath() %>/project/comment/post" method="post">
						
									<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
									<input type="hidden" name="page.pkey" value="<s:property value="page.pkey" />" class="curr-page-pkey">
									
									<input type="hidden" name="appUser.pkey" value="<s:property value="appUser.pkey" />" class="">
										
										<ul id="" class="inner-list">
											<li class="inner-list-li float-left clear" id="">
												<textarea class="inner-shadow" rows="" cols="" placeholder="Add a comment" name="comment.body"></textarea>
											</li>
											
											<li class="inner-list-li float-left clear">
												<input type="submit" class="float-right btn" value="post" />
											</li>
										</ul>
										
									</form>
								</div>
									
								<ul id="page-comments-list" class="float-left clear margin-5px inner-list"> <li> There are no Comments .. !!! </li> </ul>
							</section>
			 			</td>
			 			
			 		</tr>
		 		</tbody>
		 	</table>
		 	
		</div>
	</section>
	
</body>

</html>	

