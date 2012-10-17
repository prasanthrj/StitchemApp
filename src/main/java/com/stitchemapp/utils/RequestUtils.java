package com.stitchemapp.utils;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

public class RequestUtils {
	
	public static final Logger LOGGER = Logger.getLogger(RequestUtils.class);
	
	// Extract HostUrl from request ..	
	public static String fetchHostURL (HttpServletRequest request) {
		
		String hostUrl = null;
		if (request != null) {
			hostUrl = "";
			hostUrl += request.getScheme(); 
			hostUrl += "://"; 
			hostUrl += request.getLocalAddr(); 
			
			if (request.getServerPort() != 80)
				hostUrl += ":" + request.getServerPort();
			
			hostUrl += request.getContextPath();
		}

		return hostUrl;
	}
	
	

}
