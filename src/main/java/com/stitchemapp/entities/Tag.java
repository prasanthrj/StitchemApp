package com.stitchemapp.entities;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import org.hibernate.search.annotations.Field;
import org.hibernate.search.annotations.Index;

@Entity
@Table (name = "tags", uniqueConstraints = {
		@UniqueConstraint(columnNames = {"title"})
})
@NamedQueries({
	@NamedQuery(name="tag.selectTagByName", query="SELECT instance from Tag instance where instance.title=:title"),
})

public class Tag extends BaseEntity {

	@Field(index=Index.TOKENIZED)
	private String title;
	
	@Field(index=Index.TOKENIZED)
	private String description;
	
	private List<Tag> relevantTags;
	
	private Integer count;
	
	
	/* Constructors */
	
	public Tag() {
		// TODO Auto-generated constructor stub
	}
	
	public Tag(String title) {
		super();
		this.title = title;
	}
	

	
	/* Getters and Setters */
	
	@Column (name = "title", nullable = false )
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Column (name = "description", columnDefinition = "TEXT")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	@ManyToMany
	@JoinTable(name = "tags_to_relevant_tags",
			joinColumns = @JoinColumn(name = "tag_pkey"),
			inverseJoinColumns = @JoinColumn(name = "relevant_tag_pkey"))
	public List<Tag> getRelevantTags() {
		return relevantTags;
	}

	public void setRelevantTags(List<Tag> relevantTags) {
		this.relevantTags = relevantTags;
	}

	@Column(name = "entries_count")
	public Integer getCount() {
		if (count == null) 
			count = 0;
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}
	
}
