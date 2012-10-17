package com.stitchemapp.security.impl;

import java.util.Hashtable;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.dao.SaltSource;
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
	private SaltSource saltSource;
	
	private MailingService mailingService;


	/* Application Listener */
	
	@Override
	@Transactional
	public void onApplicationEvent(ContextRefreshedEvent event) {
		this.refreshAndUpdateStandardUsers();
	}
	

	/* UserManager Methods */
	
	@Transactional
	public void createUser(User user) {
		if(user != null) {
			genericDao.save(user);
			
			// Now hash the password and update the user 
//			String encPassword = passwordEncoder.encodePassword(passwd, saltSource.getSalt(user));
			
			String encPassword = passwordEncoder.encodePassword(user.getPassword(), user.getUsername()); 
			user.setPassword(encPassword);  
			genericDao.update(user);
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
	public void updateUser(User user, Boolean isPasswdChanged) {
		if(user != null) {
			genericDao.update(user);
			
			// new password encrypted ... 
			if(isPasswdChanged) {
				String encPassword = passwordEncoder.encodePassword(user.getPassword(), user.getUsername()); 
				user.setPassword(encPassword);  
				genericDao.update(user);
			}
			
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
	
	
	public boolean userExists(String username) {
		User user = readUser(username);
		if (user == null)
			return false;

		return true;
	}
	
	
	@Transactional
	public void registerUser(User user) {
		String passwd = user.getPassword();
		
		// Create User
		this.createUser(user);
		
		// Send a Welcome Mail .. !!!
		mailingService.sendSuccessfulRegistrationNotification(user, passwd);
		
	}
	
	
	@Transactional
	public void resetUserCredentials(String emailId) {
		
		User user = this.readUserByEmailId(emailId);
		if (user != null) {
			String newPasswd = SecurityUtil.generateRandomPassword();
			user.setPassword(newPasswd);
			genericDao.update(user);
			
			// Now hash the password and update the user 
			String encPassword = passwordEncoder.encodePassword(user.getPassword(), user.getUsername());
			user.setPassword(encPassword);
			genericDao.update(user);
			
			// Send Account Recovery Mail .. !!!
			mailingService.sendAccountRecoveryNotification(user, newPasswd);
		}
	}
	
	/* UserDetailsService Methods */
	
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		User user = null;
		
		// Check for Email
		if (username.contains("@"))
			user = this.readUserByEmailId(username);
		
		// Check for Username
		if(user == null)
			user = this.readUser(username);
		
		return user;
	}

	
	
	/* On Context Refresh */
	
	@Transactional
	public void refreshAndUpdateStandardUsers() {
		
		// TODO Change this to something else .... 
		
		// Administrator 
		
		User admin = this.readUserByEmailId(EmailID.ADMIN);
		if(admin == null) {
			admin = new User();
			admin.setFullName("Administrator");
			admin.setUsername(Constants.ADMIN_USERNAME);
			admin.setPassword(Constants.ADMIN_PASSWORD);
			admin.setEmailId(EmailID.ADMIN);
			
			this.createUser(admin);
		}
		
	}
	
	
	
	/* Getters and Setters */
	
	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}

	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	public void setSaltSource(SaltSource saltSource) {
		this.saltSource = saltSource;
	}

	public void setMailingService(MailingService mailingService) {
		this.mailingService = mailingService;
	}
	
}
