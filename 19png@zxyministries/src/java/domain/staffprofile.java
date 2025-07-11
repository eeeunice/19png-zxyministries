package domain;

public class staffprofile {
    private String staffId;
    private String staffName;
    private String staffEmail;
    private String staffPhone;
    private String staffPassword;
    private String role;

    // Constructor
    public staffprofile(String staffId, String staffName, String staffEmail, String staffPhone, String staffPassword, String role) {
        this.staffId = staffId;
        this.staffName = staffName;
        this.staffEmail = staffEmail;
        this.staffPhone = staffPhone;
        this.staffPassword = staffPassword;
        this.role = role;
    }

    // Getters
    public String getStaffId() {
        return staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public String getStaffEmail() {
        return staffEmail;
    }

    public String getStaffPhone() {
        return staffPhone;
    }

    public String getRole() {
        return role;
    }

    public String getStaffPassword() {
        return staffPassword;
    }
}
