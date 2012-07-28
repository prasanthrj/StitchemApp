package com.stitchemapp.security.impl;

import java.util.Hashtable;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.transaction.annotation.Transactional;

import com.stitchemapp.api.IDao;
import com.stitchemapp.constants.Constants;
import com.stitchemapp.constants.EmailID;
import com.stitchemapp.entities.User;
import com.stitchemapp.security.UserService;
import com.stitchemapp.services.MailingService;

public class NativeUserDetailsServiceImpl implements UserService, ApplicationListener<ContextRefreshedEvent> {
	
	public static final Logger LOGGER = Logger.getLogger(NativeUserDetailsServiceImpl.class);
	
	private IDao genericDao;
	private PasswordEncoder passwordEncoder;
	
	private MailingService mailingService;


	/* Application Listener */
	
	@Override
	@Transactional
	public void onApplicationEvent(ContextRefreshedEvent event) {
		this.refreshStandardUsers();
	}
	

	/* UserManager Methods */
	
	@Transactional
	public void createUser(User user) {
		if(user != null) {
			genericDao.save(user);
			
			// Now hash the password and update the user 
			String encPassword = passwordEncoder.encodePassword(user.getPassword(), user.getUsername()); 
			user.setPassword(encPassword);  
			genericDao.update(user);
			
			// TODO Send a Welcome Mail .. !!!
			
		}
	}
	
	
	
	public User readUser(Integer pkey) {
		return genericDao.find(User.class, pkey);
	}
	
	public User readUser(String username) {
		Hashtable<String, String> ht = new Hashtable<String, String>();
		ht.put("username", username);
		return genericDao.getEntity(User.class, "user.selectUserByUserName", ht);
	}
	
	public User readUserByEmailId(String emailId) {
		Hashtable<String, String> ht = new Hashtable<String, String>();
		ht.put("emailId", emailId);
		return genericDao.getEntity(User.class, "user.selectUserByEmailId", ht);
	}
	
	
	@Transactional
	public void updateUser(User user) {
		if(user != null) {
			genericDao.save(user);
		}
	}
	
	
	@Transactional
	public void deleteUser(User user) {
		if(user != null) {
			genericDao.delete(user);
		}
	}

	@Transactional
	public void deleteUser(String username) {
		User user = readUser(username);
		if(user != null) {
			deleteUser(user);
		}
	}
	
	@Transactional
	public void deleteUserByEmailId(String emailId) {
		User user = readUserByEmailId(emailId);
		if(user != null) {
			deleteUser(user);
		}
	}
	
	
	@Transactional
	public User findOrCreateUser(User user) {
		User tempUser = this.readUserByEmailId(user.getEmailId());
		if(tempUser == null) {
			this.createUser(user);
			tempUser = this.readUser(user.getPkey());
		}
		return tempUser;
	}
	
	

	@Transactional
	public void changePassword(String oldPassword, String newPassword) {
		// TODO Auto-generated method stub
		
	}

	public boolean userExists(String username) {
		User user = readUser(username);
		
		if (user == null) {
			return false;
		} else {
			return true;
		}
		
	}
	
	
	
	
	/* UserDetailsService Methods */
	
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		User user = this.readUser(username);
		return user;
	}

	
	
	/* On Context Refresh */
	
	@Transactional
	public void refreshStandardUsers() {
		
		// Administrator 
		User admin = this.readUserByEmailId(EmailID.ADMIN);
		if(admin == null) {
			admin = new User();
			admin.setFullName("Admin");
			admin.setUsername(Constants.ADMIN_USERNAME);
			admin.setPassword(Constants.ADMIN_PASSWORD);
			admin.setEmailId(EmailID.ADMIN);
			
			this.createUser(admin);
		}
		
		// Stitchemapp
		User sta = this.readUserByEmailId(EmailID.STITCHEMAPP);
		if(sta == null) {
			sta = new User();
			sta.setFullName("StitchemApp");
			sta.setUsername(Constants.STA_USERNAME);
			sta.setPassword(Constants.STA_PASSWORD);
			sta.setEmailId(EmailID.STITCHEMAPP);
			
			this.createUser(sta);
		}
		
		// Milli
		User milli = this.readUserByEmailId(EmailID.TEST);
		if(milli == null) {
			milli = new User();
			milli.setFullName("milli");
			milli.setUsername("milli");
			milli.setPassword("milli");
			milli.setEmailId(EmailID.TEST);
			
			this.createUser(milli);
		}		

		
	}
	
	
	
	/* Getters and Setters */
	
	public IDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}

	public PasswordEncoder getPasswordEncoder() {
		return passwordEncoder;
	}

	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	public MailingService getMailingService() {
		return mailingService;
	}

	public void setMailingService(MailingService mailingService) {
		this.mailingService = mailingService;
	}
	
}
