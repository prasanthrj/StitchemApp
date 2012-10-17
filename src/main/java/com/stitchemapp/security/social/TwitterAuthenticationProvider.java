package com.stitchemapp.security.social;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.client.RestTemplate;

import com.stitchemapp.constants.Constants;
import com.stitchemapp.enums.SocialAuthProvider;
import com.stitchemapp.security.SocialAuthenticationProvider;
import com.stitchemapp.security.SocialConnectionService;
import com.stitchemapp.utils.RequestUtils;

public class TwitterAuthenticationProvider implements SocialAuthenticationProvider {

	public static final Logger LOGGER = Logger.getLogger(TwitterAuthenticationProvider.class);

	private SocialConnectionService socialConnectionService;

	private String consumerKey;
	private String consumerSecret;
	private String authProviderUrl;
	private String scope;
	private String callBackUri;

	private static final String FB_GRAPH_URL = "https://graph.facebook.com";
	
	
	
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
                    
                    String authorizeUrl = authProviderUrl + "?client_id=" + consumerKey + "&redirect_uri=" + callbackUrl + "&scope=" + scope;
                    respose.sendRedirect(authorizeUrl);
                    
                } else {
                    if (this.hasRequiredParameters(request)) {
                    
                    	String accessToken =  retrieveAccessTokenFromProvider(request);
                        socialConnectionService.initializeWithAccessToken(authProviderUrl, accessToken);
                        
                        request.getSession().setAttribute(Constants.AUTH_PROVIDER_PARAMETER, SocialAuthProvider.FaceBook);

                    }
                
                }
                
            }
        
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
        }
            
	}

	public String retrieveAccessTokenFromProvider(HttpServletRequest request) {
		
		String hostUrl = RequestUtils.fetchHostURL(request);
		String requestCode = request.getParameter("code");

		String callbackUrl = hostUrl + callBackUri;
		LOGGER.info( " callback url: " + callbackUrl );
		LOGGER.info( " Req Code: " + requestCode );
		
		RestTemplate restTemplate = new RestTemplate();
		
		String accessTokenUrl = FB_GRAPH_URL + "/oauth/access_token?client_id=" + consumerKey + "&client_secret=" + consumerSecret + "&code=" + requestCode + "&redirect_uri=" + callbackUrl ;
		String obj = restTemplate .getForObject(accessTokenUrl, String.class);
		
		String accessToken = obj.split("&")[0].split("=")[1];
		LOGGER.info( " Access Token: " + accessToken );
		
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
	
	public void setConsumerKey(String consumerKey) {
		this.consumerKey = consumerKey;
	}

	public void setConsumerSecret(String consumerSecret) {
		this.consumerSecret = consumerSecret;
	}

	public void setAuthProviderUrl(String authProviderUrl) {
		this.authProviderUrl = authProviderUrl;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}

	public void setCallBackUri(String callBackUri) {
		this.callBackUri = callBackUri;
	}

}
