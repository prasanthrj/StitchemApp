
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="auth" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE HTML>
<html>

<head>
	<title> Account Recovery </title>
	
	<style type="text/css">
	
	#passwd-reset-cont {
		margin: 0 auto;
		width: 640px;
	}
	
	#reset-pswd-list {
		margin: 20px auto !important;
		width: 442px;
	}
	
	#reset-pswd-list li {
		overflow: hidden;
	}
	
	#reset-pswd-list input {
		width: 430px;
		height: 42px;
		font-size: 16px;
		margin: 4px 0;
	}
	
	#reset-pswd-list input[type=submit] {
		width: 440px;
	}
	
	#reset-msg-cont {
		border: none;
		border-bottom: 1px solid #CCCCCC;
		padding-bottom: 10px;
		background: none;
		height: auto;
		text-align: center;
	}
	
	#reset-msg-cont p {
		color: #333333;
	    display: block;
	    float: none;
	    margin: 10px;
	    font-weight: bold;
	}
	
	#reset-msg-cont p.green {
		color: green;
	}
	
	</style>
	
	<script type="text/javascript" >
	$(document).ready( function() {
		
		/* Window resize related ... */
		
		adjustToWindowDimentions(); 
		
		$(window).resize(function() {
			adjustToWindowDimentions(); 
		});
		
		$('#passwd-reset-form').ajaxForm({
			type: "POST",
			beforeSubmit : function() {
				$('body').css({	'cursor': 'progress' });
			},
			success : function(data) {
				$('body').css({	'cursor': 'auto' });
				if(data && data.messageBean) {
					var msg = data.messageBean;
					if(msg.messageType == 'status') {
						var topCont = $('#reset-msg-cont');
						var newHtml = '<p class="title green"> Your password is reset and a mail was sent to your EmailId </p>';
						newHtml += '<p>You will now be re-directed to Home ... </p>';
						
						topCont.html(newHtml);
						setTimeout(function() {
							window.location.href = 'home';
						}, 2500);
						
					} else if(msg.messageType == 'error') {
						
					}
				} 
			},
			complete : function(data) {}
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
			<label class="page-title"> Account Recovery </label>
		</div>
	</div>
	
	<div id="main-cont" class="float-fix">

		<div id="passwd-reset-cont" class="float-fix">
			<div id="reset-msg-cont" class="float-fix">
				<p class="title"> Yes, I forgot my password </p>
				<p> Please reset my password and send it to my email below ... </p>
			</div>
			<form action="<%= request.getContextPath() %>/user/reset_passwd" id="passwd-reset-form" method="post">
				<ul id="reset-pswd-list">
					<li>
						<input type="email" class="mandatory emailId" name="user.emailId" placeholder="email-id">
					</li>
					<li class="padding-5px">
						<input type="submit" value="Reset My Password" name="reset_password" class="btn btn-yellow" style="width: 442px;">
					</li>
				</ul>
			</form>
		</div>
		
	</div>
	
</body>
</html>
		