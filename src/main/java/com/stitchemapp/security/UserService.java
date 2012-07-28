package com.stitchemapp.security;

import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.stitchemapp.entities.User;

public interface UserService extends UserDetailsService {
	
	
	/* User CRUD */
	
	// Register User
	void createUser(User user);
	
	
	User readUser(Integer pkey);
	
	User readUser(String username);
	
	User readUserByEmailId(String emailId);
		

	void updateUser(User user);
	
	
	void deleteUser(User user);

	void deleteUser(String username);
	
	void deleteUserByEmailId(String emailId);
	
	
	User findOrCreateUser(User user);
	

	void changePassword(String oldPassword, String newPassword);

	boolean userExists(String username);
	
	
	/* On Context Refresh */
	
	void refreshStandardUsers();
	
	
	
	/* NOTE : Includes UserDetailsService methods ... */
	
	
	
	
	
}
