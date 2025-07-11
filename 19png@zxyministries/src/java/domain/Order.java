package domain;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private String orderId;
    private String customerId;
    private String customerName;
    private Timestamp orderDate;
    private int itemCount;
    private double totalAmount;
    private String status;
    private double discountAmountOrder;
    private double payAmount;
    private String orderStatusId;
    private String addressId;
    private String discountId;
    private List<OrderDetail> orderDetails;
    
    // Default constructor
    public Order() {
        orderDetails = new ArrayList<>();
    }
    
    // Constructor with basic fields
    public Order(String orderId, String customerId, String customerName, Timestamp orderDate, 
                int itemCount, double totalAmount, String status) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.orderDate = orderDate;
        this.itemCount = itemCount;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDetails = new ArrayList<>();
    }
    
    // Full constructor
    public Order(String orderId, String customerId, String customerName, Timestamp orderDate, 
                int itemCount, double totalAmount, String status, double discountAmountOrder, 
                double payAmount, String orderStatusId, String addressId, String discountId) {
        this(orderId, customerId, customerName, orderDate, itemCount, totalAmount, status);
        this.discountAmountOrder = discountAmountOrder;
        this.payAmount = payAmount;
        this.orderStatusId = orderStatusId;
        this.addressId = addressId;
        this.discountId = discountId;
    }

    // Getters and Setters
    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public int getItemCount() {
        return itemCount;
    }

    public void setItemCount(int itemCount) {
        this.itemCount = itemCount;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getDiscountAmountOrder() {
        return discountAmountOrder;
    }

    public void setDiscountAmountOrder(double discountAmountOrder) {
        this.discountAmountOrder = discountAmountOrder;
    }

    public double getPayAmount() {
        return payAmount;
    }

    public void setPayAmount(double payAmount) {
        this.payAmount = payAmount;
    }

    public String getOrderStatusId() {
        return orderStatusId;
    }

    public void setOrderStatusId(String orderStatusId) {
        this.orderStatusId = orderStatusId;
    }

    public String getAddressId() {
        return addressId;
    }

    public void setAddressId(String addressId) {
        this.addressId = addressId;
    }

    public String getDiscountId() {
        return discountId;
    }

    public void setDiscountId(String discountId) {
        this.discountId = discountId;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    // Method to add order detail
    public void addOrderDetail(OrderDetail detail) {
        if (this.orderDetails == null) {
            this.orderDetails = new ArrayList<>();
        }
        this.orderDetails.add(detail);
    }

    // Method to calculate total amount
    public void calculateTotalAmount() {
        this.totalAmount = 0;
        this.itemCount = 0;
        if (this.orderDetails != null) {
            for (OrderDetail detail : orderDetails) {
                this.totalAmount += detail.getTotalAmountProduct();
                this.itemCount += detail.getQuantity();
            }
        }
        // Apply discount if exists
        if (this.discountAmountOrder > 0) {
            this.payAmount = this.totalAmount - this.discountAmountOrder;
        } else {
            this.payAmount = this.totalAmount;
        }
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId='" + orderId + '\'' +
                ", customerId='" + customerId + '\'' +
                ", customerName='" + customerName + '\'' +
                ", orderDate=" + orderDate +
                ", itemCount=" + itemCount +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                '}';
    }
}