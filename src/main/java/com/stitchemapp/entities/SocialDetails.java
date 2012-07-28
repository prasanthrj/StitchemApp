package com.stitchemapp.entities;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import com.stitchemapp.enums.SocialAuthProvider;

@Entity
@Table(name = "social_user_details", uniqueConstraints = {
		@UniqueConstraint(columnNames = {"provider_id", "provider_user_id"}),
		@UniqueConstraint(columnNames = {"user_pkey", "provider_id"})
})
@NamedQueries({
	@NamedQuery(name="socialDetails.selectSocialUserByUser", query="SELECT instance from SocialDetails instance where instance.user=:user" ),
	@NamedQuery(name="socialDetails.selectSocialUserByUserAndProviderId", query="SELECT instance from SocialDetails instance where instance.user=:user AND instance.providerId=:providerId" ),
	@NamedQuery(name="socialDetails.selectSocialUserByProviderIdAndProviderUserId", query="SELECT instance from SocialDetails instance where instance.providerId=:providerId AND instance.providerUserId=:providerUserId" )
})
public class SocialDetails extends BaseEntity {
	
	/**
	 * Assumptions :
	 * 
	 * A given user can have a maximum of 1 account connected per SocialProvider
	 * 
	 */
	
	private User user;

	private SocialAuthProvider providerId;
	private String providerUserId;

	private String displayName;
	private String fullName;
	private String emailId;
	
	private String profileUrl;
	private String avatarUrl;

	private String accessToken;
	private String secret;
	private String refreshToken;
	private Long expireTime;
	
	
	
	/* Getters and Setters */
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="user_pkey", nullable = false )
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Enumerated(EnumType.STRING)
	@Column(name = "provider_id", nullable = false )
	public SocialAuthProvider getProviderId() {
		return providerId;
	}

	public void setProviderId(SocialAuthProvider providerId) {
		this.providerId = providerId;
	}

	@Column(name = "provider_user_id")
	public String getProviderUserId() {
		return providerUserId;
	}

	public void setProviderUserId(String providerUserId) {
		this.providerUserId = providerUserId;
	}

	@Column(name = "display_name")
	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	@Column(name = "full_name")
	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	@Column(name = "email_id")
	public String getEmailId() {
		return emailId;
	}

	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}

	@Column(name = "profile_url")
	public String getProfileUrl() {
		return profileUrl;
	}

	public void setProfileUrl(String profileUrl) {
		this.profileUrl = profileUrl;
	}

	@Column(name = "avatar_url")
	public String getAvatarUrl() {
		return avatarUrl;
	}

	public void setAvatarUrl(String imageUrl) {
		this.avatarUrl = imageUrl;
	}

	@Column(name = "access_token", nullable = false )
	public String getAccessToken() {
		return accessToken;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}

	@Column(name = "secret")
	public String getSecret() {
		return secret;
	}

	public void setSecret(String secret) {
		this.secret = secret;
	}

	@Column(name = "refresh_token")
	public String getRefreshToken() {
		return refreshToken;
	}

	public void setRefreshToken(String refreshToken) {
		this.refreshToken = refreshToken;
	}

	@Column(name = "expiry_time")
	public Long getExpireTime() {
		return expireTime;
	}

	public void setExpireTime(Long expireTime) {
		this.expireTime = expireTime;
	}
	
	
}
  
  