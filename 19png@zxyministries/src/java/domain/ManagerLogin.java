package domain;

public class ManagerLogin {
    private String managerid;
    private String managername;
    private String manageremail;
    private String managerphone;
    private String managerusername;
    private String managerpassword;

    // Full constructor
    public ManagerLogin(String managerid, String managername, String manageremail, String managerphone,
                        String managerusername, String managerpassword) {
        this.managerid = managerid;
        this.managername = managername;
        this.manageremail = manageremail;
        this.managerphone = managerphone;
        this.managerusername = managerusername;
        this.managerpassword = managerpassword;
       
    }

    // Minimal constructor for login
    public ManagerLogin(String manageremail, String managerpassword) {
        this.manageremail = manageremail;
        this.managerpassword = managerpassword;
    }

    // Getters
    public String getManagerId() {
        return managerid;
    }

    public String getManagerName() {
        return managername;
    }

    public String getManagerEmail() {
        return manageremail;
    }

    public String getManagerPhone() {
        return managerphone;
    }

    public String getManagerUsername() {
        return managerusername;
    }

    public String getManagerPassword() {
        return managerpassword;
    }

   

    // Setters
    public void setManagerId(String managerid) {
        this.managerid = managerid;
    }

    public void setManagerName(String managername) {
        this.managername = managername;
    }

    public void setManagerEmail(String manageremail) {
        this.manageremail = manageremail;
    }

    public void setManagerPhone(String managerphone) {
        this.managerphone = managerphone;
    }

    public void setManagerUsername(String managerusername) {
        this.managerusername = managerusername;
    }

    public void setManagerPassword(String managerpassword) {
        this.managerpassword = managerpassword;
    }

   
}
