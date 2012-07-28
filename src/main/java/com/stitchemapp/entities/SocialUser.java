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

//@Entity
//@Table(name = "social_users", uniqueConstraints = {
//		@UniqueConstraint(columnNames = {"user_id", "provider_id", "provider_user_id"}),
//		@UniqueConstraint(columnNames = {"user_id", "provider_id", "rank"})
//})
//@NamedQueries({
//	@NamedQuery(name="socialUser.selectUserByUserId", query="SELECT instance from SocialUser instance where instance.userId=:userId" ),
//	@NamedQuery(name="socialUser.selectUserByUserIdAndProviderId", query="SELECT instance from SocialUser instance where instance.userId=:userId AND instance.providerId=:providerId" ),
//	@NamedQuery(name="socialUser.selectUserByUserIdProviderIdAndProviderUserId", query="SELECT instance from SocialUser instance where instance.userId=:userId AND instance.providerId=:providerId AND instance.providerUserId=:providerUserId" )
//})
public class SocialUser extends BaseEntity {
	
	
	private User user;

	private String userId;
	
	private SocialAuthProvider providerId;
	private String providerUserId;

	private int rank;

	private String displayName;
	private String profileUrl;
	private String imageUrl;

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
	
	
	
	

	@Column(name = "user_id")
	public String getUserId() {
		
		if ( userId == null && user != null ) 
			userId = user.getPkey().toString();
		
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
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

	@Column(name = "rank", nullable = false )
	public int getRank() {
		return rank;
	}

	public void setRank(int rank) {
		this.rank = rank;
	}

	@Column(name = "display_name")
	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	@Column(name = "profile_url")
	public String getProfileUrl() {
		return profileUrl;
	}

	public void setProfileUrl(String profileUrl) {
		this.profileUrl = profileUrl;
	}

	@Column(name = "image_url")
	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
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
  
  