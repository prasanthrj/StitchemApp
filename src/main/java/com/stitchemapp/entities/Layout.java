package com.stitchemapp.entities;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.apache.commons.io.filefilter.FalseFileFilter;

import com.stitchemapp.enums.OrientationType;

@Entity
@Table(name = "project_layout")
public class Layout extends BaseEntity {
	
	private Integer width;
	private Integer height;
	
	private OrientationType orientation;

	private Page landingPage;
	private List<Page> pages;
	
	
	
	// Getters abd Setters ..
	
	@Column(name="layout_width")
	public Integer getWidth() {
		return width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	@Column(name="layout_height")
	public Integer getHeight() {
		return height;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	@Enumerated(EnumType.STRING)
	@Column(name="orientaion")
	public OrientationType getOrientation() {
		return orientation;
	}

	public void setOrientation(OrientationType orientation) {
		this.orientation = orientation;
	}

	@OneToOne
	@JoinColumn( name = "landing_page_pkey" )
	public Page getLandingPage() {
		return landingPage;
	}

	public void setLandingPage(Page landingPage) {
		this.landingPage = landingPage;
	}

	
	@OneToMany(fetch = FetchType.LAZY, mappedBy="layout")
	public List<Page> getPages() {
		return pages;
	}

	public void setPages(List<Page> pages) {
		this.pages = pages;
	}
	
	
}
