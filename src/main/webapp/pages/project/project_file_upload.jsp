
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>
	
<!-- 	http://blueimp.github.com/jQuery-File-Upload/     -->

<!-- 	Using the below	  -->
<!-- 	http://davidwalsh.name/dw-content/multiple-file-upload.php 	 -->

<!-- 	http://struts.apache.org/2.0.14/docs/interceptors.html 	-->

<!--    http://www.fyneworks.com/jquery/multiple-file-upload/ -->


	
	<meta>
	<title> Project file uploader  </title>
	
	<link rel="stylesheet" href="<%=request.getContextPath() %>/themes/styles/jscrollpane.css"></link>
	<script type="text/javascript" src="<%=request.getContextPath() %>/scripts/lib/jscrollpane.min.js"></script>
	
	<script type="text/javascript" src="<%=request.getContextPath() %>/scripts/lib/mousewheel.js"></script>
<%-- 	<script type="text/javascript" src="<%=request.getContextPath() %>/scripts/lib/mwheelIntent.js"></script> --%>

	<style type="text/css">
	
	.images-upload-btn {
		cursor: pointer;
	}
	
	#right-scroll-cont {
		bottom: 10px;
	    padding: 0 !important;
	    position: absolute;
	    top: 125px;
	    right: 20px;
	    left: 250px;
	    overflow-y: scroll;
	}
	
	</style>
	
	<script type="text/javascript">
	
	$(document).ready( function() {
		
		// Scrollpane .. 
		$("#left-scroll-cont").jScrollPane({showArrows: true }).data().jsp;
		
// 		$("#right-scroll-cont").jScrollPane({showArrows: true }).data().jsp;
		
		//scrollpane.destroy(); 
		
		// ----------------------------------------------------------------------------   
		
		var uploadForm = $('#upload-imgs-form');
		var multiFileInput = $('#images-multiple-input');
		
		
		$('.images-upload-btn').live('click', function(){
			
			var name = $(this).attr('name');
			
			multiFileInput.attr('name', name + '.fileObj'); 
			multiFileInput.trigger('click');
			
		});
		
		multiFileInput.live('change', submitUploadImagesForm );
		
		
		// Setting the Landing Page ... 
		var landingPageImgPkey = '<s:property value="layout.landingPage.screenImage.pkey" />';
		if(landingPageImgPkey) {
			
			var leftLandingPageLi = $('.image-pkey[value=' + landingPageImgPkey + ']').parents('li.page-li');
			leftLandingPageLi.append('<label id="landing-page-label"> Landing Page </label>');
			
			$('#' + landingPageImgPkey).find('.landing-page-icon').addClass('landing-page');
		}

		
	});
	
	function submitUploadImagesForm(){
		
		//get the input and UL list 
		var multinput = document.getElementById('images-multiple-input');

		var uploadForm = document.getElementById('upload-imgs-form');
		
		console.log(multinput.files);
		
		for (var i = 0; i < multinput.files.length; i++) {
			
			var nameElem = document.createElement("input");
			nameElem.type = 'hidden';
			nameElem.name = 'imageNames[' + i + ']';
			nameElem.value = multinput.files[i].name;
			
			uploadForm.appendChild(nameElem);
			
			var typeElem = document.createElement("input");
			typeElem.type = 'hidden';
			typeElem.name = 'imageContentTypes[' + i + ']';
			typeElem.value = multinput.files[i].type;
			
			uploadForm.appendChild(typeElem);
			
		}
		
	
		$(uploadForm).trigger('submit');
 		
	};
	
	function deleteImageFile(element, pkey) {
		
		if(pkey) {
			var deleteImgUrl = '<%= request.getContextPath() %>/image/remove?imageFile.pkey=' + pkey ;
			$.getJSON(deleteImgUrl, function(data){
				// If no error .. 
				$(element).parents('li.image-li').remove();
								
			});

		}
		
	};
	
	// Repeated in Two places 1. File Upload 2. Create / Edit ..
	function preparePageForEditingInBuild(projectPkey, pagePkey) {
		if(projectPkey && pagePkey) {
			window.location.href = '<%= request.getContextPath() %>/project/build/prepare?project.pkey=' + projectPkey + '&page.pkey=' + pagePkey;
		}
	};
	
	
	// update Landing Page ..
	function updateLandingPage( element, pkey ) {
		
		var currentLandingPageImagePkey = $('#landing-page-image-pkey').val();
		if( currentLandingPageImagePkey == pkey )
			return;
	
		var projectPkey = $('#project-pkey').val();
// 		var layoutPkey = $('#layout-pkey').val(); 
		
		// Left Nav 
		var leftLandingPageLi = $('.image-pkey[value=' + pkey + ']').parents('li.page-li');
		var landingPagePkey = leftLandingPageLi.find('input.page-pkey').val();
		
		var updateLayoutURL = '<%= request.getContextPath() %>/project/build/update_landing_page?project.pkey=' + projectPkey + '&page.pkey=' + landingPagePkey;
		$.getJSON( updateLayoutURL, function(){
			
			$('.landing-page').removeClass('landing-page');
			$(element).addClass('landing-page');
			
			$('#landing-page-label').remove();
			
			// Update on the left side .. .. 
			leftLandingPageLi.append('<label id="landing-page-label"> Landing Page </label>');
			
			// Update the pkey .. 
			$('#landing-page-image-pkey').attr('value', pkey);
			
		});
		
	};
	
	</script>
	
</head>

<body>

	<section id="info-cont" style="display: none;">
	
		<input type="hidden" value="<s:property value="project.pkey" />" id="project-pkey">
		<input type="hidden" value="<s:property value="project.layout.pkey" />" id="layout-pkey">
		
		<input type="hidden" value="<s:property value="layout.landingPage.screenImage.pkey" />" id="landing-page-image-pkey">
		<input type="hidden" value="<s:property value="layout.landingPage.pkey" />" id="landing-page-pkey">
		
	</section>
	
	
	<!-- Body Content -->
	
	<section class="float-left clear full-width" id="body-content">
		
		<div id="body-table-cont" >
			 
		 	<table class="float-left clear" id="body-table">
		 		
		 		<thead>
		 			<tr>
		 				<th>
		 					<div class="sec-header-bar ">
								<label class="" > <s:property value="project.title" /> </label>
							</div>
		 				</th>
		 				<th>
		 					<div class="sec-header-bar">
								<label class=""> Add images to the project </label>
								<a class="float-right btn" href="<%= request.getContextPath() %>/project/build/prepare?project.pkey=<s:property value="project.pkey" />" id="submit-project-btn"> Continue to Build </a>
							</div>
		 				</th>
		 			</tr>
		 		</thead>
		 		
		 		<tbody>
			 		<tr>
			 			<td id="left-navigation" >
			 				
							<div id="left-scroll-cont" class="float-left"> 
							
								<ul class="float-left clear" id="project-pages-list">
									
									<li class="float-left clear no-margin">
										<s:if test="%{project.pkey != null && project.pkey != '' }">
											<a class="float-left clear left-nav-bar" href="<%= request.getContextPath() %>/project/edit?project.pkey=<s:property value="project.pkey" />" >
												<span class="float-left clear"> About Project </span>
												<span class="float-left clear info-text"> intro/description </span>
											</a>
										</s:if>
									</li>
									
									<li class="float-left clear no-margin">
										<a class="float-left clear left-nav-bar selected-bar" href="javascript:void(0);" id="">
											<span class="float-left clear"> Manage Images </span> 
											<span class="float-left clear info-text"> screens for the project </span>
										</a>
									</li>
									
						 			<s:iterator value="pages" var="page">
							     		<li class="float-left clear padding-10px-bot left-nav-bar page-li" onclick="preparePageForEditingInBuild( <s:property value="project.pkey" /> , <s:property value="%{#page.pkey}" /> )" >
							     			<div class="page-img-thumb-cont">	
							     				<img class="float-left page-img-thumbnail" alt="<s:property value="%{#page.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#page.screenImage.pkey}" />">
								     		</div>
								     		
								     		<div class="page-thumb-info-cont">
									     		<label class="margin-5px clear float-left">
									     			<s:property value="%{#page.screenImage.fileObjFileName}" />
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
			 			
			 				<div id="right-scroll-cont" class=""> 
			 				
				 				<section class="margin-5px padding-5px">
									
									<div class="clear margin-5px">
								 		<label class="gray-333-text bold float-left"> The Application Page Screens </label>
								 		<label class="gray-666-text float-right"> <span class="gray-333-text bold"> width : </span> <s:property value="project.layout.width" /> px (fixed) <span class="gray-333-text bold"> X </span> <span class="gray-333-text bold"> height : </span> <s:property value="project.layout.height" /> px (min) </label>
								 		<label class="gray-666-text float-left clear italic"> You can do bulk upload and preview the uploaded images .. </label>
								 	</div>
								 	
									<section id="screen-images-cont" class="collapsible-section float-left clear margin-5px">
										
										<ul class="inline-list clear" id="">
											<s:iterator value="screenImages" var="screenImage">
												<li class="float-left margin-5px padding-5px image-li" id="<s:property value="%{#screenImage.pkey}" />"  >
													
													<a href="javascript:void(0);" class="landing-page-icon" title="Click to set as Landing Page" onclick="updateLandingPage( this, <s:property value="%{#screenImage.pkey}" /> )" ></a>
													<a href="javascript:void(0);" class="bin-icon float-right delete-img-btn" onclick="deleteImageFile( this, <s:property value="%{#screenImage.pkey}" />)"></a>
													
										     		<div class="page-img-thumb-cont">	
									     				<img class="float-left page-img-thumbnail" alt="<s:property value="%{#screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#screenImage.pkey}" />">
										     		</div>
										     		<div class="page-thumb-info-cont">
											     		<label class="margin-5px clear float-left">
											     			<s:property value="%{#screenImage.fileObjFileName}" />
											     		</label>
											     	</div>
										     		
												</li>
											</s:iterator>
											
											<li class="float-left margin-5px padding-5px image-li clear">
									     		<div class="page-img-thumb-cont" style="border-bottom: 1px solid #cccccc;">
								     				<img class="float-left page-img-thumbnail images-upload-btn" alt="Add more Images" src="<%= request.getContextPath() %>/themes/images/upload_images.png" name="screenImages" />
									     		</div>
											</li>
											
										</ul>
					 														
									
									</section>
									
									<div class="clear margin-5px" style="border-top: 1px dotted #CCCCCC; padding-top: 5px;">
								 		<label class="gray-333-text bold float-left"> The Application Headers </label>
								 		<label class="gray-666-text float-right"> <span class="gray-333-text bold"> width : </span> <s:property value="project.layout.width" /> px (fixed) <span class="gray-333-text bold"> X </span> <span class="gray-333-text bold"> height : </span> Your choice </label>
								 		<label class="gray-666-text float-left clear italic"> You can do bulk upload and preview </label>
								 	</div>
								 	
									<section id="header-images-cont" class="collapsible-section float-left clear margin-5px">
										
										<ul class="inline-list clear" id="">
											<s:iterator value="headerImages" var="headerImage">
												<li class="float-left margin-5px padding-5px image-li">
													
													<a href="javascript:void(0);" class="bin-icon float-right delete-img-btn" onclick="deleteImageFile( this, <s:property value="%{#headerImage.pkey}" />)"></a>
													
										     		<div class="page-img-thumb-cont">	
									     				<img class="float-left page-img-thumbnail" alt="<s:property value="%{#headerImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#headerImage.pkey}" />">
										     		</div>
										     		<div class="page-thumb-info-cont">
											     		<label class="margin-5px clear float-left">
											     			<s:property value="%{#headerImage.fileObjFileName}" />
											     		</label>
											     	</div>
										     		
												</li>
											</s:iterator>
											
											<li class="float-left margin-5px padding-5px image-li clear">
									     		<div class="page-img-thumb-cont" style="border-bottom: 1px solid #cccccc;">
								     				<img class="float-left page-img-thumbnail images-upload-btn" alt="Add more Images" src="<%= request.getContextPath() %>/themes/images/upload_images_header_footer.png" name="headerImages"/>
									     		</div>
											</li>
											
										</ul>
										
									</section>
									
									<div class="clear margin-5px" style="border-top: 1px dotted #CCCCCC; padding-top: 5px;">
								 		<label class="gray-333-text bold float-left"> The Application Footers </label>
								 		<label class="gray-666-text float-right"> <span class="gray-333-text bold"> width : </span> <s:property value="project.layout.width" /> px (fixed) <span class="gray-333-text bold"> X </span> <span class="gray-333-text bold"> height : </span> Your choice </label>
								 		<label class="gray-666-text float-left clear italic"> You can do bulk upload and preview the uploaded images .. </label>
								 	</div>
								 	
									<section id="footer-images-cont" class="float-left clear margin-5px">
										
										<ul class="inline-list clear" id="">
											<s:iterator value="footerImages" var="footerImage">
												<li class="float-left margin-5px padding-5px image-li">
													
													<a href="javascript:void(0);" class="bin-icon float-right delete-img-btn" onclick="deleteImageFile( this, <s:property value="%{#footerImage.pkey}" />)"></a>
													
										     		<div class="page-img-thumb-cont">	
									     				<img class="float-left page-img-thumbnail" alt="<s:property value="%{#footerImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#footerImage.pkey}" />">
										     		</div>
										     		<div class="page-thumb-info-cont">
											     		<label class="margin-5px clear float-left">
											     			<s:property value="%{#footerImage.fileObjFileName}" />
											     		</label>
											     	</div>
										     		
												</li>
											</s:iterator>
											
											<li class="float-left margin-5px padding-5px image-li clear">
									     		<div class="page-img-thumb-cont" style="border-bottom: 1px solid #cccccc;">
								     				<img class="float-left page-img-thumbnail images-upload-btn" alt="Add more Images" src="<%= request.getContextPath() %>/themes/images/upload_images_header_footer.png" name="footerImages"/>
									     		</div>
											</li>
											
										</ul>
									
									</section>
									
<%-- 									<s:property value="project.projectType" /> --%>
									
									
<%-- 									<s:if test="%{project.projectType == 'AndroidTab' }"> --%>
									
									<s:if test="%{project.projectType.toString() != null && project.projectType.toString() != '' }">
										<s:if test="%{project.projectType.toString() == 'AndroidTab' || project.projectType.toString() == 'Ipad' || project.projectType.toString() == 'Webapp' || project.projectType.toString() == 'Custom' }">
										
											<div class="clear margin-5px" style="border-top: 1px dotted #CCCCCC; padding-top: 5px;">
										 		<label class="gray-333-text bold float-left"> The Application Left Panels </label>
										 		<label class="gray-666-text float-right"> <span class="gray-333-text bold"> width : </span> Your choice <span class="gray-333-text bold"> X </span> <span class="gray-333-text bold"> height : </span> <s:property value="project.layout.height" /> px (fixed)  </label>
										 		<label class="gray-666-text float-left clear italic"> You can do bulk upload and preview the uploaded images .. </label>
										 	</div>
										 	
											<section id="footer-images-cont" class="float-left clear margin-5px">
												
												<ul class="inline-list clear" id="">
													<s:iterator value="leftNavImages" var="leftNavImage">
														<li class="float-left margin-5px padding-5px image-li">
															
															<a href="javascript:void(0);" class="bin-icon float-right delete-img-btn" onclick="deleteImageFile( this, <s:property value="%{#leftNavImage.pkey}" />)"></a>
															
												     		<div class="page-img-thumb-cont">	
											     				<img class="float-left page-img-thumbnail" alt="<s:property value="%{#leftNavImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#leftNavImage.pkey}" />">
												     		</div>
												     		<div class="page-thumb-info-cont">
													     		<label class="margin-5px clear float-left">
													     			<s:property value="%{#leftNavImage.fileObjFileName}" />
													     		</label>
													     	</div>
												     		
														</li>
													</s:iterator>
													
													<li class="float-left margin-5px padding-5px image-li clear">
											     		<div class="page-img-thumb-cont" style="border-bottom: 1px solid #cccccc;">
										     				<img class="float-left page-img-thumbnail images-upload-btn" alt="Add more Images" src="<%= request.getContextPath() %>/themes/images/upload_images_header_footer.png" name="leftNavImages"/>
											     		</div>
													</li>
													
												</ul>
											
											</section>
										
											<div class="clear margin-5px" style="border-top: 1px dotted #CCCCCC; padding-top: 5px;">
										 		<label class="gray-333-text bold float-left"> The Application Right Panels </label>
										 		<label class="gray-666-text float-right"> <span class="gray-333-text bold"> width : </span> Your choice <span class="gray-333-text bold"> X </span> <span class="gray-333-text bold"> height : </span> <s:property value="project.layout.height" /> px (fixed)  </label>
										 		<label class="gray-666-text float-left clear italic"> You can do bulk upload and preview the uploaded images .. </label>
										 	</div>
										 	
											<section id="footer-images-cont" class="float-left clear margin-5px">
												
												<ul class="inline-list clear" id="">
													<s:iterator value="rightNavImages" var="rightNavImage">
														<li class="float-left margin-5px padding-5px image-li">
															
															<a href="javascript:void(0);" class="bin-icon float-right delete-img-btn" onclick="deleteImageFile( this, <s:property value="%{#rightNavImage.pkey}" />)"></a>
															
												     		<div class="page-img-thumb-cont">	
											     				<img class="float-left page-img-thumbnail" alt="<s:property value="%{#rightNavImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#rightNavImage.pkey}" />">
												     		</div>
												     		<div class="page-thumb-info-cont">
													     		<label class="margin-5px clear float-left">
													     			<s:property value="%{#rightNavImage.fileObjFileName}" />
													     		</label>
													     	</div>
												     		
														</li>
													</s:iterator>
													
													<li class="float-left margin-5px padding-5px image-li clear">
											     		<div class="page-img-thumb-cont" style="border-bottom: 1px solid #cccccc;">
										     				<img class="float-left page-img-thumbnail images-upload-btn" alt="Add more Images" src="<%= request.getContextPath() %>/themes/images/upload_images_header_footer.png" name="rightNavImages"/>
											     		</div>
													</li>
													
												</ul>
											
											</section>
										
										</s:if>
									</s:if>
										
									
									<div class="float-left clear" style="display: none;">
<!-- 									<div> -->
										
										<form action="<%= request.getContextPath() %>/project/build/upload_images" method="post" id="upload-imgs-form" enctype="multipart/form-data">
									 		
									 		<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
										    
										    <input type="file" multiple="multiple" id="images-multiple-input" name="screenImages.fileObj" value="">
										    
										</form>
									
									</div>
								
								</section>
							
							</div>
							
			 			</td>
			 			
			 		</tr>
		 		</tbody>
		 	</table>
		 	
		</div>
		 
		
	</section>
	
</body>

</html>		