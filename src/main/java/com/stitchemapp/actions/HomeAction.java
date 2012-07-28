package com.stitchemapp.actions;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.stitchemapp.constants.Constants;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.SocialDetails;
import com.stitchemapp.entities.User;
import com.stitchemapp.security.SocialAuthenticationProvider;
import com.stitchemapp.security.SocialConnectionService;
import com.stitchemapp.security.SocialUserDetailsService;
import com.stitchemapp.security.impl.SecurityUtil;
import com.stitchemapp.services.ContentService;
import com.stitchemapp.services.ProjectService;

public class HomeAction extends GenericActionSupport implements ApplicationContextAware {
	
	public static final Logger LOGGER = Logger.getLogger(HomeAction.class);
	
	private ApplicationContext applicationContext;
	
	private SocialUserDetailsService socialUserDetailsService;
	private SocialConnectionService socialConnectionService;
	
	private ProjectService projectService;
	private ContentService contentService;

	private User user;
	private SocialDetails socialDetails;
	
	private List<Project> projects;
	
	private Integer projectsCount;
	private Integer publicProjectsCount;
	
	private Integer pageNumber;
	private Integer pageSize = Constants.DEFAULT_PAGE_SIZE;
	
	
	/* Methods */
	
	@Override
	public void prepare() throws Exception {
		super.prepare();
		
	}
	
	
	public String prepareHome() {
		
		projects = projectService.fetchPublicProjectsPaginated( Constants.DEFAULT_PAGE_NUMBER, Constants.DEFAULT_PAGE_SIZE );

		projectsCount = projectService.fetchAllProjectsCount();
		publicProjectsCount = projectService.fetchPublicProjectsCount();
		
		return SUCCESS;
	}
	
	public String fetchPublicProjects() {
		
		if(pageNumber == null)
			pageNumber = Constants.DEFAULT_PAGE_NUMBER;
		
		if(pageSize == null)
			pageSize = Constants.DEFAULT_PAGE_SIZE;
		
		projects = projectService.fetchPublicProjectsPaginated( pageNumber, pageSize );		
		
		return SUCCESS;
	}
	
	
	
	public String prepareStaticPage() {
		
		// TODO prepare Static Content pages
		
		
		return SUCCESS;
	}
	
	
	public String prepareSignUp() {
		
		if (!loggedInUser.getUsername().equals(Constants.ANONYMOUS_USER_NAME)) 
			return NONE;
		
		String authProvider = request.getParameter(Constants.AUTH_PROVIDER_PARAMETER);
		if (authProvider != null) {
			
			SocialAuthenticationProvider authenticationProvider = (SocialAuthenticationProvider) applicationContext.getBean(authProvider);
			socialConnectionService = authenticationProvider.getSocialConnectionService();
			
			socialDetails = socialConnectionService.fetchBasicSocialDetails();
			user = userService.readUserByEmailId(socialDetails.getEmailId());
			
			if (user != null) {
				
				// Registered User				
				
				SocialDetails exSocialDetails = socialUserDetailsService.findUserSocialDetailsByProviderAndProviderUserId(socialDetails.getProviderId(), socialDetails.getProviderUserId());
				if (exSocialDetails == null) {
					// New Social Connection ...

					socialDetails.setUser(user);
					socialUserDetailsService.createSocialDetails(socialDetails);					
					
				}
								
				SecurityUtil.signInUser(user);
				super.prepareLoggedinUserDetails();
				
				return NONE;

			}

		}
				
		return SUCCESS;
	}


	
	
	
	
	/* Getters and Setters */

	public ApplicationContext getApplicationContext(){
		return applicationContext;
	}
	
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.applicationContext = applicationContext;
	}	

	public SocialUserDetailsService getSocialUserDetailsService() {
		return socialUserDetailsService;
	}

	public void setSocialUserDetailsService(
			SocialUserDetailsService socialUserDetailsService) {
		this.socialUserDetailsService = socialUserDetailsService;
	}

	public SocialConnectionService getSocialConnectionService() {
		return socialConnectionService;
	}

	public void setSocialConnectionService(
			SocialConnectionService socialConnectionService) {
		this.socialConnectionService = socialConnectionService;
	}

	public ProjectService getProjectService() {
		return projectService;
	}

	public void setProjectService(ProjectService projectService) {
		this.projectService = projectService;
	}

	public ContentService getContentService() {
		return contentService;
	}

	public void setContentService(ContentService contentService) {
		this.contentService = contentService;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public SocialDetails getSocialDetails() {
		return socialDetails;
	}

	public void setSocialDetails(SocialDetails socialDetails) {
		this.socialDetails = socialDetails;
	}

	public List<Project> getProjects() {
		return projects;
	}

	public void setProjects(List<Project> projects) {
		this.projects = projects;
	}

	public Integer getProjectsCount() {
		return projectsCount;
	}

	public void setProjectsCount(Integer projectsCount) {
		this.projectsCount = projectsCount;
	}

	public Integer getPublicProjectsCount() {
		return publicProjectsCount;
	}

	public void setPublicProjectsCount(Integer publicProjectsCount) {
		this.publicProjectsCount = publicProjectsCount;
	}

	public Integer getPageNumber() {
		return pageNumber;
	}

	public void setPageNumber(Integer pageNumber) {
		this.pageNumber = pageNumber;
	}

	public Integer getPageSize() {
		return pageSize;
	}

	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}

}
