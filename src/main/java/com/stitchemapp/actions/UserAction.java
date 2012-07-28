package com.stitchemapp.actions;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.User;
import com.stitchemapp.security.SocialAuthenticationProvider;
import com.stitchemapp.security.SocialConnectionService;
import com.stitchemapp.security.SocialUserDetailsService;
import com.stitchemapp.security.impl.SecurityUtil;

public class UserAction extends GenericActionSupport implements ApplicationContextAware {
	
	public static final Logger LOGGER = Logger.getLogger(UserAction.class);
	
	private ApplicationContext applicationContext;
	private SocialUserDetailsService socialUserDetailsService;
	
	private SocialAuthenticationProvider authenticationProvider;
	private SocialConnectionService socialConnectionService;
	
	private User user;
	private SocialDetails socialDetails;
	
	
	@Override
	public void prepare() throws Exception {
		super.prepare();
		
		// User
		String userEmailId = this.request.getParameter("user.emailId");
        if (userEmailId != null && StringUtils.isNotEmpty(userEmailId)){
            user = userService.readUserByEmailId(userEmailId);
        }
        
		
	}
	
	public String registerUser(){
		
		if(user != null && user.getEmailId() != null ){
			
			if(user.getPkey() != null) {
				super.userService.updateUser(user);
			} else {
				super.userService.createUser(user);
			}
			
			if (socialDetails != null && socialDetails.getProviderId() != null) {
				
				String authProvider = socialDetails.getProviderId().toString();
					
				SocialAuthenticationProvider authenticationProvider = (SocialAuthenticationProvider) applicationContext.getBean(authProvider);
				SocialConnectionService socialConnectionManager = authenticationProvider.getSocialConnectionService();
				
				socialDetails = socialConnectionManager.fetchBasicSocialDetails();
				socialDetails.setUser(user);
				
				// Save Social Details ..
				socialUserDetailsService.createSocialDetails(socialDetails);					

			}
			
		}
		
		// on Successful User creation, set Authentication 
		user = userService.readUser(user.getPkey());
		
		SecurityUtil.signInUser(user);
		super.prepareLoggedinUserDetails();
						
		return SUCCESS;
	}
		

	
	/* Getters and Setters */
	
	public ApplicationContext getApplicationContext() {
		return applicationContext;
	}

	public void setApplicationContext(ApplicationContext applicationContext) {
		this.applicationContext = applicationContext;
	}

	public SocialUserDetailsService getSocialUserDetailsService() {
		return socialUserDetailsService;
	}

	public void setSocialUserDetailsService(
			SocialUserDetailsService socialUserDetailsService) {
		this.socialUserDetailsService = socialUserDetailsService;
	}

	public SocialAuthenticationProvider getAuthenticationProvider() {
		return authenticationProvider;
	}

	public void setAuthenticationProvider(SocialAuthenticationProvider authenticationProvider) {
		this.authenticationProvider = authenticationProvider;
	}

	public SocialConnectionService getSocialConnectionService() {
		return socialConnectionService;
	}

	public void setSocialConnectionService(
			SocialConnectionService socialConnectionService) {
		this.socialConnectionService = socialConnectionService;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public SocialDetails getSocialDetails() {
		return socialDetails;
	}

	public void setSocialDetails(SocialDetails socialDetails) {
		this.socialDetails = socialDetails;
	}
	
	
}
