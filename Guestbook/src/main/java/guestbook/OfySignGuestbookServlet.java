package guestbook;

 

import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.User;

import com.google.appengine.api.users.UserService;

import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;

import javax.servlet.http.HttpServlet;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

 

public class OfySignGuestbookServlet extends HttpServlet {
	

	static {

        ObjectifyService.register(Greeting.class);

    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

    	UserService userService = UserServiceFactory.getUserService();

    	User user = userService.getCurrentUser();

    	String content = req.getParameter("content");
    	
    	String title = req.getParameter("title");

    	Greeting greeting = new Greeting(user, content, title);

    	ofy().save().entity(greeting).now();

    	resp.sendRedirect("/ofyguestbook.jsp");	

    }

}