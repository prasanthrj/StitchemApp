

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> Project View </title>
	
	<script type="text/javascript" >
	
	$(document).ready( function() {
		
		$(window).keydown(function(event){
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
		appUserInput.live("keyup", function(event){
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
				<p> Supported browsers: <a href="http://www.opera.com">Opera</a>, <a href="http://www.mozilla.com">Firefox</a>, <a href="http://www.apple.com/safari">Safari</a>, and <a href="http://www.konqueror.org">Konqueror</a>. </p>
			</iframe>
		</div>
		
		<div id="project-info-cont" class="float-left">
			
			<div id="qr-code-cont" class="float-left">
				<img id="QRcode-img" alt="QR Code" title="Scan to view it on device" src="<%= request.getContextPath() %>/publish/mobile_qrcode?project.pkey=<s:property value="project.pkey" />">
			</div>
			
			<div class="float-left">
				<label class="sub-title"> Device : </label>
				<p class="bold"> <s:property value="project.projectType" /> ( <s:property value="project.layout.width" />px <span class="normal"> X </span> <s:property value="project.layout.height" />px ) </p>
			</div>
			
		</div>
		
		<div id="project-meta-cont" class="float-left">
			
			<form id="projectPublishForm" class="float-fix" 
				action="<%= request.getContextPath() %>/publish/manage_details" method="post">
		
				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
				<input type="hidden" name="publishDetails.pkey" value="<s:property value="publishDetails.pkey" />">
				
				<div class="float-fix">
					<label class="pu-title margin-5px"> Share your pattern </label>

					<div id="publish-visibility" class="float-fix float-right">
						<input type="radio" name="isPublic" value="true" id="visible-public" checked="checked" class="isPublic">
						<label for="visible-public">Public</label>
						<input type="radio" name="isPublic" value="false" id="visible-private" class="isPublic">
						<label for="visible-private">Private</label>
					</div>
				
				</div>
				
				<div class="float-fix">
					<textarea name="project.description" rows="" cols="80" class="inp-box inner-shadow" placeholder="Project description"
						style=" margin: 3px; margin-top: 10px;" > <s:property value="project.description"/> </textarea>
				</div>
				
				<div id="publish-contacts-cont" class="float-fix">
				
					<label class="clear gray-999-text" style="float: none; display: block;"> people you are sharing with : </label>
				 	<ul class="clear" id="app-users-list">
				 		<s:iterator value="appUsers" var="appUser" status="idx">
				 			<li>
<!-- 				 				<s:if test="%{#appUser.pkey != null && #appUser.name != '' }"> -->
<!-- 				 					<label><s:property value="%{#appUser.name}" /></label> -->
<!-- 				 				</s:if> -->
<!-- 				 				<s:else> -->
			 						<label><s:property value="%{#appUser.emailId}" /></label>
<!-- 				 				</s:else> -->

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
				
					<div class="" style="margin: 4px 0;">
						<input type="text" class="inp-box inner-shadow " placeholder="add people email-ids" id="add-app-user-input">
<!-- 						<a id="add-app-user-btn" href="javascript:void(0);"> + Add </a> -->
					</div>
			
				</div>
				
				<div class="btn-cont float-right no-margin no-padding">
					<input type="submit" value="Publish Project" id="publish-proj-btn" class="btn btn-yellow">
				</div>
				
			</form>
			
			
		</div>
		
	</div>

	<section class="pop-ups-cont">


	</section>
	
	
</body>

</html>		

