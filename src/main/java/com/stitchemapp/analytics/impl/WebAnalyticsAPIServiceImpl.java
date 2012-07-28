package com.stitchemapp.analytics.impl;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.codehaus.jettison.json.JSONObject;

import com.stitchemapp.analytics.ActionAnalyzer;
import com.stitchemapp.analytics.ActionRecorder;
import com.stitchemapp.analytics.WebAnalyticsAPIService;
import com.stitchemapp.analytics.entities.Event;
import com.stitchemapp.beans.MessageBean;

@Path("/api/analytics/v1")
public class WebAnalyticsAPIServiceImpl implements WebAnalyticsAPIService {

	private ActionRecorder actionRecorder;
	private ActionAnalyzer actionAnalyzer;

	/* Page events */

	// http://localhost:9090/SimpleAnalytics/rest/api/analytics/v1/record/event/

	@Path("/record/event/")
	@POST
	@Produces({  MediaType.APPLICATION_JSON })
	public JSONObject recordEvent(@QueryParam("event") JSONObject event,
			@Context HttpServletRequest request) {

		Event newEvent = new Event();

		newEvent.setTimeStamp(new Date());
		newEvent.setSessionId(request.getSession(true).getId());

		MessageBean statusMsg = actionRecorder.recordEvent(newEvent);

		JSONObject resutObj = new JSONObject();
		

		return resutObj;
	}

	// http://localhost:9090/SimpleAnalytics/rest/api/analytics/v1/record/visit/

	@Path("/record/visit/")
	@POST
	@Produces({ MediaType.APPLICATION_JSON })
	public JSONObject recordVisit(@FormParam("pageURI") String pageURI,
			@Context HttpServletRequest request) {

		System.out.println(pageURI);
		System.out.println("SessionId :" + request.getSession(true).getId());

		System.out
				.println("---------------------------------#-------------------------------------");

		System.out.println("RemoteAddr :" + request.getRemoteAddr());
		System.out.println("User-Agent :" + request.getHeader("User-Agent"));

		System.out
				.println("---------------------------------#-------------------------------------");

		System.out.println("Host :" + request.getHeader("Host"));

		System.out
				.println("---------------------------------#-------------------------------------");

		JSONObject resutObj = new JSONObject();
		
		return null;
	}

	public Integer fetchPageVisitCount(String pageURI) {

		return 0;
	}
	
	
	

	/* Getters and Setters */

	public ActionRecorder getActionRecorder() {
		return actionRecorder;
	}

	public void setActionRecorder(ActionRecorder actionRecorder) {
		this.actionRecorder = actionRecorder;
	}

	public ActionAnalyzer getActionAnalyzer() {
		return actionAnalyzer;
	}

	public void setActionAnalyzer(ActionAnalyzer actionAnalyzer) {
		this.actionAnalyzer = actionAnalyzer;
	}

}
