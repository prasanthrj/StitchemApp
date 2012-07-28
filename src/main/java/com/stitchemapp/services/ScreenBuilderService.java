package com.stitchemapp.services;

import java.util.List;

import com.stitchemapp.entities.HotSpot;
import com.stitchemapp.entities.ImageFile;
import com.stitchemapp.entities.Layout;
import com.stitchemapp.entities.Page;
import com.stitchemapp.entities.Project;
import com.stitchemapp.entities.UIEvent;
import com.stitchemapp.enums.ImageFileType;

public interface ScreenBuilderService {
	
	
	/* Layout related + CRUD */
	
	void createLayout(Layout layout);
	
	Layout readLayout(Integer pkey);
	
	void updateLayout(Layout layout);
	
	void deleteLayout(Layout layout);
	
	
	
	/* Images */
	
	void createImageFile(ImageFile imageFile);
	
	ImageFile readImageFile(Integer pkey);
	
	void updateImageFile(ImageFile imageFile);
	
	void deleteImageFile(ImageFile imageFile);
	
	
	List<ImageFile> fetchProjectScreenImages(Project project);
	
	List<ImageFile> fetchProjectHeaderImages(Project project);
	
	List<ImageFile> fetchProjectFooterImages(Project project);
	
	List<ImageFile> fetchProjectLeftNavImages(Project project);
	
	List<ImageFile> fetchProjectRightNavImages(Project project);
	
	
	void storeProjectImageFile(Project project, ImageFile imageFile);
	
//	void storeProjectImageFiles(Project project, List<ImageFile> imageFiles);
	
	Page createPageForProjectScreenImage (Project project, ImageFile imageFile);
	
	void createPagesForProjectScreenImages (Project project, List<ImageFile> imageFiles);
	
	
	
	
	
	/* Page related + CRUD */
	
	void createPage(Page page);
	
	Page readPage(Integer pkey);
	
	void updatePage(Page page);
	
	void updatePage(Page page, ImageFile imageFile);
	
	void deletePage(Page page);

	
	
	List<Page> fetchPagesByLayout(Layout layout);
	
	Page fetchPageByScreenImage(ImageFile screenImage);
	
	
	
	/* HotSpot Related + CRUD */
	
	
	void createHotSpot(HotSpot hotSpot);
	
	HotSpot readHotSpot(Integer pkey);
	
	void updateHotSpot(HotSpot hotSpot);
	
	void deleteHotSpot(HotSpot hotSpot);
	
	
	// Not In Use 
	List<HotSpot> fetchHotSpotsByPage(Page page);
	
	// Not In Use 
//	List<HotSpot> fetchHotSpotsByToPage (Page toPage);
	
	
	
	// Not In Use 
	List<HotSpot> fetchButtonsByPage(Page page);
	
	// Not In Use 
	List<HotSpot> fetchHeatContoursByPage(Page page);
	
	
	
	
	
	/* UI Event CRUD -- :)  */
	
	void createUIEvent(UIEvent uiEvent);
	
	UIEvent readUIEvent(Integer pkey);
	
	void updateUIEvent(UIEvent uiEvent);
	
	void deleteUIEvent(UIEvent event);
	
	
}
