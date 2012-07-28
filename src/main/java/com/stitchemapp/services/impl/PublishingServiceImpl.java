package com.stitchemapp.services.impl;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.stitchemapp.api.IDao;
import com.stitchemapp.constants.EmailID;
import com.stitchemapp.constants.EmailSubject;
import com.stitchemapp.entities.HotSpot;
import com.stitchemapp.entities.Layout;
import com.stitchemapp.entities.Page;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.PublishDetails;
import com.stitchemapp.entities.UIEvent;
import com.stitchemapp.entities.User;
import com.stitchemapp.services.MailingService;
import com.stitchemapp.services.ProjectService;
import com.stitchemapp.services.PublishingService;
import com.stitchemapp.utils.Convert;

public class PublishingServiceImpl implements PublishingService {

	public static final Logger LOGGER = Logger.getLogger(PublishingServiceImpl.class);

	private IDao genericDao;
	private ProjectService projectService;
	private MailingService mailingService;
	
	private Project project;
	private Document projectHtmlDocument;
	
	private DocumentBuilderFactory docFactory;
	private DocumentBuilder docBuilder;
	
	
	
	/* PublishDetails CRUD */
	
	@Transactional
	public void createPublishDetails(PublishDetails publishDetails) {
		if(publishDetails != null) {
			genericDao.save(publishDetails);
		}
	}

	public PublishDetails readPublishDetails(Integer pkey) {
		return genericDao.find(PublishDetails.class, pkey);
	}

	@Transactional
	public void updatePublishDetails(PublishDetails publishDetails) {
		if(publishDetails != null) {
			genericDao.update(publishDetails);
		}
	}

	@Transactional
	public void deletePublishDetails(PublishDetails publishDetails) {
		if(publishDetails != null) {
			genericDao.delete(publishDetails);
		}
	}
	
	
	
	/* Publishing Related */
	
	public String prepareProjectPublishDoc(Project project){
		
//		project = genericDao.find(Project.class, projectPkey);
		
		// Do Some Validation here
		
		
		// Generate Content here
		
		String xmlString = null;
		 
		try {
			
			projectHtmlDocument = this.renderHTMLforMobileProject(project);
			
			/////////////////
	        //Output the XML

	        //set up a transformer
	        TransformerFactory transfac = TransformerFactory.newInstance();
	        Transformer trans = transfac.newTransformer();
	        trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
	        trans.setOutputProperty(OutputKeys.INDENT, "yes");

	        //create string from xml tree
	        StringWriter sw = new StringWriter();
	        StreamResult result = new StreamResult(sw);
	        DOMSource source = new DOMSource(projectHtmlDocument);
	        trans.transform(source, result);
	        
	        xmlString = sw.toString();
			
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
			
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
			
		} catch (TransformerException e) {
			e.printStackTrace();
			
		}
		
		return xmlString;
	}
	
	
	public void broadcastProjectPublishingDetailsToUsers(Project project, String HostURL){
		
		if (project != null) {
			
			PublishDetails publishDetails = project.getPublishDetails();
			
			String from = EmailID.DO_NOT_REPLY;
			String to = "";
			String subject = EmailSubject.PROJECT_PUBLISH + ": " + project.getTitle();
			
			String body = "";
			
			List<User> appUsers = project.getAppUsers();
			if (appUsers == null)
				appUsers = new ArrayList<User>();
			
			for (User appUser : appUsers) {
				
				to = appUser.getEmailId();
				
				body += publishDetails.getNotes();
				
				body += "\n\n Use the below URL to view the app in mobile : \n";
				body += HostURL + "/publish/mobile?project.pkey=" + project.getPkey().toString() + "&appUser.pkey=" + appUser.getPkey();
				
				body += "\n\n Use the below URL to view the app in desktop : \n";
				body += HostURL + "/publish/web?project.pkey=" + project.getPkey().toString() + "&appUser.pkey=" + appUser.getPkey();
				
				if (publishDetails.getPassKey() != null && publishDetails.getPassKey() != "") {
					
					body += "\n\n Use this below passkey whenever required : \n";
					body += publishDetails.getPassKey();
					
				}				
				
				body += "\n\n\n Thanks & Best regards, \n -StichemApp Team";
				
//				mailingManager.sendHtmlMail(from, to, subject, body);
				mailingService.sendTextMail(from, to, subject, body);
				
				body = "";
					
			}
		}

	}
	
	
	
	
	/* Utils */
	
	/* HTML parsers */
	
	// Project Publishing ...
	
	public Document renderHTMLforMobileProject(Project project) throws ParserConfigurationException {
		
		// New Instances as DocumentBuilderFactory is not thread safe ..
		
		docFactory = DocumentBuilderFactory.newInstance();
		docBuilder = docFactory.newDocumentBuilder();
 
		/* Build the HTML Body here */
		
		// Root element
		Document document = docBuilder.newDocument();
		
		Element rootElement = document.createElement("section");
		rootElement.setAttribute("id", "pages-cont");
		
		document.appendChild(rootElement);
		
		Layout projectLayOut = project.getLayout();
		
//		Integer layoutWidth = projectLayOut.getWidth();
//		Integer layoutHeight = projectLayOut.getHeight();
		
		List<Page> pages = projectLayOut.getPages();
		
		if(pages == null) pages = new ArrayList<Page>();
		
		
		/* Page & Elements creation */
		
		for (int i = 0; i < pages.size(); i++) {
			
			Page page = pages.get(i);
			
			Element pageElement = document.createElement("div");
			pageElement.setAttribute("data-role", "page");
			pageElement.setAttribute("class", "single-page");
			pageElement.setAttribute("id", "page-" + page.getPkey());
			
			Element pageContentElement = document.createElement("div");
			pageContentElement.setAttribute("class", "page-content pos-rel");
			
			/* Page Image */
			
			if (page.getScreenImage() != null) {
				
				Element pageImageElement = document.createElement("img");
				pageImageElement.setAttribute("class", "screen-img");
				pageImageElement.setAttribute("src", "/image/view?project.pkey=" + project.getPkey() + "&imageFile.pkey=" + page.getScreenImage().getPkey());
								
				pageImageElement.appendChild(document.createTextNode(" "));
				pageContentElement.appendChild(pageImageElement);

			}
			
			if (page.getHeaderImage() != null) {
				
				Element pageHeaderImageElement = document.createElement("img");
				pageHeaderImageElement.setAttribute("class", "header-img");
				pageHeaderImageElement.setAttribute("src", "/image/view?project.pkey=" + project.getPkey() + "&imageFile.pkey=" + page.getHeaderImage().getPkey());
								
				pageHeaderImageElement.appendChild(document.createTextNode(" "));
				pageContentElement.appendChild(pageHeaderImageElement);
				
			}

			if (page.getFooterImage() != null) {
				
				Element pageFooterImageElement = document.createElement("img");
				pageFooterImageElement.setAttribute("class", "footer-img");
				pageFooterImageElement.setAttribute("src", "/image/view?project.pkey=" + project.getPkey() + "&imageFile.pkey=" + page.getFooterImage().getPkey());
								
				pageFooterImageElement.appendChild(document.createTextNode(" "));
				pageContentElement.appendChild(pageFooterImageElement);
			
			}
			
			if (page.getLeftNavImage() != null) {
				
				Element pageLeftNavImageElement = document.createElement("img");
				pageLeftNavImageElement.setAttribute("class", "left-nav-img");
				pageLeftNavImageElement.setAttribute("src", "/image/view?project.pkey=" + project.getPkey() + "&imageFile.pkey=" + page.getLeftNavImage().getPkey());
								
				pageLeftNavImageElement.appendChild(document.createTextNode(" "));
				pageContentElement.appendChild(pageLeftNavImageElement);
			
			}

			if (page.getRightNavImage() != null) {
				
				Element pageRightNavImageElement = document.createElement("img");
				pageRightNavImageElement.setAttribute("class", "right-nav-img");
				pageRightNavImageElement.setAttribute("src", "/image/view?project.pkey=" + project.getPkey() + "&imageFile.pkey=" + page.getRightNavImage().getPkey());
								
				pageRightNavImageElement.appendChild(document.createTextNode(" "));
				pageContentElement.appendChild(pageRightNavImageElement);
			
			}

			
			/* Page HotSpots */
			
			List<HotSpot> hotSpots  = page.getHotSpots();
			
			if (hotSpots == null) hotSpots = new ArrayList<HotSpot>();
			
			for (int j = 0; j < hotSpots.size(); j++) {
				
				HotSpot hotSpot = hotSpots.get(j);
				
				Element hotSpotElement = document.createElement("a");
				hotSpotElement.setAttribute("class", "btn");
				hotSpotElement.setAttribute("id", "hs-" + hotSpot.getPkey().toString() );
				hotSpotElement.setAttribute("href", "javascript:void(0);" );
				
				
				// Attaching Events ..
				
				List<UIEvent> uiEvents = hotSpot.getUiEvents();
				if (uiEvents == null) uiEvents = new ArrayList<UIEvent>();
				
				Element scriptElement = document.createElement("script");
				
				StringBuffer eventsText = new StringBuffer();
				
				for (int k = 0; k < uiEvents.size(); k++) {
					
					UIEvent uiEvent = uiEvents.get(k);
					
					eventsText.append("bindEvent('hs-" + hotSpot.getPkey().toString() + "' , '" + uiEvent.getEventType().toString() + "' , '" + uiEvent.getTransitionType().toString() + "', '" + "#page-" + uiEvent.getToPage().getPkey() +"' );" );
					
				}
				
				scriptElement.setTextContent(eventsText.toString());
				
				Float fromX = hotSpot.getFromX();
				Float fromY = hotSpot.getFromY();
				
				Float width = hotSpot.getToX() - fromX;
				Float height = hotSpot.getToY() - fromY;
				
				if(width < 0) {
					width = -1 * width;
					fromX = hotSpot.getToX();
				}
				
				if(height < 0) {
					height = -1 * height;
					fromY = hotSpot.getToY();
				}
				
				double percentFromX = Convert.round2decimals( fromX  * 100 );
				double percentFromY = Convert.round2decimals(fromY * 100 );
				double percentWidth = Convert.round2decimals( width * 100 );
				double percentHeight = Convert.round2decimals( height * 100 );
				
				
				hotSpotElement.setAttribute("style", "top: " + percentFromY + "%; left: " + percentFromX + "%; width: " + percentWidth + "%; height: " + percentHeight + "%;");
				
				hotSpotElement.appendChild(document.createTextNode(" "));
				pageContentElement.appendChild(hotSpotElement);
				
				scriptElement.appendChild(document.createTextNode(" "));
				pageContentElement.appendChild(scriptElement);
								
			}
			
			/* Page Clear */
			
			Element pageClearElement = document.createElement("div");
			pageClearElement.setAttribute("class", "clear");
			
			pageClearElement.appendChild(document.createTextNode(" "));
			pageContentElement.appendChild(pageClearElement);
			
			
			pageContentElement.appendChild(document.createTextNode(" "));
			pageElement.appendChild(pageContentElement);
			
			
			pageElement.appendChild(document.createTextNode(" "));
			rootElement.appendChild(pageElement);
						
		}
		
		
		return document;
		
	}

	public Document renderHTMLforWebProject(Project project) throws ParserConfigurationException {
		
		// New Instances as DocumentBuilderFactory is not thread safe ..
		
		docFactory = DocumentBuilderFactory.newInstance();
		docBuilder = docFactory.newDocumentBuilder();
 
		/* Build the HTML Body here */
		
		// Root element
		Document document = docBuilder.newDocument();
		
		Element rootElement = document.createElement("section");
		rootElement.setAttribute("id", "pages-cont");
		
		document.appendChild(rootElement);
		
		Layout projectLayOut = project.getLayout();
		List<Page> pages = projectLayOut.getPages();

		if(pages == null) pages = new ArrayList<Page>();
		
		/* Page & Elements creation */
		
		for (int i = 0; i < pages.size(); i++) {
			
			Page page = pages.get(i);
			
			Element pageElement = document.createElement("div");
			pageElement.setAttribute("data-role", "page");
			pageElement.setAttribute("class", "single-page");
			pageElement.setAttribute("id", "page-" + page.getPkey());
			

			rootElement.appendChild(pageElement);
						
		}
		
		
		return document;
		
	}


	/* Getters and Setters */
	

	public IDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}
	
	public ProjectService getProjectService() {
		return projectService;
	}

	public void setProjectService(ProjectService projectService) {
		this.projectService = projectService;
	}

	public MailingService getMailingService() {
		return mailingService;
	}

	public void setMailingService(MailingService mailingService) {
		this.mailingService = mailingService;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}
	
	public Document getProjectHtmlDocument() {
		return projectHtmlDocument;
	}

	public void setProjectHtmlDocument(Document projectHtmlDocument) {
		this.projectHtmlDocument = projectHtmlDocument;
	}
	
	public DocumentBuilderFactory getDocFactory() {
		return docFactory;
	}

	public void setDocFactory(DocumentBuilderFactory docFactory) {
		this.docFactory = docFactory;
	}

	public DocumentBuilder getDocBuilder() {
		return docBuilder;
	}

	public void setDocBuilder(DocumentBuilder docBuilder) {
		this.docBuilder = docBuilder;
	}

	
}
