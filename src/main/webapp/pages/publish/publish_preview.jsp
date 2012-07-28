
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE HTML>
<html>

<head>

	<title> Project Preview </title>
	
	<script type="text/javascript">
	
	var contextPath = '<%= request.getContextPath() %>';
	
	$(document).ready( function() {
	
		$('img').each(function(){
			var image = $(this);
			
			var src = contextPath + image.attr('src');
			image.attr('src', src);
			
		});
		
	});
	
	</script>
	
</head>

<body lang="en">

	<%= request.getAttribute("docToPublish")  %>
	
</body>

</html>