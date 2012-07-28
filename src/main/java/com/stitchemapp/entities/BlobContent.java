package com.stitchemapp.entities;

import java.io.File;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.Lob;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.apache.struts2.json.annotations.JSON;

import com.stitchemapp.enums.FileType;

@Entity
@Table(name = "blob_content")
public class BlobContent extends BaseEntity {

	private byte[] fileData;
	private FileType fileType;
	private File fileObj;
	private String FileName;
	private String ContentType;

	
	@Column(name="file_data")
	@Lob
	@Basic(fetch=FetchType.LAZY)
	@JSON(serialize=false)
	public byte[] getFileData() {
		return fileData;
	}

	public void setFileData(byte[] fileData) {
		this.fileData = fileData;
	}

	
	@Column(name = "file_type")
	@Enumerated(EnumType.STRING)
	public FileType getFileType() {
		return fileType;
	}

	public void setFileType(FileType fileType) {
		this.fileType = fileType;
	}

	@Transient
	public File getFileObj() {
		return fileObj;
	}

	public void setFileObj(File fileObj) {
		this.fileObj = fileObj;
	}

	@Column(name = "file_name")
	public String getFileName() {
		return FileName;
	}

	public void setFileName(String fileName) {
		FileName = fileName;
	}

	@Column(name = "file_content_type")
	public String getContentType() {
		return ContentType;
	}

	public void setContentType(String contentType) {
		ContentType = contentType;
	}

}
