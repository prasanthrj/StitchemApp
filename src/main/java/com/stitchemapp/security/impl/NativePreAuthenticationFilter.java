package com.stitchemapp.security.impl;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;

import com.stitchemapp.constants.Constants;
import com.stitchemapp.security.AbstractAuthenticationProviderFactory;
import com.stitchemapp.security.SocialAuthenticationProvider;

public class NativePreAuthenticationFilter extends AbstractPreAuthenticatedProcessingFilter {

	private static final Logger logger = LoggerFactory.getLogger(NativePreAuthenticationFilter.class);
	
	private AbstractAuthenticationProviderFactory authenticationProviderFactory;
	
	private SocialAuthenticationProvider authenticationSource;
	private String exceptionUrlPattern;
	
	
	public NativePreAuthenticationFilter() {
		super();
	}
	
	
	@Override
	protected Object getPreAuthenticatedPrincipal(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return request.getParameter("j_username");
	}
	
	@Override
	protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return request.getParameter("j_password");
	}

	/*
	
	private String extractPassword(HttpServletRequest request) {
		return request.getParameter("j_password");
	}

	private String extractUsername(HttpServletRequest request) {
		return request.getParameter("j_username");
	}
	
	*/
	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		
		if (logger.isDebugEnabled()) 
			logger.debug("Checking secure context token: " + SecurityContextHolder.getContext().getAuthentication());
		
		HttpServletRequest httpServletRequest = (HttpServletRequest) request;
		HttpServletResponse httpServletResponse = (HttpServletResponse) response;

		if (requiresPreAuthenticationSetUp(httpServletRequest)) {
			
			authenticationSource = authenticationProviderFactory.getSocialAuthProviderInstance(httpServletRequest);
			if(authenticationSource != null) {
				authenticationSource.authenticateAtProviderForAccessToken( httpServletRequest, httpServletResponse );

				if (httpServletRequest.getSession(true).getAttribute(Constants.AUTH_PROVIDER_PARAMETER) != null ) {
					chain.doFilter(request, response);
				}
			}
			
		} else {
			chain.doFilter(request, response);
		}
		
	}
	
	
	private boolean requiresPreAuthenticationSetUp(HttpServletRequest request) {
		
		String authProvider = request.getParameter(Constants.AUTH_PROVIDER_PARAMETER);
		if(authProvider == null) 
			return false;
		
		if (SecurityContextHolder.getContext().getAuthentication() == null)
			return true;
		
		return false;

	}
	

	
	@Override
	public void afterPropertiesSet() {

	}
	
	
	/* Getters and Setters */
	
	public void setAuthenticationProviderFactory(
			AbstractAuthenticationProviderFactory authenticationProviderFactory) {
		this.authenticationProviderFactory = authenticationProviderFactory;
	}

	public void setExceptionUrlPattern(String exceptionUrlPattern) {
		this.exceptionUrlPattern = exceptionUrlPattern;
	}

}