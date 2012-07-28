package com.stitchemapp.services;

import com.stitchemapp.entities.UserInfo;
import com.stitchemapp.entities.UserNotifications;

public interface UserAccountService {
	
	
	/* UserInfo CRUD */
	
	void createUserInfo(UserInfo userInfo);
	
	UserInfo readUserInfo(Integer pkey);
	
	void updateUserInfo(UserInfo userInfo);
	
	void deleteUserInfo(UserInfo userInfo);
	
	
	/* UserNotifications CRUD */
	
	void createUserNotifications(UserNotifications userNotifications);
	
	UserNotifications readUserNotifications(Integer pkey);
	
	void updateUserNotifications(UserNotifications userNotifications);
	
	void deleteUserNotifications(UserNotifications userNotifications);
	
	void resetUserNotifications(Integer pkey);
	
	
	
	
	
	

}
