package com.stitchemapp.analytics.entities;

import java.util.List;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.stitchemapp.entities.BaseEntity;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.User;

@Entity
@Table(name = "analytics_applications")
public class Application extends BaseEntity {

	private Project project;

	private User publisher;
	private List<User> userGroup;

	
	
	/* Getters and Setters */

	@OneToOne
	@JoinColumn(name = "project_pkey")
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	@OneToOne
	@JoinColumn(name = "user_pkey")
	public User getPublisher() {
		return publisher;
	}

	public void setPublisher(User publisher) {
		this.publisher = publisher;
	}

	
	@ManyToMany(fetch = FetchType.LAZY )
	@JoinTable(name = "application_to_users_mapping_table", 
			joinColumns = @JoinColumn(name = "application_pkey"),
			inverseJoinColumns = @JoinColumn(name = "application_user_pkey"))
	public List<User> getUserGroup() {
		return userGroup;
	}

	public void setUserGroup(List<User> userGroup) {
		this.userGroup = userGroup;
	}
	

}
