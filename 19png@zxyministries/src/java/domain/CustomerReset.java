package domain;

public class CustomerReset {
    private String customerId;
    private String email;
    private String newPassword;

    public CustomerReset(String customerId, String email, String newPassword) {
        this.customerId = customerId;
        this.email = email;
        this.newPassword = newPassword;
    }

    public String getCustomerId() { return customerId; }
    public String getEmail() { return email; }
    public String getNewPassword() { return newPassword; }

    public void setCustomerId(String customerId) { this.customerId = customerId; }
    public void setEmail(String email) { this.email = email; }
    public void setNewPassword(String newPassword) { this.newPassword = newPassword; }
}