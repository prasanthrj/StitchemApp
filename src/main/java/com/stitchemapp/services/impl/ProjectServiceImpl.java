package com.stitchemapp.services.impl;

import java.util.Hashtable;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;

import com.stitchemapp.api.IDao;
import com.stitchemapp.constants.Constants;
import com.stitchemapp.entities.Comment;
import com.stitchemapp.entities.Layout;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.PublishDetails;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.OrientationType;
import com.stitchemapp.enums.ProjectType;
import com.stitchemapp.services.ProjectService;
import com.stitchemapp.services.ScreenBuilderService;

public class ProjectServiceImpl implements ProjectService {
	
	public static final Logger LOGGER = Logger.getLogger(ProjectServiceImpl.class);
	
	private IDao genericDao;
	
	private ScreenBuilderService projectBuilderService;

	
	
	
	@Transactional
	public void createProject(Project project) {
		if(project != null) {
			
			// Save Layout
			if(project.getProjectType() != null && 
					!(project.getProjectType().equals(ProjectType.Custom))) {
				
				Layout layout = project.getLayout();
				if(layout == null)
					layout = new Layout();
				
				OrientationType orientation = layout.getOrientation();
				layout.setHeight(project.getProjectType().layoutHeight(orientation));
				layout.setWidth(project.getProjectType().layoutWidth(orientation));
				
				project.setLayout(layout);
				
			}
			
			// Save Publish datails ...
			
			PublishDetails publishDetails = new PublishDetails();
			publishDetails.setNotes(project.getDescription());
			
			project.setPublishDetails(publishDetails);
			genericDao.save(project);
			
			
			// Setting the title ..
			
			if (project.getTitle() == null) 
				project.setTitle(Constants.DEFAULT_PROJECT_TITLE + '-' + project.getPkey());
			
			genericDao.update(project);
			
		}
	}

	public Project readProject(Integer pkey) {
		return genericDao.find(Project.class, pkey);
	}

	@Transactional
	public void updateProject(Project project) {
		if(project != null) {
			
			if(project.getProjectType() != null && 
					!(project.getProjectType().equals(ProjectType.Custom))) {
			
				if(project.getProjectType().height() != project.getLayout().getHeight() 
						|| project.getProjectType().width() != project.getLayout().getWidth() ) {
					
					Layout layout = project.getLayout();

					OrientationType orientation = layout.getOrientation();
					layout.setHeight(project.getProjectType().layoutHeight(orientation));
					layout.setWidth(project.getProjectType().layoutWidth(orientation));
					
					project.setLayout(layout);
					
				}
			}
			
			genericDao.update(project);
		}
	}

	@Transactional
	public void deleteProject(Project project) {
		if(project != null) {
			genericDao.delete(project);
		}
	}
	
	
	
	
	
	public Integer fetchAllProjectsCount() {
		return genericDao.fetchEntitiesCount(Project.class);
	}
	
	public Integer fetchPublicProjectsCount() {
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("isPublic", Boolean.TRUE );
		criteria.put("isApproved", Boolean.TRUE );
		return genericDao.fetchEntitiesCount(Project.class, criteria);
	}
	
	public List<Project> fetchAllPublicProjects(){
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("isPublic", Boolean.TRUE );
		criteria.put("isApproved", Boolean.TRUE );
		return genericDao.getEntities(Project.class, "project.selectProjectsByVisibilityAndApproval", criteria);
		
	}
	
	public List<Project> fetchPublicProjectsByType(ProjectType projectType) {
		
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("projectType", projectType);
		criteria.put("isPublic", Boolean.TRUE );
		criteria.put("isApproved", Boolean.TRUE );
		
		return genericDao.getEntities(Project.class, "project.selectPublicProjectsByPublisher",criteria);
	}
	
	

	
	public List<Project> fetchPublicProjectsPaginated(Integer pageNumber, Integer pageSize) {
		
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("isPublic", Boolean.TRUE );
		criteria.put("isApproved", Boolean.TRUE );
		
//        String sortColumn = "description";
//        String sortOrder = "asc";

        return genericDao.getEntities(Project.class, "project.selectProjectsByVisibilityAndApproval", criteria, pageNumber, pageSize);
		
	}
	
	public List<Project> fetchPublicProjectsByTypePaginated(ProjectType projectType, Integer pageNumber, Integer pageSize) {
		
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("projectType", projectType);
		criteria.put("isPublic", Boolean.TRUE );
		criteria.put("isApproved", Boolean.TRUE );
		
//        String sortColumn = "description";
//        String sortOrder = "asc";

        return genericDao.getEntities(Project.class, "project.selectPublicProjectsByType", criteria, pageNumber, pageSize);
        
	}
	
	public List<Project> fetchProjectsByPublisher(User publisher){
		
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("publisher", publisher);
		
		return genericDao.getEntities(Project.class, "project.selectProjectsByPublisher",criteria);
	}
	
	public List<Project> fetchPublicProjectsByPublisher(User publisher){
		
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("publisher", publisher);
		criteria.put("isPublic", Boolean.TRUE );
		criteria.put("isApproved", Boolean.TRUE );
		
		return genericDao.getEntities(Project.class, "project.selectPublicProjectsByPublisher",criteria);
	}
	
	
	
	
	
	
	
	
	
	/* For Moderator */

	public List<Project> fetchAllUnVerifiedProjects() {
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("isPublic", Boolean.TRUE );
		criteria.put("isApproved", Boolean.FALSE );
		return genericDao.getEntities(Project.class, "project.selectProjectsByVisibilityAndApproval", criteria);
	}
	
	@Transactional
	public void toggleProjectApprovalStatus(Project project, Boolean isApproved){
		if(project != null) {
			project.setIsApproved(isApproved);
			
			this.updateProject(project);
		}
	}
	
	
	
	
	
	
	
	
	/* layout CRUD + related */
	
	@Transactional
	public void createLayout(Layout layout) {
		if(layout != null) {
			genericDao.save(layout);
		}
	}

	public Layout readLayout(Integer pkey) {
		// TODO Auto-generated method stub
		return null;
	}

	@Transactional
	public void updateLayout(Layout layout) {
		if(layout != null) {
			genericDao.update(layout);
		}
	}

	@Transactional
	public void deleteLayout(Layout layout) {
		if(layout != null) {
			genericDao.delete(layout);
		}
	}
	
	
	
	
	/* Comments related */
	
	@Transactional
	public void createComment(Comment comment) {
		if(comment != null) {
			genericDao.save(comment);
		}
	}

	public Comment readComment(Integer pkey) {
		// TODO Auto-generated method stub
		return null;
	}

	@Transactional
	public void updateComment(Comment comment) {
		if(comment != null) {
			genericDao.update(comment);
		}
	}

	@Transactional
	public void deleteComment(Comment comment) {
		if(comment != null) {
			genericDao.delete(comment);
		}
	}
	
	
	public List<Comment> fetchCommentsByProject(Project project) {
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("project", project );
		return genericDao.getEntities(Comment.class, "comment.selectCommentsByProject", criteria);
		
	}
	
	
	
	
	/* Getters and Setters */
	
	public IDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}

	public ScreenBuilderService getProjectBuilderService() {
		return projectBuilderService;
	}

	public void setProjectBuilderService(ScreenBuilderService projectBuilderService) {
		this.projectBuilderService = projectBuilderService;
	}

	

}
