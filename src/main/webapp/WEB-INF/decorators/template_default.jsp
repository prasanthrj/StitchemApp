
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="dec"%>

<!DOCTYPE HTML>
<html>
	
	<script type="text/javascript">window.status = "Loading: Document body...";</script>
	
	<head>
		
		<link rel="icon" type="image/png" href="<%= request.getContextPath() %>/themes/images/favicon.ico">
		
		<!-- Meta tags -->
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<!-- Title -->
		<title> <dec:title default="stitchemapp" /> </title>
		
		<%@ include file="includes/includes.jsp"%>
		
		<dec:head />
		
	</head>
	
	<body>
	
		<section id="body-cont">
		
			<%@ include file="includes/header.jsp"%>
			
			<dec:body />
			
			<!-- Body ends -->	
			
			<%@ include file="includes/footer.jsp"%>
			
		</section>
		
	</body>
	
	<script type="text/javascript">window.status = "Done";</script>
	
</html>