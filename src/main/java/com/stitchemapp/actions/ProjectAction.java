package com.stitchemapp.actions;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.stitchemapp.beans.ProjectPreviewBean;
import com.stitchemapp.entities.Comment;
import com.stitchemapp.entities.Layout;
import com.stitchemapp.entities.Page;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.Tag;
import com.stitchemapp.entities.User;
import com.stitchemapp.services.ContentService;
import com.stitchemapp.services.ProjectService;
import com.stitchemapp.services.PublishingService;
import com.stitchemapp.services.ScreenBuilderService;

public class ProjectAction extends GenericActionSupport {

	public static final Logger LOGGER = Logger.getLogger(ProjectAction.class);
	
	private ProjectService projectService;
	private ContentService contentService;
	
	private ScreenBuilderService screenBuilderService;
	private PublishingService publishingService;
	
	private Project project;
	private Layout layout;
	
	private Page page;
	private List<Page> pages;
	
	private Comment comment;
	private List<Comment> comments;
	
//	private ImageFile imageFile;
//	private InputStream fileStream;
	
	private User user;
	
	// For preview
	private ProjectPreviewBean projectBean;
	
	
	
	@Override
	public void prepare() throws Exception {
		super.prepare();
		
		// Local stuff
		String projPkey = this.request.getParameter("project.pkey");
        if (projPkey != null && StringUtils.isNotEmpty(projPkey)){
            project = projectService.readProject(Integer.valueOf(projPkey));
            if(project != null){
            	layout = project.getLayout();
            	pages = layout.getPages();
            }
        }
        
        String pagePkey = this.request.getParameter("page.pkey");
        if (pagePkey != null && StringUtils.isNotEmpty(pagePkey)){
        	page = screenBuilderService.readPage(Integer.valueOf(pagePkey));
        }
		
        String commentPkey = this.request.getParameter("comment.pkey");
        if (commentPkey != null && StringUtils.isNotEmpty(commentPkey)){
        	comment = projectService.readComment(Integer.valueOf(commentPkey));
        }
        
	}
	
	
	public String prepareProjectInfo(){
		
		// prepare will read the project
		
		projectBean = new ProjectPreviewBean();
		
		projectBean.setPkey(project.getPkey());
		
		projectBean.setPublisher(project.getPublisher());
		
		projectBean.setTitle(project.getTitle());
		projectBean.setDescription(project.getDescription());
		
		projectBean.setProjectType(project.getProjectType());
		projectBean.setHeight(project.getProjectType().height());
		projectBean.setWidth(project.getProjectType().width());
		
		projectBean.setPagesCount(pages.size());
		
		projectBean.setComments(new ArrayList<Comment>());
		

		return SUCCESS;
	}
	
	
	public String prepareProjectView() {

		// project, pages, layout are prepared ..
		if(project != null){
			
			// publisher Info
			user = project.getPublisher();
			comments = projectService.fetchCommentsByProject(project);
		}

		return SUCCESS;
	}
	
	
	public String prepareProjectForEdit(){
		
		// Implementing Authorisation ..
		if(!super.authorizeUserProject(project))
			return ERROR;
		
		if (project != null && project.getPkey() != null ) {
			// prepare will read the project
//			project = projectManager.readProject(project.getPkey());
			
			layout = project.getLayout();
			pages = layout.getPages();
		} 
		
		return SUCCESS;
	
	}

	public String saveProject(){
		
		if (project != null) {
			
			Tag tag = contentService.readTag(project.getTags().get(0).getTitle());
			if (tag == null) 
				return ERROR;
			
			List<Tag> tags = new ArrayList<Tag>();
			tags.add(tag);
			
			if (project.getPkey() != null ){
				projectService.updateProject(project);
			} else {
				if( user == null || user.getEmailId() == null )
					return INPUT;
				
				user = userService.findOrCreateUser(user);
									
				project.setPublisher(user);
				project.setLayout(layout);
				project.setTags(tags);
				
				projectService.createProject(project);
			}
			
		}
		
		return SUCCESS;
	
	}
	
	
	public String deleteProject() {
		
		if (project != null && project.getPkey() != null) {
			projectService.deleteProject(project);
		}
		
		return SUCCESS;

	}
	
	
	
	/* Comments Related */
	
	public String postComment() {
		
		// TODO Authorise .. 
		
		
		// Publisher ...
		if( comment != null && project != null) {
			User user = userService.readUser(comment.getUser().getPkey());

			if (user != null ) {
				comment.setProject(project);
				comment.setUser(user);
				
				if (comment.getPkey() != null) {
					projectService.updateComment(comment);
				} else {
					projectService.createComment(comment);
				}
				
			}
		
		}
		
		return SUCCESS;
	}
	
	public String deleteComment() {
		if (comment != null && comment.getPkey() != null) {
			projectService.deleteComment(comment);
		}
		
		return SUCCESS;
	}
	
	
	
	
	
	/* Getters and Setters */
	
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

	public ScreenBuilderService getScreenBuilderService() {
		return screenBuilderService;
	}

	public void setScreenBuilderService(
			ScreenBuilderService screenBuilderService) {
		this.screenBuilderService = screenBuilderService;
	}

	public PublishingService getPublishingService() {
		return publishingService;
	}

	public void setPublishingService(PublishingService publishingService) {
		this.publishingService = publishingService;
	}
	
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public Layout getLayout() {
		return layout;
	}

	public void setLayout(Layout layout) {
		this.layout = layout;
	}

	public Page getPage() {
		return page;
	}

	public void setPage(Page page) {
		this.page = page;
	}

	public List<Page> getPages() {
	return pages;
	}

	public void setPages(List<Page> pages) {
		this.pages = pages;
	}

	public Comment getComment() {
		return comment;
	}

	public void setComment(Comment comment) {
		this.comment = comment;
	}
	
	public List<Comment> getComments() {
		return comments;
	}

	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public ProjectPreviewBean getProjectBean() {
		return projectBean;
	}

	public void setProjectBean(ProjectPreviewBean projectBean) {
		this.projectBean = projectBean;
	}
	
}
