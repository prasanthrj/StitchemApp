
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> User Profile </title>
	
	<script type="text/javascript" >
	
	$(document).ready( function() {
		
		/* Window resize related ... */
		adjustToWindowDimentions(); 
		
		$(window).resize(function() {
			adjustToWindowDimentions(); 
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
						<label style="font-size: 14px;"> <s:property value="user.fullName"/> </label>
					</li>
					<li>
						<label><s:property value="projects.size()"/> Projects </label>
					</li>
				</ul>
			</div>
			<div class="float-right">
				
			</div>
		</div>
	</div>
	
	<div id="main-cont"> 
		
		<ul id="user-interactions-list" class="">
	
			<s:iterator value="projects" var="project">
	  		
		  		<li class="interaction">

					<a href="<%= request.getContextPath() %>/project/view?project.pkey=<s:property value="%{#project.pkey}" />&user.emailId=<s:property value="loggedInUser.emailId"/>" class="thumb">	
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
						</div>
						
					</div>
		  			
					<input type="hidden" class="project-pkey" value="<s:property value="%{#project.pkey}" />">
		  			
		  		</li>
	 		
			</s:iterator>
		</ul>
	
	
	</div>   
		
	<section class="pop-ups-cont">
	
		
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