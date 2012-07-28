package com.stitchemapp.utils;

public class Convert {
	
	
	// Rounding off the value to two decimal Points..
	
	public static double round2decimals(double inpNum) {
		double result = inpNum * 100;
		result = Math.round(result);
		result = result / 100;
		return result;
	}

}
