package com.stitchemapp.security;

import java.util.List;

import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.SocialAuthProvider;


public interface SocialUserDetailsService {
	
	
	/* SocialUser CRUD */
	
	
	void createSocialDetails(SocialDetails socialDetails);
	
	SocialDetails readSocialDetails(Integer pkey);

	void updateSocialDetails(SocialDetails socialDetails);
	
	void deleteSocialDetails(SocialDetails socialDetails);

	
	
	/* Social connections  */
	
	SocialDetails prepareNewSocialUserConnection(SocialDetails socialDetails);
	
	boolean isSocialUserConnectionExists(SocialAuthProvider authProvider, String providerUserId);
	
		
	
	
	/* SocialUser With Provider related */
	

	List<SocialDetails> findSocialDetailsByUser(User user);

	SocialDetails findUserSocialDetailsByProvider(User user, SocialAuthProvider providerId);

	SocialDetails findUserSocialDetailsByProviderAndProviderUserId(SocialAuthProvider providerId,String providerUserId);
	
	
	/*
	List<SocialUser> findByUserId(String userId);

	List<SocialUser> findByUserIdAndProviderId(String userId, String providerId);

	List<SocialUser> findByUserIdAndProviderUserIds(String userId, MultiValueMap<String, String> providerUserIds);
	

	SocialUser findSocialUser(String userId, String providerId, String providerUserId);
	

	List<SocialUser> findPrimaryByUserIdAndProviderId(String userId, String providerId);

	Integer selectMaxRankByUserIdAndProviderId(String userId, String providerId);

	List<String> findUserIdsByProviderIdAndProviderUserId(String providerId, String providerUserId);

	List<String> findUserIdsByProviderIdAndProviderUserIds(String providerId, Set<String> providerUserIds);
	*/
	

}
