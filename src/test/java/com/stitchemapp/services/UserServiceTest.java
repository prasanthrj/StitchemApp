package com.stitchemapp.services;

import java.util.Random;

import org.apache.log4j.Logger;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.stitchemapp.security.UserService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={
	"classpath:applicationContext-test.xml"
})
public class UserServiceTest {
	
	public static final Logger LOGGER = Logger.getLogger(UserServiceTest.class);
	
	@Autowired
	private UserService _userService;
	
	/* Local Variables and Constants  */
	
	private static final Integer MAX_PASSWD_LENGTH = 8;
	
	private static final String AB = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	private static Random rnd = new Random();

	
	/* Test Cases */
	
	@Before
	public void beforeTests() {
		
		
	}
	
	@Test
	public void generateRandomAlphaNumericString() {
		
		StringBuilder sb = new StringBuilder(MAX_PASSWD_LENGTH);
		for (int i = 0; i < MAX_PASSWD_LENGTH; i++) {
			sb.append(AB.charAt(rnd.nextInt(AB.length())));
		}
		
		System.out.println(sb.toString());
		
	}
	
	@Test
	public void generateRandomString() {
		
		StringBuffer sb = new StringBuffer();
		for (int x = 0; x < MAX_PASSWD_LENGTH; x++) {
			sb.append((char) ((int) (Math.random() * 26) + 97));
		}
		System.out.println(sb.toString());
		
	}
	
	
	
	@After
	public void afterTests() {
		
		
		
	}
	
	
	

}
