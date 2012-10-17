package com.stitchemapp.services;

import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;

import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.PublishDetails;
import com.stitchemapp.entities.User;

public interface PublishingService {
	
	
	/* PublishDetails CRUD */
	
	void createPublishDetails(PublishDetails publishDetails);
	
	PublishDetails readPublishDetails(Integer pkey);
	
	void updatePublishDetails(PublishDetails publishDetails);
	
	void deletePublishDetails(PublishDetails publishDetails);
	
	
	/* Publishing Related */
	
	String prepareProjectPublishDoc(Project project);
	
	void publishProjectDetailsAndUpdateAppUsers(Project project, String HostURL, List<User> appUsers);
	
	
	/* HTML Rendering */

	Document renderHTMLforMobileProject(Project project) throws ParserConfigurationException;
	
	Document renderHTMLforWebProject(Project project) throws ParserConfigurationException;

	
}
