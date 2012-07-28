package com.stitchemapp.beans;

import com.stitchemapp.enums.MessageType;

public class MessageBean {
	
	private MessageType messageType;
	private String message;

	
	public MessageType getMessageType() {
		return messageType;
	}

	public void setMessageType(MessageType messageType) {
		this.messageType = messageType;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	

}
