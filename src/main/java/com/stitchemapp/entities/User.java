package com.stitchemapp.entities;

import java.util.Collection;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@Entity
@Table(name = "users", uniqueConstraints = {
	@UniqueConstraint(columnNames = {"user_name"}),
	@UniqueConstraint(columnNames = {"email_id"})
})
@NamedQueries({
	@NamedQuery(name="user.selectUserByUserName", query="SELECT instance from User instance where instance.username=:username AND instance.enabled != " + false ),
	@NamedQuery(name="user.selectUserByEmailId", query="SELECT instance from User instance where instance.emailId=:emailId AND instance.enabled != " + false )
})
public class User extends BaseEntity implements UserDetails {

	private String username;
	private String password;
	
//	private String displayName;
	private String fullName;
	private String emailId;
	
	private String location;
	
	private String activationToken;

	private UserNotifications notifications;
		
	// UserDetails related
	private Collection<GrantedAuthority> authorities;
	private boolean accountNonExpired = true;
	private boolean accountNonLocked = true;
	private boolean credentialsNonExpired = true;
	private boolean enabled = true;
	
	
	private UserInfo userInfo;
	
	private boolean isSocialUser = false;
	private String avatarurl;

	
	
	
	/* Getters and Setters */
	
	@Column(name = "user_name" )
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
	@Column(name = "password" )
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	/*
	@Column(name = "display_name" )
	public String getDisplayName() {
		if (displayName == null)
			displayName = this.fullName;
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	*/

	@Column(name = "full_name")
	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	@Column(name = "email_id", nullable = false )
	public String getEmailId() {
		return emailId;
	}

	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}

	@Column(name = "location")
	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	@Column(name = "activation_token")
	public String getActivationToken() {
		return activationToken;
	}

	public void setActivationToken(String activationToken) {
		this.activationToken = activationToken;
	}

	@OneToOne ( fetch = FetchType.LAZY, cascade = CascadeType.ALL )
	@JoinColumn(name = "user_notifications_pkey")
	public UserNotifications getNotifications() {
		return notifications;
	}

	public void setNotifications(UserNotifications notifications) {
		this.notifications = notifications;
	}
	

	@Transient
	public Collection<GrantedAuthority> getAuthorities() {
		return authorities;
	}

	public void setAuthorities(Collection<GrantedAuthority> authorities) {
		this.authorities = authorities;
	}

	public boolean isAccountNonExpired() {
		return accountNonExpired;
	}

	public void setAccountNonExpired(boolean accountNonExpired) {
		this.accountNonExpired = accountNonExpired;
	}

	public boolean isAccountNonLocked() {
		return accountNonLocked;
	}

	public void setAccountNonLocked(boolean accountNonLocked) {
		this.accountNonLocked = accountNonLocked;
	}

	public boolean isCredentialsNonExpired() {
		return credentialsNonExpired;
	}

	public void setCredentialsNonExpired(boolean credentialsNonExpired) {
		this.credentialsNonExpired = credentialsNonExpired;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	
	
	@OneToOne( fetch = FetchType.LAZY, cascade = CascadeType.ALL )
	@JoinColumn(name = "user_info_pkey")
	public UserInfo getUserInfo() {
		return userInfo;
	}

	public void setUserInfo(UserInfo userInfo) {
		this.userInfo = userInfo;
	}
	
	@Column(name = "is_social_user", columnDefinition="BIT(1) default 0")
	public boolean isSocialUser() {
		return isSocialUser;
	}

	public void setSocialUser(boolean isSocialUser) {
		this.isSocialUser = isSocialUser;
	}

	@Column(name = "avatar_url", columnDefinition="TEXT" )
	public String getAvatarurl() {
		return avatarurl;
	}

	public void setAvatarurl(String avatarurl) {
		this.avatarurl = avatarurl;
	}
	
	
	
	
	
}
