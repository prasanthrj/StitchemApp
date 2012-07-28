package com.stitchemapp.security.social;

import org.apache.log4j.Logger;
import org.apache.struts2.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.web.client.RestTemplate;

import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson.JacksonFactory;
import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.SocialAuthProvider;
import com.stitchemapp.security.SocialConnectionService;
import com.stitchemapp.security.SocialUserDetailsService;

public class GoogleConnectionService implements SocialConnectionService {
	
	public static final Logger LOGGER = Logger.getLogger(GoogleConnectionService.class);

	private SocialUserDetailsService socialUserDetailsManager;
	
	private String accessToken;
	private String authProviderUrl;
	
	private static final SocialAuthProvider providerId = SocialAuthProvider.Google;
	
	private RestTemplate restTemplate = new RestTemplate();
	
	
	
	
	/* SocialUser Connection related */
	
	public void initializeWithAccessToken(String authProviderUrl, String accessToken) {
		this.accessToken = accessToken;
		this.authProviderUrl = authProviderUrl;
		
			
		
	}
	
	
	/* User Related */
	
	public User findUserBySocialDetails(SocialDetails inSocialDetails) {
		
		User user = null;
		
		String providerUserId = inSocialDetails.getProviderUserId();
		SocialDetails socialDetails = socialUserDetailsManager.findUserSocialDetailsByProviderAndProviderUserId(providerId, providerUserId);
		
		if(socialDetails != null)
			user = socialDetails.getUser();
					
		return user;
		
	}
	

	
	
	
	
	/* SocialUser Related */

	public SocialDetails findOrCreateSocialUser() {
		
		
		
		return null;
	}
	
	
	
	
	
	
	/* inWard Connection Related */
	
	
	public SocialDetails fetchBasicSocialDetails() {
		
		SocialDetails socialDetails = null;
		
		try {
			JSONObject jsonDetails = this.fetchBasicProfile();
			if (jsonDetails != null) {
				
				socialDetails = new SocialDetails();
				
				socialDetails.setProviderId(providerId);
				socialDetails.setProviderUserId(jsonDetails.getString("id"));
				
				socialDetails.setFullName(jsonDetails.getString("first_name"));
				socialDetails.setDisplayName(jsonDetails.getString("name"));
				socialDetails.setEmailId(jsonDetails.getString("email"));
				
				socialDetails.setAvatarUrl(jsonDetails.getString("picture"));
				
				socialDetails.setAccessToken(accessToken);
			}
			
		} catch (Throwable ex) {
			ex.printStackTrace();
		}
		
		return socialDetails;
	}

	public JSONObject fetchBasicProfile() {
		try {
			String url = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + accessToken ;
			String obj = restTemplate.getForObject(url, String.class);
			JSONObject resp = new JSONObject(obj);
			
			LOGGER.info("My Details: " + resp.toString() );
			
			return resp;
		} catch (Throwable ex) {
			return null;
		}
	}

	
	
	public String getFriends(int startIndex, int count) {
        try {

            String users = this.searchPeople(startIndex, count).toString();
            return users;
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
        }
        return null;
    }

    public String searchFriends(String sortType, boolean showTotalCount, int startIndex, int count) {
        try {
            String users = this.searchBasicProfile(sortType, startIndex, count).toString();
            return users;
        } catch (Exception e) {
            LOGGER.error(e.getMessage(), e);
        }
        return null;
    }
    
    
    

    public String searchPeople(Integer startIndex, Integer count){
    	String my_url = "https://www.googleapis.com/oauth2/v1/userinfo=" + accessToken ;
		String res = restTemplate.getForObject(my_url, String.class);
		System.out.println("My Details: "+res);
		return res;
	}

	public String searchBasicProfile(String sortType, Integer startIndex, Integer count){
		String my_url = "https://www.googleapis.com/oauth2/v1/userinfo=" + accessToken ;
		String res = restTemplate.getForObject(my_url, String.class);
		return res;
	}
	
	


	
	
	
	/* outWard Connection Related */
	
	public void postToSocialProviderFeed(String comment) {
		// TODO Auto-generated method stub
		
	}

	
	
	
	
	/* Getters and Setters */
	
	public SocialUserDetailsService getSocialUserDetailsManager() {
		return socialUserDetailsManager;
	}

	public void setSocialUserDetailsManager(
			SocialUserDetailsService socialUserDetailsManager) {
		this.socialUserDetailsManager = socialUserDetailsManager;
	}

	public String getAccessToken() {
		return accessToken;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}

	public String getAuthProviderUrl() {
		return authProviderUrl;
	}

	public void setAuthProviderUrl(String authProviderUrl) {
		this.authProviderUrl = authProviderUrl;
	}


	


	
	
	
	
}
