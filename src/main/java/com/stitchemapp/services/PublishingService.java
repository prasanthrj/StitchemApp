package com.stitchemapp.services;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;

import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.PublishDetails;

public interface PublishingService {
	
	
	/* PublishDetails CRUD */
	
	void createPublishDetails(PublishDetails publishDetails);
	
	PublishDetails readPublishDetails(Integer pkey);
	
	void updatePublishDetails(PublishDetails publishDetails);
	
	void deletePublishDetails(PublishDetails publishDetails);
	
	
	
	/* Publishing Related */
	
	String prepareProjectPublishDoc(Project project);
	
	void broadcastProjectPublishingDetailsToUsers(Project project, String HostURL);
	
	
	
	
	/* Utils */
	
	/* HTML parsers */

	Document renderHTMLforMobileProject(Project project) throws ParserConfigurationException;
	
	Document renderHTMLforWebProject(Project project) throws ParserConfigurationException;

	
}
