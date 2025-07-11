package domain;

import java.util.Date;

public class Feedback {
    private String feedbackId;
    private String customerId;
    private int rating;
    private String comment;
    private Date feedbackDate;
    
    public Feedback() {
    }
    
    public Feedback(String feedbackId, String customerId, int rating, String comment, Date feedbackDate) {
        this.feedbackId = feedbackId;
        this.customerId = customerId;
        this.rating = rating;
        this.comment = comment;
        this.feedbackDate = feedbackDate;
    }
    
    // Getters
    public String getFeedbackId() {
        return feedbackId;
    }
    
    public String getCustomerId() {
        return customerId;
    }
    
    public int getRating() {
        return rating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public Date getFeedbackDate() {
        return feedbackDate;
    }
    
    // Setters
    public void setFeedbackId(String feedbackId) {
        this.feedbackId = feedbackId;
    }
    
    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public void setFeedbackDate(Date feedbackDate) {
        this.feedbackDate = feedbackDate;
    }
}