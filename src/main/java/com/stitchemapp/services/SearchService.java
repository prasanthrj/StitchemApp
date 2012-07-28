package com.stitchemapp.services;

import java.util.List;
import java.util.Set;

import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.Tag;

public interface SearchService {

	
	/* Direct DB Search */
	
	// Project Related 
	
	List<Project> searchProjectsByTitle(String titleText);
	
	List<Project> searchProjectsByTitle(String titleText, Integer pageNumber, Integer pageSize);
	
	List<Project> searchProjectsByDescription(String descText);
	
	List<Project> searchProjectsByDescription(String descText, Integer pageNumber, Integer pageSize);
	
	
	
	
	// Tag/Category Related
	
	List<Tag> searchTagsByTitle(String titleText);
	
	List<Tag> searchTagsByDescription(String descText);
	
	
	
	
	/* Lucene Search */
	
	List<Project> searchProjects(String searchString);
	
	List<Project> searchProjects(String searchString, Integer pageNumber, Integer pageSize);
	
	
	
	List<Tag> searchTags(String searchString);
	
	
	
	/* Lucene Search Indexing */
	
	void doIndex(Class inEntityClass);
	
	void doIndexForSetOfEntities(Set<Integer> keys, Class inEntityClass);
	
	
}
