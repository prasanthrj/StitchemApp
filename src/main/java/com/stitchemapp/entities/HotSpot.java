package com.stitchemapp.entities;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlTransient;

import com.stitchemapp.enums.HotSpotType;
import com.stitchemapp.enums.MobileEvent;
import com.stitchemapp.enums.TransitionType;

@Entity
@Table(name = "project_hot_spots")
@NamedQueries({
	@NamedQuery(name="hotSpot.selectHotSpotsByPageAndType", query="SELECT instance from HotSpot instance where instance.page=:page AND instance.hotSpotType = :hotSpotType " ),
	@NamedQuery(name="hotSpot.selectHotSpotsByPage", query="SELECT instance from HotSpot instance where instance.page=:page" )
})
public class HotSpot extends BaseEntity {

	private Page page;
	
	private String title;
	private String description;
	
	private Float fromX;
	private Float fromY;

	private Float toX;
	private Float toY;

	private HotSpotType hotSpotType;
	
	private List<UIEvent> uiEvents;
	

	
	// ---------------------------------------------------------------
	// For V2
	private HotSpot parentHotSpot;
	private List<HotSpot> childHotSpots;
	
	
	
	
	
	@ManyToOne( fetch = FetchType.LAZY )
	@JoinColumn(name = "page_pkey", nullable = false)
	public Page getPage() {
		return page;
	}

	public void setPage(Page page) {
		this.page = page;
	}
	
	@Column(name = "hotspot_title")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Column(name = "hotspot_description")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Column(name="x1_coordinate_normalized", nullable = false)
	public Float getFromX() {
		return fromX;
	}

	public void setFromX(Float fromX) {
		this.fromX = fromX;
	}

	@Column(name="y1_coordinate_normalized", nullable = false)
	public Float getFromY() {
		return fromY;
	}

	public void setFromY(Float fromY) {
		this.fromY = fromY;
	}

	@Column(name="x2_coordinate_normalized", nullable = false)
	public Float getToX() {
		return toX;
	}

	public void setToX(Float toX) {
		this.toX = toX;
	}

	@Column(name="y2_coordinate_normalized", nullable = false)
	public Float getToY() {
		return toY;
	}

	public void setToY(Float toY) {
		this.toY = toY;
	}

	@Enumerated(EnumType.STRING)
	@Column(name = "hot_spot_type", nullable = false)
	public HotSpotType getHotSpotType() {
		if (hotSpotType == null) 
			hotSpotType = HotSpotType.Button;
				
		return hotSpotType;
	}

	public void setHotSpotType(HotSpotType hotSpotType) {
		this.hotSpotType = hotSpotType;
	}

	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.REMOVE, mappedBy="hotSpot")
	public List<UIEvent> getUiEvents() {
		return uiEvents;
	}

	public void setUiEvents(List<UIEvent> uiEvents) {
		this.uiEvents = uiEvents;
	}

	
	// ---------------------------------------------------------------
	
	
	
	@OneToOne (fetch = FetchType.LAZY )
	@JoinColumn(name = "parent_hot_spot_pkey")
	public HotSpot getParentHotSpot() {
		return parentHotSpot;
	}

	public void setParentHotSpot(HotSpot parentHotSpot) {
		this.parentHotSpot = parentHotSpot;
	}

	@XmlTransient
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "parentHotSpot")
	public List<HotSpot> getChildHotSpots() {
		if(this.childHotSpots == null)
			this.childHotSpots = new ArrayList<HotSpot>();
		
		return childHotSpots;
	}

	public void setChildHotSpots(List<HotSpot> childHotSpots) {
		this.childHotSpots = childHotSpots;
	}
	
//	public void addChild(HotSpot hotSpot){
//		if(this.childHotSpots == null)
//			this.childHotSpots = new ArrayList<HotSpot>();
//		
//		this.childHotSpots.add(hotSpot);
//	}
	
}
