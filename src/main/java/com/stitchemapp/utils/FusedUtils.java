package com.stitchemapp.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.log4j.Logger;

import com.stitchemapp.exceptions.GenericException;

public class FusedUtils {
	
	
	private static Logger LOGGER = Logger.getLogger(FusedUtils.class);
	
	
	public static byte[] getBytesFromFile(File file) throws IOException, GenericException {
		InputStream is = new FileInputStream(file);
		byte[] bytes = new byte[0];
		try {
			// Get the size of the file
			long length = file.length();

			if (length > Integer.MAX_VALUE) {
//				throw FusedException.create("File Size too Large",	MessageLevel.SEVERE);
			}

			// Create the byte array to hold the data
			bytes = new byte[(int) length];

			// Read in the bytes
			int offset = 0;
			int numRead = 0;
			while (offset < bytes.length
					&& (numRead = is.read(bytes, offset, bytes.length - offset)) >= 0) {
				offset += numRead;
			}

			// Ensure all the bytes have been read in
			if (offset < bytes.length) {
				throw new IOException("Could not completely read file "
						+ file.getName());
			}
		} finally {
			// Close the input stream and return bytes
			if (is != null)
				is.close();
		}
		
		return bytes;
	}
	
	
	public static String extractFileNameWithOutExtension(String inFileName) {
//		String[] temp = inFileName.split(".");
		
		return null;
	}

}
