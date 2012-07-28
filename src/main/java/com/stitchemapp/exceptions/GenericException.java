package com.stitchemapp.exceptions;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import org.codehaus.jackson.annotate.JsonIgnore;

import com.stitchemapp.enums.ErrorCode;

@XmlRootElement( name = "errors" )
public class GenericException extends RuntimeException {
	
	private String message;
	private ErrorCode errorCode;
	private Exception exception;
	
	public GenericException(String message, ErrorCode errorCode) {
		super();
		this.message = message;
		this.errorCode = errorCode;
	}

	public GenericException(String message, ErrorCode errorCode, Exception exception){
        super(message,exception);
        this.message = message;
        this.errorCode = errorCode;
        this.exception = exception;
    }
	
	/* Getters and Setters */
	
	public String getMessage() {
		return message;
	}
	
	public void setMessage(String message) {
		this.message = message;
	}

	public ErrorCode getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(ErrorCode errorCode) {
		this.errorCode = errorCode;
	}

	@XmlTransient
	@JsonIgnore
	public Exception getException() {
		return exception;
	}
	
	public void setException(Exception exception) {
		this.exception = exception;
	}

}
