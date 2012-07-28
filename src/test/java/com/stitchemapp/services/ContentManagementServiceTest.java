package com.stitchemapp.services;

import org.apache.log4j.Logger;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.stitchemapp.entities.Tag;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={
	"classpath:applicationContext-test.xml"
})
public class ContentManagementServiceTest {

	public static final Logger LOGGER = Logger.getLogger(ContentManagementServiceTest.class);
	
	@Autowired
	private ContentService _contentManagementService;
	
	
	/* Local Variables and Constants  */
	

	
	/* Test Cases */
	
	@Before
	public void beforeTests() {
		
	}
	
	
	@Test
	public void testAddTag(){
		
		Tag tag = new Tag();
		tag.setTitle("SignUps");
		
		_contentManagementService.createTag(tag);
		
		
	}
	
	
	@After
	public void afterTests() {
		
	}
	
	
	
	
	
	
	
}
