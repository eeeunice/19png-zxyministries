package domain;

public class StaffReset {
    private String staffid;
    private String staffemail;
    private String newpassword;

    public StaffReset(String staffid, String staffemail, String newpassword) {
        this.staffid = staffid;
        this.staffemail = staffemail;
        this.newpassword = newpassword;
    }

    public String getStaffid() {
        return staffid;
    }

    public String getStaffemail() {
        return staffemail;
    }

    public String getNewpassword() {
        return newpassword;
    }

    public void setStaffid(String staffid) {
        this.staffid = staffid;
    }

    public void setStaffemail(String staffemail) {
        this.staffemail = staffemail;
    }

    public void setNewpassword(String newpassword) {
        this.newpassword = newpassword;
    }
}
