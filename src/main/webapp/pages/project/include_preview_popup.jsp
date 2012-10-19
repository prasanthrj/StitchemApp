

<div id="project-preview-popup" class="pop-up <s:property value="project.projectType"/> <s:property value="layout.orientation"/>">
	<div id="preview-cont" class="">
		<iframe src="" id="preview-iframe"> 
			<p> Oooops ... , your browser currently doesn't support IFrames .. !!!</p>
			<p> Supported browsers: <a href="http://www.opera.com">Opera</a>, <a href="http://www.mozilla.com">Firefox</a>, <a href="http://www.apple.com/safari">Safari</a>, and <a href="http://www.konqueror.org">Konqueror</a>. </p>
		</iframe>
	</div>
</div>

<script type="text/javascript">

function showPreviewInModal(projectPkey, layoutWidth, layoutHeight){
	
	// Check for no-of current pages 
	var noOfPages = $('#pages-list li').length;
	if(!noOfPages || noOfPages == 0) {
		alert('upload Screens and select a landing page !!');
		return;
	}
	
	if (!layoutWidth) layoutWidth = $('#proj-width').val();
	if (!layoutHeight) layoutHeight = $('#proj-height').val();
	
	var previewUrl = '<%=request.getContextPath()%>/publish/preview?project.pkey=' + projectPkey ;
	
	var landingPagePkey = $('#landing-page-pkey').val();
	if(landingPagePkey && landingPagePkey != '')
		previewUrl += '#page-' + landingPagePkey ;
	
	// Fancybox ... 
	var previewCont = $('#preview-cont');
	previewCont.find('iframe').attr('src', previewUrl );
	
	$('#preview-popup-link').trigger('click');	
	
};

</script>