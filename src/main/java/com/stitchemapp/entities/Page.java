package com.stitchemapp.entities;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

@Entity
@Table(name = "project_page", uniqueConstraints = {
	@UniqueConstraint(columnNames = {"layout_pkey", "page_image_pkey"})
})
@NamedQueries({
	@NamedQuery(name="page.selectPagesByLayout", query="SELECT instance from Page instance where instance.layout=:layout" ),
	@NamedQuery(name="page.fetchPageByScreenImage", query="SELECT instance from Page instance where instance.screenImage=:screenImage" )
})
public class Page extends BaseEntity {

	private Layout layout;

	private String title;
	private String notes;
	
	private ImageFile screenImage;
	
	private ImageFile headerImage;
	private ImageFile footerImage;
	private ImageFile leftNavImage;
	private ImageFile rightNavImage;
	
	private List<HotSpot> hotSpots;

//	private List<Comment> comments;
		
	
	
	@ManyToOne( fetch = FetchType.LAZY )
	@JoinColumn(name = "layout_pkey", nullable = false)
	public Layout getLayout() {
		return layout;
	}

	public void setLayout(Layout layout) {
		this.layout = layout;
	}
	
	@Column(name = "page_tile")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Column(name = "page_notes", columnDefinition = "TEXT")
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	@OneToOne (cascade = CascadeType.ALL )
	@JoinColumn(name = "page_image_pkey", nullable = false)
	public ImageFile getScreenImage() {
		return screenImage;
	}

	public void setScreenImage(ImageFile image) {
		this.screenImage = image;
	}

	@ManyToOne (fetch = FetchType.LAZY )
	@JoinColumn(name = "header_image_pkey")
	public ImageFile getHeaderImage() {
		return headerImage;
	}

	public void setHeaderImage(ImageFile headerImage) {
		this.headerImage = headerImage;
	}

	@ManyToOne (fetch = FetchType.LAZY )
	@JoinColumn(name = "footer_image_pkey")
	public ImageFile getFooterImage() {
		return footerImage;
	}

	public void setFooterImage(ImageFile footerImage) {
		this.footerImage = footerImage;
	}

	@ManyToOne (fetch = FetchType.LAZY )
	@JoinColumn(name = "left_nav_image_pkey")
	public ImageFile getLeftNavImage() {
		return leftNavImage;
	}

	public void setLeftNavImage(ImageFile leftNavImage) {
		this.leftNavImage = leftNavImage;
	}

	@ManyToOne (fetch = FetchType.LAZY )
	@JoinColumn(name = "right_nav_image_pkey")
	public ImageFile getRightNavImage() {
		return rightNavImage;
	}

	public void setRightNavImage(ImageFile rightNavImage) {
		this.rightNavImage = rightNavImage;
	}

	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL ,mappedBy="page")
	public List<HotSpot> getHotSpots() {
		return hotSpots;
	}

	public void setHotSpots(List<HotSpot> hotSpots) {
		this.hotSpots = hotSpots;
	}

//	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, mappedBy="page")
//	public List<Comment> getComments() {
//		return comments;
//	}
//
//	public void setComments(List<Comment> comments) {
//		this.comments = comments;
//	}

}
