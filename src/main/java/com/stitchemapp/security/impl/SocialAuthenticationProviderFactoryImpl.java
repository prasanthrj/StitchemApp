package com.stitchemapp.security.impl;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.stitchemapp.constants.Constants;
import com.stitchemapp.security.AbstractAuthenticationProviderFactory;
import com.stitchemapp.security.SocialAuthenticationProvider;

public class SocialAuthenticationProviderFactoryImpl implements AbstractAuthenticationProviderFactory, ApplicationContextAware {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SocialAuthenticationProviderFactoryImpl.class);
	
	private ApplicationContext applicationContext;
	private SocialAuthenticationProvider socialAuthenticationSource = null;
	
	
	public SocialAuthenticationProvider getSocialAuthProviderInstance(HttpServletRequest request) {
		LOGGER.info(" Req URI : " + request.getRequestURI());
		
		if (applicationContext != null && socialAuthenticationSource == null) {
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

}
