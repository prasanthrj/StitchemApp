package com.stitchemapp.analytics;

import javax.servlet.http.HttpServletRequest;

import org.codehaus.jettison.json.JSONObject;

public interface WebAnalyticsAPIService {
	
	
	/* Page events */
	
	JSONObject recordEvent( JSONObject event, HttpServletRequest request );
	
	
	
	/* Page Visits */
	
	JSONObject recordVisit( String pageURI , HttpServletRequest request );
	
	Integer fetchPageVisitCount( String pageURI );
	
	
	
	/* Analytics */
	
	
	
	
	
	
}
