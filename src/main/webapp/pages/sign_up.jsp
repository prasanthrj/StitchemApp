
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> Register </title>
	
	<style type="text/css">
	
	#ext-signup {
		border: none;
		border-bottom: 1px solid #CCCCCC;
		padding-bottom: 10px;
		background: none;
		height: auto;
		text-align: center;
	}
	
	#ext-signup label {
		color: #333333;
	    display: block;
	    float: none;
	    margin: 10px;
	    font-weight: bold;
	}
	
	#ext-signup ul {
		margin: 0 auto !important;
		width: 432px;
	}
	
	#ext-signup li {
		overflow: hidden;
	}
	
	#ext-signup form {
	    border: 3px solid;
	    display: block;
	    text-align: center;
	    height: 36px;
	    margin: 6px;
	    width: 126px;
		
		-webkit-border-radius: 4px;
		-moz-border-radius: 4px;
		border-radius: 4px;
	}
	
	#ext-signup form label {
		color: #999999;
	}
	
	#ext-signup input {
	    float: left;
	    height: 30px;
	    margin: 3px;
	    width: 30px;
	    
	    background-size: 85%; 
	}
	
	#ext-signup form[name=signin_fb] {
		border-color: rgba(73, 130, 182, 0.5);
		
		-webkit-box-shadow: 0px 0px 1px 1px #4A83B7 inset;
		-moz-box-shadow: 0px 0px 1px 1px #4A83B7 inset;
		box-shadow: 0px 0px 1px 1px #4A83B7 inset;
	}
	
	#ext-signup form[name=signin_gg] {
		border-color: rgba(225, 53, 85, 0.5);
		
		-webkit-box-shadow: 0px 0px 1px 1px #E13555 inset;
		-moz-box-shadow: 0px 0px 1px 1px #E13555 inset;
		box-shadow: 0px 0px 1px 1px #E13555 inset;
	}
	
	#ext-signup form[name=signin_tw] {
		border-color: rgba(71, 213, 229, 0.5);
		
		-webkit-box-shadow: 0px 0px 1px 1px #44D5E9 inset;
		-moz-box-shadow: 0px 0px 1px 1px #44D5E9 inset;
		box-shadow: 0px 0px 1px 1px #44D5E9 inset;
	}
	
	</style>
	
	<script type="text/javascript" >
	$(document).ready( function() {
		
		/* Window resize related ... */
		adjustBodyToWindowDimensions();
		$(window).resize(function() {
			adjustBodyToWindowDimensions();
		});
		
		
		
	});
	</script>

</head>

<body>

	<!-- Body Content -->

	<div id="top-cont" class="yellow-bg">
		<div id="page-title-cont" class="float-fix">
			<label class="page-title"> Join Now </label>		
		</div>
	</div>
		
	<div id="main-cont"> 
		<div id="signup-cont" class="float-fix">
			
			<div id="ext-signup" class="float-fix">
				<label class="" >sign up with ...</label>
				
				<ul class="inline-list">
					<li>
						<form name="signin_fb" id="" action="<%= request.getContextPath() %>/login?auth_provider=facebook" method="POST">
					        <input type="hidden" name="scope" value="publish_stream,user_photos,offline_access" />
							<input id="signup-fb" type="submit" value="" name=""/>
							<label>facebook</label>
						</form>
					</li>
					<li>
						<form name="signin_gg" id="" action="<%= request.getContextPath() %>/login?auth_provider=google" method="POST">
							<input id="signup-gg" type="submit" value="" name=""/>
							<label>google</label>
						</form>
					</li>
					<li>
						<form name="signin_tw" id="" action="<%= request.getContextPath() %>/login?auth_provider=twitter" method="POST">
							<input id="signup-tw" type="submit" value="" name=""/>
							<label>twitter</label>
						</form>
					</li>
				</ul>
			</div>
			
			<div id="native-signup-cont">
				<form action="<%= request.getContextPath() %>/user/register" method="post">
						
					<!-- Social Details -->
					<input type="hidden" name="socialDetails.providerId" value="<s:property value="socialDetails.providerId"/>">
					
					<ul id="signup-list">
						<li>
							<input type="text" name="user.fullName" value="<s:property value="socialDetails.displayName"/>" placeholder="name">
						</li>
						<li>
							<input type="email" name="user.emailId" value="<s:property value="socialDetails.emailId"/>" placeholder="email-id">
						</li>
						<li>
							<input type="text" name="user.username" value="" placeholder="username">
						</li>
						<li>
							<input type="password" name="user.password" value="" placeholder="password" class="float-left">
							<input type="password" name="confirm_password" value="" placeholder="confirm password" class="float-right">
						</li>
						
						<li class="padding-5px">
							<input type="submit" value="Join Now" name="join now" class="btn btn-yellow">
						</li>
					</ul>
				</form>
			</div>
			
		</div>
	</div>   
	
	<section class="pop-ups-cont">
	
	</section>
	
</body>

</html>		




