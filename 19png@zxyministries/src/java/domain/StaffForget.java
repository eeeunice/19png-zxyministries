package domain;

public class StaffForget {
    private String staffid;
    private String staffemail;
    private String staffusername;
    private String staffphone;

    public StaffForget(String staffid, String staffemail, String staffusername, String staffphone) {
        this.staffid = staffid;
        this.staffemail = staffemail;
        this.staffusername = staffusername;
        this.staffphone = staffphone;
    }

    // Getters
    public String getStaffId() { return staffid; }
    public String getStaffEmail() { return staffemail; }
    public String getStaffUsername() { return staffusername; }
    public String getStaffPhone() { return staffphone; }

    // Setters
    public void setStaffId(String staffid) { this.staffid = staffid; }
    public void setStaffEmail(String staffemail) { this.staffemail = staffemail; }
    public void setStaffUsername(String staffusername) { this.staffusername = staffusername; }
    public void setStaffPhone(String staffphone) { this.staffphone = staffphone; }
}
