
<div id="left-scroll-cont" class="float-left"> 
							
	<ul class="float-left clear" id="project-pages-list">
		
		<li class="float-left clear no-margin">
			<s:if test="%{ project.pkey != null && project.pkey != '' }">
				<a class="float-left clear left-nav-bar" href="<%= request.getContextPath() %>/project/edit?project.pkey=<s:property value="project.pkey" />" id="submit-project-btn">
					<span class="float-left clear"> About Project </span>
					<span class="float-left clear info-text"> intro/description </span>
				</a>
			</s:if>
		</li>
		
		<li class="float-left clear no-margin">
			<s:if test="%{ project.pkey != null && project.pkey != '' }">
				<a class="float-left clear left-nav-bar" href="<%= request.getContextPath() %>/project/build/uploader?project.pkey=<s:property value="project.pkey" />" id="">
					<span class="float-left clear"> Manage Images </span>
					<span class="float-left clear info-text"> screens for the project </span>
				</a>
			</s:if>
		</li>
		
			<s:iterator value="pages" var="page">
	    		<li class="float-left clear padding-10px-bot left-nav-bar page-li" onclick="preparePageForEditing(<s:property value="%{#page.pkey}" />, this)" >
	    			<div class="page-img-thumb-cont">	
	    				<img class="float-left page-img-thumbnail" alt="<s:property value="%{#page.screenImage.fileObjFileName}" />" src="<%= request.getContextPath() %>/image/view?project.pkey=<s:property value="project.pkey" />&imageFile.pkey=<s:property value="%{#page.screenImage.pkey}" />">
	     		</div>
	     		
	     		<div class="page-thumb-info-cont">
		     		<label class="margin-5px clear float-left">
		     			<s:property value="%{#page.screenImage.fileObjFileName}" />
		     		</label>
		     		
		     		<ul class="page-thumb-info clear">
		     			
		     			<li class="float-left margin-5px">
		     				<s:if test="%{#page.headerImage == null || #page.headerImage.pkey == '' }">
								<img class="float-left" alt="" src="<%= request.getContextPath() %>/themes/images/icon_add_header_small_nil.png">										
	<!-- 											<label class="padding-5px-left"> No header </label>	 -->
							</s:if>
						</li>
						<li class="float-left margin-5px">
							<s:if test="%{#page.footerImage == null || #page.footerImage.pkey == '' }">
								<img class="float-left" alt="" src="<%= request.getContextPath() %>/themes/images/icon_add_footer_small_nil.png">
	<!-- 											<label class="padding-5px-left"> No footer </label>	 -->
							</s:if>
						</li>
						
						<li class="float-left margin-5px">
							<img class="float-left" alt="" src="<%= request.getContextPath() %>/themes/images/icon_add_hotspot.png" width="16px">
							<label class="padding-5px-left"> <span> 0 </span> </label>										
						</li>
						
						<li class="float-left margin-5px">
							<img class="float-left" alt="" src="<%= request.getContextPath() %>/themes/images/icon_comment.png" width="16px">
							<label class="padding-5px-left"> <span> 0 </span> </label>	
																
						</li>
		     		</ul>
	
		     		<input type="hidden" class="image-pkey" value="<s:property value="%{#page.screenImage.pkey}" />">
		     		<input type="hidden" class="page-pkey" value="<s:property value="%{#page.pkey}" />">
		     	</div>
	     		
	    		</li>
	    </s:iterator> 
	    						    				 			
	</ul>

</div>