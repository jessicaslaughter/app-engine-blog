package guestbook;

public class EmailAddress {
		private String id;
		private String email;


    	public EmailAddress (String e, String i) {
		this.setId(i);
		this.email = e;
    	}
    
    	public EmailAddress(){}
    
    	//Id value for simple entity retrieval
	
    	public String getEmail() {
			return email;
		}

		public void setEmail(String email) {
			this.email = email;
		}

		public String getId() {
			return id;
		}

		public void setId(String id) {
			this.id = id;
		}

}
