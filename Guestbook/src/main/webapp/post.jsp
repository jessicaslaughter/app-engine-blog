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
	<nav>
  		<div>
			<p><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
			to be able to post here.</p>
 		 </div>
	</nav>
<%
    }
%>

<%
	ObjectifyService.register(Greeting.class);
	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
	Collections.sort(greetings);
    if (greetings.isEmpty()) {
        %>
        <div>
        	<h2><b>Make this empty blog happy, publish a post!</b></h2>
        </div>
        <%
    } else {
        %>
        <div>
        	<h2><b>My Blog</b></h2>
        </div>
        <%
    }
%>

<%
 if (user != null) {
	 %>
 
    <form action="/ofysign" method="post">
    	<div><h3>Write a post below:</h3></div>
      	<div>
      	    <label><h4>Title of Post</h4></label>
      		<div style="text-align: left;">
      			<textarea name="title" rows="1" cols="110" placeholder= "Enter your title here!"></textarea>
      		</div>
      	</div>
     	<div>
        <label><h4>Content of Post</h4></label>
      		<div>
      		<textarea name="content" rows="5" cols="110" placeholder= "Write your post here!"></textarea>
      		</div>
      	</div>
      <br>
      
      <div><button type="submit"><h4>Post Entry</h4></button></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>
    <form action="/" method="post">
          <div><button ><h4>Cancel Entry</h4></button></div>
    
    </form>

 <% } %>
  </body>
</html>