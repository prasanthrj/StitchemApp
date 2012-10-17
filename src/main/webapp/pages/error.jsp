
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>
	<title> Oops !!! </title>
	
	<style type="text/css">
	
	#global-error-cont {
		margin: 10px auto;
		width: 600px;
	}
	
	#global-error-cont h1 {
		font-size: 36px;
	    font-weight: bold;
	    letter-spacing: -2px;
	    line-height: 40px;
	    float: left;
	    clear: both;
	    min-width: 400px;
	}
	
	#global-error-cont img {
		float: right;
		margin: 5px 25px 0 0;
	}
	
	</style>
	
	<script type="text/javascript" >
	$(document).ready( function() {
		
		/* Window resize related ... */
		
		adjustToWindowDimentions(); 
		
		$(window).resize(function() {
			adjustToWindowDimentions(); 
		});
		
		
	});
	
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
			<label class="page-title"> Ooops </label>
		</div>
	</div>
	
	<div id="main-cont" class="float-fix">
		<div id="global-error-cont" class="float-fix">
			<h1> Whoops, </h1>
			<h1> Something's broken !  </h1>
			
			<img alt="Oops" src="<%= request.getContextPath() %>/themes/images/error_broken.png">
		
			<div class="float-left" style="margin-top: 220px;">
	        	<input type="button" class="btn btn-yellow" value="Go Back" onClick="history.go(-1)">
			</div>
		</div>
	</div>
	
</body>
</html>
		