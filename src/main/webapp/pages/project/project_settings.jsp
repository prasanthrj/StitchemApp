<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> Project Configuration </title>
	
	<script type="text/javascript" >
	
	$(document).ready( function() {
		
		/* Window resize related ... */
		adjustToWindowDimentions(); 
		
		$(window).resize(function() {
			adjustToWindowDimentions(); 
		});
		
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
		
		// Setting Project Type 
		var projectType = '${project.projectType}';
		$('#project-type-select').val(projectType).trigger('change');
		
	});
	
	/* Window resize */
	
	function adjustToWindowDimentions(){
		adjustBodyToWindowDimensions();		// body .. 
		
	};
	
	function loadDeviceSpecs(select) {
		var device = $(select).val();
		
		var layoutWidth = $('.layout-width');
		var layoutHeight = $('.layout-height');
		
		var imgBaseUrl = '<%= request.getContextPath() %>/themes/images/devices/';
		var imgElem = $('#proj-img-cont img');
		if(device != 'Custom') {
			var imgUrl = imgBaseUrl + device + '.png';
			imgElem.hide().attr('src', imgUrl).show('fade');
		} else {
			imgElem.hide();	
		}
		
		switch (device) {
			case 'AndroidMobile':
				layoutWidth.text(480);
				layoutHeight.text(800);
				break;
			case 'AndroidTab':
				layoutWidth.text(1280);
				layoutHeight.text(800);
				break;
			case 'IPhone':
				layoutWidth.text(320);
				layoutHeight.text(480);
				break;
			case 'IPad':
				layoutWidth.text(1024);
				layoutHeight.text(768);
				break;
			case 'Webapp':
				layoutWidth.text(1024);
				layoutHeight.text(900);
				break;
			case 'Custom':
				layoutWidth.text('-- ');
				layoutHeight.text('-- ');
				
				break;
			default:
				break;
			
		}
		
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
			<label class="float-right bold gray-999-text margin-5px"> Settings </label>
		</div>
	</div>
	
	<div id="main-cont" class="float-fix">
		
		<form action="<%= request.getContextPath() %>/project/save" method="post" id="new-post-form" >
		
			<div class="project-settings-cont" style="border-right: 1px dotted #CCCCCC; padding: 0 30px 0 0;">
			
		 		<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
	 			<s:if test="%{#loggedInUser.emailId != null}">
		 			<input type="hidden" class="mandatory emailid" name="user.emailId" value="<s:property value="loggedInUser.emailId"/>">
		 		</s:if>
		 		<s:else>
		 			<input type="hidden" class="mandatory emailid" name="user.emailId" value="<s:property value="user.emailId"/>">
		 		</s:else>
		 		
		 		<ul id="project-settings-list">
		 			<li>
		 				<label>Title :</label>
		 				<input type="text" class="mandatory" name="project.title" value="<s:property value="project.title" />" placeholder="Name your project">
		 			</li>
		 			<li>
		 				<label>Description :</label>
		 				<textarea class="mandatory" name="project.description" placeholder="No Stories please" style="height: 100px;"><s:property value="project.description" /></textarea>
		 			</li>
		 			<li>
		 				<label>Pattern category </label>
						<input type="text" placeholder="eg. SignUps" class="mandatory" name="project.tags[0].title" value="<s:property value="project.tags[0].title" />" id="tags-autocomplete">
					</li>
					<li>
						<label class="gray-999-text">Select device on the right..</label>
					</li>
		 		</ul>

			</div>
			
			<div id="proj-img-cont" class="float-left margin-5px">
 				<img alt="" src="<%= request.getContextPath() %>/themes/images/devices/AndroidMobile.png">
 			</div>
			
			<div class="project-settings-cont" style="">
			
				<div class="float-left clear">
	 				<label class="bold" style="">Device :</label>
	 				<select name="project.projectType" class="float-left clear" id="project-type-select" onchange="loadDeviceSpecs(this);">
	 					<option value="IPhone" selected="selected"> IPhone </option>
						<option value="IPad"> IPad </option>
						<option value="AndroidMobile"> Android Mobile </option>
						<option value="AndroidTab"> Android Tab </option>
						<option value="Webapp"> Web Application </option>
						<option value="Custom"> Custom Application </option>
	 				</select>
	 			</div>
	 			
	 			<div id="device-desc-cont" class="float-left clear" style="margin: 30px 0px;">
	 				<p class="gray-999-text" style="max-width: 280px; margin-bottom: 15px;">
						Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 	 				
	 				</p>
	 				<label class="float-left clear normal" style="margin: 0;">Width : <span class="layout-width"> </span>px</label>
	 				<label class="float-left clear normal" style="margin: 0;">Height : <span class="layout-height"> </span>px</label>
	 			</div>
	 			
	 			<div id="proj-dim-cont" class="float-left clear" style="margin: 30px 0px; display: none;">
					<label class="bold ">Dimensions <span class="normal">(px)</span> :</label>	
					
					<div class="float-left clear">
						<div class="float-left">
							<input placeholder="Width" type="text" value="<s:property value="layout.width" />" name="layout.width" class="clear float-left" style="width: 128px;">					 				
	 					</div>
	 					<div class="float-left" style="margin-left: 8px;">
							<input placeholder="Height" type="text" value="<s:property value="layout.height" />" name="layout.height" class="clear float-left" style="width: 128px;">					 				
	 					</div>
					</div>	 				
 					
 					<%-- 
		 			<li>
		 				<label>oreintation :</label>
	 					<select class="" name="layout.orientation" id="orientation-select">
	 						<option value="none"> -- default --</option>
	 						<option value="vertical"> vertical </option>
	 						<option value="horizontal"> horizontal </option>
	 						<option value="both"> both </option>
	 					</select>
		 			</li>
		 			 --%>
		 			 
		 		</div>
		 		
		 		<div class="float-left clear " style="margin: 30px 0px;">
					<input type="submit" value="continue" class="btn btn-yellow">
				</div>
				
			</div>
			
		</form>
		
	</div>

</body>

</html>		

