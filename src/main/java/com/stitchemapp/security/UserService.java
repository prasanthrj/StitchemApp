package com.stitchemapp.security;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.stitchemapp.entities.User;

public interface UserService extends UserDetailsService {
	
	
	/* User CRUD */
	
	// Register User
		
	
	void createUser(User user);
	
	
	User readUser(Integer pkey);
	
	User readUser(String username);
	
	User readUserByEmailId(String emailId);


	void updateUser(User user, Boolean isPasswdChanged);
	
	
	void deleteUser(User user);

	void deleteUser(String username);
	
	void deleteUserByEmailId(String emailId);
	
	
	User findOrCreateUser(User user);

	boolean userExists(String username);
	
	
	void registerUser(User user);
	
	void resetUserCredentials(String emailId);
	
	
	/* On Context Refresh */
	
	void refreshAndUpdateStandardUsers();
	
	
	
	/* NOTE : Includes UserDetailsService methods ... */
	
	
	
	
	
}
