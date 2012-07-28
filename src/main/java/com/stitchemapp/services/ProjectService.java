package com.stitchemapp.services;

import java.util.List;

import com.stitchemapp.entities.Comment;
import com.stitchemapp.entities.Layout;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.ProjectType;

public interface ProjectService {
	
	/* Project CRUD */
	
	void createProject(Project project);
	
	Project readProject(Integer pkey);
	
	void updateProject(Project project);
	
	void deleteProject(Project project);
	
	

	
	
	Integer fetchAllProjectsCount();
	
	Integer fetchPublicProjectsCount();
	
	// Should not be used ...
	List<Project> fetchAllPublicProjects();
	
	// Should not be used ...
	List<Project> fetchPublicProjectsByType(ProjectType projectType);
	
	List<Project> fetchPublicProjectsPaginated(Integer pageNumber, Integer pageSize);
	
	List<Project> fetchPublicProjectsByTypePaginated(ProjectType projectType, Integer pageNumber, Integer pageSize);
	
	List<Project> fetchProjectsByPublisher(User publisher);
	
	List<Project> fetchPublicProjectsByPublisher(User publisher);
	
	
	
	
	/* For Moderator */
	
	List<Project> fetchAllUnVerifiedProjects();
	
	void toggleProjectApprovalStatus(Project project, Boolean isApproved);
	
	
	
	
	
	/* Project CRUD */
	
	void createLayout(Layout layout);
	
	Layout readLayout(Integer pkey);
	
	void updateLayout(Layout layout);
	
	void deleteLayout(Layout layout);
	
	
	
	/* Project Comment CRUD */

	void createComment(Comment comment);
	
	Comment readComment(Integer pkey);
	
	void updateComment(Comment comment);
	
	void deleteComment(Comment comment);
	
	
	List<Comment> fetchCommentsByProject(Project project);
		

}
