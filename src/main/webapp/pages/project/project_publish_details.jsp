

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> Publish Options </title>
	
	<script type="text/javascript">
	
	$(document).ready( function() {
		
		$(window).keydown(function(event) {
			if(event.keyCode == 13) {
				event.preventDefault();
				return false;
			}
		});

		
		/* Window resize related ... */
		adjustToWindowDimentions(); 
		
		$(window).resize(function() {
			adjustToWindowDimentions(); 
		});
		
		var index = 0;
		
		var appUserInput = $('#add-app-user-input');
		appUserInput.live("keyup", function(event) {
			if(event.keyCode == '13'){
				event.preventDefault();

				var appUserHtml = '';
				var appUserEmailId = appUserInput.val();
				if (appUserEmailId) {
					appUserHtml += '<li>';
					appUserHtml += '<label>' + appUserEmailId + '</label>';
					appUserHtml += '<a href="javascript:void(0);" class="bin-icon float-right" ></a>';
					appUserHtml += '<input type="hidden" name="appUsers[' + index + '].emailId" value="' + appUserEmailId + '">';
					appUserHtml += '</li>';
				}
				
				$('#app-users-list').append(appUserHtml);				
				appUserInput.val('');
				
				index++;
				
				return false;
			}
		});
		
		$('#app-users-list .bin-icon').live('click', function(){
			$(this).parents('li').remove();	
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
			<label class="page-title"> 
				<a href="<%= request.getContextPath() %>/project/build/prepare?project.pkey=<s:property value="project.pkey" />&user.emailId=<s:property value="loggedInUser.emailId"/>"> <s:property value="project.title" /> </a> 
			</label>
			<label class="float-right bold gray-999-text margin-5px"> Publish Options </label>
		</div>
	</div>
	
	<div id="main-cont" class="float-fix">
	
		<div id="preview-cont" class="border-frame">
			<iframe src="<%= request.getContextPath() %>/publish/mobile?project.pkey=<s:property value="project.pkey" />&user.emailId=<s:property value="loggedInUser.emailId"/>" id="preview-iframe"> 
				<p> Oooops ... , your browser currently doesn't support IFrames .. !!!</p>
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
								<h1 class="bold"> Sharing settings </h1>
							</li>
							<li>
								<label class=""> link to view on device : </label> 
								<input type="text" value="/publish/device?project.pkey=<s:property value="project.pkey" />" class="float-left clear" style="width: 500px;">
							</li>
							<li>
								<label class=""> link to view on desktop : </label>
								<input type="text" value="/publish/web?project.pkey=<s:property value="project.pkey" />" class="float-left clear" style="width: 500px;">
							</li>
						</ul>
					</td>
				</tr>
			</table>
			
		</div>
		
		<div id="project-meta-cont" class="float-left">
			
			<form id="projectPublishForm" class="float-fix" 
				action="<%= request.getContextPath() %>/publish/manage_details" method="post">
		
				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
				<input type="hidden" name="publishDetails.pkey" value="<s:property value="publishDetails.pkey" />">
				
				<div class="float-fix">
					<label style="color: #666666; font-size: 14px; font-weight: bold; margin: 5px 0;"> I would like my project to be &nbsp; &nbsp; &nbsp; </label>
					
					<div id="publish-visibility" class="float-fix float-left">
						<input type="radio" name="project.isPublic" value="true" id="visible-public" checked="checked" class="isPublic">
						<label for="visible-public">Public &nbsp; &nbsp; </label>
						<input type="radio" name="project.isPublic" value="false" id="visible-private" class="isPublic">
						<label for="visible-private">Private</label>
					</div>
					
				</div>
				
				<div id="publish-contacts-cont" class="float-fix">
				
					<label class="clear gray-999-text" style="float: none; display: block;"> Notify the people below with an email : </label>
				 	<ul class="clear" id="app-users-list">
				 		<s:iterator value="appUsers" var="appUser" status="idx">
				 			<li>
				 				<s:if test="%{#appUser.fullName != null && #appUser.fullName != '' }">
				 					<label><s:property value="%{#appUser.fullName}" /></label>
				 				</s:if>
				 				<s:else>
			 						<label><s:property value="%{#appUser.emailId}" /></label>
				 				</s:else>
				 				<a href="javascript:void(0);" class="bin-icon float-right" ></a>
				 			</li>
					    </s:iterator>
				 	</ul>
				
					<div class="" style="margin: 4px 0;">
						<input type="email" class="inp-box inner-shadow " placeholder=" + add people email-ids" id="add-app-user-input" style="width: 400px;">
					</div>
			
				</div>
				
				<div class="float-left">
					<input type="submit" value="Publish Project" id="publish-proj-btn" class="btn btn-yellow">
				</div>
				
			</form>
			
			
		</div>
		
	</div>

	<section class="pop-ups-cont">


	</section>
	
	
</body>

</html>		

