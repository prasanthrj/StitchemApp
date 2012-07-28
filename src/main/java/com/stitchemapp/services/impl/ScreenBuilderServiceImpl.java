package com.stitchemapp.services.impl;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.Hashtable;
import java.util.List;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

import org.apache.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;

import com.stitchemapp.api.IDao;
import com.stitchemapp.constants.Constants;
import com.stitchemapp.entities.HotSpot;
import com.stitchemapp.entities.ImageFile;
import com.stitchemapp.entities.Layout;
import com.stitchemapp.entities.Page;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.UIEvent;
import com.stitchemapp.enums.HotSpotType;
import com.stitchemapp.enums.ImageFileType;
import com.stitchemapp.services.ProjectService;
import com.stitchemapp.services.ScreenBuilderService;
import com.stitchemapp.utils.FusedUtils;

public class ScreenBuilderServiceImpl implements ScreenBuilderService {

	public static final Logger LOGGER = Logger.getLogger(ScreenBuilderServiceImpl.class);

	private IDao genericDao;
	private ProjectService projectService;

	
	
	
	@Transactional
	public void createLayout(Layout layout) {
		if(layout != null ) {
			genericDao.save(layout);
		}
	}

	public Layout readLayout(Integer pkey) {
		return genericDao.find(Layout.class, pkey);
	}

	
	// Only useful method
	@Transactional
	public void updateLayout(Layout layout) {
		if(layout != null  ) {
			genericDao.update(layout);
		}
	}

	@Transactional
	public void deleteLayout(Layout layout) {
		if(layout != null ) {
			genericDao.delete(layout);
		}
	}
	
	
	
	/* Images */
	
	@Transactional
	public void createImageFile(ImageFile imageFile) {
		if(imageFile != null) {
			genericDao.save(imageFile);
		}
	}
	
	public ImageFile readImageFile(Integer pkey) {
		return genericDao.find(ImageFile.class, pkey);
	}

	@Transactional
	public void updateImageFile(ImageFile imageFile) {
		if(imageFile != null) {
			genericDao.update(imageFile);
		}
	}

	@Transactional
	public void deleteImageFile(ImageFile imageFile) {
		if(imageFile != null) {
			
			if(imageFile.getImageType().equals(ImageFileType.ScreenImage)){
				Page page = fetchPageByScreenImage(imageFile);
				deletePage(page);
			} else {
				// TODO remove references ..
				genericDao.delete(imageFile);
			}
									
		}
	}
	
	
	@Transactional
	public void storeProjectImageFile(Project project, ImageFile imageFile){
		try {
			
			File file = imageFile.getFileObj();
			byte[] bytes = FusedUtils.getBytesFromFile(file);
			imageFile.setImage(bytes);
			
			// Thumb Nail ...
//			imageFile.setThumbNail(this.createThumbNailFromImage(imageFile.getImage()));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		imageFile.setProject(project);
		
		if(imageFile.getPkey() != null){
			this.updateImageFile(imageFile);
		} else {
			this.createImageFile(imageFile);
		}
		
	}
	
	public List<ImageFile> fetchProjectScreenImages(Project project) {
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("project", project);
		ht.put("imageType", ImageFileType.ScreenImage);
		return genericDao.getEntities(ImageFile.class, "images.selectProjectImagesByType", ht);
	}
	
	public List<ImageFile> fetchProjectHeaderImages(Project project) {
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("project", project);
		ht.put("imageType", ImageFileType.Header);
		return genericDao.getEntities(ImageFile.class, "images.selectProjectImagesByType", ht);
	}
	
	public List<ImageFile> fetchProjectFooterImages(Project project) {
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("project", project);
		ht.put("imageType", ImageFileType.Footer);
		return genericDao.getEntities(ImageFile.class, "images.selectProjectImagesByType", ht);
	}
	
	public List<ImageFile> fetchProjectLeftNavImages(Project project) {
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("project", project);
		ht.put("imageType", ImageFileType.LeftNavBar);
		return genericDao.getEntities(ImageFile.class, "images.selectProjectImagesByType", ht);
	}
	
	public List<ImageFile> fetchProjectRightNavImages(Project project) {
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("project", project);
		ht.put("imageType", ImageFileType.RightNavBar);
		return genericDao.getEntities(ImageFile.class, "images.selectProjectImagesByType", ht);
	}
	
	@Transactional
	public Page createPageForProjectScreenImage (Project project, ImageFile imageFile) {
		
		// Creating default page ..
		Page page = new Page();
		
		if (imageFile != null && !imageFile.getIsPageCreated()) {
			
			
			page.setLayout(project.getLayout());
			page.setScreenImage(imageFile);
			page.setTitle(this.prepareGenericPageTitle(imageFile));
			
			this.createPage(page);
			
			// update Image file
			imageFile.setIsPageCreated(true);
			this.updateImageFile(imageFile);
			
			// Set Landing page ..
			if(project.getLayout().getLandingPage() != null){
				Layout layout = project.getLayout();
				layout.setLandingPage(page);
				this.updateLayout(layout);
			}

		}
		
		return page;
								
	}
	
	
	private String prepareGenericPageTitle(ImageFile imageFile) {
		StringBuffer pageTitle = new StringBuffer("page-");
		
		String imageFileName = imageFile.getFileObjFileName();
		if(imageFileName != null){
			String[] temp = imageFileName.split("\\.");
			for (int i = 0; i < temp.length-1 ; i++) {
				pageTitle.append(temp[i]);
			}
		} else {
			pageTitle.append(imageFile.getPkey());
		}
		
		return pageTitle.toString();
	}

	@Transactional
	public void createPagesForProjectScreenImages (Project project, List<ImageFile> imageFiles) {
		
		if (imageFiles == null)
			imageFiles = this.fetchProjectScreenImages(project);

		if(imageFiles != null){
			
			for (int i = 0; i < imageFiles.size(); i++) {
				ImageFile imageFile = imageFiles.get(i);
				
				if (imageFile != null && !imageFile.getIsPageCreated()) {
					
					// Creating default page ..
					this.createPageForProjectScreenImage(project, imageFile);
					
				}
								
			}
			
		}
		
	}
	
	
	/* Page related + CRUD */
	
	@Transactional
	public void createPage(Page page) {
		if(page != null && page.getLayout() != null) {
			genericDao.save(page);
		}
	}

	public Page readPage(Integer pkey) {
		return genericDao.find(Page.class, pkey);
	}

	@Transactional
	public void updatePage(Page page) {
		if(page != null && page.getLayout() != null) {
			genericDao.update(page);
		}
	}
	
	@Transactional
	public void updatePage(Page page, ImageFile imageFile) {
		
		/* Image File Type is known from the ImageFile itself .... avoid extra param "imageFileType" */
		ImageFileType imageFileType = imageFile.getImageType();
		
		if (imageFile.getPkey() == -1) {
			imageFile = null;
		}
		
		if(page != null) {
			switch (imageFileType) {
				case ScreenImage:
					// TODO update screenImage ...
					break;
				case Header:
					page.setHeaderImage(imageFile);
					break;
				case Footer:
					page.setFooterImage(imageFile);
					break;
				case LeftNavBar:
					page.setLeftNavImage(imageFile);
					break;
				case RightNavBar:
					page.setRightNavImage(imageFile);
					break;
	
				default:
					break;
			}
			
			genericDao.update(page);
			
		}
	}
	

	@Transactional
	public void deletePage(Page page) {
		if(page != null) {
			genericDao.delete(page);
		}
	}

	
	
	public List<Page> fetchPagesByLayout(Layout layout) {
		
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("layout", layout);
		
		return genericDao.getEntities(Page.class, "page.selectPagesByLayout",ht);
	}
	
	public Page fetchPageByScreenImage(ImageFile screenImage) {
		
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("screenImage", screenImage);
		
		return genericDao.getEntity(Page.class, "page.fetchPageByScreenImage",ht);
	}

	
	
	/* HotSpot Related + CRUD */
	
	@Transactional
	public void createHotSpot(HotSpot hotSpot) {
		if(hotSpot != null && hotSpot.getPage() != null) {
			genericDao.save(hotSpot);
		}
	}

	public HotSpot readHotSpot(Integer pkey) {
		return genericDao.find(HotSpot.class, pkey);
	}

	@Transactional
	public void updateHotSpot(HotSpot hotSpot) {
		if(hotSpot != null && hotSpot.getPage() != null) {
			genericDao.update(hotSpot);
		}
	}
	
	@Transactional
	public void deleteHotSpot(HotSpot hotSpot) {
		if(hotSpot != null) {
			genericDao.delete(hotSpot);
		}
	}

	
	
	public List<HotSpot> fetchHotSpotsByPage(Page page){
		
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("page", page);

		return genericDao.getEntities(HotSpot.class, "hotSpot.selectHotSpotsByPage",ht);
	}
	
	/*
	public List<HotSpot> fetchHotSpotsByToPage(Page toPage){
		
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("toPage", toPage);

		return genericDao.getEntities(HotSpot.class, "hotSpot.selectHotSpotsByToPage",ht);
	}
	*/
	
	
	// Not In Use
	public List<HotSpot> fetchButtonsByPage(Page page) {
		
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("page", page);
		ht.put("hotSpotType", HotSpotType.Button);
		
		return genericDao.getEntities(HotSpot.class, "hotSpot.selectHotSpotsByPageAndType",ht);
	}

	// Not In Use
	public List<HotSpot> fetchHeatContoursByPage(Page page) {
		
		Hashtable<String, Object> ht = new Hashtable<String, Object>();
		ht.put("page", page);
		ht.put("hotSpotType", HotSpotType.HeatContour);
		
		return genericDao.getEntities(HotSpot.class, "hotSpot.selectHotSpotsByPageAndType",ht);
	}

	
	
	/* UI Event CRUD -- :)  */
	
	@Transactional
	public void createUIEvent(UIEvent uiEvent) {
		if(uiEvent != null && uiEvent.getToPage() != null) {
			genericDao.save(uiEvent);
		}
	}

	public UIEvent readUIEvent(Integer pkey) {
		return genericDao.find(UIEvent.class, pkey);
	}

	@Transactional
	public void updateUIEvent(UIEvent uiEvent) {
		if(uiEvent != null && uiEvent.getToPage() != null) {
			genericDao.update(uiEvent);
		}
	}
	
	@Transactional
	public void deleteUIEvent(UIEvent uiEvent) {
		if(uiEvent != null) {
			genericDao.delete(uiEvent);
		}
	}

	
	
	
	/*  Local Methods .. */
	
	private byte[] createThumbNailFromImage(byte[] image){
		
		ImageIcon imageData = new ImageIcon(image);
		
		if( imageData.getIconWidth() > Constants.DEFAULT_THUMB_NAIL_WIDTH ) {
			
			Integer thumbNailWidth = Constants.DEFAULT_THUMB_NAIL_WIDTH;
			Integer thumbNailHeight = Math.round( Constants.DEFAULT_THUMB_NAIL_WIDTH * ((float)imageData.getIconHeight() / (float)imageData.getIconWidth() ) );
						
			BufferedImage bufferedResizedImage = new BufferedImage(thumbNailWidth, thumbNailHeight, BufferedImage.TYPE_INT_RGB);
			Graphics2D g2d = bufferedResizedImage.createGraphics();
			g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
			g2d.drawImage(imageData.getImage(), 0, 0, thumbNailWidth, thumbNailHeight, null);
			g2d.dispose();
			
			
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] thumbnailInByte = null;
			
			try {
				ImageIO.write( bufferedResizedImage, "jpg", baos );
				baos.flush();
				thumbnailInByte = baos.toByteArray();
				baos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}

			if (thumbnailInByte == null) 
				thumbnailInByte = image;
			
			return thumbnailInByte;
			
		} else {
			return image;				
		}
		
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

}
