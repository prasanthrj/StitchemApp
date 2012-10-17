package com.stitchemapp.services;

import java.util.List;

import com.stitchemapp.beans.MailNotification;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.User;

public interface MailingService {
	
	
	/* Basic Notifications */
	
	void sendProjectDetailsToUnregisteredUsers(Project project);
	
	
	/* Account Related */

	void sendSuccessfulRegistrationNotification(User user, String password);
	
	void sendAccountRecoveryNotification(User user, String tempPassword);
	
	
	/* Publishing */
	
	void sendProjectViewInvitesToUsers(Project project, List<User> users);
	
	void sendPublicViewApprovalNotification(Project project, Boolean isApproved);
	
	
	/* Announcements */

//	void sendAnnouncementToUsers(String subject, String body);
//	
//	void sendAnnouncementToUsersFromTemplate(String subject, String templateFileName);
	
	
	
	
	/* Core Mailing Methods */

	void sendSimpleTextMessage(MailNotification notification);
	
	void sendHtmlMimeMessage(MailNotification notification);



	
}
