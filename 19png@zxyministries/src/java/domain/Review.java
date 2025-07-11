package domain;

import java.util.Date;

public class Review {
    private String reviewId;
    private String customerId;
    private double rating;
    private String comments;
    private Date reviewDate;
    private Date createdAt;
    private String reply;
    private Date replyAt;
    private String replyBy;
    private String orderId;

    public Review() {
    }

    public Review(String reviewId, String customerId, double rating, String comments, Date reviewDate,
                  Date createdAt, String reply, Date replyAt, String replyBy, String orderId) {
        this.reviewId = reviewId;
        this.customerId = customerId;
        this.rating = rating;
        this.comments = comments;
        this.reviewDate = reviewDate;
        this.createdAt = createdAt;
        this.reply = reply;
        this.replyAt = replyAt;
        this.replyBy = replyBy;
        this.orderId = orderId;
    }

    // Getters and Setters
    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public Date getReplyAt() {
        return replyAt;
    }

    public void setReplyAt(Date replyAt) {
        this.replyAt = replyAt;
    }

    public String getReplyBy() {
        return replyBy;
    }

    public void setReplyBy(String replyBy) {
        this.replyBy = replyBy;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
}