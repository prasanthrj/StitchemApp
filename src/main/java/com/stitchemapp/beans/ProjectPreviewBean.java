package com.stitchemapp.beans;

import java.util.List;

import com.stitchemapp.entities.Comment;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.ProjectType;

public class ProjectPreviewBean {
	
	private Integer pkey;

	private User publisher;
	
	private String title;
	private String description;
	
	private ProjectType projectType;
	private Integer width;
	private Integer height;

	private Integer pagesCount;

	private List<Comment> comments;

	private Integer viewsCount;
	private float rating;

	
	
	
	/* Getters and Setters */
	
	

	public Integer getPkey() {
		return pkey;
	}

	public void setPkey(Integer pkey) {
		this.pkey = pkey;
	}

	public User getPublisher() {
		return publisher;
	}

	public void setPublisher(User publisher) {
		this.publisher = publisher;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public ProjectType getProjectType() {
		if(projectType == null)
			projectType = ProjectType.IPhone;
		return projectType;
	}

	public void setProjectType(ProjectType projectType) {
		this.projectType = projectType;
	}

	public Integer getWidth() {
		if(width == null)
			width = getProjectType().width();
		return width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	public Integer getHeight() {
		if(height == null)
			height = getProjectType().height();
		return height;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	public Integer getPagesCount() {
		return pagesCount;
	}

	public void setPagesCount(Integer pagesCount) {
		this.pagesCount = pagesCount;
	}

	public List<Comment> getComments() {
		return comments;
	}

	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}

	public Integer getViewsCount() {
		return viewsCount;
	}

	public void setViewsCount(Integer viewsCount) {
		this.viewsCount = viewsCount;
	}

	public float getRating() {
		return rating;
	}

	public void setRating(float rating) {
		this.rating = rating;
	}
	
	
	
}
