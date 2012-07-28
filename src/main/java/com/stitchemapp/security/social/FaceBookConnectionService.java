package com.stitchemapp.security.social;

import org.apache.log4j.Logger;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.web.client.RestTemplate;

import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.SocialUser;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.SocialAuthProvider;
import com.stitchemapp.security.SocialConnectionService;
import com.stitchemapp.security.SocialUserDetailsService;

public class FaceBookConnectionService implements SocialConnectionService {
	
	public static final Logger LOGGER = Logger.getLogger(FaceBookConnectionService.class);

	private SocialUserDetailsService socialUserDetailsManager;
	
	private String accessToken;
	private String authProviderUrl;
	
	private static final SocialAuthProvider providerId = SocialAuthProvider.FaceBook;
	private static final String FB_GRAPH_URL = "https://graph.facebook.com";
	
	private RestTemplate restTemplate = new RestTemplate();
	

	
	/* SocialUser Connection related */
	
	public void initializeWithAccessToken(String authProviderUrl, String accessToken) {
		this.accessToken = accessToken;
		this.authProviderUrl = authProviderUrl;
		
		
	}
	
	
	
	/* User Related */
	
	public User findUserBySocialDetails(SocialDetails inSocialDetails){
		
		User user = null;
		
		String providerUserId = inSocialDetails.getProviderUserId();
		SocialDetails socialDetails = socialUserDetailsManager.findUserSocialDetailsByProviderAndProviderUserId(providerId, providerUserId);
		
		if(socialDetails != null)
			user = socialDetails.getUser();
					
		return user;
		
	}
	
	
	
	
	/* SocialUser Related */

	public SocialDetails findOrCreateSocialUser() {
		
		SocialDetails inSocialDetails = this.fetchBasicSocialDetails();
		String providerUserId = inSocialDetails.getProviderUserId();
		
		SocialDetails socialDetails = socialUserDetailsManager.findUserSocialDetailsByProviderAndProviderUserId(providerId, providerUserId);
		if(socialDetails == null || socialDetails.getUser() == null) {
			
			// i.e. new UserConnection .. ( First time User social connection )
			socialDetails = socialUserDetailsManager.prepareNewSocialUserConnection(inSocialDetails);
		}
		
		return socialDetails;
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
				
				socialDetails.setFullName(jsonDetails.getString("first_name") + " " + jsonDetails.getString("last_name") );
				socialDetails.setDisplayName(jsonDetails.getString("name"));
				socialDetails.setEmailId(jsonDetails.getString("email"));
				
				socialDetails.setAvatarUrl( "/" + jsonDetails.getString("id") + "/picture" );
				
				socialDetails.setAccessToken(accessToken);
			}
			
		} catch (Throwable ex) {
			ex.printStackTrace();
		}
		
		return socialDetails;
	}
	

	public JSONObject fetchBasicProfile() {
		
		JSONObject resp = null;
		
		try {
			String my_url = FB_GRAPH_URL + "/me?access_token=" + accessToken;
			String res = restTemplate.getForObject(my_url, String.class);
			resp = new JSONObject(res);
			
			LOGGER.info("My Details: "+resp.toString());
			
		} catch (Throwable ex) {
			ex.printStackTrace();
		}
		
		return resp;
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
		String my_url = FB_GRAPH_URL + "/me?access_token=" + accessToken;
		String res = restTemplate.getForObject(my_url, String.class);
		System.out.println("My Details: "+res);
		return res;
	}

	public String searchBasicProfile(String sortType, Integer startIndex, Integer count){
		String my_url = FB_GRAPH_URL + "/me?access_token=" + accessToken;
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
