package com.stitchemapp.enums;

public enum ProjectType {

	AndroidMobile (480, 800, 120, 180), 
	AndroidTab (1280, 800, 120, 180), 
	IPhone (320, 480, 120, 180), 
	IPad (1024, 768, 120, 180), 
	Webapp (1024, 900, 120, 180), 
	Custom (null, null, null, null);

	private final Integer width;
	private final Integer height;
	private final Integer maxThumbnailWidth;
	private final Integer maxThumbnailHeight;
	
	private Integer canvasWidth = 0;
	private Integer canvasHeight = 0;

	// Constructor
	private ProjectType(Integer width, Integer height, Integer maxThumbnailWidth, Integer maxThumbnailHeight) {
		this.width = width;
		this.height = height;
		this.maxThumbnailWidth = maxThumbnailWidth;
		this.maxThumbnailHeight = maxThumbnailHeight;
	}

	public Integer width() {
		return width;
	}

	public Integer height() {
		return height;
	}
		
	public Integer maxThumbNailWidth() {
		return maxThumbnailWidth;
	}

	public Integer maxThumbNailHeight() {
		return maxThumbnailHeight;
	}
	
	
	/*
	public Integer canvasWidth() {
		if (this.equals(ProjectType.AndroidTab) || this.equals(ProjectType.Ipad)) {
			canvasWidth = width / 2;
			return canvasWidth;
		}
		
		return width;
	}

	public Integer canvasHeight() {
		if (this.equals(ProjectType.AndroidTab) || this.equals(ProjectType.Ipad)) {
			canvasHeight = height / 2;
			return canvasHeight;
		}
		
		return height;
	}
	

	public String descriptionText() {
		switch (this) {
		case AndroidMobile:
			return "An android phone with a screen resolution of 480 X 800 px. Samsung galaxy, HTC wildfire, Nexus are some of the popular phones that has this resolution. ";
		case AndroidTab:
			return "";
		case Iphone3G:
			return "";
		case Iphone4:
			return "";
		case Ipad:
			return "";
		case Custom:
		default:
			return "";

		}

	}
	
	*/

}
