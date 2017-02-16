package guestbook;


import java.io.IOException;
import java.util.logging.Logger;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.util.*;
import java.io.*;
import java.nio.file.*;
import javax.mail.*;
import javax.mail.internet.*;


import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")


public class CronServlet extends HttpServlet {

	private static final Logger logger = Logger.getLogger(CronServlet.class.getName());

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		String strCallResult = "";
		resp.setContentType("text/plain");
		try {
			String strTo = req.getParameter("email_to");
			String strSubject = req.getParameter("email_subject");
			String strBody = req.getParameter("email_body");

			Properties props = new Properties();
			Session session = Session.getDefaultInstance(props, null);
			
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress("blog@vivid-access-156516.appspot.com"));
			
			List<EmailAddress> addresses = ofy().load().type(EmailAddress.class).list();
			for (EmailAddress send: addresses){
				msg.addRecipient(Message.RecipientType.TO,
						new InternetAddress(send.getEmail()));
			}
			msg.setSubject("My New Blog's Daily Newsletter");
			
			UserService userService = UserServiceFactory.getUserService();
	        User user = userService.getCurrentUser();
			
			String guestbookName = req.getParameter("guestbookName");
		    if (guestbookName == null) {
		        guestbookName = "Web Blog";
		    }
		    ObjectifyService.register(Greeting.class);

		 	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();

		 	Collections.sort(greetings);
			String message = "Good day, here are the most recent posts from My New Blog:" 
		    + "\r\n" + "\r\n" + "=================================" + "\r\n";
		    for (Greeting greeting: greetings){
		    		message += "Title: " + greeting.getTitle() + "\r\n"
						+ "\r\n" + greeting.getContent() + "\r\n"
						+ "=================================" + "\r\n";
		    	}
		    
			msg.setText(message);
			Transport.send(msg);
			strCallResult = "Success: " + "Email has been delivered.";
			resp.getWriter().println(strCallResult);
		}
		catch (Exception ex) {
			strCallResult = "Fail: " + ex.getMessage();
			resp.getWriter().println(strCallResult);
		}

	}


	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}
}