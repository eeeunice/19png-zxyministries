package domain;

public class Address {
    private String addressId;
    private String customerId;
    private String street;
    private String postcode;
    private String city;
    private String state;
    private String country;

    public Address(String addressId, String customerId, String street, String postcode, String city, String state,
            String country) {
        this.addressId = addressId;
        this.customerId = customerId;
        this.street = street;
        this.postcode = postcode;
        this.city = city;
        this.state = state;
        this.country = country;
    }

    // Getters
    public String getAddressId() {
        return addressId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public String getStreet() {
        return street;
    }

    public String getPostcode() {
        return postcode;
    }

    public String getCity() {
        return city;
    }

    public String getState() {
        return state;
    }

    public String getCountry() {
        return country;
    }

    // Setters
    public void setAddressId(String addressId) {
        this.addressId = addressId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setCountry(String country) {
        this.country = country;
    }
}