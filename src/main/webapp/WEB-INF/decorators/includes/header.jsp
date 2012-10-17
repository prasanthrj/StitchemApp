
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<script type="text/javascript">

// 	var contextPath = '${pageContext.request.contextPath}';

	var contextPath = '<%= request.getContextPath() %>';
	var loggedInUserName = '<s:property value="loggedInUser.username"/>';

	$(document).ready(function() {
		
		var signInMsgCont = $('#sign-in-cont .msg-cont');
		
		$('#loginForm').ajaxForm({
			type: "POST",
			beforeSubmit : function() {
				$('body').css({	'cursor': 'progress' });
			},
			beforeSend: function (xhr) {
		        xhr.setRequestHeader("X-Ajax-call", "true");
		    },
			complete : function(result) {
				$('body').css({	'cursor': 'auto' });
				if(result && result.responseText) {
					var response = $.parseJSON(result.responseText);
					if(response && response.isAuthenticated) {
						if(response.targetUrl) {
							if(response.targetUrl.indexOf('stitchemapp/home') >= 0) {
								window.location.href = 'user/home';
							} else {
								window.location.href = response.targetUrl;
							}
						}
					} else {
						signInMsgCont.html('<label class="error">Bad Credentials</label>').show('fade');
					}
				} 
			}
		});
		
		$('#loginForm input').bind('focus', function(){
			signInMsgCont.hide('fade');
			this.select();
		});
		
	});
	
</script>
    
<!-- Header -->

<header id="header" class="">

	<div id="header-cont" class="float-fix">
		<div id="logo-cont">
<%-- 			<img src="<%= request.getContextPath() %>/themes/images/logo.png" class="logo"/> --%>
			<label class="title"> <a href="<%= request.getContextPath() %>/home" > Stitch'emapp </a> </label>
		</div>
		<div id="top-nav-cont">
			<ul id="top-nav-list" class="inline-list">
				<auth:authorize ifAnyGranted="ROLE_ANONYMOUS">
					<li>
						<a href="#sign-in-cont" id="login-btn" class="fancy-box-link">login</a>
					</li>
					<li>
						<a href="<%= request.getContextPath() %>/signup" class=""> join now </a>
					</li>
				</auth:authorize>
				<auth:authorize ifNotGranted="ROLE_ANONYMOUS">
					<li>
						<a href="<%= request.getContextPath() %>/user/home" > <s:property value="loggedInUser.fullName"/> </a>
					</li>
					<li>
						<a href="<%= request.getContextPath() %>/j_spring_security_logout" >logout</a>
					</li>
				</auth:authorize>
				<li>
					<label> | </label>
				</li>
				<li>
	               	<a href="<%= request.getContextPath() %>/static/about">about</a>
	            </li>
				<li>
	            	<a href="<%= request.getContextPath() %>/static/contact">contact</a>
				</li>
				<li>
					<a href="javascript:void(0);">blog</a>
				</li>
			</ul>
		</div>
	</div>
	
	<section class="pop-ups-cont" >
	
		<auth:authorize ifAnyGranted="ROLE_ANONYMOUS">
			
			<!-- Sign In Container -->
			<div id="sign-in-cont" class="pop-up">
				<div class="pu-body">
					<div class="msg-cont"></div>
					<div class="pu-content">
						<form id="loginForm" action="<%= request.getContextPath() %>/login/authenticate" method="post">
							<input type="hidden" name="targetUrl" value="<%= request.getRequestURI() %>?<%= request.getQueryString() %>">
							<input id="username-input" type="text" name="j_username" value="" placeholder="Username or Email">
							<input id="password-input" type="password" name="j_password" value="" placeholder="Password">
							<input id="signin-input" type="submit" value="Sign In" name="signin" class="btn btn-yellow">
						</form>
					</div>
					<div style="margin: 5px 42px 30px;">
						<a class="bold" href="<%= request.getContextPath() %>/forgot_password"> Forgot Password ? </a>
					</div>
				</div>
				
				<div id="ext-signin">
					<label>login with ...</label>
					<ul class="inline-list float-right">
						<li>
							<form name="signin_fb" id="" action="<%= request.getContextPath() %>/login?auth_provider=facebook" method="POST">
						        <input type="hidden" name="scope" value="publish_stream,user_photos,offline_access" />
								<input id="signin-fb" type="submit" value="" name=""/>
							</form>
						</li>
						<li>
							<form name="signin_gg" id="" action="<%= request.getContextPath() %>/login?auth_provider=google" method="POST">
								<input id="signin-gg" type="submit" value="" name=""/>
							</form>
						</li>
						<li>
							<form id="signin_tw" id="" action="<%= request.getContextPath() %>/login?auth_provider=twitter" method="POST">
								<input id="signin-tw" type="submit" value="" name=""/>
							</form>
						</li>
					</ul>
				</div>
		
			</div>
		</auth:authorize>
	
	</section>
	
</header>

<!-- Header ends -->

	
	
	