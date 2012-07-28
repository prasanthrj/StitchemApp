
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>
	
	<meta>
	<title> Project Editor  </title>
	
	
	<!-- Scrollbar testing -->
	
	<%-- 
	<style type="text/css">
	
		::-webkit-scrollbar {
			width: 10px;
			height: 10px;
		}
		
		::-webkit-scrollbar-button:start:decrement,
		::-webkit-scrollbar-button:end:increment  {
			height: 30px;
			display: block;
			background-color: transparent;
		}
		
		::-webkit-scrollbar-track-piece  {
			background-color: #3b3b3b;
			-webkit-border-radius: 6px;
		}
		
		::-webkit-scrollbar-thumb:vertical {
			height: 50px;
			background-color: #666;
			border: 1px solid #eee;
			-webkit-border-radius: 6px;
		}

	</style>
	 --%>
	
	<script type="text/javascript">
	$(document).ready( function() {
		
		
		$('#submit-project-btn').live('click', function(){
			$('#new-post-form').trigger('submit');
		});
		
		var projectType = '<s:property value="project.projectType" />';
		
		if( projectType && projectType != '' ){
			$('#project-type-select').val(projectType);
			
			var customSettingsDiv = $('#custom-settings');
			if(projectType == 'Custom'){
				customSettingsDiv.show();			
			} else {
				customSettingsDiv.hide();			
			}
			
		};
		
		var orientation = '<s:property value="layout.orientation" />';
		if( orientation && orientation != '' ){
			$('#orientation-select').val(orientation);
		};
		
		
	});
	
	// Repeated in Two places 1. File Upload 2. Create / Edit ..
	function preparePageForEditingInBuild(projectPkey, pagePkey) {
		if(projectPkey && pagePkey) {
			window.location.href = '<%= request.getContextPath() %>/project/build/prepare?project.pkey=' + projectPkey + '&page.pkey=' + pagePkey;
		}
	};
	
	function loadProjectRelatedDetails(element){
		var projType = $(element).val();
		
		$('.ellipsis').hide();
		$('#' + projType + '-desc').show();
		
		var customSettingsDiv = $('#custom-settings');
		if(projType == 'Custom'){
			customSettingsDiv.show();			
		} else {
			customSettingsDiv.hide();			
		}
		
	};
	
	</script>
	
</head>

<body>

	<!-- Body Content -->
	
	<section class="full-width" id="body-content" >
		<div class="in" >
		 	
		 	<table class="float-left clear" id="body-table">
	
<!-- 			<div class="padding-10px-bot"> -->
<!-- 		 		<h1 class="page-title gray-999-text" id="page-title-cont"> New Project </h1> -->
<!-- 		 	</div> -->
		 	
<!-- 		 	<table class="float-left clear full-width"> -->
		 		<thead>
		 			<tr>
		 				<th>
		 					<div class="sec-header-bar">
								<label class=""> 
									<s:if test="%{project.title != null && project.title != '' }">
										<s:property value="project.title" />
									</s:if>
									<s:else> New Project </s:else>
	
								</label>
							</div>
		 				</th>
		 				<th>
		 					<div class="sec-header-bar right">
								<label class=""> About the Project </label>
								
								<a class="float-right btn" href="javascript:void(0);" id="submit-project-btn">
									<s:if test="%{project.pkey != null && project.pkey != '' }">
										Update &amp; Continue 
								 	</s:if>
								 	<s:else>
								 		Save &amp; Continue 
								 	</s:else>
								</a>
							</div>
		 				</th>
		 			</tr>
		 		</thead>
		 		
		 		<tbody>
			 		<tr>
			 			<td id="left-navigation" >
			 			
							<div id="left-scroll-cont" class="float-left abs-scrollable"> 
<!-- 							<div id="left-scroll-cont" class="float-left"> -->
							
								<ul class="float-left clear" id="project-pages-list">
									
									<li class="float-left clear no-margin">
										<a class="float-left clear left-nav-bar selected-bar" href="javascript:void(0)">
											<span class="float-left clear"> About Project </span>
											<span class="float-left clear info-text"> intro/description </span>
										</a>
									</li>
									
									<li class="float-left clear no-margin">
										<s:if test="%{project.pkey != null && project.pkey != '' }">
											<a class="float-left clear left-nav-bar" href="<%= request.getContextPath() %>/project/build/uploader?project.pkey=<s:property value="project.pkey" />" id="">
												<span class="float-left clear"> Manage Images </span>
												<span class="float-left clear info-text"> screens for the project </span>
											</a>
										</s:if>
									</li>
									
						 			<s:iterator value="pages" var="page">
							     		<li class="float-left clear padding-10px-bot left-nav-bar page-li" onclick="preparePageForEditingInBuild( <s:property value="project.pkey" /> , <s:property value="%{#page.pkey}" /> )" >
							     			<div class="page-img-thumb-cont">	
							     				<img class="float-left page-img-thumbnail" alt="<s:property value="%{#page.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#page.screenImage.pkey}" />">
								     		</div>

								     		<div class="page-thumb-info-cont">
									     		<label class="margin-5px clear float-left">
<%-- 									     			<s:property value="%{#page.screenImage.fileObjFileName}" /> --%>
									     			<s:property value="%{#page.title}" />
									     		</label>
									     		
									     		<ul class="page-thumb-info clear">
									     			
									     			<li class="float-left margin-5px">
														<img class="float-left" alt="" src="<%= request.getContextPath() %>/themes/images/hotspot_small.png" width="16px">
														<label class="padding-5px-left"> <span> <s:property value="%{#page.hotSpots.size()}" /> </span> </label>										
													</li>
													<li class="float-left margin-5px">
									     				<s:if test="%{#page.headerImage == null || #page.headerImage.pkey == '' }">
															<img class="float-left" alt="" src="<%= request.getContextPath() %>/themes/images/header_small_nil.png">										
				<!-- 											<label class="padding-5px-left"> No header </label>	 -->
														</s:if>
													</li>
													<li class="float-left margin-5px">
														<s:if test="%{#page.footerImage == null || #page.footerImage.pkey == '' }">
															<img class="float-left" alt="" src="<%= request.getContextPath() %>/themes/images/footer_small_nil.png">
				<!-- 											<label class="padding-5px-left"> No footer </label>	 -->
														</s:if>
													</li>
													<li class="float-left margin-5px">
														<img class="float-left" alt="" src="<%= request.getContextPath() %>/themes/images/comments_small.png" width="16px">
														<label class="padding-5px-left"> <span> <s:property value="%{#page.comments.size()}" /> </span> </label>	
													</li>
													
									     		</ul>
			
									     		<input type="hidden" class="image-pkey" value="<s:property value="%{#page.screenImage.pkey}" />">
									     		<input type="hidden" class="page-pkey" value="<s:property value="%{#page.pkey}" />">
									     	</div>
								     		
							     		</li>
								    </s:iterator> 
								    						    				 			
						 		</ul>
					 		
					 		</div>
								
							
			 			</td>
			 			
			 			<td id="page-content">
			 				
			 				
			
				 			<form action="<%= request.getContextPath() %>/project/save" method="post" id="new-post-form" enctype="multipart/form-data">
						 		<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
					 			
					 			<div class="float-left padding-10px">
					 				<div class="padding-10px-ver float-left clear">
						 				<input type="text" class="mandatory inp-box-long inner-shadow" name="project.title" value="<s:property value="project.title" />" placeholder="Project title">
						 			</div>
						 			<div class="padding-10px-ver float-left clear">
						 				<textarea class="mandatory description-box inner-shadow" name="project.description" placeholder="Project description" style="height: 150px;"><s:property value="project.description" /></textarea>
					 				</div>
					 			</div>
					 			
					 			<div class="float-right " id="project-type-cont">
					 				
					 				<div class="float-left clear padding-10px-ver" >
						 				<select name="project.projectType" class="inp-box inner-shadow" id="project-type-select" onchange="loadProjectRelatedDetails(this);">
						 					<option value="AndroidMobile"> Android Mobile </option>
						 					<option value="AndroidTab"> Android Tab </option>
	<!-- 					 					<option value="AndroidTabLandScape"> Android Tab - LandScape </option> -->
	<!-- 					 					<option value="AndroidTabPortrait"> Android Tab - Portrait </option> -->
						 					<option value="Iphone3"> Iphone 3 Mobile </option>
						 					<option value="Iphone4"> Iphone 4 Mobile </option>
						 					<option value="Ipad"> Ipad </option>
						 					<option value="Webapp"> Web Application </option>
						 					<option value="Custom"> Custom Application </option>
						 				</select>
					 				</div>
					 				
					 				<div class="gray-999-text margin-5px padding-10px-ver">
			 							<p class="ellipsis" id="AndroidMobile-desc">A typical android phone's screen resolution is 480 X 800 px. Samsung galaxy, HTC wildfire, Nexus are some of the popular phones that has this resolution.</p>
										<p class="ellipsis" id="AndroidTab-desc" style="display:none;">A typical android tabs's screen resolution is 1280 X 800 px. Samsung galaxy tab, is one of the popular tabs that has this resolution.</p>
										<p class="ellipsis" id="Iphone3-desc" style="display:none;">IPhone 3's screen resolution is 320 X 480 px. </p>
										<p class="ellipsis" id="Iphone4-desc" style="display:none;">IPhone 4's screen resolution is 640 X 960 px. This is the retina display's resolution. </p>
										<p class="ellipsis" id="Ipad-desc" style="display:none;">IPad's screen resolution is 1024 X 768 px. </p>
										<p class="ellipsis" id="Webapp-desc" style="display:none;">A typical fixed width web application will have it's resolution set to 1024 X 900 px. </p>
										<p class="ellipsis" id="Custom-desc" style="display:none;">Choose your custom dimentions in the project creation step. </p>
					 				</div>
					 				
					 				<div class="float-left clear padding-10px-ver">
					 					<label>Oreintation :</label>
					 					<select class="inp-box inner-shadow" name="layout.orientation" id="orientation-select">
					 						<option value="none"> -- default --</option>
					 						<option value="vertical"> vertical </option>
					 						<option value="horizontal"> horizontal </option>
					 						<option value="both"> both </option>
					 					</select>
					 				</div>
					 				
					 				<div class="float-left clear padding-10px-ver" id="custom-settings" style="display: none;">
					 					<div class="float-left">
											<label class="float-left"> width :</label>
											<input placeholder="in pixels" type="text" value="<s:property value="layout.width" />" name="layout.width" class="inner-shadow clear float-left" style="width: 139px; height: 25px;">					 				
					 					</div>
					 					
					 					<div class="float-left" style="margin-left: 8px;">
											<label class="float-left"> height :</label>
											<input placeholder="in pixels" type="text" value="<s:property value="layout.height" />" name="layout.height" class="inner-shadow clear float-left" style="width: 140px; height: 25px;">					 				
					 					</div>	
					 				</div>
					 			
					 			</div>	
						    
							</form>
							
								
			 			</td>
			 			
			 		</tr>
			 	</tbody>
		 	</table>
		 	
		</div>
		 
		<!-- Right Side bar -->
		
		<!--  
		<div class="right-side-bar">
			<div class="padding-10px-hor">
					
		 		<h1 class="gray-666-text bold float-left clear"> Browse Projects   </h1>
		 		<ul class="float-left clear padding-10px-bot margin-5px">
		 			<li class=""><a>Project 1</a></li>
		 			<li class=""><a>Project 2</a></li>
		 			<li class=""><a>Project 3</a></li>
		 			<li class=""><a>Project 4</a></li>
		 			<li class=""><a>Project 5</a></li>
		 		</ul>
		 		
		 		
		 	</div>
		 </div>
		-->
		
	</section>
	
</body>

</html>		