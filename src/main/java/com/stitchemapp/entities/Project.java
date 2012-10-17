package com.stitchemapp.entities;

import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.search.annotations.Field;
import org.hibernate.search.annotations.Index;
import org.hibernate.search.annotations.Indexed;
import org.hibernate.search.annotations.IndexedEmbedded;
import org.hibernate.search.annotations.Store;

import com.stitchemapp.enums.ProjectType;

@Entity
@Table(name = "projects")
@NamedQueries({
	@NamedQuery(name="project.selectProjectsByPublisher", query="SELECT instance from Project instance where instance.publisher=:publisher" ),
	@NamedQuery(name="project.selectProjectsByVisibilityAndApproval", query="SELECT instance from Project instance where instance.isPublic=:isPublic AND instance.isApproved=:isApproved" ),
	@NamedQuery(name="project.selectPublicProjectsByPublisher", 
		query="SELECT instance from Project instance where instance.publisher=:publisher AND instance.isPublic=:isPublic AND instance.isApproved=:isApproved" ),
	@NamedQuery(name="project.selectPublicProjectsByType", 
		query="SELECT instance from Project instance where instance.projectType=:projectType AND instance.isPublic=:isPublic AND instance.isApproved=:isApproved" )
})
@Indexed(index="project_index")
public class Project extends BaseEntity {
	
	private User publisher;
	
	private ProjectType projectType;
	
	@Field(index=Index.TOKENIZED, store=Store.YES)
	private String title;

	@Field(index=Index.TOKENIZED, store=Store.YES)
	private String description;
	
	private List<ImageFile> images;
	
	private Layout layout;
	
	@IndexedEmbedded(depth=1, prefix="tag_")
	private List<Tag> tags;
	
	private PublishDetails publishDetails;
	
	private Boolean isPublic = false;
	private Boolean isApproved = false;
	
	// For cascading.. 
	private Set<User> appUsers;
	private List<Comment> comments;
	
	
	/* Getters and Setters */
	
	@ManyToOne
	@JoinColumn(name = "publisher_pkey", nullable = false )
	public User getPublisher() {
		return publisher;
	}

	public void setPublisher(User publisher) {
		this.publisher = publisher;
	}

	@Enumerated(EnumType.STRING)
	@Column(name = "project_type", nullable = false)
	public ProjectType getProjectType() {
		return projectType;
	}

	public void setProjectType(ProjectType projectType) {
		this.projectType = projectType;
	}

	@Column(name = "title")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Column(name = "description", columnDefinition = "TEXT")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@OneToMany(fetch = FetchType.LAZY, mappedBy="project")
	public List<ImageFile> getImages() {
		return images;
	}

	public void setImages(List<ImageFile> images) {
		this.images = images;
	}

	@OneToOne (fetch = FetchType.LAZY, cascade = CascadeType.ALL )
	@JoinColumn(name = "project_layout_pkey")
	public Layout getLayout() {
		return layout;
	}

	public void setLayout(Layout layout) {
		this.layout = layout;
	}

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "project_to_tags",
			joinColumns = @JoinColumn(name = "project_pkey"),
			inverseJoinColumns = @JoinColumn(name = "tag_pkey"))
	public List<Tag> getTags() {
		return tags;
	}

	public void setTags(List<Tag> tags) {
		this.tags = tags;
	}

	@OneToOne (fetch = FetchType.LAZY, cascade = CascadeType.ALL )
	@JoinColumn(name = "project_publish_details_pkey")
	public PublishDetails getPublishDetails() {
		return publishDetails;
	}

	public void setPublishDetails(PublishDetails publishDetails) {
		this.publishDetails = publishDetails;
	}

	@Column(name = "is_public", columnDefinition="BIT(1) default 0")
	public Boolean getIsPublic() {
		return isPublic;
	}

	public void setIsPublic(Boolean isPublic) {
		this.isPublic = isPublic;
	}

	@Column(name = "is_approved_by_moderator", columnDefinition="BIT(1) default 0")
	public Boolean getIsApproved() {
		return isApproved;
	}

	public void setIsApproved(Boolean isApproved) {
		this.isApproved = isApproved;
	}
	
	@ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinTable(name = "project_app_users_mapping_table", 
			joinColumns = @JoinColumn(name = "project_pkey"),
			inverseJoinColumns = @JoinColumn(name = "app_user_pkey"))
	public Set<User> getAppUsers() {
		return appUsers;
	}

	public void setAppUsers(Set<User> appUsers) {
		this.appUsers = appUsers;
	}

	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.REMOVE, mappedBy="project")
	public List<Comment> getComments() {
		return comments;
	}

	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}
	
}
