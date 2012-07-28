package com.stitchemapp.analytics;

import com.stitchemapp.analytics.entities.Event;
import com.stitchemapp.analytics.entities.Visit;
import com.stitchemapp.beans.MessageBean;

public interface ActionRecorder {
	
	
	
	/* Event CRUD */
	
	MessageBean recordEvent(Event event);
	
	
	
	/* Visit CRUD */
	
	void recordVisit(Visit visit);
	
	
	
	

}
