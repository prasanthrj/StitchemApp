
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>
	
<!-- 	http://blueimp.github.com/jQuery-File-Upload/     -->
	
	<meta>
	<title> Project Editor  </title>
	
	<link rel="stylesheet" href="<%=request.getContextPath() %>/themes/styles/jscrollpane.css"></link>
	<script type="text/javascript" src="<%=request.getContextPath() %>/scripts/lib/jscrollpane.min.js"></script>
	
	<script type="text/javascript" src="<%=request.getContextPath() %>/scripts/lib/mousewheel.js"></script>
<%-- 	<script type="text/javascript" src="<%=request.getContextPath() %>/scripts/lib/mwheelIntent.js"></script> --%>

	<style type="text/css">
	
	.images-upload-btn {
		cursor: pointer;
	}
	
	</style>
	
	<script type="text/javascript">
	$(document).ready( function() {
		
		// Scrollpane .. 
		$("#left-scroll-cont").jScrollPane({showArrows: true }).data().jsp;
		
		// $("#right-scroll-cont").jScrollPane({showArrows: true }).data().jsp;
		
		//scrollpane.destroy(); 
		
		// ----------------------------------------------------------------------------   
		
		
		
// 		$('#upload-imgs-btn').live('click', function(){ 
// 			submitUploadImagesForm(); 
// 		}); 
		
		
		var uploadForm = $('#upload-imgs-form');
		
		$('.images-upload-btn').click(function(){
			var name = $(this).attr('name');
			/* 
			console.log(uploadForm);
			console.log(uploadForm.find('input[name^=' + name + ']'));
			 */
			uploadForm.find('input[name^=' + name + ']').trigger('click');
			
		});
		
		$('.images-multiple-input').live('change', submitUploadImagesForm);
		
	});
	
	function submitUploadImagesForm(event){
		/* 
		console.log(this);
		console.log(event.target.files);
		 */
// 		var element = $(this);
// 		var files = event.target.files;
		
// 		var name = element.attr('name'); 
// 		var formHtml = '<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">';
		
// 		if ( files ){ 
// 			for(var i = 0; i < files.length ; i++) {  
// 				var file = files[i]; 
// 				formHtml += '<input type="file" name="' + name + '[' + i + '].fileObj" value="" />'; 
// 			} 
// 		} 
		
		var uploadForm = $('#upload-imgs-form');
		
// 		uploadForm.html(formHtml); 
		
// 		var inputs = uploadForm.find('input[type=file]'); 
// 		for(var i = 0; i < inputs.length ; i++) { 
// 			$(inputs[i]).val(files[i]);			
// 		} 
		
		uploadForm.trigger('submit');
 		
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
	
	
	</script>
	
</head>

<body>

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
								 		<label class="gray-666-text float-right"> <span class="gray-333-text bold"> w : </span> <s:property value="project.layout.width" /> px (fixed) <span class="gray-333-text bold"> X </span> <span class="gray-333-text bold"> h : </span> <s:property value="project.layout.height" /> px (min) </label>
								 		<label class="gray-666-text float-left clear italic"> You can do bulk upload and preview the uploaded images .. </label>
								 	</div>
								 	
									<section id="screen-images-cont" class="collapsible-section float-left clear margin-5px">
										
										<ul class="inline-list clear" id="">
											<s:iterator value="screenImages" var="screenImage">
												<li class="float-left margin-5px padding-5px image-li">
													
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
											
											<li class="float-left margin-5px padding-5px image-li">
									     		<div class="page-img-thumb-cont" style="border-bottom: 1px solid #cccccc;">
								     				<img class="float-left page-img-thumbnail images-upload-btn" alt="Add more Images" src="<%= request.getContextPath() %>/themes/images/upload_images.png" name="screenImages" />
									     		</div>
											</li>
											
										</ul>
					 														
									
									</section>
									
									<div class="clear margin-5px" style="border-top: 1px dotted #CCCCCC; padding-top: 5px;">
								 		<label class="gray-333-text bold float-left"> The Application Headers </label>
								 		<label class="gray-666-text float-right"> <span class="gray-333-text bold"> w : </span> <s:property value="project.layout.width" /> px (fixed) <span class="gray-333-text bold"> X </span> <span class="gray-333-text bold"> h : </span> Your choice </label>
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
											
											<li class="float-left margin-5px padding-5px image-li">
									     		<div class="page-img-thumb-cont" style="border-bottom: 1px solid #cccccc;">
								     				<img class="float-left page-img-thumbnail images-upload-btn" alt="Add more Images" src="<%= request.getContextPath() %>/themes/images/upload_images_header_footer.png" name="headerImages"/>
									     		</div>
											</li>
											
										</ul>
										
									</section>
									
									<div class="clear margin-5px" style="border-top: 1px dotted #CCCCCC; padding-top: 5px;">
								 		<label class="gray-333-text bold float-left"> The Application Footers </label>
								 		<label class="gray-666-text float-right"> <span class="gray-333-text bold"> w : </span> <s:property value="project.layout.width" /> px (fixed) <span class="gray-333-text bold"> X </span> <span class="gray-333-text bold"> h : </span> Your choice </label>
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
											
											<li class="float-left margin-5px padding-5px image-li">
									     		<div class="page-img-thumb-cont" style="border-bottom: 1px solid #cccccc;">
								     				<img class="float-left page-img-thumbnail images-upload-btn" alt="Add more Images" src="<%= request.getContextPath() %>/themes/images/upload_images_header_footer.png" name="footerImages"/>
									     		</div>
											</li>
											
										</ul>
									
									</section>
										
											
														
														
									 	
	<%-- 									<section id="header-images-cont" class="collapsible-section float-left clear padding-5px margin-5px">				 --%>
											
											
	<!-- 										<ul> -->
	<!-- 					 						<li> -->
	<!-- 					 							<input type="file" class="inp-box-long" name="headerImages[0].fileObj" value="" placeholder="header images"> -->
	<!-- 					 							<input type="hidden" name="headerImages[0].imageType" value="Header"> -->
	<!-- 					 						</li> -->
	<!-- 					 						<li> -->
	<!-- 					 							<input type="file" class="inp-box-long" name="headerImages[1].fileObj" value="" placeholder="header images"> -->
	<!-- 					 							<input type="hidden" name="headerImages[1].imageType" value="Header"> -->
	<!-- 					 						</li> -->
	<!-- 					 					</ul>		 -->
														
	<%-- 									</section>				 --%>
														
														
														
											
											
										<!-- ----------------------------------------------------------------- -->				
														
	<!-- 								 	<div class="btn-cont float-right clear"> -->
	<!-- 								    	<input type="submit" name="" value="Upload" class="btn" id="submit-project-btn"> -->
	<!-- 								    	<a class="float-left btn" href="javascript:void(0);" id="upload-imgs-btn"> Upload </a> -->
	<!-- 								    </div> -->
									
									<div style="display: none;">
<!-- 									<div> -->
										<form action="<%= request.getContextPath() %>/project/build/upload_images" method="post" id="upload-imgs-form" enctype="multipart/form-data">
									 		
									 		<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
									 		
	<!-- 									    <input type="file" multiple class="inp-box-long images-multiple-input" name="screenImages" value="" placeholder="background images" > -->
	<!-- 									    <input type="file" multiple class="inp-box-long images-multiple-input" name="headerImages" value="" placeholder="background images" > -->
	<!-- 									    <input type="file" multiple class="inp-box-long images-multiple-input" name="footerImages" value="" placeholder="background images" > -->
										    
										    <input type=file multiple class="inp-box-long images-multiple-input" name="screenImages.fileObj" value="" placeholder="background images" >
										    <input type=file multiple class="inp-box-long images-multiple-input" name="headerImages.fileObj" value="" placeholder="background images" >
										    <input type=file multiple class="inp-box-long images-multiple-input" name="footerImages.fileObj" value="" placeholder="background images" >
										    
										</form>
									</div>
								
								</section>
							
							</div>
							
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