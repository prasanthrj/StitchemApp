package com.stitchemapp.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "project_publish_details")
public class PublishDetails extends BaseEntity {
	
	private String notes;
	
	private Page landingPage;
	
	private Boolean isPublished = false;
	private String passKey;
	
	
	/* Getters and Setters */
	
	
	@Column(name = "publish_notes", columnDefinition = "TEXT")
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	@OneToOne
	@JoinColumn( name = "landing_page_pkey" )
	public Page getLandingPage() {
		return landingPage;
	}

	public void setLandingPage(Page landingPage) {
		this.landingPage = landingPage;
	}

	@Column(name = "is_published", columnDefinition="BIT(1) default 0")
	public Boolean getIsPublished() {
		return isPublished;
	}

	public void setIsPublished(Boolean isPublished) {
		this.isPublished = isPublished;
	}
	
	@Column(name = "pass_key")
	public String getPassKey() {
		return passKey;
	}

	public void setPassKey(String passKey) {
		this.passKey = passKey;
	}

	
}
