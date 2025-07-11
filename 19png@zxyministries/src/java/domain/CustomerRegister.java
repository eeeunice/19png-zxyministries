package domain;

public class CustomerRegister {
    private String customerId;
    private String custName;
    private String email;
    private String username;
    private String password;
    private String phoneNum;
    private String dateOfBirth;
    private String addressid;
    private String gender;
    private String registrationDate; // Add this field

    public CustomerRegister(String customerId, String custName, String email, String username, String password,
            String phoneNum, String dateOfBirth, String addressid, String gender) {
        this.customerId = customerId;
        this.custName = custName;
        this.email = email;
        this.username = username;
        this.password = password;
        this.phoneNum = phoneNum;
        this.dateOfBirth = dateOfBirth;
        this.addressid = addressid;
        this.gender = gender;
        // You might want to set a default registration date here
        // this.registrationDate = new
        // java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    }

    // Add constructor with registration date
    public CustomerRegister(String customerId, String custName, String email, String username, String password,
            String phoneNum, String dateOfBirth, String addressid, String gender, String registrationDate) {
        this.customerId = customerId;
        this.custName = custName;
        this.email = email;
        this.username = username;
        this.password = password;
        this.phoneNum = phoneNum;
        this.dateOfBirth = dateOfBirth;
        this.addressid = addressid;
        this.gender = gender;
        this.registrationDate = registrationDate;
    }

    // Getters
    public String getCustomerId() {
        return customerId;
    }

    public String getCustName() {
        return custName;
    }

    public String getEmail() {
        return email;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public String getAddressid() {
        return addressid;
    }

    public String getGender() {
        return gender;
    }

    // Setters
    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setPhoneNum(String phoneNum) {
        this.phoneNum = phoneNum;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public void setAddressid(String addressid) {
        this.addressid = addressid;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    // Add these methods
    public String getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(String registrationDate) {
        this.registrationDate = registrationDate;
    }
}
