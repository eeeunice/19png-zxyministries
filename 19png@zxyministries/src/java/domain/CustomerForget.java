package domain;

public class CustomerForget {
    private String customerId;
    private String email;
    private String username;
    private String phoneNum;

    public CustomerForget(String customerId, String email, String username, String phoneNum) {
        this.customerId = customerId;
        this.email = email;
        this.username = username;
        this.phoneNum = phoneNum;
    }

    // Getters
    public String getCustomerId() { return customerId; }
    public String getEmail() { return email; }
    public String getUsername() { return username; }
    public String getPhoneNum() { return phoneNum; }

    // Setters
    public void setCustomerId(String customerId) { this.customerId = customerId; }
    public void setEmail(String email) { this.email = email; }
    public void setUsername(String username) { this.username = username; }
    public void setPhoneNum(String phoneNum) { this.phoneNum = phoneNum; }
}
