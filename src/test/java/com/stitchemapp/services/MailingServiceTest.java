package com.stitchemapp.services;

import java.util.Date;

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
	

	
	/* Test Cases */
	
	@Before
	public void beforeTests() {
		
	}
	
	public void testSimpleMailing(){
		
		String from = "";
//		String to = "asdfsddfj@gmail.com";
//		String to = "gowri.shankar.8488@gmail.com";
		String to = "paraniraja@gmail.com";
		String subject = " Test Mail";
		String body = "Test Mail" + new Date().toString();
		
//		_mailingManager.sendTextMail(from, to, subject, body);
		
	}

	public void testHtmlMailing(){
		
		String from = "";
		String to = "gowrishankar.milli@gmail.com";
		String subject = "Stitch'em App Test Mail";
		String body = "Test Mail" + new Date().toString();
		
		body += "HTML Body :\n";
		
//		_mailingManager.sendHtmlMail(from, to, subject, body);
		
	}

	@After
	public void afterTests() {
		
	}
	
	
	


}