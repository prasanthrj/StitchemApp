
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> User Home </title>
	
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

	<div id="top-cont" class="yellow-bg">
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
				</ul>
			</div>
			<div class="float-right">
				<a href="#new-project-popup" class="float-right btn margin-5px fancy-box-link" style="padding: 2px 12px 4px;"> create new project </a>
			</div>
		</div>
	</div>
		
	<div id="main-cont">
		
		<ul id="user-interactions-list" class="">
	
			<s:iterator value="projects" var="project">
	  		
		  		<li class="interaction">

					<a title="edit" href="<%= request.getContextPath() %>/project/build/prepare?project.pkey=<s:property value="%{#project.pkey}" />&user.emailId=<s:property value="loggedInUser.emailId"/>" class="thumb">	
						<s:if test="%{#project.layout.landingPage.screenImage.pkey != null}">
	 						<img class="" alt="<s:property value="%{#project.layout.landingPage.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#project.layout.landingPage.screenImage.pkey}" />">
	 					</s:if>
					</a>
					
					<div class="float-left">
					
						<div class="float-left">
							<h2 class="auto-ellipses"><s:property value="%{#project.title}" /></h2>
							<label class="proj-desc" style="display: none;">
								<s:property value="%{#project.description}" />
							</label>
						</div>
						
						<div class="float-left clear margin-5px">
							<a class="no-border bold margin-5px" href="<%= request.getContextPath() %>/project/view?project.pkey=<s:property value="%{#project.pkey}" />"> view </a>
							<a class="no-border bold margin-5px" href="<%= request.getContextPath() %>/project/build/prepare?project.pkey=<s:property value="%{#project.pkey}" />&user.emailId=<s:property value="loggedInUser.emailId"/>"> edit </a>
							<a class="no-border bold margin-5px" href="<%= request.getContextPath() %>/project/delete?project.pkey=<s:property value="%{#project.pkey}" />&user.emailId=<s:property value="loggedInUser.emailId"/>"> delete </a>
						</div>
					
					</div>
		  			
					<input type="hidden" class="project-pkey" value="<s:property value="%{#project.pkey}" />">
		  			
		  		</li>
	 		
			</s:iterator>
		</ul>
	
	
	</div>   
		
	<section class="pop-ups-cont">
	
		<div id="new-project-popup" class="pop-up">
			
			<div id="get-started-box">
			
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
<!-- 							<label> Your email </label> -->
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