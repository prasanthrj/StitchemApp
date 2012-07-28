package com.stitchemapp.actions;

import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

public class GenericSessionAwareActionSupport extends GenericActionSupport implements SessionAware {

	private Map<String,Object> sessionMap;
	
	public void setSession(Map<String, Object> session) {
		this.sessionMap = session;
	}
	
	public Object getFromSession(String key){
		if (!sessionMap.containsKey(key))
			return null;
		
		return sessionMap.get(key);
	}
	
	public void addToSession(String key,Object object){
		sessionMap.put(key, object);
	}
	
	public Object removeFromSession(String key){
		if (sessionMap.containsKey(key))
			return sessionMap.remove(key);
		
		return null;
	}

}
