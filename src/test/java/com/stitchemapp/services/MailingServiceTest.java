package com.stitchemapp.services;

import java.io.File;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.Date;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={
	"classpath:applicationContext-test.xml"
})
public class MailingServiceTest {

	public static final Logger LOGGER = Logger.getLogger(MailingServiceTest.class);
	
	@Autowired
	private MailingService _mailingService;
	
	/* Local Variables and Constants  */
	
	private static final String mailTmplDir = "/home/milli/Dropbox/Imaginea/NightOut/App Fusion/StitchemApp/src/main/resources/Mail-Tmpl/";
	private static final String sampleTmpl = "project_view_invite.html";
 
	
	/* Test Cases */
	
	@Before
	public void beforeTests() {
		
		
	}
	
	
	@Test
	public void testTemplates() throws IOException {
		
		File templateFile = new File(mailTmplDir + sampleTmpl);
		String content = FileUtils.readFileToString(templateFile,null);
		
		Object[] arguments = new Object[3];
		arguments[0] = "milli";
		arguments[1] = "IPhone";
		arguments[2] = "2";

		content = MessageFormat.format(content, arguments);
		LOGGER.info(content);

	}
	
	
	@Test
	public void testSimpleMailing(){
		
		String from = "gowri.shankar.8488@gmail.com";
		String to = "gowri.shankar.8488@gmail.com";
		String subject = " Test Mail";
		String body = "Test Mail" + new Date().toString();
		
//		_mailingService.sendTextMail(from, to, subject, body);
		
		LOGGER.info("Test : Mail Sent");
		
	}
	

	@Test
	public void testHtmlMailing(){
		
		String from = "gowri.shankar.8488@gmail.com";
		String to = "gowri.shankar.8488@gmail.com";
		String subject = "Stitch'em App Test Mail";
		String body = "";
		
		body += "\n<b>HTML Body :</b>";
		
		
//		_mailingService.sendHtmlMail(from, to, subject, body);
		
		LOGGER.info("Test : Mail Sent");
	}

	@After
	public void afterTests() {
		
		
		
	}


	

}