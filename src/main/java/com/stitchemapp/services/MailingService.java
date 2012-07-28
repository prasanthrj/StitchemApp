package com.stitchemapp.services;

public interface MailingService {

	
	void sendTextMail(String from, String to, String subject, String body);
	
	void sendHtmlMail(String from, String to, String subject, String body);
	
}
