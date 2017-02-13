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
   		<title>write a post</title>
   		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	</head>

  	<body>
 
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
	%>

	<%
		} else {
	%>
		<p><a href="<%=userService.createLoginURL(request.getRequestURI())%>">sign in</a> to be able to post here.</p>
	<%
    }
%>
	<%
		ObjectifyService.register(Greeting.class);
		List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
		Collections.sort(greetings);
		if (user != null) {
	%>
	<h1>publish a post</h1>
	<h3>title</h3>
	<form action="/ofysign" method="post">
		<textarea name="title" rows="1" cols="110"
			placeholder="Enter your title here!"></textarea>
		<h3 class="publish-header">content</h3>
		<textarea name="content" rows="5" cols="110"
			placeholder="Write your post here!"></textarea>
		<button type="submit">publish</button>
		<input type="hidden"
			value="/" />
	</form>
	<form action="/" method="post">
		<button>cancel entry</button>
	</form>

	<% } %>
	<footer>
		<p>by leo xia and jessica slaughter</p>
	</footer>
</body>
</html>