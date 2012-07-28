package com.stitchemapp.actions;

import java.util.Date;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.stitchemapp.analytics.ActionRecorder;
import com.stitchemapp.analytics.entities.Event;
import com.stitchemapp.analytics.entities.Visit;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.User;
import com.stitchemapp.services.ProjectService;
import com.stitchemapp.services.PublishingService;

public class AnalyticsFeedForwardAction extends GenericActionSupport {

	public static final Logger LOGGER = Logger.getLogger(AnalyticsFeedForwardAction.class);
	
	private ProjectService projectManager;
	private PublishingService publishingManager;
	
	private ActionRecorder actionRecorder;
	
	private Project project;
	private User appUser;
	
	private Event event;
	private Visit visit;
	
	
	@Override
	public void prepare() throws Exception {
		super.prepare();
		
		String project_pkey = this.request.getParameter("project.pkey");
        if (project_pkey != null && StringUtils.isNotEmpty(project_pkey)){
            project = projectManager.readProject(Integer.valueOf(project_pkey));
        }
        
        String appUserPkey = this.request.getParameter("appUser.pkey");
        if (appUserPkey != null && StringUtils.isNotEmpty(appUserPkey)){
        	appUser = userService.readUser(Integer.valueOf(appUserPkey));
        }
        
	
	}


	public String saveProjectPageVisit(){
		
		if ( request != null ) {
			
			if(visit == null)
				visit = new Visit();
			
			
//			System.out.println(visit.getPageURI());
			
//			System.out.println("SessionId :" + request.getSession(true).getId());
//
//			System.out.println("---------------------------------#-------------------------------------");
//
//			System.out.println("RemoteAddr :" + request.getRemoteAddr());
//			System.out.println("User-Agent :" + request.getHeader("User-Agent"));
//
//			System.out.println("---------------------------------#-------------------------------------");
//
//			System.out.println("Host :" + request.getHeader("Host"));
//
//			System.out.println("---------------------------------#-------------------------------------");

			visit.setUser(appUser);
			visit.setProject(project);
			
			visit.setHostIP(request.getHeader("Host"));
			visit.setUserIp(request.getRemoteAddr());
			
			visit.setUserAgent(request.getHeader("User-Agent"));
			
			visit.setSessionId(request.getSession(true).getId());
			visit.setTimeStamp(new Date());
			
//			visit.setPageURI(request.getRequestURI());
			
			actionRecorder.recordVisit(visit);
			
			
		}
		
		return SUCCESS;
	}
	
	
	public String saveProjectPageEvent(){
		
		if (event != null && this.request != null ) {
			
			
		}
			
		return SUCCESS;
	}

	
	
	
	
	/* Getters and Setters */

	public ProjectService getProjectManager() {
		return projectManager;
	}

	public void setProjectManager(ProjectService projectManager) {
		this.projectManager = projectManager;
	}

	public PublishingService getPublishingManager() {
		return publishingManager;
	}

	public void setPublishingManager(PublishingService publishingManager) {
		this.publishingManager = publishingManager;
	}

	public ActionRecorder getActionRecorder() {
		return actionRecorder;
	}

	public void setActionRecorder(ActionRecorder actionRecorder) {
		this.actionRecorder = actionRecorder;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public User getAppUser() {
		return appUser;
	}

	public void setAppUser(User appUser) {
		this.appUser = appUser;
	}

	public Event getEvent() {
		return event;
	}

	public void setEvent(Event event) {
		this.event = event;
	}

	public Visit getVisit() {
		return visit;
	}

	public void setVisit(Visit visit) {
		this.visit = visit;
	}

}
