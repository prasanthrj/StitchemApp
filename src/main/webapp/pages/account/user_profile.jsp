
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
							</div>
						</div>
						
						<div class="options-cont">
							<a class="view-icon bold margin-5px" href="<%= request.getContextPath() %>/project/view?project.pkey=<s:property value="%{#project.pkey}" />"> view </a>
						</div>
						
			  		</li>
				</s:iterator>
			</ul>
		</s:if>
		<s:else>
			<div id="no-items-cont" style="width: 305px;">
				<label class="float-left" > Yet to contribute !!!  </label>
			</div>
		</s:else>
		
		
	
	
	</div>   
		
	<section class="pop-ups-cont">
	
	</section>
	
</body>

</html>		