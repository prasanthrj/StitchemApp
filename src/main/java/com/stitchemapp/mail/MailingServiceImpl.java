package com.stitchemapp.mail;

import java.io.File;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.List;

import javax.mail.internet.MimeMessage;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

import com.stitchemapp.beans.MailNotification;
import com.stitchemapp.constants.EmailID;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.User;
import com.stitchemapp.services.MailingService;

public class MailingServiceImpl implements MailingService {

	public static final Logger LOGGER = Logger.getLogger(MailingServiceImpl.class);

	private JavaMailSender mailSender;
	
	private String tmplDirPath;
	
	
	/* Template filenames */
	
	private static final String PROJECT_DETAILS_TMPL = "";
	
	private static final String SUCCESSFUL_REG_TMPL = "successful_registration.html";
	private static final String ACCOUNT_RECOVERY_TMPL = "account_recovery.html";
	
	private static final String PROJECT_VIEW_INVITE_TMPL = "project_view_invite.html";
	private static final String PUBLIC_APPROVAL_TMPL = "";
	
	
	/* Basic Notifications */

	public void sendProjectDetailsToUnregisteredUsers(Project project) {
		// TODO Auto-generated method stub
		
	}

	
	/* Account Related */
	
	public void sendSuccessfulRegistrationNotification(User user, String password) {
		File templateFile = new File(tmplDirPath + SUCCESSFUL_REG_TMPL);
		
		Object[] arguments = new Object[3];
		arguments[0] = user.getFullName();
		arguments[1] = user.getUsername();
		arguments[2] = password;
		
		try {
			String content = FileUtils.readFileToString(templateFile,null);
			content = MessageFormat.format(content, arguments);
			
			String subject = "Welcome to Stitchemapp !";
			MailNotification notification = new MailNotification(user.getEmailId(), subject, content);
			this.sendHtmlMimeMessage(notification);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	public void sendAccountRecoveryNotification(User user, String tempPassword) {
		File templateFile = new File(tmplDirPath + ACCOUNT_RECOVERY_TMPL);
		
		Object[] arguments = new Object[3];
		arguments[0] = user.getFullName();
		arguments[1] = user.getUsername();
		arguments[2] = tempPassword;
		
		try {
			String content = FileUtils.readFileToString(templateFile,null);
			content = MessageFormat.format(content, arguments);
			
			String subject = "Your new password for Stitchemapp !!!";
			MailNotification notification = new MailNotification(user.getEmailId(), subject, content);
			this.sendHtmlMimeMessage(notification);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		LOGGER.debug("Account Recovery Mail is Sent !!!");
	}

	
	
	/* Publishing */
	
	public void sendProjectViewInvitesToUsers(Project project, List<User> users) {
		String template = tmplDirPath + PROJECT_VIEW_INVITE_TMPL;
		
		String author = project.getPublisher().getFullName();
		String device = project.getProjectType().name();
		String projKey = project.getPkey().toString();

		Object[] arguments;
		String body = "";
		try {
			File templateFile = new File(template);
			String content = FileUtils.readFileToString(templateFile, null);
			
			String subject = "You have been invited to view a StitchemApp Project";
			MailNotification notification;
			for (User user : users) {
				arguments = new Object[]{author, device, };
				body = MessageFormat.format(content, arguments, projKey);
				
				notification = new MailNotification(user.getEmailId(), subject, body);
				this.sendHtmlMimeMessage(notification);
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
	}

	public void sendPublicViewApprovalNotification(Project project, Boolean isApproved) {
		String template = tmplDirPath + PUBLIC_APPROVAL_TMPL;
		
		
	}


	
	/* Core Mailing Methods */
	
	public void sendSimpleTextMessage(MailNotification notification) {
		if (notification != null && notification.getToEmail() != null) {
			
			SimpleMailMessage mailMsg = new SimpleMailMessage();
			mailMsg.setFrom(notification.getFromEmail());
			mailMsg.setTo(notification.getToEmail());
			mailMsg.setSubject(notification.getSubject());
			mailMsg.setText(notification.getBody());
			
			mailSender.send(mailMsg);
			
		}
	}

	public void sendHtmlMimeMessage(MailNotification notification) {
		if (notification != null && notification.getToEmail() != null) {
			
			try {
				MimeMessage mimeMessage = mailSender.createMimeMessage();
				MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage);

				messageHelper.setFrom(notification.getFromEmail());
				messageHelper.setTo(notification.getToEmail());
				messageHelper.setSubject(notification.getSubject());
				messageHelper.setText(notification.getBody(), true);
				
				mailSender.send(mimeMessage);
				
			} catch (Exception e) {
				e.printStackTrace();
			} 
			
			/*
			MimeMessage mimeMsg = mailSender.createMimeMessage();
			try {
				mimeMsg.setFrom(new InternetAddress(notification.getFromEmail()));
				mimeMsg.addRecipient(Message.RecipientType.TO, new InternetAddress(notification.getToEmail()));
				mimeMsg.setSubject(notification.getSubject());
				mimeMsg.setContent(notification.getBody(), "text/html");
				
				mailSender.send(mimeMsg);
				
			} catch (Exception e) {
				e.printStackTrace();
			} 
			*/
		}
	}

	
	
	/* Getters and Setters */

	public void setMailSender(JavaMailSender mailSender) {
		this.mailSender = mailSender;
	}

	public void setTmplDirPath(String tmplDirPath) {
		this.tmplDirPath = tmplDirPath;
	}

}
