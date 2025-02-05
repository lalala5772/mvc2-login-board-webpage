package dto;

import java.sql.Timestamp;

public class MembersDTO {
	private String id;
	private String passwd;
	private String name;
	private String email;
	private String phone;
	private String postcode;
	private String address1;
	private String address2;
	private Timestamp signup_date;
	
	public MembersDTO(String id, String passwd, String name, String email, String phone, String postcode,
			String address1, String address2) {
		super();
		this.id = id;
		this.passwd = passwd;
		this.name = name;
		this.email = email;
		this.phone = phone;
		this.postcode = postcode;
		this.address1 = address1;
		this.address2 = address2;
	}

	
	public MembersDTO(String id, String passwd, String name, String email, String phone, String postcode,
			String address1, String address2, Timestamp signup_date) {
		super();
		this.id = id;
		this.passwd = passwd;
		this.name = name;
		this.email = email;
		this.phone = phone;
		this.postcode = postcode;
		this.address1 = address1;
		this.address2 = address2;
		this.signup_date = signup_date;
	}

	public String getId() {
		return id;
	}

	public String getPasswd() {
		return passwd;
	}

	public String getName() {
		return name;
	}

	public String getEmail() {
		return email;
	}

	public String getPhone() {
		return phone;
	}

	public String getPostcode() {
		return postcode;
	}

	public String getAddress1() {
		return address1;
	}

	public String getAddress2() {
		return address2;
	}

	public Timestamp getSignup_date() {
		return signup_date;
	}


}
