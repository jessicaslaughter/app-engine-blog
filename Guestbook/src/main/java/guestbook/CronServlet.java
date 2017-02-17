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

import guestbook.Sendgrid;
import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.labs.repackaged.org.json.JSONException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")


public class CronServlet extends HttpServlet {
	static{
		ObjectifyService.register(EmailAddress.class);
	}
	private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
			ObjectifyService.register(Greeting.class);
		 	List<Greeting> posts = ObjectifyService.ofy().load().type(Greeting.class).list();
		 	Collections.sort(posts);
		 	
			String message = "Hi!" 
		    + "\r\n" + "\r\n" + "=================================" + "\r\n";
		    for (Greeting thisPost: posts){
		    		message += "Title: " + thisPost.getTitle() + "\r\n"
						+ "\r\n" + thisPost.getContent() + "\r\n"
						+ "=================================" + "\r\n";
		    }
		    
			List<EmailAddress> addresses = ofy().load().type(EmailAddress.class).list();
			for (EmailAddress send: addresses){
				Sendgrid mail = new Sendgrid("jessicaslaughter","jessicas1!");
				mail.setTo("jessica.t.slaughter@gmail.com")
			    .setFrom("hello@jessicaslaughter.co")
			    .setSubject("Our Blog")
			    .setText(message)
			    .setHtml("<strong>Thanks!</strong>");
				try {
					mail.send();
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}


	}


	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}
}