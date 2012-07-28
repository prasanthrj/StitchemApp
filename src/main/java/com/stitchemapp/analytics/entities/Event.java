package com.stitchemapp.analytics.entities;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.stitchemapp.entities.BaseEntity;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.MobileEvent;

@Entity
@Table(name = "analytics_events")
public class Event extends BaseEntity {
	
	private Project project;
	private User user;
	
	private String hostIP;

	// User Info
	private String userIp;
	private String userAgent;

	// Session Info
	private String sessionId;
	private Date timeStamp;

	// Access Info
	private String pageURI;

	// Event Info
	private MobileEvent eventType;

	private String[] xCoord;
	private String[] yCoord;

	
	
	/* Getters and Setters */

	@ManyToOne (fetch = FetchType.LAZY)
	@JoinColumn(name = "project_pkey")
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}
	
	@ManyToOne (fetch = FetchType.LAZY)
	@JoinColumn(name = "user_pkey")
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	
	

	@Column( name="host_ip" )
	public String getHostIP() {
		return hostIP;
	}

	public void setHostIP(String hostIP) {
		this.hostIP = hostIP;
	}

	@Column( name="user_ip" )
	public String getUserIp() {
		return userIp;
	}

	public void setUserIp(String userIp) {
		this.userIp = userIp;
	}

	@Column( name="user_agent" )
	public String getUserAgent() {
		return userAgent;
	}

	public void setUserAgent(String userAgent) {
		this.userAgent = userAgent;
	}

	@Column( name="user_session_id" )
	public String getSessionId() {
		return sessionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	@Column( name="time_stamp" )
	public Date getTimeStamp() {
		return timeStamp;
	}

	public void setTimeStamp(Date timeStamp) {
		this.timeStamp = timeStamp;
	}

	@Column( name="page_uri" )
	public String getPageURI() {
		return pageURI;
	}

	public void setPageURI(String pageURI) {
		this.pageURI = pageURI;
	}

	@Enumerated(EnumType.STRING)
	@Column( name="event_type" )
	public MobileEvent getEventType() {
		return eventType;
	}

	public void setEventType(MobileEvent eventType) {
		this.eventType = eventType;
	}

}
