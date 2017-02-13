<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.*" %>

<%@ page import="com.googlecode.objectify.*" %>

<%@ page import="guestbook.Greeting" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>
  <head>
  	<title>our blog</title>
  	<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>
  <body>
  <h1>Our Blog</h1>
  <div class="header-image"><img src="http://jessicaslaughter.co/wp-content/uploads/2017/02/header-image.jpg"/></div>

<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>
	<nav><ul>
	  	<li><a href="/post.jsp">write a post</a></li>
	  	<li><a href="/listposts.jsp">view all posts</a></li>
	  	<li><a href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign out</a></li>
	  	<li>subscribe</li>
	  	<li>unsubscribe</li>
	</ul></nav>

	<%
		} else {
	%>
	<nav><ul>
	  	<li><a href="/post.jsp">write a post</a></li>
	  	<li><a href="/listposts.jsp">view all posts</a></li>
	  	<li>subscribe</li>
	  	<li>unsubscribe</li>
	</ul></nav>
	<%
		}
	%>


	<%

 	ObjectifyService.register(Greeting.class);

 	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();

 	Collections.sort(greetings);
 	if (greetings.isEmpty()) {
 %>

        <p>There aren't any posts here yet.</p>

        <%

    } else {

        %>

        <%
		if (greetings.size() < 5) { // less than five posts
	        for (Greeting greeting : greetings) {
	
	            pageContext.setAttribute("greeting_content", greeting.getContent());
	            pageContext.setAttribute("greeting_date", greeting.getDate());
	            pageContext.setAttribute("greeting_title", greeting.getTitle());
	            pageContext.setAttribute("greeting_user", greeting.getUser());
	            
	
	            if (greeting.getUser() == null) {
	
	                %>
					<div class="post-header">
					<h2>${fn:escapeXml(greeting_title)}</h2>
	                <p class="meta"><span>anonymous author | </span><span>date: ${fn:escapeXml(greeting_date)}</span></p>
					</div>
	                <%
	
	            } else {
	
	            	pageContext.setAttribute("greeting_content", greeting.getContent());
		            pageContext.setAttribute("greeting_date", greeting.getDate());
		            pageContext.setAttribute("greeting_title", greeting.getTitle());
		            pageContext.setAttribute("greeting_user", greeting.getUser());
	
	                %>
					<div class="post-header">
					<h2>${fn:escapeXml(greeting_title)}</h2>
	                <p class="meta"><span class="post">author: ${fn:escapeXml(greeting_user.nickname)} | </span><span>date: ${fn:escapeXml(greeting_date)}</span></p>
					</div>
	                <%
	
	            }
	
	            %>
	
	            <div class="post"><p>${fn:escapeXml(greeting_content)}</p></div>
	
	            <%
	
	        }

    	}
		else {
			for (int i = 0; i < 5; i++) { // first five posts
				Greeting greeting = greetings.get(greetings.size() - 1 - i);
				
				pageContext.setAttribute("greeting_content", greeting.getContent());
	            pageContext.setAttribute("greeting_date", greeting.getDate());
	            pageContext.setAttribute("greeting_title", greeting.getTitle());
	            pageContext.setAttribute("greeting_user", greeting.getUser());
	
	            if (greeting.getUser() == null) {
	
	                %>
					<div class="post-header">
					<h2>${fn:escapeXml(greeting_title)}</h2>
	                <p class="meta"><span>anonymous author | </span><span>date: ${fn:escapeXml(greeting_date)}</span></p>
					</div>
	                <%
	
	            } else {
	
	            	pageContext.setAttribute("greeting_content", greeting.getContent());
		            pageContext.setAttribute("greeting_date", greeting.getDate());
		            pageContext.setAttribute("greeting_title", greeting.getTitle());
		            pageContext.setAttribute("greeting_user", greeting.getUser());
	
	                %>
					<div class="post-header">
					<h2>${fn:escapeXml(greeting_title)}</h2>
	                <p class="meta"><span>author: ${fn:escapeXml(greeting_user.nickname)} | </span><span>date: ${fn:escapeXml(greeting_date)}</span></p>
					</div>
	                <%
	
	            }
	
	            %>
	
	            <div class="post"><p>${fn:escapeXml(greeting_content)}</p></div>
	
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

