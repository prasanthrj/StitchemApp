
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>

<script type="text/javascript">
$(document).ready( function() {

	
});
</script>


<!-- Body Content -->

<section class="float-left clear full-width" id="body-content">
	<div class="in">
		<div class="page-content">
			
			<div class="page-title-cont">
				<label class="float-left gray-666-text bold" style="padding-top: 3px;"> Showing results for </label>
		 		<h1 class="page-title float-left padding-10px-hor"> "<s:property value="searchForm.searchString" />" </h1>
	 			<a class="share-icon float-right " title="Share" href="#"></a>
	 			<a class="printer-icon float-right" title="Print" href="#"></a>
	 			<a class="download-icon float-right" title="Download" href="#"></a>
		 	</div>
		 	
		 	<label class="italic gray-999-text padding-10px-bot float-right"> Showing results from <span class="bold blue-text"> last one week </span> sorted by <span class="bold blue-text"> Date </span> </label>
		 	
		 	<table id="search-results-table" class="form-table padding-10px-ver">
		 		<tbody>
			 		<tr>
			 			<td class="td-label">
			 				<img alt="" src="themes/images/pin_icon.png" class="padding-10px-bot">
							<label class="float-right clear"> by <a href="#"> milli </a></label>
							<label class="float-right clear"> on <span class="gray-333-text"> Aug 22 </span> </label>			 				
			 			</td>
			 			<td class="td-result">
			 				<h1 class="search-result-title"><a class="sky-blue-text"> A common form of lorem ipsum text reads as follows: </a></h1> 
			 				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et aliquip ex ea commodo consequat. nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
			 				<div class="links-cont margin-5px clear float-left">
			 					<label class="padding-10px-hor gray-333-text">Posted 3 days ago</label> 
			 					<a class="bookmark-icon indent"> Add Bookmark </a> 
			 					<a class="user-icon indent"> subscribe to <span class="blue-text"> milli </span> </a>
			 				</div>
			 			</td>
			 		</tr>
			 		<tr>
			 			<td class="td-label">
			 				<img alt="" src="themes/images/pin_icon.png" class="padding-10px-bot">
							<label class="float-right clear"> by <a href="#"> milli </a></label>
							<label class="float-right clear"> on <span class="gray-333-text"> Aug 22 </span> </label>			 				
			 			</td>
			 			<td class="td-result">
			 				<h1 class="search-result-title"><a class="sky-blue-text"> A common form of lorem ipsum text reads as follows: </a></h1> 
			 				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et aliquip ex ea commodo consequat. nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
			 				<div class="links-cont">
			 					
			 				</div>
			 			</td>
			 		</tr>
			 		<tr>
			 			<td class="td-label">
			 				<img alt="" src="themes/images/pin_icon.png" class="padding-10px-bot">
							<label class="float-right clear"> by <a href="#"> milli </a></label>
							<label class="float-right clear"> on <span class="gray-333-text"> Aug 22 </span> </label>			 				
			 			</td>
			 			<td class="td-result">
			 				<h1 class="search-result-title"><a class="sky-blue-text"> A common form of lorem ipsum text reads as follows: </a></h1> 
			 				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et aliquip ex ea commodo consequat. nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
			 				<div class="links-cont">
			 					
			 				</div>
			 			</td>
			 		</tr>
			 		<tr>
			 			<td class="td-label">
			 				<img alt="" src="themes/images/pin_icon.png" class="padding-10px-bot">
							<label class="float-right clear"> by <a href="#"> milli </a></label>
							<label class="float-right clear"> on <span class="gray-333-text"> Aug 22 </span> </label>			 				
			 			</td>
			 			<td class="td-result">
			 				<h1 class="search-result-title"><a class="sky-blue-text"> A common form of lorem ipsum text reads as follows: </a></h1> 
			 				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et aliquip ex ea commodo consequat. nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
			 				<div class="links-cont">
			 					
			 				</div>
			 			</td>
			 		</tr>
			 		<tr>
			 			<td class="td-label">
			 				<img alt="" src="themes/images/pin_icon.png" class="padding-10px-bot">
							<label class="float-right clear"> by <a href="#"> milli </a></label>
							<label class="float-right clear"> on <span class="gray-333-text"> Aug 22 </span> </label>			 				
			 			</td>
			 			<td class="td-result">
			 				<h1 class="search-result-title"><a class="sky-blue-text"> A common form of lorem ipsum text reads as follows: </a></h1> 
			 				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et aliquip ex ea commodo consequat. nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
			 				<div class="links-cont">
			 					
			 				</div>
			 			</td>
			 		</tr>
			 		<tr>
			 			<td class="td-label">
			 				<img alt="" src="themes/images/pin_icon.png" class="padding-10px-bot">
							<label class="float-right clear"> by <a href="#"> milli </a></label>
							<label class="float-right clear"> on <span class="gray-333-text"> Aug 22 </span> </label>			 				
			 			</td>
			 			<td class="td-result">
			 				<h1 class="search-result-title"><a class="sky-blue-text"> A common form of lorem ipsum text reads as follows: </a></h1> 
			 				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et aliquip ex ea commodo consequat. nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
			 				<div class="links-cont">
			 					
			 				</div>
			 			</td>
			 		</tr>
			 		
			 		<tr>
			 			<td colspan="2" class="padding-10px-top" style="height: 12px; border-bottom: 1px solid #DDDDDD;"></td>
			 		</tr>
		 		</tbody>
		 	</table>
			
		</div>
		
		<div class="right-side-bar">
			
		</div>		 
	</div>
</section>



		