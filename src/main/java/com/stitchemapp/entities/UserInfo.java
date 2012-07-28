package com.stitchemapp.entities;

import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "user_info")
public class UserInfo extends BaseEntity {
	
	private String FirstName;
	private String middleName;
	private String LastName;
	
	private Date dateOfBirth;
	private String contactNumber;
	private String address;

	private BlobContent image;
	private Integer thumbNailX;
	private Integer thumbNailY;

	private String skillSet;
	private String interests;
	
	private String aboutMe;
	private String preferences;
	private String additionalInfo;
	
	
	
	/* Getters and Setters */
	
	@Column(name = "first_name", nullable = false )
	public String getFirstName() {
		return FirstName;
	}

	public void setFirstName(String firstName) {
		FirstName = firstName;
	}

	@Column(name = "middle_name")
	public String getMiddleName() {
		return middleName;
	}

	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}

	@Column(name = "last_name", nullable = false )
	public String getLastName() {
		return LastName;
	}

	public void setLastName(String lastName) {
		LastName = lastName;
	}
	
	@Column(name = "date_of_birth")
	public Date getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	@Column(name = "contact_no")
	public String getContactNumber() {
		return contactNumber;
	}

	public void setContactNumber(String contactNumber) {
		this.contactNumber = contactNumber;
	}

	@Column(name = "address")
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	@OneToOne
	@JoinColumn(name = "blob_content_pkey")
	public BlobContent getImage() {
		return image;
	}

	public void setImage(BlobContent image) {
		this.image = image;
	}
	
	@Column(name = "thumbnail_x_coordinate")
	public Integer getThumbNailX() {
		return thumbNailX;
	}

	public void setThumbNailX(Integer thumbNailX) {
		this.thumbNailX = thumbNailX;
	}

	@Column(name = "thumbnail_y_coordinate")
	public Integer getThumbNailY() {
		return thumbNailY;
	}

	public void setThumbNailY(Integer thumbNailY) {
		this.thumbNailY = thumbNailY;
	}

	@Column(name = "skill_set")
	public String getSkillSet() {
		return skillSet;
	}

	public void setSkillSet(String skillSet) {
		this.skillSet = skillSet;
	}

	@Column(name = "interests")
	public String getInterests() {
		return interests;
	}

	public void setInterests(String interests) {
		this.interests = interests;
	}

	@Column(name = "abot_me", columnDefinition = "TEXT")
	public String getAboutMe() {
		return aboutMe;
	}

	public void setAboutMe(String aboutMe) {
		this.aboutMe = aboutMe;
	}

	@Column(name = "preferences", columnDefinition = "TEXT")
	public String getPreferences() {
		return preferences;
	}

	public void setPreferences(String preferences) {
		this.preferences = preferences;
	}
	
	@Column(name = "additional_info", columnDefinition = "TEXT")
	public String getAdditionalInfo() {
		return additionalInfo;
	}

	public void setAdditionalInfo(String additionalInfo) {
		this.additionalInfo = additionalInfo;
	}
	
	
}
