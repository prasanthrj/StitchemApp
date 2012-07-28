package com.stitchemapp.security.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.User;

public class SecurityUtil {

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
