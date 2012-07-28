package com.stitchemapp.security.impl;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.stitchemapp.constants.Constants;
import com.stitchemapp.security.AbstractAuthenticationProviderFactory;
import com.stitchemapp.security.SocialAuthenticationProvider;

public class SocialAuthenticationFactoryImpl implements AbstractAuthenticationProviderFactory, ApplicationContextAware {
	
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SocialAuthenticationFactoryImpl.class);
	
	private ApplicationContext applicationContext;
	protected HttpServletRequest request;
	
	private SocialAuthenticationProvider socialAuthenticationSource = null;
	
	
	public SocialAuthenticationProvider getSocialAuthProviderInstance(HttpServletRequest request) {
		
		if (applicationContext != null && socialAuthenticationSource == null) {
			
			LOGGER.info(" Req URI : " + request.getRequestURI());
			
			String authProvider = request.getParameter(Constants.AUTH_PROVIDER_PARAMETER);

			if(authProvider != null) 
				return (SocialAuthenticationProvider) applicationContext.getBean(authProvider);
		
		}
		
		return socialAuthenticationSource;
	}
	
	
	
	
	/* Getters and Setters */
	
	public ApplicationContext getApplicationContext(){
		return applicationContext;
	}
	
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.applicationContext = applicationContext;
	}

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}
	
	
}
