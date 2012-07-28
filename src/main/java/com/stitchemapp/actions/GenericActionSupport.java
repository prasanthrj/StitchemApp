package com.stitchemapp.actions;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.interceptor.ServletRequestAware;
import org.springframework.security.core.context.SecurityContextHolder;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.Preparable;
import com.stitchemapp.beans.MessageBean;
import com.stitchemapp.constants.Constants;
import com.stitchemapp.entities.Page;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.User;
import com.stitchemapp.security.UserService;

public class GenericActionSupport extends ActionSupport implements Preparable, ServletRequestAware {

	protected HttpServletRequest request;
	protected UserService userService;

	protected MessageBean messageBean = new MessageBean();

	protected User loggedInUser;
	
	
	
	// Default action method
	public String execute() {
		return SUCCESS;
	}
	
	public void prepare() throws Exception {
		this.prepareLoggedinUserDetails();
		
		// Override to prepare the required fields
		
	}
	

	public void prepareLoggedinUserDetails() {
		
		if( SecurityContextHolder.getContext() != null && SecurityContextHolder.getContext().getAuthentication() != null) {
			
			String loggedInUserName = SecurityContextHolder.getContext().getAuthentication().getName();
			
			if (loggedInUserName.equals(Constants.ANONYMOUS_USER_NAME)) {
				loggedInUser = new User();
				loggedInUser.setUsername(loggedInUserName);
			} else {
				loggedInUser = userService.readUser(loggedInUserName);
			}
			
//			System.out.println(loggedInUserName);
		
		}
		
//		System.out.println(loggedInUser.getUsername());
//		System.out.println(loggedInUser.getAuthorities());

	}
	
	
	
	/* Authorisation methods */
	
	public boolean authorizeUserProject(Project project){
		
		if (project == null) 
			return true;
		
		if ( project.getPublisher() != null && !loggedInUser.getUsername().equals(project.getPublisher().getUsername()))
			return false;
		
		return true;
	
	}
	
	
	public boolean authorizeProjectPage(Project project, Page page){
		
		if(!this.authorizeUserProject(project))
			return false;
		
		if( project == null || page == null || project.getLayout().getPages() == null )
			return true;
		
		List<Page> pages = project.getLayout().getPages();
		if(!(pages.size() > 0))
			return false;
		
		if (!pages.contains(page))
			return false;		
		
		return true;
		
	}
	
	
	
	
	

	/* Getters and Setters */
	
	public void setServletRequest(HttpServletRequest httpServletRequest) {
		this.request = httpServletRequest;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public MessageBean getMessageBean() {
		if(messageBean == null)
			messageBean = new MessageBean();
		return messageBean;
	}

	public void setMessageBean(MessageBean messageBean) {
		this.messageBean = messageBean;
	}

	public User getLoggedInUser() {
		return loggedInUser;
	}

	public void setLoggedInUser(User loggedInUser) {
		this.loggedInUser = loggedInUser;
	}
	
}
