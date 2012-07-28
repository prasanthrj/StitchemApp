
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE HTML>
<html>

<head>

<!--   http://localstreamer.posterous.com/javascript-code-snippet-how-to-detect-all-mob  -->
<!--   http://detectmobilebrowsers.com/  -->

	<title> Published for Mobile </title>
	
	<script type="text/javascript">
	
	var contextPath = '<%= request.getContextPath() %>';

	var projectPkey = '<s:property value="project.pkey" />';
	var appUserPkey = '<s:property value="appUser.pkey" />';
	
	$(document).ready( function() {
	
		// Setting the Image clearly .. 
		$('img').each(function(){
			var image = $(this);
			
			var src = contextPath + image.attr('src');
			image.attr('src', src);
			
		});
		
		// Analytics .. 
		
		
	});
		
	</script>
	
	<!-- this has to be below as it needs "contextPath" -->
<%-- 	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/custom-analytics.js"></script> --%>

</head>

<body lang="en">

	<!-- Body Content -->
	
<%-- 	<section> --%>
		
<!-- 		<div data-role="page" > -->
			
<!-- 		</div> -->
		
<%-- 	</section> --%>
		
	<%= request.getAttribute("docToPublish")  %>
	
	
	<s:if test="%{isIframe == true}">
		<script type="text/javascript">

		
		</script>
	</s:if>
	
		
</body>

	
</html>		