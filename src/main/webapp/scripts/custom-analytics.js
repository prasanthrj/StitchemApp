
// using class -- single-page
// data-role=page 


/*

$('div[data-role=page]').each(function(){
	console.log(this);
	$(this).live('pageinit', function(){
		console.log(this);
	});
});

*/

/* Global Variables ... */

var pages = $('[data-role=page]');

pages.live('pageshow', function (event, ui) {
	try  {
    	$.ajax({
    		url: contextPath + '/analytics/recordPageVisit',
    		type: "POST",
    		data: {
    			'project.pkey' : projectPkey,
    			'appUser.pkey' : appUserPkey,
    			'visit.pageURI' : event.target.id
    		}
		});

	} catch(error) { }
});

pages.live('tap', function (event, ui) {
	try  {
    	$.ajax({
    		url: contextPath + '/analytics/recordPageVisit',
    		type: "POST",
    		data: {
    			'project.pkey' : projectPkey,
    			'appUser.pkey' : appUserPkey,
    			'visit.pageURI' : event.target.id
    		}
		});

	} catch(error) { }
});

pages.live('taphold', function (event, ui) {
	
	try  {
		
    	$.ajax({
    		url: contextPath + '/analytics/recordPageVisit',
    		type: "POST",
    		data: {
    			'project.pkey' : projectPkey,
    			'appUser.pkey' : appUserPkey,
    			'visit.pageURI' : event.target.id
    		}
		});

	} catch(error) { }
});

pages.live('swipeleft', function (event, ui) {
	try  {
    	$.ajax({
    		url: contextPath + '/analytics/recordPageVisit',
    		type: "POST",
    		data: {
    			'project.pkey' : projectPkey,
    			'appUser.pkey' : appUserPkey,
    			'visit.pageURI' : event.target.id
    		}
		});
	} catch(error) { }
});

pages.live('swiperight', function (event, ui) {
	try  {
    	$.ajax({
    		url: contextPath + '/analytics/recordPageVisit',
    		type: "POST",
    		data: {
    			'project.pkey' : projectPkey,
    			'appUser.pkey' : appUserPkey,
    			'visit.pageURI' : event.target.id
    		}
		});
	} catch(error) { }
});

