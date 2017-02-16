<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.*" %>

<%@ page import="com.googlecode.objectify.*" %>

<%@ page import="guestbook.Greeting" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
<html>
 <head>
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
<nav>
  <div>
    <div> 
     
      <p>Hello, ${fn:escapeXml(user.nickname)}! (You can
		<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
		 <form action="/subscribe" method="post">
          <div><button><h4>Subscribe</h4></button></div>
    </form>
   </div>   
  </div>
</nav>
<%
    } else {
%>
<nav>
  <div>
    
	<p>
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
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
        if(user == null){
        	%>
        	<br>
        	<br>
        	<p>Sign in to view posts</p>
        	<br>
        	<br>
        	<%
        }
    }
%>

<%
 if (user != null) {
	 %>
 
	<br>
	<br>
	<p>You have unsubscribed.</p>    
	<br>
	<br>


 <% } %>


 	<form action="/guestbook.jsp" method="post">
          <div><button><h4>Return to Homepage</h4></button></div>
    
    </form>


  </body>
</html>