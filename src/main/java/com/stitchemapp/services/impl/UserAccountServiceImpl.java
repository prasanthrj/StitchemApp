package com.stitchemapp.services.impl;

import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;

import com.stitchemapp.api.IDao;
import com.stitchemapp.entities.UserInfo;
import com.stitchemapp.entities.UserNotifications;
import com.stitchemapp.services.UserAccountService;

public class UserAccountServiceImpl implements UserAccountService {

	public static final Logger LOGGER = Logger.getLogger(UserAccountServiceImpl.class);
	
	private IDao genericDao;
	
	
	
	
	
	
	/* UserInfo */
	
	@Transactional
	public void createUserInfo(UserInfo userInfo) {
		if(userInfo != null) {
			genericDao.save(userInfo);
		}
	}
	
	public UserInfo readUserInfo(Integer pkey) {
		return genericDao.find(UserInfo.class, pkey);
	}

	@Transactional
	public void updateUserInfo(UserInfo userInfo) {
		if(userInfo != null) {
			genericDao.update(userInfo);
		}
	}

	@Transactional
	public void deleteUserInfo(UserInfo userInfo) {
		if(userInfo != null) {
			genericDao.delete(userInfo);
		}
	}

	
	/* UserNotifications CRUD */
	
	@Transactional
	public void createUserNotifications(UserNotifications userNotifications) {
		if(userNotifications != null) {
			genericDao.save(userNotifications);
		}
	}
	
	public UserNotifications readUserNotifications(Integer pkey) {
		return genericDao.find(UserNotifications.class, pkey);
	}
	
	@Transactional
	public void updateUserNotifications(UserNotifications userNotifications) {
		if(userNotifications != null) {
			genericDao.update(userNotifications);
		}
	}
	
	@Transactional
	public void deleteUserNotifications(UserNotifications userNotifications) {
		if(userNotifications != null) {
			genericDao.delete(userNotifications);
		}
	}
	
	@Transactional
	public void resetUserNotifications(Integer pkey) {
		UserNotifications notifications = this.readUserNotifications(pkey);
		
		// reset the fields
		if(notifications != null) {
			genericDao.save(notifications);
		}
	}
	
	
	

	/* Getters and Setters */
	
	public IDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}

	
}
