package com.stitchemapp.services;

import org.apache.log4j.Logger;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.stitchemapp.api.IEntity;
import com.stitchemapp.daos.GenericJpaDao;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={
	"classpath:applicationContext-test.xml"
})
public class PublishingManagerTest {
	
	public static final Logger LOGGER = Logger.getLogger(PublishingManagerTest.class);
	
	
	
	/* Local Variables and Constants  */
	

	
	/* Test Cases */
	
	@Before
	public void beforeTests() {
		
	}
	
		
	@Test
	public void testProjectPublishing(){
		
		LOGGER.info("Test : Project Publishing");
		
	}
	
	
	@After
	public void afterTests() {
		
	}
	
	
	
	
	
}
