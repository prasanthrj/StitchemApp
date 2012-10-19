
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> Admin Home </title>
	
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/themes/admin.css" media="screen"/>
	
	<script type="text/javascript" >
	
	$(document).ready( function() {
		
		/* Window resize related ... */
		adjustToWindowDimentions(); 
		
		$(window).resize(function() {
			adjustToWindowDimentions(); 
		});
		
		
		// Tabs 
		
		$('#admin-tabs-list').customTabs();
		
		// fancybox .. 
		
		$('.fancy-box-link').fancybox({
	        'opacity'		: true,
			'scrolling'		: 'no',
			'titleShow'		: false,
			'onClosed'		: function() {
			    $(".msg-cont").hide();
			}
		});
		
		
		$('#newTagForm').ajaxForm({
			beforeSubmit : function(){
				
			},
			success : function(){
				window.location.reload(true);
			},
			complete : function(){
				$.fancybox.close();
			}
		});
		
		$('.deleteTagForm').ajaxForm({
			beforeSubmit : function(){
				
			},
			success : function(){
				window.location.reload(true);
			},
			complete : function(){
				$.fancybox.close();
			}
		});
		
		$('.delete-tag-link').live('click', function(){
			$(this).closest('form').trigger('submit');
		});
		
	});
	
	
	function deleteTag( projectPkey ) {

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
		<div id="page-title-cont" class="float-fix">
			<label class="page-title"> <s:property value="loggedInUser.fullName"/> </label>		
		</div>
	</div>
	
	<div class="float-fix">
		<ul id="admin-tabs-list" class="tabs-list">
			<li class="tab" id="projects">
				<a href="javascript:void(0);" class="bold"> Projects </a>
			</li>
			<li class="tab sel" id="tags">
				<a href="javascript:void(0);" class="bold"> Tags </a>
			</li>
		</ul>
	</div>
		
	<div id="main-cont"> 
	
		<div id="tabs-body">
			
			<div id="projects-tab" class="float-fix">
				
				<div class="margin-5px">
					<h2 class="sub-title bold float-left"> Projects to Approve </h2>
				</div>
			
				<table class="admin-table">
					<thead>
						<tr>
							<td> <label> # </label> </td>
							<td> <label> preview </label> </td>
							<td> <label> author </label> </td>
							<td> <label> updated on </label> </td>
							<td> <label> options </label> </td>
						</tr>					
					</thead>
					<tbody>
						<s:iterator value="projects" var="project">
							<tr>
								<td>
									<s:property value="%{#project.pkey}" />
								</td>
								<td>
									<a class="thumb" href="<%= request.getContextPath() %>/project/view?project.pkey=<s:property value="%{#project.pkey}" />"> 
										<s:if test="%{#project.layout.landingPage.screenImage.pkey != null}">
					 						<img class="" alt="<s:property value="%{#project.layout.landingPage.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#project.layout.landingPage.screenImage.pkey}" />">
					 					</s:if>
					 					<s:else>
					 						<s:property value="%{#project.title}" />
					 					</s:else>
				 					</a>
								</td>
								<td>
									<a href="<%= request.getContextPath() %>/user/profile?user.pkey=<s:property value="%{#project.publisher.pkey}" />">
										<s:property value="%{#project.publisher.username}" />
									</a>
								</td>
								<td>
									<s:property value="%{#project.createdOn}" />
								</td>
								<td>
									<a class="no-border bold margin-5px" href="<%= request.getContextPath() %>/admin/project_approve?project.pkey=<s:property value="%{#project.pkey}" />"> approve </a>
									<a class="no-border bold margin-5px" href="<%= request.getContextPath() %>/admin/project_reject?project.pkey=<s:property value="%{#project.pkey}" />"> reject </a>
								</td>
							</tr>
						</s:iterator>
					</tbody>
				</table>
				
			</div>
			
			<div id="tags-tab" class="float-fix">
			
				<div class="margin-5px">
					<h2 class="sub-title bold float-left"> Tags List </h2>
					<a href="#add-new-tag-popup" id="add-tag-link" class="fancy-box-link bold float-right margin-5px"> add tag </a>				
				</div>
			
				<table class="admin-table">
					<thead>
						<tr>
							<td> <label> # </label> </td>
							<td> <label> title </label> </td>
							<td> <label> description </label> </td>
							<td> <label> no. of projects </label> </td>
							<td> <label> updated on </label> </td>
							<td> <label> options </label> </td>
						</tr>					
					</thead>
					<tbody>
						<s:iterator value="tags" var="tag">
							<tr>
								<td>
									<s:property value="%{#tag.pkey}" />
								</td>
								<td>
									<s:property value="%{#tag.title}" />
								</td>
								<td>
									<s:property value="%{#tag.description}" />
								</td>
								<td>
									<s:property value="%{#tag.count}" />
								</td>
								<td>
<%-- 									<s:property value="%{#tag.updatedOn}" /> --%>
										<s:property value="%{#tag.createdOn}" />
								</td>
								<td>
									<a class="no-border bold float-left edit-icon" href="javascript:void(0);">&nbsp;</a>
									<form action="<%= request.getContextPath() %>/admin/tag_delete" class="deleteTagForm float-left" method="post">
										<input type="hidden" name="tag.pkey" value="<s:property value="%{#tag.pkey}" />" />
										
										<a class="no-border bold delete-tag-link bin-icon " href="javascript:void(0);">&nbsp;</a>
									</form>
								</td>
							</tr>
						</s:iterator>
					</tbody>
				</table>
				
				
			</div>
			
		</div>
		
	
	</div>   
		
	<section class="pop-ups-cont">
	
		
		<!-- Project Delete pop-up -->
		
		<div id="add-new-tag-popup" class="pop-up">
			<form id="newTagForm" action="<%= request.getContextPath() %>/admin/tag_save" method="post">
						
				<input type="hidden" name="tag.pkey" value="" id="tag-pkey">
				
				<div class="pu-header float-fix">
					<label class="pu-title"> Tag </label>
				</div>
				<div class="pu-body float-fix">
					<div class="msg-cont">
					
					</div>
					<div class="pu-content">
						<ul>
							<li>
								<label>Title</label>
								<input type="text" name="tag.title" class="float-left">
							</li>
							<li>
								<label>Description</label>
								<textarea name="tag.description" > </textarea>
							</li>
						
						</ul>
					</div>
				</div>
				
				<div class="pu-footer">
					<div class="btn-cont">
						<input type="button" value="Cancel" id="" class="close-pop-up btn">
						<input type="submit" value="Save" id="" class="btn btn-yellow" name="Save">
					</div>
				</div>
				
			</form>
		</div>
	
	</section>
	
</body>

</html>		