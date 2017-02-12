<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
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
    <div> <!-- Brand and toggle get grouped for better mobile display -->
      <p>Hello, ${fn:escapeXml(user.nickname)}! (You can
		<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
		 <form action="/subscribe" method="get">
          <div><button><h4>Unsubscribe</h4></button></div>
    </form>
    </div>  
  </div>
</nav>
<%
    } else {
%>
<nav>
  <div>
    <!-- Brand and toggle get grouped for better mobile display -->
	<p>
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
	to be able to post here.</p>
  </div><!-- /.container-fluid -->
</nav>
<%
    }
%>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
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
 
	<br>
	<br>
	<p>Thanks for subscribing! Daily newsletters will be sent to your email at 5pm CDT.</p>    
	<br>
	<br>


 <% } %>


 	<form action="/guestbook.jsp" method="post">
          <div><button class="btn btn-warning" style="border-radius: 20px;"><h4 style="padding: 0;">Back to Home</h4></button></div>
    
    </form>

  </body>
</html>