package com.stitchemapp.security;

import org.codehaus.jettison.json.JSONObject;

import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.User;

public interface SocialConnectionService {
	
	/* SocialUser Connection related */
	
	void initializeWithAccessToken(String authProviderUrl, String accessToken);
	
	
	/* User Related */
	
	User findUserBySocialDetails(SocialDetails inSocialDetails);
	
	
	/* SocialUser Related */
	
	SocialDetails findOrCreateSocialUser();
	
	
	/* inWard Connection Related */
	
	SocialDetails fetchBasicSocialDetails();

	JSONObject fetchBasicProfile();

	
	String getFriends(int startIndex, int count);

	String searchFriends(String sortType, boolean showTotalCount, int startIndex, int count);

	
	String searchPeople(Integer startIndex, Integer count);

	String searchBasicProfile(String sortType, Integer startIndex, Integer count);
	
	
	/* outWard Connection Related */
		
	void postToSocialProviderFeed(String comment);
	
	
}
