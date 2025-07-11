package domain;

public class Discount {
    private String discountId;
    private double discountAmount;
    private double minimumPurchaseValue;
    private double minimumOrderValue;
    private String discountCode;
    private String statusDiscounts;
    private String promotionId;

    // Constructors
    public Discount() {
    }

    public Discount(String discountId, double discountAmount, double minimumPurchaseValue,
            double minimumOrderValue, String discountCode, String statusDiscounts,
            String promotionId) {
        this.discountId = discountId;
        this.discountAmount = discountAmount;
        this.minimumPurchaseValue = minimumPurchaseValue;
        this.minimumOrderValue = minimumOrderValue;
        this.discountCode = discountCode;
        this.statusDiscounts = statusDiscounts;
        this.promotionId = promotionId;
    }

    // Getters and Setters
    public String getDiscountId() {
        return discountId;
    }

    public void setDiscountId(String discountId) {
        this.discountId = discountId;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getMinimumPurchaseValue() {
        return minimumPurchaseValue;
    }

    public void setMinimumPurchaseValue(double minimumPurchaseValue) {
        this.minimumPurchaseValue = minimumPurchaseValue;
    }

    public double getMinimumOrderValue() {
        return minimumOrderValue;
    }

    public void setMinimumOrderValue(double minimumOrderValue) {
        this.minimumOrderValue = minimumOrderValue;
    }

    public String getDiscountCode() {
        return discountCode;
    }

    public void setDiscountCode(String discountCode) {
        this.discountCode = discountCode;
    }

    public String getStatusDiscounts() {
        return statusDiscounts;
    }

    public void setStatusDiscounts(String statusDiscounts) {
        this.statusDiscounts = statusDiscounts;
    }

    public String getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(String promotionId) {
        this.promotionId = promotionId;
    }
}