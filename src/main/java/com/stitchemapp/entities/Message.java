package com.stitchemapp.entities;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "messages")
public class Message extends BaseEntity {

	private User sender;
	private User reciepent;

	private String subject;
	private String body;
	
	

	public User getSender() {
		return sender;
	}

	public void setSender(User sender) {
		this.sender = sender;
	}

	public User getReciepent() {
		return reciepent;
	}

	public void setReciepent(User reciepent) {
		this.reciepent = reciepent;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

}
