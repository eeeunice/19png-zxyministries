package domain;

import java.sql.Timestamp;

public class CustomerActivity {
    private String customerName;
    private double amount;
    private Timestamp date;  
    private String status;
    
    // Default constructor
    public CustomerActivity() {
    }

    // Update the constructor to use Timestamp instead of String for date
    public CustomerActivity(String customerName, double amount, java.sql.Timestamp date, String status) {
        this.customerName = customerName;
        this.amount = amount;
        this.date = date;
        this.status = status;
    }
    
    // Getters and setters
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public double getAmount() {
        return amount;
    }
    
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    public java.sql.Timestamp getDate() {
        return date;
    }
    
    public void setDate(java.sql.Timestamp date) {
        this.date = date;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
}