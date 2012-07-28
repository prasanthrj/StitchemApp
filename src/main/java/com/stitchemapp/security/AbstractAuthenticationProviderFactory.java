package com.stitchemapp.security;

import javax.servlet.http.HttpServletRequest;

public interface AbstractAuthenticationProviderFactory {
	
	public SocialAuthenticationProvider getSocialAuthProviderInstance(HttpServletRequest request);

}
