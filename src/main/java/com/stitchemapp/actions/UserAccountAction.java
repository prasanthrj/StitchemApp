package com.stitchemapp.actions;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.User;
import com.stitchemapp.entities.UserInfo;
import com.stitchemapp.entities.UserNotifications;
import com.stitchemapp.services.ProjectService;
import com.stitchemapp.services.UserAccountService;

public class UserAccountAction extends GenericActionSupport {
	
	public static final Logger LOGGER = Logger.getLogger(UserAccountAction.class);

	private UserAccountService userAccountService;
	private ProjectService projectService;
	
	private UserNotifications notifications;
	private List<Project> projects;
	
	private User user;
	private UserInfo userInfo;
	
	
	@Override
	public void prepare() throws Exception {
		super.prepare();
				
		if (!loggedInUser.getUsername().equals("anonymousUser")) {
			notifications = loggedInUser.getNotifications();
		}
		
		String userPkey = this.request.getParameter("user.pkey");
        if (userPkey != null && StringUtils.isNotEmpty(userPkey)){
            user = this.userService.readUser(Integer.valueOf(userPkey));
        }
        
		
	}
	
	public String prepareUserHome() {
		
		// User Projects ..
		if (!loggedInUser.getUsername().equals("anonymousUser")) {
			
			// All Projects
			projects = projectService.fetchProjectsByPublisher(loggedInUser);
		}
		
		return SUCCESS;
	}
	
	public String prepareUserProfile() {
		
		// User Projects ..
		if (user != null && user.getPkey() != null) {
			userInfo = user.getUserInfo();
			
			// User's approved public projects
			projects = projectService.fetchPublicProjectsByPublisher(user);
			
		}
		
		return SUCCESS;
	}
	
	
	

	
	/* Getters and Setters */
	
	
	public UserAccountService getUserAccountService() {
		return userAccountService;
	}

	public void setUserAccountService(UserAccountService userAccountService) {
		this.userAccountService = userAccountService;
	}

	public ProjectService getProjectService() {
		return projectService;
	}

	public void setProjectService(ProjectService projectService) {
		this.projectService = projectService;
	}
	
	public UserNotifications getNotifications() {
		return notifications;
	}

	public void setNotifications(UserNotifications notifications) {
		this.notifications = notifications;
	}

	public List<Project> getProjects() {
		return projects;
	}

	public void setProjects(List<Project> projects) {
		this.projects = projects;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public UserInfo getUserInfo() {
		return userInfo;
	}

	public void setUserInfo(UserInfo userInfo) {
		this.userInfo = userInfo;
	}
	
}
