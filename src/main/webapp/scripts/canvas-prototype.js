// Fixed: Minus xStep bug (when x2 < x, original code bugs) 
// Fixed: Vertical line bug (when abs(x - x2) is zero, original code bugs because of NaN) 

var CP = window.CanvasRenderingContext2D && CanvasRenderingContext2D.prototype;

if (CP && CP.lineTo) {
	
	CP.dashedLine = function(x, y, x2, y2, dashArray) {
		
		this.beginPath();
		
		if (!dashArray)
			dashArray = [ 4, 4 ];
		
		var dashCount = dashArray.length;
		var dx = (x2 - x);
		var dy = (y2 - y);
		var xSlope = (Math.abs(dx) > Math.abs(dy));
		var slope = (xSlope) ? dy / dx : dx / dy;

		this.moveTo(x, y);
		var distRemaining = Math.sqrt(dx * dx + dy * dy);
		var dashIndex = 0;
		while (distRemaining >= 0.1) {
			var dashLength = Math.min(distRemaining, dashArray[dashIndex
					% dashCount]);
			var step = Math.sqrt(dashLength * dashLength / (1 + slope * slope));
			if (xSlope) {
				if (dx < 0)
					step = -step;
				x += step;
				y += slope * step;
			} else {
				if (dy < 0)
					step = -step;
				x += slope * step;
				y += step;
			}
			this[(dashIndex % 2 == 0) ? 'lineTo' : 'moveTo'](x, y);
			distRemaining -= dashLength;
			dashIndex++;
		}
		
		this.closePath();
		this.stroke();
	};

	CP.dashedRectangle = function(x1, y1, x2, y2, dashArray) {
		
		this.dashedLine(x1, y1, x2, y1, dashArray);
		this.dashedLine(x2, y1, x2, y2, dashArray);

		this.dashedLine(x1, y1, x1, y2, dashArray);
		this.dashedLine(x1, y2, x2, y2, dashArray);

	};
	
	CP.dashedRectangleWithFillColor = function(x1, y1, x2, y2, dashArray, fillStyle) {
		
		this.x1 = parseInt(x1);
		this.y1 = parseInt(y1);
		this.x2 = parseInt(x2);
		this.y2 = parseInt(y2);
				
		this.dashedLine(this.x1, this.y1, this.x2, this.y1, dashArray);
		this.dashedLine(this.x2, this.y1, this.x2, this.y2, dashArray);

		this.dashedLine(this.x1, this.y1, this.x1, this.y2, dashArray);
		this.dashedLine(this.x1, this.y2, this.x2, this.y2, dashArray);
		
		this.clearRect(this.x1, this.y1, this.x2 - this.x1, this.y2 - this.y1);
		
		this.fillStyle = fillStyle;
		this.fillRect(this.x1, this.y1, this.x2 - this.x1, this.y2 - this.y1);

	};
	
}