package domain;

import java.sql.Timestamp;

public class Contact {
    private String contactusId;
    private String name;
    private String phoneNumber;
    private String email;
    private String description;
    private String status;
    private String staffId;
    private String managerId;
    private Timestamp currentUpdate;

    // Full-field constructor (for admin/DAO usage)
    public Contact(String contactusId, String name, String phoneNumber, String email, String description,
                   String status, String staffId, String managerId, Timestamp currentUpdate) {
        this.contactusId = contactusId;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.description = description;
        this.status = status;
        this.staffId = staffId;
        this.managerId = managerId;
        this.currentUpdate = currentUpdate;
    }

    // Simplified constructor (for customer submission)
    public Contact(String name, String email, String phoneNumber, String description) {
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.description = description;
        this.status = "Pending"; // default status
        this.staffId = null;
        this.managerId = null;
        this.currentUpdate = new Timestamp(System.currentTimeMillis());
    }

    // Getters and setters
    public String getContactusId() {
        return contactusId;
    }

    public void setContactusId(String contactusId) {
        this.contactusId = contactusId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public String getManagerId() {
        return managerId;
    }

    public void setManagerId(String managerId) {
        this.managerId = managerId;
    }

    public Timestamp getCurrentUpdate() {
        return currentUpdate;
    }

    public void setCurrentUpdate(Timestamp currentUpdate) {
        this.currentUpdate = currentUpdate;
    }

    @Override
    public String toString() {
        return "Contact [contactusId=" + contactusId + ", name=" + name + ", phoneNumber=" + phoneNumber
                + ", email=" + email + ", description=" + description + ", status=" + status + ", staffId=" + staffId
                + ", managerId=" + managerId + ", currentUpdate=" + currentUpdate + "]";
    }
}
