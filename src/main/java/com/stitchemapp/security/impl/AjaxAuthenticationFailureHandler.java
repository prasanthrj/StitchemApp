package com.stitchemapp.security.impl;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;

public class AjaxAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException exception) throws IOException, ServletException {

		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			response.setContentType("application/json");
	        response.getWriter().print("{ \"isAuthenticated\" : false }");
	        response.getWriter().flush();
	    } else {
			super.onAuthenticationFailure(request, response, exception);
		}
		
    }
}
