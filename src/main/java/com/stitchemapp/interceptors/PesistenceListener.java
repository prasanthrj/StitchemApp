package com.stitchemapp.interceptors;

import java.util.Date;

import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import com.stitchemapp.constants.Constants;
import com.stitchemapp.entities.BaseEntity;

public class PesistenceListener {
	
	public static final Logger LOGGER = Logger.getLogger(PesistenceListener.class);
	
	@PrePersist
	void onPreCreate(Object entity) {
		BaseEntity baseEntity = (BaseEntity) entity;
		baseEntity.setCreatedOn(new Date());
//		baseEntity.setLastUpdatedOn(new Date());
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if(authentication == null) {
			baseEntity.setCreatedBy(Constants.ANONYMOUS_USER_NAME);
		} else{
			String loggedInUser = authentication.getName();
			baseEntity.setCreatedBy(loggedInUser);
//			baseEntity.setLastUpdatedBy(loggedInUser);
		}
	}
	
	@PreUpdate
	void onPreUpdate(Object entity) {
		BaseEntity baseEntity = (BaseEntity) entity;
//		baseEntity.setLastUpdatedOn(new Date());
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if(authentication == null) {
//			baseEntity.setLastUpdatedBy(Constants.ANONYMOUS_USER);
		} else {
			String loggedInUser = authentication.getName();
//			baseEntity.setLastUpdatedBy(loggedInUser);
		}
	}

}
