package com.stitchemapp.utils;

import javax.servlet.http.HttpServletRequest;

public class RequestUtils {
	
	
	
	// Extract HostUrl from request ..	
	
	public static String fetchHostURL (HttpServletRequest request) {
		
		String hostUrl = "";
		
		if (request != null) {

			hostUrl += request.getScheme(); 
			hostUrl += "://"; 
			
			String server = request.getServerName(); 
			if (server.contains("localhost")) { 
				server = "192.168.6.119"; 
			} 
			
			hostUrl += server; 
			
			if (request.getServerPort() != 80)
				hostUrl += ":" + request.getServerPort();
			
			hostUrl += request.getContextPath();

		}

//		System.out.println(hostUrl);

		return hostUrl;

	}
	

}
