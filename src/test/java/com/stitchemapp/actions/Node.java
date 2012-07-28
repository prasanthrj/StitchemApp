package com.stitchemapp.actions;

import java.util.ArrayList;
import java.util.List;

public class Node {
	
	private int fromX;
	private int fromY;
	
	private int toX;
	private int toY;
	
//	private Node parent;
	
	private List<Node> children;
	
	public Node() {
		// TODO Auto-generated constructor stub
	}
	
	public Node(int fromX, int fromY, int toX, int toY) {
		this.fromX = fromX;
		this.fromY = fromY;
		
		this.toX = toX;
		this.toY = toY;
	
		children = new ArrayList<Node>();
		
	}
	
	public void addChild(Node node) {
		this.children.add(node);
	}
	
	public List<Node> getAllChildren() {
		return children;
	}
	
}
