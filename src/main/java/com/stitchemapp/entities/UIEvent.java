package com.stitchemapp.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.stitchemapp.enums.MobileEvent;
import com.stitchemapp.enums.TransitionType;

@Entity
@Table(name = "hot_spot_events")
public class UIEvent extends BaseEntity {

	private HotSpot hotSpot;
	
	private MobileEvent eventType;
	private TransitionType transitionType;
	private Page toPage;
	
	private String description;

	@ManyToOne( fetch = FetchType.LAZY )
	@JoinColumn(name = "hot_spot_pkey", nullable = false)
	public HotSpot getHotSpot() {
		return hotSpot;
	}

	public void setHotSpot(HotSpot hotSpot) {
		this.hotSpot = hotSpot;
	}
	
	@Enumerated(EnumType.STRING)
	@Column(name = "on_event_type", nullable = false)
	public MobileEvent getEventType() {
		if (eventType == null) 
			eventType = MobileEvent.tap;
		
		return eventType;
	}

	public void setEventType(MobileEvent eventType) {
		this.eventType = eventType;
	}

	@Enumerated(EnumType.STRING)
	@Column(name = "transition_type" )
	public TransitionType getTransitionType() {
		if (transitionType == null) 
			transitionType = TransitionType.none;
		
		return transitionType;
	}

	public void setTransitionType(TransitionType transitionType) {
		this.transitionType = transitionType;
	}

	@ManyToOne( fetch = FetchType.LAZY )
	@JoinColumn(name = "to_page_pkey")
	public Page getToPage() {
		return toPage;
	}

	public void setToPage(Page toPage) {
		this.toPage = toPage;
	}

	@Column(name = "event_description")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	
}
