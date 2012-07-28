package com.stitchemapp.services.impl;

import java.util.Hashtable;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.transaction.annotation.Transactional;

import com.stitchemapp.api.IDao;
import com.stitchemapp.entities.Tag;
import com.stitchemapp.services.ContentService;

public class ContentServiceImpl implements ContentService, ApplicationListener<ContextRefreshedEvent> {
	
	public static final Logger LOGGER = Logger.getLogger(ContentServiceImpl.class);
	
	private IDao genericDao;
	
	
	/* Application Listener */
	
	@Override
	@Transactional
	public void onApplicationEvent(ContextRefreshedEvent event) {
		this.refreshStandardProjectTags();
	}

	
	
	
	/* Tag CRUD + related */
	
	@Transactional
	public void createTag(Tag tag) {
		if(tag != null) {
			
			if(this.readTag(tag.getTitle()) == null)
				genericDao.save(tag);
			
		}
	}

	public Tag readTag(Integer pkey) {
		return genericDao.find(Tag.class, pkey);
	}
	
	public Tag readTag(String title) {
		Hashtable<String, String> ht = new Hashtable<String, String>();
		ht.put("title", title);
		return genericDao.getEntity(Tag.class, "tag.selectTagByName", ht);
	}

	@Transactional
	public void updateTag(Tag tag) {
		if(tag != null) {
			genericDao.update(tag);
		}
	}

	@Transactional
	public void deleteTag(Tag tag) {
		if(tag != null) {
			genericDao.delete(tag);
		}
	}
	
	
	
	@Transactional
	public Tag findOrCreateTag(Tag tag) {
		Tag tempTag = this.readTag(tag.getTitle());
		if(tempTag == null) {
			this.createTag(tag);
			tempTag = this.readTag(tag.getPkey());
		}
		return tempTag;
	}
	
	public List<Tag> fetchAllTags(){
		return genericDao.findAllEntities(Tag.class);
	}
	
	
	
	/* On Context Refresh */
	
	@Transactional
	public void refreshStandardProjectTags() {
		
		// Standard tags
		this.findOrCreateTag(new Tag("Activity"));
		this.findOrCreateTag(new Tag("Custom Navigations"));
		this.findOrCreateTag(new Tag("Captures"));
		this.findOrCreateTag(new Tag("Logins"));
		this.findOrCreateTag(new Tag("Others"));
		this.findOrCreateTag(new Tag("Searches"));
		this.findOrCreateTag(new Tag("Settings"));
		this.findOrCreateTag(new Tag("SignUps"));
		this.findOrCreateTag(new Tag("User Profiles"));
		this.findOrCreateTag(new Tag("Walkthroughs"));
		this.findOrCreateTag(new Tag("Widgets"));
		

	}
	
	
	
	/* Getters and Setters */
	
	public IDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}

	

}
