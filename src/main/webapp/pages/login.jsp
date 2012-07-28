
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>
	
	<title> Login </title>
	
	<script type="text/javascript">
	$(document).ready( function() {
	
		
	});
	</script>
	
</head>

<body>

	<!-- Body Content -->
	<section class="float-left clear full-width" id="body-content">
	
		<div id="body-table-cont" >
			 
						 
			<!-- Sign In Container -->
		
			<div id="sign-in-cont" class="float-left margin-5px" style="min-width: 400px;">
				<div class="pu-header float-left clear ">
					<label class="pu-title float-left"> Sign In </label>
				</div>
				<div class="pu-body float-left clear">
					<div class="msg-cont float-left clear">
					
					</div>
					<div class="pu-content float-left clear">
						<form id="loginForm" action="<%= request.getContextPath() %>/j_spring_security_check" method="post">
							<ul id="signin-list">
								<li>
									<label class="inp-label">User name :</label>
									<input type="text" name="j_username" value="" placeholder="username">
								</li>
								<li>
									<label class="inp-label">Password :</label>
									<input type="password" name="j_password" value="" placeholder="password">
								</li>
								
								<li class="padding-5px">
									<label class="inp-label"></label>
									<input type="submit" value="Sign In" name="signin" class="btn float-right">
								</li>
							</ul>
						</form>
					</div>
				</div>
				<div class="pu-footer float-left clear">
					<label class="inp-label">Login with ...</label>
					<div class="btn-cont">
						
					</div>
				</div>
			</div>
			
					
			<!-- Join now Container -->
			
			<div id="join-now-popup" class="float-right margin-5px" style="min-width: 400px;">
				<div class="pu-header float-left clear ">
					<label class="pu-title float-left"> Join Now </label>
				</div>
				<div class="pu-body float-left clear">
					<div class="msg-cont float-left clear">
					
					</div>
					<div class="pu-content float-left clear">
						<form action="<%= request.getContextPath() %>/user/register" method="post">
							<ul id="signin-list">
								<li>
									<label class="inp-label">User name :</label>
									<input type="text" name="user.username" value="" placeholder="username">
								</li>
								<li>
									<label class="inp-label">Password :</label>
									<input type="password" name="user.password" value="" placeholder="password">
								</li>
								<li>
									<label class="inp-label">Confirm Password :</label>
									<input type="password" name="confirm_password" value="" placeholder="confirm username">
								</li>
								<li>
									<label class="inp-label">Full Name :</label>
									<input type="text" name="user.fullName" value="" placeholder="your full name">
								</li>
								<li>
									<label class="inp-label">E-mail Id :</label>
									<input type="email" name="user.emailId" value="" placeholder="your email-id">
								</li>
								
								<li class="padding-5px">
									<label class="inp-label"></label>
									<input type="submit" value="Join Now" name="join now" class="btn float-right">
								</li>
							</ul>
						</form>
					</div>
				</div>
			</div>
			
			 
		</div>
	</section>
	
</body>

</html>		