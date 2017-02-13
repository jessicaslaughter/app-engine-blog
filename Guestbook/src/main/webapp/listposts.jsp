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
	<h1>archive</h1>
	<nav>
	<ul>
	<li><a href="/">back to home</a></li>
	<li><a href="/post.jsp">write a post</a></li>
	</ul>
	</nav>
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
    		<p>there are no posts yet</p>
    	<%
    	}else{
    	%>
    	<%
    		for (int i=0; i < greetings.size(); i++) {
    			Greeting greeting = greetings.get(greetings.size() - 1 - i);
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
                    <div class="archive-post">
                    <p class="archive-meta"><b>${fn:escapeXml(greeting_title)}</b> by ${fn:escapeXml(greeting_user.nickname)} on ${fn:escapeXml(greeting_date)}:</p>
           			<p>${fn:escapeXml(greeting_content)}</p>
           			</div>
                    <%
                }
        		
        		
    		}
    	}
    	%>
    	<footer>
			<p>by leo xia and jessica slaughter</p>
		</footer>

	</body>

</html>