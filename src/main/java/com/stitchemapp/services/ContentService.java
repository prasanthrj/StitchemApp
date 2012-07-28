package com.stitchemapp.services;

import java.util.List;

import com.stitchemapp.entities.Tag;

public interface ContentService {

	
	/* Tag CRUD */
	
	void createTag(Tag tag);
	
	Tag readTag(Integer pkey);
	
	Tag readTag(String title);
	
	void updateTag(Tag tag);
	
	void deleteTag(Tag tag);
	
	
	
	Tag findOrCreateTag(Tag tag);
	
	List<Tag> fetchAllTags();
	
	
	
	/* On Context Refresh */
	
	void refreshStandardProjectTags();
	
	
	
}
