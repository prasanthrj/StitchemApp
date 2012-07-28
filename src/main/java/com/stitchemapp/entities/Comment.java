package com.stitchemapp.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "comments")
@NamedQueries({
	@NamedQuery(name="comment.selectCommentsByPage", query="SELECT instance from Comment instance WHERE instance.page=:page ORDER BY instance.createdOn DESC" ),
	@NamedQuery(name="comment.selectCommentsByProject", query="SELECT instance from Comment instance WHERE instance.project=:project ORDER BY instance.createdOn DESC" )
})
public class Comment extends BaseEntity {

	private User user;

	private String subject;
	private String body;

	private Page page;
	private Project project;
	
	
	/* Getters and Setters */
	
	@ManyToOne (fetch = FetchType.LAZY)
	@JoinColumn(name = "author_pkey")
	public User getUser() {
		return user;
	}

	public void setUser(User appUser) {
		this.user = appUser;
	}

	@Column(name = "subject")
	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	@Column(name = "body", columnDefinition = "TEXT", nullable = false)
	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	@ManyToOne (fetch = FetchType.LAZY)
	@JoinColumn(name = "page_pkey")
	public Page getPage() {
		return page;
	}

	public void setPage(Page page) {
		this.page = page;
	}

	@ManyToOne (fetch = FetchType.LAZY)
	@JoinColumn(name = "project_pkey")
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

}
