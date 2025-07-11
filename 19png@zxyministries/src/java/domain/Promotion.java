package domain;

import java.sql.Timestamp;

public class Promotion {
    private String promotionId;
    private String promotionName;
    private String promotionType;
    private String promotionCode;
    private Timestamp startDate;
    private Timestamp endDate;
    private String description;
    private String managerId;

    // Constructors
    public Promotion() {
    }

    public Promotion(String promotionId, String promotionName, String promotionType,
            String promotionCode, Timestamp startDate, Timestamp endDate,
            String description, String managerId) {
        this.promotionId = promotionId;
        this.promotionName = promotionName;
        this.promotionType = promotionType;
        this.promotionCode = promotionCode;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
        this.managerId = managerId;
    }

    // Getters and Setters
    public String getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(String promotionId) {
        this.promotionId = promotionId;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public String getPromotionType() {
        return promotionType;
    }

    public void setPromotionType(String promotionType) {
        this.promotionType = promotionType;
    }

    public String getPromotionCode() {
        return promotionCode;
    }

    public void setPromotionCode(String promotionCode) {
        this.promotionCode = promotionCode;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getManagerId() {
        return managerId;
    }

    public void setManagerId(String managerId) {
        this.managerId = managerId;
    }
}