
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> User Home </title>
	
	<style type="text/css">

	.blue-link {
		color: blue !important;	
	}
	
	#profile-edit-cont {
		margin: 0 100px;
		padding: 15px 32px 20px;
		border-bottom: 1px dotted #CCCCCC;
		color: #333333;
		line-height: 16px;
		background-color: #FCFCFC;
	}
	
	#profile-edit-cont li {
		overflow: hidden;
		margin: 2px 0;
	}
	
	#profile-edit-cont label {
		display: block;
		clear: both;
		margin: 2px;
		font-weight: bold;
	}
	
	#profile-edit-cont input {
		clear: both;
		float: left;
	}

	</style>
	
	<script type="text/javascript" >
	
	$(document).ready( function() {
		
		/* Window resize related ... */
		adjustToWindowDimentions(); 
		
		$(window).resize(function() {
			adjustToWindowDimentions(); 
		});
		
		
		/* Tags */
		
		var tagsURL = '<%= request.getContextPath() %>/project/fetch_tags';
		$.getJSON( tagsURL, function(data){
			var tagsList = data.tagTitles;
//				console.log(tagsList);
			
			var tags = data.tags;
			if(!tags || tags.length == 0)
				return;
			
			var tagsArray = [];
			for(var i in tags){
				var tag = tags[i];
				tagsArray.push(tag.title);
			}
			
			$( "#tags-autocomplete" ).autocomplete({
				source: tagsArray
			});
			
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
		
		$('#profile-edit-cont input').bind('focus', function(){
			$(this).removeClass('error');
			this.select();
		});
		
		var editProfileCont = $('#profile-edit-cont');
		var editProfileBtn = $('#edit-profile-btn');
		
		editProfileBtn.live('click', function(){
			editProfileCont.slideDown('slow');
			editProfileBtn.hide('fade');
		});
		
		$('#profile-edit-cont .cancel-edit-btn').live('click', function(){
			editProfileCont.slideUp('slow');
			editProfileBtn.show('fade');
		});
		
		$('#profile-submit-btn').live('click', function(){
			var newPasswdInp = $('#user-pswd');
			var newConfPasswdInp = $('#user-confirm-pswd');
			
			var newPasswd = newPasswdInp.val();
			var newConfPasswd = newConfPasswdInp.val();
			if(newPasswd && newPasswd != '') {
				if(newPasswd != newConfPasswd) {
					newPasswdInp.addClass('error');
					newConfPasswdInp.addClass('error');
					return;
				}
			}
			
			$('#user-profile-form').ajaxForm({
				type: "POST",
				beforeSubmit : function() {
					$('body').css({	'cursor': 'progress' });
				},
				success : function(data) {
					$('body').css({	'cursor': 'auto' });
					if(data && data.messageBean) {
						var msg = data.messageBean;
						if(msg.messageType == 'error') {

						} else {
							window.location.reload(true);
						}
					} 
				},
				complete : function(data) {}
			}).trigger('submit');
		});
		
	});
	
	
	function deleteProject( projectPkey ) {

	};
	
	
	/* Window resize */
	
	function adjustToWindowDimentions(){
		adjustBodyToWindowDimensions();		// body .. 
		
	};
	
	</script>

</head>

<body>

	<!-- Body Content -->

	<div id="top-cont" class="yellow-bg" style="margin: 5px 0 0 0;">
		<div id="user-profile-cont" class="float-fix">
			<div id="" class="user-thumb-cont float-left">
				<img class="user-thumb" alt="" src="<%= request.getContextPath() %>/themes/images/megamind.jpg">
			</div>
			<div id="" class="float-left">
				<ul>
					<li>
						<label style="font-size: 14px;"> <s:property value="loggedInUser.fullName"/> </label>
					</li>
					<li>
						<label><s:property value="loggedInUser.emailId"/></label>
					</li>
					<li>
						<label><s:property value="projects.size()"/> Projects </label>
					</li>
					<li>
						<a href="javascript:void(0);" id="edit-profile-btn" class="blue-link"> edit profile </a>
					</li>
				</ul>
			</div>
			<div class="float-right">
				<a href="#new-project-popup" class="float-right btn margin-5px fancy-box-link" 
					style="padding: 2px 12px 4px;background-color: #FCFCFC;"> create new project </a>
			</div>
		</div>
	</div>
	
	<div id="profile-edit-cont" class="float-fix" style="display: none;">
		<a class="float-right icon close-icon bold cancel-edit-btn" href="javascript:void(0);" style="font-size: 14px;"> close </a>
		<form action="<%= request.getContextPath() %>/user/update_profile" method="post" id="user-profile-form" >
			<input type="hidden" value="<s:property value="loggedInUser.pkey"/>" name="user.pkey">
			<div class="float-left" style="padding-right: 30px; border-right: 1px dashed #CCCCCC; margin-right: 30px;">
				<ul>
					<li>
						<label> Full Name </label>
						<input type="text" name="user.fullName" value="<s:property value="loggedInUser.fullName"/>" placeholder="Full Name">
					</li>
					<li>
						<label> Location </label>
						<input type="text" name="user.location" value="<s:property value="loggedInUser.location"/>" placeholder="Country">
					</li>
					<li>
						<input type="button" id="profile-submit-btn" value="update" class="btn btn-yellow float-right margin-5px">
<!-- 						<input type="button" value="cancel" class="btn float-right margin-5px cancel-edit-btn" style="clear: none;"> -->
					</li>
				</ul>
			</div>
			<div class="float-left">
				<div id="edit-passwd-cont">
					<ul>
						<li>
							<label> Change Password <span class="normal gray-ccc-text"> &nbsp; &nbsp; * not necessary </span></label>
							<input type="password" id="user-pswd" name="newPassword" placeholder="new password" class=" " >
						</li>
						<li>
							<input type="password" id="user-confirm-pswd" value="" placeholder="confirm password" class=" ">
						</li>
					</ul>
				</div>
			</div>
		</form>
	</div>
		
	<div id="main-cont">
	
		<s:if test="%{projects != null && projects.size() > 0}">
		
			<ul id="user-interactions-list" class="float-fix" style="margin-top: 15px;">
	
				<s:iterator value="projects" var="project">
			  		<li class="interaction">
						
						<input type="hidden" class="project-pkey" value="<s:property value="%{#project.pkey}" />">
						
						<div class="img-cont">
							<a title="edit" href="<%= request.getContextPath() %>/project/view?project.pkey=<s:property value="%{#project.pkey}" />" class="thumb">	
								<s:if test="%{#project.layout.landingPage.screenImage.pkey != null}">
			 						<img class="" alt="<s:property value="%{#project.layout.landingPage.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#project.layout.landingPage.screenImage.pkey}" />">
			 					</s:if>
							</a>
						</div>
						
						<div class="details-cont">
							<div class="float-left clear">
								<h2 class="auto-ellipses"><s:property value="%{#project.title}" /></h2>
								<p class="proj-desc"><s:property value="%{#project.description}" /></p>
							</div>
							<div class="float-left clear" style="margin: 10px 0;">
								<label class=""> <span class="bold">for </span> <s:property value="%{#project.projectType}" /></label>
								
								<label> 
									<span class="bold">tags </span> 
									<s:iterator value="%{#project.tags}" var="tag">
										<s:property value="%{#tag.title}" /> 
									</s:iterator>
								</label>
								
								<s:if test="%{#project.isPublic == true}">
									<label class="gray-999-text bold"> * published to public</label>							
								</s:if>
								
							</div>
						</div>
						
						<div class="options-cont">
							<a class="view-icon bold margin-5px" href="<%= request.getContextPath() %>/project/view?project.pkey=<s:property value="%{#project.pkey}" />"> view </a>
							<a class="edit-icon bold margin-5px" href="<%= request.getContextPath() %>/project/build/prepare?project.pkey=<s:property value="%{#project.pkey}" />&user.emailId=<s:property value="loggedInUser.emailId"/>"> edit </a>
							<a class="delete-icon bold margin-5px" href="<%= request.getContextPath() %>/project/delete?project.pkey=<s:property value="%{#project.pkey}" />&user.emailId=<s:property value="loggedInUser.emailId"/>"> delete </a>
						</div>
						
			  		</li>
				</s:iterator>
			</ul>
		</s:if>
		<s:else>
			<div id="no-items-cont" style="width: 305px;">
				<a href="#new-project-popup" class="plus-icon float-left fancy-box-link" > Create new project </a>
				<label class=""> and start stitching </label>
			</div>
		</s:else>
	
	</div>   
		
	<section class="pop-ups-cont">
	
		<div id="new-project-popup" class="pop-up">
			
			<div id="get-started-box">
			
				<label class="title"> Stitch a New Pattern </label>
				<p> Pattern should represent a complete navigation sequence from a Mobile Project, explained in maximum of 10 slides. </p>
				
				<form action="<%= request.getContextPath() %>/project/settings" id="new-pattern-form" method="post">
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
							<input type="hidden" name="user.emailId" value="<s:property value="loggedInUser.emailId"/>">
						</li>
						<li>
							<input type="button" id="new-pattern-submit-btn" value="" class="" >
						</li>
					</ul> 
				</form>
				
			</div>
			
		</div>
	
		
		<!-- Project Delete pop-up -->
		
		<div id="project-delete-popup" class="pop-up">
			<form id="projectDeleteForm" action="<%= request.getContextPath() %>/project/delete" method="post">
						
				<input type="hidden" name="project.pkey" value="" id="project-pkey">
				
				<div class="pu-header">
					<label class="pu-title float-left"> Confirmation </label>
					<a href="javascript:void(0);" class="close-icon float-right close-pop-up"></a>
				</div>
				<div class="pu-body">
					<div class="msg-cont">
					
					</div>
					<div class="pu-content">
						<label>Are you sure?</label>
					</div>
				</div>
				
				<div class="pu-footer">
					<div class="btn-cont">
						<input type="button" value="Cancel" id="" class="close-pop-up btn">
						<input type="submit" value="Delete Project" id="" class="btn">
					</div>
				</div>
				
			</form>
		</div>
	
	</section>
	
</body>

</html>		