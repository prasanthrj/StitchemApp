package com.stitchemapp.mail;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

import com.stitchemapp.api.IDao;
import com.stitchemapp.api.IEntity;
import com.stitchemapp.constants.EmailID;
import com.stitchemapp.services.MailingService;

public class MailingServiceImpl implements MailingService {

	public static final Logger LOGGER = Logger.getLogger(MailingServiceImpl.class);

	private IDao genericDao;
	private JavaMailSender mailSender;
	
	/* Methods */

	public void sendTextMail(String from, String to, String subject, String body) {
		
		if (to != null) {
			
			SimpleMailMessage message = new SimpleMailMessage();
			
			if(from == null || from == "")
				from = EmailID.DO_NOT_REPLY;
			
			message.setFrom(from);
			message.setTo(to);
			message.setSubject(subject);
			message.setText(body);
			
			mailSender.send(message);
			
		} else {
			
		}
		
	}

	public void sendHtmlMail(String from, String to, String subject, String body) {
		
		if (to != null) {
			
			MimeMessage message = mailSender.createMimeMessage();
			
			if(from == null || from == "")
				from = EmailID.DO_NOT_REPLY;
			
			try {
				
				message.setFrom(new InternetAddress(from));
				message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
				message.setSubject(subject);

				message.setContent(body, "text/html");
				
				mailSender.send(message);
				
			} catch (AddressException e) {
				e.printStackTrace();
			} catch (MessagingException e) {
				e.printStackTrace();
			}
			
		} else {
			
		}
		

	}
	
	
	

	/* Getters and Setters */

	public IDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}

	public JavaMailSender getMailSender() {
		return mailSender;
	}

	public void setMailSender(JavaMailSender mailSender) {
		this.mailSender = mailSender;
	}

}
