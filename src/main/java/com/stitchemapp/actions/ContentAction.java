package com.stitchemapp.actions;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.Tag;
import com.stitchemapp.services.ContentService;
import com.stitchemapp.services.ProjectService;

public class ContentAction extends GenericActionSupport {

	public static final Logger LOGGER = Logger.getLogger(ContentAction.class);

	private ContentService contentService;
	private ProjectService projectService;

	private Tag tag;
	private List<Tag> tags;
	
	private List<String> tagTitles;

	private Project project;
	private List<Project> projects;

	/* Methods */

	@Override
	public void prepare() throws Exception {
		super.prepare();
		
		String projPkey = this.request.getParameter("project.pkey");
        if (projPkey != null && StringUtils.isNotEmpty(projPkey)){
            project = projectService.readProject(Integer.valueOf(projPkey));
        }
        
        String tagPkey = this.request.getParameter("tag.pkey");
        if (tagPkey != null && StringUtils.isNotEmpty(tagPkey)){
            tag = contentService.readTag(Integer.valueOf(tagPkey));
        }
        
        

	}
	
	
	/* Moderator related */
	
	public String prepareAdminHome() {
		if (!loggedInUser.getUsername().equals("admin"))
			return ERROR;
		
		projects = projectService.fetchAllUnVerifiedProjects();
		tags = contentService.fetchAllTags();
		
		return SUCCESS;
	}

	
	/* projects */
	
	public String approveProject(){
		
		if (!loggedInUser.getUsername().equals("admin"))
			return ERROR;
		
		if (project != null) 
			projectService.toggleProjectApprovalStatus(project, Boolean.TRUE);
		
		return SUCCESS;
	};
	
	
	public String rejectProject(){
		
		if (!loggedInUser.getUsername().equals("admin"))
			return ERROR;
		
		if (project != null) 
			projectService.toggleProjectApprovalStatus(project, Boolean.FALSE);
		
		return SUCCESS;
	};
	
	
	

	/* tags */
	
	public String prepareTagsList(){
		
		tags = contentService.fetchAllTags();
		if (tags == null)
			tags = new ArrayList<Tag>();

		tagTitles = new ArrayList<String>();
		for (Tag tag : tags) {
			tagTitles.add(tag.getTitle());
		}
		
		return SUCCESS;
	}
	
	public String saveTag() {
		
		if (!loggedInUser.getUsername().equals("admin"))
			return ERROR;
		
		if (tag != null) {
			if (tag.getPkey() != null) {
				contentService.updateTag(tag);
			} else {
				contentService.createTag(tag);
			}
		}
		
		return SUCCESS;
	}

	public String deleteTag() {
		
		if (!loggedInUser.getUsername().equals("admin"))
			return ERROR;

		if (tag != null) 
			contentService.deleteTag(tag);
		
		return SUCCESS;
	}
	
	
	
	
	
	

	/* Getters and Setters */

	public ContentService getContentService() {
		return contentService;
	}

	public void setContentService(ContentService contentService) {
		this.contentService = contentService;
	}

	public ProjectService getProjectService() {
		return projectService;
	}

	public void setProjectService(ProjectService projectService) {
		this.projectService = projectService;
	}

	public Tag getTag() {
		return tag;
	}

	public void setTag(Tag tag) {
		this.tag = tag;
	}

	public List<Tag> getTags() {
		return tags;
	}

	public void setTags(List<Tag> tags) {
		this.tags = tags;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public List<Project> getProjects() {
		return projects;
	}

	public void setProjects(List<Project> projects) {
		this.projects = projects;
	}

}
