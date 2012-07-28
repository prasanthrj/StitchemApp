package com.stitchemapp.security.social;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.client.RestTemplate;

import com.google.api.client.auth.oauth2.draft10.AccessTokenResponse;
import com.google.api.client.googleapis.auth.oauth2.draft10.GoogleAccessProtectedResource;
import com.google.api.client.googleapis.auth.oauth2.draft10.GoogleAuthorizationRequestUrl;
import com.google.api.client.googleapis.auth.oauth2.draft10.GoogleAccessTokenRequest.GoogleAuthorizationCodeGrant;
import com.google.api.client.http.HttpRequestFactory;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson.JacksonFactory;
import com.stitchemapp.constants.Constants;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.SocialAuthProvider;
import com.stitchemapp.security.SocialAuthenticationProvider;
import com.stitchemapp.security.SocialConnectionService;
import com.stitchemapp.utils.RequestUtils;

public class GoogleAuthenticationProvider implements SocialAuthenticationProvider {

	public static final Logger LOGGER = Logger.getLogger(GoogleAuthenticationProvider.class);

	private SocialConnectionService socialConnectionService;

	private String consumerKey;
	private String consumerSecret;
	private String authProviderUrl;
	private String scope;
	private String callBackUri;

	
	private static final HttpTransport TRANSPORT = new NetHttpTransport();
	private static final JsonFactory JSON_FACTORY = new JacksonFactory();
	
	
	/* Authentication Related */
	
	public void authenticateAtProviderForAccessToken(HttpServletRequest request, HttpServletResponse respose) {
		
		
		String hostUrl = RequestUtils.fetchHostURL(request);
		String requestCode = request.getParameter(Constants.REQ_CODE_PARAMETER);
		
    	try{
    	
            if (request.getParameter("error_reason") != null) {
                LOGGER.error("Error: " + request.getParameter("error_description"));
                
            } else {
                if (requestCode == null) {
                	
                    String callbackUrl = hostUrl + callBackUri;
                    LOGGER.info( "callback url:" + callbackUrl );
                    
                    String authorizeUrl = new GoogleAuthorizationRequestUrl(consumerKey, callbackUrl.toString(), scope).build();
                    respose.sendRedirect(authorizeUrl);
                    
                } else {
                	
                    if (this.hasRequiredParameters(request)) {
                        String accessToken =  retrieveAccessTokenFromProvider(request);
                        socialConnectionService.initializeWithAccessToken(authProviderUrl, accessToken);
                        
                        request.getSession().setAttribute(Constants.AUTH_PROVIDER_PARAMETER, SocialAuthProvider.Google);
                        
                    }
                    
                }
            }
        
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
        }

        
	}

	public String retrieveAccessTokenFromProvider(HttpServletRequest request) {
		
		String accessToken = null;
			
		String hostUrl = RequestUtils.fetchHostURL(request);
		String requestCode = request.getParameter("code");
		
		String callbackUrl = hostUrl + callBackUri;
		LOGGER.info( " callback url: " + callbackUrl );
		LOGGER.info( " Req Code: " + requestCode );
		
		try {
			
			GoogleAuthorizationCodeGrant authRequest = new GoogleAuthorizationCodeGrant(TRANSPORT, JSON_FACTORY, consumerKey, consumerSecret, requestCode, callbackUrl);
			authRequest.useBasicAuthorization = false;
		
			AccessTokenResponse authResponse = authRequest.execute();
			accessToken = authResponse.accessToken;
		
//			GoogleAccessProtectedResource access = new GoogleAccessProtectedResource(accessToken, TRANSPORT, JSON_FACTORY, consumerKey, consumerSecret, authResponse.refreshToken);
//			HttpRequestFactory f = TRANSPORT.createRequestFactory(access);
//			
//			accessToken = authResponse.accessToken;
			
			LOGGER.info( " Access Token: " + accessToken );
		
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return accessToken;
		
	}

	public boolean hasRequiredParameters(HttpServletRequest request) {
		
		if(request.getParameter(Constants.REQ_CODE_PARAMETER) == null)
			return false;

		return true;
	
	}
	
	
	
	
	
	
	/* SocialConnection Manager */

	public SocialConnectionService getSocialConnectionService() {
		return socialConnectionService;
	}

	public void setSocialConnectionService(SocialConnectionService socialConnectionService) {
		this.socialConnectionService = socialConnectionService;
	}

	
	/* Some Other Getters and Setters for Fields */
	
	public String getConsumerKey() {
		return consumerKey;
	}

	public void setConsumerKey(String consumerKey) {
		this.consumerKey = consumerKey;
	}

	public String getConsumerSecret() {
		return consumerSecret;
	}

	public void setConsumerSecret(String consumerSecret) {
		this.consumerSecret = consumerSecret;
	}

	public String getAuthProviderUrl() {
		return authProviderUrl;
	}

	public void setAuthProviderUrl(String authProviderUrl) {
		this.authProviderUrl = authProviderUrl;
	}

	public String getScope() {
		return scope;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}

	public String getCallBackUri() {
		return callBackUri;
	}

	public void setCallBackUri(String callBackUri) {
		this.callBackUri = callBackUri;
	}
	
	

}
