package com.stitchemapp.analytics.impl;

import org.springframework.transaction.annotation.Transactional;

import com.stitchemapp.analytics.ActionRecorder;
import com.stitchemapp.analytics.entities.Event;
import com.stitchemapp.analytics.entities.Visit;
import com.stitchemapp.api.IDao;
import com.stitchemapp.beans.MessageBean;

public class ActionRecorderImpl implements ActionRecorder {

	private IDao genericDao;
	
	/* Methods */
	
	/* Event CRUD */

	@Transactional
	public MessageBean recordEvent(Event event) {
		if (event != null) {
			genericDao.save(event);	
		}
		
		return null;
	}
	
	
	/* Visit CRUD */
	
	@Transactional
	public void recordVisit(Visit visit) {
		if (visit != null) {
			genericDao.save(visit);		
		}
	}
	
	
	
	
	/* Getters and Setters */
	
	public IDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(IDao genericDao) {
		this.genericDao = genericDao;
	}

	
}
