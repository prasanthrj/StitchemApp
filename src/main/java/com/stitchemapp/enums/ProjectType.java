package com.stitchemapp.enums;

public enum ProjectType {

	IPhone (320, 480, 320, 480, null, null), 
	IPad (1024, 768, 420, 560, 720, 540), 
	AndroidMobile (480, 800, 300, 500, null, null), 
	AndroidTab (1280, 800, 350, 560, 720, 450), 
	Webapp (1024, 900, 720, 540, null, null),
	Custom (null, null, null, null, null, null);

	private final Integer width;
	private final Integer height;
	
	
	/**
	 *  Project specific dimensions ..
	 *  
	 *  Here horizontal orientation is available for IPad and Tab only 
	 *  
	 */
	private final Integer vertLayoutWidth;
	private final Integer vertLayoutHeight;
	
	private final Integer horiLayoutWidth;
	private final Integer horiLayoutHeight;
	


	// Constructor
	private ProjectType(Integer width, Integer height, 
			Integer vertLayoutWidth, Integer vertLayoutHeight,
			Integer horiLayoutWidth, Integer horiLayoutHeight ) {
		this.width = width;
		this.height = height;
		this.vertLayoutWidth = vertLayoutWidth;
		this.vertLayoutHeight = vertLayoutHeight;
		
		if(horiLayoutWidth == null)
			horiLayoutWidth = vertLayoutWidth;
		
		if(horiLayoutHeight == null)
			horiLayoutHeight = vertLayoutHeight;
		
		this.horiLayoutWidth = horiLayoutWidth;
		this.horiLayoutHeight = horiLayoutHeight;
		
	}

	public Integer width() {
		return width;
	}

	public Integer height() {
		return height;
	}
		
	public Integer layoutWidth(OrientationType orientation) {
		switch (orientation) {
			case vertical:
				return vertLayoutWidth;
			case horizontal:
				return horiLayoutWidth;
			default:
				return vertLayoutWidth;
		}
	}

	public Integer layoutHeight(OrientationType orientation) {
		switch (orientation) {
			case vertical:
				return vertLayoutHeight;
			case horizontal:
				return horiLayoutHeight;
			default:
				return vertLayoutHeight;
		}
	}
	
//	public Integer maxThumbNailWidth() {
//		return maxThumbnailWidth;
//	}
//
//	public Integer maxThumbNailHeight() {
//		return maxThumbnailHeight;
//	}
	

}
