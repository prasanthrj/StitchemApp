package com.stitchemapp.services.impl;

import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;

import com.stitchemapp.api.IDao;
import com.stitchemapp.api.IEntity;
import com.stitchemapp.constants.Constants;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.Tag;
import com.stitchemapp.services.SearchService;

public class SearchServiceImpl implements SearchService {
	
	public static final Logger LOGGER = Logger.getLogger(SearchServiceImpl.class);
	
	private IDao genericDao;
	
	
	
	/* Direct DB Search */
	
	// Project Related .. 
	

	public List<Project> searchProjectsByTitle(String titleText) {
		String entityField = "title";
		return genericDao.searchEntityByField(Project.class, entityField, titleText);
	}

	public List<Project> searchProjectsByTitle(String titleText, Integer pageNumber, Integer pageSize) {
		String entityField = "title";
		return genericDao.searchEntityByField(Project.class, entityField, titleText, pageNumber, pageSize);
	}

	public List<Project> searchProjectsByDescription(String descText) {
		String entityField = "description";
		return genericDao.searchEntityByField(Project.class, entityField, descText);
	}

	public List<Project> searchProjectsByDescription(String descText, Integer pageNumber, Integer pageSize) {
		String entityField = "description";
		return genericDao.searchEntityByField(Project.class, entityField, descText, pageNumber, pageSize);
	}

	
	
	
	// Tag/Category Related
	
	public List<Tag> searchTagsByTitle(String titleText) {
		String entityField = "title";
		return genericDao.searchEntityByField(Tag.class, entityField, titleText);
	}

	public List<Tag> searchTagsByDescription(String descText) {
		String entityField = "description";
		return genericDao.searchEntityByField(Tag.class, entityField, descText);
	}
	
	
	
	
	/* Lucene Search */
	

	public List<Project> searchProjects(String searchString) {
		
		String [] projections = { Constants.ENTITY_FIELD_PKEY, Constants.ENTITY_FIELD_TITLE, Constants.ENTITY_FIELD_DESCRIPTION };
		String[] entityFields = { Constants.ENTITY_FIELD_TITLE, Constants.ENTITY_FIELD_DESCRIPTION };
		Class[] classes = { Project.class, Tag.class };
		
		return genericDao.fullTextSearch(searchString, projections, entityFields, classes, null);
		
	}

	public List<Project> searchProjects(String searchString, Integer pageNumber, Integer pageSize) {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Tag> searchTags(String searchString) {
		// TODO Auto-generated method stub
		return null;
	}

	
	
	
	/* Lucene Search Indexing */
	
	
	@Transactional
	public void doIndex(Class inEntityClass){
		genericDao.doIndex(inEntityClass);
	}
	
	@Transactional
    public void doIndexForSetOfEntities(Set<Integer> keys, Class inEntityClass){
    	if(keys != null && keys.size() > 0){
    		for(Integer key : keys){
    			IEntity l = genericDao.find(inEntityClass, key); 			
    			genericDao.doSingleObjectIndex(l);
    		}
    	}    	
    }

	
	

}
