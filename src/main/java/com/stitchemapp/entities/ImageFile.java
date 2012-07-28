package com.stitchemapp.entities;

import java.io.File;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

import org.apache.struts2.json.annotations.JSON;

import com.stitchemapp.enums.ImageFileType;

@Entity
@org.hibernate.annotations.Entity ( dynamicInsert = true, dynamicUpdate = true )
@Table(name = "images", uniqueConstraints = {
	@UniqueConstraint(columnNames = {"image_type", "image_label", "image_content_type", "project_pkey"})
})
@NamedQueries({
	@NamedQuery(name="images.selectProjectImagesByType", query="SELECT instance from ImageFile instance where instance.project=:project AND instance.imageType=:imageType")
})
public class ImageFile extends BaseEntity {

	private Project project;
	
	private ImageFileType imageType;

	private byte[] image;
	
	private File fileObj;
	private String fileObjFileName;
	private String fileObjContentType;
	
	private Integer height;
	private Integer width;
	
	private byte[] thumbNail;
	
	private Boolean isPageCreated = false;
	
	
	@ManyToOne (fetch = FetchType.LAZY)
	@JoinColumn(name = "project_pkey")
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}
	
	@Enumerated(EnumType.STRING)
	@Column(name = "image_type", nullable = false)
	public ImageFileType getImageType() {
		return imageType;
	}

	public void setImageType(ImageFileType imageType) {
		this.imageType = imageType;
	}

	@Lob
	@Basic(fetch=FetchType.LAZY)
	@JSON(serialize=false)
	@Column(name="image_lob")
	public byte[] getImage() {
		return image;
	}

	public void setImage(byte[] image) {
		this.image = image;
	}

	@Transient
	public File getFileObj() {
		return fileObj;
	}

	public void setFileObj(File fileObj) {
		this.fileObj = fileObj;
	}

	@Column(name="image_label")
	public String getFileObjFileName() {
		return fileObjFileName;
	}

	public void setFileObjFileName(String fileObjFileName) {
		this.fileObjFileName = fileObjFileName;
	}

	@Column(name="image_content_type")
	public String getFileObjContentType() {
		return fileObjContentType;
	}

	public void setFileObjContentType(String fileObjContentType) {
		this.fileObjContentType = fileObjContentType;
	}

	@Column(name="height")
	public Integer getHeight() {
		return height;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	@Column(name="width")
	public Integer getWidth() {
		return width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	
	@Lob
	@Basic(fetch=FetchType.LAZY)
	@JSON(serialize=false)
	@Column(name="image_thumb_nail")
	public byte[] getThumbNail() {
		return thumbNail;
	}

	public void setThumbNail(byte[] thumbNail) {
		this.thumbNail = thumbNail;
	}

	@Column(name = "is_page_created", columnDefinition="BIT(1) default 0")
	public Boolean getIsPageCreated() {
		return isPageCreated;
	}

	public void setIsPageCreated(Boolean isPageCreated) {
		this.isPageCreated = isPageCreated;
	}
	
	
}
