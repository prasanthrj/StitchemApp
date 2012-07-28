package com.stitchemapp.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.AuthenticationProvider;

import com.stitchemapp.entities.User;

public interface SocialAuthenticationProvider {

	
	/* Authentication Related */
	
	void authenticateAtProviderForAccessToken(HttpServletRequest request, HttpServletResponse respose);
	
	String retrieveAccessTokenFromProvider(HttpServletRequest request); 

	boolean hasRequiredParameters(HttpServletRequest request);
	
	
	
	
	/* SocialConnection Manager */
	
	SocialConnectionService getSocialConnectionService();

	void setSocialConnectionService(SocialConnectionService socialConnectionManager);
	
	
	
	
	
	/* Some Other Getters and Setters for Fields */
	
	String getConsumerKey();

	void setConsumerKey(String consumerKey);

	
	
	String getConsumerSecret();

	void setConsumerSecret(String consumerSecret);

	
	
	String getAuthProviderUrl();
	
	void setAuthProviderUrl(String authProviderUrl);
	
	
	
	String getScope();

	void setScope(String scope);
	
	
	
	String getCallBackUri();
	
	void setCallBackUri(String callBackUri);

	
	
}
