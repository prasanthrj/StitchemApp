package com.stitchemapp.entities;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "user_notifications")
public class UserNotifications extends BaseEntity {

	private Integer projectsCount;
	private Integer feedbacksCount;
	private Integer messagesCount;
	
	

	public Integer getProjectsCount() {
		return projectsCount;
	}

	public void setProjectsCount(Integer projectsCount) {
		this.projectsCount = projectsCount;
	}

	public Integer getFeedbacksCount() {
		return feedbacksCount;
	}

	public void setFeedbacksCount(Integer feedbacksCount) {
		this.feedbacksCount = feedbacksCount;
	}

	public Integer getMessagesCount() {
		return messagesCount;
	}

	public void setMessagesCount(Integer messagesCount) {
		this.messagesCount = messagesCount;
	}

}
