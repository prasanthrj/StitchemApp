package com.stitchemapp.actions;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.imageio.ImageIO;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.stitchemapp.entities.ImageFile;
import com.stitchemapp.entities.Page;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.PublishDetails;
import com.stitchemapp.entities.User;
import com.stitchemapp.services.ContentService;
import com.stitchemapp.services.ProjectService;
import com.stitchemapp.services.PublishingService;
import com.stitchemapp.services.ScreenBuilderService;
import com.stitchemapp.utils.RequestUtils;

public class PublishingAction extends GenericActionSupport {
	
	public static final Logger LOGGER = Logger.getLogger(PublishingAction.class);

	private ProjectService projectService;
	private ScreenBuilderService screenBuilderService;
	private PublishingService publishingService;
	private ContentService contentService;
	
	private Project project;
	private String docToPublish;
	private Boolean isIframe = false;
	
	private Page page;
	
	private User appUser;
	
	private PublishDetails publishDetails;	
	private Set<User> appUsers;
	
	// QR Code
	private ImageFile imageFile;
	private InputStream fileStream;
	
	private static final String charSetName = "ISO-8859-1";
	
		
	@Override
	public void prepare() throws Exception{
		super.prepare();
		
		String project_pkey = this.request.getParameter("project.pkey");
        if (project_pkey != null && StringUtils.isNotEmpty(project_pkey)){
            project = projectService.readProject(Integer.valueOf(project_pkey));
        }
        
        String pagePkey = this.request.getParameter("page.pkey");
        if (pagePkey != null && StringUtils.isNotEmpty(pagePkey)){
        	page = screenBuilderService.readPage(Integer.valueOf(pagePkey));
        }
		
//        String commentPkey = this.request.getParameter("comment.pkey");
//        if (commentPkey != null && StringUtils.isNotEmpty(commentPkey)){
//        	comment = publishingManager.readComment(Integer.valueOf(commentPkey));
//        }
        
        String appUserPkey = this.request.getParameter("appUser.pkey");
        if (appUserPkey != null && StringUtils.isNotEmpty(appUserPkey)){
        	appUser = userService.readUser(Integer.valueOf(appUserPkey));
        }

        String publishDetailsPkey = this.request.getParameter("publishDetails.pkey");
        if (publishDetailsPkey != null && StringUtils.isNotEmpty(publishDetailsPkey)){
        	publishDetails = publishingService.readPublishDetails(Integer.valueOf(publishDetailsPkey));
        }

	}
	
	
	
	
	/* Publishing Related */
	
	public String prepareProjectPublishDetails() {
		
		if(project != null){
			publishDetails = project.getPublishDetails();
			appUsers = project.getAppUsers();
		}
		
		return SUCCESS;
	}
	
	public String manageProjectPublishDetails() {
		
		if (project == null)
			return INPUT;
		
		if (publishDetails != null) {
			publishDetails.setIsPublished(true);
			if (publishDetails.getPkey() == null) {
				publishingService.createPublishDetails(publishDetails);
			} else {
				publishingService.updatePublishDetails(publishDetails);
			}
		}
		
		// AppUsers 
		List<User> newUsers = new ArrayList<User>();
		if (appUsers != null) {
			Set<User> latestAppUsers = project.getAppUsers();

			User user;
			for (User appUser : appUsers) {
				if (appUser != null && appUser.getPkey() == null) {
					user = userService.findOrCreateUser(appUser);
					latestAppUsers.add(user);
					newUsers.add(user);
				}
			}
			
			project.setAppUsers(latestAppUsers);
			projectService.updateProject(project);
		}
		
		String HostUrl = RequestUtils.fetchHostURL(request);
		publishingService.publishProjectDetailsAndUpdateAppUsers(project, HostUrl, newUsers);
		
		return SUCCESS;
	}
	
	
	
	public String publishProjectForMobile() {
		
		if( (project.getIsPublic() && project.getIsApproved()) 
				|| (!project.getIsPublic() && appUser != null ) ) {
			
			// Setting the Landing page details ..
			page = project.getLayout().getLandingPage();
			
			// project is ready and available ..
			docToPublish = publishingService.prepareProjectPublishDoc(project);
			
		} else {
			
		}
		
		return SUCCESS;
	}
	
	
	
	public String publishProjectForWeb() {
		
		if( (project.getIsPublic() && project.getIsApproved()) 
				|| (!project.getIsPublic() && appUser != null ) ) {
			
			// Setting the Landing page details ..
			page = project.getLayout().getLandingPage();
			
			// project is ready and available ..
			docToPublish = publishingService.prepareProjectPublishDoc(project);
			
		} else {
			
		}
		
		return SUCCESS;
	}

	

	/* Preview related */
	
	public String generateProjectPreview() {
		
		if (project == null)
			return INPUT;
		
		// project is ready and available ..
		docToPublish = publishingService.prepareProjectPublishDoc(project);
				
		return SUCCESS;
	}
	
	
	
	/* QR Codes .. */
	
	public String generateQRCodeForMobilePublishing(){
		if( project != null ){
			
			if(!project.getIsPublic() && appUser != null) {
				// check for appUser correctness 
				return INPUT;
			} 

			
			StringBuffer publishUrl = new StringBuffer();
			publishUrl.append(RequestUtils.fetchHostURL(request));
			publishUrl.append("/publish/mobile?project.pkey=").append(project.getPkey());

			// Encoding ..
			Charset charset = Charset.forName(charSetName);
			CharsetEncoder encoder = charset.newEncoder();
			byte[] stringInBytes = null;
			byte[] QRCodeInBytes = null;
			
			try {
				// Convert a string to ISO-8859-1 bytes in a ByteBuffer
				ByteBuffer byteBuf = encoder.encode(CharBuffer.wrap(publishUrl));
				stringInBytes = byteBuf.array();
				
				String data = new String(stringInBytes, charSetName);
				
				// get a byte matrix for the data
				int QRImageHeight = 150;
				int QRImageWidth = 150;
				com.google.zxing.Writer writer = new QRCodeWriter();
				
				BitMatrix matrix = writer.encode(data, BarcodeFormat.QR_CODE, QRImageWidth, QRImageHeight);
				BufferedImage qrCode = MatrixToImageWriter.toBufferedImage(matrix);
				
				
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				
				ImageIO.write( qrCode, "jpg", baos );
				baos.flush();
				QRCodeInBytes = baos.toByteArray();
				baos.close();
				
			} catch (CharacterCodingException e) {
				System.out.println(e.getMessage());
			} catch (UnsupportedEncodingException e) {
				System.out.println(e.getMessage());
			} catch (com.google.zxing.WriterException e) {
				System.out.println(e.getMessage());
			} catch (IOException e) {
				e.printStackTrace();
			}

			ByteArrayInputStream bis = new ByteArrayInputStream(QRCodeInBytes);
			
			setFileStream(bis);

		}
		
		return SUCCESS;
	}
	
	
	
	/* Local Methods .. */
	
	
	
	/* Getters And Setters */
	
	
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

	public PublishingService getPublishingService() {
		return publishingService;
	}

	public void setPublishingService(PublishingService publishingService) {
		this.publishingService = publishingService;
	}

	public ContentService getContentService() {
		return contentService;
	}

	public void setContentService(ContentService contentService) {
		this.contentService = contentService;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public String getDocToPublish() {
		return docToPublish;
	}

	public void setDocToPublish(String docToPublish) {
		this.docToPublish = docToPublish;
	}

	public Boolean getIsIframe() {
		if(this.isIframe == null)
			isIframe = false;
		return isIframe;
	}

	public void setIsIframe(Boolean isIframe) {
		this.isIframe = isIframe;
	}

	public Page getPage() {
		return page;
	}

	public void setPage(Page page) {
		this.page = page;
	}

	public User getAppUser() {
		return appUser;
	}

	public void setAppUser(User appUser) {
		this.appUser = appUser;
	}

	public PublishDetails getPublishDetails() {
		return publishDetails;
	}

	public void setPublishDetails(PublishDetails publishDetails) {
		this.publishDetails = publishDetails;
	}

	public Set<User> getAppUsers() {
		return appUsers;
	}

	public void setAppUsers(Set<User> appUsers) {
		this.appUsers = appUsers;
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



}
