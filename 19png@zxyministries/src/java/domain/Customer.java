package domain;

import java.sql.Timestamp; // Import the correct Timestamp class
import java.util.Date;

public class Customer {
    private String customerid;
    private String custname;
    private String email;
    private String phonenum;
    private Date dateofbirth;
    private String addressid;
    private String gender;
    private String username;
    private String password;
    private Timestamp registrationdate; // Corrected type

    // Full constructor
    public Customer(String customerid, String custname, String email, String phonenum,
            Date dateofbirth, String addressid, String gender, String username,
            String password, Timestamp registrationdate) {
        this.customerid = customerid;
        this.custname = custname;
        this.email = email;
        this.phonenum = phonenum;
        this.dateofbirth = dateofbirth;
        this.addressid = addressid;
        this.gender = gender;
        this.username = username;
        this.password = password;
        this.registrationdate = registrationdate;
    }

    // Minimal constructor for login
    public Customer(String email, String password) {
        this.email = email;
        this.password = password;
    }

    // Getters
    public String getCustomerId() {
        return customerid;
    }

    public String getCustName() {
        return custname;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNum() {
        return phonenum;
    }

    public Date getDateOfBirth() {
        return dateofbirth;
    }

    public String getAddressid() {
        return addressid;
    }

    public String getGender() {
        return gender;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public Timestamp getRegistrationDate() {
        return registrationdate;
    }

    // Setters (if needed)
    public void setRegistrationDate(Timestamp registrationdate) {
        this.registrationdate = registrationdate;
    }
}
