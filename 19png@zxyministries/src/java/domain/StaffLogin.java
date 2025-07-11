package domain;

public class StaffLogin {
    private String staffId;
    private String managerId;
    private String staffName;
    private String staffEmail;
    private String staffPhone;
    private String staffPassword;
    private String role;

    // Constructor
    public StaffLogin(String staffId, String managerId, String staffName, String staffEmail,
                      String staffPhone, String staffPassword, String role) {
        this.staffId = staffId;
        this.managerId = managerId;
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

    public String getManagerId() {
        return managerId;
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

    public String getStaffPassword() {
        return staffPassword;
    }

    public String getRole() {
        return role;
    }

    // Setters
    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public void setManagerId(String managerId) {
        this.managerId = managerId;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public void setStaffEmail(String staffEmail) {
        this.staffEmail = staffEmail;
    }

    public void setStaffPhone(String staffPhone) {
        this.staffPhone = staffPhone;
    }

    public void setStaffPassword(String staffPassword) {
        this.staffPassword = staffPassword;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
