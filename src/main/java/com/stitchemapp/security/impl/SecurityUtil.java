package com.stitchemapp.security.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.apache.log4j.Logger;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.User;

public class SecurityUtil {
	
	public static final Logger LOGGER = Logger.getLogger(SecurityUtil.class);
	
	private static final Integer PASSWD_LENGTH = 8;
	
	private static final String ALPHA_NUM_STR = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	private static Random rnd = new Random();
	
	/* Generic Utils */
	
	public static String generateRandomPassword() {
		int aplhaNumStrLength = ALPHA_NUM_STR.length();
		
		StringBuilder sb = new StringBuilder(PASSWD_LENGTH);
		for (int i = 0; i < PASSWD_LENGTH; i++) {
			sb.append(ALPHA_NUM_STR.charAt(rnd.nextInt(aplhaNumStrLength)));
		}
		
		return sb.toString();
	}

	
	
	/* Authentication */

	public static Authentication signInUser(User user) {

		List<GrantedAuthority> authorities = createlUserAuthorities();
		Authentication authentication = new UsernamePasswordAuthenticationToken(user, user.getPassword(), authorities);
		SecurityContextHolder.getContext().setAuthentication(authentication);
		return authentication;

	}

	public static Authentication signInSocialUser(SocialDetails socialUser) {

		User user = socialUser.getUser();

		List<GrantedAuthority> authorities = createlUserAuthorities();
		Authentication authentication = new UsernamePasswordAuthenticationToken(user, user.getPassword(), authorities);

		SecurityContextHolder.getContext().setAuthentication(authentication);
		return authentication;

	}

	public static List<GrantedAuthority> createlUserAuthorities() {

		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
		GrantedAuthority authority = new GrantedAuthority() {
			public String getAuthority() {
				return "ROLE_SOCIAL_USER";
			}
		};
		authorities.add(authority);
		
		return authorities;
		
	}

}
