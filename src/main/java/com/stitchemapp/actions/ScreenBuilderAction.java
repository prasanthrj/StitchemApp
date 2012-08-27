package com.stitchemapp.actions;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.imageio.ImageIO;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.stitchemapp.beans.MessageBean;
import com.stitchemapp.constants.Messages;
import com.stitchemapp.entities.HotSpot;
import com.stitchemapp.entities.ImageFile;
import com.stitchemapp.entities.Layout;
import com.stitchemapp.entities.Page;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.PublishDetails;
import com.stitchemapp.entities.UIEvent;
import com.stitchemapp.entities.User;
import com.stitchemapp.enums.ImageFileType;
import com.stitchemapp.enums.MessageType;
import com.stitchemapp.services.ProjectService;
import com.stitchemapp.services.ScreenBuilderService;
import com.stitchemapp.utils.ImageUtils;

public class ScreenBuilderAction extends GenericActionSupport {

	public static final Logger LOGGER = Logger.getLogger(ScreenBuilderAction.class);
	
	private MessageBean messageBean = new MessageBean();

	private ProjectService projectService;
	private ScreenBuilderService screenBuilderService;
	
	private User user;

	private Project project;
	private Layout layout;
	
	private Page page;
	private List<Page> pages;
	
	private ImageFile imageFile;
	private InputStream fileStream;
	
	private ImageFileType imageFileType;
	
	private List<ImageFile> imageFiles;
		
	private List<ImageFile> screenImages;
	private List<ImageFile> headerImages;
	private List<ImageFile> footerImages;
	private List<ImageFile> leftNavImages;
	private List<ImageFile> rightNavImages;
	
	private HotSpot hotSpot;
	private List<HotSpot> hotSpots;
	private Page toPage;
	
	private UIEvent uiEvent;
	private List<UIEvent> uiEvents;
	
	private HotSpot rootHotSpotNode;

	// Publishing related .. 
	private PublishDetails publishDetails;	
	private List<User> appUsers;
	
	// LandingPage
	private Boolean isLandingPage;
	
	
	/* Methods */ 
	
	@Override
	public void prepare() throws Exception{
		super.prepare();
		
		String project_pkey = this.request.getParameter("project.pkey");
        if (project_pkey != null && StringUtils.isNotEmpty(project_pkey)){
            project = projectService.readProject(Integer.valueOf(project_pkey));
            if(project != null) {
            	layout = project.getLayout();
            	
            	// Publishing Related ...
            	publishDetails = project.getPublishDetails();
        		appUsers = project.getAppUsers();
            }
        }
        
        String page_pkey = this.request.getParameter("page.pkey");
        if (page_pkey != null && StringUtils.isNotEmpty(page_pkey)){
            page = screenBuilderService.readPage(Integer.valueOf(page_pkey));
            if (page != null) {
				hotSpots = page.getHotSpots();
			}
        }
        
        String hotSpot_pkey = this.request.getParameter("hotSpot.pkey");
        if (hotSpot_pkey != null && StringUtils.isNotEmpty(hotSpot_pkey)){
            hotSpot = screenBuilderService.readHotSpot(Integer.valueOf(hotSpot_pkey));
            if (hotSpot != null) {
//				uiEvents = hotSpot.getUiEvents();
			}
        }
        
        String uiEvent_pkey = this.request.getParameter("uiEvent.pkey");
        if (uiEvent_pkey != null && StringUtils.isNotEmpty(uiEvent_pkey)){
            uiEvent = screenBuilderService.readUIEvent(Integer.valueOf(uiEvent_pkey));
        }
        
        String imageFile_pkey = this.request.getParameter("imageFile.pkey");
        if (imageFile_pkey != null && StringUtils.isNotEmpty(imageFile_pkey)){
        	if(Integer.valueOf(imageFile_pkey) != 0){
        		imageFile = screenBuilderService.readImageFile(Integer.valueOf(imageFile_pkey));
        	} else {
        		imageFile = null;
        	}
        }

	}
	
	
	/* Images */
	
	public String prepareProjectUploader(){
		
		if ( project != null ) {
			
			this.fetchAllProjectImages();
			
			pages = project.getLayout().getPages();
			layout = project.getLayout();
		
		} else {
			return ERROR;
		}
		
		return SUCCESS;
	}
	
	public String uploadProjectImage(){
		try {
			
			if ( project != null ) {
			
				project = projectService.readProject(project.getPkey());
				
				if (imageFile != null) {
					imageFile.setImageType(imageFileType);
					
					BufferedImage image = ImageIO.read(imageFile.getFileObj());
					
					// Dimensions 
					imageFile.setWidth(image.getWidth());
					imageFile.setHeight(image.getHeight());
					
					if (imageFile.getImageType().equals(ImageFileType.screen) && image.getWidth() < project.getProjectType().width()) {
						// TODO throw Image Dimension Error Message
						messageBean.setMessageType(MessageType.error);
						messageBean.setMessage(Messages.INVALID_DIMENSIONS);
					}
					
//					FileUtils.copyFile(srcFile, destFile, true);
					
					imageFile.setThumbNail( ImageUtils.createThumbnailOutOfImage(image, project.getProjectType()) );
//					imageFile.setThumbNail( ImageUtils.createThumbnailUsingImageMagick(imageFile, project.getProjectType()));
	
					screenBuilderService.storeProjectImageFile(project, imageFile);
				}
				
				if(imageFile.getImageType().equals(ImageFileType.screen))
					page = screenBuilderService.createPageForProjectScreenImage(project, imageFile);
				
			} else {
				
				// TODO Set Image Error Message
				return ERROR;
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return SUCCESS;
	}
	
	public String uploadProjectImages(){
		
		if ( project != null ) {
		
			project = projectService.readProject(project.getPkey());
			
			if (imageFiles != null) {
				for (ImageFile imageFile : imageFiles) {
					
					this.imageFile = imageFile;
					this.uploadProjectImage();
					
				}
			}
			
		} else {
			
			return ERROR;
		}
		
		return SUCCESS;
	}
	
	public String fetchAllProjectImages(){
		
		if (project != null) {
			
			screenImages = screenBuilderService.fetchProjectScreenImages(project);
			headerImages = screenBuilderService.fetchProjectHeaderImages(project);
			footerImages = screenBuilderService.fetchProjectFooterImages(project);
			leftNavImages = screenBuilderService.fetchProjectLeftNavImages(project);
			rightNavImages = screenBuilderService.fetchProjectRightNavImages(project);
		}
		
		return SUCCESS;
	}
	
	
	public String fetchProjectImage() {
		
		if(project != null && imageFile != null && imageFile.getPkey() != null) {
			imageFile = screenBuilderService.readImageFile(imageFile.getPkey());
			
			byte[] bytes = imageFile.getImage();
			ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
			
			setFileStream(bis);

		}
		
		return SUCCESS;
	}
	
	public String fetchProjectImageThumbNail() {
		
		if(project != null && imageFile != null && imageFile.getPkey() != null) {
			imageFile = screenBuilderService.readImageFile(imageFile.getPkey());
			
			byte[] bytes = imageFile.getThumbNail();
			ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
			
			setFileStream(bis);

		}
		
		return SUCCESS;
	}
	
	public String deleteProjectImage() {
		
		// TODO Chech for Project and Image combo
		
		if (imageFile != null && imageFile.getPkey() != null) {
			screenBuilderService.deleteImageFile(imageFile);
		}	
		return SUCCESS;
	}
	
	public String updateProjectScreenImage(){
		
		if(page != null && imageFile != null){
			
			imageFile.setImageType(ImageFileType.screen);
			screenBuilderService.storeProjectImageFile(project, imageFile);
			page = screenBuilderService.readPage(page.getPkey());
			
			// Do you need HotSpots?
			
		} else {
			return ERROR;
		}
		
		return SUCCESS;
		
	}
	
	
	
	/* Layout Related */
	
	public String updateProjectLandingPage() {
		
		String msgStr = "";
		
		if (layout != null && page != null) {
			
			if (isLandingPage != null && isLandingPage) {
				
				msgStr = "Project landing page has been set to " + page.getTitle();
				
				if(layout.getLandingPage() != null)
					msgStr = "Project landing page has been changed from " + layout.getLandingPage().getTitle() + " to " + page.getTitle();
				
				layout.setLandingPage(page);
				
			} else {
				msgStr = "Project landing page has been removed";
				
				layout.setLandingPage(null);
				
			}
						
			if (layout.getPkey() != null) {
				screenBuilderService.updateLayout(layout);
			} else {
				screenBuilderService.createLayout(layout);
			}
			
		}
		
		messageBean.setMessageType(MessageType.success);
		messageBean.setMessage(msgStr);
				
		return SUCCESS;
	}

	
	/* Preparing Project */
	
	public String prepareProjectForBuild() {
		
		if( project != null && user != null) {

			project = projectService.readProject(project.getPkey());
			user = userService.readUserByEmailId(user.getEmailId());
			
			if (user != null && project.getPublisher().getEmailId().equals(user.getEmailId())) {
				
				// Creating Pages ... ( No screens in particular )
				screenBuilderService.createPagesForProjectScreenImages(project, null);
				
				pages = project.getLayout().getPages();
				if( page == null && pages != null && pages.size() > 0)
					page = pages.get(0);
				
				this.fetchAllProjectImages();
				
			} else {
				return ERROR;
			}
			
		} else {
			return ERROR;
		}
		
		return SUCCESS;
	}
	
	
	/* Pages */
	
	public String savePage() {
		
		if(page != null && !page.getTitle().isEmpty() ){
						
			if (page.getPkey() != null ){

				// Setting Image file : logic works for all images except screen Image update ..
				if (imageFile != null) {
					screenBuilderService.updatePage(page, imageFile);
				} else {
					screenBuilderService.updatePage(page);
				}
				
			} else {
				screenBuilderService.createPage(page);
			}
			
		} else {
			return ERROR;
		}
		
		return SUCCESS;
	}
	
	
	public String preparePageForEdit() {
		
		if(page != null) {
			
			// TODO Check for correctness in project .. 			
			
			page = screenBuilderService.readPage(page.getPkey());
			hotSpots = page.getHotSpots(); 
		}

		return SUCCESS;
	}
	
	public String removePage() {
		
		if(page != null) {
			
			// TODO Check for correctness in project .. 			
			
			screenBuilderService.deletePage(page);
			
			// set the messageBean ..
			messageBean.setMessageType(MessageType.success);
			messageBean.setMessage(Messages.PAGE_DELETE_SUCCESS);
			
		}

		return SUCCESS;
	}
	
	
	
	/* Hot Spots */
	
	public String saveHotSpotCoordinates() {
		
		if(page != null && hotSpot != null && hotSpot.getPkey() != null ) {
			screenBuilderService.updateHotSpot(hotSpot);
		} else {
			return ERROR;
		}

		return SUCCESS;
	}

	public String saveHotSpot() {
		
		// UIEvents Work flow ...
		
		if(page != null && hotSpot != null && uiEvents != null){
			
			// Hot Spot ....
			if (hotSpot != null && hotSpot.getPkey() != null ){
				screenBuilderService.updateHotSpot(hotSpot);
			} else {
				hotSpot.setPage(page);
				screenBuilderService.createHotSpot(hotSpot);
			}
			
			
			// UIEvents .... 
			for (UIEvent inUiEvent : uiEvents) {
				if (inUiEvent != null) {
					
					UIEvent uiEvent = new UIEvent();
					if(inUiEvent.getPkey() != null)
						uiEvent = screenBuilderService.readUIEvent(inUiEvent.getPkey());
					
					uiEvent.setHotSpot(screenBuilderService.readHotSpot(hotSpot.getPkey()));
					uiEvent.setEventType(inUiEvent.getEventType());
					uiEvent.setToPage(screenBuilderService.readPage(inUiEvent.getToPage().getPkey()));
					uiEvent.setTransitionType(inUiEvent.getTransitionType());
					
					if (uiEvent.getPkey() != null) {
						screenBuilderService.updateUIEvent(uiEvent);
					} else {
						uiEvent.setHotSpot(hotSpot);
						screenBuilderService.createUIEvent(uiEvent);
					}
					
				}
			}
			
			hotSpot.setUiEvents(uiEvents);
			screenBuilderService.updateHotSpot(hotSpot);
						
		} else {
			return ERROR;
		}

		// reset the stuff
//		page = projectBuilderManager.readPage(page.getPkey());
//		hotSpots = page.getHotSpots();
		
		return SUCCESS;
	}
	

	public String prepareHotSpotForEdit() {
	
		if(hotSpot != null)
			hotSpot = screenBuilderService.readHotSpot(hotSpot.getPkey());
		
		return SUCCESS;
	}
	
		
	public String removePageHotSpot(){
		
		if(hotSpot != null) {
			hotSpot = screenBuilderService.readHotSpot(hotSpot.getPkey());
			screenBuilderService.deleteHotSpot(hotSpot);
		}
		
		// reset the stuff
//		page = projectBuilderManager.readPage(page.getPkey());
//		hotSpots = page.getHotSpots();
		
		return SUCCESS;
	}
	
	public String fetchAllHotSpotsOfPage() {
		
		page = screenBuilderService.readPage(page.getPkey());
		hotSpots = page.getHotSpots();
		
		return SUCCESS;
	}
	
	
	/* UIEvent related */
	
	public String prepareUiEventForEdit() {
		
		if(uiEvent != null) {
			uiEvent = screenBuilderService.readUIEvent(uiEvent.getPkey());
			hotSpot = uiEvent.getHotSpot();
		}
		
		return SUCCESS;
	}
	
	
	public String removeHotSpotUiEvent(){
		
		if(uiEvent != null) {
			// Delete uiEvent
			screenBuilderService.deleteUIEvent(uiEvent);
		}
		
		page = screenBuilderService.readPage(page.getPkey());
		hotSpots = page.getHotSpots();
		
		return SUCCESS;
	}
	
	
	/* private methods */
	
	private void buildRootHotSpotNode() {
		if(rootHotSpotNode == null)
			rootHotSpotNode = new HotSpot();
		
		if(hotSpots != null) {
			for (HotSpot childHotSpot : hotSpots) {
				if(childHotSpot.getParentHotSpot() == null)
					rootHotSpotNode.getChildHotSpots().add(hotSpot);
			}
		}
		
	}
	
	/* Getters and Setters */
	
	public MessageBean getMessageBean() {
		return messageBean;
	}

	public void setMessageBean(MessageBean messageBean) {
		this.messageBean = messageBean;
	}

	public ProjectService getProjectService() {
		return projectService;
	}

	public void setProjectService(ProjectService projectService) {
		this.projectService = projectService;
	}

	public ScreenBuilderService getScreenBuilderService() {
		return screenBuilderService;
	}

	public void setScreenBuilderService(
			ScreenBuilderService screenBuilderService) {
		this.screenBuilderService = screenBuilderService;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public Layout getLayout() {
		return layout;
	}

	public void setLayout(Layout layout) {
		this.layout = layout;
	}

	public Page getPage() {
		return page;
	}

	public void setPage(Page page) {
		this.page = page;
	}

	public List<Page> getPages() {
		return pages;
	}

	public void setPages(List<Page> pages) {
		this.pages = pages;
	}

	public ImageFile getImageFile() {
		return imageFile;
	}

	public void setImageFile(ImageFile imageFile) {
		this.imageFile = imageFile;
	}
	
	public InputStream getFileStream() {
		return fileStream;
	}

	public void setFileStream(InputStream fileStream) {
		this.fileStream = fileStream;
	}

	public ImageFileType getImageFileType() {
		return imageFileType;
	}

	public void setImageFileType(ImageFileType imageFileType) {
		this.imageFileType = imageFileType;
	}

	public List<ImageFile> getImageFiles() {
		return imageFiles;
	}

	public void setImageFiles(List<ImageFile> imageFiles) {
		this.imageFiles = imageFiles;
	}

	public List<ImageFile> getScreenImages() {
		return screenImages;
	}

	public void setScreenImages(List<ImageFile> screenImages) {
		this.screenImages = screenImages;
	}

	public List<ImageFile> getHeaderImages() {
		return headerImages;
	}

	public void setHeaderImages(List<ImageFile> headerImages) {
		this.headerImages = headerImages;
	}

	public List<ImageFile> getFooterImages() {
		return footerImages;
	}

	public void setFooterImages(List<ImageFile> footerImages) {
		this.footerImages = footerImages;
	}

	public List<ImageFile> getLeftNavImages() {
		return leftNavImages;
	}

	public void setLeftNavImages(List<ImageFile> leftNavImages) {
		this.leftNavImages = leftNavImages;
	}

	public List<ImageFile> getRightNavImages() {
		return rightNavImages;
	}

	public void setRightNavImages(List<ImageFile> rightNavImages) {
		this.rightNavImages = rightNavImages;
	}

	public HotSpot getHotSpot() {
		return hotSpot;
	}

	public void setHotSpot(HotSpot hotSpot) {
		this.hotSpot = hotSpot;
	}

	public List<HotSpot> getHotSpots() {
		return hotSpots;
	}

	public void setHotSpots(List<HotSpot> hotSpots) {
		this.hotSpots = hotSpots;
	}

	public Page getToPage() {
		return toPage;
	}

	public void setToPage(Page toPage) {
		this.toPage = toPage;
	}

	public UIEvent getUiEvent() {
		return uiEvent;
	}

	public void setUiEvent(UIEvent uiEvent) {
		this.uiEvent = uiEvent;
	}

	public List<UIEvent> getUiEvents() {
		return uiEvents;
	}

	public void setUiEvents(List<UIEvent> uiEvents) {
		this.uiEvents = uiEvents;
	}

	public HotSpot getRootHotSpotNode() {
		return rootHotSpotNode;
	}

	public void setRootHotSpotNode(HotSpot rootHotSpotNode) {
		this.rootHotSpotNode = rootHotSpotNode;
	}

	public PublishDetails getPublishDetails() {
		return publishDetails;
	}

	public void setPublishDetails(PublishDetails publishDetails) {
		this.publishDetails = publishDetails;
	}

	public List<User> getAppUsers() {
		return appUsers;
	}

	public void setAppUsers(List<User> appUsers) {
		this.appUsers = appUsers;
	}

	public Boolean getIsLandingPage() {
		return isLandingPage;
	}

	public void setIsLandingPage(Boolean isLandingPage) {
		this.isLandingPage = isLandingPage;
	}
	
	
	
	
}
