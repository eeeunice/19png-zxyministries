package domain;

import java.sql.Date;
import java.sql.Timestamp;

public class staff_displaycust {
    private String customerid;
    private String custname;
    private String email;
    private String phonenum;
    private Date dateofbirth;
    private String gender;
    private Timestamp registrationdate;

    public staff_displaycust(String customerid, String custname, String email, String phonenum, Date dateofbirth, String gender, Timestamp registrationdate) {
        this.customerid = customerid;
        this.custname = custname;
        this.email = email;
        this.phonenum = phonenum;
        this.dateofbirth = dateofbirth;
        this.gender = gender;
        this.registrationdate = registrationdate;
    }

    // Getter methods
    public String getCustomerId() {
        return customerid;
    }

    public String getCustName() {
        return custname;
    }

    public String getEmail() {
        return email;
    }

    public String getPhonenum() {
        return phonenum;
    }

    public Date getdateofbirth() {
        return dateofbirth;
    }

    public String getGender() {
        return gender;
    }

    public Timestamp getregistrationdate() {
        return registrationdate;
    }
}
