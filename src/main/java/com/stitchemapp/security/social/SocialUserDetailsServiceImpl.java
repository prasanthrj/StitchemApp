package com.stitchemapp.security.social;

import java.util.Hashtable;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;

import com.stitchemapp.api.IDao;
import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.SocialAuthProvider;
import com.stitchemapp.security.SocialUserDetailsService;
import com.stitchemapp.security.UserService;
import com.stitchemapp.services.MailingService;

public class SocialUserDetailsServiceImpl implements SocialUserDetailsService {
	
	public static final Logger LOGGER = Logger.getLogger(SocialUserDetailsServiceImpl.class);

	private IDao genericDao;
	private MailingService mailingService;
	
	private UserService userService;
	
	
	
	/* SocialUser CRUD */
	
	
	@Transactional
	public void createSocialDetails(SocialDetails socialDetails) {
		if(socialDetails != null ) {
			genericDao.save(socialDetails);
		}
	}

	public SocialDetails readSocialDetails(Integer pkey) {
		return genericDao.find(SocialDetails.class, pkey);
	}

	@Transactional
	public void updateSocialDetails(SocialDetails socialDetails) {
		if(socialDetails != null ) {
			genericDao.update(socialDetails);
		}
	}

	@Transactional
	public void deleteSocialDetails(SocialDetails socialDetails) {
		if(socialDetails != null ) {
			genericDao.delete(socialDetails);
		}
	}
	
	
	/* Social connections  */
	
	@Transactional
	public SocialDetails prepareNewSocialUserConnection(SocialDetails socialDetails) {
		
		String emailId = socialDetails.getEmailId();
		User user = userService.readUserByEmailId(emailId);
		
		if(user == null) {
			user = new User();
			
			user.setSocialUser(true);
			
			user.setFullName(socialDetails.getDisplayName());
			user.setEmailId(socialDetails.getEmailId());
			
			user.setAvatarurl(socialDetails.getAvatarUrl());
		
			userService.createUser(user);
		}
		
		socialDetails.setUser(user);
		
		this.createSocialDetails(socialDetails);
			
		return socialDetails;
	}
	

	public boolean isSocialUserConnectionExists(SocialAuthProvider authProvider, String providerUserId) {
		
		SocialDetails socialDetails = this.findUserSocialDetailsByProviderAndProviderUserId(authProvider, providerUserId);
		if (socialDetails != null && socialDetails.getUser() != null) 
			return true;
		
		return false;
	}
	
	
	
	
	
	
	
	
	
	
	/* SocialUser With Provider related */
	
	
	public List<SocialDetails> findSocialDetailsByUser(User user) {
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("user", user);
		return genericDao.getEntities(SocialDetails.class, "socialDetails.selectSocialUserByUser", ht);
	}

	public SocialDetails findUserSocialDetailsByProvider(User user,	SocialAuthProvider providerId) {
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("user", user);
		ht.put("providerId", providerId);
		return genericDao.getEntity(SocialDetails.class, "socialDetails.selectSocialUserByUserAndProviderId", ht);
	}

	public SocialDetails findUserSocialDetailsByProviderAndProviderUserId(SocialAuthProvider providerId, String providerUserId) {
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("providerId", providerId);
		ht.put("providerUserId", providerUserId);
		return genericDao.getEntity(SocialDetails.class, "socialDetails.selectSocialUserByProviderIdAndProviderUserId", ht);
	}
	
	
	

	
	
	
	/* Getters and Setters */

	public IDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}

	public MailingService getMailingService() {
		return mailingService;
	}

	public void setMailingService(MailingService mailingService) {
		this.mailingService = mailingService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}


}
