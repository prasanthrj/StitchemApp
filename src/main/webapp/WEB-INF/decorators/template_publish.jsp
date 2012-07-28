
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="dec"%>

<!DOCTYPE HTML>
<html>
	
	<script type="text/javascript">window.status = "Loading: Document body...";</script>
	
	<head>
	
		<link rel="icon" type="image/png" href="<%= request.getContextPath() %>/themes/images/favicon.ico">
				
		<!-- Meta tags -->
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<meta name="viewport" content="initial-scale=1, maximum-scale=1">
		<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0,maximum-scale=1.0">
		<meta name="viewport" content="target-densitydpi=device-dpi">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="translucent-black" />
	
		
		<link rel="stylesheet" media="all" href="http://code.jquery.com/mobile/1.0rc2/jquery.mobile-1.0rc2.css"/>
		
		<link rel="stylesheet" media="all" href="<%= request.getContextPath() %>/themes/publish.css"/>
		
		<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/lib/jquery-1.5.js"></script>
		<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/lib/jquery.mobile-1.0rc1.js"></script>
		
		<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/publish.js"></script>
		
		
		<!-- Title -->
		<title> <dec:title default="Publish" /> </title>
		
		<dec:head />
		
	</head>
	
	<body lang="en">

		<!-- Body Content -->
	
		<dec:body />

		<!-- Body ends -->	
		
	</body>
	
	<script type="text/javascript">window.status = "Done";</script>
	
</html>

