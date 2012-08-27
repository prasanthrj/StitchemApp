<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> Project View </title>
	
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
	
	function loadProjectDimensions(select) {
		var device = $(select).val();
		
		var layoutWidth = $('#layout-width');
		var layoutHeight = $('#layout-height');
		
		switch (device) {
			case 'AndroidMobile':
				layoutWidth.attr('value', 480);
				layoutHeight.attr('value', 800);
				break;
			case 'AndroidTab':
				layoutWidth.attr('value', 1280);
				layoutHeight.attr('value', 800);
				break;
			case 'Iphone3':
				layoutWidth.attr('value', 320);
				layoutHeight.attr('value', 480);
				break;
			case 'Iphone4':
				layoutWidth.attr('value', 640);
				layoutHeight.attr('value', 960);
				break;
			case 'Ipad':
				layoutWidth.attr('value', 1024);
				layoutHeight.attr('value', 768);
				break;
			case 'Webapp':
				layoutWidth.attr('value', 1024);
				layoutHeight.attr('value', 900);
				break;
			case 'Custom':
				layoutWidth.attr('value', '');
				layoutHeight.attr('value', '');
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
		
		<form action="<%= request.getContextPath() %>/project/save" method="post" id="new-post-form">
		
			<div id="project-settings-cont" class="">
			
		 		<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
		 		<s:if test="%{#loggedInUser.emailId != null}">
		 			<input type="hidden" placeholder="will be used for account creation" class="mandatory emailid" name="user.emailId" value="<s:property value="loggedInUser.emailId"/>">
		 		</s:if>
		 		<s:else>
		 			<input type="hidden" placeholder="will be used for account creation" class="mandatory emailid" name="user.emailId" value="<s:property value="user.emailId"/>">
		 		</s:else>
		 		
		 		<ul id="project-settings-list">
		 			<li>
		 				<label>title :</label>
		 				<input type="text" class="mandatory" name="project.title" value="<s:property value="project.title" />" placeholder="Project title">
		 			</li>
		 			<li>
		 				<label>description :</label>
		 				<textarea class="mandatory" name="project.description" placeholder="Project description" style="height: 100px;"><s:property value="project.description" /></textarea>
		 			</li>
		 			<li>
		 				<label> pattern category </label>
						<input type="text" placeholder="eg. SignUps" class="mandatory" name="project.tags[0].title" value="<s:property value="project.tags[0].title" />" id="tags-autocomplete">
					</li>
		 			<li>
		 				<label>intended device :</label>
		 				<select name="project.projectType" class="" id="project-type-select" onchange="loadProjectDimensions(this);">
		 					<option value="AndroidMobile"> Android Mobile </option>
		 					<option value="AndroidTab"> Android Tab </option>
		 					<option value="Iphone3"> Iphone 3 Mobile </option>
		 					<option value="Iphone4"> Iphone 4 Mobile </option>
		 					<option value="Ipad"> Ipad </option>
		 					<option value="Webapp"> Web Application </option>
		 					<option value="Custom"> Custom Application </option>
		 				</select>
		 			</li>
		 			<li>
						<label>dimensions :</label>		 				
	 					<div class="float-left">
							<input placeholder="in pixels" id="layout-width" type="text" value="<s:property value="layout.width" />" name="layout.width" class="clear float-left" style="width: 138px;">					 				
	 					</div>
	 					<div class="float-left" style="margin-left: 8px;">
							<input placeholder="in pixels" id="layout-height"  type="text" value="<s:property value="layout.height" />" name="layout.height" class="clear float-left" style="width: 138px;">					 				
	 					</div>
		 			</li>
		 			
		 			<li>
		 				<label>oreintation :</label>
	 					<select class="" name="layout.orientation" id="orientation-select">
	 						<option value="none"> -- default --</option>
	 						<option value="vertical"> vertical </option>
	 						<option value="horizontal"> horizontal </option>
	 						<option value="both"> both </option>
	 					</select>
		 			</li>
		 			
		 		</ul>

			</div>
			
			<div id="" class="float-left">
				
			</div>
			
			<div class="float-fix" style="width: 160px; margin: 40px auto 0;">
				<input type="submit" value="save" class="btn btn-yellow">
			</div>
			
		</form>
		
	</div>

	<section class="pop-ups-cont">


	</section>
	
	
</body>

</html>		

