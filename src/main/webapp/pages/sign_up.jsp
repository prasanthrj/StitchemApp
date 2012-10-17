
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>

	<title> Register </title>
	
	<style type="text/css">
	
	/* Register */

	#signup-cont {
		margin: 0 auto;
		width: 640px;
	}
	
	#signup-list {
		margin: 30px auto !important;
		width: 442px;
	}
	
	#signup-list li {
		overflow: hidden;
	}
	
	#signup-list input {
		width: 430px;
		height: 42px;
		font-size: 16px;
		margin: 4px 0;
	}
	
	#signup-list input[type=password] {
		width: 205px;
	}
	
	#signup-list input[type=submit] {
		width: 440px;
	}
	
	#signup-list label {
		font-size: 14px;
	    margin: 8px 16px;
	    min-width: 150px;
	    text-align: right;
	}
	
	#signup-fb {
		background: url("themes/images/fb-light.png") no-repeat scroll center center transparent;
		background-color: rgba(73, 130, 182, 1);
	}
	
	#signup-gg {
		background: url("themes/images/google-light.png") no-repeat scroll center center transparent;
		background-color: rgba(225, 53, 85, 1);
	}
	
	#signup-tw {
		background: url("themes/images/twitter-light.png") no-repeat scroll center center transparent;
		background-color: rgba(71, 213, 229, 1);
	}
	
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
	
	#native-signup-cont {
		position: relative;
		overflow: hidden;
		padding: 10px;
	}
	
	</style>
	
	<script type="text/javascript" >
	$(document).ready( function() {
		
		/* Window resize related ... */
		adjustBodyToWindowDimensions();
		$(window).resize(function() {
			adjustBodyToWindowDimensions();
		});
		
		$('#join-now-btn').live('click', function(){
			var userRegistrationForm = $('#user-registration-form');
			userRegistrationForm.validateForm({
				breakOnError : false,
				failureFunction : function(element){
					$(element).addClass('error');
				},
				successFunction : function(element){
					$(element).removeClass('error');
				},
				onValidForm : function(form){
					var pswd = $('#user-pswd');
					var cnfPswd = $('#user-confirm-pswd');
					if(pswd.val() == cnfPswd.val()) {
						submitRegistrationForm();
					} else {
						pswd.addClass('error');
						cnfPswd.addClass('error');
						showNotificationMsg("error", "Confirm password" );
					}
				}
			});
			
		});
		
		$('#user-registration-form input').bind('focus', function(){ 
			this.select();
		});

	});
	
	// Registration Form .. 
	function submitRegistrationForm() {
		$('#user-registration-form').ajaxForm({
			type: "POST",
			beforeSubmit : function() {
				$('body').css({	'cursor': 'progress' });
			},
			success : function(data) {
				$('body').css({	'cursor': 'auto' });
				if(data && data.messageBean) {
					var msg = data.messageBean;
					if(msg.messageType == 'error') {
						if(msg.message == 'username') {
							showNotificationMsg("error", "We are sorry. this username is already taken !!!", false );
							$('#reg-username').focus().select();
						} else if(msg.message == 'emailid') {
							showNotificationMsg("status", "This emailid is already registered !!!", false );
							$('#reg-emailid').focus().select();
						}
					} else {
						window.location.href = 'user/home';
					}
				} 
			},
			complete : function(data) {}
		}).trigger('submit');
	};
	
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
			
			<div id="native-signup-cont" class="">
			
				<div id="notification-cont" style="display: none;">
					<div id="notification-box" class="error">
						<a href="javascript:void" class="float-left skull-icon-white" id="noification-icon"></a>
						<span class="msg-text"> Something Went Wrong !!! </span>
						<a href="javascript:void(0);" class="float-right close-icon-white" id="noification-close"></a>
					</div>
				</div>
				
			
				<form action="<%= request.getContextPath() %>/user/register" id="user-registration-form" method="post">

					<!-- Social Details -->
					<input type="hidden" name="socialDetails.providerId" value="<s:property value="socialDetails.providerId"/>">
					
					<ul id="signup-list">
						<li>
							<input type="text" class="mandatory" name="user.fullName" value="<s:property value="socialDetails.fullName"/>" placeholder="Full Name">
						</li>
						<li>
							<input type="email" id="reg-emailid" class="mandatory emailId" name="user.emailId" value="<s:property value="socialDetails.emailId"/>" placeholder="email-id">
						</li>
						<li>
							<input type="text" id="reg-username" class="mandatory" name="user.username" value="" placeholder="username">
						</li>
						<li>
							<input type="password" id="user-pswd" name="user.password" value="" placeholder="password" class="mandatory float-left" >
							<input type="password" id="user-confirm-pswd" value="" placeholder="confirm password" class="mandatory float-right">
						</li>
						
						<li class="padding-5px">
							<input type="button" id="join-now-btn" value="Join Now" name="join now" class="btn btn-yellow" style="width: 442px;">
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




