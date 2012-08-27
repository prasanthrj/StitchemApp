<!-- Project Publish pop-up -->
		
<div id="project-publish-popup" class="pop-up">
		
	<div class="float-fix">
		<div class="msg-cont" style="display: none;">
		
		</div>
		<div class="pu-content">
			<form id="projectPublishForm" class="float-fix" 
				action="<%= request.getContextPath() %>/publish/manage_details" method="post">
		
				<input type="hidden" name="project.pkey" value="<s:property value="project.pkey" />">
				<input type="hidden" name="publishDetails.pkey" value="<s:property value="publishDetails.pkey" />">
				
				<div class="float-fix">
					<label class="pu-title margin-5px"> Share your pattern </label>

					<div id="publish-visibility" class="float-fix float-right">
						<input type="radio" name="isPublic" value="true" id="visible-public" checked="checked" class="isPublic">
						<label for="visible-public">Public</label>
						<input type="radio" name="isPublic" value="false" id="visible-private" class="isPublic">
						<label for="visible-private">Private</label>
					</div>
				
				</div>
				
				<div class="float-fix">
					<textarea name="project.description" rows="" cols="80" class="inp-box inner-shadow" placeholder="Project description"
						style=" margin: 3px; margin-top: 10px;" > <s:property value="project.description"/> </textarea>
				</div>
				
				<div id="publish-contacts-cont" class="float-fix">
				
					<label class="clear gray-999-text" style="float: none; display: block;"> people you are sharing with : </label>
				 	<ul class="clear" id="app-users-list">
				 		<s:iterator value="appUsers" var="appUser" status="idx">
				 			<li>
<!-- 				 				<s:if test="%{#appUser.pkey != null && #appUser.name != '' }"> -->
<!-- 				 					<label><s:property value="%{#appUser.name}" /></label> -->
<!-- 				 				</s:if> -->
<!-- 				 				<s:else> -->
			 						<label><s:property value="%{#appUser.emailId}" /></label>
<!-- 				 				</s:else> -->

								<s:if test="%{#appUser.isPublisher != true }">
				 					<a href="javascript:void(0);" class="bin-icon float-right" ></a>
				 				</s:if>
				 				<s:else>
				 					<span class="float-right"> Yourself </span>
				 				</s:else>
				 				
				 				<input type="hidden" name="appUsers[<s:property value="%{#idx.index}" />].emailId" value="<s:property value="%{#appUser.emailId}" />">
				 				<input type="hidden" name="appUsers[<s:property value="%{#idx.index}" />].pkey" value="<s:property value="%{#appUser.pkey}" />">
				 			</li>
					    </s:iterator>
				 	</ul>
				
					<div class="" style="margin: 4px 0;">
						<input type="text" class="inp-box inner-shadow " placeholder="add people email-ids" id="add-app-user-input">
<!-- 						<a id="add-app-user-btn" href="javascript:void(0);"> + Add </a> -->
					</div>
			
				</div>
				
			</form>
		</div>
	</div>
	<div class="pu-footer float-fix">
		<div class="btn-cont float-right no-margin no-padding">
			<input type="button" value="Publish Project" id="publish-proj-btn" class="btn btn-yellow">
		</div>
	</div>

</div>

<script type="text/javascript">
$(document).ready( function() {
	
	var projectPublishPopUp = $('#project-publish-popup');
	
	var appUserInput = $('#add-app-user-input');
	appUserInput.live("keyup", function(event){
		if(event.keyCode == '13'){
			
			event.eventBubble = false;
			
		    if (event.stopPropagation) {   
		    	event.stopPropagation();
		    	event.preventDefault();
		    }

			var appUserHtml = '';
			var appUserEmailId = appUserInput.val();
			if (appUserEmailId) {
				appUserHtml += '<li>';
				appUserHtml += '<label>' + appUserEmailId + '</label>';
				appUserHtml += '<a href="javascript:void(0);" class="bin-icon float-right" ></a>';
				appUserHtml += '<input type="hidden" name="appUsers.emailId" value="' + appUserEmailId + '">';
				appUserHtml += '</li>';
			}
			
			$('#app-users-list').append(appUserHtml);				
			appUserInput.val('');
			
			return false;
		}

	});
	
	$('#app-users-list .bin-icon').live('click', function(){
		$(this).parents('li').remove();	
	});
	
	$('#publish-proj-btn').live('click', function(){
		$('#projectPublishForm').ajaxForm({
			beforeSubmit: function (data){},
			success: function (data){
				// re load the publish details 
			},
			complete: function(){
				$.fancybox.close();
			}
		}).trigger('submit');
	});
	
});
</script>