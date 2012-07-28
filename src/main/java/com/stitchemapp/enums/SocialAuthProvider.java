package com.stitchemapp.enums;

public enum SocialAuthProvider {
	
	FaceBook ("https://www.facebook.com/dialog/oauth", "email,publish_stream,user_photos,offline_access"), 
	Twitter ("http://google.com", "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email"), 
	Google ("", ""), 
	LinkedIn ("", ""), 
	GitHub ("", "");

	private final String host;
	private final String scope;
	private final String callback;
	
	
	/* Constructor */
	
	private SocialAuthProvider(String host, String scope) {
	
		this.host = host;
		this.scope = scope;
		
		this.callback = "/user/home?id=" + this.toString();
	
	}

	
	/* Methods */
	
	public String host() {
		return host;
	}

	public String scope() {
		return scope;
	}
		
	public String callback() {
		return callback;
	}


}
