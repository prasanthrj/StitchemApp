package com.stitchemapp.mail;

import java.util.List;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.ws.rs.core.MultivaluedMap;

public class CustomMailClient {

	protected Properties properties;

	public String sendEmail(MultivaluedMap<String, String> fieldMap) {
		try {
			System.out.println("here " + fieldMap);
			if (fieldMap != null) {
				// Set the host smtp address
				boolean debug = false;

				// Set the host smtp address
				Properties props = new Properties();
				props.put("mail.smtp.host", "imap.imaginea.com");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.port", "225");
				props.put("mail.smtp.starttls.enable", "true");
				// props.put("mail.smtp.localhost","IMACHE044");

				Authenticator auth = new Authenticator() {
					@Override
					protected PasswordAuthentication getPasswordAuthentication() {
						String username = properties.getProperty("app1.senderEmail");
						String password = properties.getProperty("app1.password");
						return new PasswordAuthentication(username, password);
					}
				};
				
				Session session = Session.getDefaultInstance(props, auth);

				session.setDebug(debug);

				// create a message
				Message msg = new MimeMessage(session);

				// set the from and to address
				InternetAddress addressFrom = new InternetAddress(properties.getProperty("app1.senderEmail"));
				msg.setFrom(addressFrom);

				List<String> emails = fieldMap.get("to");
				InternetAddress[] addressTo = new InternetAddress[emails.size()];
				for (int i = 0; i < emails.size(); i++) {
					addressTo[i] = new InternetAddress(emails.get(i));
				}
				msg.setRecipients(Message.RecipientType.TO, addressTo);

				// Setting the Subject and Content Type
				msg.setSubject(fieldMap.get("subj").get(0));
				msg.setContent(fieldMap.get("message").get(0), "text/plain");
				Transport.send(msg);
				return "{\"result\":[{\"status\":\"success\"}]}";
			} else
				return "{\"error\":[{\"error_text\":\"Email content not received.\"}]}";
			
		} catch (Exception e) {
			e.printStackTrace();
			return "{\"error\":[{\"error_text\":\"Email could not be sent.\"}]}";
		}

	}

}
