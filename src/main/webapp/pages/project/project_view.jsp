

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> View </title>
	
	<script type="text/javascript" >
	
	$(document).ready( function() {
		
		/* Window resize related ... */
		adjustToWindowDimentions(); 
		
		$(window).resize(function() {
			adjustToWindowDimentions(); 
		});
		
		
		$('#write-comment-btn').live('click', function() {
			var btn = $(this);
			var commentsCont = $('#new-comment-cont');
			commentsCont.slideToggle(600, function(){
				if(commentsCont.css('display') == 'block') {
					btn.html('discard comment');
				} else {
					btn.html('let me write a comment');
				}
			});
		});
		
		$('#postCommentForm').ajaxForm({
			beforeSubmit : function() {
				
			},
			success: function (data){
				if(data && data.comment) {
					var comment = data.comment;
					
					var commentHtml = '<li>';
					commentHtml += '<img alt="" src="<%= request.getContextPath() %>/themes/images/profile_photo.png" class="user-img-thumb">';
					commentHtml += '<div class="comment-text">';
					commentHtml += '<p class="bold gray-333-text">' + comment.user.fullName + '</p>';
					commentHtml += '<label class="gray-666-text">' + comment.body + '</label>';
					commentHtml += '</div>';
					commentHtml += '</li>';
					
					$('#project-comments-list li:first').after(commentHtml);
					var commentsCnt = $('#comments-count');
					var count = parseInt(commentsCnt.text());
					commentsCnt.html(count + 1);

				}
			},
			complete: function(){
				$('#new-comment-cont').slideUp(600);
			} 
		});
		
	});
	
	/* Window resize */
	
	function adjustToWindowDimentions(){
		adjustBodyToWindowDimensions();		// body .. 
		
		
		
	};
	
	</script>

</head>

<body>

	<!-- Body Content -->

	<div id="top-cont" class="yellow-bg">
		<div id="page-title-cont" class="float-fix">
			<label class="page-title"> <s:property value="project.title" /> </label>
			
			<!-- 
			<a class="share-icon float-right " title="Share" href="#"></a>
 			<a class="printer-icon float-right" title="Print" href="#"></a>
 			<a class="download-icon float-right" title="Download" href="#"></a>
 			<a class="mail-icon float-right" title="Mail this project" href="#"></a>
 			 -->
 			 
		</div>
	</div>
	
	<div id="main-cont" class="float-fix">
	
		<div id="preview-cont" class="border-frame">
			<iframe src="<%= request.getContextPath() %>/publish/mobile?project.pkey=<s:property value="project.pkey" />" id="preview-iframe"> 
				<p> Oooops ... , your browser currently doesn't support IFrames .. !!!</p>
				<p> Supported browsers: <a href="http://www.opera.com">Opera</a>, <a href="http://www.mozilla.com">Firefox</a>, <a href="http://www.apple.com/safari">Safari</a>, and <a href="http://www.konqueror.org">Konqueror</a>. </p>
			</iframe>
		</div>
		
		<div id="project-info-cont" class="float-left">
			
			<table>
				<tr>
					<td>
						<div id="qr-code-cont">
							<img id="QRcode-img" alt="QR Code" title="QR Code : Scan to view it on device" 
								src="<%= request.getContextPath() %>/publish/mobile_qrcode?project.pkey=<s:property value="project.pkey" />">
						</div>
					</td>
					<td>
						<ul id="" class="float-left">
							<li>
								<div class="float-left">
									<h1 class="bold"> About : </h1>
									<p class=""> <s:property value="project.description" /> </p>
								</div>
							</li>
							<li>
								<div class="float-left clear">
									<label class=""> Stitched by &nbsp; </label> 
									<label class="underline"> <a href="<%= request.getContextPath() %>/user/profile?user.pkey=<s:property value="project.publisher.pkey" />"> <s:property value="project.publisher.fullName" /> </a> </label>
								</div>
								<div class="float-left clear">
									<label class=""> for &nbsp; </label>
									<label class="bold"> <s:property value="project.projectType" /> ( <s:property value="project.layout.width" />px <span class="normal"> X </span> <s:property value="project.layout.height" />px ) </label>
								</div>
							</li>
						</ul>
					</td>
				</tr>
			</table>
			
		</div>
		
		<div id="project-meta-cont" class="float-left">
			<auth:authorize ifNotGranted="ROLE_ANONYMOUS">
				<div id="new-comment-cont" style="display: none;">
					<form action="<%= request.getContextPath() %>/project/comment/post" id="postCommentForm" method="post">
						<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />" >
						<input type="hidden" name="comment.user.pkey" value="<s:property value="loggedInUser.pkey"/>" >
						
						<textarea name="comment.body" style="width: 96%;" placeholder="post comment"> <s:property value="comment.body" /> </textarea>
						<input type="submit" value="Post" name="Post" class="clear float-left btn">
					</form>
				</div>
			</auth:authorize>
		
			<ul id="project-comments-list" class="float-fix">
				<li class="float-fix">
					<auth:authorize ifAnyGranted="ROLE_ANONYMOUS">
						<a href="javascript:void(0)" id="" class="float-left bold fancy-box-link"> Login to write a comment </a>
					</auth:authorize>
					<auth:authorize ifNotGranted="ROLE_ANONYMOUS">
						<a href="javascript:void(0)" id="write-comment-btn" class="float-left bold"> let me write a comment </a>
					</auth:authorize>
					
					<label class="gray-666-text float-right"> <span id="comments-count"><s:property value="comments.size()" /></span> Comments </label>
				</li>
				<s:iterator value="comments" var="comment">
					<li class="">
						<img alt="" src="<%= request.getContextPath() %>/themes/images/profile_photo.png" class="user-img-thumb">
						<div class="comment-text">
							<p class="bold gray-333-text"> <s:property value="%{#comment.user.fullName}" /> </p>
							<label class="gray-666-text"> <s:property value="%{#comment.body}" /> </label>
						</div>
					</li>
				</s:iterator>
			</ul>
			
		</div>
		
	</div>

	<section class="pop-ups-cont">


	</section>
	
	
</body>

</html>		

