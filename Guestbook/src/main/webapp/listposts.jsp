<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<title>blog posts</title>
		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	</head>

	<body>
		<form action="/guestbook.jsp" method="post">
    		<div><button type="submit"><h4>Back to home</h4></button></div>
    		<input type="hidden" value="${fn:escapeXml(guestbookName)}"/>
   		</form>
    
    	<form action="/post.jsp" method="post">
    		<div><button type="submit"><h4>Make a post</h4></button></div>
      		<input type="hidden" value="${fn:escapeXml(guestbookName)}"/>
  		</form>
    
		<%
   		 String guestbookName = request.getParameter("guestbookName");
    		if (guestbookName == null) {
      	 		guestbookName = "Web Blog";
   		 }
   		 pageContext.setAttribute("guestbookName", guestbookName);
   		 UserService userService = UserServiceFactory.getUserService();
   		 User user = userService.getCurrentUser();
   		 if (user != null) {
      		pageContext.setAttribute("user", user);
   		 }
   		 
%>
		<%
		ObjectifyService.register(Greeting.class);

	 	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();

	 	Collections.sort(greetings);
    	if(greetings.isEmpty()){
    	%>
    		<div><h2>There are no posts on the blog</h2></div>
    	<%
    	}else{
    	%>
    		<div><h2>Listing of all posts</h2></div>
    	<%
    		for (Greeting greeting : greetings) {
    			pageContext.setAttribute("greeting_content", greeting.getContent());
	            pageContext.setAttribute("greeting_date", greeting.getDate());
	            pageContext.setAttribute("greeting_title", greeting.getTitle());
        		
        		if (greeting.getUser() == null) {
                    %>
                    <p>anonymous:</p>
                    <%
                } else {
                    pageContext.setAttribute("greeting_user",
                                             greeting.getUser());
                    %>
                    <p>${fn:escapeXml(greeting_user.nickname)} wrote on ${fn:escapeXml(greeting_date)}:</p>
                    
                    <h3><b> ${fn:escapeXml(greeting_title)}</b></h3>
           			<blockquote> ${fn:escapeXml(greeting_content)}</blockquote>
            		<hr>
                    <%
                }
        		
        		
    		}
    	}
    	%>

	</body>

</html>