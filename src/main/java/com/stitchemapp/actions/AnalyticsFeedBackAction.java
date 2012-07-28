package com.stitchemapp.actions;

import org.apache.log4j.Logger;

import com.stitchemapp.analytics.ActionAnalyzer;
import com.stitchemapp.services.ProjectService;

public class AnalyticsFeedBackAction extends GenericActionSupport {

	public static final Logger LOGGER = Logger.getLogger(AnalyticsFeedBackAction.class);
	
	private ProjectService projectService;
	private ActionAnalyzer actionAnalyzer;
	
	
	@Override
	public void prepare() throws Exception {
		super.prepare();
		
	}
	
	
	
	
	
}
