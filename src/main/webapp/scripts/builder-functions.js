
/* jcarousel related */

var pagesListCarousel;

function pagesListCarouselInitCallback(carousel){
	pagesListCarousel = carousel;
};

function addPageElementToPageslListCarousel(element){
	if(!pagesListCarousel){
		var carouselPagesList = $('#pages-list');
		carouselPagesList.html(element);
		carouselPagesList.jcarousel({
			initCallback : pagesListCarouselInitCallback,
            reloadCallback : pagesListCarouselInitCallback
		});
	} else {
		pagesListCarousel.addAndAnimate(element);
		pagesListCarousel.scroll(pagesListCarousel.size());
	}
};

function removePageElementFromPageslListCarousel(elementIndex){
	pagesListCarousel.removeAndAnimate(elementIndex);
	pagesListCarousel.scroll(1);
};



/* Ajax FileUpload Related .. */ 

var filesArray = [];
var filesArrayIndex = 0;

var tempElementPrefix = 'car-page-temp-';

var screenImagesUploader = function(event, element){
	preventEventDefaults(event);
	
	var projectPkey = $('#proj-pkey').val();
	
	if(event.type == 'change') {
		filesArray = element.files || [];	// Multiple file select
	} else {
		filesArray = event.dataTransfer.files || [];	// Drag drop 
	}
	
	filesArrayIndex = 0;
	
	// Prepare Screens upload ..
	var carouselPagesList = $('#pages-list');
	for (var i = 0; i < filesArray.length; i++) {
		var tempObj = {
			'elementId' : tempElementPrefix + i,
			'fileName' : filesArray[i].name
		}
		
		var tempLiHtml = new EJS({url: contextPath + '/pages/project/ejs/temp_screen_thumb_li.ejs'}).render(tempObj);
		addPageElementToPageslListCarousel(tempLiHtml);
	};
	
	$('#no-pages-cont').hide();
	
	// Setting the locals 
	var imageFileType = "screen";
	var noOfFiles = filesArray.length;
	var pagePkeys = new Array();
	
	var currUploadElement = $('#' + tempElementPrefix + filesArrayIndex );
	
	var onStart = function(event){};
	
	var progress = function(event){
		var percent = Math.round((event.loaded * 100) / event.total);
		currUploadElement.find('.percent').html(percent + ' %');
	};
	
	var onError = function(event){
		currUploadElement.remove();
		showNotificationMsg('error', "upload Failed");
	};
	
	var onAbort = function(event){
		currUploadElement.remove();
		showNotificationMsg('error', "upload Aborted");
	};
	
	var onLoad = function(event){};

	var onComplete = function(){	// this is oHXR ... 
		if ( this.readyState == 4 && this.status == 200 ) {
            	
        	var jsonResponse = $.parseJSON(this.responseText);
        	var page = jsonResponse.page;
        	
        	pagePkeys.push(page.pkey);
        	
        	// Load the current page 
        	currUploadElement.html('');
        	currUploadElement.attr('id', 'car-page-' + page.pkey);
        	
        	var pageLiHtml = new EJS({url: contextPath + '/pages/project/ejs/screen_thumb_li.ejs'}).render(page);
			
        	currUploadElement.html(pageLiHtml);
        	currUploadElement.find('input[type=radio]').customInput();
        	
        	// update the page in list
        	var optionHtml = '<option class="page-' + page.pkey + '-title auto-ellipses" value="' + page.pkey + '">';
        	optionHtml += page.title;
        	optionHtml += '</option>';
        	$('.new-event-div select[name*=toPage]').append(optionHtml);
        	
        	
        	// Upload next file ..
        	filesArrayIndex++;
        	currUploadElement = $('#' + tempElementPrefix + filesArrayIndex );
        	
        	if( noOfFiles > 0 && noOfFiles != filesArrayIndex) {
        		uploadFile(filesArray[filesArrayIndex], projectPkey, onStart, progress, onError, onAbort, onLoad, onComplete, imageFileType); 
        	} else {
        		var pagePkeyToLoad = pagePkeys[0];
        		$('#car-page-' + pagePkeyToLoad + ' .page-thumb-image-cont').check();
        	}
        	
        	showNotificationMsg( 'status', page.screenImage.title + " has been successfully uploaded !!!" );
            
        } else {
        	showNotificationMsg( 'error', this.status );
        }
	};
	
	// Uploading ..
	if( noOfFiles > 0 && noOfFiles != filesArrayIndex) {
		uploadFile(filesArray[filesArrayIndex], projectPkey, onStart, progress, onError, onAbort, onLoad, onComplete, imageFileType); 
	} 
	
};

function prepareFileDropUpload(droppableElemId){
	var element = document.getElementById( droppableElemId );
	element.ondragenter = function(event) { preventEventDefaults(event); };
	element.ondragover = function(event) { preventEventDefaults(event); };
    element.ondrop = screenImagesUploader;
}


/* Regular files / supporting images uploader  */

var suppImgContOf = {
	'screen' : '',
	'header' : 'page-header-cont',
	'footer' : 'page-footer-cont',
	'leftNavBar' : 'page-leftNav-cont',
	'rightNavBar' : 'page-rightNav-cont'
};

var regularfileUploader = function(event, element, imageFileType) {
	preventEventDefaults(event);
	
	var projectPkey = $('#proj-pkey').val();
	
	if(event.type == "change") {
		filesArray = element.files || [];	// Multiple file select
	} else {
		filesArray = event.dataTransfer.files || [];	// Drag drop 
	}
	
	filesArrayIndex = 0;
	
	// Setting the locals 
	var noOfFiles = filesArray.length;
	var currfile = filesArray[filesArrayIndex];
	
	var imagePkeys = new Array();
	
	var onStart = function(event) {};
	
	var progress = function(event) {
		showNotificationMsg( 'status', currfile.name );
	};
	
	var onError = function(event) {
		showNotificationMsg( 'error', currfile.name );
	};
	
	var onAbort = function(event) {
		showNotificationMsg( 'alert', currfile.name );
	};
	
	var onLoad = function(event) {};
	
	var onComplete = function() {	// this is oHXR ... 
		if ( this.readyState == 4 ) {
            if ( this.status == 200 ) {
            	var jsonResponse = $.parseJSON(this.responseText);
            	var imageFile = jsonResponse.imageFile;
            	
            	// Load the current page 
            	showNotificationMsg( 'success', imageFile.fileObjFileName );
            	
            	// Load ImageDetails
            	imagePkeys.push(imageFile.pkey);
            	var imageFileType = imageFile.imageType;
            	
            	var suppImagesCont = $('#' + suppImgContOf[imageFileType]);
            	var suppImagesList = suppImagesCont.find('.supporting-images-list:first');
            	
        		var suppImageHtml = new EJS({url: contextPath + '/pages/project/ejs/supp_img_li.ejs'}).render(imageFile);
    			
        		suppImagesList.append(suppImageHtml);
        		suppImagesList.find('li:last input[type=radio]').customInput();

        		// Upload next file ..
            	filesArrayIndex++;
            	currfile = filesArray[filesArrayIndex];
            	
            	if( noOfFiles > 0 && noOfFiles != filesArrayIndex) {
            		uploadFile(currfile, projectPkey, onStart, progress, onError, onAbort, onLoad, onComplete, imageFileType); 
            	} else {

            		// TODO Check this fix ... :) i mean --- click and check .. do we need both ??
            		$('#supp-img-' + imagePkeys[0]).click().check();
            	}
            	
            } else {
            	showNotificationMsg( 'error', currfile.name );
            }
        }
	};
	
	// Uploading ..
	if( noOfFiles > 0 && noOfFiles != filesArrayIndex) {
		uploadFile(currfile, projectPkey, onStart, progress, onError, onAbort, onLoad, onComplete, imageFileType); 
	};
	
};



function uploadFile( inFile, projectPkey, onStart, progress, onError, onAbort, onLoad, onComplete, imageFileType) {
	if (inFile && inFile.size && projectPkey) {
	    var formData = new FormData();
	    var oXHR = new XMLHttpRequest();
	    
	    var uploadUrl = '';
		if ( imageFileType && imageFileType != '' ) {
			uploadUrl = "project/build/upload_image?project.pkey=" + projectPkey ;
			
			formData.append("imageFile.fileObj", inFile);
	        formData.append("imageFile.fileObjFileName", inFile.name);
	        formData.append("imageFile.fileObjContentType", inFile.type);
	        formData.append("imageFileType", imageFileType);
		} else {
			uploadUrl = "project/build/upload_file?project.pkey=" + projectPkey ;
		}
		
		oXHR.upload.addEventListener('loadstart', onStart || function(event){} , false);
        oXHR.upload.addEventListener('progress', progress || function(event){} , false);
        oXHR.upload.addEventListener('error', onError || function(event){} , false);
        oXHR.upload.addEventListener('abort', onAbort || function(event){} , false);
        oXHR.upload.addEventListener('load', onLoad || function(event){} , false);
        
        oXHR.open( 'POST' , uploadUrl );
        oXHR.send(formData);
        
        oXHR.onreadystatechange = onComplete || function() {
            if ( oXHR.readyState == 4 ) {
                if ( oXHR.status == 200 ) {
                	alert('Upload success.');
                } else {
                	alert('Failed to load.');
                }
                
            }
        };
		
	}
};
