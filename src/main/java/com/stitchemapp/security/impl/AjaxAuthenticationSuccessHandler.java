package com.stitchemapp.security.impl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;

public class AjaxAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

	public void onAuthenticationSuccess(HttpServletRequest request, 
			HttpServletResponse response, Authentication auth) throws IOException, ServletException {
		
		String targetUrl = request.getParameter("targetUrl");
		if (targetUrl == null || targetUrl.isEmpty()) {
			targetUrl = "/home";
		}
		
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			response.setContentType("application/json");
			response.getWriter().print("{ \"isAuthenticated\" : true, \"targetUrl\" : \"" + targetUrl + "\" }");
			response.getWriter().flush();
		} else {
			super.onAuthenticationSuccess(request, response, auth);
		}
	}
	
}
